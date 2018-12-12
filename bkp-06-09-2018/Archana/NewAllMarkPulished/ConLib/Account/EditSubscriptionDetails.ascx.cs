using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Users;
using System.Web.UI.WebControls.WebParts;
using System.ComponentModel;
using CommerceBuilder.DomainModel;
using CommerceBuilder.Orders;
using CommerceBuilder.Common;
using CommerceBuilder.Utility;
using CommerceBuilder.Payments;
using CommerceBuilder.Messaging;

namespace AbleCommerce.ConLib.Account
{
    public partial class EditSubscriptionDetails : System.Web.UI.UserControl
    {
        public event EditShipAddressEventHandler OnEditShipAddress;
        public event EditBillAddressEventHandler OnEditBillAddress;
        public event EditPaymentInfoEventHandler OnEditPaymentInfo;
        public event EditCardInfoEventHandler OnEditCardInfo;

        int _SubscriptionId = 0;
        int _ProfileId = 0;
        Subscription _Subscription = null;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("0")]
        [Description("The Subscription Id for which to show the details.")]
        public int SubscriptionId
        {
            get { return _SubscriptionId; }
            set { _SubscriptionId = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _Subscription = EntityLoader.Load<Subscription>(this.SubscriptionId);

            if (_Subscription != null)
            {
                tdPaymentPanel.Visible = _Subscription.PaymentProfile != null;

                if (tdPaymentPanel.Visible)
                    _ProfileId = _Subscription.PaymentProfile.Id;
            }

            var targetID = Request.Form["__EVENTTARGET"];
            if (targetID.EndsWith("$ChangeButton") && _Subscription.PaymentProfile != null)
            {
                BindCardTypes();
                int thisYear = LocaleHelper.LocalNow.Year;
                for (int i = 0; (i <= 10); i++)
                {
                    ExpirationYear.Items.Add(new ListItem((thisYear + i).ToString()));
                }

                BindPayments();
            }
        }

        protected void BindPayments(int profileId = 0) 
        {
            PreferedCreditCard.DataBind();
            if (PreferedCreditCard.Items.Count > 1)
            {
                if (profileId == 0)
                    profileId = _Subscription.PaymentProfile.Id;
                
                ListItem item = PreferedCreditCard.Items.FindByValue(profileId.ToString());
                if (item != null)
                {
                    item.Selected = true;
                    var profile = _Subscription.User.PaymentProfiles.Where(p => p.Id == Convert.ToInt32(item.Value))
                        .SingleOrDefault();

                    RemoveCardButton.Visible = profile != null && profile.Subscriptions.Count == 0;
                }
                else
                    RemoveCardButton.Visible = false;

                PreferedCreditCard.Visible = true;
                PaymentProfilePH.Controls.Clear();
                UpdateCardButton.Visible = true;
            }
            else
            {
                if(_Subscription.PaymentProfile != null)
                    PaymentProfilePH.Controls.Add(new LiteralControl(string.Format("<b>{0}</b>", _Subscription.PaymentProfile.NameWithReference)));
                PreferedCreditCard.Visible = false;
                UpdateCardButton.Visible = false;
                RemoveCardButton.Visible = false;
            }          
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (_Subscription != null)
            {
                BillAddress.Text = _Subscription.FormatBillAddress(true);
                ShipAddress.Text = _Subscription.FormatShipAddress(true);
                if (ShipAddress.Text == "N/A") 
                    EditShipAddressLink.Visible = false;
            }

            var targetID = Request.Form["__EVENTTARGET"];
            if (targetID.EndsWith("$SaveCardButton"))
            {
                BindPayments();
            }

            EditProfileButton.Visible = _ProfileId > 0;

            DisableAutoComplete();
        }

        protected void UpdateCardButton_Click(object sender, EventArgs e) 
        {
            int profileId = AlwaysConvert.ToInt(PreferedCreditCard.SelectedValue);
            if (profileId > 0)
            {
                _Subscription.PaymentProfile = GatewayPaymentProfileDataSource.Load(profileId);
                IList<PaymentMethod> methods = AbleCommerce.Code.StoreDataHelper.GetPaymentMethods(AbleContext.Current.UserId);
                PaymentMethod newPaymentMethod = null;
                if (string.IsNullOrEmpty(_Subscription.PaymentProfile.PaymentMethodName))
                    newPaymentMethod = methods.Where(m => m.PaymentInstrumentType == _Subscription.PaymentProfile.InstrumentType).FirstOrDefault();
                else
                    newPaymentMethod = methods.Where(m => m.Name == _Subscription.PaymentProfile.PaymentMethodName).SingleOrDefault();

                if (newPaymentMethod != null)
                    _Subscription.PaymentMethod = newPaymentMethod;

                try
                {
                    EmailProcessor.NotifySubscriptionUpdated(_Subscription);
                }
                catch (Exception ex)
                {
                    Logger.Error("Error sending subscription updated email.", ex);
                }

                _Subscription.Save();
                BindPayments(profileId);
                CreditCardMessagePH.Visible = true;
            }
        }

        protected void RemoveCardButton_Click(object sender, EventArgs e) 
        {
            int profileId = AlwaysConvert.ToInt(PreferedCreditCard.SelectedValue);
            if (profileId > 0)
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
                                profile.Delete();
                                BindPayments();
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

        protected void EditShipAddressLink_Click(object sender, EventArgs e)
        {
            BindPayments();
            if (OnEditShipAddress != null) OnEditShipAddress(this, new SubscriptionDetailEventArgs(this.SubscriptionId));
        }

        protected void EditBillAddressLink_Click(object sender, EventArgs e)
        {
            BindPayments();
            if (OnEditBillAddress != null) OnEditBillAddress(this, new SubscriptionDetailEventArgs(this.SubscriptionId));
        }

        protected void AddPaymentLink_Click(object sender, EventArgs e)
        {
            BindPayments();
            AddCardPopup.Show();
        }
        
        protected void EditPaymentMethodLink_Click(object sender, EventArgs e)
        {
            if (OnEditPaymentInfo != null) OnEditPaymentInfo(this, new SubscriptionDetailEventArgs(this.SubscriptionId));
        }

        protected void GatewayProfilesDS_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["userId"] = AbleContext.Current.UserId;
        }

        protected void PreferedCreditCard_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindPayments(AlwaysConvert.ToInt(PreferedCreditCard.SelectedValue));
        }

        protected void BindCardTypes()
        {
            // LOAD AVAILABLE PAYMENT METHODS
            IList<PaymentMethod> methods = AbleCommerce.Code.StoreDataHelper.GetPaymentMethods(AbleContext.Current.UserId);
            foreach (PaymentMethod method in methods)
            {
                if (method.IsCreditOrDebitCard())
                {
                    if (_Subscription.SubscriptionPlan != null && _Subscription.SubscriptionPlan.IsRecurring)
                    {
                        if (method.AllowSubscriptions || !AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled)
                            CardType.Items.Add(new ListItem(method.Name, method.Id.ToString()));    
                    }
                    else
                        CardType.Items.Add(new ListItem(method.Name, method.Id.ToString()));
                }
            }
        }

        protected void SaveCardButton_Click(Object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                GatewayPaymentProfile profile = _Subscription.PaymentProfile;
                if (profile != null)
                {
                    AccountDataDictionary cardDetails = new AccountDataDictionary();
                    cardDetails["AccountName"] = CardName.Text.Trim();
                    cardDetails["AccountNumber"] = CardNumber.Text.Trim();
                    cardDetails["ExpirationMonth"] = ExpirationMonth.SelectedItem.Value;
                    cardDetails["ExpirationYear"] = ExpirationYear.SelectedItem.Value;
                    cardDetails["SecurityCode"] = SecurityCode.Text.Trim();
                    PaymentMethod method = PaymentMethodDataSource.Load(AlwaysConvert.ToInt(CardType.SelectedValue));
                    PaymentInstrumentData instr = PaymentInstrumentData.CreateInstance(cardDetails, method.PaymentInstrumentType, null);
                    int gatewayId = PaymentGatewayDataSource.GetPaymentGatewayIdByClassId(_Subscription.PaymentProfile.GatewayIdentifier);
                    PaymentGateway gateway = PaymentGatewayDataSource.Load(gatewayId);
                    if (gateway != null)
                    {
                        var provider = gateway.GetInstance();
                        try
                        {
                            var rsp = provider.DoCreatePaymentProfile(new CommerceBuilder.Payments.Providers.CreatePaymentProfileRequest(_Subscription.User, instr, profile.CustomerProfileId) { ValidateProfile = true });
                            if (rsp.Successful)
                            {
                                GatewayPaymentProfile gwprofile = new GatewayPaymentProfile();
                                gwprofile.NameOnCard = CardName.Text.Trim(); ;
                                gwprofile.Expiry = Misc.GetStartOfDate(new DateTime(AlwaysConvert.ToInt(ExpirationYear.SelectedItem.Value), AlwaysConvert.ToInt(ExpirationMonth.SelectedItem.Value), 1));
                                gwprofile.CustomerProfileId = profile.CustomerProfileId;
                                gwprofile.PaymentProfileId = rsp.PaymentProfileId;
                                gwprofile.ReferenceNumber = StringHelper.MakeReferenceNumber(cardDetails["AccountNumber"]);
                                gwprofile.User = _Subscription.User;
                                gwprofile.InstrumentType = instr.InstrumentType;
                                gwprofile.GatewayIdentifier = profile.GatewayIdentifier;
                                gwprofile.Save();
                                BindPayments(gwprofile.Id);
                                CardName.Text = string.Empty;
                                CardNumber.Text = string.Empty;
                                ExpirationMonth.SelectedIndex = 0;
                                ExpirationYear.SelectedIndex = 0;
                                AddCardPopup.Hide();
                            }
                            else
                            {
                                ErrorMessage.Text = rsp.ResponseMessage;
                                AddCardPopup.Show();
                            }
                        }
                        catch (Exception exp)
                        {
                            Logger.Error(exp.Message);
                            ErrorMessage.Text = exp.Message;
                            AddCardPopup.Show();
                        }
                    }

                    BindPayments(profile.Id);
                }
            }
            else
            {
                AddCardPopup.Show();
            }
        }

        private void DisableAutoComplete()
        {
            CardNumber.Attributes.Add("autocomplete", "off");
            CardNumber.Text = string.Empty;
            SecurityCode.Attributes.Add("autocomplete", "off");
            SecurityCode.Text = string.Empty;
        }

        protected void GatewayProfilesDS_Selected(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.ReturnValue != null)
            {
                IList<GatewayPaymentProfile> profiles = (IList<GatewayPaymentProfile>)e.ReturnValue;
                if (profiles.Count > 0)
                {
                    IList<string> methods = AbleCommerce.Code.StoreDataHelper.GetPaymentMethods(AbleContext.Current.UserId)
                        .Where(m => m.AllowSubscriptions)
                        .Select(m => m.Name.ToLower())
                        .ToList();

                    List<GatewayPaymentProfile> toBeRemoved = new List<GatewayPaymentProfile>();
                    foreach (var profile in profiles)
                    {
                        if (!string.IsNullOrEmpty(profile.PaymentMethodName) && !methods.Contains(profile.PaymentMethodName.ToLower()))
                            toBeRemoved.Add(profile);
                    }

                    foreach (var profile in toBeRemoved)
                        profiles.Remove(profile);
                }
            }
        }

        protected void EditProfileButton_Click(object sender, EventArgs e)
        { 
            BindPayments(_ProfileId);
            if (OnEditCardInfo != null) OnEditCardInfo(this, new CardInfoDetailEventArgs(_ProfileId));
        }
    }

    public class SubscriptionDetailEventArgs : EventArgs
    {
        public int SubscriptionId { get; set; }

        public SubscriptionDetailEventArgs(int subscriptionId)
        {
            this.SubscriptionId = subscriptionId;
        }
    }

    public class CardInfoDetailEventArgs : EventArgs
    {
        public int ProfileId { get; set; }

        public CardInfoDetailEventArgs(int profileId)
        {
            this.ProfileId = profileId;
        }
    }

    public delegate void EditShipAddressEventHandler(Object sender, SubscriptionDetailEventArgs e);
    public delegate void EditBillAddressEventHandler(Object sender, SubscriptionDetailEventArgs e);
    public delegate void EditPaymentInfoEventHandler(Object sender, SubscriptionDetailEventArgs e);
    public delegate void EditEmailReminderEventHandler(Object sender, SubscriptionDetailEventArgs e);
    public delegate void EditCardInfoEventHandler(Object sender, CardInfoDetailEventArgs e);
}