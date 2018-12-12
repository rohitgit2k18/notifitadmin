namespace AbleCommerce.Mobile.UserControls.Checkout.PaymentForms
{
    using System;
    using CommerceBuilder.Payments.Providers.PayPal;
    using AbleCommerce.Code;

    public partial class PayPalExpressPaymentForm : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
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

            ChangeLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/PayPalExpressCheckout.aspx?Action=CANCEL&ReturnURL=PAY");
        }

        protected void PayPalButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/PayPalExpressCheckout.aspx?Action=DO"));
        }
    }
}