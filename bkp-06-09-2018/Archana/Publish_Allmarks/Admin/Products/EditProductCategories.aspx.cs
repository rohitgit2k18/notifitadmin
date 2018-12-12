namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class EditProductCategories : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _ProductId = 0;
        private Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            if (!Page.IsPostBack)
            {
                Caption.Text = string.Format(Caption.Text, _Product.Name);
                CategoryTree.SelectedCategories = _Product.Categories.ToArray();
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (CategoryTree.SelectedCategories.Length > 0)
                {
                    //UPDATE CATEGORIES
                    _Product.Categories.Clear();
                    _Product.Categories.AddRange(CategoryTree.SelectedCategories);
                    _Product.Categories.Save();
                    _Product.RecalculateOrderBy();
                    _Product.Save();
                    SuccessMessage.Text = string.Format("Product categories updated at {0}", LocaleHelper.LocalNow);
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