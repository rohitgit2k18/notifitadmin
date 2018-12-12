using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Products;

namespace AbleCommerce
{
    public partial class ProductImages : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                this.Page.Title = "Images of " + product.Name;
                this.GalleryCaption.Text = string.Format(this.GalleryCaption.Text, product.Name);
                ProductImageRepeater.DataSource = product.Images;
                ProductImageRepeater.DataBind();
            }
        }

        protected string GetSafeUrl(string url)
        {
            return this.Page.ResolveUrl(url);
        }
    }
}