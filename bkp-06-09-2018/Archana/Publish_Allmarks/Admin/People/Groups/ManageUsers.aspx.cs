namespace AbleCommerce.Admin.People.Groups
{
    using System;
    using System.Collections.Generic;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class ManageUsers : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _GroupId;
        private bool _IsReadonlyGroup;
        private int _Subscriptions;

        protected void Page_Load(object sender, EventArgs e)
        {
            _GroupId = AlwaysConvert.ToInt(Request.QueryString["GroupId"]);
            Group group = GroupDataSource.Load(_GroupId);
            if (group == null) Response.Redirect("Default.aspx");

            // ensure user has permission to manage this group
            IList<Group> managableGroups = SecurityUtility.GetManagableGroups();
            if (managableGroups.IndexOf(group) < 0) Response.Redirect("Default.aspx");
            
            _IsReadonlyGroup = group.IsReadOnly;
            _Subscriptions = group.SubscriptionPlans.Count;

            AlphabetRepeater.DataSource = GetAlphabetDS();
            AlphabetRepeater.DataBind();

            if (!Page.IsPostBack)
            {
                SearchGroup.DataSource = AbleContext.Current.Store.Groups;
                SearchGroup.DataTextField = "Name";
                SearchGroup.DataValueField = "GroupId";
                SearchGroup.DataBind();
                
                Caption.Text = string.Format(Caption.Text, group.Name);  
                ListItem item = SearchGroup.Items.FindByValue(_GroupId.ToString());
                if (item != null)
                {
                    Session.Remove("ManageUserSearchCriteria");
                    SearchGroup.ClearSelection();
                    item.Selected = true;
                }
                LoadLastSearch();
            }
        }

        protected bool IsInGroup(object dataItem)
        {
            User user = (User)dataItem;
            return (user.IsInGroup(_GroupId));
        }

        protected bool EnableChange(object dataItem)
        {
            User user = (User)dataItem;
            if (user.IsAdmin && (AbleContext.Current.User.Id != user.Id && !AbleContext.Current.User.IsSecurityAdmin))
            {
                return false;
            }
            
            if (_Subscriptions > 0)
            {
                return false;
            }

            if (_IsReadonlyGroup)
            {
                return user.Id != AbleContext.Current.UserId;
            }

            return true;
        }

        protected void IsInGroup_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox isInGroup = (CheckBox)sender;
            GridViewRow row = (GridViewRow)isInGroup.NamingContainer;
            GridView grid = row.NamingContainer as GridView;
            int dataItemIndex = (row.DataItemIndex - (grid.PageSize * grid.PageIndex));
            int userId = (int)grid.DataKeys[dataItemIndex].Value;

            User user = UserDataSource.Load(userId);
            CommerceBuilder.Users.Group group = GroupDataSource.Load(_GroupId);
            UserGroup userGroup = UserGroupDataSource.Load(user.Id, group.Id);
            if (userGroup == null) userGroup = new UserGroup(user, group);
            int index = user.UserGroups.IndexOf(userGroup);
            if (isInGroup.Checked)
            {
                //IN ROLE WAS CHECKED, ADD ROLE IF NOT FOUND
                if (index < 0)
                {
                    user.UserGroups.Add(userGroup);
                    user.UserGroups.Save();
                    AbleContext.Current.Database.FlushSession();
                }
            }
            else
            {
                //IN ROLE WAS UNCHECKED, DELETE ROLE IF FOUND
                if (index > -1) user.UserGroups.DeleteAt(index);
            }
            //REBIND GRIDS
            BindSearchPanel();
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            BindSearchPanel();

            // DISPLAY THE RESET BUTTON
            ResetButton.Visible = true;
        }

        protected void ResetButton_Click(object sender, EventArgs e)
        {
            // RESET THE SESSION
            Session.Remove("ManageUserSearchCriteria");

            // RESET THE FORM
            SearchUserName.Text = string.Empty;
            SearchEmail.Text = string.Empty;
            SearchFirstName.Text = string.Empty;
            SearchLastName.Text = string.Empty;
            SearchCompany.Text = string.Empty;
            SearchPhone.Text = string.Empty;

            ListItem item = SearchGroup.Items.FindByValue(_GroupId.ToString());
            if (item != null)
            {
                SearchGroup.ClearSelection();
                item.Selected = true;
            }

            SearchIncludeAnonymous.Checked = false;

            // EXECUTE THE SEARCH AND HIDE THE RESET BUTTON
            SearchButton_Click(sender, e);

            BindSearchPanel();

            // DISPLAY THE RESET BUTTON
            ResetButton.Visible = false;
        }

        private void BindSearchPanel()
        {
            SearchUsersGrid.DataBind();
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

        #region Users Search
        protected void UserDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            UserSearchCriteria criteria = GetSearchCriteria();
            Session["ManageUserSearchCriteria"] = criteria;
            e.InputParameters["criteria"] = criteria;
        }

        private UserSearchCriteria GetSearchCriteria()
        {
            // BUILD THE SEARCH CRITERIA
            UserSearchCriteria criteria = new UserSearchCriteria();
            criteria.UserName = SearchUserName.Text;
            criteria.Email = SearchEmail.Text;
            criteria.FirstName = SearchFirstName.Text;
            criteria.LastName = SearchLastName.Text;
            criteria.Company = SearchCompany.Text;
            criteria.Phone = SearchPhone.Text;
            criteria.GroupId = AlwaysConvert.ToInt(SearchGroup.SelectedValue);

            if (ShowAssignFilter.SelectedValue == "0")
            {
                criteria.GroupId = 0;

                // UPDATE SEARCH FORM AND RESET GROUP SELECTION
                SearchGroup.SelectedIndex = 0;
            }
            else criteria.ShowAssignedToGroup = ShowAssignFilter.SelectedValue == "1";
            criteria.IncludeAnonymous = SearchIncludeAnonymous.Checked;
            return criteria;
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
            SearchUsersGrid.DataBind();
        }

        protected string[] GetAlphabetDS()
        {
            string[] alphabet = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "All" };
            return alphabet;
        }

        /// <summary>
        /// Restores the last user search criteria if available
        /// </summary>
        private void LoadLastSearch()
        {
            // LOAD CRITERIA FROM SESSION
            UserSearchCriteria criteria = Session["ManageUserSearchCriteria"] as UserSearchCriteria;
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
                
                if(criteria.GroupId == 0) ShowAssignFilter.SelectedIndex = 0;
                else{
                    string selectedValue = criteria.ShowAssignedToGroup ? "1" : "0";
                    selectedItem = ShowAssignFilter.Items.FindByValue( selectedValue);
                    if (selectedItem != null) selectedItem.Selected = true;
                }

                ResetButton.Visible = true;
            }
        }
        #endregion
    }
}