namespace AbleCommerce.Layouts
{
    using System;
    using System.Data;
    using System.Configuration;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Users;
    using AbleCommerce.Code;
    using System.IO;
    
    public partial class AdminPanel : System.Web.UI.UserControl
    {
        enum PageType : byte
        {
            Category,
            Webpage,
            Product,
            None
        }

        PageType _pageType = PageType.None;

        protected void Page_Load(object sender, EventArgs e)
        {
            _pageType = GetPageType();
            if (AbleContext.Current.User.IsInRole(Role.WebsiteAdminRoles) && _pageType != PageType.None)
            {
                if (!Page.IsPostBack)
                {
                    DisplayPagePanel.Visible = _pageType == PageType.Product || _pageType == PageType.Category;
                    switch (_pageType)
                    {
                        case PageType.Product:
                            BindProduct();
                            break;

                        case PageType.Category:
                            BindCategory();
                            break;

                        case PageType.Webpage:
                            BindWebpage();
                            break;

                        default:
                            // DO NOTHING
                            break;
                    }
                }
            }
            else
            {
                this.Visible = false;
            }
        }

        private void BindWebpage()
        {
            Webpage webpage = WebpageDataSource.Load(PageHelper.GetWebpageId());
            EditItemLink.Text = webpage.Name;
            EditItemLink.NavigateUrl = Page.ResolveUrl(string.Format("~/Admin/Website/ContentPages/EditContentPage.aspx?WebpageId={0}", webpage.Id));
        }

        private void BindCategory()
        {
            DisplayPage.DataBind();
            Category category = CategoryDataSource.Load(PageHelper.GetCategoryId());
            int webpageId = category.Webpage != null ? category.Webpage.Id : 0;
            SelectItem(DisplayPage, webpageId.ToString());
            EditItemLink.Text = category.Name;
            EditItemLink.NavigateUrl = Page.ResolveUrl(string.Format("~/Admin/Catalog/EditCategory.aspx?CategoryId={0}", category.Id));
            MangeDisplayPagesLink.NavigateUrl = Page.ResolveUrl("~/Admin/Website/ContentPages/CategoryPages/Default.aspx");
        }

        private void BindProduct()
        {
            DisplayPage.DataBind();
            Product product = ProductDataSource.Load(PageHelper.GetProductId());
            SelectItem(DisplayPage, product.WebpageId.ToString());
            EditItemLink.Text = product.Name;
            EditItemLink.NavigateUrl = Page.ResolveUrl(string.Format("~/Admin/Products/EditProduct.aspx?ProductId={0}", product.Id));
            MangeDisplayPagesLink.NavigateUrl = Page.ResolveUrl("~/Admin/Website/ContentPages/ProductPages/Default.aspx");
        }

        private void SelectItem(DropDownList list, string value)
        {
            ListItem item = list.Items.FindByValue(value);
            if (item != null)
                item.Selected = true;
        }

        private PageType GetPageType() 
        {
            PageType pageType = PageType.None;
            string pageName = Path.GetFileName(Request.Url.AbsolutePath);
            switch (pageName.ToLower())
            { 
                case "product.aspx":
                    pageType = PageType.Product;
                    break;

                case "category.aspx":
                    pageType = PageType.Category;
                    break;

                case "webpage.aspx":
                    pageType = PageType.Webpage;
                    break;

                default:
                    pageType = PageType.None;
                    break;
            }

            return pageType;
        }

        protected void DisplayPageDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            WebpageType webpageType = WebpageType.ProductDisplay;
            switch(_pageType)
            {
                case PageType.Product:
                    webpageType = WebpageType.ProductDisplay;
                    break;

                case PageType.Category:
                    webpageType = WebpageType.CategoryDisplay;
                    break;
            }

            e.InputParameters["webpageType"] = webpageType;
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            if (_pageType == PageType.Product)
            {
                Product product = ProductDataSource.Load(PageHelper.GetProductId());
                product.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(DisplayPage.SelectedValue));
                product.Save();
                Response.Redirect(product.NavigateUrl);
            }
            else
                if (_pageType == PageType.Category)
                {
                    Category category = CategoryDataSource.Load(PageHelper.GetCategoryId());
                    category.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(DisplayPage.SelectedValue));
                    category.Save();
                    Response.Redirect(category.NavigateUrl);
                }
        }
    }
}