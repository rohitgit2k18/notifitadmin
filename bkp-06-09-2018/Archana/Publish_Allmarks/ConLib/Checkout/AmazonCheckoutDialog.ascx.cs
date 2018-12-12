namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Stores;

    [Description("Displays amazon checkout dialog")]
    public partial class AmazonCheckoutDialog : System.Web.UI.UserControl
    {
        protected void Page_PreRender(object sender, EventArgs e)
        {
            bool hasSubscriptions = BasketHelper.HasRecurringSubscriptions(AbleContext.Current.User.Basket);
            bool newSubFeatureEnabled = AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled;            

            AmazonCheckoutWidget.Visible = AbleContext.Current.User.Basket.Items.Count > 0
                && (!hasSubscriptions || !newSubFeatureEnabled)
                && HasAmazonGateway();
        }

        private bool HasAmazonGateway()
        {
            Store store = AbleContext.Current.Store;
            IList<PaymentGateway> gatewayList = store.PaymentGateways;
            foreach (PaymentGateway gateway in gatewayList)
            {
                if (gateway.ClassId.EndsWith("CommerceBuilder.Amazon"))
                {
                    return gateway.GetInstance() != null;
                }
            }
            return false;
        }
    }
}