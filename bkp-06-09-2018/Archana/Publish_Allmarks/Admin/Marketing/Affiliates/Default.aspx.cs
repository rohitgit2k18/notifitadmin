using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Extensions;
using CommerceBuilder.Marketing;
using CommerceBuilder.Orders;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.UI;

namespace AbleCommerce.Admin.Marketing.Affiliates
{
    public partial class _Default : AbleCommerceAdminPage
    {
        protected string ExpandIconUrl
        {
            get { return AbleCommerce.Code.NavigationHelper.GetThemeImageUrl("icons/plus.png"); }
        }

        protected string CollapseIconUrl
        {
            get { return AbleCommerce.Code.NavigationHelper.GetThemeImageUrl("icons/minus.png"); }
        }

        protected void AddAffiliateButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Affiliate affiliate = new Affiliate();
                affiliate.Name = AddAffiliateName.Text;
                affiliate.ReferralPeriod = AffiliateReferralPeriod.Persistent;
                affiliate.Save();
                Response.Redirect("EditAffiliate.aspx?AffiliateId=" + affiliate.Id.ToString());
            }
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            AbleCommerce.Code.PageHelper.SetDefaultButton(AddAffiliateName, AddAffiliateButton.ClientID);
            AddAffiliateName.Focus();

            if (!Page.IsPostBack)
            {
                Store store = AbleContext.Current.Store;
                StoreSettingsManager settings = store.Settings;

                AffiliateParameter.Text = settings.AffiliateParameterName;
                TrackerUrl.Text = settings.AffiliateTrackerUrl;

                // ENSURE THE CORRECT SETTING FORM ELEMENTS ARE DISPLAYED
                SelfSignup.Checked = settings.AffiliateAllowSelfSignup;
                ListItem itemAffiliatePersistence = AffiliatePersistence.Items.FindByValue(((byte)settings.AffiliatePersistence).ToString());
                if (itemAffiliatePersistence != null)
                {
                    AffiliatePersistence.SelectedIndex = AffiliatePersistence.Items.IndexOf(itemAffiliatePersistence);
                }
                ReferralPeriod.Text = settings.AffiliateReferralPeriod.ToString();
                CommissionRate.Text = settings.AffiliateCommissionRate.ToString();
                if (!settings.AffiliateCommissionIsPercent) CommissionType.SelectedIndex = 0;
                else CommissionType.SelectedIndex = (settings.AffiliateCommissionOnTotal ? 2 : 1);
                SelfSignup_CheckedChanged(sender, e);

                AffiliateReferralRule.SelectedIndex = (int)settings.AffiliateReferralRule;
            }
        }

        protected int GetOrderCount(object dataItem)
        {
            Affiliate a = (Affiliate)dataItem;
            return OrderDataSource.CountForAffiliate(a.Id);
        }

        protected int GetUserCount(object dataItem)
        {
            Affiliate a = (Affiliate)dataItem;
            return UserDataSource.CountForAffiliate(a.Id);
        }

        protected string GetHomeUrl(object dataItem)
        {
            Affiliate a = (Affiliate)dataItem;
            return string.Format("http://{0}{1}?{2}={3}", Request.Url.Authority, this.ResolveUrl(AbleCommerce.Code.NavigationHelper.GetHomeUrl()), AbleContext.Current.Store.Settings.AffiliateParameterName, a.Id);
        }

        protected string GetCommissionRate(object dataItem)
        {
            Affiliate affiliate = (Affiliate)dataItem;
            if (affiliate.CommissionIsPercent)
            {
                string format = "{0:0.##}% of {1}";
                if (affiliate.CommissionOnTotal) return string.Format(format, affiliate.CommissionRate, "order total");
                return string.Format(format, affiliate.CommissionRate, "product subtotal");
            }
            return string.Format("{0} per order", affiliate.CommissionRate.LSCurrencyFormat("lc"));
        }

        protected string GetPersistenceLabel(object dataItem)
        {
            Affiliate affiliate = (Affiliate)dataItem;
            switch (affiliate.ReferralPeriod)
            {
                case AffiliateReferralPeriod.FirstOrder:
                    return "First Order";
                case AffiliateReferralPeriod.NumberOfDays:
                    return "First " + affiliate.ReferralDays + " Days";
                case AffiliateReferralPeriod.FirstOrderWithinNumberOfDays:
                    return "First Order Within " + affiliate.ReferralDays + " Days";
                default:
                    return "Persistent";
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // UPDATE THE SETTINGS
                StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                settings.AffiliateParameterName = StringHelper.Truncate(AffiliateParameter.Text.Trim(), 200);
                settings.AffiliateTrackerUrl = StringHelper.Truncate(TrackerUrl.Text.Trim(), 200);
                settings.AffiliateAllowSelfSignup = SelfSignup.Checked;
                settings.AffiliateReferralRule = AlwaysConvert.ToEnum<ReferralRule>(AffiliateReferralRule.SelectedValue, ReferralRule.NewSignupsOnly);
                settings.AffiliatePersistence = ((AffiliateReferralPeriod)AlwaysConvert.ToByte(AffiliatePersistence.SelectedValue));
                AffiliateReferralPeriod referralPeriod = ((AffiliateReferralPeriod)AlwaysConvert.ToByte(AffiliatePersistence.SelectedValue));
                if ((referralPeriod != AffiliateReferralPeriod.Persistent && referralPeriod != AffiliateReferralPeriod.FirstOrder))
                {
                    settings.AffiliateReferralPeriod = AlwaysConvert.ToInt16(ReferralPeriod.Text);
                }
                else
                {
                    settings.AffiliateReferralPeriod = 0;
                }
                settings.AffiliateCommissionRate = AlwaysConvert.ToDecimal(CommissionRate.Text);
                settings.AffiliateCommissionIsPercent = (CommissionType.SelectedIndex > 0);
                settings.AffiliateCommissionOnTotal = (CommissionType.SelectedIndex == 2);
                settings.Save();
                AffiliateSettingsMessage.Text = string.Format(AffiliateSettingsMessage.Text, LocaleHelper.LocalNow);
                AffiliateSettingsMessage.Visible = true;
            }
        }

        protected void SelfSignup_CheckedChanged(object sender, EventArgs e)
        {
            trPersistence.Visible = SelfSignup.Checked;
            trCommissionRate.Visible = SelfSignup.Checked;
            if (SelfSignup.Checked) AffiliatePersistence_SelectedIndexChanged(sender, e);
            else trReferralPeriod.Visible = false;
        }

        protected void AffiliatePersistence_SelectedIndexChanged(Object sender, EventArgs e)
        {
            AffiliateReferralPeriod referralPeriod = (AffiliateReferralPeriod)AlwaysConvert.ToByte(AffiliatePersistence.SelectedValue);
            trReferralPeriod.Visible = (referralPeriod != AffiliateReferralPeriod.Persistent && referralPeriod != AffiliateReferralPeriod.FirstOrder);
            ReferralPeriod.Text = AbleContext.Current.Store.Settings.AffiliateReferralPeriod.ToString(); ;
        }
    }
}