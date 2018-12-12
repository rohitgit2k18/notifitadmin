using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile.UserControls
{
    public partial class RegisterDialog : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(UserName);
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(Password);
            AbleCommerce.Code.PageHelper.SetDefaultButton(ConfirmPassword, RegisterButton.ClientID);
            ShowPasswordPolicy();

            if (!Page.IsPostBack)
            {
                CustomerPasswordPolicy policy = new CustomerPasswordPolicy();
                trCaptchaImage.Visible = policy.ImageCaptcha;
                trCaptchaField.Visible = policy.ImageCaptcha;
            }
        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && ValidatePassword())
            {
                if ((!trCaptchaField.Visible) || CaptchaImage.Authenticate(CaptchaInput.Text))
                {
                    // PERFORM CUSTOM VALIDATION TO ENSURE EMAIL IS NOT ALREADY REGISTERED
                    string userName = UserName.Text.Trim();
                    int userIde = UserDataSource.GetUserIdByEmail(userName);
                    int userIdu = UserDataSource.GetUserIdByUserName(userName);
                    if (userIde == 0 && userIdu == 0)
                    {
                        // NO USER REGISTERED WITH THAT USERNAME OR EMAIL 
                        MembershipCreateStatus status;
                        User newUser = UserDataSource.CreateUser(userName, userName, Password.Text, string.Empty, string.Empty, true, 0, out status);
                        if (status == MembershipCreateStatus.Success)
                        {
                            // WE HAVE TO VALIDATE CREDENTIALS SO A MODIFIED FORM POST CANNOT ACCESS THIS CODE
                            if (Membership.ValidateUser(userName, Password.Text))
                            {
                                // SET A DEFAULT BILLING ADDRESS FOR THE USER
                                newUser.PrimaryAddress.Email = userName;
                                newUser.PrimaryAddress.CountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                                newUser.PrimaryAddress.Residence = true;
                                newUser.Save();

                                // SET COOKIE TO REMEMBER USERNAME IF INDICATED
                                if (RememberUserName.Checked)
                                {
                                    HttpCookie cookie = new HttpCookie("UserName", userName);
                                    cookie.Expires = DateTime.MaxValue;
                                    Response.Cookies.Add(cookie);
                                }
                                else
                                {
                                    Response.Cookies.Add(new HttpCookie("UserName", ""));
                                }

                                //MIGRATE USER IF NEEDED
                                int newUserId = UserDataSource.GetUserIdByUserName(userName);
                                if ((AbleContext.Current.UserId != newUserId) && (newUserId != 0))
                                {
                                    User.Migrate(AbleContext.Current.User, newUser, false, true);
                                    AbleContext.Current.UserId = newUserId;
                                }

                                //REDIRECT TO APPROPRIATE PAGE
                                FormsAuthentication.SetAuthCookie(UserName.Text, false);
                                Response.Redirect(NavigationHelper.GetReturnUrl(NavigationHelper.GetMobileStoreUrl("~/Default.aspx")));
                            }
                        }
                        else
                        {
                            InvalidRegistration.IsValid = false;
                            switch (status)
                            {
                                case MembershipCreateStatus.DuplicateUserName:
                                case MembershipCreateStatus.DuplicateEmail:
                                    InvalidRegistration.ErrorMessage = "The user-name you have provided is already registered.  Sign in to access your account.";
                                    break;
                                case MembershipCreateStatus.InvalidEmail:
                                    InvalidRegistration.ErrorMessage = "The email address you have provided is not valid.";
                                    break;
                                case MembershipCreateStatus.InvalidUserName:
                                    InvalidRegistration.ErrorMessage = "The user-name you have provided is not valid.";
                                    break;
                                case MembershipCreateStatus.InvalidPassword:
                                    InvalidRegistration.ErrorMessage = "The password you have provided is not valid.";
                                    break;
                                default:
                                    InvalidRegistration.ErrorMessage = "Unexpected error in registration (" + status.ToString() + ")";
                                    break;
                            }
                        }
                    }
                    else
                    {
                        DuplicateEmailValidator.IsValid = false;
                    }
                }
                else
                {
                    //CAPTCHA IS VISIBLE AND DID NOT AUTHENTICATE
                    CustomValidator invalidInput = new CustomValidator();
                    invalidInput.ID = Guid.NewGuid().ToString();
                    invalidInput.Text = "*";
                    invalidInput.ErrorMessage = "You did not input the verification number correctly.";
                    invalidInput.IsValid = false;
                    phCaptchaValidators.Controls.Add(invalidInput);
                    CaptchaInput.Text = "";
                    Password.Attributes.Add("value", string.Empty);
                    RefreshCaptcha();
                }
            }
        }

        private bool _PasswordLengthValidatorAdded = false;
        private void ShowPasswordPolicy()
        {
            //SHOW THE PASSWORD POLICY
            CustomerPasswordPolicy policy = new CustomerPasswordPolicy();
            if (policy.MinLength > 0)
            {
                PasswordPolicyLength.Text = string.Format(PasswordPolicyLength.Text, policy.MinLength);
                if (!_PasswordLengthValidatorAdded)
                {
                    RegularExpressionValidator PasswordLengthValidator = new RegularExpressionValidator();
                    PasswordLengthValidator.ID = "PasswordLengthValidator";
                    PasswordLengthValidator.EnableViewState = false;
                    PasswordLengthValidator.ControlToValidate = "Password";
                    PasswordLengthValidator.Text = "*";
                    PasswordLengthValidator.ErrorMessage = "Password must be at least " + policy.MinLength.ToString() + " characters.";
                    PasswordLengthValidator.ValidationExpression = ".{" + policy.MinLength.ToString() + ",}";
                    PasswordLengthValidator.SetFocusOnError = false;
                    PasswordLengthValidator.EnableClientScript = false;
                    PasswordLengthValidator.ValidationGroup = "Register";
                    PasswordValidatorPanel.Controls.Add(PasswordLengthValidator);
                    _PasswordLengthValidatorAdded = true;
                }
            }
            else PasswordPolicyLength.Visible = false;
            List<string> requirements = new List<string>();
            if (policy.RequireUpper) requirements.Add("uppercase letter");
            if (policy.RequireLower) requirements.Add("lowercase letter");
            if (policy.RequireNumber) requirements.Add("number");
            if (policy.RequireSymbol) requirements.Add("symbol");
            if (!policy.RequireNumber && !policy.RequireSymbol && policy.RequireNonAlpha) requirements.Add("non-letter");
            PasswordPolicyRequired.Visible = (requirements.Count > 0);
            if (PasswordPolicyRequired.Visible)
            {
                if (requirements.Count > 1) requirements[requirements.Count - 1] = "and " + requirements[requirements.Count - 1];
                PasswordPolicyRequired.Text = string.Format(PasswordPolicyRequired.Text, string.Join(", ", requirements.ToArray()));
            }
        }

        private bool ValidatePassword()
        {
            //VALIDATE PASSWORD POLICY
            CustomerPasswordPolicy policy = new CustomerPasswordPolicy();
            if (!policy.TestPassword(null, Password.Text))
            {
                CustomValidator policyValidator = new CustomValidator();
                policyValidator.ControlToValidate = "Password";
                policyValidator.IsValid = false;
                policyValidator.Text = "*";
                policyValidator.ErrorMessage = "The password does not meet the minimum requirements.";
                policyValidator.SetFocusOnError = false;
                policyValidator.ValidationGroup = "Register";
                PasswordValidatorPanel.Controls.Add(policyValidator);
                return false;
            }
            return true;
        }

        protected void ChangeImageLink_Click(object sender, EventArgs e)
        {
            RefreshCaptcha();
            Password.Attributes.Add("value", Password.Text);
        }

        private void RefreshCaptcha()
        {
            CaptchaImage.ChallengeText = StringHelper.RandomNumber(6);
        }
    }
}