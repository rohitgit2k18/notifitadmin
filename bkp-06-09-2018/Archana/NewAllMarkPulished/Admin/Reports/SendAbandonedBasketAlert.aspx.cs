using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.Mail;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Messaging;
using CommerceBuilder.Orders;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Reports
{
    public partial class SendAbandonedBasketAlert : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Basket _basket;

        protected void Page_PreInit(object sender, EventArgs e)
        {
            // READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = true;
        }

        protected void Page_SaveStateComplete(object sender, EventArgs e)
        {
            // END READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // locate basket for alert
            int basketId = AlwaysConvert.ToInt(Request.QueryString["BasketId"]);
            _basket = BasketDataSource.Load(basketId);
            if (_basket == null) Response.Redirect("MonthlyAbandonedBaskets.aspx");

            // see if we have an email template for abandoned alerts
            int templateId = AbleContext.Current.Store.Settings.AbandonedBasketAlertEmailTemplateId;
            EmailTemplate emailTemplate = EmailTemplateDataSource.Load(templateId);
            if (emailTemplate != null)
            {
                // initialize readonly display elements
                CustomerName.Text = _basket.User.PrimaryAddress.FullName;
                trCustomerName.Visible = !string.IsNullOrEmpty(CustomerName.Text);
                BasketContents.Text = GetBasketItems(_basket);
                LastActivity.Text = _basket.User.LastActivityDate.ToString();
                CancelButton.NavigateUrl += "?ReportDate=" + _basket.User.LastActivityDate.Value.ToShortDateString();

                // initialize form fields on first visit only
                if (!Page.IsPostBack)
                {
                    ToEmail.Text = _basket.User.GetBestEmailAddress();
                    Hashtable parameters = new Hashtable();
                    parameters.Add("store", AbleContext.Current.Store);
                    parameters.Add("customer", _basket.User);
                    parameters.Add("basket", _basket);
                    Subject.Text = NVelocityEngine.Instance.Process(parameters, emailTemplate.Subject);
                    if (!emailTemplate.IsHTML)
                    {
                        TextMessageContents.Text = NVelocityEngine.Instance.Process(parameters, emailTemplate.Body);
                        TextMessageContents.Visible = true;
                        HtmlMessageContents.Visible = false;
                    }
                    else
                    {
                        HtmlMessageContents.Value = NVelocityEngine.Instance.Process(parameters, emailTemplate.Body);
                    }
                }
            }
            else
            {
                SettingAlertPanel.Visible = true;
                SendAlertPanel.Visible = false;
            }
        }

        protected void SendButton_Click(Object sender, EventArgs e)
        {
            try
            {
                EmailTemplate emailTemplate = EmailTemplateDataSource.Load(AbleContext.Current.Store.Settings.AbandonedBasketAlertEmailTemplateId);
                string fromAddress = emailTemplate.FromAddress;
                if (fromAddress == "merchant")
                    fromAddress = AbleContext.Current.Store.Settings.DefaultEmailAddress;

                MailMessage mailMessage = new MailMessage();
                mailMessage.To.Add(new MailAddress(ToEmail.Text));
                mailMessage.From = new MailAddress(fromAddress);
                
                string[] ccAddresses = emailTemplate.CCList.Split(',');
                if (ccAddresses != null && ccAddresses.Length > 0)
                {
                    foreach (string ccAddress in ccAddresses)
                    {
                        if (ValidationHelper.IsValidEmail(ccAddress))
                            mailMessage.CC.Add(new MailAddress(ccAddress.Trim()));
                    }
                }

                string[] bccAddresses = emailTemplate.BCCList.Split(',');
                if (bccAddresses != null && bccAddresses.Length > 0)
                {
                    foreach (string bccAddress in bccAddresses)
                    {
                        if (ValidationHelper.IsValidEmail(bccAddress))
                            mailMessage.Bcc.Add(new MailAddress(bccAddress.Trim()));
                    }
                }

                mailMessage.Subject = Subject.Text;
                mailMessage.IsBodyHtml = emailTemplate.IsHTML;
                mailMessage.Body = emailTemplate.IsHTML ? HtmlMessageContents.Value : TextMessageContents.Text;
                EmailClient.Send(mailMessage);

                SendAlertPanel.Visible = false;
                ConfirmMessage.Text = string.Format(ConfirmMessage.Text, ToEmail.Text);
                ConfirmPanel.Visible = true;
                FinishButton.NavigateUrl += "?ReportDate=" + _basket.User.LastActivityDate.Value.ToShortDateString();
            }
            catch (Exception ex)
            {
                ErrorMessage.Text = "Error sending message: " + ex.Message;
                ErrorMessage.Visible = true;
                Logger.Error(ex.Message, ex);
            }
        }

        private string GetBasketItems(Basket basket)
        {
            List<string> basketItems = new List<string>();
            foreach (BasketItem basketItem in basket.Items)
            {
                if (basketItem.OrderItemType == OrderItemType.Product)
                {
                    basketItems.Add("[" + basketItem.Quantity + "]&nbsp;" + basketItem.Name);
                }
            }
            return string.Join(", ", basketItems.ToArray());
        }
    }
}