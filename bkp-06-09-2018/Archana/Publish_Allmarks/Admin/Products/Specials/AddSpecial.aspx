<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Specials.AddSpecial" Title="Add Pricing Rule"  CodeFile="AddSpecial.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Add Special Price for {0}"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="Only price is required.  You can optionally restrict the price by date or group."></asp:Localize></p>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />                
        <table cellspacing="0" class="inputForm">
            <tr>
                <th>
                    <asp:Label ID="PriceLabel" runat="server" Text="Special Price:"></asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="Price" runat="server" Text="" Columns="12" MaxLength="11"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RangeValidator ID="PriceValidator" runat="server" Text="*" ErrorMessage="Special Price must be between 0 and 99999999.99" MinimumValue="0" MaximumValue="99999999.99" Type="currency" ControlToValidate="Price"></asp:RangeValidator>
                    <asp:RequiredFieldValidator ID="PriceRequired" runat="server" Text="*" Display="Dynamic" ErrorMessage="Price is required." ControlToValidate="Price"></asp:RequiredFieldValidator>
                    <asp:Label ID="BasePriceMessage" runat="server" Text="(must be less than base price of {0})"></asp:Label>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="StartDateLabel" runat="server" Text="Start Date:"></asp:Label>
                </th>
                <td>
                    <uc:PickerAndCalendar ID="StartDate" runat="server" />
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="EndDateLabel" runat="server" Text="End Date:"></asp:Label><br />
                </th>
                <td>
                    <uc:PickerAndCalendar ID="EndDate" runat="server" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <asp:Label ID="GroupsLabel" runat="server" Text="Groups:"></asp:Label><br />
                </th>
                <td>
                    <asp:RadioButton ID="AllGroups" GroupName="radGroups" runat="server" Text="All Groups" Checked="true" /><br />
                    <asp:RadioButton ID="SelectedGroups" GroupName="radGroups" runat="server" Text="Selected Groups:" /><br />
                    <div style="padding-left:20px">
                        <asp:ListBox ID="Groups" runat="server" SelectionMode="Multiple" Rows="6" DataSourceId="GroupsDs" DataTextField="Name" DataValueField="GroupId">
                        </asp:ListBox>
                        <asp:ObjectDataSource ID="GroupsDs" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="LoadAll" TypeName="CommerceBuilder.Users.GroupDataSource">
                        </asp:ObjectDataSource>
                    </div>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
				    <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>