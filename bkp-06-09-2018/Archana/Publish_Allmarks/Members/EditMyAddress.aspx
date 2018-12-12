<%@ Page Title="Address Book - Edit Address" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="EditMyAddress.aspx.cs" Inherits="AbleCommerce.Members.EditMyAddress" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_editAddressPage" class="mainContentWrapper">
		<div class="section">
            <div class="content">
                <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                <asp:Panel ID="EditAddressPanel" runat="server" DefaultButton="EditSaveButton" CssClass="tabpane">
                    <asp:UpdatePanel ID="EditAddressAjax" runat="server">
                        <ContentTemplate>        
                            <h2><asp:Localize ID="EditAddressCaption" runat="server" Text="{0} {1} Address"></asp:Localize></h2>
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="FirstName" runat="server" EnableViewState="false" MaxLength="30"></asp:TextBox> 
                                        <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                            ErrorMessage="First name is required." Display="Static" ControlToValidate="FirstName"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="LastName" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox> 
                                        <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                            ErrorMessage="Last name is required." Display="Static" ControlToValidate="LastName"
                                            EnableViewState="false"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="CompanyLabel" runat="server" Text="Company:" AssociatedControlID="Company" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Company" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox> 
                                    </td>
                                    <th>
                                        <asp:Label ID="PhoneLabel" runat="server" Text="Phone:" AssociatedControlID="Phone" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Phone" runat="server" EnableViewState="false" MaxLength="30"></asp:TextBox> 
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" AssociatedControlID="Address1" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Address1" runat="server" EnableViewState="false" MaxLength="100"></asp:TextBox> 
                                        <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                            ErrorMessage="Address is required." Display="Static" ControlToValidate="Address1"
                                            EnableViewState="false"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" AssociatedControlID="Address2" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Address2" runat="server" EnableViewState="false" MaxLength="100"></asp:TextBox> 
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="City" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox> 
                                        <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                            ErrorMessage="City is required." Display="Static" ControlToValidate="City"
                                            EnableViewState="false"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="CountryLabel" runat="server" Text="Country:" AssociatedControlID="Country" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode"
                                            OnSelectedIndexChanged="Country_Changed" AutoPostBack="true"></asp:DropDownList>
                                    </td>                         
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="Province" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Province" runat="server" MaxLength="30"></asp:TextBox> 
                                        <asp:DropDownList ID="Province2" runat="server"></asp:DropDownList>
                                        <asp:CustomValidator ID="Province2Invalid" runat="server" Text="*"
                                            ErrorMessage="The state or province you entered was not recognized.  Please choose from the list." Display="Dynamic" ControlToValidate="Province2"></asp:CustomValidator>
                                        <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
                                            ErrorMessage="State or province is required." Display="Static" ControlToValidate="Province2"></asp:RequiredFieldValidator>
                                    </td>   
                                    <th>
                                        <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" AssociatedControlID="PostalCode" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="PostalCode" runat="server" EnableViewState="false" MaxLength="10"></asp:TextBox> 
                                        <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*"
                                            ErrorMessage="ZIP or Postal Code is required." Display="Static" ControlToValidate="PostalCode"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="FaxLabel" runat="server" Text="Fax:" AssociatedControlID="Fax" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Fax" runat="server" EnableViewState="false" MaxLength="30"></asp:TextBox> 
                                    </td>
                                    <th>
                                        <asp:Label ID="ResidenceLabel" runat="server" Text="Type:" AssociatedControlID="Residence" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="Residence" runat="server" EnableViewState="false">
                                            <asp:ListItem Text="This is a residence" Value="1" Selected="true"></asp:ListItem>
                                            <asp:ListItem Text="This is a business" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td colspan="3">
                                        <asp:ValidationSummary ID="EditValidationSummary" runat="server" EnableViewState="false" />
                                        <asp:Button ID="EditSaveButton" runat="server" Text="Save" OnClick="EditSaveButton_Click"></asp:Button>
                                        <asp:Button ID="EditCancelButton" runat="server" Text="Cancel" OnClick="EditCancelButton_Click" CausesValidation="false" EnableViewState="false"></asp:Button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <asp:Panel ID="AddressValidationPanel" runat="server" Visible="false">
                                            <asp:Panel ID="ValidAddressesPanel" runat="server" Visible="false" CssClass="validAddressContainer">
                                                <asp:PlaceHolder ID="PHAddressFound" runat="server" Visible="false">
                                                    <p>We found matching street addresses for the details you entered. Please choose the best address from those listed below:</p>
                                                </asp:PlaceHolder>
                                                <asp:PlaceHolder ID="PHNoAddress" runat="server" Visible="false">
                                                    <p>We couldn't find any address that matches the one you entered. Please confirm your entry and correct it if necessary.</p>
                                                </asp:PlaceHolder>
                                                <div class="validAddresses">
                                                    <asp:RadioButtonList ID="ValidAddressesList" runat="server" DataTextField="FormattedAddress" DataValueField="Id"></asp:RadioButtonList>
                                                </div>
                                                <asp:Button ID="UseValidAddressButton" runat="server" Text="Continue" OnClick="EditSaveButton_Click" />
                                                <asp:Button ID="CancelValidAddressButton" runat="server" Text="Cancel" OnClick="CancelValidAddressButton_Click" />
                                            </asp:Panel>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </asp:Panel>
			</div>
		</div>
    </div>
</div>
</asp:Content>