namespace AbleCommerce.Members
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
    using CommerceBuilder.Users;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Payments.Providers;

    public partial class PaymentTypes : CommerceBuilder.UI.AbleCommercePage
    {
        User _user = AbleContext.Current.User;
        StoreSettingsManager _settings = AbleContext.Current.Store.Settings;

        private IList<PaymentMethod> _methods;

        private string _ValidationGroup = "CreditCard";

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!_settings.EnablePaymentProfilesStorage || AbleContext.Current.User.IsAnonymousOrGuest)
                Response.Redirect("MyAccount.aspx");

            UpdateValidationOptions();

            // SET THE DEFAULT NAME
            CardName.Text = _user.PrimaryAddress.FullName;

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
                if (method.IsCreditOrDebitCard() && method.PaymentGateway != null)
                {
                    var provider = method.PaymentGateway.GetInstance();
                    if ((provider.SupportedTransactions & SupportedTransactions.RecurringBillingProfileManaged) == SupportedTransactions.RecurringBillingProfileManaged)
                    {
                        CardType.Items.Add(new ListItem(method.Name, method.Id.ToString()));
                        if (method.IsIntlDebitCard()) intlDebitCards.Add(method.Name);
                        else creditCards.Add(method.Name);
                    }
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
            SaveCardButton.OnClientClick = "if (Page_ClientValidate('" + this._ValidationGroup + "')) { this.value='Processing...';this.onclick=function(){return false;}; }";

            if (!Page.IsPostBack)
            {
                BindCards();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            DisableAutoComplete();

            if (AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled)
            {
                IList<PaymentMethod> methods = AbleCommerce.Code.StoreDataHelper.GetPaymentMethods(AbleContext.Current.UserId);
                IList<string> allowedMethods = methods.Where(m => m.AllowSubscriptions)
                    .Select(m => m.Name)
                    .ToList<string>();
                if (allowedMethods.Count > 0)
                {
                    SubscriptionProfilesNoticePH.Visible = true;
                    SubscriptionProfilesNoticeLabel.Text = string.Format(SubscriptionProfilesNoticeLabel.Text, String.Join(", ", allowedMethods.ToArray()));
                }
            }
        }
        
        protected void SaveCardButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && CustomValidation())
            {
                AccountDataDictionary cardDetails = new AccountDataDictionary();
                cardDetails["AccountName"] = CardName.Text.Trim();
                cardDetails["AccountNumber"] = CardNumber.Text.Trim();
                cardDetails["ExpirationMonth"] = ExpirationMonth.SelectedItem.Value;
                cardDetails["ExpirationYear"] = ExpirationYear.SelectedItem.Value;
                cardDetails["SecurityCode"] = SecurityCode.Text.Trim();
                PaymentMethod method = PaymentMethodDataSource.Load(AlwaysConvert.ToInt(CardType.SelectedValue));
                PaymentInstrumentData instr = PaymentInstrumentData.CreateInstance(cardDetails, method.PaymentInstrumentType, null);
                PaymentGateway gateway = method.PaymentGateway;
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
                                var match = Regex.Match(rsp.ResponseMessage, @"\d+", RegexOptions.IgnoreCase);
                                if(match.Success)
                                    customerProfileId = match.Value;
                                else
                                    ErrorMessage.Text = rsp.ResponseMessage;
                            }
                            else
                                ErrorMessage.Text = rsp.ResponseMessage;
                        }
                        catch(Exception exp)
                        {
                            ErrorMessage.Text = exp.Message;
                        }

                        if (string.IsNullOrEmpty(customerProfileId)) return;
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
                            if (_user.PaymentProfiles.Count == 0)
                            {
                                _user.Settings.DefaultPaymentProfileId = gwprofile.Id;
                                _user.Settings.Save();
                            }
                            CardName.Text = string.Empty;
                            CardNumber.Text = string.Empty;
                            ExpirationMonth.SelectedIndex = 0;
                            ExpirationYear.SelectedIndex = 0;
                            BindCards();
                        }
                        else
                        {
                            ErrorMessage.Text = rsp.ResponseMessage;
                            Logger.Error(rsp.ResponseMessage);
                        }
                    }
                    catch (Exception exp)
                    {
                        ErrorMessage.Text = exp.Message;
                    }
                }
            }
        }

        protected void BindCards()
        {
            var paymentProfiles = GatewayPaymentProfileDataSource.LoadForUser(_user.Id);
            CardsList.DataSource = paymentProfiles;
            CardsList.DataBind();
            NoPaymentTypePanel.Visible = paymentProfiles.Count == 0;
            SetDefaultButton.Visible = paymentProfiles.Count > 1;
            InstructionText.Visible = SetDefaultButton.Visible;
        }

        protected bool ShowSelectDefault()
        {
            return GatewayPaymentProfileDataSource.CountForUser(_user.Id) > 1;
        }

        protected bool IsDefaultProfile(int profileId) 
        {
            return _user.Settings.DefaultPaymentProfileId == profileId;
        }

        protected bool CanBeDeleted(int profileId) 
        {
            return _user.Subscriptions.Where(s => s.PaymentProfile != null && s.PaymentProfile.Id == profileId)
                .ToList()
                .Count == 0;
        }

        protected void SetDefaultButton_Click(object sender, EventArgs e)
        {
            foreach (RepeaterItem  item in CardsList.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    HiddenField hdnSelected = item.FindControl("HDNSelected") as HiddenField;
                    if (hdnSelected != null && hdnSelected.Value.ToLower().Equals("true"))
                    {
                        HiddenField hdnProfileId = item.FindControl("HDNProfileId") as HiddenField;
                        _user.Settings.DefaultPaymentProfileId = AlwaysConvert.ToInt(hdnProfileId.Value);
                        _user.Settings.Save();
                    }
                }
            }

            BindCards();
        }

        private bool CustomValidation()
        {
            bool hasErrors = false;

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
            SaveCardButton.ValidationGroup = _ValidationGroup;
        }

        protected string GetExpiration(object o)
        {
            GatewayPaymentProfile payment = o as GatewayPaymentProfile;
            return string.Format("{0:d}", payment.LastDayOfExpiry.HasValue ? payment.LastDayOfExpiry : payment.Expiry);
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

        protected void CardsList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DELETE_PROFILE")
            {
                int profileId = AlwaysConvert.ToInt(e.CommandArgument);
                if(profileId > 0 && CanBeDeleted(profileId))
                {
                    var profile = GatewayPaymentProfileDataSource.Load(profileId);
                    if (profile.Subscriptions.Count == 0)
                    {
                        int gatewayId = PaymentGatewayDataSource.GetPaymentGatewayIdByClassId(profile.GatewayIdentifier);
                        PaymentGateway gateway = PaymentGatewayDataSource.Load(gatewayId);
                        if (gateway != null)
                        {
                            var provider = gateway.GetInstance();
                            try
                            {
                                var rsp = provider.DoDeletePaymentProfile(new CommerceBuilder.Payments.Providers.DeletePaymentProfileRequest(AbleContext.Current.User, profile.CustomerProfileId, profile.PaymentProfileId));
                                if (rsp.Successful || rsp.ResponseCode == "E00040")
                                {
                                    int id = profile.Id;
                                    profile.Delete();
                                    BindCards();
                                }
                                else
                                {
                                    DeleteMessage.Text = string.Format("Somthing went wrong! Unable to remove profile '{0} ending in {1}'", profile.InstrumentType, profile.ReferenceNumber);
                                    Logger.Error(rsp.ResponseMessage);
                                }
                            }
                            catch (Exception exp)
                            {
                                Logger.Error(exp.Message);
                            }
                        }
                    }
                }
            }

            if (e.CommandName == "EDIT_PROFILE")
            {
                Response.Redirect(string.Format("~/Members/EditPaymentType.aspx?ProfileId={0}", e.CommandArgument));
            }
        }
    }
}