using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Stores;
using CommerceBuilder.Common;
using CommerceBuilder.Utility;
using CommerceBuilder.Messaging;

namespace AbleCommerce.Admin._Store
{
    public partial class Subscriptions : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;
            IList<EmailTemplate> emailTemplates = EmailTemplateDataSource.LoadAll();
            
            if (!Page.IsPostBack)
            {
                foreach (EmailTemplate template in emailTemplates)
                {
                    EnrollmentEmail.Items.Add(new ListItem(template.Name, template.Id.ToString()));
                    PaymentRemindersEmail.Items.Add(new ListItem(template.Name, template.Id.ToString()));
                    SubscriptionExpirationEmailTemplate.Items.Add(new ListItem(template.Name, template.Id.ToString()));
                    CancellationEmail.Items.Add(new ListItem(template.Name, template.Id.ToString()));
                    ExpiredEmail.Items.Add(new ListItem(template.Name, template.Id.ToString()));
                    SubscriptionChangedEmail.Items.Add(new ListItem(template.Name, template.Id.ToString()));
                }

                ROEnabledPanel.Visible = settings.ROCreateNewOrdersEnabled;
                RONotEnabledPanel.Visible = !ROEnabledPanel.Visible;
                EnableInstructions.Visible = false;
                LblEnabling.Visible = false;
                                
                // CreateNewOrders.Checked = settings.ROCreateNewOrdersEnabled;
                ListItem item = new ListItem();

                CreateNextOrderDays.Text = settings.ROCreateNextOrderDays.ToString();
                SubscriptionChangesDays.Text = settings.ROSubscriptionChangesDays.ToString();
                SubscriptionsCancellationDays.Text = settings.ROSubscriptionCancellationDays.ToString();                

                EnrollmentEmail.ClearSelection();
                item = EnrollmentEmail.Items.FindByValue(settings.ROSubscriptionEnrollmentEmailTemplateId.ToString());
                if (item != null) item.Selected = true;

                PaymentReminderDays.Text = settings.ROPaymentReminderIntervalDays.ToString();
                PaymentRemindersEmail.ClearSelection();
                item = PaymentRemindersEmail.Items.FindByValue(settings.ROPaymentReminderEmailTemplateId.ToString());
                if (item != null) item.Selected = true;

                /* Currently we do not have a separate email sending for failure of subscription payment
                item = PaymnetFailureEmail.Items.FindByValue(settings.ROPaymentFailEmailTemplateId.ToString());
                if (item != null) item.Selected = true;
                */

                if (!string.IsNullOrEmpty(settings.ROExpirationReminderEmailDays)) ExpirationReminderEmailIntervalDays.Text = settings.ROExpirationReminderEmailDays.ToString();

                SubscriptionExpirationEmailTemplate.ClearSelection();
                item = SubscriptionExpirationEmailTemplate.Items.FindByValue(settings.ROExpirationReminderEmailTemplateId.ToString());
                if (item != null) item.Selected = true;

                SubscriptionChangedEmail.ClearSelection();
                item = SubscriptionChangedEmail.Items.FindByValue(settings.ROSubscriptionUpdatedEmailTemplateId.ToString());
                if (item != null) item.Selected = true;

                CancellationEmail.ClearSelection();
                item = CancellationEmail.Items.FindByValue(settings.ROSubscriptionCancellationEmailTemplateId.ToString());
                if (item != null) item.Selected = true;

                ExpiredEmail.ClearSelection();
                item = ExpiredEmail.Items.FindByValue(settings.ROSubscriptionExpiredEmailTemplateId.ToString());
                if (item != null) item.Selected = true;

                IgnoreGatewayForPartialRecurSupport.Checked = settings.ROIgnoreGatewayForPartialRecurSupport;
                CreateOrdersForDetachedPayments.Checked = settings.ROCreateOrdersForDetachedPayments;
                trCreateOrdersForDetachedPayments.Visible = false;
                RecurringPaymentsWithoutCVVAllowed.Checked = settings.RORecurringPaymentsWithoutCVVAllowed;
                
                // SettingsPanel.Visible = CreateNewOrders.Checked;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Store store = AbleContext.Current.Store;
                StoreSettingsManager settings = store.Settings;

                // UPDATE SETTINGS
                // settings.ROCreateNewOrdersEnabled = CreateNewOrders.Checked;
                //if (CreateNewOrders.Checked)
                //{
                    settings.ROCreateNextOrderDays = AlwaysConvert.ToInt(CreateNextOrderDays.Text);
                    settings.ROSubscriptionChangesDays = AlwaysConvert.ToInt(SubscriptionChangesDays.Text);
                    settings.ROSubscriptionUpdatedEmailTemplateId = AlwaysConvert.ToInt(SubscriptionChangedEmail.SelectedValue);
                    settings.ROSubscriptionCancellationDays = AlwaysConvert.ToInt(SubscriptionsCancellationDays.Text);

                    settings.ROSubscriptionEnrollmentEmailTemplateId = AlwaysConvert.ToInt(EnrollmentEmail.SelectedValue);
                    settings.ROPaymentReminderIntervalDays = AlwaysConvert.ToInt(PaymentReminderDays.Text);
                    settings.ROPaymentReminderEmailTemplateId = AlwaysConvert.ToInt(PaymentRemindersEmail.SelectedValue);
                    //settings.ROPaymentFailEmailTemplateId = AlwaysConvert.ToInt(PaymnetFailureEmail.SelectedValue);
                    settings.ROExpirationReminderEmailDays = ExpirationReminderEmailIntervalDays.Text;
                    settings.ROExpirationReminderEmailTemplateId = AlwaysConvert.ToInt(SubscriptionExpirationEmailTemplate.SelectedValue);
                    settings.ROSubscriptionCancellationEmailTemplateId = AlwaysConvert.ToInt(CancellationEmail.SelectedValue);
                    settings.ROSubscriptionExpiredEmailTemplateId = AlwaysConvert.ToInt(ExpiredEmail.SelectedValue);
                    settings.ROIgnoreGatewayForPartialRecurSupport = IgnoreGatewayForPartialRecurSupport.Checked;
                    if (!IgnoreGatewayForPartialRecurSupport.Checked)
                        settings.ROCreateOrdersForDetachedPayments = CreateOrdersForDetachedPayments.Checked;
                    else
                        settings.ROCreateOrdersForDetachedPayments = false;
                    settings.RORecurringPaymentsWithoutCVVAllowed = RecurringPaymentsWithoutCVVAllowed.Checked;
                //}

                settings.Save();
                SavedMessage.Visible = true;
            }
        }

        /*
        protected void CreateNewOrders_CheckedChanged(object sender, EventArgs e)
        {
            SettingsPanel.Visible = CreateNewOrders.Checked;
        }
        */

        protected void IgnoreGatewayForPartialRecurSupport_CheckedChanged(object sender, EventArgs e)
        {
            trCreateOrdersForDetachedPayments.Visible = !IgnoreGatewayForPartialRecurSupport.Checked;
        }

        protected void EnableROFeature_Click(object sender, EventArgs e)
        {
            EnableInstructions.Visible = true;
            EnableROFeature.Visible = false;
            LblDisabled.Visible = false;
            LblEnabling.Visible = true;
        }

        protected void DisableROFeature_Click(object sender, EventArgs e)
        {
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;
            settings.ROCreateNewOrdersEnabled = false;
            settings.Save();

            ROEnabledPanel.Visible = false;
            RONotEnabledPanel.Visible = true;
            EnableInstructions.Visible = false;
            EnableROFeature.Visible = true;
            LblDisabled.Visible = true;
            LblEnabling.Visible = false;
        }

        protected void EnableROConfirm_Click(object sender, EventArgs e)
        {
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;
            settings.ROCreateNewOrdersEnabled = true;
            settings.Save();

            ROEnabledPanel.Visible = true;
            RONotEnabledPanel.Visible = false;
            EnableInstructions.Visible = false;
            LblEnabling.Visible = false;
        }

        protected void CancelROConfirm_Click(object sender, EventArgs e)
        {
            EnableInstructions.Visible = false;
            EnableROFeature.Visible = true;
            LblDisabled.Visible = true;
            LblEnabling.Visible = false;
        }
    }
}