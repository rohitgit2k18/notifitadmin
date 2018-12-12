<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Create.CreateOrder3" Title="Place Order" CodeFile="CreateOrder3.aspx.cs" %>
<%@ Register Src="~/Admin/Orders/Create/MiniBasket.ascx" TagName="MiniBasket" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="BasketAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>  
            <div class="pageHeader">
                <div class="caption">
                    <h1>
                        <asp:Localize ID="Caption" runat="server" Text="Create Order for {0} (Step 3 of 4)"></asp:Localize>
                    </h1>
                </div>
            </div>
            <div class="grid_8 alpha">
                <div class="mainColumn">
                    <div class="content">
                        <asp:ValidationSummary ID="AddressValidationSummary" runat="server" EnableViewState="false" ValidationGroup="OPC" />                
                        <asp:Panel ID="BillAddressPanel" runat="server" DefaultButton="ContinueButton" EnableViewState="false">
                            <table class="inputForm" cellpadding="3" width="100%">
                                <tr>
                                    <td class="sectionHeader" colspan="4">
                                        <asp:Localize ID="BillingAddressCaption" runat="server" Text="Billing Address"></asp:Localize>
                                    </td>
                                </tr>
                                <tr>                        
                                    <th>
                                        <asp:Label ID="BillToFirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="BillToFirstName" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToFirstName" runat="server" EnableViewState="false" Width="150px" MaxLength="20" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="BillToFirstNameRequired" runat="server" Text="*"
                                            ErrorMessage="First name is required." Display="Static" ControlToValidate="BillToFirstName"
                                            EnableViewState="False" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="BillToLastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="BillToLastName" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToLastName" runat="server" EnableViewState="false" Width="150px" MaxLength="30" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="BillToLastNameRequired" runat="server" Text="*"
                                            ErrorMessage="Last name is required." Display="Static" ControlToValidate="BillToLastName"
                                            EnableViewState="False" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="BillToAddress1Label" runat="server" Text="Address:" AssociatedControlID="BillToAddress1" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToAddress1" runat="server" EnableViewState="false" Width="150px" MaxLength="100" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="BillToAddress1Required" runat="server" Text="*"
                                            ErrorMessage="Billing address is required." Display="Static" ControlToValidate="BillToAddress1"
                                            EnableViewState="false" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="BillToAddress2Label" runat="server" Text="Address 2:" AssociatedControlID="BillToAddress2" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToAddress2" runat="server" EnableViewState="false" Width="150px" MaxLength="100"></asp:TextBox> 
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="BillToCountryLabel" runat="server" Text="Country:" AssociatedControlID="BillToCountry" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="BillToCountry" runat="server" DataTextField="Name" DataValueField="CountryCode" 
                                            AutoPostBack="true" EnableViewState="false" Width="150px"></asp:DropDownList>
                                    </td>
                                    <th>
                                        <asp:Label ID="BillToCityLabel" runat="server" Text="City:" AssociatedControlID="BillToCity" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToCity" runat="server" EnableViewState="false" Width="150px" MaxLength="50" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="BillToCityRequired" runat="server" Text="*"
                                            ErrorMessage="Billing city is required." Display="Static" ControlToValidate="BillToCity"
                                            EnableViewState="false" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="BillToProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="BillToProvince" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToProvince" runat="server" MaxLength="50" Width="150px" EnableViewState="false"></asp:TextBox> 
                                        <asp:DropDownList ID="BillToProvinceList" runat="server" Width="150px" DataTextField="Name" DataValueField="ProvinceId" EnableViewState="false"></asp:DropDownList><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="BillToProvinceRequired" runat="server" Text="*" ErrorMessage="Billing state or province is required."
                                            Display="Static" ControlToValidate="BillToProvinceList" ValidationGroup="OPC" EnableViewState="false"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="BillToPostalCodeLabel" runat="server" Text="Postal Code:" AssociatedControlID="BillToPostalCode" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToPostalCode" runat="server" EnableViewState="false" Width="150px" MaxLength="10" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="BillToPostalCodeRequired" runat="server" Text="*"
                                            ErrorMessage="Billing ZIP or Postal Code is required." Display="Static" ControlToValidate="BillToPostalCode"
                                            EnableViewState="False" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <asp:Label ID="BillToAddressTypeLabel" runat="server" Text="Type:" AssociatedControlID="BillToAddressType" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td valign="top">
                                        <asp:DropDownList ID="BillToAddressType" runat="server" Width="150px" EnableViewState="false">
                                            <asp:ListItem Text="This is a residence" Value="1" Selected="true"></asp:ListItem>
                                            <asp:ListItem Text="This is a business" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <th>
                                        <asp:Label ID="BillToCompanyLabel" runat="server" Text="Company:" AssociatedControlID="BillToCompany" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToCompany" runat="server" EnableViewState="false" Width="150px" MaxLength="50"></asp:TextBox> 
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="BillToPhoneLabel" runat="server" Text="Phone:" AssociatedControlID="BillToPhone" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToPhone" runat="server" EnableViewState="false" Width="150px" MaxLength="30"></asp:TextBox><span class="requiredField">*</span>
                                         <asp:RequiredFieldValidator ID="BillToPhoneRequired" runat="server" Text="*"
                                            ErrorMessage="Billing phone number is required." Display="Static" ControlToValidate="BillToPhone"
                                            EnableViewState="False" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="BillToEmailLabel" runat="server" Text="Email:" AssociatedControlID="BillToEmail" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BillToEmail" runat="server" EnableViewState="false" Width="150px" MaxLength="250" ValidationGroup="OPC"></asp:TextBox> 
                                        <cb:EmailAddressValidator ID="BillToEmailValidator" runat="server" ControlToValidate="BillToEmail" ValidationGroup="OPC" Display="static" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>
                                    </td>
                                </tr>
                                <tr id="trAddressBook" runat="server">
                                    <th>
                                        Ship To:
                                    </th>
                                    <td colspan="3">
                                        <asp:DropDownList ID="AddressBook" runat="server" Width="200px" DataTextField="Value" 
                                            DataValueField="Key" AppendDataBoundItems="true" AutoPostBack="true">
                                            <asp:ListItem Text="Billing Address" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="New Address" Value="-1"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="trContinueButton1" runat="server" EnableViewState="false">
                                    <td>&nbsp;</td>
                                    <td colspan="3">
                                        <asp:Button ID="ContinueButton" runat="server" Text="Continue" OnClick="ContinueButton_Click" CausesValidation="true" ValidationGroup="OPC" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="ShipAddressPanel" runat="server" DefaultButton="ContinueButton2" Visible="false" EnableViewState="false">
                            <table class="inputForm">
                                <tr id="trShippingAddressCaption" runat="server">
                                    <td class="sectionHeader" colspan="4">
                                        <asp:Localize ID="ShippingAddressCaption" runat="server" Text="Shipping Address"></asp:Localize>
                                    </td>
                                </tr>
                                <tr>                        
                                    <th>
                                        <asp:Label ID="ShipToFirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="ShipToFirstName" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToFirstName" runat="server" EnableViewState="false" Width="150px" MaxLength="20" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="ShipToFirstNameRequired" runat="server" Text="*"
                                            ErrorMessage="Ship to first name is required." Display="Static" ControlToValidate="ShipToFirstName"
                                            EnableViewState="false" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToLastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="ShipToLastName" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToLastName" runat="server" EnableViewState="false" Width="150px" MaxLength="30" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="ShipToLastNameRequired" runat="server" Text="*"
                                            ErrorMessage="Ship to last name is required." Display="Static" ControlToValidate="ShipToLastName"
                                            EnableViewState="false" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToAddress1Label" runat="server" Text="Address:" AssociatedControlID="ShipToAddress1" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToAddress1" runat="server" EnableViewState="false" Width="150px" MaxLength="100" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="ShipToAddress1Required" runat="server" Text="*"
                                            ErrorMessage="Shipping address is required." Display="Static" ControlToValidate="ShipToAddress1"
                                            EnableViewState="false" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToAddress2Label" runat="server" Text="Address 2:" AssociatedControlID="ShipToAddress2" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToAddress2" runat="server" EnableViewState="false" Width="150px" MaxLength="100"></asp:TextBox> 
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToCountryLabel" runat="server" Text="Country:" AssociatedControlID="ShipToCountry" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="ShipToCountry" runat="server" DataTextField="Name" DataValueField="CountryCode" 
                                            AutoPostBack="true" EnableViewState="false" Width="150px"></asp:DropDownList>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToCityLabel" runat="server" Text="City:" AssociatedControlID="ShipToCity" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToCity" runat="server" EnableViewState="false" Width="150px" MaxLength="50" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="ShipToCityRequired" runat="server" Text="*"
                                            ErrorMessage="Shipping city is required." Display="Static" ControlToValidate="ShipToCity"
                                            EnableViewState="false" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="ShipToProvince" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToProvince" runat="server" Visible="false" EnableViewState="false" Width="150px" MaxLength="50"></asp:TextBox> 
                                        <asp:DropDownList ID="ShipToProvinceList" runat="server" EnableViewState="false" Width="150px"></asp:DropDownList><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="ShipToProvinceRequired" runat="server" Text="*" ErrorMessage="Shipping state or province is required."
                                            Display="Static" ControlToValidate="ShipToProvinceList" ValidationGroup="OPC" EnableViewState="false"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToPostalCodeLabel" runat="server" Text="Postal Code:" AssociatedControlID="ShipToPostalCode" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToPostalCode" runat="server" EnableViewState="false" Width="150px" MaxLength="10" ValidationGroup="OPC"></asp:TextBox><span class="requiredField">*</span> 
                                        <asp:RequiredFieldValidator ID="ShipToPostalCodeRequired" runat="server" Text="*"
                                            ErrorMessage="Shipping ZIP or Postal Code is required." Display="Static" ControlToValidate="ShipToPostalCode"
                                            EnableViewState="false" SetFocusOnError="false" ValidationGroup="OPC"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <asp:Label ID="ShipToAddressTypeLabel" runat="server" Text="Type:" AssociatedControlID="ShipToAddressType" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td valign="top">
                                        <asp:DropDownList ID="ShipToAddressType" runat="server" EnableViewState="false">
                                            <asp:ListItem Text="This is a residence" Value="1" Selected="true"></asp:ListItem>
                                            <asp:ListItem Text="This is a business" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToCompanyLabel" runat="server" Text="Company:" AssociatedControlID="ShipToCompany" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToCompany" runat="server" EnableViewState="false" Width="150px" MaxLength="50"></asp:TextBox> 
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToPhoneLabel" runat="server" Text="Phone:" AssociatedControlID="ShipToPhone" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td colspan="3">
                                        <asp:TextBox ID="ShipToPhone" runat="server" EnableViewState="false" Width="150px" MaxLength="30"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td colspan="3">
                                        <asp:Button ID="ContinueButton2" runat="server" Text="Continue" OnClick="ContinueButton_Click" CausesValidation="true" ValidationGroup="OPC" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </div>
                </div>
            </div>
            <div class="grid_4 omega">
                <div class="rightColumn">
                    <uc1:MiniBasket ID="MiniBasket1" runat="server" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>