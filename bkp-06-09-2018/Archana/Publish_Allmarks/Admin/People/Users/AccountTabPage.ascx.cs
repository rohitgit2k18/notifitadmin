namespace AbleCommerce.Admin.People.Users
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Web.Security;

    public partial class AccountTabPage : System.Web.UI.UserControl
    {
        private int _UserId;
        private User _User;

        protected void Page_Init(object sender, EventArgs e)
        {
            foreach (TaxExemptionType t in Enum.GetValues(typeof(TaxExemptionType)))
            {
                ListItem item = new ListItem(StringHelper.SpaceName(t.ToString()), ((int)t).ToString());
                TaxExemptionType.Items.Add(item);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
            _User = UserDataSource.Load(_UserId);

            if (!Page.IsPostBack)
            {
                // INITIALIZE LEFT COLUMN WITH ADJUSTABLE ACCOUNT SETTINGS
                UserName.Text = _User.UserName;
                Email.Text = _User.Email;
                IsDisabled.Enabled = (_User.Id != AbleContext.Current.UserId);
                IsDisabled.Checked = !_User.IsApproved;
                ListItem selectedItem = TaxExemptionType.Items.FindByValue(((int)_User.TaxExemptionType).ToString());
                if (selectedItem != null) TaxExemptionType.SelectedIndex = TaxExemptionType.Items.IndexOf(selectedItem);
                TaxExemptionReference.Text = _User.TaxExemptionReference;
            }

            InitializeChangeGroupsJS();

            // INITIALIZE RIGHT COLUMN OF PASSWORD DETAILS
            RegisteredSinceDate.Text = _User.CreateDate.ToString("g");
            if (_User.LastActivityDate.HasValue && _User.LastActivityDate > System.DateTime.MinValue)
            {
                LastActiveDate.Text = _User.LastActivityDate.Value.ToString("g");
            }
            FailedLoginCount.Text = _User.FailedPasswordAttemptCount.ToString();
            if (_User.LastLockoutDate.HasValue && _User.LastLockoutDate > System.DateTime.MinValue)
            {
                LastLockoutDate.Text = _User.LastLockoutDate.Value.ToString("g");
            }
            if (_User.Passwords.Count > 0)
            {
                TimeSpan ts = LocaleHelper.LocalNow - _User.Passwords[0].CreateDate;
                string timeSpanPhrase;
                if (ts.Days > 0) timeSpanPhrase = ts.Days.ToString() + " days";
                else if (ts.Hours > 0) timeSpanPhrase = ts.Hours.ToString() + " hours";
                else timeSpanPhrase = ts.Minutes.ToString() + " minutes";
                PasswordLastChangedText.Text = string.Format(PasswordLastChangedText.Text, timeSpanPhrase);
            }
            else
            {
                PasswordLastChangedText.Visible = false;
            }

            // DISPLAY POLICY ON CHANGE PASSWORD FORM
            PasswordPolicy policy;
            if (_User.IsAdmin) policy = new MerchantPasswordPolicy();
            else policy = new CustomerPasswordPolicy();
            PasswordPolicyLength.Text = string.Format(PasswordPolicyLength.Text, policy.MinLength);
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

            bool showLoginAs = ((_User.Id != AbleContext.Current.UserId) && (!_User.IsAdmin));
            if (showLoginAs)
            {
                LoginUserButton.Visible = true;
                LoginUserButton.OnClientClick = string.Format(LoginUserButton.OnClientClick, _User.UserName);
            }
            else
            {
                LoginUserButton.Visible = false;
            }
        }

        protected void LoginUserButton_Click(object sender, EventArgs e)
        {
            int newUserId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
            User user = UserDataSource.Load(newUserId);
            if ((user != null) && (user.Id != AbleContext.Current.UserId) && (!user.IsAdmin))
            {
                //LOGIN AS USER AND SEND TO THE STORE HOME PAGE
                FormsAuthentication.SetAuthCookie(user.UserName, false);
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl());
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!_User.IsAnonymous)
            {
                // HANDLE GROUP DISPLAY HERE TO REACT TO CHANGES
                GroupList.Text = GetGroupList();
                GroupListChanged.Value = string.Empty;
                InitializeChangeGroupsDialog();
                SubscriptionsPanel.Visible = (SubscriptionGrid.Rows.Count > 0);
            }
            ShowHideDisabledAlert();

            // update referred date in the event it has changed
            if (_User.Affiliate != null && _User.AffiliateReferralDate.HasValue && _User.AffiliateReferralDate != DateTime.MinValue)
            {
                ReferredDate.Text = string.Format(" on {0}", _User.AffiliateReferralDate.Value.ToShortDateString());
            }
            else
            {
                ReferredDate.Text = string.Empty;
            }
        }

        /// <summary>
        /// Initializes javascript required by the change groups dialog
        /// </summary>
        private void InitializeChangeGroupsJS()
        {
            this.Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "selectbox", this.ResolveUrl("~/Scripts/selectbox.js"));
            string leftBoxName = AvailableGroups.ClientID;
            string rightBoxName = SelectedGroups.ClientID;
            AvailableGroups.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, '')");
            SelectedGroups.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, '');");
            SelectAllGroups.Attributes.Add("onclick", "moveAllOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, ''); return false;");
            SelectGroup.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, ''); return false;");
            UnselectGroup.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, ''); return false;");
            UnselectAllGroups.Attributes.Add("onclick", "moveAllOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, ''); return false;");
            StringBuilder changeGroupListScript = new StringBuilder();
            changeGroupListScript.AppendLine("function changeGroupList(){");
            changeGroupListScript.AppendLine("\t$get('" + HiddenSelectedGroups.ClientID + "').value=getOptions($get('" + rightBoxName + "'));");
            changeGroupListScript.AppendLine("\t$get('" + GroupList.ClientID + "').innerHTML=getOptionNames($get('" + rightBoxName + "'));");
            changeGroupListScript.AppendLine("}");
            this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "changeGroupList", changeGroupListScript.ToString(), true);
        }

        /// <summary>
        /// Initializes the change groups dialog with current user group settings
        /// </summary>
        private void InitializeChangeGroupsDialog()
        {
            AvailableGroups.Items.Clear();
            SelectedGroups.Items.Clear();
            IList<Group> managableGroups = SecurityUtility.GetManagableGroups();
            IList<string> subscriptionGroups = new List<string>();
            foreach (Group group in managableGroups)
            {
                if (group.SubscriptionPlans != null && group.SubscriptionPlans.Count > 0)
                {
                    if (_User.IsInGroup(group.Id))
                    {
                        subscriptionGroups.Add(group.Name);
                        PHSubscriptionGroups.Controls.Add(new LiteralControl(string.Format("<option disabled='disabled'>{0}</option>", group.Name)));
                    }
                }
                else
                {
                    ListItem newItem = new ListItem(group.Name, group.Id.ToString());
                    bool groupSelected = _User.IsInGroup(group.Id);
                    if (groupSelected) SelectedGroups.Items.Add(newItem);
                    else AvailableGroups.Items.Add(newItem);
                }
            }
            phMyGroupsWarning.Visible = (_UserId == AbleContext.Current.UserId);
            SubscriptionGroupLI.Visible = subscriptionGroups.Count > 0;
        }

        /// <summary>
        /// Gets a comma delimited list of assigned group names for the current user
        /// </summary>
        /// <returns>Comma delimited list of group names, or the empty text if no 
        /// groups are assigned to the user</returns>
        protected string GetGroupList()
        {
            List<string> groupNames = new List<string>();
            foreach (UserGroup ur in _User.UserGroups)
            {
                if (ur.Group != null)
                {
                    groupNames.Add(ur.Group.Name);
                }
            }
            if (groupNames.Count == 0) return string.Empty;
            return string.Join(", ", groupNames.ToArray());
        }

        protected void ChangeGroupListOKButton_Click(object sender, System.EventArgs e)
        {
            // REMOVE ANY MANAGEABLE GROUPS ASSOCIATED WITH USER, EXCEPT THE SUBSCRIPTION GROUPS
            IList<Group> managableGroups = SecurityUtility.GetManagableGroups();
            for (int i = _User.UserGroups.Count - 1; i >= 0; i--)
            {
                if (managableGroups.IndexOf(_User.UserGroups[i].GroupId) > -1 &&
                    _User.UserGroups[i].Subscription == null)
                {
                    _User.UserGroups.DeleteAt(i);
                }
            }

            // LOOP SUBMITTED GROUPS AND ADD (VALID) SELECTED GROUPS
            int[] selectedGroups = AlwaysConvert.ToIntArray(Request.Form[HiddenSelectedGroups.UniqueID]);
            if (selectedGroups != null && selectedGroups.Length > 0)
            {
                foreach (int groupId in selectedGroups)
                {
                    int index = managableGroups.IndexOf(groupId);
                    if (index > -1)
                    {
                        _User.UserGroups.Add(new UserGroup(_User, managableGroups[index]));
                    }
                }
            }
            else
            {
                // ASSIGN TO DEFAULT USER GROUP (NO MATTER USER HAVE SOME SUBSCRIPTION GROUPS ALREADY ASSIGNED)
                _User.UserGroups.Add(new UserGroup(_User, GroupDataSource.LoadForName(Group.DefaultUserGroupName)));
            }

            // SAVE ANY CHANGES TO USER GROUPS
            _User.Save();
        }

        private List<int> GetValidGroupIds()
        {
            List<int> allGroupIds = new List<int>();
            IList<Group> allGroups = GroupDataSource.LoadAll();
            foreach (Group c in allGroups) allGroupIds.Add(c.Id);
            return allGroupIds;
        }

        protected void ChangePasswordOKButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && EnforcePasswordPolicy())
            {
                string password = NewPassword.Text.Trim();
                _User.SetPassword(password, ForceExpiration.Checked);
                ChangePasswordPopup.Hide();
            }
            else
            {
                ChangePasswordPopup.Show();
            }
        }

        protected void ChangePasswordCancelButton_Click(object sender, EventArgs e)
        {
            NewPassword.Text = string.Empty;
            ConfirmNewPassword.Text = string.Empty;
            ChangePasswordPopup.Hide();
        }

        protected bool EnforcePasswordPolicy()
        {
            // DETERMINE THE APPROPRIATE POLICY FOR THE USER
            PasswordPolicy policy;
            if (_User.IsAdmin) policy = new MerchantPasswordPolicy();
            else policy = new CustomerPasswordPolicy();

            // CHECK IF PASSWORD MEETS POLICY
            PasswordTestResult result = policy.TestPasswordWithFeedback(NewPassword.Text.Trim());
            if ((result & PasswordTestResult.Success) == PasswordTestResult.Success) return true;

            // PASSWORD DOES NOT MEET POLICY
            StringBuilder newErrorMessage = new StringBuilder();
            newErrorMessage.Append(PasswordPolicyValidator.ErrorMessage + "<ul>");
            if ((result & PasswordTestResult.PasswordTooShort) == PasswordTestResult.PasswordTooShort) newErrorMessage.Append("<li>New password length must be at least " + policy.MinLength.ToString() + " characters.</li>");
            if ((result & PasswordTestResult.RequireLower) == PasswordTestResult.RequireLower) newErrorMessage.Append("<li>New password must contain at least one lowercase letter.<li>");
            if ((result & PasswordTestResult.RequireUpper) == PasswordTestResult.RequireUpper) newErrorMessage.Append("<li>New password must contain at least one uppercase letter.</li>");
            if ((result & PasswordTestResult.RequireNonAlpha) == PasswordTestResult.RequireNonAlpha) newErrorMessage.Append("<li>New password must contain at least one non-letter.</li>");
            if ((result & PasswordTestResult.RequireNumber) == PasswordTestResult.RequireNumber) newErrorMessage.Append("<li>New password must contain at least one number.</li> ");
            if ((result & PasswordTestResult.RequireSymbol) == PasswordTestResult.RequireSymbol) newErrorMessage.Append("<li>New password must contain at least one symbol.</li>");
            PasswordPolicyValidator.ErrorMessage = newErrorMessage.ToString() + "</ul>";
            PasswordPolicyValidator.IsValid = false;
            return false;
        }

        private bool ValidateNewUserName(string newUserName)
        {
            if (!_User.UserName.Equals(newUserName, StringComparison.InvariantCultureIgnoreCase))
            {
                //user name has been changed. verify if new user name is available
                int existingUserId = UserDataSource.GetUserIdByUserName(newUserName);
                if (existingUserId > 0)
                {
                    UserNameAvailableValidator.ErrorMessage = string.Format(UserNameAvailableValidator.ErrorMessage, newUserName);
                    UserNameAvailableValidator.IsValid = false;
                    return false;
                }
            }
            return true;
        }

        protected void SaveAccountButton_Click(object sender, EventArgs e)
        {
            if (SaveAccount())
            {
                AccountSavedMessage.Text = string.Format(AccountSavedMessage.Text, LocaleHelper.LocalNow);
                AccountSavedMessage.Visible = true;
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            // save 
            if (SaveAccount())
            {
                // redirect away
                Response.Redirect("Default.aspx");
            }
        }

        private bool SaveAccount()
        {
            string newUserName = UserName.Text.Trim();
            if (Page.IsValid && ValidateNewUserName(newUserName))
            {
                //UPDATE ACCOUNT SETTINGS
                _User.UserName = newUserName;
                _User.Email = Email.Text;
                _User.PrimaryAddress.Email = Email.Text;

                // PREVENT DISABLING OF YOUR OWN ACCOUNT
                if (_User.Id != AbleContext.Current.UserId)
                {
                    _User.IsApproved = !IsDisabled.Checked;
                    ShowHideDisabledAlert();
                }

                // UPDATE AFFILIATE ASSOCIATION
                int affliateId = AlwaysConvert.ToInt(Affiliate.SelectedValue, 0);
                _User.Affiliate = AffiliateDataSource.Load(affliateId);
                _User.AffiliateReferralDate = LocaleHelper.LocalNow;

                // UPDATE TAX EXEMPTIONS
                _User.TaxExemptionType = (TaxExemptionType)AlwaysConvert.ToInt(TaxExemptionType.SelectedValue);
                _User.TaxExemptionReference = TaxExemptionReference.Text;

                // SAVE USER SETTINGS
                _User.Save();

                return true;
            }

            return false;
        }
        protected string GetSubGroupName(object dataItem)
        {
            Subscription s = (Subscription)dataItem;
            Group g = GroupDataSource.Load(AlwaysConvert.ToInt(s.GroupId));
            if (g != null) return g.Name;
            else return string.Empty;
        }

        protected void SubscriptionGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int subscriptionId = AlwaysConvert.ToInt(e.CommandArgument);
            Subscription subscription = SubscriptionDataSource.Load(subscriptionId);
            switch (e.CommandName)
            {
                case "Activate":
                    subscription.Activate();
                    SubscriptionGrid.DataBind();
                    break;
                case "CancelSubscription":
                    subscription.Delete();
                    SubscriptionGrid.DataBind();
                    break;
            }
        }

        protected void SubscriptionGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int subscriptionId = (int)SubscriptionGrid.DataKeys[e.RowIndex].Value;
            Subscription subscription = SubscriptionDataSource.Load(subscriptionId);
            if (subscription != null)
            {
                subscription.ExpirationDate = AlwaysConvert.ToDateTime(e.NewValues["ExpirationDate"], DateTime.MinValue);
                subscription.Save();
            }
            SubscriptionGrid.EditIndex = -1;
            e.Cancel = true;
        }

        protected void ShowHideDisabledAlert()
        {
            if (IsDisabled.Checked)
                IsDisabled.Text = "This account is disabled.";
            else
                IsDisabled.Text = string.Empty;
        }

        protected void Affiliate_DataBound(Object sender, EventArgs e)
        {
            if (_User != null && _User.Affiliate != null) SetSelectedItem(Affiliate, _User.Affiliate.Id.ToString());
        }

        private void SetSelectedItem(DropDownList list, string selectedValue)
        {
            if (list.SelectedItem != null) list.SelectedItem.Selected = false;
            ListItem selectedItem = list.Items.FindByValue(selectedValue);
            if (selectedItem != null) selectedItem.Selected = true;
        }

        protected void BackButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        protected string GetExpiration(object o)
        {
            Subscription subscription = o as Subscription;
            if (subscription != null && subscription.ExpirationDate.HasValue && subscription.ExpirationDate != DateTime.MinValue && subscription.ExpirationDate.Value.Year != DateTime.MaxValue.Year)
                return string.Format("{0:d}", subscription.ExpirationDate);
            return "N/A";
        }

        protected string GetNextPayment(object dataItem)
        {
            Subscription subscription = (Subscription)dataItem;
            DateTime paymentDate = subscription.NextOrderDateForDisplay;
            return paymentDate == DateTime.MinValue ? "N/A" : paymentDate.ToShortDateString();
        }

        protected string GetEditSubscriptionUrl(object dataItem)
        {
            Subscription subscription = (Subscription)dataItem;
            string returnUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(string.Format("~/Admin/People/Users/EditUser.aspx?UserId={0}", _UserId)));
            string editUrl = string.Format("~/Admin/People/Subscriptions/EditSubscription.aspx?SubscriptionId={0}&ReturnUrl={1}", subscription.Id, returnUrl);
            return editUrl;
        }
    }
}