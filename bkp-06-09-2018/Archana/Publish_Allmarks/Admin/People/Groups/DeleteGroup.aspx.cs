namespace AbleCommerce.Admin.People.Groups
{
    using System.Collections;
    using System.Collections.Generic;
    using AbleCommerce.Code;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class DeleteGroup : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        int _GroupId = 0;

        protected void Page_Init(object sender, System.EventArgs e)
        {
            // locate group to delete
            _GroupId = AlwaysConvert.ToInt(Request.QueryString["GroupId"]);
            Group group = GroupDataSource.Load(_GroupId);
            if (group == null) Response.Redirect("Default.aspx");

            // groups managed by the application cannot be deleted
            if (group.IsReadOnly) Response.Redirect("Default.aspx");

            // ensure user has permission to edit this group
            IList<Group> managableGroups = SecurityUtility.GetManagableGroups();
            if (managableGroups.IndexOf(group) < 0) Response.Redirect("Default.aspx");

            Caption.Text = string.Format(Caption.Text, group.Name);
            InstructionText.Text = string.Format(InstructionText.Text, group.Name);
            BindGroups(group);
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        protected void DeleteButton_Click(object sender, System.EventArgs e)
        {
            // GET NEW GROUP FOR USERS (IF SELECTED)
            int newGroupId = AlwaysConvert.ToInt(GroupList.SelectedValue);
            GroupDataSource.Delete(_GroupId, newGroupId);
            Response.Redirect("Default.aspx");
        }

        private void BindGroups(Group group)
        {
            IList<Group> groups = GroupDataSource.LoadAll("Name");
            groups.RemoveAt(groups.IndexOf(group));
            GroupList.DataSource = groups;
            GroupList.DataBind();
        }
    }
}