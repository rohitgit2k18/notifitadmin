<%@ Page Language="C#" MasterPageFile="Order.master" Inherits="AbleCommerce.Admin.Orders.EditAddresses" Title="Edit Addresses"  CodeFile="EditAddresses.aspx.cs" AutoEventWireup="True" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Addresses"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="SaveButton" runat="server" text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
                <asp:HyperLink ID="CancelButon" runat="server" text="Cancel" NavigateUrl="ViewOrder.aspx" SkinID="CancelButton" EnableViewState="false" />
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content">
        <asp:UpdatePanel ID="EditAddressAjax" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <cb:Notification ID="SavedMessage" runat="server" text="Address(es) updated at {0:t}" Visible="false" EnableViewState="false" SkinID="GoodCondition"></cb:Notification>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <table cellspacing="0" class="inputForm" width="100%">
                    <tr class="sectionHeader">
                        <th colspan="4">
                            <asp:Label ID="BillToCaption" runat="server" Text="Bill To:"></asp:Label>
                        </th>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="BillToFirstNameLabel" runat="server" Text="First Name:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToFirstName" runat="server"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="BillToFirstNameValidator" runat="server" ControlToValidate="BillToFirstName" ErrorMessage="First name is required." Text="*"></asp:RequiredFieldValidator>
                        </td>
                        <th>
                            <asp:Label ID="BillToLastNameLabel" runat="server" Text="Last Name:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToLastName" runat="server"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="BillToLastNameValidator" runat="server" ControlToValidate="BillToLastName" ErrorMessage="Last name is required." Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="BillToCompanyLabel" runat="server" Text="Company:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToCompany" runat="server"></asp:TextBox> 
                        </td>
                        <th valign="top">
                            <asp:Label ID="BillToPhoneLabel" runat="server" Text="Phone:"></asp:Label>
                        </th>
                        <td colspan="3">
                            <asp:TextBox ID="BillToPhone" runat="server"></asp:TextBox><br />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="BillToAddress1Label" runat="server" Text="Street Address 1:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToAddress1" runat="server"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="BillToAddress1Validator" runat="server" ControlToValidate="BillToAddress1" ErrorMessage="First line of street address is required." Text="*"></asp:RequiredFieldValidator>
                        </td>
                        <th>
                            <asp:Label ID="BillToAddress2Label" runat="server" Text="Street Address 2:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToAddress2" runat="server"></asp:TextBox> 
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="BillToCityLabel" runat="server" Text="City:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToCity" runat="server"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="BillToCityValidator" runat="server" ControlToValidate="BillToCity" ErrorMessage="City is required." Text="*"></asp:RequiredFieldValidator>
                        </td>
                        <th>
                            <asp:Label ID="BillToProvinceLabel" runat="server" Text="State / Province:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToProvince" runat="server"></asp:TextBox> 
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="BillToPostalCodeLabel" runat="server" Text="ZIP / Postal Code:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToPostalCode" runat="server"></asp:TextBox> 
                        </td>
                        <th>
                            <asp:Label ID="BillToCountryLabel" runat="server" Text="Country:"></asp:Label>
                        </th>
                        <td>
                            <asp:DropDownList ID="BillToCountryCode" runat="server" DataTextField="Name" DataValueField="CountryCode"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="BillToEmailLabel" runat="server" Text="Email:" AssociatedControlID="BillToEmail"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BillToEmail" runat="server"></asp:TextBox> 
                        </td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                </table>
                <asp:Repeater ID="ShipmentRepeater" runat="server" OnItemDataBound="ShipmentRepeater_ItemDataBound">
                    <ItemTemplate>
                        <table cellspacing="0" class="inputForm" width="100%">
                            <tr class="sectionHeader">
                                <th colspan="4">
                                    <asp:Label ID="ShipToCaption" runat="server" Text='<%# string.Format("Shipment #{0}", (Container.ItemIndex + 1)) %>'></asp:Label>
                                </th>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="ShipToFirstNameLabel" runat="server" Text="First Name:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToFirstName" runat="server"></asp:TextBox><span class="requiredField">*</span> 
                                    <asp:RequiredFieldValidator ID="ShipToFirstNameValidator" runat="server" ControlToValidate="ShipToFirstName" ErrorMessage="First name is required." Text="*"></asp:RequiredFieldValidator>
                                </td>
                                <th>
                                    <asp:Label ID="ShipToLastNameLabel" runat="server" Text="Last Name:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToLastName" runat="server"></asp:TextBox><span class="requiredField">*</span> 
                                    <asp:RequiredFieldValidator ID="ShipToLastNameValidator" runat="server" ControlToValidate="ShipToLastName" ErrorMessage="Last name is required." Text="*"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="ShipToCompanyLabel" runat="server" Text="Company:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToCompany" runat="server"></asp:TextBox> 
                                </td>
                                <th valign="top">
                                    <asp:Label ID="ShipToPhoneLabel" runat="server" Text="Phone:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToPhone" runat="server"></asp:TextBox><br />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="ShipToAddress1Label" runat="server" Text="Street Address 1:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToAddress1" runat="server"></asp:TextBox><span class="requiredField">*</span> 
                                    <asp:RequiredFieldValidator ID="ShipToAddress1Validator" runat="server" ControlToValidate="ShipToAddress1" ErrorMessage="First line of street address is required." Text="*"></asp:RequiredFieldValidator>
                                </td>
                                <th>
                                    <asp:Label ID="ShipToAddress2Label" runat="server" Text="Street Address 2:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToAddress2" runat="server"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="ShipToCityLabel" runat="server" Text="City:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToCity" runat="server"></asp:TextBox><span class="requiredField">*</span> 
                                    <asp:RequiredFieldValidator ID="ShipToCityValidator" runat="server" ControlToValidate="ShipToCity" ErrorMessage="City is required." Text="*"></asp:RequiredFieldValidator>
                                </td>
                                <th>
                                    <asp:Label ID="ShipToProvinceLabel" runat="server" Text="State / Province:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToProvince" runat="server"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="ShipToPostalCodeLabel" runat="server" Text="ZIP / Postal Code:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ShipToPostalCode" runat="server"></asp:TextBox> 
                                </td>
                                <th>
                                    <asp:Label ID="ShipToCountryCodeLabel" runat="server" Text="Country:"></asp:Label>
                                </th>
                                <td>
                                    <asp:DropDownList ID="ShipToCountryCode" runat="server" DataTextField="Name" DataValueField="CountryCode"></asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:Repeater>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>