namespace AbleCommerce.Admin.People.Users
{
    using System;
    using System.Collections.Generic;
    using System.Web.Security;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Linq;
    using System.Web.Script.Serialization;
    using System.Web.UI;
    using System.Web.Services;
    using System.Web.UI.HtmlControls;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected bool ReBindResults { get; set; }

        protected void Page_Init(object sender, EventArgs e)
        {
            AlphabetRepeater.DataSource = GetAlphabetDS();
            AlphabetRepeater.DataBind();
            AbleCommerce.Code.PageHelper.SetDefaultButton(SearchEmail, SearchButton.ClientID);
            SearchGroup.DataSource = AbleContext.Current.Store.Groups;
            SearchGroup.DataTextField = "Name";
            SearchGroup.DataValueField = "GroupId";
            SearchGroup.DataBind();
            AddGroup.DataSource = SecurityUtility.GetManagableGroups()
                .Where(group => group.Name != Group.DefaultUserGroupName);
            AddGroup.DataBind();
            trAddGroup.Visible = AddGroup.Items.Count > 1;
            if (!Page.IsPostBack) LoadLastSearch();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            UserSearchCriteria filter = Session["UserSearchCriteria"] as UserSearchCriteria;
            if (filter == null) filter = new UserSearchCriteria();

            var serializer = new JavaScriptSerializer();
            var result = serializer.Serialize(filter);
            ScriptManager.RegisterClientScriptBlock(Page, typeof(Page), "searchQueryJson", "var searchQuery = " + result + ";", true);
            gridFooter.Visible = UserGrid.Rows.Count > 0;
        }

        /// <summary>
        /// Restores the last user search criteria if available
        /// </summary>
        private void LoadLastSearch()
        {
            // LOAD CRITERIA FROM SESSION
            UserSearchCriteria criteria = Session["UserSearchCriteria"] as UserSearchCriteria;
            if (criteria != null)
            {
                SearchUserName.Text = criteria.UserName;
                SearchEmail.Text = criteria.Email;
                SearchFirstName.Text = criteria.FirstName;
                SearchLastName.Text = criteria.LastName;
                SearchCompany.Text = criteria.Company;
                SearchPhone.Text = criteria.Phone;
                ListItem selectedItem = SearchGroup.Items.FindByValue(criteria.GroupId.ToString());
                if (selectedItem != null)
                {
                    SearchGroup.SelectedIndex = SearchGroup.Items.IndexOf(selectedItem);
                }
                SearchIncludeAnonymous.Checked = criteria.IncludeAnonymous;
                ShowDisabledUsers.Checked = criteria.ShowDisabledUsers;

                ResetSearchButton.Visible = true;
            }
        }

        protected string GetFullName(object dataItem)
        {
            User user = (User)dataItem;
            Address address = user.PrimaryAddress;
            if (address != null)
            {
                if (!string.IsNullOrEmpty(address.FirstName) && !string.IsNullOrEmpty(address.LastName)) return ((string)(address.LastName + ", " + address.FirstName)).Trim();
                return ((string)(address.LastName + address.FirstName)).Trim();
            }
            return string.Empty;
        }

        protected string GetUserGroups(object dataItem)
        {
            User user = (User)dataItem;
            List<string> groups = new List<string>();
            foreach (UserGroup userGroup in user.UserGroups)
            {
                groups.Add(userGroup.Group.Name);
            }
            return string.Join(", ", groups.ToArray());
        }

        protected string[] GetAlphabetDS()
        {
            string[] alphabet = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "All" };
            return alphabet;
        }

        protected void AlphabetRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if ((e.CommandArgument.ToString().Length == 1))
            {
                SearchUserName.Text = (e.CommandArgument.ToString() + "*");
            }
            else
            {
                SearchUserName.Text = String.Empty;
            }
            // CLEAR OUT OTHER CRITERIA
            SearchEmail.Text = string.Empty;
            SearchFirstName.Text = string.Empty;
            SearchLastName.Text = string.Empty;
            SearchGroup.SelectedIndex = 0;
            SearchCompany.Text = string.Empty;
            SearchPhone.Text = string.Empty;
            UserGrid.DataBind();
        }

        protected void UserGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Login")
            {
                int newUserId = AlwaysConvert.ToInt(e.CommandArgument);
                User user = UserDataSource.Load(newUserId);
                if ((user != null) && (user.Id != AbleContext.Current.UserId) && (!user.IsAdmin))
                {
                    //LOGIN AS USER AND SEND TO THE STORE HOME PAGE
                    FormsAuthentication.SetAuthCookie(user.UserName, false);
                    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl());
                }
            }
        }

        protected bool IsEditable(object dataItem)
        {
            User user = (User)dataItem;
            if (user.IsSystemAdmin && !AbleContext.Current.User.IsSystemAdmin) return false;
            else if (user.IsAdmin && (AbleContext.Current.User.Id != user.Id && !AbleContext.Current.User.IsSecurityAdmin)) return false;
            else return true;
        }

        protected bool IsDeletable(object dataItem)
        {
            User user = (User)dataItem;
            if ((user.Id == AbleContext.Current.UserId) || user.IsSystemAdmin && !AbleContext.Current.User.IsSystemAdmin) return false;
            else if (user.IsAdmin && (AbleContext.Current.User.Id != user.Id && !AbleContext.Current.User.IsSecurityAdmin)) return false;
            else return true;
        }

        protected bool IsNotMeOrAdmin(object dataItem)
        {
            User user = (User)dataItem;
            return ((user.Id != AbleContext.Current.UserId) && (!user.IsAdmin));
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            UserGrid.PageIndex = 0;
            UserGrid.DataBind();

            // DISPLAY THE RESET BUTTON
            ResetSearchButton.Visible = true;
        }

        protected void ResetButton_Click(object sender, EventArgs e)
        {
            // RESET THE SESSION
            Session.Remove("UserSearchCriteria");

            // RESET THE FORM
            SearchUserName.Text = string.Empty;
            SearchEmail.Text = string.Empty;
            SearchFirstName.Text = string.Empty;
            SearchLastName.Text = string.Empty;
            SearchCompany.Text = string.Empty;
            SearchPhone.Text = string.Empty;
            SearchGroup.SelectedIndex = 0;
            SearchIncludeAnonymous.Checked = false;

            // EXECUTE THE SEARCH AND HIDE THE RESET BUTTON
            SearchButton_Click(sender, e);
            ResetSearchButton.Visible = false;
        }

        private UserSearchCriteria GetSearchCriteria()
        {
            // BUILD THE SEARCH CRITERIA
            UserSearchCriteria criteria = new UserSearchCriteria();
            criteria.UserName =  StringHelper.StripHtml(SearchUserName.Text.Trim());
            criteria.Email =  StringHelper.StripHtml(SearchEmail.Text.Trim());
            criteria.FirstName =  StringHelper.StripHtml(SearchFirstName.Text.Trim());
            criteria.LastName =  StringHelper.StripHtml(SearchLastName.Text.Trim());
            criteria.Company =  StringHelper.StripHtml(SearchCompany.Text.Trim());
            criteria.Phone = StringHelper.StripHtml(SearchPhone.Text.Trim());
            criteria.GroupId = AlwaysConvert.ToInt(SearchGroup.SelectedValue);
            criteria.IncludeAnonymous = SearchIncludeAnonymous.Checked;
            criteria.ShowDisabledUsers = ShowDisabledUsers.Checked;
            return criteria;
        }

        protected void UserDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            UserSearchCriteria criteria = GetSearchCriteria();
            Session["UserSearchCriteria"] = criteria;
            e.InputParameters["criteria"] = criteria;
        }
        
        #region Add User
        protected void SaveButton_Click(object sender, EventArgs e)
        {
            // CHECK IF PAGE IS VALID
            if (Page.IsValid)
            {
                // MAKE SURE PASSWORD VALIDATES AGAINST POLICY
                if (ValidatePassword())
                {
                    // ATTEMPT TO CREATE THE USER
                    MembershipCreateStatus status;
                    User newUser = UserDataSource.CreateUser(AddEmail.Text, AddEmail.Text, AddPassword.Text, string.Empty, string.Empty, true, 0, out status);
                    if (status == MembershipCreateStatus.Success)
                    {
                        // FORCE PASSWORD EXPIRATION
                        newUser.Passwords[0].ForceExpiration = ForceExpiration.Checked;
                        newUser.Passwords[0].Save();

                        // ASSIGN GROUPS TO NEW USER
                        IList<Group> availableGroups = SecurityUtility.GetManagableGroups();
                        int groupId = AlwaysConvert.ToInt(AddGroup.SelectedValue);
                        if (groupId > 0)
                        {
                            int index = availableGroups.IndexOf(groupId);
                            if (groupId > -1)
                            {
                                // ADD THE GROUP ASSOCIATION FOR THE NEW USER
                                newUser.UserGroups.Add(new UserGroup(newUser, availableGroups[index]));
                                newUser.Save();
                            }
                        }

                        // REDIRECT TO EDIT FORM IF INDICATED
                        if (((Button)sender).ID == "AddEditButton")
                            Response.Redirect("EditUser.aspx?UserId=" + newUser.Id.ToString());

                        // NO REDIRECT, DISPLAY A CONFIRMATION FOR CREATED USER
                        UserAddedMessage.Text = string.Format(UserAddedMessage.Text, newUser.UserName);
                        UserAddedMessage.Visible = true;

                        // RESET THE ADD FORM FIELDS
                        AddEmail.Text = String.Empty;
                        AddPassword.Text = String.Empty;
                        AddConfirmPassword.Text = String.Empty;
                        AddGroup.SelectedIndex = -1;

                        //REBIND THE SEARCH
                        UserGrid.DataBind();
                    }
                    else
                    {
                        // CREATE USER FAILED WITHIN THE API
                        switch (status)
                        {
                            case MembershipCreateStatus.DuplicateEmail:
                            case MembershipCreateStatus.DuplicateUserName:
                                AddCustomValidationError(phEmailValidation, AddEmail, "The email address is already registered.");
                                break;
                            case MembershipCreateStatus.InvalidEmail:
                            case MembershipCreateStatus.InvalidUserName:
                                AddCustomValidationError(phEmailValidation, AddEmail, "The email address is invalid.");
                                break;
                            case MembershipCreateStatus.InvalidPassword:
                                AddCustomValidationError(phPasswordValidation, AddPassword, "The password is invalid.");
                                break;
                            default:
                                AddCustomValidationError(phEmailValidation, AddEmail, "Unexpected error: " + status.ToString());
                                break;
                        }
                        AddPopup.Show();
                    }
                }
                else AddPopup.Show();
            }
            else AddPopup.Show();
        }

        /// <summary>
        /// Determine if the group has an associated admin role
        /// </summary>
        /// <param name="group">Group to check for association with an admin role</param>
        /// <returns>True if the group is associated with an admin role, false otherwise.</returns>
        private bool IsAdminGroup(Group group)
        {
            if (group != null)
            {
                foreach (string adminRole in Role.AllAdminRoles)
                {
                    if (group.IsInRole(adminRole)) return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Validates the password against the effective policy
        /// </summary>
        /// <returns>True if the password is valid, false if it does not meet the policy requirements.</returns>
        private bool ValidatePassword()
        {
            // GET THE INITIAL GROUP SO WE CAN DETERMINE PASSWORD POLICY TO EMPLOY
            int groupId = AlwaysConvert.ToInt(AddGroup.SelectedValue);
            CommerceBuilder.Users.Group group = GroupDataSource.Load(groupId);

            // LOAD THE APPROPRIATE PASSWORD POLICY
            PasswordPolicy policy;
            if (IsAdminGroup(group)) policy = new MerchantPasswordPolicy();
            else policy = new CustomerPasswordPolicy();

            PasswordTestResult result = policy.TestPasswordWithFeedback(null, AddPassword.Text);
            if ((result & PasswordTestResult.Success) != PasswordTestResult.Success)
            {
                // THE PASSWORD DOES NOT MEET THE POLICY
                if ((result & PasswordTestResult.PasswordTooShort) == PasswordTestResult.PasswordTooShort)
                {
                    AddCustomValidationError(phPasswordValidation, AddPassword, "Password length must be at least " + policy.MinLength.ToString() + " characters.");
                }
                if ((result & PasswordTestResult.RequireUpper) == PasswordTestResult.RequireUpper)
                {
                    AddCustomValidationError(phPasswordValidation, AddPassword, "Password must contain at least one uppercase character.");
                }
                if ((result & PasswordTestResult.RequireLower) == PasswordTestResult.RequireLower)
                {
                    AddCustomValidationError(phPasswordValidation, AddPassword, "Password must contain at least one lowercase character.");
                }
                if ((result & PasswordTestResult.RequireNumber) == PasswordTestResult.RequireNumber)
                {
                    AddCustomValidationError(phPasswordValidation, AddPassword, "Password must contain at least one number.");
                }
                if ((result & PasswordTestResult.RequireSymbol) == PasswordTestResult.RequireSymbol)
                {
                    AddCustomValidationError(phPasswordValidation, AddPassword, "Password must contain at least one symbol (e.g. underscore or punctuation)");
                }
                if ((result & PasswordTestResult.RequireSymbol) == PasswordTestResult.RequireSymbol)
                {
                    AddCustomValidationError(phPasswordValidation, AddPassword, "Password must contain at least one symbol (e.g. underscore or punctuation)");
                }
                if ((result & PasswordTestResult.RequireNonAlpha) == PasswordTestResult.RequireNonAlpha)
                {
                    AddCustomValidationError(phPasswordValidation, AddPassword, "Password must contain at least one non-alphabetic character");
                }
                return false;
            }
            return true;
        }

        private void AddCustomValidationError(PlaceHolder parent, WebControl controlToValidate, string errorMessage)
        {
            CustomValidator v = new CustomValidator();
            v.IsValid = false;
            v.ValidationGroup = "AddUser";
            v.Text = "*";
            v.ErrorMessage = errorMessage;
            v.ControlToValidate = controlToValidate.ID;
            parent.Controls.Add(v);
        }
        #endregion

        #region SendMail
        private void SetMailTarget(bool selectedOnly)
        {
            List<string> userIdsToEmail = new List<string>();
            if (selectedOnly)
            {
                // TO SELCTED USERS
                foreach (GridViewRow row in UserGrid.Rows)
                {
                    HtmlInputCheckBox checkbox = (HtmlInputCheckBox)row.FindControl("SelectUserCheckBox");
                    if ((checkbox != null) && (checkbox.Checked))
                    {
                        int userId = Convert.ToInt32(UserGrid.DataKeys[row.RowIndex].Value);
                        userIdsToEmail.Add(userId.ToString());
                    }
                }

            }
            else
            {
                // TO ALL USERS IN SEARCH RESULTS
                IList<User> users = UserDataSource.Search(GetSearchCriteria(), "U.LoweredUserName");
                // Looping through all the rows in the GridView            
                foreach (User user in users)
                {
                    userIdsToEmail.Add(user.Id.ToString());
                }
            }
            Session["SendMail_IdList"] = "UserId:" + string.Join(",", userIdsToEmail.ToArray());
        }

        protected void SendEmailSelected_Click(object sender, EventArgs e)
        {
            SetMailTarget(true);
            Response.Redirect("SendMail.aspx?ReturnUrl=" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Admin/People/Users/Default.aspx")));
        }

        protected void SendEmailAll_Click(object sender, EventArgs e)
        {
            SetMailTarget(false);
            Response.Redirect("SendMail.aspx?ReturnUrl=" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Admin/People/Users/Default.aspx")));
        }
        #endregion

        #region BATCH OPERATIONS

        protected void BatchButton_Click(object sender, EventArgs e)
        {
            List<string> messages = new List<string>();
            string ids = Request.Form["SelectedUserIds"];

            if (!string.IsNullOrEmpty(ids))
            {
                Session["EXPORT_USER_IDS"] = ids;
                Response.Redirect("~/Admin/DataExchange/UsersExport.aspx?type=selected");
            }
        }

        #endregion
    }
}