namespace AbleCommerce.Admin._Store.EmailTemplates
{
    using System;
    using System.Collections.Generic;
    using System.Net.Mail;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;

    public partial class Settings : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Store _Store;
        private StoreSettingsManager _Settings;

        protected void Page_Init(object sender, EventArgs e)
        {
            _Store = AbleContext.Current.Store;
            _Settings = _Store.Settings;

            // INITIALIZE GENERAL SETTINGS
            DefaultAddress.Text = _Settings.DefaultEmailAddress;
            SubscriptionAddress.Text = _Settings.SubscriptionEmailAddress;
            SubscriptionRequestExpirationDays.Text = _Settings.SubscriptionRequestExpirationDays.ToString();

            // BIND THE SEND TO FRIEND SELECTBOX
            IList<EmailTemplate> templates = EmailTemplateDataSource.LoadAll();
            EmailTemplatesList.DataSource = templates;
            EmailTemplatesList.DataBind();

            ContactUsEmailTemplatesList.DataSource = templates;
            ContactUsEmailTemplatesList.DataBind();

            // BIND EMAIL TEMPLATES FOR ABANDONED BASKETS ALERT
            AbandonedBasketEmailTemplateList.DataSource = templates;
            AbandonedBasketEmailTemplateList.DataBind();

            // BIND THE DEFAULT EMAIL LIST SELECTBOX
            IList<EmailList> emailLists = EmailListDataSource.LoadAll();
            DefaultEmailList.DataSource = emailLists;
            DefaultEmailList.DataBind();

            // INITIALIZE SERVER CONFIGURATION
            SmtpServer.Text = _Settings.SmtpServer;
            if (String.IsNullOrEmpty(_Settings.SmtpPort)) SmtpPort.Text = "25";
            else SmtpPort.Text = _Settings.SmtpPort;
            SmtpEnableSSL.Checked = _Settings.SmtpEnableSSL;
            SmtpUserName.Text = _Settings.SmtpUserName;
            RequiresAuth.Checked = _Settings.SmtpRequiresAuthentication;

            // DISABLE SCROLLING DURING VALIDATION
            AbleCommerce.Code.PageHelper.DisableValidationScrolling(this.Page);
        }

        /// <summary>
        /// Saves the general settings
        /// </summary>
        private void SaveGeneralSettings()
        {
            string oldDefaultAddress = string.Empty;
            oldDefaultAddress = _Settings.DefaultEmailAddress;
            _Settings.DefaultEmailAddress = DefaultAddress.Text;
            _Settings.SubscriptionEmailAddress = SubscriptionAddress.Text;
            _Settings.SubscriptionRequestExpirationDays = AlwaysConvert.ToInt(SubscriptionRequestExpirationDays.Text);
            _Settings.DefaultEmailListId = AlwaysConvert.ToInt(DefaultEmailList.SelectedValue);
            _Settings.ProductTellAFriendEmailTemplateId = AlwaysConvert.ToInt(EmailTemplatesList.SelectedValue);
            _Settings.AbandonedBasketAlertEmailTemplateId = AlwaysConvert.ToInt(AbandonedBasketEmailTemplateList.SelectedValue);
            _Settings.ContactUsConfirmationEmailTemplateId = AlwaysConvert.ToInt(ContactUsEmailTemplatesList.SelectedValue);
            _Settings.ProductTellAFriendCaptcha = TellAFriendCaptcha.Checked;
            _Settings.Save();
        }

        /// <summary>
        /// Saves the SMTP settings
        /// </summary>
        private void SaveSmtpSettings()
        {
            _Settings.SmtpServer = SmtpServer.Text;
            _Settings.SmtpPort = SmtpPort.Text;
            _Settings.SmtpEnableSSL = SmtpEnableSSL.Checked;
            _Settings.SmtpUserName = SmtpUserName.Text;
            _Settings.SmtpPassword = SmtpPassword.Text;
            _Settings.SmtpRequiresAuthentication = RequiresAuth.Checked;
            _Settings.Save();
        }

        protected void SaveGeneralButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveGeneralSettings();
                GeneralSavedMessage.Text = string.Format(GeneralSavedMessage.Text, LocaleHelper.LocalNow);
                GeneralSavedMessage.Visible = true;
            }
        }

        protected void SaveSmtpButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveSmtpSettings();
                SmtpSavedMessage.Text = string.Format(SmtpSavedMessage.Text, LocaleHelper.LocalNow);
                SmtpSavedMessage.Visible = true;
            }
        }

        /// <summary>
        /// Gets the most appropriate 'from' address to use with the test email
        /// </summary>
        /// <returns>A string containing the most appropriate 'from' address</returns>
        private string FindFromAddress()
        {
            if (!string.IsNullOrEmpty(_Settings.SubscriptionEmailAddress))
            {
                return _Settings.SubscriptionEmailAddress;
            }
            if (!string.IsNullOrEmpty(_Settings.DefaultEmailAddress))
            {
                return _Settings.DefaultEmailAddress;
            }
            return TestSendTo.Text;
        }

        protected void SendTestButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // CREATE THE MAIL MESSAGE INSTANCE
                MailMessage mailMessage = new MailMessage();
                mailMessage.From = new MailAddress(FindFromAddress());
                mailMessage.To.Add(TestSendTo.Text);
                mailMessage.Subject = _Store.Name + ": SMTP Settings Updated";
                mailMessage.Body = string.Format("The SMTP Settings for {0} were recently updated.  Receipt of this email confirms the new settings are working properly.", _Store.Name);

                // PREPARE THE SMTP SETTINGS
                SmtpSettings smtpSettings = SmtpSettings.DefaultSettings;
                smtpSettings.Server = _Settings.SmtpServer;
                smtpSettings.Port = AlwaysConvert.ToInt(_Settings.SmtpPort, 25);
                smtpSettings.EnableSSL = _Settings.SmtpEnableSSL;
                if (_Settings.SmtpRequiresAuthentication)
                {
                    smtpSettings.RequiresAuthentication = true;
                    smtpSettings.UserName = _Settings.SmtpUserName;
                    smtpSettings.Password = _Settings.SmtpPassword;
                }

                // ATTEMPT TO SEND THE TEST MESSAGE
                Label resultMessage = new Label();
                try
                {
                    EmailClient.Send(mailMessage, smtpSettings, true);
                    resultMessage.SkinID = "GoodCondition";
                    resultMessage.Text = string.Format("Test message has been sent to '{0}'.", TestSendTo.Text);
                }
                catch (Exception ex)
                {
                    resultMessage.SkinID = "ErrorCondition";
                    resultMessage.Text = string.Format("Test message resulted in error: " + ex.Message);
                }
                TestSendTo.Text = string.Empty;
                TestResultPanel.Controls.Add(resultMessage);
            }
        }

        protected void RemoveButton_Click(object sender, EventArgs e)
        {
            SmtpServer.Text = String.Empty;
            SmtpPort.Text = string.Empty;
            SmtpEnableSSL.Checked = false;
            SmtpUserName.Text = String.Empty;
            SmtpPassword.Text = String.Empty;
            RequiresAuth.Checked = false;
            SaveSmtpSettings();
            WarningLabel.Visible = true;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // SET THE SMTP PASSWORD FIELD VALUE
            if (!string.IsNullOrEmpty(_Settings.SmtpPassword))
            {
                SmtpPassword.Attributes["Value"] = _Settings.SmtpPassword;
            }

            // SELECT THE TELL A FRIEND EMAIL TEMPLATE
            int templateId = _Settings.ProductTellAFriendEmailTemplateId;
            ListItem item = EmailTemplatesList.Items.FindByValue(templateId.ToString());
            if (item != null) EmailTemplatesList.SelectedIndex = EmailTemplatesList.Items.IndexOf(item);
            TellAFriendCaptcha.Checked = _Settings.ProductTellAFriendCaptcha;

            //SELECT ABANDONED BASKET ALERT TEMPLATE
            item = null;
            item = AbandonedBasketEmailTemplateList.Items.FindByValue(_Settings.AbandonedBasketAlertEmailTemplateId.ToString());
            if (item != null) item.Selected = true;

            //SELECT CONTACT US CONFIRMATION EMAIL TEMPLATE
            item = null;
            item = ContactUsEmailTemplatesList.Items.FindByValue(_Settings.ContactUsConfirmationEmailTemplateId.ToString());
            if (item != null) item.Selected = true;

            // SELECT THE DEFAULT EMAIL LIST
            int listId = _Settings.DefaultEmailListId;
            item = DefaultEmailList.Items.FindByValue(listId.ToString());
            if (item != null) DefaultEmailList.SelectedIndex = DefaultEmailList.Items.IndexOf(item);

            // SHOW/HIDE REMOVE SETTINGS BUTTON
            RemoveButton.Visible = !string.IsNullOrEmpty(SmtpServer.Text);
            TestPanel.Visible = RemoveButton.Visible;
        }
    }
}
