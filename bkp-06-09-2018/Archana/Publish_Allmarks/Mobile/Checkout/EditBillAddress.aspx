<%@ Page Title="Checkout - Edit Billing Address" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="True" CodeFile="EditBillAddress.aspx.cs" Inherits="AbleCommerce.Mobile.Checkout.EditBillAddress" %>
<%@ Register src="~/Mobile/UserControls/CheckoutNavBar.ascx" tagname="CheckoutNavBar" tagprefix="uc1" %>
<asp:Content ID="PageContent" runat="server" ContentPlaceHolderID="PageContent">
    <uc1:CheckoutNavBar ID="CheckoutNavBar" runat="server" />
    <div id="checkoutPage">     
        <div id="checkout_editBillAddrPage" class="mainContentWrapper"> 
	        <div class="pageHeader">
		        <h1><asp:Localize ID="Caption" runat="server" Text="Billing Address"></asp:Localize></h1>
            </div>
            <div class="column_1 mainColumn">
                <div class="section">
                    <div class="content">
                    <div class="inputForm">
                        <div class="validationSummary">
                            <asp:ValidationSummary ID="RegisterValidationSummary" runat="server" />
                        </div>
                        <asp:PlaceHolder ID="CreateNewAccountPanel" runat="server">
                            <div class="field">
                                <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Text="Email Address:" CssClass="fieldHeader"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="UserName" runat="server" ></asp:TextBox><span class="requiredField">(R)</span>
                                    <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="UserName" Display="Dynamic" Required="true" 
                                        ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>
                                    <asp:CustomValidator ID="InvalidRegistration" runat="server" ControlToValidate="UserName" ErrorMessage="Registration was not successful." ToolTip="Registration was not successful."
                                        Display="Dynamic" Text="*"></asp:CustomValidator>
                                    <asp:CustomValidator ID="DuplicateEmailValidator" runat="server" ControlToValidate="UserName" Display="Dynamic"
                                        Text="*" ErrorMessage="This email address is already associated with an existing user account.  Use the 'Forgot User Name or Password' feature if you need to retrieve your login information, or use a different email address to register." />
                                </span>
                            </div>
                            <div class="field">
                                <p><i>
                                    <asp:Localize ID="PasswordPolicyLength" runat="server" Text="Your password must be at least {0} characters long."></asp:Localize>
                                    <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="You must include at least one {0}."></asp:Localize>
                                </i></p>
                                <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Text="Password:" CssClass="fieldHeader"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="Password" runat="server" TextMode="Password" MaxLength="24"></asp:TextBox><span class="requiredField">(R)</span>
                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                        ErrorMessage="You must provide a password" ToolTip="You must provide a password"
                                        Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:PlaceHolder ID="PasswordValidatorPanel" runat="server" EnableViewState="false" />
                                </span>
                            </div>
                           <div class="field">
                                <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword" Text="Re-enter:" CssClass="fieldHeader"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" MaxLength="24"></asp:TextBox><span class="requiredField">(R)</span>
                                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                        ErrorMessage="You must re-enter the password." ToolTip="You must re-enter the password."
                                        Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                                        ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="You did not re-enter the password correctly."
                                        Text="*"></asp:CompareValidator>
                                 </span>
                            </div>
                            <div id="trCaptchaImage" runat="server" visible="true" class="field">
                                <span class="fieldValue">
                                    <asp:UpdatePanel ID="CaptchaPanel" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:Label ID="CaptchaImageLabel" runat="server" Text="Verification Number:" AssociatedControlID="CaptchaImage" CssClass="fieldHeader" EnableViewState="False"></asp:Label><br />
                                            <cb:CaptchaImage ID="CaptchaImage" runat="server" Height="60px" Width="200px" EnableViewState="False" />
                                            <p><asp:LinkButton ID="ChangeImageLink" runat="server" Text="different image" CausesValidation="false" OnClick="ChangeImageLink_Click" EnableViewState="False" TabIndex="6" CssClass="button linkButton"></asp:LinkButton></p>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </span>
                            </div>
                            <div id="trCaptchaField" runat="server" visible="true" class="field">
                                <asp:Label ID="CaptchaInputLabel" runat="server" Text="Verification:" EnableViewState="False" CssClass="fieldHeader"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="CaptchaInput" runat="server" Width="80px" 
                                        EnableViewState="False" TabIndex="4"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="CaptchaRequired" runat="server" ControlToValidate="CaptchaInput"
                                        ErrorMessage="You must enter the number in the image." ToolTip="You must enter the number in the image."
                                        Display="Dynamic" ValidationGroup="Login" Text="*" EnableViewState="False"></asp:RequiredFieldValidator>
                                    <asp:PlaceHolder ID="phCaptchaValidators" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                </span>
                            </div>
                        </asp:PlaceHolder>
                        <asp:UpdatePanel ID="EditAddressAjax" runat="server">
                            <ContentTemplate> 
                              <div class="field"> 
                                <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" CssClass="fieldHeader" AssociatedControlID="FirstName" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="FirstName" runat="server" EnableViewState="false" MaxLength="30" ></asp:TextBox><span class="requiredField">(R)</span> 
                                    <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                        ErrorMessage="First name is required." Display="Dynamic" ControlToValidate="FirstName"></asp:RequiredFieldValidator>
                                </span>
                              </div>
                               <div class="field">
                                    <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" CssClass="fieldHeader" AssociatedControlID="LastName" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="LastName" runat="server" EnableViewState="false" MaxLength="50" ></asp:TextBox><span class="requiredField">(R)</span>
                                    <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                        ErrorMessage="Last name is required." Display="Dynamic" ControlToValidate="LastName"
                                        EnableViewState="false"></asp:RequiredFieldValidator>
                                </span>
                               </div>
                                <div class="field">
                                    <asp:Label ID="CompanyLabel" runat="server" Text="Company:" CssClass="fieldHeader" AssociatedControlID="Company" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="Company" runat="server" EnableViewState="false" MaxLength="50" ></asp:TextBox> 
                                </span>
                               </div>
                               <div class="field">
                                    <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" CssClass="fieldHeader" AssociatedControlID="Address1" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="Address1" runat="server" EnableViewState="false" MaxLength="100" ></asp:TextBox><span class="requiredField">(R)</span> 
                                    <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                        ErrorMessage="Address is required." Display="Dynamic" ControlToValidate="Address1"
                                        EnableViewState="false"></asp:RequiredFieldValidator>
                                </span>
                                </div>
                                <div class="field">
                                    <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" CssClass="fieldHeader" AssociatedControlID="Address2" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="Address2" runat="server" EnableViewState="false" MaxLength="100" ></asp:TextBox> 
                                </span>
                                </div>
                                <div class="field">
                                    <asp:Label ID="CityLabel" runat="server" Text="City:" CssClass="fieldHeader" AssociatedControlID="City" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="City" runat="server" EnableViewState="false" MaxLength="50" ></asp:TextBox><span class="requiredField">(R)</span> 
                                    <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                        ErrorMessage="City is required." Display="Dynamic" ControlToValidate="City"
                                        EnableViewState="false"></asp:RequiredFieldValidator>
                                </span>
                                </div>
                                <div class="field">
                                    <asp:Label ID="CountryLabel" runat="server" Text="Country:" CssClass="fieldHeader" AssociatedControlID="Country" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode" 
                                        OnSelectedIndexChanged="Country_Changed" AutoPostBack="true" ></asp:DropDownList>
                                </span>
                                </div>
                                <div class="field">
                                    <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" CssClass="fieldHeader" AssociatedControlID="Province" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="Province" runat="server" MaxLength="30" ></asp:TextBox> 
                                    <asp:DropDownList ID="Province2" runat="server" ></asp:DropDownList><span class="requiredField">(R)</span>
                                    <asp:CustomValidator ID="Province2Invalid" runat="server" Text="*"
                                        ErrorMessage="The state or province you entered was not recognized.  Please choose from the list." Display="Dynamic" ControlToValidate="Province2"></asp:CustomValidator>
                                    <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
                                        ErrorMessage="State or province is required." Display="Dynamic" ControlToValidate="Province2"></asp:RequiredFieldValidator>
                                </span>
                                </div>
                                <div class="field">
                                    <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" CssClass="fieldHeader" AssociatedControlID="PostalCode" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="PostalCode" runat="server" EnableViewState="false" MaxLength="10" ></asp:TextBox><span id="PostalCodeRequiredLabel" class="requiredField" runat="server">(R)</span> 
                                    <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*"
                                        ErrorMessage="ZIP or Postal Code is required." Display="Dynamic" ControlToValidate="PostalCode"></asp:RequiredFieldValidator>
                                </span>
                                </div>
                                <asp:PlaceHolder ID="BillToEmailHolder" runat="server">
                                <div class="field">
                                    <asp:Label ID="BillToEmailLabel" runat="server" Text="Email:" CssClass="fieldHeader" AssociatedControlID="BillToEmail" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="BillToEmail" runat="server" MaxLength="250" ></asp:TextBox><span class="requiredField">(R)</span>
                                    <cb:EmailAddressValidator ID="BillToEmailValidator" runat="server" ControlToValidate="BillToEmail" Display="static" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>
                                </span>
                                </div>
                                </asp:PlaceHolder>
                                <div class="field">
                                    <asp:Label ID="TelephoneLabel" runat="server" Text="Telephone:" CssClass="fieldHeader" AssociatedControlID="Telephone" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="Telephone" runat="server" EnableViewState="false" MaxLength="30" ></asp:TextBox><span class="requiredField">(R)</span> 
                                    <asp:RequiredFieldValidator ID="TelephoneRequired" runat="server" Text="*"
                                        ErrorMessage="Telephone number is required." ControlToValidate="Telephone"
                                        EnableViewState="False" SetFocusOnError="false" Display="Dynamic"></asp:RequiredFieldValidator>
                                </span>
                                </div>
                                <div class="field">
                                    <asp:Label ID="FaxLabel" runat="server" Text="Fax:" CssClass="fieldHeader" AssociatedControlID="Fax" EnableViewState="false"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="Fax" runat="server" EnableViewState="false" MaxLength="30" ></asp:TextBox> 
                                </span>
                                </div>
                                <div class="field">
                                    <asp:CheckBox ID="IsBusinessAddress" runat="server" Text="This is a business address" />
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
				    </div>
                </div>
                <asp:ListView ID="EmailLists" runat="server">
                    <LayoutTemplate>
                        <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <div class="widget">
                            <div class="section">
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
                    <asp:Button ID="ShippingContinueButton" runat="server" Text="Continue Checkout >>" OnClick="BillingPageContinue_Click" CssClass="button"/>
                </asp:Panel>
                <asp:Panel ID="NoShipmentPanel" runat="server" CssClass="widget continueCheckoutWidget">
                    <div class="section">
                        <div class="content">
                            <p><asp:Localize ID="ContinueHelpText" runat="server" Text="Make sure your billing address is filled out completely then click Continue."></asp:Localize></p>
					        <asp:Button ID="NoShipmentContinueButton" runat="server" Text="Continue Checkout >>" OnClick="BillingPageContinue_Click" CssClass="button"/>
                        </div>
                    </div>
                </asp:Panel>
            </div>
            </div>
        </div>
    </div>
</asp:Content>