namespace AbleCommerce.Admin.People.Groups
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private IList<Group> _ManagableGroups;

        protected void Page_Init(object sender, EventArgs e)
        {
            AddGroupDialog1.ItemAdded += new PersistentItemEventHandler(AddGroupDialog1_ItemAdded);
            EditGroupDialog1.ItemUpdated += new PersistentItemEventHandler(EditGroupDialog1_ItemUpdated);
            _ManagableGroups = SecurityUtility.GetManagableGroups();
        }

        private void AddGroupDialog1_ItemAdded(object sender, PersistentItemEventArgs e)
        {
            _ManagableGroups = SecurityUtility.GetManagableGroups();
            GroupGrid.DataBind();
            GroupAjax.Update();
        }

        private void EditGroupDialog1_ItemUpdated(object sender, PersistentItemEventArgs e)
        {
            _ManagableGroups = SecurityUtility.GetManagableGroups();
            GroupGrid.EditIndex = -1;
            GroupGrid.DataBind();
            AddPanel.Visible = true;
            EditPanel.Visible = false;
            AddEditAjax.Update();
            GroupAjax.Update();
        }

        protected void GroupGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int groupId = (int)GroupGrid.DataKeys[e.NewEditIndex].Value;
            CommerceBuilder.Users.Group group = GroupDataSource.Load(groupId);
            if (group != null)
            {
                AddPanel.Visible = false;
                EditPanel.Visible = true;
                EditCaption.Text = string.Format(EditCaption.Text, group.Name);
                EditGroupDialog editDialog = EditPanel.FindControl("EditGroupDialog1") as EditGroupDialog;
                if (editDialog != null) editDialog.GroupId = groupId;
                AddEditAjax.Update();
            }
        }

        protected void GroupGrid_RowCancelingEdit(object sender, EventArgs e)
        {
            AddPanel.Visible = true;
            EditPanel.Visible = false;
            AddEditAjax.Update();
        }

        protected string GetRoles(object dataItem)
        {
            CommerceBuilder.Users.Group group = (CommerceBuilder.Users.Group)dataItem;
            List<string> roles = new List<string>();
            foreach (Role role in group.Roles)
            {
                roles.Add(role.Name);
            }
            return string.Join(", ", roles.ToArray());
        }

        protected int CountUsers(object dataItem)
        {
            CommerceBuilder.Users.Group group = (CommerceBuilder.Users.Group)dataItem;
            return UserDataSource.CountForGroup(group.Id);
        }

        protected bool IsManagableGroup(object dataItem)
        {
            Group group = (Group)dataItem;
            return _ManagableGroups.Contains(group);
        }

        protected bool IsEditableGroup(object dataItem)
        {
            Group group = (Group)dataItem;
            return !group.IsReadOnly && IsManagableGroup(group);
        }

        protected bool ShowDeleteButton(object dataItem)
        {
            CommerceBuilder.Users.Group g = (CommerceBuilder.Users.Group)dataItem;
            if (!IsEditableGroup(dataItem)) return false;
            return (UserDataSource.CountForGroup(g.Id) <= 0);
        }

        protected bool ShowDeleteLink(object dataItem)
        {
            CommerceBuilder.Users.Group g = (CommerceBuilder.Users.Group)dataItem;
            if (!IsEditableGroup(dataItem)) return false;
            return (UserDataSource.CountForGroup(g.Id) > 0);
        }
    }
}