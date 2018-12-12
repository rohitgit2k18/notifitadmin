namespace AbleCommerce.Mobile.UserControls.Checkout
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers.PayPal;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Utility;

    public partial class PaymentWidget : System.Web.UI.UserControl
    {
        // define parameters for preventing repeated checkout failures
        private const int _MaxPaymentFailures = 3;
        private const int _TimeoutMinutes = 5;
        private const string _LastFailureDateKey = "AC_CheckoutLastFailureDate";
        private const string _FailureCountKey = "AC_CheckoutFailureCount";
        protected IList<PaymentMethod> _AvailablePaymentMethods = null;

        public event CheckedOutEventHandler CheckedOut;

        /// <summary>
        /// Gets or sets the order associated with this payment widget
        /// </summary>
        public Order Order { get; set; }

        /// <summary>
        /// Gets or sets the basket associated with this payment widget
        /// </summary>
        public Basket Basket { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool hasBasket = this.Basket != null;
            bool hasOrder = this.Order != null;

            CreditCardPaymentForm.Order = this.Order;
            CreditCardPaymentForm.Basket = this.Basket;

            if (hasBasket || hasOrder)
            {
                decimal paymentAmount;
                if (hasOrder)
                {
                    // if this is a post-order payment we must bypass the 
                    // typical behavior of checkout payment forms
                    HandlePostOrderPayment();

                    // payment amount is customer balance
                    paymentAmount = this.Order.GetCustomerBalance();
                    CheckPaymentForm.PaymentAmount = paymentAmount;
                    CheckPaymentForm.MaxPaymentAmount = paymentAmount;
                    CreditCardPaymentForm.PaymentAmount = paymentAmount;
                    CreditCardPaymentForm.MaxPaymentAmount = paymentAmount;
                    GiftCertificatePaymentForm.PaymentAmount = paymentAmount;
                    MailPaymentForm.PaymentAmount = paymentAmount;
                    PayPalPaymentForm.PaymentAmount = paymentAmount;
                    PhoneCallPaymentForm.PaymentAmount = paymentAmount;
                    PurchaseOrderPaymentForm.PaymentAmount = paymentAmount;                    
                }
                else
                {
                    // protect against repeated failures
                    int failureCount = GetFailureCount();
                    if (failureCount >= _MaxPaymentFailures)
                    {
                        DisablePayments();
                        return;
                    }

                    // examine result of checkout
                    HandleCheckoutResponse();

                    // coupons are only available for initial basket payments
                    // not for follow-on order payments
                    CouponsPanel.Visible = true;

                    // payment amount is basket total
                    paymentAmount = this.Basket.Items.TotalPrice();
                }

                // determine if payment is required
                if (paymentAmount > 0)
                {
                    if (hasBasket && IsPayPalExpress())
                    {
                        PayPalExpressPaymentForm.Visible = true;
                    }
                    else
                    {
                        // determine available payment options from merchant config
                        BindPaymentOptions();
                    }
                }
                else
                {
                    ZeroValuePaymentForm.Visible = true;
                }
            }
            else
            {
                this.Controls.Clear();
            }
        }

        private void HandlePostOrderPayment()
        {
            CheckPaymentForm.CheckingOut += new CheckingOutEventHandler(PostCheckoutPayment);
            CreditCardPaymentForm.CheckingOut += new CheckingOutEventHandler(PostCheckoutPayment);
            GiftCertificatePaymentForm.CheckingOut += new CheckingOutEventHandler(PostCheckoutPayment);
            MailPaymentForm.CheckingOut += new CheckingOutEventHandler(PostCheckoutPayment);
            PayPalPaymentForm.CheckingOut += new CheckingOutEventHandler(PostCheckoutPayment);
            PhoneCallPaymentForm.CheckingOut += new CheckingOutEventHandler(PostCheckoutPayment);
            PurchaseOrderPaymentForm.CheckingOut += new CheckingOutEventHandler(PostCheckoutPayment);
        }

        private void HandleCheckoutResponse()
        {
            CheckPaymentForm.CheckedOut += new CheckedOutEventHandler(HandleCheckoutResponse);
            CreditCardPaymentForm.CheckedOut += new CheckedOutEventHandler(HandleCheckoutResponse);
            GiftCertificatePaymentForm.CheckedOut += new CheckedOutEventHandler(HandleCheckoutResponse);
            MailPaymentForm.CheckedOut += new CheckedOutEventHandler(HandleCheckoutResponse);
            PayPalPaymentForm.CheckedOut += new CheckedOutEventHandler(HandleCheckoutResponse);
            PhoneCallPaymentForm.CheckedOut += new CheckedOutEventHandler(HandleCheckoutResponse);
            PurchaseOrderPaymentForm.CheckedOut += new CheckedOutEventHandler(HandleCheckoutResponse);
        }

        private void HandleCheckoutResponse(object sender, CheckedOutEventArgs e)
        {
            if (!e.CheckoutResponse.Success)
            {
                // SHOW ERRORS TO CUSTOMER
                WarningMessageList.DataSource = e.CheckoutResponse.WarningMessages;
                WarningMessageList.DataBind();

                // protect against repeated failures
                IncreaseFailureCount();
                int failureCount = GetFailureCount();
                if (failureCount >= _MaxPaymentFailures)
                {
                    DisablePayments();
                }
            }

            if (CheckedOut != null)
                CheckedOut(this, e);
        }

        protected void ApplyCouponButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                IBasketService basketService = AbleContext.Resolve<IBasketService>();
                CouponResult result = basketService.ApplyCoupon(AbleContext.Current.User.Basket, CouponCode.Text);
                if (result.ResultType == CouponResultType.Valid)
                {
                    ValidCouponMessage.Visible = true;
                    ValidCouponMessage.Text = string.Format(ValidCouponMessage.Text, CouponCode.Text);
                    if (result.RemovedCoupons.Count > 0)
                    {
                        CouponsRemovedMessage.Text = String.Format(CouponsRemovedMessage.Text, string.Join(", ", result.RemovedCoupons.ToArray()));
                        CouponsRemovedMessage.Visible = true;
                    }
                }
                else
                {
                    // handle error
                    switch (result.ResultType)
                    {
                        case CouponResultType.InvalidCode:
                            InvalidCouponMessage.Text = "<p class=\"error\">The coupon code you entered is invalid.</p>";
                            break;
                        case CouponResultType.AlreadyUsed:
                            InvalidCouponMessage.Text = "<p class=\"error\">The coupon code you entered is already in use.</p>";
                            break;
                        case CouponResultType.InvalidForOrder:
                            InvalidCouponMessage.Text = "<p class=\"error\">" + result.ErrorMessage + "</p>";
                            break;
                    }
                    InvalidCouponMessage.Visible = true;
                }
                CouponCode.Text = string.Empty;
            }
        }

        private bool IsPayPalExpress()
        {
            ExpressCheckoutSession paypalSession = ExpressCheckoutSession.Current;
            if (paypalSession != null)
            {
                return true;
            }
            return false;
        }

        private bool HasRecurringSubscriptions()
        {
            bool hasBasket = this.Basket != null;
            bool hasOrder = this.Order != null;
            if (hasBasket) return BasketHelper.HasRecurringSubscriptions(this.Basket);
            else if (hasOrder) return OrderHelper.HasRecurringSubscriptions(this.Order);
            else return false;
        }

        private bool IsPaymentMethodAllowed(PaymentMethod payMethod, bool hasSubscriptions)
        {
            if (!hasSubscriptions) return true;
            if (payMethod.AllowSubscriptions) return true;
            return !AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled;
        }

        private void BindPaymentOptions()
        {
            // GENERATE LIST OF PAYMENT TYPES AVAIL
            List<DictionaryEntry> paymentMethods = new List<DictionaryEntry>();
            _AvailablePaymentMethods = AbleCommerce.Code.StoreDataHelper.GetPaymentMethods(AbleContext.Current.UserId);
            bool hasSubscriptions = HasRecurringSubscriptions();
            foreach (PaymentMethod method in _AvailablePaymentMethods)
            {
                if (!IsPaymentMethodAllowed(method, hasSubscriptions))
                {
                    // basket / order contains recurring subscriptions. This payment method is not allowed
                    // for subscription payments
                    continue;
                }

                switch (method.PaymentInstrumentType)
                {
                    case PaymentInstrumentType.AmericanExpress:
                    case PaymentInstrumentType.Discover:
                    case PaymentInstrumentType.JCB:
                    case PaymentInstrumentType.MasterCard:
                    case PaymentInstrumentType.DinersClub:
                    case PaymentInstrumentType.Visa:
                    case PaymentInstrumentType.Maestro:
                    case PaymentInstrumentType.SwitchSolo:
                    case PaymentInstrumentType.VisaDebit:
                        if (paymentMethods.Count == 0 || (int)paymentMethods[0].Key != -1)
                            paymentMethods.Insert(0, new DictionaryEntry(-1, "Credit/Debit Card"));
                        break;
                    case PaymentInstrumentType.Check:
                    case PaymentInstrumentType.PurchaseOrder:
                    case PaymentInstrumentType.PayPal:
                    case PaymentInstrumentType.Mail:
                    case PaymentInstrumentType.PhoneCall:
                        paymentMethods.Add(new DictionaryEntry(method.Id, method.Name));
                        break;
                    case PaymentInstrumentType.Amazon:
                        // Amazon do not support post order payments
                        if(this.Basket != null)
                            paymentMethods.Add(new DictionaryEntry(method.Id, method.Name));
                        break;
                    default:
                        // types not supported
                        break;
                }
            }

            // INCLUDE GIFT CERTIFICATES IF ANY EXIST IN THE STORE
            if (AbleCommerce.Code.StoreDataHelper.HasGiftCertificates())
            {
                if(!hasSubscriptions) paymentMethods.Add(new DictionaryEntry(-2, "Gift Certificate"));
            }

            // ONLY CONTINUE IF PAYMENT METHODS ARE AVAILABLE
            if (paymentMethods.Count > 0)
            {
                paymentMethods.Sort(ComparerPaymentMethod);
                // BIND THE RADIO LIST FOR PAYMENT METHOD SELECTION
                PaymentMethodList.DataSource = paymentMethods;
                PaymentMethodList.DataBind();

                // MAKE SURE THE CORRECT PAYMENT METHOD IS SELECTED
                int paymentMethodId = AlwaysConvert.ToInt(Request.Form[PaymentMethodList.UniqueID]);
                ListItem selectedListItem = PaymentMethodList.Items.FindByValue(paymentMethodId.ToString());
                if (selectedListItem != null)
                {
                    PaymentMethodList.SelectedIndex = PaymentMethodList.Items.IndexOf(selectedListItem);
                }
                else PaymentMethodList.SelectedIndex = 0;

                // SHOW THE CORRECT FORM FOR THE SELECTED METHOD
                paymentMethodId = AlwaysConvert.ToInt(PaymentMethodList.SelectedValue);
                if (paymentMethodId == -1)
                {
                    CreditCardPaymentForm.Visible = true;

                    // show amount entry for post-checkout payments
                    CreditCardPaymentForm.AllowAmountEntry = this.Order != null;
                }
                else if (paymentMethodId == -2)
                {
                    GiftCertificatePaymentForm.Visible = true;
                }
                else
                {
                    PaymentMethod selectedMethod = _AvailablePaymentMethods[_AvailablePaymentMethods.IndexOf(paymentMethodId)];
                    switch (selectedMethod.PaymentInstrumentType)
                    {
                        case PaymentInstrumentType.Check:
                            CheckPaymentForm.PaymentMethodId = selectedMethod.Id;
                            CheckPaymentForm.Visible = true;
                            break;
                        case PaymentInstrumentType.PurchaseOrder:
                            PurchaseOrderPaymentForm.PaymentMethodId = selectedMethod.Id;
                            PurchaseOrderPaymentForm.Visible = true;
                            break;
                        case PaymentInstrumentType.PayPal:
                            PayPalPaymentForm.PaymentMethodId = selectedMethod.Id;
                            PayPalPaymentForm.Visible = true;
                            break;
                        case PaymentInstrumentType.Mail:
                            MailPaymentForm.PaymentMethodId = selectedMethod.Id;
                            MailPaymentForm.Visible = true;
                            break;
                        case PaymentInstrumentType.PhoneCall:
                            PhoneCallPaymentForm.PaymentMethodId = selectedMethod.Id;
                            PhoneCallPaymentForm.Visible = true;
                            break;
                        case PaymentInstrumentType.Amazon:
                            AmazonPaymentForm.PaymentMethodId = selectedMethod.Id;
                            AmazonPaymentForm.Visible = true;
                            break;
                        default:
                            // types not supported
                            break;
                    }
                }

                // SHOW PAYMENT SELECTION IF THERE IS MORE THAN ONE TYPE
                PaymentMethodListPanel.Visible = PaymentMethodList.Items.Count > 1;
            }
        }

        private void PostCheckoutPayment(object sender, CheckingOutEventArgs e)
        {
            // VALIDATE THE PAYMENT
            if (e.Payment.Amount > 0 && e.Payment.Amount <= Order.GetCustomerBalance())
            {
                bool result = PayOrder(e.Payment);
                if (result) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page, "Mobile/Members/MyOrder.aspx?OrderNumber=" + this.Order.OrderNumber));
            }

            // CANCEL PENDING CHECKOUT
            e.Cancel = true;
        }

        private bool PayOrder(Payment payment)
        {
            bool hasGateway = (payment.PaymentMethod.PaymentGateway != null);
            if (hasGateway)
            {
                // PRESERVE ACCOUNT DATA FOR PROCESSING
                string accountData = payment.AccountData;
                payment.AccountData = string.Empty;

                // SAVE PAYMENT
                this.Order.Payments.Add(payment);
                this.Order.Save(true, true);

                // PROCESS PAYMENT WITH SAVED ACCOUNT DATA
                payment.AccountData = accountData;
                payment.Authorize(false);
                if (payment.PaymentStatus == PaymentStatus.AuthorizationFailed)
                {
                    // VOID PAYMENT AND SHOW ERRORS TO CUSTOMER
                    payment.Void();
                    List<string> errorList = new List<string>();
                    errorList.Add(payment.Transactions[0].ResponseMessage);
                    WarningMessageList.DataSource = errorList;
                    WarningMessageList.DataBind();
                    return false;
                }
                else return true;
            }
            else
            {
                //SAVE PAYMENT
                this.Order.Payments.Add(payment);
                this.Order.Save(true, true);
                return true;
            }
        }

        /// <summary>
        /// Disables the payment form due to too many failed attempts
        /// </summary>
        private void DisablePayments()
        {
            // do not show payment form
            PaymentFormContainer.Visible = false;
            CouponsPanel.Visible = false;
            FailurePanel.Visible = true;

            // how many minutes of lockout remaining?
            DateTime lastFailureDate = GetLastFailureDate();
            TimeSpan elapsedTime = LocaleHelper.LocalNow - lastFailureDate;
            FailureTimeoutRemaining.Text = (_TimeoutMinutes - (int)elapsedTime.TotalMinutes).ToString();
        }

        private DateTime GetLastFailureDate()
        {
            // GET CURRENT FAILURE COUNT
            if (Session[_LastFailureDateKey] != null)
            {
                return (DateTime)Session[_LastFailureDateKey];
            }
            else
            {
                return LocaleHelper.LocalNow;
            }
        }

        private int GetFailureCount()
        {
            // GET CURRENT FAILURE COUNT
            if (Session[_FailureCountKey] != null)
            {
                DateTime lastFailureDate = GetLastFailureDate();
                TimeSpan elapsedTime = LocaleHelper.LocalNow - lastFailureDate;
                int remainingTimeout = (_TimeoutMinutes - (int)elapsedTime.TotalMinutes);
                if (remainingTimeout <= 0)
                {
                    // timeout has expired
                    Session[_LastFailureDateKey] = null;
                    Session[_FailureCountKey] = 0;
                }
                return (int)Session[_FailureCountKey];
            }
            else
            {
                return 0;
            }
        }

        private void IncreaseFailureCount()
        {
            // INCREASE CURRENT FAILURE COUNT
            Session[_FailureCountKey] = GetFailureCount() + 1;
            Session[_LastFailureDateKey] = LocaleHelper.LocalNow;
        }

        private int ComparerPaymentMethod(DictionaryEntry x, DictionaryEntry y)
        {
            int paymentMethodId1 = (int)x.Key;
            int paymentMethodId2 = (int)y.Key;
            int order1, order2 = 0;

            if (paymentMethodId1 == -1) order1 = GetCreditCardSortOrder();
            else if (paymentMethodId1 == -2) order1 = AbleContext.Resolve<IPaymentMethodProvider>().GetGiftCertificatePaymentMethod().OrderBy;
            else order1 = _AvailablePaymentMethods[_AvailablePaymentMethods.IndexOf(paymentMethodId1)].OrderBy;

            if (paymentMethodId2 == -1) order2 = GetCreditCardSortOrder();
            else if (paymentMethodId2 == -2) order2 = AbleContext.Resolve<IPaymentMethodProvider>().GetGiftCertificatePaymentMethod().OrderBy;
            else order2 = _AvailablePaymentMethods[_AvailablePaymentMethods.IndexOf(paymentMethodId2)].OrderBy;

            return order1.CompareTo(order2);
        }

        private int GetCreditCardSortOrder()
        {
            int order = -1;
            foreach (PaymentMethod method in _AvailablePaymentMethods)
            {
                switch (method.PaymentInstrumentType)
                {
                    case PaymentInstrumentType.AmericanExpress:
                    case PaymentInstrumentType.Discover:
                    case PaymentInstrumentType.JCB:
                    case PaymentInstrumentType.MasterCard:
                    case PaymentInstrumentType.DinersClub:
                    case PaymentInstrumentType.Visa:
                    case PaymentInstrumentType.Maestro:
                    case PaymentInstrumentType.SwitchSolo:
                    case PaymentInstrumentType.VisaDebit:
                        if (order == -1) order = method.OrderBy;
                        else if (method.OrderBy < order) order = method.OrderBy;
                        break;
                    default:
                        break;
                }
            }

            if (order == -1) order = 0;
            return order;
        }
    }
}