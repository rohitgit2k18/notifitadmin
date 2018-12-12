namespace AbleCommerce.Members
{
    using System;
    using System.Collections.Generic;
    using System.Web.Security;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;
    using CommerceBuilder.Marketing;
    using System.Web.UI.WebControls;
using CommerceBuilder.Stores;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;

    public partial class MyCredentials : CommerceBuilder.UI.AbleCommercePage
    {
        private StoreSettingsManager _settings;

        protected void Page_Init(object sender, EventArgs e)
        {
            _settings = AbleContext.Current.Store.Settings;
            IList<EmailList> publicLists = GetPublicEmailLists();
            if (publicLists.Count > 0)
            {
                dlEmailLists.DataSource = publicLists;
                dlEmailLists.DataBind();
            }
            else
            {
                phEmailLists.Visible = false;
            }
        }

        protected bool IsInList(object dataItem)
        {
            EmailList list = (EmailList)dataItem;
            return list.IsMember(AbleContext.Current.User.Email);
        }

        private IList<EmailList> GetPublicEmailLists()
        {
            IList<EmailList> publicLists = new List<EmailList>();
            IList<EmailList> allLists = EmailListDataSource.LoadAll();
            foreach (EmailList list in allLists)
            {
                if (list.IsPublic) publicLists.Add(list);
            }
            return publicLists;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            if (!user.IsAnonymousOrGuest)
            {
                // handling for registered users
                NewAccountText.Visible = false;
                UpdateAccountText.Visible = true;
                if (!Page.IsPostBack)
                {
                    UserName.Text = user.UserName;
                    Email.Text = user.Email;
                }
            }
            else
            {
                // handling for guest users
                if (!Page.IsPostBack)
                {
                    // TRY TO DEFAULT THE EMAIL ADDRESS TO LAST ORDER EMAIL
                    int orderCount = user.Orders.Count;
                    if (orderCount > 0)
                    {
                        UserName.Text = user.Orders[orderCount - 1].BillToEmail;
                        Email.Text = UserName.Text;
                    }
                }

                // CONFIGURE SCREEN FOR NEW ACCOUNT CREATION
                trCurrentPassword.Visible = false;
                NewAccountText.Visible = true;
                UpdateAccountText.Visible = false;
            }

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

            phReviewReminders.Visible = _settings.ProductReviewEnabled != UserAuthFilter.None && _settings.ProductReviewReminderEnabled;
            if (!Page.IsPostBack)
            { 
                ReviewReminders.Checked = !user.Settings.OptOutReviewReminders;
            }

            trEmailPrefs.Visible = phReviewReminders.Visible || phEmailLists.Visible;
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

                // IF USERNAME IS CHANGED, VALIDATE THE NEW NAME IS AVAILABLE
                string newUserName = UserName.Text.Trim();
                bool userNameChanged = (currentUserName != newUserName);
                if (userNameChanged)
                {
                    // CHECK IF THERE IS ALREADY A USER WITH DESIRED USERNAME
                    if (UserDataSource.GetUserIdByUserName(newUserName) > 0)
                    {
                        // A USER ALREADY EXISTS WITH THAT NAME
                        phUserNameUnavailable.Visible = true;
                        return;
                    }
                }

                // OPT-OUT REVIEW REMINDERS
                user.Settings.OptOutReviewReminders = !ReviewReminders.Checked;

                // UPDATE THE USER RECORD WITH NEW VALUES
                user.Email = Email.Text.Trim();
                user.PrimaryAddress.Email = user.Email;
                user.UserName = newUserName;
                user.Save();

                // RESET AUTH COOKIE WITH NEW USERNAME IF NEEDED
                if (userNameChanged) FormsAuthentication.SetAuthCookie(newUserName, false);

                // UPDATE PASSWORD IF INDICATED
                if (Password.Text.Length > 0)
                {
                    user.SetPassword(Password.Text);
                }

                // UPDATE MAILING PREFERENCES
                if (phEmailLists.Visible) UpdateEmailLists();

                // DISPLAY RESULT
                SavedMessage.Visible = true;
            }
        }

        private void AddPwdValidationError(string message)
        {
            PasswordPolicyValidator.ErrorMessage += message;
        }

        private void UpdateEmailLists()
        {
            // DETERMINE SELECTED LISTS
            List<int> offList = new List<int>();
            List<int> onList = new List<int>();
            int index = 0;
            foreach (DataListItem item in dlEmailLists.Items)
            {
                int tempListId = (int)dlEmailLists.DataKeys[index];
                CheckBox selected = (CheckBox)item.FindControl("Selected");
                if ((selected != null) && (selected.Checked))
                {
                    onList.Add(tempListId);
                }
                else
                {
                    offList.Add(tempListId);
                }
                index++;
            }
            string email = AbleContext.Current.User.Email;

            // PROCESS LISTS THAT SHOULD NOT BE SUBSCRIBED
            foreach (int emailListId in offList)
            {
                EmailListUser elu = EmailListUserDataSource.Load(emailListId, email);
                if (elu != null) elu.Delete();
            }

            // PROCESS LISTS THAT SHOULD BE SUBSCRIBED
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            foreach (int emailListId in onList)
            {
                EmailListUser elu = EmailListUserDataSource.Load(emailListId, email);
                if (elu == null)
                {
                    EmailList list = EmailListDataSource.Load(emailListId);
                    if (list != null) list.ProcessSignupRequest(email);
                }
            }
            database.CommitTransaction();
        }
    }
}