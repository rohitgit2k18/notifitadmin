namespace AbleCommerce.Admin.Catalog
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;
    using CommerceBuilder.Common;

    public partial class ChangeVisibility : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        int _CategoryId = 0;
        List<ICatalogable> _CatalogItems = new List<ICatalogable>();
        IList<Category> _Categories;
        IList<Product> _Products;
        IList<Link> _Links;
        IList<Webpage> _Webpages;
        String _IconPath = String.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryId = AlwaysConvert.ToInt(Request.QueryString["CategoryId"]);
            InitializeCatalogItems();

            // INITIALIZE ICON PATH
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);

            CGrid.DataSource = _CatalogItems;
            CGrid.DataBind();

            if (!Page.IsPostBack)
            {
                // Caption.Text = string.Format(Caption.Text, CatalogNode.Name);

                // SET THE CURRENT PATH
                IList<CatalogPathNode> currentPath = CatalogDataSource.GetPath(_CategoryId, false);
                CurrentPath.DataSource = currentPath;
                CurrentPath.DataBind();
            }           
        }

        protected void InitializeCatalogItems()
        {
            String items = Request.QueryString["Objects"];
            if (String.IsNullOrEmpty(items)) return;
            String[] itemsArray = items.Split(',');
            List<String> categoryIds = new List<String>();
            List<String> productIds = new List<String>();
            List<String> linkIds = new List<String>();
            List<String> webpageIds = new List<String>();

            // Sort out items in saperate lists
            foreach (String item in itemsArray)
            {
                String[] itemValues = item.Split(':');
                int catalogNodeId = AlwaysConvert.ToInt(itemValues[0]);
                CatalogNodeType catalogNodeType = (CatalogNodeType)AlwaysConvert.ToByte(itemValues[1]);
                switch (catalogNodeType)
                {
                    case CatalogNodeType.Category:
                        categoryIds.Add(catalogNodeId.ToString());
                        break;
                    case CatalogNodeType.Product:
                        productIds.Add(catalogNodeId.ToString());
                        break;
                    case CatalogNodeType.Link:
                        linkIds.Add(catalogNodeId.ToString());
                        break;
                    case CatalogNodeType.Webpage:
                        webpageIds.Add(catalogNodeId.ToString());
                        break;
                }
            }

            trIncludeContents.Visible = (categoryIds.Count > 0);
            if (categoryIds.Count > 0)
            {
                ICriteria criteria = CommerceBuilder.DomainModel.NHibernateHelper.CreateCriteria<Category>();
                criteria.Add(Restrictions.In("Id", categoryIds.ToArray()));
                _Categories = CategoryDataSource.LoadForCriteria(criteria);
                if (_Categories != null && _Categories.Count > 0)
                {
                    foreach (Category category in _Categories)
                    {
                        _CatalogItems.Add(category);
                    }
                }
            }

            if (productIds.Count > 0)
            {
                ICriteria criteria = CommerceBuilder.DomainModel.NHibernateHelper.CreateCriteria<Product>();
                criteria.Add(Restrictions.In("Id", productIds.ToArray()));
                _Products = ProductDataSource.LoadForCriteria(criteria);
                if (_Products != null && _Products.Count > 0)
                {
                    foreach (Product product in _Products)
                    {
                        _CatalogItems.Add(product);
                    }
                }
            }

            if (linkIds.Count > 0)
            {
                ICriteria criteria = CommerceBuilder.DomainModel.NHibernateHelper.CreateCriteria<Link>();
                criteria.Add(Restrictions.In("Id", linkIds.ToArray()));
                _Links = LinkDataSource.LoadForCriteria(criteria);
                if (_Links != null && _Links.Count > 0)
                {
                    foreach (Link link in _Links)
                    {
                        _CatalogItems.Add(link);
                    }
                }
            }

            if (webpageIds.Count > 0)
            {
                ICriteria criteria = CommerceBuilder.DomainModel.NHibernateHelper.CreateCriteria<Webpage>();
                criteria.Add(Restrictions.In("Id", webpageIds.ToArray()));
                _Webpages = WebpageDataSource.LoadForCriteria(criteria);
                if (_Webpages != null && _Webpages.Count > 0)
                {
                    foreach (Webpage webpage in _Webpages)
                    {
                        _CatalogItems.Add(webpage);
                    }
                }
            }

            if (!Page.IsPostBack)
            {
                if (_CatalogItems.Count == 1)
                {
                    ICatalogable catalogable = _CatalogItems[0];
                    switch (catalogable.Visibility)
                    {
                        case CatalogVisibility.Public:
                            VisPublic.Checked = true;
                            break;

                        case CatalogVisibility.Private:
                            VisPrivate.Checked = true;
                            break;

                        case CatalogVisibility.Hidden:
                            VisHidden.Checked = true;
                            break;

                        default:
                            VisPrivate.Checked = true;
                            break;
                    }
                }
                else if (_CatalogItems.Count > 1)
                {
                    VisPrivate.Checked = false;
                    VisPublic.Checked = false;
                    VisHidden.Checked = false;
                }
            }
        }

        protected string GetCatalogIconUrl(object dataItem)
        {
            ICatalogable catalogItem = ((ICatalogable)dataItem);
            Type itemType = catalogItem.GetType();

            if (itemType == typeof(Category)) return _IconPath + "Category.gif";
            else if (itemType == typeof(Product)) return _IconPath + "Product.gif";
            else if (itemType == typeof(Webpage)) return _IconPath + "Webpage.gif";
            else if (itemType == typeof(Link)) return _IconPath + "Link.gif";

            return string.Empty;
        }
        protected string GetNavigateUrl(object dataItem)
        {

            ICatalogable catalogItem = ((ICatalogable)dataItem);
            Type itemType = catalogItem.GetType();

            if (itemType == typeof(Category)) return "~/Admin/Catalog/Browse.aspx?CategoryId=" + ((Category)catalogItem).Id;
            else if (itemType == typeof(Product)) return "~/Admin/Products/EditProduct.aspx?ProductId=" + ((Product)catalogItem).Id;
            else if (itemType == typeof(Webpage)) return "~/Admin/Catalog/EditWebpage.aspx?WebpageId=" + ((Webpage)catalogItem).Id;
            else if (itemType == typeof(Link)) return "~/Admin/Catalog/EditLink.aspx?LinkId=" + ((Link)catalogItem).Id;

            return string.Empty;
        }

        protected string GetVisibilityIconUrl(object dataItem)
        {
            return _IconPath + "Cms" + (((ICatalogable)dataItem).Visibility) + ".gif";
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Browse.aspx?CategoryId=" + _CategoryId.ToString());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            CatalogVisibility visibility = CatalogVisibility.Public;
            if (VisPublic.Checked) visibility = CatalogVisibility.Public;
            else if (VisHidden.Checked) visibility = CatalogVisibility.Hidden;
            else visibility = CatalogVisibility.Private;

            foreach (ICatalogable catalogItem in _CatalogItems)
            {
                if (catalogItem is Category)
                {
                    Category item = (Category)catalogItem;
                    item.Visibility = visibility;
                    item.Save();
                    //CHECK IF WE SHOULD RECURSE
                    if (Scope.SelectedValue == "1")
                        UpdateChildNodes(item.Id, visibility);
                }
                else if (catalogItem is Product)
                {
                    Product item = (Product)catalogItem;
                    item.Visibility = visibility;
                    item.Save();
                }
                else if (catalogItem is Webpage)
                {
                    Webpage item = (Webpage)catalogItem;
                    item.Visibility = visibility;
                    item.Save();
                }
                else if (catalogItem is Link)
                {
                    Link item = (Link)catalogItem;
                    item.Visibility = visibility;
                    item.Save();
                }
            }

            //RETURN TO BROWSE MODE
            Response.Redirect("Browse.aspx?CategoryId=" + _CategoryId.ToString());
        }

        private void UpdateChildNodes(int categoryId, CatalogVisibility visibility)
        {
            IList<CatalogNode> children = CatalogDataSource.LoadForCategory(categoryId, false);
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            foreach (CatalogNode child in children)
            {
                child.Visibility = visibility;
                child.ChildObject.Visibility = visibility;
                child.Save(true);
                if (child.CatalogNodeType == CatalogNodeType.Category)
                    UpdateChildNodes(child.CatalogNodeId, visibility);
            }
            database.CommitTransaction();
        }
    }
}