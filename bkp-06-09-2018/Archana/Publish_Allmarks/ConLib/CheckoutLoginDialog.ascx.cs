namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;

    [Description("A login dialog which is used on the checkout page while an anonymous user is checking out.")]
    public partial class CheckoutLoginDialog : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            InstructionText.Text = string.Format(InstructionText.Text, AbleContext.Current.Store.Name);
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(UserName);
            AbleCommerce.Code.PageHelper.SetDefaultButton(Password, LoginButton.ClientID);
            if (!Page.IsPostBack)
            {
                HttpCookie usernameCookie = Request.Cookies["UserName"];
                if ((usernameCookie != null) && !string.IsNullOrEmpty(usernameCookie.Value))
                {
                    UserName.Text = usernameCookie.Value;
                    RememberUserName.Checked = true;
                    Password.Focus();
                }
                else
                {
                    UserName.Focus();
                }
                ForgotPasswordPanel.Visible = false;
                EmailSentPanel.Visible = false;
            }
        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            if (Membership.ValidateUser(UserName.Text, Password.Text))
            {
                //MIGRATE USER IF NEEDED
                int newUserId = UserDataSource.GetUserId(UserName.Text);
                if ((AbleContext.Current.UserId != newUserId) && (newUserId != 0))
                {
                    User.Migrate(AbleContext.Current.User, UserDataSource.Load(newUserId));
                    AbleContext.Current.UserId = newUserId;
                    AbleContext.Current.User = UserDataSource.Load(newUserId);
                }
                //HANDLE LOGIN PROCESSING
                if (RememberUserName.Checked)
                {
                    HttpCookie cookie = new HttpCookie("UserName", UserName.Text);
                    cookie.Expires = DateTime.MaxValue;
                    Response.Cookies.Add(cookie);
                }
                else
                {
                    Response.Cookies.Add(new HttpCookie("UserName", ""));
                }
                //UPDATE AUTHORIZATION COOKIE
                FormsAuthentication.SetAuthCookie(UserName.Text, false);
                //REDIRECT TO CHECKOUT
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetCheckoutUrl(true));
            }
            else
            {
                InvalidLogin.IsValid = false;
            }
        }

        protected void ForgotPasswordButton_Click(object sender, EventArgs e)
        {
            LoginPanel.Visible = false;
            ForgotPasswordPanel.Visible = true;
            ForgotPasswordUserName.Text = UserName.Text;

        }

        protected void ForgotPasswordCancelButton_Click(object sender, EventArgs e)
        {
            LoginPanel.Visible = true;
            ForgotPasswordPanel.Visible = false;
        }

        protected void ForgotPasswordNextButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                User user = UserDataSource.LoadForUserName(ForgotPasswordUserName.Text);
                if (user != null)
                {
                    user.GeneratePasswordRequest();
                    ForgotPasswordPanel.Visible = false;
                    EmailSentPanel.Visible = true;
                    EmailSentHelpText.Text = string.Format(EmailSentHelpText.Text, user.Email);
                }
                else
                {
                    ForgotPasswordUserNameValidator.IsValid = false;
                }
            }
        }

        protected void KeepShoppingButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl());
        }
    }
}