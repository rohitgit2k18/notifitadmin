namespace AbleCommerce.Admin.Products.Assets
{
    using System;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class Images : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _ProductId;
        private Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            Caption.Text = string.Format(Caption.Text, _Product.Name);
            if (_Product.IconUrl.IsNotNullOrEmpty())
            {
                IconPreview.ImageUrl = _Product.IconUrl;
            }
            else
            {
                IconPreview.Visible = false;
                IconPreviewNoImage.Visible = true;
            }

            if (_Product.ThumbnailUrl.IsNotNullOrEmpty())
            {
                ThumbnailPreview.ImageUrl = _Product.ThumbnailUrl;
            }
            else
            {
                ThumbnailPreview.Visible = false;
                ThumbnailPreviewNoImage.Visible = true;
            }
            if (_Product.ImageUrl.IsNotNullOrEmpty())
            {
                ImagePreview.ImageUrl = _Product.ImageUrl;
            }
            else
            {
                ImagePreview.Visible = false;
                ImagePreviewNoImage.Visible = true;
            }

            UploadImageButton.NavigateUrl += _ProductId;
            AddExistingImageButton.NavigateUrl += _ProductId;
            AdvancedButton.NavigateUrl += _ProductId;
            AdditionalButton.NavigateUrl += _ProductId;
        }
    }
}