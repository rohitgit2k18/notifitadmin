<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddressDetails.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.AddressDetails" %>
<div class="opcInputForm">
    <div class="clear">
        <asp:ValidationSummary ID="RegisterValidationSummary" runat="server" />
    </div>
    <div>
        <span class="label">First Name <span class="requiredField">*</span></span>
        <asp:TextBox ID="FirstName" runat="server" CssClass="large"></asp:TextBox>
        <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                        ErrorMessage="First name is required." Display="Dynamic" ControlToValidate="FirstName"></asp:RequiredFieldValidator>
    </div>
    <div>
        <span class="label">Last Name <span class="requiredField">*</span></span>
        <asp:TextBox ID="LastName" runat="server" CssClass="large"></asp:TextBox>
        <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                        ErrorMessage="Last name is required." Display="Dynamic" ControlToValidate="LastName"></asp:RequiredFieldValidator>
    </div>
    <div class="clear">
        <asp:PlaceHolder ID="EmailPanel" runat="server">
            <span class="label">Email <span class="requiredField">*</span></span>
            <asp:TextBox ID="Email" runat="server" CssClass="large"></asp:TextBox>
            <cb:EmailAddressValidator ID="EmailAddressValid" runat="server" ControlToValidate="Email" Display="Dynamic" Required="true" 
                                        ErrorMessage="Email address should be in the format of name@domain.tld." Text="*"></cb:EmailAddressValidator>
        </asp:PlaceHolder>
    </div>
    <div class="clear">
        <asp:UpdatePanel ID="CreateAccountUpdatePanel" runat="server" Visible="false">
        <ContentTemplate>
            <asp:CheckBox ID="CreateAccount" runat="server" 
                    Text="Create an account for later use." AutoPostBack="true" 
                    oncheckedchanged="CreateAccount_CheckedChanged" />
            <asp:PlaceHolder ID="CreateAccountPh" runat="server" Visible="false">
                <i>
                    <asp:Localize ID="PasswordPolicyLength" runat="server" Text="<br />Your password must be at least {0} characters long." EnableViewState="false"></asp:Localize>
				    <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="You must include at least one {0}." EnableViewState="false"></asp:Localize>
                </i>
                <span class="label">Password:<span class="requiredField">*</span></span>
                <asp:TextBox ID="Password" runat="server" TextMode="Password" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
				    ErrorMessage="You must provide a password" ToolTip="You must provide a password"
				    Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:PlaceHolder ID="PasswordValidatorPanel" runat="server"/>
                <span class="label">Confirm Password:<span class="requiredField">*</span></span>
                <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                    ErrorMessage="You must re-enter the password." ToolTip="You must re-enter the password."
                    Text="*" Display="Dynamic" ></asp:RequiredFieldValidator>
		        <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
		            ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="You did not re-enter the password correctly."
		            Text="*"></asp:CompareValidator>
                <asp:CustomValidator ID="InvalidRegistration" runat="server" ErrorMessage="Registration was not successful." ToolTip="Registration was not successful."
                    Display="Dynamic" Text="*"></asp:CustomValidator>
                <asp:CustomValidator ID="DuplicateEmailValidator" runat="server" Display="Dynamic"
                    ErrorMessage="This email address is already associated with an existing user account.  Use the 'Forgot User Name or Password' feature if you need to retrieve your login information, or use a different email address to register." Text="*" />
            </asp:PlaceHolder>
        </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="clear">
        <span class="label">Company</span>
        <asp:TextBox ID="Company" runat="server" CssClass="large"></asp:TextBox>
        <span class="label">Address 1 <span class="requiredField">*</span></span>
        <asp:TextBox ID="Address1" runat="server" CssClass="large"></asp:TextBox>
        <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                        ErrorMessage="Address is required." Display="Dynamic" ControlToValidate="Address1"></asp:RequiredFieldValidator>
        <span class="label">Address 2</span>
        <asp:TextBox ID="Address2" runat="server" CssClass="large"></asp:TextBox>
    </div>
    <div class="clear">
    </div>
    <div class="clear">
        <span class="label">Country <span class="requiredField">*</span></span>
        <asp:DropDownList ID="Country" runat="server" CssClass="large" DataTextField="Name"
            DataValueField="CountryCode" OnSelectedIndexChanged="Country_Changed" AutoPostBack="true">
        </asp:DropDownList>
        <span class="label">Region/State <span class="requiredField">*</span></span>
        <asp:TextBox ID="Province" runat="server" CssClass="large"></asp:TextBox>
        <asp:CustomValidator ID="Province2Invalid" runat="server" Text="*" ErrorMessage="The state or province you entered was not recognized.  Please choose from the list."
            Display="Dynamic" ControlToValidate="Province2"></asp:CustomValidator>
        <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
            ErrorMessage="State or province is required." Display="Dynamic" ControlToValidate="Province2"></asp:RequiredFieldValidator>
        <asp:DropDownList ID="Province2" runat="server" CssClass="large">
        </asp:DropDownList>
    </div>
    <div>
        <span class="label">City <span class="requiredField">*</span></span>
        <asp:TextBox ID="City" runat="server" CssClass="large"></asp:TextBox>
        <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                        ErrorMessage="City is required." Display="Dynamic" ControlToValidate="City"></asp:RequiredFieldValidator>
    </div>
    <div>
        <span class="label">Postal Code <span class="requiredField" id="PostalCodeRequiredLabel"
            runat="server" visible="false">*</span></span>
        <asp:TextBox ID="PostalCode" runat="server" CssClass="large"></asp:TextBox>
        <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*" ErrorMessage="ZIP or Postal Code is required."
            Display="Dynamic" ControlToValidate="PostalCode"></asp:RequiredFieldValidator>
    </div>
    <div>
        <span class="label">Telephone <span class="requiredField">*</span></span>
        <asp:TextBox ID="Telephone" runat="server" CssClass="large"></asp:TextBox>
        <asp:RequiredFieldValidator ID="TelephoneRequired" runat="server" Text="*"
            ErrorMessage="Telephone number is required." ControlToValidate="Telephone"
            EnableViewState="False" SetFocusOnError="false" Display="Dynamic"></asp:RequiredFieldValidator>
    </div>
    <div>
        <span class="label">Fax</span>
        <asp:TextBox ID="Fax" runat="server" CssClass="large"></asp:TextBox>
    </div>
    <div class="clear">
        <span class="label">Type:</span>
        <asp:DropDownList ID="Residence" runat="server" CssClass="large">
            <asp:ListItem Text="This is a residence" Value="1" Selected="true"></asp:ListItem>
            <asp:ListItem Text="This is a business" Value="0"></asp:ListItem>
        </asp:DropDownList>
    </div>
    <asp:PlaceHolder ID="ButtonPlaceHolder" runat="server">
        <br />
        <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
        <asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" CausesValidation="false" />
    </asp:PlaceHolder>
    <asp:HiddenField runat="server" ID="HiddenAddressId" /> 
</div>
