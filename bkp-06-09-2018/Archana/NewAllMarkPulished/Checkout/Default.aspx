<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Layouts/Fixed/Checkout.master" AutoEventWireup="True" CodeFile="Default.aspx.cs" Inherits="AbleCommerce.Checkout.Default" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" runat="server">
<div id="checkoutPage"> 
    <div id="checkout_startPage" class="mainContentWrapper"> 
        <div class="column_1 halfColumn">
            <div class="widget registerWidget">
                <div class="innerSection">
		            <div class="header">
			            <h2>New Customers</h2>
		            </div>
		            <div class="content">
			            <p>If you are a new customer, please create an account and checkout.  This will allow you to re-access your order history and track this purchase.</p>
			            <asp:HyperLink ID="CreateAccountAndCheckoutButton" runat="server" Text="Create Account and Checkout" CssClass="button" NavigateUrl="~/Checkout/EditBillAddress.aspx" />
			            <asp:PlaceHolder ID="GuestCheckoutPanel" runat="server" Visible="false">
				            <p class="topMargin">If you prefer, you may use the guest checkout option to place an order without creating an account.</p>
				            <asp:HyperLink ID="GuestCheckoutButton" runat="server" Text="Guest Checkout" CssClass="button" NavigateUrl="~/Checkout/EditBillAddress.aspx?GC=0" />
			            </asp:PlaceHolder>
		            </div>
                </div>
	        </div>
        </div>
        <div class="column_2 halfColumn">
	        <div class="widget loginWidget">
                <div class="innerSection">
		            <div class="header">
			            <h2>Existing Customers</h2>
		            </div>
		            <div class="content"> 			
                        <asp:UpdatePanel ID="CaptchaAjax" UpdateMode="Conditional" runat="server">
                            <ContentTemplate>
		                        <asp:Panel ID="LoginPanel" runat="server" DefaultButton="LoginButton" CssClass="dialogSection">
                                    <asp:ValidationSummary ID="LoginValidationSummary" runat="server" ValidationGroup="Login" EnableViewState="False" />
                                    <table class="inputForm">
                                        <tr>
                                            <th class="rowHeader">
                                                <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Text="Email:" EnableViewState="False"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:TextBox ID="UserName" runat="server" CssClass="txt" SkinID="Email"></asp:TextBox>   
                                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                    ErrorMessage="You must provide your email address." ToolTip="You must provide a user name."
                                                    ValidationGroup="Login" Text="*"></asp:RequiredFieldValidator>                         
                                                <asp:CustomValidator ID="InvalidLogin" runat="server" ControlToValidate="UserName"
                                                    ErrorMessage="The sign in information you provided was incorrect." ToolTip="The sign in information you provided was incorrect."
                                                    Display="Dynamic" ValidationGroup="Login" Text="*" EnableViewState="false"></asp:CustomValidator>
                                                <asp:CustomValidator ID="AccountDisabled" runat="server" ControlToValidate="UserName"
                                                    ErrorMessage="This account has been disabled." ToolTip="This account has been disabled."
                                                    Display="Dynamic" ValidationGroup="Login" Text="*" EnableViewState="false"></asp:CustomValidator>
                                                <asp:CustomValidator ID="AccountLocked" runat="server" ControlToValidate="UserName"
                                                    ErrorMessage="This account has been locked for {0} minutes." ToolTip="This account has been locked."
                                                    Display="Dynamic" ValidationGroup="Login" Text="*" EnableViewState="false"></asp:CustomValidator>
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>
                                                <asp:CheckBox ID="RememberUserName" runat="server" Text="Remember Me" />
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <th class="rowHeader">
                                                <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Text="Password:" EnableViewState="False"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:TextBox ID="Password" runat="server" TextMode="Password" Width="80px" 
                                                    EnableViewState="False"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                    ErrorMessage="You must provide a password." ToolTip="You must provide a password."
                                                    ValidationGroup="Login" Text="*" EnableViewState="False"></asp:RequiredFieldValidator>
                                                <asp:LinkButton ID="ForgotPasswordButton" runat="server" 
                                                    Text="Recover your password" CausesValidation="false" 
                                                    OnClick="ForgotPasswordButton_Click" EnableViewState="False" CssClass="link" Width="150px"></asp:LinkButton>
                                            </td>
                                        </tr>
                                        <tr ID="trCaptchaField" runat="server" Visible="false">
                                            <th class="rowHeader">
                                                <asp:Label ID="CaptchaInputLabel" runat="server" EnableViewState="false" Text="Verification Number:"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:TextBox ID="CaptchaInput" runat="server" Width="80px" 
                                                    EnableViewState="False"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="CaptchaRequired" runat="server" ControlToValidate="CaptchaInput"
                                                    ErrorMessage="You must enter the number in the image." ToolTip="You must enter the number in the image."
                                                    Display="Dynamic" ValidationGroup="Login" Text="*" EnableViewState="False"></asp:RequiredFieldValidator>
                                                <asp:PlaceHolder ID="phCaptchaValidators" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                            </td>
                                        </tr>
                                        <tr ID="trCaptchaImage" runat="server" Visible="false">
                                            <td>&nbsp;</td>
                                            <td>
                                                <cb:CaptchaImage ID="CaptchaImage" runat="server" Height="60px" Width="200px" EnableViewState="False" />
                                            <br />
                                                <asp:LinkButton ID="ChangeImageLink" runat="server" Text="show a different image" CausesValidation="false" OnClick="ChangeImageLink_Click" EnableViewState="False" CssClass="link"></asp:LinkButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>
                                                <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Login and Checkout" 
                                                    ValidationGroup="Login" OnClick="LoginButton_Click" EnableViewState="false" CssClass="button"/>
                                            </td>
                                        </tr>
                                    </table>
	                            </asp:Panel>
		                        <asp:Panel ID="ForgotPasswordPanel" runat="server" DefaultButton="ForgotPasswordNextButton" CssClass="dialogSection">
                                    <p><asp:Label ID="ForgotPasswordHelpText" runat="server" EnableViewState="False" Text="Enter your email address for password assistance."></asp:Label></p>
                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ForgotPassword" EnableViewState="false" />
                                    <table cellspacing="0" class="inputForm compact">
                                        <tr>
                                            <th class="rowHeader">
                                                <asp:Label ID="ForgotPasswordUserNameLabel" runat="server" AssociatedControlID="ForgotPasswordUserName" Text="Email:" EnableViewState="false"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:TextBox ID="ForgotPasswordUserName" runat="server" Columns="30" EnableViewState="false"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="ForgotPasswordUserNameRequired" runat="server" ControlToValidate="ForgotPasswordUserName"
                                                    ErrorMessage="Email address is required" ToolTip="Email address is required" 
                                                    ValidationGroup="ForgotPassword" Display="Dynamic" Text="*" EnableViewState="false"></asp:RequiredFieldValidator>
                                                <asp:CustomValidator ID="ForgotPasswordUserNameValidator" runat="server" ControlToValidate="ForgotPasswordUserName"
                                                    ErrorMessage="The given email address is not registered." ToolTip="The given email address is not registered."
                                                    Display="Dynamic" ValidationGroup="ForgotPassword" Text="*" EnableViewState="false"></asp:CustomValidator>
                                                <asp:CustomValidator ID="DisabledUsernameValidator" runat="server" ControlToValidate="ForgotPasswordUserName"
                                                    ErrorMessage="The account associated with this address has been disabled." ToolTip="The account associated with this address has been disabled."
                                                    Display="Dynamic" ValidationGroup="ForgotPassword" Text="*" EnableViewState="false"></asp:CustomValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>
                                                <asp:Button ID="ForgotPasswordNextButton" runat="server" Text="Next" ValidationGroup="ForgotPassword" OnClick="ForgotPasswordNextButton_Click" EnableViewState="false" /> 
                                                <asp:Button ID="ForgotPasswordCancelButton" runat="server" Text="Cancel" CausesValidation="False" OnClick="ForgotPasswordCancelButton_Click" EnableViewState="false" />
                                            </td>
                                        </tr>
                                    </table>
	                            </asp:Panel>
		                        <asp:Panel ID="EmailSentPanel" runat="server" CssClass="innerSection">
				                    <div class="info">
                                        <p><asp:Label ID="EmailSentHelpText" runat="server" Text="We have sent an email to '{0}'. Please check your email to get the user name or follow the link it contains to create a new password." EnableViewState="false"></asp:Label></p>
                                    </div>
				                    <div class="actions">
                                         <asp:Button ID="TryAgainButton" runat="server" Text="Try Again" OnClick="TryAgainButton_Click" EnableViewState="false" />
				                    </div>
	                            </asp:Panel>
		                        <asp:Panel ID="PasswordExpiredPanel" runat="server" DefaultButton="ChangePasswordButton" CssClass="dialogSection">
                                    <p><asp:Localize ID="PasswordExpiredInstructionText" runat="server" Text="You must provide a new password to continue and the new password must meet the following minimum requirements:" EnableViewState="false"></asp:Localize></p>
                                    <ul>
                                        <li runat="server" id="ppLength">
                                            <asp:Localize ID="PasswordPolicyLength" runat="server" Text="  The new password must be at least {0} characters long." EnableViewState="false"></asp:Localize>
                                        </li>
                                        <li runat="server" id="ppHistoryCount">
                                            <asp:Localize ID="PasswordPolicyHistoryCount" runat="server" Text="  You may not use any of your previous {0} passwords." EnableViewState="false"></asp:Localize>
                                        </li>
                                        <li runat="server" id="ppHistoryDays">
                                            <asp:Localize ID="PasswordPolicyHistoryDays" runat="server" Text="  You may not reuse any passwords used within the last {0} days." EnableViewState="false"></asp:Localize>
                                        </li>
                                        <li runat="server" id="ppPolicyRequired">
                                            <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="  The password must include at least one {0}." EnableViewState="false"></asp:Localize>
                                        </li>
                                    </ul>
                                    <asp:ValidationSummary ID="PasswordExpiredValidationSummary" runat="server" ValidationGroup="PasswordExpired" EnableViewState="false" />
				                    <table cellspacing="0" class="inputForm compact">
                                        <tr>
                                            <th class="rowheader">
                                                <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword" Text="New Password" EnableViewState="false"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:TextBox ID="NewPassword" runat="server" Font-Size="0.8em" TextMode="Password" EnableViewState="false"></asp:TextBox>
                                                <asp:PlaceHolder ID="phNewPasswordValidators" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                                <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword"
                                                    ErrorMessage="You must choose a new password." ToolTip="New Password is required."
                                                    Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="rowheader">
                                                <asp:Label ID="ConfirmNewPasswordLabel" runat="server" AssociatedControlID="ConfirmNewPassword" Text="Retype:" EnableViewState="false"></asp:Label>
                                            <td>
                                                <asp:TextBox ID="ConfirmNewPassword" runat="server" Font-Size="0.8em" TextMode="Password" EnableViewState="false"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword"
                                                    ErrorMessage="You must retype the password." ToolTip="Confirm New Password is required."
                                                    Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword"
                                                    ControlToValidate="ConfirmNewPassword" Display="Dynamic" ErrorMessage="You did not retype the new password correctly."
                                                    Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:CompareValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>
                                                <asp:Button ID="ChangePasswordButton" runat="server" Text="Continue" EnableViewState="false" ValidationGroup="PasswordExpired" OnClick="ChangePasswordButton_Click" />
                                            </td>
                                        </tr>
                                    </table>
	                            </asp:Panel>
    		                    <asp:HiddenField ID="VS" runat="server" EnableViewState="false" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>
