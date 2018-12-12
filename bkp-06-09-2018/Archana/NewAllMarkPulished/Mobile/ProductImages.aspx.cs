using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Products;
using CommerceBuilder.Utility;

namespace AbleCommerce.Mobile
{
    public partial class ProductImages : CommerceBuilder.UI.AbleCommercePage
    {
        private int _largeImageMaxDimension = 600;

        protected void Page_Init(object sender, EventArgs e)
        {
            if (Request.Browser.IsMobileDevice) _largeImageMaxDimension = 300;
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                this.Page.Title = "Images of " + product.Name;
                this.GalleryCaption.Text = string.Format(this.GalleryCaption.Text, product.Name);

                List<ProductImage> images = (from i in product.Images select i)
                    .ToList<ProductImage>();
                
                if (!string.IsNullOrEmpty(product.ImageUrl)) 
                    images.Insert(0, new ProductImage() { ImageUrl = product.ImageUrl, ImageAltText = product.ImageAltText });

                MoreImagesList.DataSource = images;
                MoreImagesList.DataBind();
            }
        }

        protected string GetLargeImageUrl(string url)
        {
            string resizedImageUrl = string.Format("~/GetImage.ashx?maintainAspectRatio=true&maxHeight={0}&maxWidth={1}&Path={2}", _largeImageMaxDimension, _largeImageMaxDimension, Server.UrlEncode(url));
            return this.Page.ResolveUrl(resizedImageUrl);
        }

        protected string GetThumbnailUrl(string url)
        {
            string thumbnailUrl = string.Format("~/GetImage.ashx?Path={0}&height={1}&width={1}", Server.UrlEncode(url), 50);
            return this.Page.ResolveUrl(thumbnailUrl);
        }
    }
}