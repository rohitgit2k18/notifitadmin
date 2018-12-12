namespace AbleCommerce.Admin.People.Groups
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class EditGroupDialog : System.Web.UI.UserControl
    {
        public event PersistentItemEventHandler ItemUpdated;

        public int GroupId
        {
            get { return AlwaysConvert.ToInt(ViewState["GroupId"]); }
            set { ViewState["GroupId"] = value; }
        }

        protected void Page_Init(object sender, System.EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //INITIALIZE ROLELIST
                IList<Role> roles = SecurityUtility.GetManagableRoles();
                RoleList.DataSource = roles;
                RoleList.DataBind();
                trRoles.Visible = RoleList.Items.Count > 0;
            }
        }

        protected void UpdateGroup()
        {
            if (Page.IsValid)
            {
                CommerceBuilder.Users.Group group = GroupDataSource.Load(this.GroupId);
                group.Name = Name.Text;
                group.Roles.Clear();
                group.Save();
                foreach (ListItem roleListItem in RoleList.Items)
                {
                    if (roleListItem.Selected)
                    {
                        Role role = RoleDataSource.Load(AlwaysConvert.ToInt(roleListItem.Value));
                        group.Roles.Add(role);
                    }
                }
                group.Save();
                SavedMessage.Text = string.Format(SavedMessage.Text, group.Name);
                SavedMessage.Visible = true;
                if (ItemUpdated != null) ItemUpdated(this, new PersistentItemEventArgs(this.GroupId, group.Name));
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                UpdateGroup();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            CommerceBuilder.Users.Group group = GroupDataSource.Load(this.GroupId);
            if (group != null)
            {
                Name.Text = group.Name;
                RoleList.SelectedIndex = -1;
                foreach (Role role in group.Roles)
                {
                    ListItem item = RoleList.Items.FindByValue(role.Id.ToString());
                    if (item != null) item.Selected = true;
                }
            }
            else
            {
                this.Controls.Clear();
            }
        }
    }
}