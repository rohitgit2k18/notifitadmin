using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Products;
using CommerceBuilder.Common;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile
{
    public partial class ReviewTerms : CommerceBuilder.UI.AbleCommercePage
    {
        Product _product = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            _product = ProductDataSource.Load(AbleCommerce.Code.PageHelper.GetProductId());
            if (_product == null)
            {
                Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Default.aspx"));
                return;
            }
            //ProductName.Text = _product.Name;
            reviewTermsText.Text = AbleContext.Current.Store.Settings.ProductReviewTermsAndConditions;            
            BackToReviewsLink.HRef = Page.ResolveClientUrl(NavigationHelper.GetMobileStoreUrl(string.Format("~/ProductReviews.aspx?ProductId={0}", _product.Id)));
        }
    }
}