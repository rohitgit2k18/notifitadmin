namespace AbleCommerce
{
    using System;
    using System.Web.UI;
    using AbleCommerce.Code;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;
    using System.Text;
    using CommerceBuilder.Stores;
    using System.Collections.Generic;
    using System.Linq;
    using CommerceBuilder.DomainModel;
    
    public partial class ProductPage : CommerceBuilder.UI.AbleCommercePage
    {
        Product _product = null;
        Webpage _webpage = null;
        
        protected void Page_PreInit(object sender, EventArgs e)
        {            
            int productId = PageHelper.GetProductId();
            _product = ProductDataSource.Load(productId);

            if (_product != null)
            {
                // DELAYED QUERIES TO EAGER LOAD RELATED DATA FOR PERFORMANCE BOOST.
                var futureQuery = NHibernateHelper.QueryOver<Product>()
                        .Where(p => p.Id == productId)
                        .Fetch(p => p.ProductKitComponents).Eager
                        .Future<Product>();

                NHibernateHelper.QueryOver<Product>()
                    .Where(p => p.Id == productId)
                    .Fetch(p => p.ProductOptions).Eager
                    .Future<Product>();

                NHibernateHelper.QueryOver<Product>()
                    .Where(p => p.Id == productId)
                    .Fetch(p => p.ProductTemplates).Eager
                    .Future<Product>();

                NHibernateHelper.QueryOver<Product>()
                    .Where(p => p.Id == productId)
                    .Fetch(p => p.Specials).Eager
                    .Future<Product>();

                if (_product.IsKit)
                {
                    NHibernateHelper.QueryOver<KitComponent>()
                        .Fetch(kc => kc.KitProducts).Eager
                        .JoinQueryOver<ProductKitComponent>(kc => kc.ProductKitComponents)
                        .Where(pkc => pkc.ProductId == productId)
                        .Future<KitComponent>();

                    NHibernateHelper.QueryOver<KitProduct>()
                        .Fetch(kp => kp.Product).Eager
                        .Fetch(kp => kp.Product.Specials).Eager
                        .JoinQueryOver<KitComponent>(kp => kp.KitComponent)
                        .JoinQueryOver<ProductKitComponent>(kc => kc.ProductKitComponents)
                        .Where(pkc => pkc.ProductId == productId)
                        .Future<KitProduct>();
                }

                // TRIGGER QUEUED FUTURE QUERIES
                futureQuery.ToList<Product>();

                if ((_product.Visibility == CatalogVisibility.Private) &&
                    (!AbleContext.Current.User.IsInRole(Role.CatalogAdminRoles)))
                {
                    Response.Redirect(NavigationHelper.GetHomeUrl());
                }

                var user = AbleContext.Current.User;
                if (!user.IsAdmin)
                {
                    if (_product.EnableGroups)
                    {
                        List<int> groups = (from ug in AbleContext.Current.User.UserGroups select ug.GroupId).ToList<int>();
                        if (groups.Count > 0)
                        {
                            bool isInGroup = _product.ProductGroups.Any<ProductGroup>(pg => groups.Contains(pg.Group.Id));
                            if (!isInGroup)
                            {
                                Response.Redirect(NavigationHelper.GetHomeUrl());
                            }
                        }
                        else
                        {
                            Response.Redirect(NavigationHelper.GetHomeUrl());
                        }
                    }
                }
            }
            else NavigationHelper.Trigger404(Response, "Invalid Product");

            // INITIALIZE TO DEFAULT LAYOUT
            string layout = AbleContext.Current.Store.Settings.ProductsDefaultLayout;
            _webpage = _product.Webpage;
            if (_webpage == null) _webpage = WebpageDataSource.Load(AbleContext.Current.Store.Settings.ProductWebpageId);
            if (_webpage != null)
            {
                // CHECK FOR LAYOUT OVERRIDE
                if (_webpage.Layout != null) layout = _webpage.Layout.FilePath;

                // CHECK FOR THEME OVERRIDE
                if (!string.IsNullOrEmpty(_webpage.Theme) && CommerceBuilder.UI.Theme.Exists(_webpage.Theme))
                {
                    this.Theme = _webpage.Theme;
                }
            }

            // SET THE LAYOUT
            if (!string.IsNullOrEmpty(layout)) this.MasterPageFile = layout;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // REGISTER THE PAGEVISIT
            AbleCommerce.Code.PageVisitHelper.RegisterPageVisit(_product.Id, CatalogNodeType.Product, _product.Name);
            AbleCommerce.Code.PageHelper.BindMetaTags(this, _product);
            Page.Title = string.IsNullOrEmpty(_product.Title) ? _product.Name : _product.Title;
            if (_webpage != null)
            {
                PageContents.Value = _webpage.Description;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Store store = AbleContext.Current.Store;
            if (!string.IsNullOrEmpty(_product.GTIN))
            {
                string gtinType = string.Empty;
                switch(_product.GTIN.Length)
                {
                    case 8:
                        gtinType = "gtin8";
                        break;

                    case 13:
                        gtinType = "gtin13";
                        break;

                    case 14:
                        gtinType = "gtin14";
                        break;

                    default:
                        gtinType = "gtin13";
                        break;
                }

                PHRichSnippets.Controls.Add(new LiteralControl(string.Format("<meta itemprop='{0}' content='{1}' />", gtinType, _product.GTIN)));
            }

            if(!string.IsNullOrEmpty(_product.Color))
                PHRichSnippets.Controls.Add(new LiteralControl(string.Format("<meta itemprop='color' content='{0}' />", _product.Color)));

            string url = _product.NavigateUrl;
            if (url.StartsWith("~/"))
            {
                url = store.StoreUrl + url.Substring(2);
            }
            else
            {
                url = store.StoreUrl + url;
            }

            PHRichSnippets.Controls.Add(new LiteralControl(string.Format("<meta itemprop='url' content='{0}' />", url)));
        }
    }
}