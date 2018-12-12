namespace AbleCommerce.Admin.UserControls
{
    using System;
    using System.Data;
    using System.Configuration;
    using System.Collections;
    using System.Collections.Generic;
    using System.Net.Mail;
    using System.Text.RegularExpressions;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Resources;
    using NHibernate;
    using CommerceBuilder.DomainModel;
    using NHibernate.Criterion;

    public partial class SendEmail : System.Web.UI.UserControl
    {
        /// <summary>
        /// Contains a list of users to be emailed
        /// </summary>
        private IList<User> _UserList;

        /// <summary>
        /// Contains an email list to send notification for
        /// </summary>
        private EmailList _EmailList;

        /// <summary>
        ///  Contains a list of subscriptions to be emailed
        /// </summary>
        private IList<Subscription> _SubscriptionList;

        /// <summary>
        /// Contains a list of orders to generate email list
        /// </summary>
        private IList<CommerceBuilder.Orders.Order> _OrderList;

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

            // GIVE PRECEDENCE TO QUERYSTRING REQUESTS
            if (!String.IsNullOrEmpty(Request.QueryString["OrderId"]) || !String.IsNullOrEmpty(Request.QueryString["OrderNumber"]))
            {
                // OBTAIN ORDER ID FROM QUERY STRING
                int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
                sessionIdList = "OrderId:" + orderId.ToString();
            }
            else if (!String.IsNullOrEmpty(Request.QueryString["EmailListId"]))
            {
                // OBTAIN EMAIL LIST ID FROM QUERY STRING
                int emailListId = AlwaysConvert.ToInt(Request.QueryString["EmailListId"]);
                _EmailList = EmailListDataSource.Load(emailListId);
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["UserId"]))
            {
                // OBTAIN USER ID FROM QUERY STRING
                int userId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
                sessionIdList = "UserId:" + userId.ToString();
            }

            // IF QUERYSTRING VALUES WERE NOT FOUND, LOOK FOR VALUES IN SESSION
            if (string.IsNullOrEmpty(sessionIdList) && Session["SendMail_IdList"] != null)
            {
                sessionIdList = Session["SendMail_IdList"].ToString();
            }

            // ATTEMPT TO PARSE DATASET
            if (!string.IsNullOrEmpty(sessionIdList))
            {
                Match idListMatch = Regex.Match(sessionIdList, @"^(UserId|SubscriptionId|OrderId):(\d+(?:,\d+)*)$", RegexOptions.IgnoreCase);
                if (idListMatch.Success)
                {
                    string idList = idListMatch.Groups[2].Value;
                    switch (idListMatch.Groups[1].Value.ToLowerInvariant())
                    {
                        case "userid":
                            ParseUserIdList(idList);
                            break;
                        case "subscriptionid":
                            ParseSubscriptionIdList(idList);
                            break;
                        case "orderid":
                            ParseOrderIdList(idList);
                            break;
                    }
                }
            }

            // VERIFY A DATASET WAS FOUND, IF NOT RETURN TO CALLING PAGE
            bool foundUserList = (_UserList != null && _UserList.Count > 0);
            bool foundEmailList = (_EmailList != null && _EmailList.Users.Count > 0);
            bool foundSubscriptionList = (_SubscriptionList != null && _SubscriptionList.Count > 0);
            bool foundOrderList = (_OrderList != null && _OrderList.Count > 0);
            bool foundRecipientSource = (foundUserList || foundEmailList || foundSubscriptionList || foundOrderList);
            if (!foundRecipientSource) RedirectMe();
        }

        /// <summary>
        /// Load orders in the id list
        /// </summary>
        /// <param name="idList">List of order ids</param>
        private void ParseOrderIdList(string idList)
        {
            // VALIDATE THE INPUT
            if (string.IsNullOrEmpty(idList))
                throw new ArgumentNullException("idList");
            if (!Regex.IsMatch(idList, "^\\d+(,\\d+)*$"))
                throw new ArgumentException("Id list can only be a comma delimited list of integer.", "idList");

            // PARSE THE LIST OF INTEGERS
            if (idList.Contains(","))
            {
                ICriteria criteria = NHibernateHelper.CreateCriteria<CommerceBuilder.Orders.Order>();
                criteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
                criteria.Add(Restrictions.In("Id", AlwaysConvert.ToIntArray(idList)));
                _OrderList = OrderDataSource.LoadForCriteria(criteria);
            }
            else
            {
                ICriteria criteria = NHibernateHelper.CreateCriteria<CommerceBuilder.Orders.Order>();
                criteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
                criteria.Add(Restrictions.Eq("Id", AlwaysConvert.ToInt(idList)));
                _OrderList = OrderDataSource.LoadForCriteria(criteria);
            }
        }

        /// <summary>
        /// Load subscriptions in the id list
        /// </summary>
        /// <param name="idList">List of subscription ids</param>
        private void ParseSubscriptionIdList(string idList)
        {
            // VALIDATE THE INPUT
            if (string.IsNullOrEmpty(idList))
                throw new ArgumentNullException("idList");
            if (!Regex.IsMatch(idList, "^\\d+(,\\d+)*$"))
                throw new ArgumentException("Id list can only be a comma delimited list of integer.", "idList");

            // PARSE THE LIST OF INTEGERS
            if (idList.Contains(","))
            {
                ICriteria criteria = NHibernateHelper.CreateCriteria<Subscription>();
                criteria.Add(Restrictions.In("Id", AlwaysConvert.ToIntArray(idList)));
                _SubscriptionList = SubscriptionDataSource.LoadForCriteria(criteria);
            }
            else
            {
                ICriteria criteria = NHibernateHelper.CreateCriteria<Subscription>();
                criteria.Add(Restrictions.Eq("Id", AlwaysConvert.ToInt(idList)));
                _SubscriptionList = SubscriptionDataSource.LoadForCriteria(criteria);
            }
        }

        /// <summary>
        /// Load users in the id list
        /// </summary>
        /// <param name="idList">List of user ids</param>
        private void ParseUserIdList(string idList)
        {
            // VALIDATE THE INPUT
            if (string.IsNullOrEmpty(idList))
                throw new ArgumentNullException("idList");
            if (!Regex.IsMatch(idList, "^\\d+(,\\d+)*$"))
                throw new ArgumentException("Id list can only be a comma delimited list of integer.", "idList");

            // PARSE THE LIST OF INTEGERS
            if (idList.Contains(","))
            {
                ICriteria criteria = NHibernateHelper.CreateCriteria<User>();
                criteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
                criteria.Add(Restrictions.In("Id", AlwaysConvert.ToIntArray(idList)));
                _UserList = UserDataSource.LoadForCriteria(criteria);
            }
            else
            {
                ICriteria criteria = NHibernateHelper.CreateCriteria<User>();
                criteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
                criteria.Add(Restrictions.Eq("Id", AlwaysConvert.ToInt(idList)));
                _UserList = UserDataSource.LoadForCriteria(criteria);
            }
        }

        /// <summary>
        /// Gets a list of recipients suitable for display.
        /// </summary>
        /// <returns>A list of recipeints suitable for display.</returns>
        private string GetRecipientList()
        {
            List<string> recipientList = new List<string>();
            if (_UserList != null)
            {
                foreach (User user in _UserList)
                {
                    recipientList.Add(user.GetBestEmailAddress());
                }
            }
            else if (_SubscriptionList != null)
            {
                foreach (Subscription subscription in _SubscriptionList)
                {
                    recipientList.Add(subscription.User.GetBestEmailAddress());
                }
            }
            else if (_OrderList != null)
            {
                foreach (CommerceBuilder.Orders.Order order in _OrderList)
                {
                    recipientList.Add(order.BillToEmail);
                }
            }
            else if (_EmailList != null)
            {
                recipientList.Add(_EmailList.Name);
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
            if (_EmailList != null && _EmailList.Users.Count > 0)
            {
                previewAddress = _EmailList.Users[0].Email;
                parameters.Add("emailListUser", _EmailList.Users[0]);
            }
            else if (_UserList != null && _UserList.Count > 0)
            {
                previewAddress = _UserList[0].GetBestEmailAddress();
                parameters["customer"] = _UserList[0];
            }
            else if (_OrderList != null && _OrderList.Count > 0)
            {
                previewAddress = _OrderList[0].BillToEmail;
                parameters["customer"] = _OrderList[0].User;
                parameters["order"] = _OrderList[0];
            }
            else if (_SubscriptionList != null && _SubscriptionList.Count > 0)
            {
                previewAddress = _SubscriptionList[0].User.GetBestEmailAddress();
                parameters["customer"] = _SubscriptionList[0].User;
                parameters["subscription"] = _SubscriptionList[0];
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
            if (_EmailList != null && _EmailList.Users.Count > 0)
            {
                foreach (EmailListUser elu in _EmailList.Users)
                {
                    Hashtable parameters = new Hashtable();
                    parameters.Add("list", _EmailList);
                    parameters.Add("email", elu.Email);
                    User user = elu.User;
                    if (user != null) parameters.Add("customer", user);
                    parameters.Add("emailListUser", elu);

                    // UN-SUBSCRIBE LINK
                    String unsubscribeLink = AbleContext.Current.Store.StoreUrl + "Subscription.aspx?action=remove&list=" + _EmailList.Id + "&email=" + elu.Email.ToLowerInvariant() + "&key=" + elu.SignupDate.ToString("MMddyyhhmmss");
                    parameters.Add("unsubscribeLink", unsubscribeLink);

                    recipients.Add(new MailMergeRecipient(elu.Email, parameters));
                }
            }
            else if (_UserList != null && _UserList.Count > 0)
            {
                foreach (User user in _UserList)
                {
                    Hashtable parameters = new Hashtable();
                    parameters.Add("customer", user);
                    recipients.Add(new MailMergeRecipient(user.Email, parameters));
                }
            }
            else if (_OrderList != null && _OrderList.Count > 0)
            {
                foreach (CommerceBuilder.Orders.Order order in _OrderList)
                {
                    Hashtable parameters = new Hashtable();
                    parameters.Add("customer", order.User);
                    parameters.Add("order", order);
                    parameters.Add("payments", order.Payments);
                    recipients.Add(new MailMergeRecipient(order.BillToEmail, parameters));
                }
            }
            else if (_SubscriptionList != null && _SubscriptionList.Count > 0)
            {
                foreach (Subscription subscription in _SubscriptionList)
                {
                    User user = subscription.User;
                    Hashtable parameters = new Hashtable();
                    parameters.Add("customer", user);
                    parameters.Add("subscription", subscription);
                    recipients.Add(new MailMergeRecipient(user.Email, parameters));
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
                if (_EmailList != null)
                {
                    _EmailList.LastSendDate = LocaleHelper.LocalNow;
                    _EmailList.Save();
                }

                // PROVIDE NOTIFICATION
                ComposePanel.Visible = false;
                PreviewPanel.Visible = false;
                ConfirmationPanel.Visible = true;
                SmtpErrorPanel.Visible = false;
                ConfirmationMessage.Text = string.Format(ConfirmationMessage.Text, recipients.Count);
                Session["SendMail_IdList"] = null;
            }
        }

        protected void OKButton_Click(object sender, System.EventArgs e)
        {
            // CLEAR THE SELECTED USER LIST AND REDIRECT
            Session["SendMail_IdList"] = null;
            RedirectMe();
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            // CLEAR THE SELECTED USER LIST AND REDIRECT
            Session["SendMail_IdList"] = null;
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
