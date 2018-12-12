namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Reflection;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Stores;

    [Description("Builds the amazon checkout button")]
    public partial class AmazonCheckoutButton : System.Web.UI.UserControl
    {
        protected void Page_PreRender(object sender, EventArgs e)
        {
            bool hasSubscriptions = BasketHelper.HasRecurringSubscriptions(AbleContext.Current.User.Basket);
            bool newSubFeatureEnabled = AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled;
            if (!hasSubscriptions || !newSubFeatureEnabled)
            {
                IPaymentProvider amazonProvider = GetAmazonProvider();
                if (amazonProvider != null)
                {
                    MethodInfo buttonMethod = amazonProvider.GetType().GetMethod("GetCheckoutButton");
                    object[] parameters = new object[] { AbleContext.Current.User.Basket };
                    PlaceHolder checkoutButton = (PlaceHolder)buttonMethod.Invoke(amazonProvider, parameters);
                    this.ButtonPanel.Controls.Add(checkoutButton);
                }
            }
        }

        private IPaymentProvider GetAmazonProvider()
        {
            Store store = AbleContext.Current.Store;
            IList<PaymentGateway> gatewayList = store.PaymentGateways;
            foreach (PaymentGateway gateway in gatewayList)
            {
                if (gateway.ClassId.EndsWith("CommerceBuilder.Amazon"))
                {
                    return gateway.GetInstance();
                }
            }
            return null;
        }
    }
}