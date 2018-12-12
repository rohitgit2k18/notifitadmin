namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.IO;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Utility;
    using System.Net.Mail;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Users;
    using System.Collections.Generic;
    using System.Web.Services;
    using CommerceBuilder.Orders;

    [Description("A Standard Contact Us email form control that can be used by customers to contact merchants.")]
    public partial class ContactUs : System.Web.UI.UserControl
    {
        private bool _enableCaptcha = true;
        private bool _enableConfirmationEmail = false;
        private int _confirmationEmailTemplateId = 0;

        private string _subject = "New Contact Message";
        private string _sendTo;

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
            get { return _confirmationEmailTemplateId;  }
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

            if(!Page.IsPostBack)
            {
                SaveUploadedFile(Request.Files);
                User user = AbleContext.Current.User;
                Email.CssClass += " contact-field";
                Phone.CssClass += " contact-field";
                FirstName.CssClass += " contact-field";
                LastName.CssClass += " contact-field";
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
            PassEnquiryToCrm();

            // if confirmation email is enabled, send the confirmation email back to customer
            //if (this.EnableConfirmationEmail) SendConfirmationEmail();
        }

        private void PassEnquiryToCrm()
        {
            
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;

            Order order = new Order();
            order.BillToEmail = StringHelper.StripHtml(Email.Text);
            order.BillToFirstName = StringHelper.StripHtml(FirstName.Text);
            order.BillToLastName = StringHelper.StripHtml(LastName.Text);
            order.BillToPhone = StringHelper.StripHtml(Phone.Text);
            order.BillToCompany = StringHelper.StripHtml(Company.Text);
            order.OrderDate = DateTime.Now;
            
            // The list of files that have been uploaded are included in the HiddenFilesField.
            var files = (List<FileAttachment>)Session["UPLOADED"];
            if (files == null)
            {
                files = new List<FileAttachment>();
            }

            CrmHelper.SaveEnquiry(order, StringHelper.StripHtml(Comments.Text), files, store);


            FailureMessage.Visible = false;
            SuccessMessage.Visible = true;
            MessagePanel.Visible = true;
            ContactFormPanel.Visible = false;
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
            if(emailTemplateId == 0) 
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
                ContactFormPanel.Visible = false;
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
            List<FileAttachment> fileAttachments = new List<FileAttachment>();
            if (httpFileCollection.Count == 0)
            {
                // Delete previously uploaded files in SESSION to be erased
                fileAttachments = (List<FileAttachment>)Session["UPLOADED"];
                if (fileAttachments != null && fileAttachments.Count > 0)
                {
                    foreach (var file in fileAttachments)
                    {
                        FileInfo TheFile = new FileInfo(file.path);
                        if (TheFile.Exists)
                        {
                            // File found so delete it.
                            TheFile.Delete();
                        }
                    }
                }

                Session["UPLOADED"] = null;
            }
            fileAttachments = (List<FileAttachment>)Session["UPLOADED"];

            string fName = "";
            foreach (string fileName in httpFileCollection)
            {
                HttpPostedFile file = httpFileCollection.Get(fileName);
                //Save file content goes here
                fName = file.FileName;
                if (file != null && file.ContentLength > 0)
                {

                    var originalDirectory = new DirectoryInfo(string.Format("{0}", Server.MapPath(@"\")));

                    string pathString = System.IO.Path.Combine(originalDirectory.ToString(), "ClientUploadedFiles");

                    var fileName1 = Path.GetFileName(file.FileName);


                    bool isExists = System.IO.Directory.Exists(pathString);

                    if (!isExists)
                        System.IO.Directory.CreateDirectory(pathString);

                    var path = string.Format("{0}\\{1}", pathString, file.FileName);

                    // Get file attachments
                    if (fileAttachments == null)
                    {
                        fileAttachments = new List<FileAttachment>();
                    }

                    fileAttachments.Add(new FileAttachment() { name = fileName1, target_name = fileName1, size = file.ContentLength, path = path });
                    Session["UPLOADED"] = fileAttachments;
                    file.SaveAs(path);
                }

            }
        }
    }
}