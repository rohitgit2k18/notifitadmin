namespace AbleCommerce.ConLib.Checkout.PaymentForms
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Utility;
    using System.Linq;
    using CommerceBuilder.Payments.Providers;

    [Description("Payment form for a credit card based payment")]
    public partial class CreditCardPaymentForm : System.Web.UI.UserControl
    {
        // DEFINE EVENTS TO TRIGGER FOR CHECKOUT
        public event CheckingOutEventHandler CheckingOut;
        public event CheckedOutEventHandler CheckedOut;

        public bool AllowAmountEntry { get; set; }

        public decimal MaxPaymentAmount { get; set; }

        public decimal PaymentAmount { get; set; }

        public Order Order { get; set; }

        public Basket Basket { get; set; }

        private IList<PaymentMethod> _methods;

        private string _ValidationGroup = "CreditCard";

        private CommerceBuilder.Users.User _user;
        
        [Browsable(true), DefaultValue("CreditCard")]
        [Description("Gets or sets the validation group for this control and all child controls.")]
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            _user = AbleContext.Current.User;
            UpdateValidationOptions();

            // SET THE DEFAULT NAME
            CardName.Text = AbleContext.Current.User.PrimaryAddress.FullName;

            // POPULATE EXPIRATON DATE DROPDOWN
            int thisYear = LocaleHelper.LocalNow.Year;
            for (int i = 0; (i <= 10); i++)
            {
                ExpirationYear.Items.Add(new ListItem((thisYear + i).ToString()));
            }

            // POPULATE START DATE DROPDOWN
            for (int i = 1997; (i <= thisYear); i++)
            {
                StartDateYear.Items.Add(new ListItem(i.ToString()));
            }

            // LOAD AVAILABLE PAYMENT METHODS
            _methods = AbleCommerce.Code.StoreDataHelper.GetPaymentMethods(AbleContext.Current.UserId);
            List<string> creditCards = new List<string>();
            List<string> intlDebitCards = new List<string>();

            foreach (PaymentMethod method in _methods)
            {
                if (method.IsCreditOrDebitCard())
                {
                    CardType.Items.Add(new ListItem(method.Name, method.Id.ToString()));
                    if (method.IsIntlDebitCard()) intlDebitCards.Add(method.Name);
                    else creditCards.Add(method.Name);
                }
            }

            // SHOW OR HIDE INTL DEBIT FIELDS
            if (intlDebitCards.Count > 0)
            {
                trIntlCVV.Visible = true;
                if (creditCards.Count > 0)
                {
                    IntlCVVCredit.Visible = true;
                    IntlCVVCredit.Text = string.Format(IntlCVVCredit.Text, FormatCardNames(creditCards));
                }
                else IntlCVVCredit.Visible = false;
                IntlCVVDebit.Text = string.Format(IntlCVVDebit.Text, FormatCardNames(intlDebitCards));
                SecurityCodeValidator.Enabled = false;
                trIntlInstructions.Visible = true;
                IntlInstructions.Text = string.Format(IntlInstructions.Text, FormatCardNames(intlDebitCards));
                trIssueNumber.Visible = true;
                trStartDate.Visible = true;
            }
            else
            {
                trIntlCVV.Visible = false;
                trIntlInstructions.Visible = false;
                trIssueNumber.Visible = false;
                trStartDate.Visible = false;
            }

            // prevent double submit
            CreditCardButton.OnClientClick = "if (Page_ClientValidate('" + this.ValidationGroup + "')) { this.value='Processing...';this.onclick=function(){return false;}; }";
            CompleteButton.OnClientClick = "if (Page_ClientValidate('" + this.ValidationGroup + "')) { this.value='Processing...';this.onclick=function(){return false;}; }";
            BootstrapPopover.Visible = PageHelper.IsResponsiveTheme(this.Page);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (AbleContext.Current.Store.Settings.EnablePaymentProfilesStorage || NeedsPaymentProfiles())
            {
                if (!Page.IsPostBack && !_user.IsAnonymous)    
                {
                    Dictionary<int, string> profiles = new Dictionary<int, string>();
                    
                    bool hasRecurringSubscriptions = HasRecurringSubscriptions();
                    if (hasRecurringSubscriptions && AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled)
                    {
                        List<string> allowedMethod = new List<string>();
                        foreach (PaymentMethod method in _methods)
                        {
                            if (IsPaymentMethodAllowed(method, hasRecurringSubscriptions))
                            {
                                allowedMethod.Add(method.Name);
                            }
                        }

                        profiles = _user.PaymentProfiles
                            .Where(p => (!p.LastDayOfExpiry.HasValue || p.LastDayOfExpiry > LocaleHelper.LocalNow)
                                && PaymentGatewayDataSource.GetPaymentGatewayIdByClassId(p.GatewayIdentifier) > 0 && (string.IsNullOrEmpty(p.PaymentMethodName) || allowedMethod.Contains(p.PaymentMethodName)))
                                .ToDictionary(p => p.Id, p => string.Format("{0} ending in {1}", p.InstrumentType, p.ReferenceNumber));
                    }
                    else
                    {
                        profiles = _user.PaymentProfiles
                            .Where(p => (!p.LastDayOfExpiry.HasValue || p.LastDayOfExpiry > LocaleHelper.LocalNow)
                                && PaymentGatewayDataSource.GetPaymentGatewayIdByClassId(p.GatewayIdentifier) > 0)
                            .ToDictionary(p => p.Id, p => string.Format("{0} ending in {1}", p.InstrumentType, p.ReferenceNumber));
                    }
                    

                    if (profiles.Count > 0)
                    {
                        CardPH.Visible = false;
                        ProfilesPH.Visible = true;
                        profiles.Add(-1, "Add New Payment");
                        ProfilesList.Items.Clear();
                        foreach (var profile in profiles)
                            ProfilesList.Items.Add(new ListItem() { Text = profile.Value, Value = profile.Key.ToString() });
                        ListItem item = ProfilesList.Items.FindByValue(_user.Settings.DefaultPaymentProfileId.ToString());
                        if (item != null)
                        {
                            item.Selected = true;
                        }
                    }
                    else
                    {
                        CardPH.Visible = true;
                        ProfilesPH.Visible = false;
                    }
                }

                CardType.AutoPostBack = true;
            }

            // UPDATE MAX PAYMENT AMOUNT TO ORDER TOTAL IF NO VALUE IS SPECIFIED
            if (this.MaxPaymentAmount == 0) this.MaxPaymentAmount = AbleContext.Current.User.Basket.Items.TotalPrice();

            if (Page.IsPostBack)
            {   
                // VALIDATE IF CORRECT PAYMENT METHOD TYPE IS SELECTED
                PaymentMethod paymentMethod = PaymentMethodDataSource.Load(AlwaysConvert.ToInt(CardType.SelectedValue));
                if (paymentMethod != null)
                {
                    // INITIALIZE SELECTED CARD TYPE FOR VALIDATION
                    PaymentInstrumentType paymentInstrumentType = paymentMethod.PaymentInstrumentType;
                    CardNumberValidator1.AcceptedCardType = paymentInstrumentType.ToString();
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {            
            DisableAutoComplete();
            trAmount.Visible = AllowPartialPayments();
            string eTarget = Request.Form["__EVENTTARGET"] as string;
            if (trAmount.Visible && (string.IsNullOrEmpty(Amount.Text) || CreditCardButton.UniqueID != eTarget))
            {
                Amount.Text = GetPaymentAmount().ToString("F2");
            }

            bool hasSubscriptions = HasRecurringSubscriptions();            
            List<ListItem> itemsToUse = new List<ListItem>();
            foreach(ListItem item in CardType.Items)
            {
                int id = AlwaysConvert.ToInt(item.Value);
                if(id == 0) continue;

                var method = _methods.Where(m => m.Id == id).SingleOrDefault();
                if(method != null && IsPaymentMethodAllowed(method, hasSubscriptions))
                {
                    itemsToUse.Add(item);
                }
            }
            CardType.Items.Clear();
            CardType.Items.AddRange(itemsToUse.ToArray());

            bool showSaveCard = false;
            if (AbleContext.Current.Store.Settings.EnablePaymentProfilesStorage && !AbleContext.Current.User.IsAnonymousOrGuest)
            {
                PaymentMethod method = PaymentMethodDataSource.Load(AlwaysConvert.ToInt(CardType.SelectedValue));
                if (method != null && method.PaymentGateway != null)
                {
                    var provider = method.PaymentGateway.GetInstance();
                    showSaveCard = (provider.SupportedTransactions & SupportedTransactions.RecurringBillingProfileManaged) == SupportedTransactions.RecurringBillingProfileManaged;
                }
            }

            // IF SUBSCRIPTION IS BEING PURCHASED WITH RECURRING ORDERS ENABLED, SYSTEM MUST NEED TO SAVE THE PROFILE
            if (showSaveCard && AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled)
            {
                showSaveCard = !AbleContext.Current.User.Basket.Items.HasSubscriptions();
            }

            trSaveCard.Visible = showSaveCard;

            if (NeedsPaymentProfiles())
            {
                CreditCardButton.Visible = false;
                CompleteButton.Visible = true;
            }
        }

        protected bool AllowPartialPayments()
        {
            bool allow = this.AllowAmountEntry || AbleContext.Current.Store.Settings.EnablePartialPaymentCheckouts;

            // check if this order contain subscriptions
            if (allow) allow = !HasRecurringSubscriptions();

            return allow;
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

        private decimal GetPaymentAmount(bool getInputPrice = false)
        {
            decimal originalAmount = this.PaymentAmount;
            if (originalAmount <= 0) originalAmount = AbleContext.Current.User.Basket.Items.TotalPrice();

            // get the input price if price input is enabled and page is posted back
            if (Page.IsPostBack && trAmount.Visible && getInputPrice)
            {
                // check for posted back amount
                string postedAmount = Request.Form[Amount.UniqueID];
                decimal paymentAmount = AlwaysConvert.ToDecimal(postedAmount);

                // AC8-3022, AC8-2854: IF amount is not changed by merchant then
 	 	 	 	// to avoid rounding issues, restore the original amount upto 4 decimal digits
                string originalRoundedAmount = string.Format("{0:F2}", originalAmount);
                if (originalRoundedAmount == postedAmount) paymentAmount = originalAmount;

                if (paymentAmount > 0) return paymentAmount;
            }

            // otherwise use provided value or basket total
            return originalAmount;
        }

        private Payment GetPayment()
        {
            Payment payment = new Payment();
            payment.Amount = GetPaymentAmount(true);
            
            if (ProfilesPH.Visible)
            {
                var profile = GatewayPaymentProfileDataSource.Load(AlwaysConvert.ToInt(ProfilesList.SelectedValue));
                payment.PaymentProfile = profile;
                payment.ReferenceNumber = profile.ReferenceNumber;
                payment.PaymentMethodName = profile.PaymentMethodName;
            }
            else
            {
                payment.PaymentMethod = PaymentMethodDataSource.Load(AlwaysConvert.ToInt(CardType.SelectedValue));
                AccountDataDictionary instrumentBuilder = new AccountDataDictionary();
                instrumentBuilder["AccountName"] = CardName.Text;
                instrumentBuilder["AccountNumber"] = CardNumber.Text;
                instrumentBuilder["ExpirationMonth"] = ExpirationMonth.SelectedItem.Value;
                instrumentBuilder["ExpirationYear"] = ExpirationYear.SelectedItem.Value;
                instrumentBuilder["SecurityCode"] = SecurityCode.Text;
                if (payment.PaymentMethod.IsIntlDebitCard())
                {
                    if (IssueNumber.Text.Length > 0) instrumentBuilder["IssueNumber"] = IssueNumber.Text;
                    if ((StartDateMonth.SelectedIndex > 0) && (StartDateYear.SelectedIndex > 0))
                    {
                        instrumentBuilder["StartDateMonth"] = StartDateMonth.SelectedItem.Value;
                        instrumentBuilder["StartDateYear"] = StartDateYear.SelectedItem.Value;
                    }
                }
                payment.ReferenceNumber = Payment.GenerateReferenceNumber(CardNumber.Text);
                payment.AccountData = instrumentBuilder.ToString();
            }

            return payment;
        }

        private bool CustomValidation()
        {
            bool hasErrors = false;
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
                    hasErrors = true;
                }
            }

            //if intl instructions are visible, we must validate additional rules
            if (trIntlInstructions.Visible)
            {
                PaymentMethod m = PaymentMethodDataSource.Load(AlwaysConvert.ToInt(CardType.SelectedValue));
                if (m != null)
                {
                    if (m.IsIntlDebitCard())
                    {
                        // INTERNATIONAL DEBIT CARD, ISSUE NUMBER OR START DATE REQUIRED
                        bool invalidIssueNumber = (!Regex.IsMatch(IssueNumber.Text, "\\d{1,2}"));
                        bool invalidStartDate = ((StartDateMonth.SelectedIndex == 0) || (StartDateYear.SelectedIndex == 0));
                        if (invalidIssueNumber && invalidStartDate)
                        {
                            IntlDebitValidator1.IsValid = false;
                            IntlDebitValidator2.IsValid = false;
                            hasErrors = true;
                        }
                        // CHECK START DATE IS IN PAST
                        int selYear = AlwaysConvert.ToInt(StartDateYear.SelectedValue);
                        int curYear = DateTime.Now.Year;
                        if (selYear > curYear)
                        {
                            StartDateValidator1.IsValid = false;
                            hasErrors = true;
                        }
                        else if (selYear == curYear)
                        {
                            int selMonth = AlwaysConvert.ToInt(StartDateMonth.SelectedValue);
                            int curMonth = DateTime.Now.Month;
                            if (selMonth > curMonth)
                            {
                                StartDateValidator1.IsValid = false;
                                hasErrors = true;
                            }
                        }
                    }
                    else
                    {
                        // CREDIT CARD, CVV IS REQUIRED
                        if (!Regex.IsMatch(SecurityCode.Text, "\\d{3,4}"))
                        {
                            SecurityCodeValidator2.IsValid = false;
                            hasErrors = true;
                        }
                    }
                }
            }

            return !hasErrors;
        }

        protected void CreditCardButton_Click(object sender, EventArgs e)
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
                        GatewayPaymentProfile profile = null;
                        if (trSaveCard.Visible && SaveCard.Checked)
                        {
                            AccountDataDictionary cardDetails = new AccountDataDictionary();
                            cardDetails["AccountName"] = CardName.Text.Trim();
                            cardDetails["AccountNumber"] = CardNumber.Text.Trim();
                            cardDetails["ExpirationMonth"] = ExpirationMonth.SelectedItem.Value;
                            cardDetails["ExpirationYear"] = ExpirationYear.SelectedItem.Value;
                            cardDetails["SecurityCode"] = SecurityCode.Text.Trim();
                            profile = CreateProfile(cardDetails);
                        }

                        if (AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled && OrderHelper.HasRecurringSubscriptions(checkoutResponse.Order))
                        {
                            IList<Subscription> subscriptions = SubscriptionDataSource.LoadForOrder(checkoutResponse.Order.Id);
                            foreach (Subscription subscription in subscriptions)
                            {
                                OrderItem oi = subscription.OrderItem;
                                if (oi != null && oi.Price == 0 && OrderHelper.HasRecurringSubscriptions(oi) && subscription.PaymentProfile == null)
                                {
                                    if (profile == null)
                                    {
                                        if (ProfilesPH.Visible)
                                        {
                                            profile = GatewayPaymentProfileDataSource.Load(AlwaysConvert.ToInt(ProfilesList.SelectedValue));
                                        }

                                        if (CardPH.Visible)
                                        {
                                            AccountDataDictionary cardDetails = new AccountDataDictionary();
                                            cardDetails["AccountName"] = CardName.Text.Trim();
                                            cardDetails["AccountNumber"] = CardNumber.Text.Trim();
                                            cardDetails["ExpirationMonth"] = ExpirationMonth.SelectedItem.Value;
                                            cardDetails["ExpirationYear"] = ExpirationYear.SelectedItem.Value;
                                            cardDetails["SecurityCode"] = SecurityCode.Text.Trim();
                                            profile = CreateProfile(cardDetails);
                                        }
                                    }
                                    
                                    subscription.PaymentProfile = profile;
                                    subscription.PaymentProcessingType = PaymentProcessingType.ArbProfileManaged;
                                    subscription.Save();
                                }
                            }
                        }

                        if (profile != null && payment.PaymentProfile == null)
                        {
                            payment.PaymentProfile = profile;
                            payment.Save();
                        }
                        
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

        protected void CompleteButton_Click(object sender, EventArgs e) 
        {
            if (Page.IsValid)
            {
                bool checkOut = true;
                if (CheckingOut != null)
                {
                    CheckingOutEventArgs c = new CheckingOutEventArgs();
                    CheckingOut(this, c);
                    checkOut = !c.Cancel;
                }
                if (checkOut)
                {
                    Basket basket = AbleContext.Current.User.Basket;
                    //PROCESS THE CHECKOUT
                    ICheckoutService checkoutService = AbleContext.Resolve<ICheckoutService>();
                    CheckoutRequest checkoutRequest = new CheckoutRequest(basket);
                    CheckoutResponse checkoutResponse = checkoutService.ExecuteCheckout(checkoutRequest);
                    if (checkoutResponse.Success)
                    {
                        GatewayPaymentProfile profile = null;
                        this.Visible = true;

                        if (ProfilesPH.Visible)
                        {
                            profile = GatewayPaymentProfileDataSource.Load(AlwaysConvert.ToInt(ProfilesList.SelectedValue));
                        }

                        if (CardPH.Visible)
                        {
                            AccountDataDictionary cardDetails = new AccountDataDictionary();
                            cardDetails["AccountName"] = CardName.Text.Trim();
                            cardDetails["AccountNumber"] = CardNumber.Text.Trim();
                            cardDetails["ExpirationMonth"] = ExpirationMonth.SelectedItem.Value;
                            cardDetails["ExpirationYear"] = ExpirationYear.SelectedItem.Value;
                            cardDetails["SecurityCode"] = SecurityCode.Text.Trim();
                            profile = CreateProfile(cardDetails);
                        }

                        if (profile != null)
                        {
                            IList<Subscription> subscriptions = SubscriptionDataSource.LoadForOrder(checkoutResponse.Order.Id);
                            foreach (Subscription subscription in subscriptions)
                            {
                                if (subscription.PaymentFrequency.HasValue && subscription.PaymentFrequencyUnit.HasValue)
                                {
                                    subscription.PaymentProfile = profile;
                                    subscription.PaymentProcessingType = PaymentProcessingType.ArbProfileManaged;
                                    subscription.Save();
                                }
                            }
                        }

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

        protected GatewayPaymentProfile CreateProfile(AccountDataDictionary cardDetails) 
        {
            PaymentMethod method = PaymentMethodDataSource.Load(AlwaysConvert.ToInt(CardType.SelectedValue));
            PaymentGateway gateway = method.PaymentGateway;
            PaymentInstrumentData instr = PaymentInstrumentData.CreateInstance(cardDetails, method.PaymentInstrumentType, null);
            GatewayPaymentProfile profile = null;
            if (gateway != null)
            {
                var provider = gateway.GetInstance();
                string customerProfileId = string.Empty;
                var profileResult = _user.PaymentProfiles.Where(p => p.GatewayIdentifier == gateway.ClassId)
                    .GroupBy(p => p.CustomerProfileId)
                    .Take(1)
                    .Select(g => new { CustomerProfileId = g.Key })
                    .SingleOrDefault();

                if (profileResult != null && !string.IsNullOrEmpty(profileResult.CustomerProfileId))
                    customerProfileId = profileResult.CustomerProfileId;

                if (string.IsNullOrEmpty(customerProfileId))
                {
                    try
                    {
                        var rsp = provider.DoCreateCustomerProfile(new CommerceBuilder.Payments.Providers.CreateCustomerProfileRequest(_user));
                        if (rsp.Successful)
                            customerProfileId = rsp.CustomerProfileId;
                        else if (rsp.ResponseCode == "E00039")
                        {
                            var match = Regex.Match(rsp.ResponseMessage, @"\d+", RegexOptions.CultureInvariant);
                            if (match.Success)
                                customerProfileId = match.Value;
                            else
                                Logger.Error(rsp.ResponseMessage);
                        }
                        else
                            Logger.Error(rsp.ResponseMessage);
                    }
                    catch (Exception exp)
                    {
                        Logger.Error(exp.Message);
                    }
                }

                try
                {
                    var rsp = provider.DoCreatePaymentProfile(new CommerceBuilder.Payments.Providers.CreatePaymentProfileRequest(_user, instr, customerProfileId) { ValidateProfile = true });
                    if (rsp.Successful)
                    {
                        GatewayPaymentProfile gwprofile = new GatewayPaymentProfile();
                        gwprofile.NameOnCard = CardName.Text.Trim(); ;
                        gwprofile.Expiry = Misc.GetStartOfDate(new DateTime(AlwaysConvert.ToInt(ExpirationYear.SelectedItem.Value), AlwaysConvert.ToInt(ExpirationMonth.SelectedItem.Value), 1));
                        gwprofile.CustomerProfileId = customerProfileId;
                        gwprofile.PaymentProfileId = rsp.PaymentProfileId;
                        gwprofile.ReferenceNumber = StringHelper.MakeReferenceNumber(cardDetails["AccountNumber"]);
                        gwprofile.User = _user;
                        gwprofile.InstrumentType = instr.InstrumentType;
                        gwprofile.PaymentMethodName = method.Name;
                        gwprofile.GatewayIdentifier = gateway.ClassId;
                        gwprofile.Save();
                        CardName.Text = string.Empty;
                        CardNumber.Text = string.Empty;
                        ExpirationMonth.SelectedIndex = 0;
                        ExpirationYear.SelectedIndex = 0;
                        profile = gwprofile;
                    }
                }
                catch (Exception exp)
                {
                    Logger.Error(exp.Message);
                }
            }

            return profile;
        }

        private void DisableAutoComplete()
        {
            CardNumber.Attributes.Add("autocomplete", "off");
            CardNumber.Text = string.Empty;
            SecurityCode.Attributes.Add("autocomplete", "off");
            SecurityCode.Text = string.Empty;
            IssueNumber.Attributes.Add("autocomplete", "off");
            IssueNumber.Text = string.Empty;
        }

        private void UpdateValidationOptions()
        {
            Amount.ValidationGroup = _ValidationGroup;
            AmountRequired.ValidationGroup = _ValidationGroup;
            CardType.ValidationGroup = _ValidationGroup;
            CardTypeRequired.ValidationGroup = _ValidationGroup;
            CardName.ValidationGroup = _ValidationGroup;
            CardNameRequired.ValidationGroup = _ValidationGroup;
            CardNumber.ValidationGroup = _ValidationGroup;
            CardNumberValidator1.ValidationGroup = _ValidationGroup;
            ExpirationDropDownValidator1.ValidationGroup = _ValidationGroup;
            CardNumberValidator2.ValidationGroup = _ValidationGroup;
            ExpirationMonth.ValidationGroup = _ValidationGroup;
            MonthValidator.ValidationGroup = _ValidationGroup;
            ExpirationYear.ValidationGroup = _ValidationGroup;
            YearValidator.ValidationGroup = _ValidationGroup;
            SecurityCode.ValidationGroup = _ValidationGroup;
            SecurityCodeValidator.ValidationGroup = _ValidationGroup;
            SecurityCodeValidator2.ValidationGroup = _ValidationGroup;
            IssueNumber.ValidationGroup = _ValidationGroup;
            StartDateMonth.ValidationGroup = _ValidationGroup;
            StartDateMonth.ValidationGroup = _ValidationGroup;
            IntlDebitValidator1.ValidationGroup = _ValidationGroup;
            IntlDebitValidator2.ValidationGroup = _ValidationGroup;
            StartDateValidator1.ValidationGroup = _ValidationGroup;
            CreditCardButton.ValidationGroup = _ValidationGroup;
            CompleteButton.ValidationGroup = _ValidationGroup;
        }

        private string FormatCardNames(List<string> cardNames)
        {
            if (cardNames == null || cardNames.Count == 0) return string.Empty;
            if (cardNames.Count == 1) return cardNames[0];
            string formattedNames = string.Join(", ", cardNames.ToArray());
            int lastComma = formattedNames.LastIndexOf(", ");
            string leftSide = formattedNames.Substring(0, lastComma);
            string rightSide = formattedNames.Substring(lastComma + 1);
            return leftSide + ", and" + rightSide;
        }

        protected void ProfilesList_SelectedIndexChanged(object sender, EventArgs e)
        {
            int profileId = AlwaysConvert.ToInt(ProfilesList.SelectedValue);
            if (profileId == -1)
            {
                CardPH.Visible = true;
                ProfilesPH.Visible = false;
            }
        }

        private bool NeedsPaymentProfiles()
        {
            return AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled && this.Basket != null && this.Basket.Items.TotalPrice() <= 0 && HasRecurringSubscriptions();
        }
    }
}