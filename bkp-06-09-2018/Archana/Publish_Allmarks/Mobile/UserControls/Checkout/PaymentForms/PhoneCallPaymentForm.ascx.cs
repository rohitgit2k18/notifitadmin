namespace AbleCommerce.Mobile.UserControls.Checkout.PaymentForms
{
    using System;
    using System.Collections.Generic;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services.Checkout;

    public partial class PhoneCallPaymentForm : System.Web.UI.UserControl
    {
        //DEFINE EVENTS TO TRIGGER FOR CHECKOUT
        public event CheckingOutEventHandler CheckingOut;
        public event CheckedOutEventHandler CheckedOut;

        private string _ValidationGroup = "PhoneCall";
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
                PhoneCallButton.Text = string.Format(PhoneCallButton.Text, method.Name);
                PhoneCallButton.OnClientClick = "if (Page_ClientValidate('" + this.ValidationGroup + "')) { this.value='Processing...';this.onclick=function(){return false;}; }";
            }
            else
            {
                this.Controls.Clear();
            }
        }

        private void UpdateValidationOptions()
        {
            PhoneCallButton.ValidationGroup = _ValidationGroup;
        }

        private Payment GetPayment()
        {
            Payment payment = new Payment();
            payment.PaymentMethod = PaymentMethodDataSource.Load(this.PaymentMethodId);
            if (this.PaymentAmount > 0) payment.Amount = this.PaymentAmount;
            else payment.Amount = AbleContext.Current.User.Basket.Items.TotalPrice();
            return payment;
        }

        protected void PhoneCallButton_Click(object sender, EventArgs e)
        {
            // CREATE THE PAYMENT OBJECT
            Payment payment = GetPayment();
            payment.ReferenceNumber = AbleContext.Current.User.PrimaryAddress.Phone;

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