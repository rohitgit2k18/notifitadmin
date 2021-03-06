namespace AbleCommerce.Admin.Orders.Create
{
    using System;
    using System.Collections.Generic;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class MailPaymentForm : System.Web.UI.UserControl
    {
        private int _UserId;
        private User _User;
        Basket _Basket;

        //DEFINE EVENTS TO TRIGGER FOR CHECKOUT
        public event CheckingOutEventHandler CheckingOut;
        public event CheckedOutEventHandler CheckedOut;

        private int _PaymentMethodId;
        public int PaymentMethodId
        {
            get { return _PaymentMethodId; }
            set { _PaymentMethodId = value; }
        }

        private string _ValidationGroup = "MailFax";
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        private bool _ValidationSummaryVisible = false;
        public bool ValidationSummaryVisible
        {
            get { return _ValidationSummaryVisible; }
            set { _ValidationSummaryVisible = value; }
        }

        private decimal _PaymentAmount = 0;
        public decimal PaymentAmount
        {
            get { return _PaymentAmount; }
            set { _PaymentAmount = value; }
        }

        private void UpdateValidationOptions()
        {
            MailButton.ValidationGroup = _ValidationGroup;
            ValidationSummary1.ValidationGroup = _ValidationGroup;
            ValidationSummary1.Visible = _ValidationSummaryVisible;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // LOCATE THE USER THAT THE ORDER IS BEING PLACED FOR
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UID"]);
            _User = UserDataSource.Load(_UserId);
            if (_User == null) return;
            _Basket = _User.Basket;

            UpdateValidationOptions();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            PaymentMethod method = PaymentMethodDataSource.Load(this.PaymentMethodId);
            if (method != null)
            {
                Caption.Text = string.Format(Caption.Text, method.Name);
                MailButton.Text = string.Format(MailButton.Text, method.Name);
            }
            else
            {
                this.Controls.Clear();
                Trace.Write(this.GetType().ToString(), "Output suppressed, invalid payment method provided.");
            }
        }

        private Payment GetPayment()
        {
            Payment payment = new Payment();
            payment.PaymentMethodId = _PaymentMethodId;
            if (this.PaymentAmount > 0) payment.Amount = this.PaymentAmount;
            else payment.Amount = _Basket.Items.TotalPrice();
            return payment;
        }

        protected void MailButton_Click(object sender, EventArgs e)
        {
            //CREATE THE PAYMENT OBJECT
            Payment payment = GetPayment();
            //PROCESS CHECKING OUT EVENT
            bool checkOut = true;
            if (CheckingOut != null)
            {
                CheckingOutEventArgs c = new CheckingOutEventArgs(payment);
                CheckingOut(this, c);
                checkOut = !c.Cancel;
            }
            if (checkOut)
            {
                //PROCESS THE CHECKOUT
                ICheckoutService checkoutService = AbleContext.Resolve<ICheckoutService>();
                CheckoutRequest checkoutRequest = new CheckoutRequest(_Basket, payment);
                CheckoutResponse checkoutResponse = checkoutService.ExecuteCheckout(checkoutRequest, false);
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