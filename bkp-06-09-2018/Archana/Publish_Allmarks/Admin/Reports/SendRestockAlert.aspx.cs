namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Net.Mail;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Products;

    public partial class SendRestockAlert : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        /// <summary>
        ///  Contains a list of subscribers for restock notification
        /// </summary>
        private IList<RestockNotify> _RestockNotifyList;

        protected void Page_Init(object sender, EventArgs e)
        {
            // WARN IF SMTP SERVER NOT CONFIGURED
            if (IsSmtpServerConfigured())
            {
                // FIND THE DATASOURCE FOR THE EMAILS
                LocateRecipientSource();

                // INITIALIZE THE EMAIL TEMPLATES
                EmailTemplates.DataSource = EmailTemplateDataSource.LoadAll("Name");
                EmailTemplates.DataBind();
                EmailTemplates.Attributes.Add("onchange", "if(!confirm('Changing the email template will reset any message text entered below.  Continue?')) return false;");

                // INITIALIZE THE MAIL FORM
                ToAddress.Text = GetRecipientList();
                if (!Page.IsPostBack)
                {
                    FromAddress.Text = AbleContext.Current.Store.Settings.DefaultEmailAddress;
                }
                MailFormat.Attributes.Add("onchange", "$get('" + MessageHtml.ClientID + "').style.visibility=(this.selectedIndex==0?'visible':'hidden');");
                MessageHtml.OnClientClick = "if(/^\\s*#.*?\\n/gm.test($get('" + Message.ClientID + "').value)){if(!confirm('WARNING: HTML editor may corrupt NVelocity script if you make changes in WYSIWYG mode.  Continue?'))return false;}";
                AbleCommerce.Code.PageHelper.SetHtmlEditor(Message, MessageHtml);

                // SHOW/hide the restock notification subscriptions removal option
                trRemoveNotificationSubscriptions.Visible = _RestockNotifyList != null;
            }
            else
            {
                // SMTP IS NOT CONFIGURED
                ComposePanel.Visible = false;
                PreviewPanel.Visible = false;
                ConfirmationPanel.Visible = false;
                SmtpErrorPanel.Visible = true;
            }

            // SET CANCEL LINKS TO CALLING PAGE
            OKButton.NavigateUrl = GetReturnUrl();
            CancelLink.NavigateUrl = GetReturnUrl();
        }

        #region Recipient Methods

        /// <summary>
        /// Locate the datasource that determines the message recipients
        /// </summary>
        private void LocateRecipientSource()
        {
            // LOCATE AN IDLIST FROM SESSION DATA
            string sessionIdList = string.Empty;

            // OBTAIN Product Variant ID FROM QUERY STRING
            int productVariantId = AlwaysConvert.ToInt(Request.QueryString["ProductVariantId"]);

            if (!string.IsNullOrEmpty(Request.QueryString["ProductId"]) && productVariantId > 0)
            {
                sessionIdList = "ProductVariantId:" + productVariantId.ToString();
            }            
            else if (!string.IsNullOrEmpty(Request.QueryString["ProductId"]))
            {
                // OBTAIN Product ID FROM QUERY STRING
                int productId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
                sessionIdList = "ProductId:" + productId.ToString();
            }

            // ATTEMPT TO PARSE DATASET
            if (!string.IsNullOrEmpty(sessionIdList))
            {
                Match idListMatch = Regex.Match(sessionIdList, @"^(ProductId|ProductVariantId):(\d+(?:,\d+)*)$", RegexOptions.IgnoreCase);
                if (idListMatch.Success)
                {
                    string idList = idListMatch.Groups[2].Value;
                    switch (idListMatch.Groups[1].Value.ToLowerInvariant())
                    {
                        case "productid":
                            ParseProductIdList(idList);
                            break;
                        case "productvariantid":
                            ParseProductVariantIdList(idList);
                            break;
                    }
                }
            }

            // VERIFY A DATASET WAS FOUND, IF NOT RETURN TO CALLING PAGE
            bool foundRestockNotifyList = (_RestockNotifyList != null && _RestockNotifyList.Count > 0);
            bool foundRecipientSource = foundRestockNotifyList;
            if (!foundRecipientSource) RedirectMe();
        }

        /// <summary>
        /// Load restock notification list for the product id
        /// </summary>
        /// <param name="idList">List of product ids</param>
        private void ParseProductIdList(string idList)
        {
            // VALIDATE THE INPUT
            if (string.IsNullOrEmpty(idList))
                throw new ArgumentNullException("idList");
            if (!Regex.IsMatch(idList, "^\\d+(,\\d+)*$"))
                throw new ArgumentException("Id list can only be a comma delimited list of integer.", "idList");


            // there should be a single id
            _RestockNotifyList = RestockNotifyDataSource.LoadForProduct(AlwaysConvert.ToInt(idList));
        }

        /// <summary>
        /// Load product variants in the id list
        /// </summary>
        /// <param name="idList">List of product variant ids</param>
        private void ParseProductVariantIdList(string idList)
        {
            // VALIDATE THE INPUT
            if (string.IsNullOrEmpty(idList))
                throw new ArgumentNullException("idList");
            if (!Regex.IsMatch(idList, "^\\d+(,\\d+)*$"))
                throw new ArgumentException("Id list can only be a comma delimited list of integer.", "idList");


            // there should be a single id
            _RestockNotifyList = RestockNotifyDataSource.LoadForProductVariant(AlwaysConvert.ToInt(idList));
        }

        /// <summary>
        /// Gets a list of recipients suitable for display.
        /// </summary>
        /// <returns>A list of recipeints suitable for display.</returns>
        private string GetRecipientList()
        {
            List<string> recipientList = new List<string>();

            if (_RestockNotifyList != null)
            {
                foreach (RestockNotify notification in _RestockNotifyList)
                {
                    recipientList.Add(notification.Email);
                }
            }

            string recipients = string.Join(", ", recipientList.ToArray());
            if (recipients.Length > 500) recipients = StringHelper.Truncate(recipients, 497) + "...";
            return recipients;
        }

        /// <summary>
        /// Gets a MailMergeRecipient instance for the first
        /// recipient of the message
        /// </summary>
        /// <returns>A MailMergeRecipient instance for the first
        /// recipient of the message.</returns>
        private MailMergeRecipient GetFirstRecipient()
        {
            string previewAddress;
            Hashtable parameters = new Hashtable();
            if (_RestockNotifyList != null)
            {
                previewAddress = _RestockNotifyList[0].Email;
                parameters["store"] = AbleContext.Current.Store;
                parameters["product"] = _RestockNotifyList[0].Product;
                parameters["recipient"] = _RestockNotifyList[0].Email;
                parameters["variant"] = _RestockNotifyList[0].ProductVariant;
            }
            else
            {
                // NO EMAIL ADDRESSES FOUND!
                return null;
            }
            return new MailMergeRecipient(previewAddress, parameters);
        }

        /// <summary>
        /// Gets a IList<MailMergeRecipient> instance for all
        /// recipients of the message
        /// </summary>
        /// <returns>A IList<MailMergeRecipient> instance for all
        /// recipients of the message.</returns>
        private IList<MailMergeRecipient> GetAllRecipients()
        {
            IList<MailMergeRecipient> recipients = new List<MailMergeRecipient>();
            if (_RestockNotifyList != null && _RestockNotifyList.Count > 0)
            {
                foreach (RestockNotify notification in _RestockNotifyList)
                {
                    Hashtable parameters = new Hashtable();
                    parameters["store"] = AbleContext.Current.Store;
                    parameters.Add("recipient", notification.Email);
                    parameters.Add("product", notification.Product);
                    parameters.Add("variant", notification.ProductVariant);
                    recipients.Add(new MailMergeRecipient(notification.Email, parameters));
                }
            }
            return recipients;
        }
        #endregion

        /// <summary>
        /// Reads the values from the form and popupates a 
        /// MailMergeTemplate instance
        /// </summary>
        /// <returns>A MailMergeTemplate instance populated with
        /// the values on the form</returns>
        private MailMergeTemplate GetMailMergeTemplate()
        {
            MailMergeTemplate mergeTemplate = new MailMergeTemplate();
            mergeTemplate.CCList = CCAddress.Text;
            mergeTemplate.BCCList = BCCAddress.Text;
            mergeTemplate.FromAddress = FromAddress.Text;
            mergeTemplate.Subject = Subject.Text;
            mergeTemplate.IsHTML = (MailFormat.SelectedIndex == 0);
            mergeTemplate.Body = Message.Text;

            // POPULATE SHARED PARAMETERS
            mergeTemplate.Parameters["store"] = AbleContext.Current.Store;

            // RETURN GENERATED MESSAGE
            return mergeTemplate;
        }

        protected void PreviewButton_Click(object sender, EventArgs e)
        {
            // SHOW THE PREVIEW
            if (Page.IsValid)
            {
                // GENERATE MESSAGE
                MailMergeTemplate mergeTemplate = GetMailMergeTemplate();
                mergeTemplate.Parameters["store"] = AbleContext.Current.Store;

                // GET RECIPIENT
                IList<MailMergeRecipient> recipients = GetAllRecipients();

                // GET A PREVIEW MESSAGE
                MailMessage message;
                try
                {
                    message = mergeTemplate.GenerateMessage(recipients[0]);
                }
                catch (Exception ex)
                {
                    EmailTemplateErrorLabel.Text = String.Format(EmailTemplateErrorLabel.Text, mergeTemplate.Subject, ex.Message);
                    EmailTemplateErrorLabel.Visible = true;
                    return;
                }

                // DISPLAY THE MESSAGE CONTENT
                if (message.IsBodyHtml)
                {
                    PreviewMessage.Text = message.Body;
                }
                else
                {
                    PreviewMessage.Text = "<PRE>" + Server.HtmlEncode(message.Body) + "</PRE>";
                }

                // SWAP THE PANELS
                ComposePanel.Visible = false;
                PreviewPanel.Visible = true;
                PreviewHelpText.Text = string.Format(PreviewHelpText.Text, recipients.Count);
                ConfirmationPanel.Visible = false;
                SmtpErrorPanel.Visible = false;

                // SET Flag for notification subscriptinos removal
                RemoveNotificationSubscriptionsFlag.Value = RemoveNotificationSubscriptions.Checked ? "1" : "0";
            }
        }

        protected void BackButton_Click(object sender, System.EventArgs e)
        {
            // CANCEL THE PREVIEW
            ComposePanel.Visible = true;
            PreviewPanel.Visible = false;
            ConfirmationPanel.Visible = false;
            SmtpErrorPanel.Visible = false;
        }

        protected void SendButton_Click(object sender, System.EventArgs e)
        {
            // SHOW THE PREVIEW
            if (Page.IsValid)
            {
                // GENERATE MESSAGE AND SEND MESSAGE
                MailMergeTemplate mergeTemplate = GetMailMergeTemplate();
                IList<MailMergeRecipient> recipients = GetAllRecipients();
                mergeTemplate.Send(recipients, true);

                if (_RestockNotifyList != null)
                {
                    if (RemoveNotificationSubscriptionsFlag.Value == "1")
                        _RestockNotifyList.DeleteAll();
                    else
                    {
                        foreach (RestockNotify notification in _RestockNotifyList)
                        {
                            notification.LastSentDate = LocaleHelper.LocalNow;
                        }

                        _RestockNotifyList.Save();
                    }
                }

                // PROVIDE NOTIFICATION
                ComposePanel.Visible = false;
                PreviewPanel.Visible = false;
                ConfirmationPanel.Visible = true;
                SmtpErrorPanel.Visible = false;
                ConfirmationMessage.Text = string.Format(ConfirmationMessage.Text, recipients.Count);
            }
        }

        protected void OKButton_Click(object sender, System.EventArgs e)
        {
            RedirectMe();
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            RedirectMe();
        }

        protected bool IsSmtpServerConfigured()
        {
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            if (!String.IsNullOrEmpty(settings.SmtpServer) && !String.IsNullOrEmpty(settings.SmtpPort))
            {
                return true;
            }
            return false;
        }

        protected void EmailTemplates_SelectedIndexChanged(Object sender, EventArgs e)
        {
            int emailTemplateId = AlwaysConvert.ToInt(EmailTemplates.SelectedValue);
            EmailTemplate emailTemplate = EmailTemplateDataSource.Load(emailTemplateId);
            if (emailTemplate != null)
            {
                emailTemplate.Parameters.Add("store", AbleContext.Current.Store);
                MailAddress fromAddress = emailTemplate.ParseAddress(emailTemplate.FromAddress);
                CCAddress.Text = emailTemplate.CCList;
                BCCAddress.Text = emailTemplate.BCCList;
                FromAddress.Text = fromAddress != null ? fromAddress.Address : emailTemplate.FromAddress;
                Subject.Text = emailTemplate.Subject;
                MailFormat.SelectedIndex = emailTemplate.IsHTML ? 0 : 1;
                Message.Text = emailTemplate.Body;
            }
            else
            {
                FromAddress.Text = AbleContext.Current.Store.Settings.DefaultEmailAddress;
                Subject.Text = string.Empty;
                Message.Text = string.Empty;
            }
        }

        private void RedirectMe()
        {
            Response.Redirect(GetReturnUrl());
        }

        private string GetReturnUrl()
        {
            String returnUrl = Request.QueryString["ReturnUrl"];
            if (!String.IsNullOrEmpty(returnUrl)) return System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(returnUrl));
            else return "~/Admin/Default.aspx";
        }
    }
}
