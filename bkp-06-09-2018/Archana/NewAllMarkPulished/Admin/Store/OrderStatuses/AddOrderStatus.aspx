<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.OrderStatuses.AddOrderStatus" Title="Edit Order Status"  CodeFile="AddOrderStatus.aspx.cs" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Add Order Status"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <table cellspacing="0" class="inputForm">
            <tr>
                <th>
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" ToolTip="The name of the order status as it will appear in the merchant administration." />
                </th>
                <td valign="top">
                    <asp:TextBox ID="Name" runat="server" Columns="30" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RegularExpressionValidator ID="NameValidator" runat="server" ErrorMessage="Maximum length for Name is 100 characters." Text="*" ControlToValidate="Name" ValidationExpression=".{1,100}"  ></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="NameRequiredValidator" runat="server" ControlToValidate="Name"
                        ErrorMessage="Name is Required." ToolTip="Name is Required." Display="Static" 
                        Text="*"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="DisplayNameLabel" runat="server" Text="Display Name:" ToolTip="The name of the order status as it will appear to customers on the store website." />
                </th>
                <td valign="top">
                    <asp:TextBox ID="DisplayName" runat="server" Columns="30" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RegularExpressionValidator ID="DisplayNameValidator" runat="server" ErrorMessage="Maximum length for Display Name is 100 characters." Text="*" ControlToValidate="DisplayName" ValidationExpression=".{1,100}"  ></asp:RegularExpressionValidator>
                    <asp:RequiredFieldValidator ID="DisplayNameRequiredValidator" runat="server" ControlToValidate="DisplayName"
                        ErrorMessage="Display name is Required." ToolTip="Display name is Required." Display="Static" 
                        Text="*"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="ReportLabel" runat="server" Text="Include in Reports:" ToolTip="Indicate whether this order should be considered a valid sale and included in sales reports." />
                </th>
                <td>
                    <asp:CheckBox ID="Report" runat="server" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="CancelledLabel" runat="server" Text="Cancelled Order:" ToolTip="Indicate whether this order represents an order that is fraudulent, cancelled, or otherwise invalidated." />
                </th>
                <td>
                    <asp:CheckBox ID="Cancelled" runat="server" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="InventoryActionLabel" runat="server" Text="Inventory Status:" ToolTip="Select the inventory rule that should be enforced on order items when this status is assigned to an order.  Inventory will never be restocked or destocked twice." />
                </th>
                <td>
                    <asp:DropDownList ID="InventoryAction" runat="server">
                        <asp:ListItem Text="Unspecified" Value="0"></asp:ListItem>
                        <asp:ListItem Text="Destocked" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Restocked" Value="2"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="TriggersLabel" runat="server" Text="Select Triggers:" ToolTip="If applicable, select the event(s) that will cause an order to update to this status." />
                </th>
                <td>
                    <asp:CheckBoxList ID="Triggers" runat="server" RepeatColumns="3" RepeatDirection="vertical" CellPadding="4">
                    </asp:CheckBoxList>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="EmailTemplatesLabel" runat="server" Text="Select Emails:" ToolTip="If applicable, select the email template(s) that will be processed and sent when an order is updated to this status." />
                </th>
                <td>
                    <asp:CheckBoxList ID="EmailTemplates" runat="server" RepeatColumns="3" RepeatDirection="vertical" DataSourceID="EmailTemplateDs" DataTextField="Name" DataValueField="EmailTemplateId" CellPadding="4">
                    </asp:CheckBoxList>
                    <asp:Label ID="NoEmailTemplatesDefinedLabel" runat="server" Text="No email templates have been defined for the store." Visible="false"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
					<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="False" OnClick="CancelButton_Click" />
                </td>
            </tr>
        </table>
    </div>
    <asp:ObjectDataSource ID="EmailTemplateDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Messaging.EmailTemplateDataSource">
    </asp:ObjectDataSource>
</asp:Content>

