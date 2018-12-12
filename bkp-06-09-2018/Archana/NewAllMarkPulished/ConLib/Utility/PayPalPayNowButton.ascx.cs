namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.ComponentModel;
    using System.Web.UI;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers.PayPal;
    using CommerceBuilder.Utility;

    [Description("Builds the paypal PayNow button")]    
    public partial class PayPalPayNowButton : System.Web.UI.UserControl
    {
        private bool _AutoClick = true;

        [Browsable(true), DefaultValue(true)]
        [Description("Indicates wheather to auto click the pay now button if page view is with in the 10 secs of order palcement, and redirect to Paypal website .")]
        public bool AutoClick
        {
            get { return _AutoClick; }
            set { _AutoClick = value; }
        }

        public Payment Payment { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Payment != null && (this.Payment.PaymentStatus == PaymentStatus.Unprocessed || this.Payment.PaymentStatus == PaymentStatus.AuthorizationPending))
            {
                PaymentMethod method = this.Payment.PaymentMethod;
                if (method != null && method.PaymentInstrumentType == PaymentInstrumentType.PayPal)
                {
                    PaymentGateway gateway = CommerceBuilder.Payments.Providers.PayPal.PayPalProvider.GetPayPalPaymentGateway(true);
                    if (gateway != null)
                    {
                        PayPalProvider provider = (PayPalProvider)gateway.GetInstance();
                        Control payNowButton = provider.GetPayNowButton(this.Payment.Order, this.Payment.Id);
                        if (payNowButton != null)
                        {
                            phPayNow.Controls.Add(payNowButton);

                            // IF AUTO CLICK IS ENABLED AND PAGE VIEW IS WITHIN 10 SECONDS PERIOD AFTER ORDER PLACEMENT
                            if (AutoClick)
                            {
                                if (this.Payment.Order.OrderDate.AddSeconds(10) >= LocaleHelper.LocalNow)
                                    ((PayNowButton)payNowButton).AutoClick();
                            }
                        }
                    }
                }
            }
        }
    }
}