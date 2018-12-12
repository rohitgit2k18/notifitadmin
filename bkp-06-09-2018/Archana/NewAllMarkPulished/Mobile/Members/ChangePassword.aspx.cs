using System;
using System.Collections.Generic;
using System.Web.Security;
using System.Web.UI;
using CommerceBuilder.Common;
using CommerceBuilder.Users;
using CommerceBuilder.Marketing;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;

namespace AbleCommerce.Mobile.Members
{
    public partial class ChangePassword : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            // CONFIGURE SCREEN FOR NEW ACCOUNT CREATION
            trCurrentPassword.Visible = true;
            NewAccountText.Visible = false;
            UpdateAccountText.Visible = true;

            PasswordPolicy policy;
            if (user.IsAdmin) policy = new MerchantPasswordPolicy();
            else policy = new CustomerPasswordPolicy();
            PasswordPolicyLength.Text = string.Format(PasswordPolicyLength.Text, policy.MinLength);
            PasswordPolicyHistoryCount.Visible = (policy.HistoryCount > 0);
            if (PasswordPolicyHistoryCount.Visible) PasswordPolicyHistoryCount.Text = string.Format(PasswordPolicyHistoryCount.Text, policy.HistoryCount);
            PasswordPolicyHistoryDays.Visible = (policy.HistoryDays > 0);
            if (PasswordPolicyHistoryDays.Visible) PasswordPolicyHistoryDays.Text = string.Format(PasswordPolicyHistoryDays.Text, policy.HistoryDays);
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

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                User user = AbleContext.Current.User;
                string currentUserName = user.UserName;

                // VALIDATE THE PASSWORD IF THIS IS NOT AN ANONYMOUS USER
                bool validPassword;
                if (!user.IsAnonymousOrGuest)
                {
                    validPassword = Membership.ValidateUser(currentUserName, CurrentPassword.Text);
                    if (!validPassword)
                    {
                        InvalidPassword.IsValid = false;
                        return;
                    }
                }
                else validPassword = true;

                // VALIDATE NEW PASSWORD AGASINT POLICY
                if (Password.Text.Length > 0)
                {
                    PasswordPolicy policy;
                    if (user.IsAdmin) policy = new MerchantPasswordPolicy();
                    else policy = new CustomerPasswordPolicy();
                    PasswordTestResult result = policy.TestPasswordWithFeedback(user, Password.Text);
                    if ((result & PasswordTestResult.Success) != PasswordTestResult.Success)
                    {
                        PasswordPolicyValidator.ErrorMessage += "<UL>";
                        if ((result & PasswordTestResult.PasswordTooShort) == PasswordTestResult.PasswordTooShort) AddPwdValidationError(string.Format(PasswordPolicyLength.Text, policy.MinLength));
                        if ((result & PasswordTestResult.RequireLower) == PasswordTestResult.RequireLower) AddPwdValidationError("New password must contain at least one lowercase letter.");
                        if ((result & PasswordTestResult.RequireUpper) == PasswordTestResult.RequireUpper) AddPwdValidationError("New password must contain at least one uppercase letter. ");
                        if ((result & PasswordTestResult.RequireNonAlpha) == PasswordTestResult.RequireNonAlpha) AddPwdValidationError("New password must contain at least one non-letter.");
                        if ((result & PasswordTestResult.RequireNumber) == PasswordTestResult.RequireNumber) AddPwdValidationError("New password must contain at least one number.");
                        if ((result & PasswordTestResult.RequireSymbol) == PasswordTestResult.RequireSymbol) AddPwdValidationError("New password must contain at least one symbol.");
                        if ((result & PasswordTestResult.PasswordHistoryLimitation) == PasswordTestResult.PasswordHistoryLimitation)
                        {
                            AddPwdValidationError("You have recently used this password.");
                        }
                        PasswordPolicyValidator.ErrorMessage += "</UL>";
                        PasswordPolicyValidator.IsValid = false;
                        return;
                    }
                }
                else if (user.IsAnonymousOrGuest)
                {
                    // PASSWORD IS REQUIRED FOR NEW ANONYMOUS ACCOUNTS
                    PasswordRequiredValidator.IsValid = false;
                    return;
                }

                // UPDATE THE USER RECORD WITH NEW VALUES
                user.Save();

                // UPDATE PASSWORD IF INDICATED
                if (Password.Text.Length > 0)
                {
                    user.SetPassword(Password.Text);
                }

                // DISPLAY RESULT
                ConfirmationMsg.Visible = true;
            }
        }

        private void AddPwdValidationError(string message)
        {
            PasswordPolicyValidator.ErrorMessage += message;
        }
    }
}