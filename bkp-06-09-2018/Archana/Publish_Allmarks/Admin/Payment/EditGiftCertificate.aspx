<%@ Page Language="C#" MasterPageFile="../Admin.master" Inherits="AbleCommerce.Admin._Payment.EditGiftCertificate" Title="Edit Gift Certificate"  CodeFile="EditGiftCertificate.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
		<div class="caption">
			<h1><asp:Localize ID="Caption" runat="server" Text="Edit Gift Certificate"></asp:Localize></h1>
		</div>
    </div>
    <div class="content">
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <table cellspacing="0" class="inputForm">
            <tr>
                <th>
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" ToolTip="The name of the Gift Certificate as it will appear in the merchant admin." />
                </th>
                <td>
                    <asp:TextBox ID="Name" runat="server" Text="" Columns="20" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="NameRequired" runat="server" Text="*" Display="Static" ErrorMessage="Name is required." ControlToValidate="Name"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="HtmlValidator" runat="server" ControlToValidate="Name" ValidationExpression="[^<>]*" Text="*" ErrorMessage="You may not use < or > characters in the name."></asp:RegularExpressionValidator>
                </td>    
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="BalanceLabel" runat="server" Text="Balance:" ToolTip="The Balance of the Gift Certificate." />
                </th>
                <td>
                    <asp:TextBox ID="Balance" runat="server" Text="" Columns="4" MaxLength="10"></asp:TextBox><span class="requiredField">*</span> 
                    <asp:RequiredFieldValidator ID="BalanceRequired" runat="server" Text="*" Display="Static" ErrorMessage="Balance is required." ControlToValidate="Balance"></asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="PriceValidator" runat="server" ControlToValidate="Balance"
                    ErrorMessage="Balance should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                    MinimumValue="0.00" Type="Currency">*</asp:RangeValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="ExpireDateLabel" runat="server" Text="Expire Date:" ToolTip="The date after which the the Gift Certificate will expire. If not specified, the Gift Certificate does not expire." />
                </th>
                <td valign="top">
                    <uc:PickerAndCalendar ID="ExpireDate" runat="server" />
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="SerialNumberLbl" runat="server" Text="Serial Number:" ToolTip="The serial number for this Gift Certificate." />
                </th>
                <td>
                    <asp:Label ID="SerialNumber" runat="server" Text="" ></asp:Label>
                </td>
            </tr>
            <tr>
                <th>
					<asp:Label ID="ReGenerateSerialNumberLbl" runat="server" Text="Re-Generate Serial Number:" ToolTip="If checked serial number for this gift certificate will be re-generated."   />
					<asp:Label ID="GenerateSerialNumberLbl" runat="server" Text="Generate Serial Number:" ToolTip="If checked serial number for this gift certificate will be generated." />
                </th>
                <td>                            
					<asp:CheckBox ID="GenerateSerialNumber" runat="server" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
				    <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                </td>
            </tr>
		</table>
    </div>
</asp:Content>