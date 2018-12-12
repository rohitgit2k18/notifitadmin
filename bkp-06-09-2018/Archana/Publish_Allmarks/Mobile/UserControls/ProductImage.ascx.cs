namespace AbleCommerce.Mobile.UserControls
{
    using System;
    using System.Data;
    using System.Configuration;
    using System.Collections;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Common;
    using System.Collections.Generic;
    using System.Linq;
    using AbleCommerce.Code;

    public partial class ProductImageControl : System.Web.UI.UserControl
    {
        //CAN BE ICON, THUMBNAIL, OR IMAGE
        private string _ShowImage = "Thumbnail";

        int _ProductId;
        Product _Product;
        [Personalizable(), WebBrowsable()]
        public Product Product
        {
            get
            {
                if (_Product == null)
                {
                    // IF NOT SPECIFIED THEN CHECK QUERY STRING.
                    _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
                    _Product = ProductDataSource.Load(_ProductId);
                }
                return _Product;
            }
            set { _Product = value; }
        }

        [Personalizable(), WebBrowsable()]
        public string ShowImage
        {
            get { return _ShowImage; }
            set { _ShowImage = value; }
        }

        public string ThumbnailsCaption { get; set; }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (Product != null)
            {
                MoreImagesPanel.Visible = Product.Images.Count > 0;
                MoreImages.NavigateUrl = NavigationHelper.GetMobileStoreUrl(string.Format("~/ProductImages.aspx?ProductId={0}", Product.Id));
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Product != null)
            {
                string checkImage = this.ShowImage.ToLowerInvariant();
                string calculatedImageUrl = string.Empty;
                string imageAltText = string.Empty;
                string optionList = Request.QueryString["Options"];

                ProductVariant variant = null;
                if (!string.IsNullOrEmpty(optionList))
                {
                    variant = ProductVariantDataSource.LoadForOptionList(Product.Id, optionList);
                }

                if (checkImage == "icon")
                {
                    if (variant != null && !string.IsNullOrEmpty(variant.IconUrl))
                    {
                        calculatedImageUrl = variant.IconUrl;
                        imageAltText = Product.IconAltText;
                    }
                    else if (!string.IsNullOrEmpty(Product.IconUrl))
                    {
                        calculatedImageUrl = Product.IconUrl;
                        imageAltText = Product.IconAltText;
                    }
                    else
                    {
                        NoIcon.Visible = true;
                    }
                }
                else if (checkImage == "thumbnail")
                {
                    if (variant != null && !string.IsNullOrEmpty(variant.ThumbnailUrl))
                    {
                        calculatedImageUrl = variant.ThumbnailUrl;
                        imageAltText = Product.ThumbnailAltText;
                    }
                    else if (!string.IsNullOrEmpty(Product.ThumbnailUrl))
                    {
                        calculatedImageUrl = Product.ThumbnailUrl;
                        imageAltText = Product.ThumbnailAltText;
                    }
                    else
                    {
                        NoThumbnail.Visible = true;
                    }
                }
                else
                {
                    if (variant != null && !string.IsNullOrEmpty(variant.ImageUrl))
                    {
                        calculatedImageUrl = variant.ImageUrl;
                        imageAltText = Product.ImageAltText;
                    }
                    else if (!string.IsNullOrEmpty(Product.ImageUrl))
                    {
                        calculatedImageUrl = Product.ImageUrl;
                        imageAltText = Product.ImageAltText;
                    }
                    else
                    {
                        NoImage.Visible = true;
                    }
                }
                if (!string.IsNullOrEmpty(calculatedImageUrl))
                {
                    this.ProductImage.ImageUrl = string.Format("~/GetImage.ashx?Path={0}&maintainAspectRatio=true&maxHeight={1}&maxWidth={1}", Server.UrlEncode(calculatedImageUrl), 300);
                    this.ProductImage.AlternateText = Server.HtmlEncode(imageAltText);

                }
                else this.ProductImage.Visible = false;
            }
        }
    }
}
