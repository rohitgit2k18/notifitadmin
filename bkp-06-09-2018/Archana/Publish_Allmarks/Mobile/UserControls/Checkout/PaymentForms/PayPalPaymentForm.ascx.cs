namespace AbleCommerce.Mobile.UserControls.Checkout.PaymentForms
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.UI;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services.Checkout;

    public partial class PayPalPaymentForm : System.Web.UI.UserControl
    {
        // DEFINE EVENTS TO TRIGGER FOR CHECKOUT
        public event CheckingOutEventHandler CheckingOut;
        public event CheckedOutEventHandler CheckedOut;

        private string _ValidationGroup = "PayPalPayment";
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        public decimal PaymentAmount { get; set; }

        public int PaymentMethodId { get; set; }

        protected void Page_Init(object sender, EventArgs e)
        {
            UpdateValidationOptions();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            PaymentMethod method = PaymentMethodDataSource.Load(this.PaymentMethodId);
            if (method != null)
            {
                PayPalButton.ImageUrl = Request.Url.Scheme + "://www.paypal.com/en_US/i/btn/x-click-but1.gif";
                PayPalButton.OnClientClick = "if (Page_ClientValidate('" + this.ValidationGroup + "')) { this.onclick=function(){return false;};}";
            }
            else
            {
                this.Controls.Clear();
            }
        }

        private Payment GetPayment()
        {
            Payment payment = new Payment();
            payment.PaymentMethod = PaymentMethodDataSource.Load(this.PaymentMethodId);
            if (this.PaymentAmount > 0) payment.Amount = this.PaymentAmount;
            else payment.Amount = AbleContext.Current.User.Basket.Items.TotalPrice();
            return payment;
        }

        private void UpdateValidationOptions()
        {
            PayPalButton.ValidationGroup = _ValidationGroup;
        }

        protected void PayPalButton_Click(object sender, EventArgs e)
        {
            // CREATE THE PAYMENT OBJECT
            Payment payment = GetPayment();

            // PROCESS CHECKING OUT EVENT
            bool checkOut = true;
            if (CheckingOut != null)
            {
                CheckingOutEventArgs c = new CheckingOutEventArgs(payment);
                CheckingOut(this, c);
                checkOut = !c.Cancel;
            }
            if (checkOut)
            {
                // CONTINUE TO PROCESS THE CHECKOUT
                Basket basket = AbleContext.Current.User.Basket;
                ICheckoutService checkoutService = AbleContext.Resolve<ICheckoutService>();
                CheckoutRequest checkoutRequest = new CheckoutRequest(basket, payment);
                CheckoutResponse checkoutResponse = checkoutService.ExecuteCheckout(checkoutRequest);
                if (checkoutResponse.Success)
                {
                    if (CheckedOut != null) CheckedOut(this, new CheckedOutEventArgs(checkoutResponse));
                    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetReceiptUrl(checkoutResponse.Order.OrderNumber));
                }
                else
                {
                    IList<string> warningMessages = checkoutResponse.WarningMessages;
                    if (warningMessages.Count == 0)
                        warningMessages.Add("The order could not be submitted at this time.  Please try again later or contact us for assistance.");
                    if (CheckedOut != null) CheckedOut(this, new CheckedOutEventArgs(checkoutResponse));
                }
            }
        }
    }
}