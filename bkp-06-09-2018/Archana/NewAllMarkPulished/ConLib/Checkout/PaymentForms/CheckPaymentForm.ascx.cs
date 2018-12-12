namespace AbleCommerce.ConLib.Checkout.PaymentForms
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Utility;

    [Description("Payment form for a check based payment")]
    public partial class CheckPaymentForm : System.Web.UI.UserControl
    {
        //DEFINE EVENTS TO TRIGGER FOR CHECKOUT
        public event CheckingOutEventHandler CheckingOut;
        public event CheckedOutEventHandler CheckedOut;

        private string _ValidationGroup = "Check";
        private PaymentMethod _PaymentMethod;

        public bool AllowAmountEntry { get; set; }

        public decimal MaxPaymentAmount { get; set; }

        public decimal PaymentAmount { get; set; }

        public int PaymentMethodId { get; set; }

        [Browsable(true), DefaultValue("Check")]
        [Description("Gets or sets the validation group for this control and all child controls.")]
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        private void UpdateValidationOptions()
        {
            AccountHolder.ValidationGroup = _ValidationGroup;
            AccountHolderValidator.ValidationGroup = _ValidationGroup;
            BankName.ValidationGroup = _ValidationGroup;
            BankNameRequiredValidator.ValidationGroup = _ValidationGroup;
            RoutingNumber.ValidationGroup = _ValidationGroup;
            RoutingNumberValidator.ValidationGroup = _ValidationGroup;
            RoutingNumberValidator2.ValidationGroup = _ValidationGroup;
            AccountNumber.ValidationGroup = _ValidationGroup;
            AccountNumberValidator.ValidationGroup = _ValidationGroup;
            CheckButton.ValidationGroup = _ValidationGroup;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _PaymentMethod = PaymentMethodDataSource.Load(this.PaymentMethodId);
            if (_PaymentMethod != null)
            {
                UpdateValidationOptions();
                CheckButton.Text = string.Format(CheckButton.Text, _PaymentMethod.Name);
                if (!Page.IsPostBack)
                {
                    AccountHolder.Text = AbleContext.Current.User.PrimaryAddress.FullName;
                }
                trAmount.Visible = AllowPartialPayments();
                DisableAutoComplete();

                // UPDATE MAX PAYMENT AMOUNT TO ORDER TOTAL IF NO VALUE IS SPECIFIED
                if (this.MaxPaymentAmount == 0) this.MaxPaymentAmount = AbleContext.Current.User.Basket.Items.TotalPrice();
            }
            else
            {
                this.Controls.Clear();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            string eTarget = Request.Form["__EVENTTARGET"] as string;
            if (trAmount.Visible && (string.IsNullOrEmpty(Amount.Text) || CheckButton.UniqueID != eTarget))
            {
                Amount.Text = GetPaymentAmount().ToString("F2");
            }

            // prevent double submit
            CheckButton.OnClientClick = "if (Page_ClientValidate('" + this.ValidationGroup + "')) { this.value='Processing...';this.onclick=function(){return false;}; }";
        }

        protected bool AllowPartialPayments()
        {
            bool allow = this.AllowAmountEntry || AbleContext.Current.Store.Settings.EnablePartialPaymentCheckouts;

            // check if this order contain subscriptions
            if (allow) allow = !BasketHelper.HasRecurringSubscriptions(AbleContext.Current.User.Basket);

            return allow;
        }

        private decimal GetPaymentAmount(bool getInputPrice = false)
        {            
            // get the input price if price input is enabled and page is posted back
            if (Page.IsPostBack && trAmount.Visible && getInputPrice)
            {
                // check for posted back amount
                decimal paymentAmount = AlwaysConvert.ToDecimal(Request.Form[Amount.UniqueID]);
                if (paymentAmount > 0) return paymentAmount;
            }

            // otherwise use provided value or basket total
            if (this.PaymentAmount > 0) return this.PaymentAmount;
            else return AbleContext.Current.User.Basket.Items.TotalPrice();
        }

        private Payment GetPayment()
        {
            Payment payment = new Payment();
            payment.PaymentMethod = _PaymentMethod;
            payment.Amount = GetPaymentAmount(true);
            AccountDataDictionary instrumentBuilder = new AccountDataDictionary();
            instrumentBuilder["AccountHolder"] = StringHelper.StripHtml(AccountHolder.Text);
            instrumentBuilder["BankName"] = StringHelper.StripHtml(BankName.Text);
            instrumentBuilder["RoutingNumber"] = RoutingNumber.Text;
            instrumentBuilder["AccountNumber"] = AccountNumber.Text;
            payment.ReferenceNumber = Payment.GenerateReferenceNumber(AccountNumber.Text);
            payment.AccountData = instrumentBuilder.ToString();
            return payment;
        }

        protected void CheckButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && CustomValidation())
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

        private bool CustomValidation()
        {
            if (trAmount.Visible)
            {
                decimal amount = AlwaysConvert.ToDecimal(Request.Form[Amount.UniqueID]);
                decimal maxAmount = AlwaysConvert.ToDecimal(this.MaxPaymentAmount.LSCurrencyFormat("lc"));
                if (amount <= 0 || (maxAmount > 0 && amount > maxAmount))
                {
                    CustomValidator invalidAmount = new CustomValidator();
                    invalidAmount.ValidationGroup = this.ValidationGroup;
                    invalidAmount.Text = "*";
                    invalidAmount.ErrorMessage = "Invalid amount.  Payment must be greater than zero and no more than " + MaxPaymentAmount.LSCurrencyFormat("lc") + ".";
                    invalidAmount.IsValid = false;
                    phAmount.Controls.Add(invalidAmount);
                    return false;
                }
            }
            return true;
        }

        private void DisableAutoComplete()
        {
            AccountHolder.Attributes.Add("autocomplete", "off");
            BankName.Attributes.Add("autocomplete", "off");
            RoutingNumber.Attributes.Add("autocomplete", "off");
            AccountNumber.Attributes.Add("autocomplete", "off");
        }
    }
}