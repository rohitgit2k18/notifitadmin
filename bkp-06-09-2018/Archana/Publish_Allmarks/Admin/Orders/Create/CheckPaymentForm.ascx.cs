namespace AbleCommerce.Admin.Orders.Create
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class CheckPaymentForm : System.Web.UI.UserControl
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

        private string _ValidationGroup = "Check";
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        private bool _ValidationSummaryVisible = true;
        public bool ValidationSummaryVisible
        {
            get { return _ValidationSummaryVisible; }
            set { _ValidationSummaryVisible = value; }
        }

        private bool _AllowAmountEntry = false;
        public bool AllowAmountEntry
        {
            get { return _AllowAmountEntry; }
            set { _AllowAmountEntry = value; }
        }

        private decimal _PaymentAmount = 0;
        public decimal PaymentAmount
        {
            get { return _PaymentAmount; }
            set { _PaymentAmount = value; }
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
            SortCode.ValidationGroup = _ValidationGroup;
            SortCodeValidator.ValidationGroup = _ValidationGroup;
            AccountNumber.ValidationGroup = _ValidationGroup;
            AccountNumberValidator.ValidationGroup = _ValidationGroup;
            CheckButton.ValidationGroup = _ValidationGroup;
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
            trRoutingNumber.Visible = (_User.PrimaryAddress.CountryCode == "US");
            trSortCode.Visible = !trRoutingNumber.Visible;
        }

        private PaymentMethod _PaymentMethod;
        protected void Page_Load(object sender, EventArgs e)
        {
            _PaymentMethod = PaymentMethodDataSource.Load(this.PaymentMethodId);
            if (_PaymentMethod != null)
            {
                Caption.Text = string.Format(Caption.Text, _PaymentMethod.Name);
                CheckButton.Text = string.Format(CheckButton.Text, _PaymentMethod.Name);
                if (!Page.IsPostBack)
                {
                    AccountHolder.Text = _User.PrimaryAddress.FullName;
                }
                trAmount.Visible = this.AllowAmountEntry;
                DisableAutoComplete();
            }
            else
            {
                this.Controls.Clear();
                Trace.Write(this.GetType().ToString(), "Output suppressed, invalid payment method provided.");
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (trAmount.Visible && string.IsNullOrEmpty(Amount.Text))
            {
                Amount.Text = GetPaymentAmount().ToString("F2");
            }
        }

        private decimal GetPaymentAmount()
        {
            if (Page.IsPostBack)
            {
                if (trAmount.Visible && !string.IsNullOrEmpty(Amount.Text)) return AlwaysConvert.ToDecimal(Amount.Text);
                else if (this.PaymentAmount > 0) return this.PaymentAmount;
                else return _Basket.Items.TotalPrice();
            }
            else
            {
                if (this.PaymentAmount > 0) return this.PaymentAmount;
                return _Basket.Items.TotalPrice();
            }
        }

        private Payment GetPayment()
        {
            Payment payment = new Payment();
            payment.PaymentMethodId = _PaymentMethodId;
            payment.Amount = GetPaymentAmount();
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
            if (Page.IsValid)
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
            else CheckButton.Text = string.Format("Pay by {0}", _PaymentMethod.Name);
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