namespace AbleCommerce.Admin.Catalog
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Utility;

    public partial class EditLinkCategories : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _LinkId = 0;
        private Link _Link;

        protected void Page_Load(object sender, EventArgs e)
        {
            _LinkId = AbleCommerce.Code.PageHelper.GetLinkId();
            _Link = LinkDataSource.Load(_LinkId);
            if (!Page.IsPostBack)
            {
                Caption.Text = string.Format(Caption.Text, _Link.Name);
                CategoryTree.SelectedCategories = _Link.Categories.ToArray();
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (CategoryTree.SelectedCategories.Length > 0)
                {
                    // UPDATE CATEGORIES
                    _Link.Categories.Clear();
                    _Link.Categories.AddRange(CategoryTree.SelectedCategories);
                    _Link.Categories.Save();
                    SuccessMessage.Text = string.Format("Link categories updated at {0}", LocaleHelper.LocalNow);
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