namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.UI;

    [Description("Displays a simple email list signup form. This form can be added to side bars.")]
    public partial class SubscribeToEmailList : System.Web.UI.UserControl, ISidebarControl
    {
        private int _EmailListId = 0;
        private string _Caption = "Subscribe To Email List";

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Subscribe To Email List")]
        [Description("The Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]        
        [Browsable(true), DefaultValue(0)]
        [Description("This is the ID of the Email List to be subscribed to. If no email list is specified the store's default email list is used.")]
        public int EmailListId
        {
            get { return _EmailListId; }
            set { _EmailListId = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (_EmailListId == 0)
            {
                _EmailListId = AbleContext.Current.Store.Settings.DefaultEmailListId;
            }
        }

        protected void SubscribeButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (_EmailListId == 0)
                {
                    return;
                }

                EmailList emailList = EmailListDataSource.Load(_EmailListId);
                if (emailList != null)
                {
                    string email = UserEmail.Text;
                    bool subscribedNow = false;
                    bool alreadySubscribed = false;
                    if (emailList.IsMember(email))
                    {
                        alreadySubscribed = true;
                    }
                    else
                    {
                        //subscribe this user to this email list
                        //emailList.EmailListUsers.Add(new EmailListUser(emailList.EmailListId, userId));
                        //emailList.EmailListUsers.Save();
                        emailList.ProcessSignupRequest(email);
                        subscribedNow = true;
                    }
                    if (subscribedNow)
                    {
                        if (emailList.SignupRule == EmailListSignupRule.ConfirmedOptIn)
                        {
                            SubscribedMessage.Text = string.Format(SubscribedMessage.Text, email, emailList.Name);
                            SubscribedMessage.Visible = true;
                        }
                        else
                        {
                            VerificationRequiredMessage.Text = string.Format(VerificationRequiredMessage.Text, email);
                            VerificationRequiredMessage.Visible = true;
                        }
                    }
                    else if (alreadySubscribed)
                    {
                        SubscribedMessage.Text = string.Format("The email '{0}' is already subscribed to '{1}'.", email, emailList.Name);
                        SubscribedMessage.Visible = true;
                    }
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (_EmailListId == 0)
            {
                this.Visible = false;
                return;
            }

            EmailList emailList = EmailListDataSource.Load(_EmailListId);
            if (emailList == null)
            {
                this.Visible = false;
                return;
            }

            CaptionLabel.Text = this.Caption;
            if (!AbleContext.Current.User.IsAnonymous && !String.IsNullOrEmpty(AbleContext.Current.User.Email))
            {
                UserEmail.Text = AbleContext.Current.User.Email;
            }

            InstructionsText.Text = string.Format(InstructionsText.Text, emailList.Name);
            this.Visible = true;
        }
    }
}