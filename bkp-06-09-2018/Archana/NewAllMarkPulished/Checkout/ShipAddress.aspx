<%@ Page Title="Checkout - Select Shipping Address" Language="C#" MasterPageFile="~/Layouts/Fixed/Checkout.master" AutoEventWireup="True" CodeFile="ShipAddress.aspx.cs" Inherits="AbleCommerce.Checkout.ShipAddress" %>
<%@ Register Src="~/ConLib/CheckoutProgress.ascx" TagName="CheckoutProgress" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/BasketTotalSummary.ascx" TagName="BasketTotalSummary" TagPrefix="uc" %>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="PageContent">
<div id="checkoutPage"> 
    <div id="checkout_shipPage" class="mainContentWrapper"> 
        <div id="pageHeader">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Select Shipping Address"></asp:Localize></h1>
        </div>
        <div class="columnsWrapper">
	    <div class="column_1 mainColumn">
            <div class="section">
                <div class="content">
			        <div class="info">
				        <p class="instruction">
					        <asp:Literal ID="HelpText" runat="server" Text="Your address book is shown below. Select the address where your order should be shipped. If the address you want is not listed you may add a new one."></asp:Literal>
				        </p>
			        </div>
                    <asp:UpdatePanel ID="AddressBookAjax" runat="server">
                        <ContentTemplate>
                            <div class="addressBook">
                                <div class="entries">
                                    <asp:Repeater ID="ShipToAddressList" runat="server" OnItemCommand="ShipToAddressList_ItemCommand" >
                                        <ItemTemplate>
                                            <div class="entry">
                                                <div class="caption">
                                                    <h2><asp:Literal ID="AddressCaption" runat="server" Text='<%#((bool)Eval("IsBilling"))?"Billing Address":"Shipping Address" %>'></asp:Literal></h2>
                                                    <span class="links">
                                                        <asp:LinkButton ID="EditAddressButton" runat="server" CommandArgument='<%#Eval("AddressId")%>' CommandName="Edit" Text="Edit" CssClass="link"></asp:LinkButton>
                                                        <asp:LinkButton ID="DeleteAddressButton" runat="server" CommandArgument='<%#Eval("AddressId")%>' CommandName="Del" Text="Delete" Visible='<%#!((bool)Eval("IsBilling")) %>' OnClientClick="return confirm('Are you sure to delete this address?');" CssClass="link" ></asp:LinkButton>
                                                    </span>
                                                </div>
                                                <div class="address">
                                                    <asp:Literal ID="Address" runat="server" Text='<%#Container.DataItem.ToString()%>'></asp:Literal>
                                                </div>
                                                <div class="buttons">
                                                    <asp:LinkButton ID="PickAddressButton" runat="server" SkinID="Button" Text="Ship Here" CommandName="Pick" CommandArgument='<%#Eval("AddressId")%>' CssClass="button"></asp:LinkButton>
                                                </div>                                        
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <div class="entry addEntry">
                                        <div class="buttons">
                                            <asp:LinkButton ID="NewAddressButton" runat="server" CssClass="button linkButton" Text="+ New Address" OnClick="NewAddressButton_Click" CausesValidation="false"></asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="popupOuterWrapper">
                                <asp:Button ID="DummyOK" runat="server" style="display:none" />
                                <ajaxToolkit:ModalPopupExtender ID="AddPanelPopup" runat="server" 
                                    TargetControlID="DummyOK"
                                    CancelControlID="CancelButton"
                                    PopupControlID="AddPanel"
                                    BackgroundCssClass="modalBackground"                         
                                    DropShadow="false"
                                    PopupDragHandleControlID="AddHeader" />
                                <asp:Panel ID="AddPanel" runat="server" Style="display:none;" CssClass="modalPopup addAddressPopup">
                                    <asp:Panel ID="AddHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                                        <asp:Localize ID="AddCaption" runat="server" Text="Add Shipping Address" />
                                        <asp:Localize ID="EditCaption" runat="server" Text="Edit Shipping Address" Visible="false"/>
                                        <asp:Localize ID="EditBillingCaption" runat="server" Text="Edit Billing Address" Visible="false" />
                                        <asp:HiddenField ID="HiddenEditAddressId" runat="server" />
                                    </asp:Panel>
                                    <div class="modalPopupContent">
                                        <p class="text">
                                            <asp:Literal ID="AddressInstructionsText" runat="server" Text="Enter the address in the form below. * denotes a required field."></asp:Literal>
                                        </p>
                                        <asp:ValidationSummary ID="AddValidationSummary" runat="server" ShowSummary="true" ValidationGroup="AddrBook" />
                                        <table class="inputForm">
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="FirstName" runat="server" MaxLength="30" Width="200"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                                        ErrorMessage="First name is required." Display="Static" ControlToValidate="FirstName" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="LastName" runat="server" MaxLength="50" Width="200"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                                        ErrorMessage="Last name is required." Display="Static" ControlToValidate="LastName" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="CompanyLabel" runat="server" Text="Company:" AssociatedControlID="Company"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Company" runat="server" MaxLength="50" Width="200"></asp:TextBox><br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" AssociatedControlID="Address1"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Address1" runat="server" MaxLength="100" Width="200"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                                        ErrorMessage="Address is required." Display="Static" ControlToValidate="Address1" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" AssociatedControlID="Address2"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Address2" runat="server" MaxLength="100" Width="200"></asp:TextBox> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="City" runat="server" MaxLength="50" Width="200"></asp:TextBox><span class="requiredField">*</span> 
                                                    <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                                        ErrorMessage="City is required." Display="Static" ControlToValidate="City" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                             <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="CountryLabel" runat="server" Text="Country:" AssociatedControlID="Country"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode" AutoPostBack="true" OnSelectedIndexChanged="CountryChanged" Width="250" AppendDataBoundItems="false">
                                                        <%-- provide a default to prevent validation errors on initial load --%>
                                                        <asp:ListItem Value=""></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="Province"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Province" runat="server" MaxLength="50" Width="250"></asp:TextBox> 
                                                    <asp:DropDownList ID="Province2" runat="server" Width="250" Visible="false"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="ProvinceRequired" runat="server" Text="*"
                                                        ErrorMessage="State or province is required." Display="Dynamic" ControlToValidate="Province" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
                                                        ErrorMessage="State or province is required." Display="Static" ControlToValidate="Province2" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" AssociatedControlID="PostalCode"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="PostalCode" runat="server" MaxLength="10" Width="100"></asp:TextBox><span class="requiredField">*</span> 
                                                    <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*"
                                                        ErrorMessage="ZIP or Postal Code is required." Display="Static" ControlToValidate="PostalCode" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="USPostalCodeRequired" runat="server" Text="*" ValidationExpression="^\d{5}(-?\d{4})?$"
                                                        ErrorMessage="ZIP code should be in the format of ######(-####)." Display="Static" ControlToValidate="PostalCode" ValidationGroup="AddrBook"></asp:RegularExpressionValidator>
                                                    <asp:RegularExpressionValidator ID="CAPostalCodeRequired" runat="server" Text="*" ValidationExpression="^[A-Za-z][0-9][A-Za-z] ?[0-9][A-Za-z][0-9]$"
                                                        ErrorMessage="Postal code should be in the format of A#A #A#." Display="Static" ControlToValidate="PostalCode" ValidationGroup="AddrBook"></asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="PhoneLabel" runat="server" Text="Telephone:" AssociatedControlID="Phone"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Phone" runat="server" MaxLength="30" Width="100"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Text="*"
                                                        ErrorMessage="Phone number is required." Display="Static" ControlToValidate="Phone" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="FaxLabel" runat="server" Text="Fax:" AssociatedControlID="Fax"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Fax" runat="server" MaxLength="30" Width="100"></asp:TextBox> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td><asp:CheckBox ID="IsBusiness" runat="server" Text="Check box if this is a business address." /></td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td>
                                                    <asp:Button ID="SaveButton" runat="server" Text="Save Address" OnClick="SaveButton_Click" ValidationGroup="AddrBook" CssClass="button"></asp:Button>
											        <asp:Button ID="CancelButton" runat="server" Text="Cancel" CausesValidation="false" OnClick="CancelButton_Click" CssClass="button"></asp:Button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
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
                                                            <asp:Button ID="UseValidAddressButton" runat="server" Text="Continue" OnClick="SaveButton_Click" />
                                                            <asp:Button ID="CancelValidAddressButton" runat="server" Text="Cancel" OnClick="CancelValidAddressButton_Click" />
                                                        </asp:Panel>
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </asp:Panel>            
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
	    </div>
        <div class="column_2 sidebarColumn">
    		<uc:BasketTotalSummary ID="BasketTotalSummary1" runat="server" ShowEditLink="false" ShowShipping="false" />
	        <%--<asp:PlaceHolder ID="MultipleDestinationsPanel" runat="server">
		        <div class="widget multipleDestinationWidget">
                    <div class="innerSection">
			            <div class="header">
				            <h2><asp:Localize ID="MultipleDestinationsCaption" runat="server" Text="Multiple Destinations"></asp:Localize></h2>
			            </div>
			            <div class="content">
				            <div class="info">
					            <p class="instruction">
					                <asp:Literal ID="MultipleDestinationsHelpText" runat="server" Text="If you wish to ship your items to multiple locations, add your addresses then click the button below."></asp:Literal>
					            </p>
				            </div>
				            <div class="actions">
					            <asp:HyperLink ID="MultipleAddressLink" runat="server" Text="Ship To Multiple Addresses" CssClass="button hyperLinkButton" NavigateUrl="~/Checkout/ShipAddresses.aspx"></asp:HyperLink>
				            </div>
			            </div>
                    </div>
		        </div>
	        </asp:PlaceHolder>--%>
        </div>
        </div>
    </div>
</div>
</asp:Content>