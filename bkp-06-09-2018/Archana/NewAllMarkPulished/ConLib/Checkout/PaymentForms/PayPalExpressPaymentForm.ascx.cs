namespace AbleCommerce.ConLib.Checkout.PaymentForms
{
    using System;
    using System.ComponentModel;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments.Providers.PayPal;

    [Description("Payment form for paypay express checkout payment")]
    public partial class PayPalExpressPaymentForm : System.Web.UI.UserControl
    {
        private string _ValidationGroup = "PayPalExpressPayment";

        [Browsable(true), DefaultValue("PayPalPayment")]
        [Description("Gets or sets the validation group for this control and all child controls.")]
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            UpdateValidationOptions();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool hasSubscriptions = BasketHelper.HasRecurringSubscriptions(AbleContext.Current.User.Basket);
            bool newSubFeatureEnabled = AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled;
            if (!hasSubscriptions || !newSubFeatureEnabled)            
            {
                ExpressCheckoutSession paypalSession = ExpressCheckoutSession.Current;
                if (paypalSession != null)
                {
                    PayPalAccount.Text = paypalSession.Payer;
                    PayPalButton.ImageUrl = string.Format(PayPalButton.ImageUrl, Request.Url.Scheme);
                }
                else
                {
                    this.Controls.Clear();
                }
            }
            else 
            {
                this.Controls.Clear();
            }
        }

        private void UpdateValidationOptions()
        {
            PayPalButton.ValidationGroup = _ValidationGroup;
        }


        protected void PayPalButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/PayPalExpressCheckout.aspx?Action=DO");
        }
    }
}