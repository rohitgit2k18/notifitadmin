using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Services.Checkout;
using CommerceBuilder.Taxes;
using CommerceBuilder.Taxes.Providers.TaxCloud;
using CommerceBuilder.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AbleCommerce
{
    public partial class TaxCloudSelectCert : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string certID = Request["certificateID"];
 	
 	        Session[TaxCloudProvider.TaxCloudSelectedCertSessionKey] = certID;
            Session[TaxCloudProvider.TaxcloudSinglePurchaseCertSessionKey] = null;

            // recalculate the current user basket
            Basket basket = AbleContext.Current.User.Basket;
            basket.ContentHash = string.Empty;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);

        }
    }
}