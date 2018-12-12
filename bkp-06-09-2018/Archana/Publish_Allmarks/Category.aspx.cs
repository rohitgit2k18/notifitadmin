namespace AbleCommerce
{
    using System;
    using System.Web.UI;
    using AbleCommerce.Code;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;

    public partial class _Category : CommerceBuilder.UI.AbleCommercePage
    {
        Category _category;
        Webpage _webpage;

        protected void Page_PreInIt()
        {
            _category = CategoryDataSource.Load(PageHelper.GetCategoryId());
            if (_category != null)
            {
                if ((_category.Visibility == CatalogVisibility.Private) &&
                    (!AbleContext.Current.User.IsInRole(Role.CatalogAdminRoles)))
                {
                    Response.Redirect(NavigationHelper.GetHomeUrl());
                }
            }
            else NavigationHelper.Trigger404(Response, "Invalid Category");

            // INITIALIZE TO DEFAULT LAYOUT
            string layout = AbleContext.Current.Store.Settings.CategoriesDefaultLayout;
            _webpage = _category.Webpage;
            if (_webpage == null) _webpage = WebpageDataSource.Load(AbleContext.Current.Store.Settings.CategoryWebpageId);
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
            AbleCommerce.Code.PageVisitHelper.RegisterPageVisit(_category.Id, CatalogNodeType.Category, _category.Name);
            AbleCommerce.Code.PageHelper.BindMetaTags(this, _category);
            Page.Title = string.IsNullOrEmpty(_category.Title) ? _category.Name : _category.Title;
            if (_webpage != null)
            {
                PageContents.Value = _webpage.Description;
            }
        }
    }
}