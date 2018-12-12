namespace AbleCommerce.Admin.People.Groups
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class AddGroupDialog : System.Web.UI.UserControl
    {
        public event PersistentItemEventHandler ItemAdded;

        protected void Page_Init(object sender, System.EventArgs e)
        {
            RoleList.DataSource = SecurityUtility.GetManagableRoles();
            RoleList.DataBind();
            trRoles.Visible = RoleList.Items.Count > 0;
        }

        protected void CreateGroup()
        {
            if (Page.IsValid)
            {
                Group group = new Group();
                group.Name = Name.Text;
                foreach (ListItem roleListItem in RoleList.Items)
                {
                    if (roleListItem.Selected)
                    {
                        Role role = RoleDataSource.Load(AlwaysConvert.ToInt(roleListItem.Value));
                        group.Roles.Add(role);
                        roleListItem.Selected = false;
                    }
                }
                Store store = AbleContext.Current.Store;
                store.Groups.Add(group);
                store.Save();
                AddedMessage.Text = string.Format(AddedMessage.Text, group.Name);
                AddedMessage.Visible = true;
                Name.Text = String.Empty;
                Name.Focus();
                if (ItemAdded != null) ItemAdded(this, new PersistentItemEventArgs(group.Id, group.Name));
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                CreateGroup();
            }
        }
    }
}