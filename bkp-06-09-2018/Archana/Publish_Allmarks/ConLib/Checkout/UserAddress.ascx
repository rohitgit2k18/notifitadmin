<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserAddress.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.UserAddress" %>
<%--
<conlib>
<summary>Form for getting user address</summary>
<param name="ValidationGroup" default="UserAddress">If you need to use multiple controls on same page, a unique validation group need to be specified for each instance of the control.</param>
<param name="AddressId">The Id of the Address to display.</param>
<param name="ShipmentId">The Id of the Shipment to display the address for, if specified it will provide options to change or edit the shipment address.</param>
</conlib>
--%>
<div class="widget">
    <asp:UpdatePanel ID="AddressAjax" runat="server">
        <Triggers>
        </Triggers>
        <ContentTemplate>        
            <div class="userAddress">
				<div class="innerSection">
					<div id="Header" runat="server" class="header">
						<div class="editLink"><asp:LinkButton ID="BillingEditLink" runat="server" Text="Edit" OnClick="EditLink_Click" ></asp:LinkButton></div>
						<asp:Localize ID="Caption" runat="server" Text="Billing Address"></asp:Localize>
					</div>
					<div class="content">
						<div class="editLink"><asp:LinkButton ID="EditLink" runat="server" Text="Edit" OnClick="EditLink_Click" CssClass="button linkButton"></asp:LinkButton> </div>
						<asp:Literal ID="AddressData" runat="server"></asp:Literal>
					</div>
				</div>
            </div>            
            <div class="popupOuterWrapper">
                <asp:Button ID="DummyOK" runat="server" style="display:none" />
                <asp:Button ID="DummyCancel" runat="server" style="display:none" />
                <ajaxToolkit:ModalPopupExtender ID="EditPanelPopup" runat="server" 
                    TargetControlID="DummyOK"
                    CancelControlID="DummyCancel"
                    PopupControlID="EditPanel"
                    BackgroundCssClass="modalBackground"                         
                    DropShadow="false"
                    PopupDragHandleControlID="EditHeader" />
                <asp:Panel ID="EditPanel" runat="server" Style="display:none;" CssClass="modalPopup editAddressPopup">
                    <asp:Panel ID="EditHeader" runat="server" CssClass="header" EnableViewState="false">
                        <asp:Localize ID="EditCaption" runat="server" Text="Edit Address" />
                    </asp:Panel>
					
                    <div class="inputForm">
                        <asp:ValidationSummary ID="EditValidationSummary" runat="server" ShowSummary="true" ValidationGroup="UserAddress" />
                        <p class="text">
                            <asp:Literal ID="AddressInstructionsText" runat="server" Text="Edit the address in the form below. {R} denotes a required field."></asp:Literal>
                        </p>
                        <table class="inputForm" cellpadding="3">
                            <tr id="trAddressBook" runat="server">
                                <th class="rowHeader">
                                    Address Book:
                                </th>
                                <td>
                                    <asp:DropDownList ID="AddressBook" runat="server" Width="300px" DataTextField="Value" 
                                        DataValueField="Key" AutoPostBack="true" OnSelectedIndexChanged="AddressChanged"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader" style="width:140px">
                                    <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="FirstName" runat="server" MaxLength="30"></asp:TextBox><span class="required">{R}</span>
                                    <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                        ErrorMessage="First name is required." Display="Static" ControlToValidate="FirstName" ValidationGroup="UserAddress"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="LastName" runat="server" MaxLength="50"></asp:TextBox><span class="required">{R}</span>
                                    <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                        ErrorMessage="Last name is required." Display="Static" ControlToValidate="LastName" ValidationGroup="UserAddress"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader" style="width:140px">
                                    <asp:Label ID="CompanyLabel" runat="server" Text="Company:" AssociatedControlID="Company"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="Company" runat="server" MaxLength="50"></asp:TextBox><br />
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" AssociatedControlID="Address1"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="Address1" runat="server" MaxLength="100"></asp:TextBox><span class="required">{R}</span>
                                    <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                        ErrorMessage="Address is required." Display="Static" ControlToValidate="Address1" ValidationGroup="UserAddress"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader" style="width:140px">
                                    <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" AssociatedControlID="Address2"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="Address2" runat="server" MaxLength="100"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="City" runat="server" MaxLength="50"></asp:TextBox><span class="required">{R}</span> 
                                    <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                        ErrorMessage="City is required." Display="Static" ControlToValidate="City" ValidationGroup="UserAddress"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader" style="width:140px">
                                    <asp:Label ID="CountryLabel" runat="server" Text="Country:" AssociatedControlID="Country"></asp:Label>
                                </th>
                                <td>
                                    <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode" AutoPostBack="true" OnSelectedIndexChanged="CountryChanged"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader" style="width:140px">
                                    <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="Province"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="Province" runat="server" MaxLength="50"></asp:TextBox> 
                                    <asp:DropDownList ID="Province2" runat="server"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="ProvinceRequired" runat="server" Text="*"
                                        ErrorMessage="State or province is required." Display="Dynamic" ControlToValidate="Province" ValidationGroup="UserAddress"></asp:RequiredFieldValidator>
                                    <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
                                        ErrorMessage="State or province is required." Display="Static" ControlToValidate="Province2" ValidationGroup="UserAddress"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" AssociatedControlID="PostalCode"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="PostalCode" runat="server" MaxLength="10"></asp:TextBox><span class="required">{R}</span> 
                                    <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*"
                                        ErrorMessage="ZIP or Postal Code is required." Display="Static" ControlToValidate="PostalCode" ValidationGroup="UserAddress"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="USPostalCodeRequired" runat="server" Text="*" ValidationExpression="^\d{5}(-?\d{4})?$"
                                        ErrorMessage="ZIP code should be in the format of ######(-####)." Display="Static" ControlToValidate="PostalCode" ValidationGroup="UserAddress"></asp:RegularExpressionValidator>
                                    <asp:RegularExpressionValidator ID="CAPostalCodeRequired" runat="server" Text="*" ValidationExpression="^[A-Za-z][0-9][A-Za-z] ?[0-9][A-Za-z][0-9]$"
                                        ErrorMessage="Postal code should be in the format of A#A #A#." Display="Static" ControlToValidate="PostalCode" ValidationGroup="UserAddress"></asp:RegularExpressionValidator>
                                </td>
                            </tr>  
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="PhoneLabel" runat="server" Text="Telephone:" AssociatedControlID="Phone"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="Phone" runat="server" MaxLength="30"></asp:TextBox><span class="required">{R}</span> 
                                    <asp:RequiredFieldValidator ID="PhoneRequired" runat="server" Text="*"
                                        ErrorMessage="Phone number is required." Display="Static" ControlToValidate="Phone" ValidationGroup="UserAddress"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader" style="width:140px">
                                    <asp:Label ID="FaxLabel" runat="server" Text="Fax:" AssociatedControlID="Fax"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="Fax" runat="server" MaxLength="30"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td><asp:CheckBox ID="IsBusiness" runat="server" Text=" Check box if this is a business address." /></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:Button ID="SaveButton" runat="server" Text="Save Address" OnClick="SaveButton_Click" ValidationGroup="UserAddress"></asp:Button>
                                    &nbsp;<asp:Button ID="CancelButton" runat="server" Text="Cancel" CausesValidation="false" OnClick="CancelButton_Click"></asp:Button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </asp:Panel>
            </div>
            </ContentTemplate>
    </asp:UpdatePanel>
</div>
