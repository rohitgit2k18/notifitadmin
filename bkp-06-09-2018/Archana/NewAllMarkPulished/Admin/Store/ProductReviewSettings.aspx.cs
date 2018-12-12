namespace AbleCommerce.Admin._Store
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Collections.Generic;

    public partial class ProductReviewSettings : CommerceBuilder.UI.AbleCommerceAdminPage
    {

        protected void Page_Init(object sender, System.EventArgs e)
        {
            IList<EmailTemplate> templates = EmailTemplateDataSource.LoadAll("Name");
            EmailTemplate.DataSource = templates;
            EmailTemplate.DataBind();
            AllEmailTemplates.DataSource = templates;
            AllEmailTemplates.DataBind();

            AbleCommerce.Code.PageHelper.SetHtmlEditor(TermsAndConditions, TermsAndConditionsHtml);
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //INITIALIZE FORM
                StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                ListItem item;
                item = Enabled.Items.FindByValue(((int)settings.ProductReviewEnabled).ToString());
                if (item != null) item.Selected = true;
                item = Approval.Items.FindByValue(((int)settings.ProductReviewApproval).ToString());
                if (item != null) item.Selected = true;
                item = ImageVerification.Items.FindByValue(((int)settings.ProductReviewImageVerification).ToString());
                if (item != null) item.Selected = true;
                item = EmailVerification.Items.FindByValue(((int)settings.ProductReviewEmailVerification).ToString());
                if (item != null) item.Selected = true;
                item = EmailTemplate.Items.FindByValue(settings.ProductReviewEmailVerificationTemplate.ToString());
                if (item != null) item.Selected = true;
                item = AllEmailTemplates.Items.FindByValue(settings.ProductReviewReminderEmailTemplate.ToString());
                if (item != null) item.Selected = true;
                TermsAndConditions.Text = settings.ProductReviewTermsAndConditions;

                EnableProductReviewReminders.Checked = settings.ProductReviewReminderEnabled;
                NotBeforeDays.Text = settings.ProductReviewReminderBeforeDays.ToString();
                NotAfterDays.Text = settings.ProductReviewReminderAfterDays.ToString();
                RunDays.Text = settings.ProductReviewReminderRunDays.ToString();
            }
        }

        private void SaveSettings()
        {
            //Load store and update
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            settings.ProductReviewEnabled = (UserAuthFilter)AlwaysConvert.ToInt(Enabled.SelectedValue);
            settings.ProductReviewApproval = (UserAuthFilter)AlwaysConvert.ToInt(Approval.SelectedValue);
            settings.ProductReviewImageVerification = (UserAuthFilter)AlwaysConvert.ToInt(ImageVerification.SelectedValue);
            settings.ProductReviewEmailVerification = (UserAuthFilter)AlwaysConvert.ToInt(EmailVerification.SelectedValue);

            settings.ProductReviewReminderEnabled = EnableProductReviewReminders.Checked;
            settings.ProductReviewReminderBeforeDays = AlwaysConvert.ToInt(NotBeforeDays.Text);
            settings.ProductReviewReminderAfterDays = AlwaysConvert.ToInt(NotAfterDays.Text);
            settings.ProductReviewReminderRunDays = AlwaysConvert.ToInt(RunDays.Text);
            settings.ProductReviewEmailVerificationTemplate = AlwaysConvert.ToInt(EmailTemplate.SelectedValue);
            settings.ProductReviewTermsAndConditions = TermsAndConditions.Text;
            settings.ProductReviewReminderEmailTemplate = AlwaysConvert.ToInt(AllEmailTemplates.SelectedValue);
            settings.Save();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            SaveSettings();
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            SavedMessage.Visible = true;
        }

        protected void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            SaveSettings();
            Response.Redirect("../Default.aspx");
        }

    }
}