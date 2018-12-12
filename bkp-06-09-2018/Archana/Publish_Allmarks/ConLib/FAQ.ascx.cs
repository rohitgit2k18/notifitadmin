using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Data;
    using System.Configuration;
    using System.Collections;
    using System.IO;
    using System.Linq;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.Utility;
    using System.Text;
    using System.Net;
    using System.Net.Mail;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Users;
    using System.Web.Services;

    [Description("A Standard Contact Us email form control that can be used by customers to contact merchants.")]
    public partial class FAQ : System.Web.UI.UserControl
    {
        private bool _enableCaptcha = true;
        private bool _enableConfirmationEmail = false;
        private int _confirmationEmailTemplateId = 0;

        private string _subject = "New Contact Message";
        private string _sendTo;

        private FAQ _faq;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("Indicates whether the captcha input field is enabled for protection from spam messages.")]
        public bool EnableCaptcha
        {
            get { return _enableCaptcha; }
            set { _enableCaptcha = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("Indicates whether the confirmation email is enabled. If true then a confirmation email will be sent back to customer.")]
        public bool EnableConfirmationEmail
        {
            get { return _enableConfirmationEmail; }
            set { _enableConfirmationEmail = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(0)]
        [Description("If confirmation email is enabled, the email template will be used to generate confirmation email.")]
        public int ConfirmationEmailTemplateId
        {
            get { return _confirmationEmailTemplateId; }
            set { _confirmationEmailTemplateId = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("New Contact Message")]
        [Description("Default email subject for the contact us email message.")]
        public string Subject
        {
            get { return _subject; }
            set { _subject = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Store email address")]
        [Description("Single or a comma separated list of email addresses, use the format like 'info@ourstore.com,sales@ourstore.com' to specify email addresses. If no value is specified store default email address will be used.")]
        public string SendTo
        {
            get { return _sendTo; }
            set { _sendTo = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            CaptchaPanel.Visible = EnableCaptcha;

            if (!Page.IsPostBack)
            {
                User user = AbleContext.Current.User;
                Email.CssClass += " contact-field";
                Phone.CssClass += " contact-field";
                FirstName.CssClass += " contact-field";
                LastName.CssClass += " contact-field";
                SaveUploadedFile(Request.Files);
            }
        }

        private void RefreshCaptcha()
        {
            CaptchaImage.ChallengeText = StringHelper.RandomNumber(6);
        }

        protected void ChangeImageLink_Click(object sender, EventArgs e)
        {
            RefreshCaptcha();
        }

        protected void Submit_Click(object sender, EventArgs e)
        {
            if (EnableCaptcha)
            {
                if (CaptchaImage.Authenticate(CaptchaInput.Text))
                {
                    SubmitComment();
                    CaptchaInput.Text = "";
                    RefreshCaptcha();
                }
                else
                {
                    //CAPTCHA IS VISIBLE AND DID NOT AUTHENTICATE
                    CustomValidator invalidInput = new CustomValidator();
                    invalidInput.Text = "*";
                    invalidInput.ErrorMessage = "You did not input the verification number correctly.";
                    invalidInput.IsValid = false;
                    phCaptchaValidators.Controls.Add(invalidInput);
                    CaptchaInput.Text = "";
                    RefreshCaptcha();
                }
            }
            else
                if (!EnableCaptcha)
            {
                SubmitComment();
            }
        }

        protected void SubmitComment()
        {
            // send the contact us email to merchant
            SendContactUsEmail();

            // if confirmation email is enabled, send the confirmation email back to customer
            if (this.EnableConfirmationEmail) SendConfirmationEmail();
        }

        private void SendContactUsEmail()
        {
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;

            MailMessage mailMessage = new MailMessage();

            if (string.IsNullOrEmpty(SendTo))
            {
                mailMessage.To.Add(settings.DefaultEmailAddress);
            }
            else
            {
                mailMessage.To.Add(SendTo);
            }

            mailMessage.From = new System.Net.Mail.MailAddress(Email.Text);
            mailMessage.Subject = this.Subject;
            mailMessage.Body += "Name: " + FirstName.Text + " " + LastName.Text + Environment.NewLine;
            if (!String.IsNullOrEmpty(Company.Text))
            {
                mailMessage.Body += "Company: " + Company.Text + Environment.NewLine;
            }
            mailMessage.Body += "Email: " + Email.Text + Environment.NewLine;
            mailMessage.Body += "Phone: " + Phone.Text + Environment.NewLine;
            mailMessage.Body += "Comment: " + Environment.NewLine + Comments.Text;

            //Add attachments
            List<string> fileAttachments = (List<string>)Session["UPLOADED"];
            if (fileAttachments != null)
            {
                foreach (var attachment in fileAttachments)
                {
                    mailMessage.Attachments.Add(new Attachment(attachment));
                }
            }

            mailMessage.BodyEncoding = System.Text.Encoding.UTF8;
            mailMessage.IsBodyHtml = false;
            mailMessage.Priority = System.Net.Mail.MailPriority.High;
            SmtpSettings smtpSettings = SmtpSettings.DefaultSettings;

            try
            {
                EmailClient.Send(mailMessage);

                FailureMessage.Visible = false;
                SuccessMessage.Visible = true;
            }
            catch (Exception exp)
            {
                Logger.Error("ContactUs Control Exception: Exp" + Environment.NewLine + exp.Message);
                FailureMessage.Visible = true;
                SuccessMessage.Visible = false;
            }

            MessagePanel.Visible = true;
            FAQFormPanel.Visible = false;
        }

        private string GetFromAddress()
        {
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            string fromAddress = settings.DefaultEmailAddress;
            if (string.IsNullOrEmpty(fromAddress)) fromAddress = "admin@domain.xyz";
            return fromAddress;
        }

        private void SendConfirmationEmail()
        {
            int emailTemplateId = ConfirmationEmailTemplateId;

            // use default if none is provided
            if (emailTemplateId == 0)
                emailTemplateId = AbleContext.Current.Store.Settings.ContactUsConfirmationEmailTemplateId;

            EmailTemplate template = EmailTemplateDataSource.Load(emailTemplateId);

            if (template != null)
            {
                template.Parameters.Add("user", AbleContext.Current.User);
                template.Parameters.Add("store", AbleContext.Current.Store);

                try
                {

                    // populate the email for anonymous user account, it is needed for email message generation ('customer' parameter)
                    if (AbleContext.Current.User.IsAnonymousOrGuest)
                        AbleContext.Current.User.Email = Email.Text;

                    MailMessage[] messages = template.GenerateMailMessages();
                    foreach (MailMessage msg in messages)
                    {
                        msg.To.Clear();
                        msg.To.Add(new MailAddress(this.Email.Text));
                        EmailClient.Send(msg);
                    }
                    FailureMessage.Visible = false;
                    SuccessMessage.Visible = true;
                }
                catch (Exception exp)
                {
                    Logger.Error("ContactUs Control Exception: " + Environment.NewLine + exp.Message);
                    FailureMessage.Visible = true;
                    SuccessMessage.Visible = false;
                }

                MessagePanel.Visible = true;
                FAQFormPanel.Visible = false;
            }
        }

        [WebMethod]
        public static void RemoveFile(string name)
        {
            var originalDirectory = new DirectoryInfo(string.Format("{0}", HttpContext.Current.Server.MapPath(@"\")));
            string pathString = System.IO.Path.Combine(originalDirectory.ToString(), "upload");
            var path = string.Format("{0}\\{1}", pathString, name);
            FileInfo TheFile = new FileInfo(path);
            if (TheFile.Exists)
            {
                // File found so delete it.
                TheFile.Delete();
            }

        }

        public void SaveUploadedFile(HttpFileCollection httpFileCollection)
        {
            // Clear Session data if no file uploades are made (IsPostBack does not work, need to clear session data on page re-load)
            List<string> fileAttachments = new List<string>();
            if (httpFileCollection.Count == 0)
            {
                // Delete previously uploaded files in SESSION to be erased
                fileAttachments = (List<string>)Session["UPLOADED"];
                if (fileAttachments != null && fileAttachments.Count > 0)
                {
                    foreach (string filePath in fileAttachments)
                    {
                        FileInfo TheFile = new FileInfo(filePath);
                        if (TheFile.Exists)
                        {
                            // File found so delete it.
                            TheFile.Delete();
                        }
                    }
                }

                Session["UPLOADED"] = null;
            }
            fileAttachments = (List<string>)Session["UPLOADED"];

            string fName = "";
            foreach (string fileName in httpFileCollection)
            {
                HttpPostedFile file = httpFileCollection.Get(fileName);
                //Save file content goes here
                fName = file.FileName;
                if (file != null && file.ContentLength > 0)
                {

                    var originalDirectory = new DirectoryInfo(string.Format("{0}", Server.MapPath(@"\")));

                    string pathString = System.IO.Path.Combine(originalDirectory.ToString(), "upload");

                    var fileName1 = Path.GetFileName(file.FileName);


                    bool isExists = System.IO.Directory.Exists(pathString);

                    if (!isExists)
                        System.IO.Directory.CreateDirectory(pathString);

                    var path = string.Format("{0}\\{1}", pathString, file.FileName);

                    // Get file attachments
                    if (fileAttachments == null)
                    {
                        fileAttachments = new List<string>();
                    }
                    fileAttachments.Add(path);
                    Session["UPLOADED"] = fileAttachments;
                    file.SaveAs(path);

                }

            }

            //if (isSavedSuccessfully)
            //{
            //    return Json(new { Message = fName });
            //}
            //else
            //{
            //    return Json(new { Message = "Error in saving file" });
            //}
        }
    }
}