namespace AbleCommerce.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;

    // inherit from System.Web.UI.Page to prevent theme errors
    public partial class CvvHelp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IList<PaymentMethod> methods = AbleCommerce.Code.StoreDataHelper.GetPaymentMethods(AbleContext.Current.UserId);
            bool showAmex = methods.Where(method => method.PaymentInstrumentType == PaymentInstrumentType.AmericanExpress).Count() > 0;
            AmexPanel.Visible = showAmex;
        }
    }
}