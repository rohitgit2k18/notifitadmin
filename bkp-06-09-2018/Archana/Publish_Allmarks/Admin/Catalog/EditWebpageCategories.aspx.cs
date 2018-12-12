namespace AbleCommerce.Admin.Catalog
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Utility;

    public partial class EditWebpageCategories : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _WebpageId = 0;
        private Webpage _Webpage;

        protected void Page_Load(object sender, EventArgs e)
        {
            _WebpageId = AbleCommerce.Code.PageHelper.GetWebpageId();
            _Webpage = WebpageDataSource.Load(_WebpageId);
            if (!Page.IsPostBack)
            {
                Caption.Text = string.Format(Caption.Text, _Webpage.Name);
                CategoryTree.SelectedCategories = _Webpage.Categories.ToArray();
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (CategoryTree.SelectedCategories.Length > 0)
                {
                    // UPDATE CATEGORIES
                    _Webpage.Categories.Clear();
                    _Webpage.Categories.AddRange(CategoryTree.SelectedCategories);
                    _Webpage.Categories.Save();
                    SuccessMessage.Text = string.Format("Webpage categories updated at {0}", LocaleHelper.LocalNow);
                    SuccessMessage.Visible = true;
                    FailureMessage.Visible = false;
                }
                else
                {
                    FailureMessage.Text = "You must select at least one category.";
                    FailureMessage.Visible = true;
                    SuccessMessage.Visible = false;
                }
            }
        }
    }
}