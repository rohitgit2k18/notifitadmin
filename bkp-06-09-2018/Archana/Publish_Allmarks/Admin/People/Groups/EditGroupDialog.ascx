<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.People.Groups.EditGroupDialog" CodeFile="EditGroupDialog.ascx.cs" %>
<asp:UpdatePanel ID="EditGroupAjax" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <cb:Notification ID="SavedMessage" runat="server" SkinID="GoodCondition" EnableViewState="false" Visible="false" Text="Group {0} saved."></cb:Notification>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="EditGroup" />
        <table class="inputForm">
            <tr>
                <th>
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Group Name:" AssociatedControlID="Name" ToolTip="Name of the group."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="Name" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegExNameValidator" runat="server" ErrorMessage="Maximum length for Name is 100 characters." Text="*" ControlToValidate="Name" ValidationExpression=".{0,100}"  ValidationGroup="EditGroup"></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="NameValidator" runat="server" ControlToValidate="Name"
                        Display="Static" ErrorMessage="Name is required." ValidationGroup="EditGroup" Text="*"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr id="trRoles" runat="server">
                <th valign="top">
                    <cb:ToolTipLabel ID="RolesLabel" runat="server" Text="Permissions:" AssociatedControlID="RoleList" ToolTip="Select any permissions that should be granted to members of this group."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:ListBox ID="RoleList" runat="server" SelectionMode="Multiple" Rows="6" DataTextField="Name" DataValueField="RoleId">
                    </asp:ListBox>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" ValidationGroup="EditGroup" />
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>