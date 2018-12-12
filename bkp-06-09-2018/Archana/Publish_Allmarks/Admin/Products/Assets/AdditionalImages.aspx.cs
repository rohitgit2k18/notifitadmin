namespace AbleCommerce.Admin.Products.Assets
{
    using System;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class AdditionalImages : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _ProductId;
        private Product _Product;

        protected void Page_Init(object sender, EventArgs e)
        {
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            Caption.Text = string.Format(Caption.Text, _Product.Name);
            CancelButton.NavigateUrl += _ProductId;
            CancelButton2.NavigateUrl += _ProductId;
            BindImages();
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("UploadAdditionalImage.aspx?ProductId=" + _ProductId.ToString());
        }

        protected void BasicButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Images.aspx?ProductId=" + _ProductId.ToString());
        }

        protected void AdvancedButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdvancedImages.aspx?ProductId=" + _ProductId.ToString());
        }

        protected void AdditionalImagesRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                int productImageId = AlwaysConvert.ToInt(e.CommandArgument);
                int index = _Product.Images.IndexOf(productImageId);
                if (index > -1) _Product.Images.DeleteAt(index);
                BindImages();
            }
        }

        private void BindImages()
        {
            AdditionalImagesRepeater.DataSource = _Product.Images;
            AdditionalImagesRepeater.DataBind();
            ImagesPanel.Visible = AdditionalImagesRepeater.Items.Count > 0;
            NoImagesPanel.Visible = !ImagesPanel.Visible;
        }

        protected String GetImageUrl(object dataItem)
        {
            ProductImage image = (ProductImage)dataItem;
            string url = image.ImageUrl;
            if (!string.IsNullOrEmpty(url))
            {
                if (!url.Contains("?")) return url + "?ts=" + DateTime.Now.ToString("hhmmss");
                else return url + "&ts=" + DateTime.Now.ToString("hhmmss");
            }
            else return string.Empty;
        }
    }
}