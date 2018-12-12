<%@ Page Title="Checkout - Edit Billing Address" Language="C#" MasterPageFile="~/Layouts/Fixed/Checkout.master" AutoEventWireup="True" CodeFile="EditBillAddress.aspx.cs" Inherits="AbleCommerce.Checkout.EditBillAddress" %>
<%@ Register Src="~/ConLib/CheckoutProgress.ascx" TagName="CheckoutProgress" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Checkout/BasketTotalSummary.ascx" tagname="BasketTotalSummary" tagprefix="uc1" %>
<%@ Register src="~/ConLib/BasketShippingEstimate.ascx" tagname="BasketShippingEstimate" tagprefix="uc2" %>
<asp:Content ID="PageContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="checkoutPage"> 
    <div id="checkout_billPage" class="mainContentWrapper"> 
	    <div id="pageHeader">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Billing Address"></asp:Localize></h1>
        </div>
        <div class="columnsWrapper">
        <div class="column_1 mainColumn">
            <div class="section">
                <div class="content">
                    <asp:ValidationSummary ID="RegisterValidationSummary" runat="server" />
                    <table cellspacing="0" class="inputForm">                        
                        <asp:PlaceHolder ID="CreateNewAccountPanel" runat="server">
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Text="Email Address:"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="UserName" runat="server" Width="250"></asp:TextBox>
                                    <asp:Label ID="UserNameRequiredLabel" runat="server" Text="*" CssClass="requiredField" EnableViewState="false"></asp:Label>
                                    <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="UserName" Display="Dynamic" Required="true" 
                                        ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>
                                    <asp:CustomValidator ID="InvalidRegistration" runat="server" ControlToValidate="UserName" ErrorMessage="Registration was not successful." ToolTip="Registration was not successful."
                                        Display="Dynamic" Text="*"></asp:CustomValidator>
                                    <asp:CustomValidator ID="DuplicateEmailValidator" runat="server" ControlToValidate="UserName" Display="Dynamic"
                                        Text="*" ErrorMessage="This email address is already associated with an existing user account.  Use the 'Forgot User Name or Password' feature if you need to retrieve your login information, or use a different email address to register." />
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Text="Password:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="Password" runat="server" TextMode="Password" Width="120" MaxLength="24"></asp:TextBox>
                                    <asp:Label ID="PasswordRequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                        ErrorMessage="You must provide a password" ToolTip="You must provide a password"
                                        Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:PlaceHolder ID="PasswordValidatorPanel" runat="server" EnableViewState="false" />
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword" Text="Re-enter:"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" Width="120" 
                                        MaxLength="24"></asp:TextBox>
                                    <asp:Label ID="ConfirmPasswordRequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                        ErrorMessage="You must re-enter the password." ToolTip="You must re-enter the password."
                                        Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                                        ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="You did not re-enter the password correctly."
                                        Text="*"></asp:CompareValidator>
                                </td>
                            </tr>
                            <tr><th class="passwordHelpText"></th>
                                <td>
                                    <i><asp:Localize ID="PasswordPolicyLength" runat="server" Text="Your password must be at least {0} characters long."></asp:Localize>
                                    <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="You must include at least one {0}."></asp:Localize></i>
                                </td>
                            </tr>
                            <tr id="trCaptchaField" runat="server" visible="false">
                                <th class="rowHeader">
                                    <asp:Label ID="CaptchaInputLabel" runat="server" Text="Verification Number:" AssociatedControlID="CaptchaInput" CssClass="H2" EnableViewState="False"></asp:Label><br />
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="CaptchaInput" runat="server" Width="80" 
                                        EnableViewState="False" ValidationGroup="Register"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="CaptchaRequired" runat="server" ControlToValidate="CaptchaInput"
                                        ErrorMessage="You must enter the number in the image." ToolTip="You must enter the number in the image."
                                        Display="Dynamic" Text="*" EnableViewState="False"></asp:RequiredFieldValidator>
                                    <asp:PlaceHolder ID="phCaptchaValidators" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                </td>
                            </tr>
                            <tr ID="trCaptchaImage" runat="server" Visible="false">
                                <td>&nbsp;</td>
                                <td colspan="2">
                                    <asp:UpdatePanel ID="CaptchaPanel" UpdateMode="Conditional" runat="server">
                                        <ContentTemplate>
                                            <cb:CaptchaImage ID="CaptchaImage" runat="server" Height="60px" Width="200px" EnableViewState="False" /><br />
                                            <asp:LinkButton ID="ChangeImageLink" runat="server" Text="show a different image" CausesValidation="false" OnClick="ChangeImageLink_Click" EnableViewState="False"></asp:LinkButton>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                    </asp:PlaceHolder>
                    <asp:UpdatePanel ID="EditAddressAjax" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="FirstName" runat="server" EnableViewState="false" MaxLength="30" Width="250"></asp:TextBox> 
                                    <asp:Label ID="FirstNameRequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                        ErrorMessage="First name is required." Display="Dynamic" ControlToValidate="FirstName"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="LastName" runat="server" EnableViewState="false" MaxLength="50" Width="250"></asp:TextBox> 
                                    <asp:Label ID="LastNameRequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                        ErrorMessage="Last name is required." Display="Dynamic" ControlToValidate="LastName"
                                        EnableViewState="false"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="CompanyLabel" runat="server" Text="Company:" AssociatedControlID="Company" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="Company" runat="server" EnableViewState="false" MaxLength="50" Width="250"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" AssociatedControlID="Address1" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="Address1" runat="server" EnableViewState="false" MaxLength="100" Width="250"></asp:TextBox> 
                                    <asp:Label ID="Address1RequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                        ErrorMessage="Address is required." Display="Dynamic" ControlToValidate="Address1"
                                        EnableViewState="false"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" AssociatedControlID="Address2" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="Address2" runat="server" EnableViewState="false" MaxLength="100" Width="250"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="City" runat="server" EnableViewState="false" MaxLength="50" Width="250"></asp:TextBox> 
                                    <asp:Label ID="CityRequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                        ErrorMessage="City is required." Display="Dynamic" ControlToValidate="City"
                                        EnableViewState="false"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="CountryLabel" runat="server" Text="Country:" AssociatedControlID="Country" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode" 
                                        OnSelectedIndexChanged="Country_Changed" AutoPostBack="true" Width="150"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="Province" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="Province" runat="server" MaxLength="30" Width="250"></asp:TextBox> 
                                    <asp:DropDownList ID="Province2" runat="server" Width="150"></asp:DropDownList>
                                    <asp:CustomValidator ID="Province2Invalid" runat="server" Text="*"
                                        ErrorMessage="The state or province you entered was not recognized.  Please choose from the list." Display="Dynamic" ControlToValidate="Province2"></asp:CustomValidator>
                                    <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
                                        ErrorMessage="State or province is required." Display="Dynamic" ControlToValidate="Province2"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" AssociatedControlID="PostalCode" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="PostalCode" runat="server" EnableViewState="false" MaxLength="10" Width="140"></asp:TextBox> 
                                    <asp:Label ID="PostalCodeRequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*"
                                        ErrorMessage="ZIP or Postal Code is required." Display="Dynamic" ControlToValidate="PostalCode"></asp:RequiredFieldValidator>
                                </td>
                            </tr> 
                            <tr id="trEmail" runat="server">
                                <th class="rowHeader">
                                    <asp:Label ID="BillToEmailLabel" runat="server" Text="Email:" AssociatedControlID="BillToEmail" EnableViewState="false"></asp:Label>
                                </th>
                                <td colspan="2">
                                    <asp:TextBox ID="BillToEmail" runat="server" MaxLength="250" Width="250"></asp:TextBox>
                                    <asp:Label ID="BillToEmailRequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <cb:EmailAddressValidator ID="BillToEmailValidator" runat="server" ControlToValidate="BillToEmail" Display="static" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="TelephoneLabel" runat="server" Text="Telephone:" AssociatedControlID="Telephone" EnableViewState="false"></asp:Label>
                                </th>
                                <td valign="top" colspan="2">
                                    <asp:TextBox ID="Telephone" runat="server" EnableViewState="false" MaxLength="30" Width="250"></asp:TextBox> 
                                    <asp:Label ID="TelephoneRequiredLabel" runat="server" Text="*" CssClass="requiredField"></asp:Label>
                                    <asp:RequiredFieldValidator ID="TelephoneRequired" runat="server" Text="*"
                                        ErrorMessage="Telephone number is required." ControlToValidate="Telephone"
                                        EnableViewState="False" SetFocusOnError="false" Display="Dynamic"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="FaxLabel" runat="server" Text="Fax:" AssociatedControlID="Fax" EnableViewState="false"></asp:Label>
                                </th>
                                <td valign="top" colspan="2">
                                    <asp:TextBox ID="Fax" runat="server" EnableViewState="false" MaxLength="30" Width="250"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td valign="top" colspan="2">
                                    <asp:CheckBox ID="IsBusinessAddress" runat="server" Text="Check box if this is a business address" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
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
                                            <asp:Button ID="UseValidAddressButton" runat="server" Text="Continue" OnClick="UseValidAddressButton_Click" />
                                            <asp:Button ID="CancelValidAddressButton" runat="server" Text="Cancel" OnClick="CancelValidAddressButton_Click" CausesValidation="false" />
                                        </asp:Panel>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    </table>
				</div>
            </div>
            <asp:ListView ID="EmailLists" runat="server">
                <LayoutTemplate>
                    <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                </LayoutTemplate>
                <ItemTemplate>
                    <div class="widget">
                        <div class="innerSection">
                            <div class="header">
                                <h2>
                                    <asp:CheckBox ID="Selected" runat="server" Checked="<%#IsEmailListChecked(Container.DataItem)%>" EnableViewState="false" />
                                    <%#Eval("Name")%>
                                </h2>
                            </div>
                            <div class="content">
                                <%#Eval("Description")%>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </div>
        <div class="column_2 sidebarColumn">
        <asp:Panel ID="ShippingAddressPanel" runat="server" CssClass="widget shippingOptionsWidget">
                <div class="innerSection">
                    <div class="header">
                        <h2><asp:Localize ID="ShippingAddressCaption" runat="server" Text="Shipping Address"></asp:Localize></h2>
                    </div>
                    <div class="content">
                        <div class="message">
						    <asp:Localize ID="ShipAddressInstructionText" runat="server" Text="Where would you like your order shipped?"></asp:Localize>
					    </div>
                        <div class="options">
                            <asp:RadioButtonList ID="ShipToOption" runat="server">
                                <asp:ListItem Text="Ship to this billing address" Value="SHIP_TO_BILLING_ADDRESS" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Ship to a different address" Value="SHIP_TO_ADDRESS"></asp:ListItem>
                                <%--<asp:ListItem Text="Ship to multiple addresses" Value="SHIP_TO_MULTIPLE_ADDRESSES"></asp:ListItem>--%>
                            </asp:RadioButtonList>
                        </div>
					    <div class="actions">
                            <asp:Button ID="ShippingContinueButton" runat="server" Text="Continue Checkout >>" OnClick="BillingPageContinue_Click" CssClass="button"/>
					    </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="NoShipmentPanel" runat="server" CssClass="widget continueCheckoutWidget">
                <div class="innerSection">
                    <div class="header">
                        <h2><asp:Localize ID="ContinueCaption" runat="server" Text="Continue Checkout"></asp:Localize></h2>
                    </div>
                    <div class="content">
                        <div class="message">
						    <asp:Localize ID="ContinueHelpText" runat="server" Text="Make sure your billing address is filled out completely then click Continue."></asp:Localize>
					    </div>
					    <div class="actions">
                            <asp:Button ID="NoShipmentContinueButton" runat="server" Text="Continue Checkout >>" OnClick="BillingPageContinue_Click" CssClass="button"/>
					    </div>
                    </div>
                </div>
            </asp:Panel>
            <uc1:BasketTotalSummary ID="BasketTotalSummary1" runat="server" ShowShipping="false" ShowEditLink="false" ShowMessage="true" ShowTaxes="false" />
            <uc2:BasketShippingEstimate ID="BasketShippingEstimate1" runat="server" />
        </div>
        </div>
    </div>
</div>
</asp:Content>
