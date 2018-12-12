namespace AbleCommerce.Members
{
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class EditPaymentType : CommerceBuilder.UI.AbleCommercePage
    {
        private int _profileId;
        private GatewayPaymentProfile _profile = null;

        protected void Page_Load(object sender, EventArgs e) 
        {
            _profileId = AlwaysConvert.ToInt(Request.QueryString["ProfileId"]);
            _profile = GatewayPaymentProfileDataSource.Load(_profileId);
            
            if(_profile == null || _profile.User != AbleContext.Current.User)
                Response.Redirect("PaymentTypes.aspx");

            if (!Page.IsPostBack)
            {
                CardType.Text = _profile.InstrumentType.ToString();
                CardName.Text = _profile.NameOnCard;
                CardNumber.Text = _profile.ReferenceNumber.PadLeft(8, 'x').ToUpper();

                // POPULATE EXPIRATON DATE DROPDOWN
                int thisYear = LocaleHelper.LocalNow.Year;
                for (int i = 0; (i <= 10); i++)
                {
                    ExpirationYear.Items.Add(new ListItem((thisYear + i).ToString()));
                }

                DateTime expirationDate = _profile.Expiry ?? DateTime.MinValue;
                if (expirationDate != DateTime.MinValue)
                {
                    string eMonth = expirationDate.Month.ToString().PadLeft(2, '0');
                    string eYear = expirationDate.Year.ToString();
                    ListItem item = ExpirationYear.Items.FindByValue(eYear);
                    if (item != null)
                        item.Selected = true;
                    item = ExpirationMonth.Items.FindByValue(eMonth);
                    if (item != null)
                        item.Selected = true;
                }
            }
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                int gatewayId = PaymentGatewayDataSource.GetPaymentGatewayIdByClassId(_profile.GatewayIdentifier);
                PaymentGateway gateway = PaymentGatewayDataSource.Load(gatewayId);
                if (gateway != null)
                {
                    var provider = gateway.GetInstance();
                    try
                    {
                        AccountDataDictionary cardDetails = new AccountDataDictionary();
                        cardDetails["AccountNumber"] = _profile.ReferenceNumber.PadLeft(8, 'x').ToUpper();
                        cardDetails["ExpirationMonth"] = ExpirationMonth.SelectedValue;
                        cardDetails["ExpirationYear"] = ExpirationYear.SelectedValue;
                        cardDetails["SecurityCode"] = SecurityCode.Text;
                        PaymentInstrumentData instr = PaymentInstrumentData.CreateInstance(cardDetails, _profile.InstrumentType, null);
                        var rsp = provider.DoUpdatePaymentProfile(new CommerceBuilder.Payments.Providers.UpdatePaymentProfileRequest(AbleContext.Current.User, instr, _profile.CustomerProfileId, _profile.PaymentProfileId));
                        if (rsp.Successful || rsp.ResponseCode == "E00040")
                        {
                            _profile.Expiry = Misc.GetStartOfDate(new DateTime(AlwaysConvert.ToInt(ExpirationYear.SelectedValue), AlwaysConvert.ToInt(ExpirationMonth.SelectedValue), 1));
                            _profile.Save();
                            SuccessMessage.Text = string.Format(SuccessMessage.Text, LocaleHelper.LocalNow);
                            SuccessMessage.Visible = true;
                        }
                        else
                        {
                            ErrorMessage.Visible = true;
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
}