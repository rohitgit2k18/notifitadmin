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
    public partial class TaxCloudSaveCert : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string exemptState = Request["ExemptState"];  
 	
 	        string singlePurchaseOrderNumber = Request["SinglePurchaseOrderNumber"];  
 	        string blanketPurchase = Request["BlanketPurchase"];  

 	        string purchaserFirstName = Request["PurchaserFirstName"];
 	        string purchaserLastName = Request["PurchaserLastName"];
 	        string purchaserAddress1 = Request["PurchaserAddress1"];
 	        string purchaserCity = Request["PurchaserCity"];
 	        string purchaserState = Request["PurchaserState"]; //
 	        string purchaserZip = Request["PurchaserZip"];
 	        string taxType = Request["TaxType"]; //
 	        string idNumber = Request["IDNumber"];
 	        string stateOfIssue = Request["StateOfIssue"]; //
 	        string countryOfIssue = Request["CountryOfIssue"]; //
 	        string purchaserBusinessType = Request["PurchaserBusinessType"]; //
            //	string purchaserBusinessTypeOtherValue = Request["PurchaserBusinessTypeOtherValue"];  //optional
 	        string purchaserExemptionReason = Request["PurchaserExemptionReason"]; //
 	        string purchaserExemptionReasonValue = Request["PurchaserExemptionReasonValue"];

            if (purchaserFirstName.Contains(" "))
            {
                string[] nameparts = purchaserFirstName.Split(' ');
                purchaserFirstName = nameparts[0];
                purchaserLastName = nameparts[1];
            }
 	
 	        if ( !isset(exemptState) || !isset(blanketPurchase) || !isset(purchaserFirstName) || !isset(purchaserAddress1) ||
 		        !isset(purchaserCity) || !isset(purchaserState) || !isset(purchaserZip) || !isset(taxType) || !isset(idNumber) ||
 		        !isset(stateOfIssue) || !isset(countryOfIssue) || !isset(purchaserBusinessType) || !isset(purchaserExemptionReason) || !isset(purchaserExemptionReasonValue) ) {
 			        return;
 	        } 
            else 
            {
                TaxGateway taxGateway = null;
                TaxCloudProvider taxProvider = null;
                int taxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(TaxCloudProvider)));
                if (taxGatewayId > 0) taxGateway = TaxGatewayDataSource.Load(taxGatewayId);
                if (taxGateway != null) taxProvider = taxGateway.GetProviderInstance() as TaxCloudProvider;

                if (taxProvider == null) return;

                taxProvider.SetExemptionCert(AbleContext.Current.User, exemptState, AlwaysConvert.ToBool(blanketPurchase, false), singlePurchaseOrderNumber, purchaserFirstName, purchaserLastName, purchaserAddress1, purchaserCity, purchaserState, purchaserZip, taxType, idNumber, stateOfIssue, countryOfIssue, purchaserBusinessType, purchaserExemptionReason, purchaserExemptionReasonValue);

                // recalculate the current user basket
                Basket basket = AbleContext.Current.User.Basket;
                basket.ContentHash = string.Empty;
                IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                preCheckoutService.Recalculate(basket);
 	        }
        }

        private bool isset(string field)
        {
            return !string.IsNullOrEmpty(field);
        }
    }
}