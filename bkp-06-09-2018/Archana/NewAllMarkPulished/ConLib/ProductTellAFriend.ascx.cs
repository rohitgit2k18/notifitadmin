namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Products;
    using CommerceBuilder.UI;
    using CommerceBuilder.Utility;

    [Description("Displays a form using which an email can be send to a friend about a product. This can be added to side bars.")]
    public partial class ProductTellAFriend : System.Web.UI.UserControl, ISidebarControl
    {
        private string _Caption = "Email A Friend";
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Email A Friend")]
        [Description("Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        protected void SendEmailButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if ((!trCaptchaImage.Visible) || CaptchaImage.Authenticate(CaptchaInput.Text))
                {
                    int productId = AbleCommerce.Code.PageHelper.GetProductId();
                    Product product = ProductDataSource.Load(productId);
                    if (product != null)
                    {
                        int categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
                        Category category = CategoryDataSource.Load(categoryId);
                        EmailTemplate template = EmailTemplateDataSource.Load(AbleContext.Current.Store.Settings.ProductTellAFriendEmailTemplateId);
                        if (template != null)
                        {
                            //STRIP HTML
                            Name.Text = StringHelper.StripHtml(Name.Text);
                            FromEmail.Text = StringHelper.StripHtml(FromEmail.Text);
                            FriendEmail.Text = StringHelper.StripHtml(FriendEmail.Text);
                            // ADD PARAMETERS
                            template.Parameters["store"] = AbleContext.Current.Store;
                            template.Parameters["product"] = product;
                            template.Parameters["category"] = category;
                            template.Parameters["fromEmail"] = FromEmail.Text;
                            template.Parameters["fromName"] = Name.Text;
                            template.FromAddress = FromEmail.Text;
                            template.ToAddress = FriendEmail.Text;
                            template.Send();
                            FriendEmail.Text = string.Empty;
                            SentMessage.Visible = true;
                            CaptchaInput.Text = "";
                            CaptchaImage.ChallengeText = StringHelper.RandomNumber(6);
                        }
                        else
                        {
                            FailureMessage.Text = "Email template could not be loaded.";
                            FailureMessage.Visible = true;
                        }
                    }
                    else
                    {
                        FailureMessage.Text = "Product could not be identified.";
                        FailureMessage.Visible = true;
                    }
                }
                else
                {
                    //CAPTCHA IS VISIBLE AND DID NOT AUTHENTICATE
                    CustomValidator invalidInput = new CustomValidator();
                    invalidInput.ValidationGroup = "TellAFriend";
                    invalidInput.Text = "*";
                    invalidInput.ErrorMessage = "You did not input the verification number correctly.";
                    invalidInput.IsValid = false;
                    phCaptchaValidators.Controls.Add(invalidInput);
                    CaptchaInput.Text = "";
                    CaptchaImage.ChallengeText = StringHelper.RandomNumber(6);
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            CaptionLabel.Text = this.Caption;
            if (String.IsNullOrEmpty(FromEmail.Text) && !String.IsNullOrEmpty(AbleContext.Current.User.Email))
            {
                Name.Text = AbleContext.Current.User.PrimaryAddress.FullName;
                FromEmail.Text = AbleContext.Current.User.Email;
            }

            bool enableCaptcha = AbleContext.Current.Store.Settings.ProductTellAFriendCaptcha;
            trCaptchaCaption.Visible = enableCaptcha;
            trCaptchaImage.Visible = enableCaptcha;
            trCaptchaInputLabel.Visible = enableCaptcha;
            trCaptchaInput.Visible = enableCaptcha;
        }
    }
}