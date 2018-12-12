<%@ Page Title="Add Shipment" Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Shipments.AddShipment" EnableViewState="false" CodeFile="AddShipment.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Add Shipment to Order #{0}"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">    
    <asp:UpdatePanel ID="AddressAjax" runat="server">
        <ContentTemplate>
            <div class="content">
                <p><asp:Localize ID="InstructionText" runat="server" Text="To begin a new shipment, select from the options below.  After saving, you can edit the shipment to add items or modify as needed."></asp:Localize></p>
                <asp:ValidationSummary ID="ValidationSummary" runat="server" />
                <table class="inputForm compact">
                    <tr>
                        <th>
                            <asp:Label ID="ShipFromLabel" runat="server" Text="Ship From:" AssociatedControlID="ShipFrom"></asp:Label>
                        </th>
                        <td>
                            <asp:DropDownList ID="ShipFrom" runat="server" DataTextField="Name" DataValueField="Id">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="AddressLabel" runat="server" Text="Ship To:"></asp:Label>
                        </th>
                        <td>
                            <asp:DropDownList ID="AddressList" runat="server" AutoPostBack="true">
                                <asp:ListItem Text="-- select or add new address --" Value=""></asp:ListItem>
                            </asp:DropDownList><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="AddressValidator" runat="server" ControlToValidate="AddressList"
                                Text="*" ErrorMessage="Ship to address is required."></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr id="trNewAddress" runat="server">
                        <td>&nbsp;</td>
                        <td>
                            <table class="inputForm">
                                <tr class="sectionHeader">
                                    <th colspan="4">
                                        <asp:Label ID="ShipToCaption" runat="server" Text="Enter New Address"></asp:Label>
                                    </th>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToFirstNameLabel" runat="server" Text="First Name:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToFirstName" runat="server" Width="200px" ValidationGroup="NewAddress"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="ShipToFirstNameValidator" runat="server" ControlToValidate="ShipToFirstName" ErrorMessage="First name is required." Text="*" ValidationGroup="NewAddress"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToLastNameLabel" runat="server" Text="Last Name:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToLastName" runat="server" Width="200px" ValidationGroup="NewAddress"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="ShipToLastNameValidator" runat="server" ControlToValidate="ShipToLastName" ErrorMessage="Last name is required." Text="*" ValidationGroup="NewAddress"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToCompanyLabel" runat="server" Text="Company:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToCompany" Width="200px" runat="server"></asp:TextBox>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToPhoneLabel" runat="server" Text="Phone:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToPhone" Width="200px" runat="server"></asp:TextBox><br />
                                    </td>          
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToAddress1Label" runat="server" Text="Street Address 1:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToAddress1" runat="server" Width="200px" ValidationGroup="NewAddress"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="ShipToAddress1Validator" runat="server" ControlToValidate="ShipToAddress1" ErrorMessage="First line of street address is required." Text="*" ValidationGroup="NewAddress"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToAddress2Label" runat="server" Text="Street Address 2:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToAddress2" Width="200px" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToCityLabel" runat="server" Text="City:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToCity" runat="server" Width="200px" ValidationGroup="NewAddress"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="ShipToCityValidator" runat="server" ControlToValidate="ShipToCity" ErrorMessage="City is required." Text="*" ValidationGroup="NewAddress"></asp:RequiredFieldValidator>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToProvinceLabel" runat="server" Text="State / Province:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToProvince" Width="200px" runat="server"></asp:TextBox>
                                    </td>
                                    
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToPostalCodeLabel" runat="server" Text="ZIP / Postal Code:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ShipToPostalCode" Width="200px" runat="server"></asp:TextBox>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipToCountryCodeLabel" runat="server" Text="Country:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="ShipToCountryCode" runat="server" DataTextField="Name" DataValueField="CountryCode"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToAddressTypeLabel" runat="server" Text="Address Type:" AssociatedControlID="ShipToAddressType"></asp:Label>
                                    </th>
                                    <td colspan="3">
                                        <asp:DropDownList ID="ShipToAddressType" runat="server">    
                                            <asp:ListItem Text="Residence"></asp:ListItem>
                                            <asp:ListItem Text="Business"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <th><asp:Label ID="ShipMethodLabel" runat="server" Text="Shipping Method:"></asp:Label></th>
                        <td>
                            <asp:DropDownList ID="ShipMethodList" runat="server" DataSourceID="ShipMethodDs" DataTextField="Name" DataValueField="ShipMethodId" AppendDataBoundItems="True" AutoPostBack="true">
                                <asp:ListItem Text=""></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trShipCharge" runat="server">
                        <th><asp:Label ID="ShipRate" runat="server" Text="Shipping Charge:"></asp:Label></th>
                        <td><asp:TextBox ID="ShipCharges" runat="server" Text="" Width="40px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th valign="top"><asp:Label ID="ShipMessageLabel" runat="server" Text="Order Note:"></asp:Label></th>
                        <td><asp:TextBox ID="ShipMessage" runat="server" Height="74px" Rows="3" Width="257px" Wrap="true" TextMode="multiline"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                            <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="Default.aspx" SkinID="CancelButton" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="ShipMethodDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Shipping.ShipMethodDataSource">
    </asp:ObjectDataSource>
</asp:Content>