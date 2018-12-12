<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="True" CodeFile="Default.aspx.cs" Inherits="AbleCommerce.Mobile.Checkout.Default" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" runat="server">
<div id="checkoutPage"> 
    <div id="checkout_startPage" class="mainContentWrapper"> 
        <div class="widget registerWidget">
            <div class="section">
		        <div class="header">
			        <h2>New Customer?</h2>
		        </div>
		        <div class="content">			            
			        <asp:HyperLink ID="CreateAccountAndCheckoutButton" runat="server" Text="Create Account and Checkout" CssClass="button" NavigateUrl="#" />
			        <asp:PlaceHolder ID="GuestCheckoutPanel" runat="server" Visible="false">
				        <p>OR</p>
				        <asp:HyperLink ID="GuestCheckoutButton" runat="server" Text="Proceed with Guest Checkout" CssClass="button" NavigateUrl="#" />
			        </asp:PlaceHolder>
		        </div>
            </div>
	    </div>
        
        
	    <div class="widget loginWidget">
            <div class="section">
		        <div class="header">
			        <h2>Existing Customer - Sign In</h2>
		        </div>
		        <div class="content">
                <div class="inputForm"> 			
                    <asp:UpdatePanel ID="CaptchaAjax" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
		                    <asp:Panel ID="LoginPanel" runat="server" DefaultButton="LoginButton" CssClass="dialogSection">
                                <div class="validationSummary">
                                    <asp:ValidationSummary ID="LoginValidationSummary" runat="server" ValidationGroup="Login" EnableViewState="False" />
                                </div>
                                <div class="field">
                                    <asp:Label ID="UserNameLabel" runat="server" CssClass="fieldHeader" AssociatedControlID="UserName" Text="Email:" EnableViewState="False"></asp:Label>
                                    <span class="fieldValue">
                                            <asp:TextBox ID="UserName" runat="server" Columns="30" CssClass="txt"></asp:TextBox><span class="requiredField">(R)</span>   
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
                                    </span>
                                </div>
                                <div class="field">
                                    <asp:CheckBox ID="RememberUserName" runat="server" Text="Remember Me" CssClass="fieldHeader" />
                                </div>
                                <div class="field">
                                    <asp:Label ID="PasswordLabel" runat="server" CssClass="fieldHeader" AssociatedControlID="Password" Text="Password:" EnableViewState="False"></asp:Label>
                                <span class="fieldValue">
                                    <asp:TextBox ID="Password" runat="server" TextMode="Password" EnableViewState="False" CssClass="password"></asp:TextBox><span class="requiredField">(R)</span>
                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                        ErrorMessage="You must provide a password." ToolTip="You must provide a password."
                                        ValidationGroup="Login" Text="*" EnableViewState="False"></asp:RequiredFieldValidator>
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
                                <div class="buttons">
                                    <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Login and Checkout" ValidationGroup="Login" OnClick="LoginButton_Click" EnableViewState="false" CssClass="button"/>
                                </div>
	                        </asp:Panel>
                            <%-- 
                            <div class="buttons">
                                <asp:LinkButton ID="ForgotPasswordButton" runat="server" 
                                    Text="Recover your password" CausesValidation="false" 
                                    OnClick="ForgotPasswordButton_Click" EnableViewState="False"></asp:LinkButton>
                            </div>
                            --%>

                            
		                    <asp:Panel ID="PasswordExpiredPanel" runat="server" DefaultButton="ChangePasswordButton" CssClass="dialogSection">
                                <div class="field">
                                <span class="fieldHeader">
                                    <asp:Localize ID="PasswordExpiredInstructionText" runat="server" Text="You must provide a new password to continue and the new password must meet the following minimum requirements:" EnableViewState="false"></asp:Localize>
                                </span>
                                <span class="fieldValue">
                                    <ul>
                                        <li runat="server" id="ppLength">
                                            <span class="fieldHeader">
                                                <asp:Localize ID="PasswordPolicyLength" runat="server" Text="  The new password must be at least {0} characters long." EnableViewState="false"></asp:Localize>
                                            </span>
                                        </li>
                                        <li runat="server" id="ppHistoryCount">
                                            <span class="fieldHeader">
                                                <asp:Localize ID="PasswordPolicyHistoryCount" runat="server" Text="  You may not use any of your previous {0} passwords." EnableViewState="false"></asp:Localize>
                                            </span>
                                        </li>
                                        <li runat="server" id="ppHistoryDays">
                                            <span class="fieldHeader">
                                                <asp:Localize ID="PasswordPolicyHistoryDays" runat="server" Text="  You may not reuse any passwords used within the last {0} days." EnableViewState="false"></asp:Localize>
                                            </span>
                                        </li>
                                        <li runat="server" id="ppPolicyRequired">
                                            <span class="fieldHeader">
                                                <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="  The password must include at least one {0}." EnableViewState="false"></asp:Localize>
                                            </span>
                                        </li>
                                    </ul>
                                </span>
                                </div>
                                <div class="validationSummary">
                                <asp:ValidationSummary ID="PasswordExpiredValidationSummary" runat="server" ValidationGroup="PasswordExpired" EnableViewState="false" />
				                </div> 
                                <div class="inputForm">
                                    <div class="field">
                                        <asp:Label ID="NewPasswordLabel" runat="server" CssClass="fieldHeader" AssociatedControlID="NewPassword" Text="New Password" EnableViewState="false"></asp:Label>
                                        <span class="fieldValue">
                                        <asp:TextBox ID="NewPassword" runat="server" Font-Size="0.8em" TextMode="Password" EnableViewState="false"></asp:TextBox><span class="requiredField">(R)</span>
                                        <asp:PlaceHolder ID="phNewPasswordValidators" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                        <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword"
                                            ErrorMessage="You must choose a new password." ToolTip="New Password is required."
                                            Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:RequiredFieldValidator>
                                        </span>
                                    </div>
                                    <div class="field">
                                        <asp:Label ID="ConfirmNewPasswordLabel" runat="server" AssociatedControlID="ConfirmNewPassword" Text="Retype:" EnableViewState="false"></asp:Label>
                                        <span class="fieldValue">
                                            <asp:TextBox ID="ConfirmNewPassword" runat="server" Font-Size="0.8em" TextMode="Password" EnableViewState="false"></asp:TextBox><span class="requiredField">(R)</span>
                                            <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword"
                                                ErrorMessage="You must retype the password." ToolTip="Confirm New Password is required."
                                                Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:RequiredFieldValidator>
                                            <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword"
                                                ControlToValidate="ConfirmNewPassword" Display="Dynamic" ErrorMessage="You did not retype the new password correctly."
                                                Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:CompareValidator>
                                        </span>
                                    </div>
                                    <div class="buttons">
                                            <asp:Button ID="ChangePasswordButton" runat="server" Text="Continue" EnableViewState="false" ValidationGroup="PasswordExpired" OnClick="ChangePasswordButton_Click" />
                                    </div>
                                </div>
	                        </asp:Panel>
                            <span class="fieldValue"> 
    		                    <asp:HiddenField ID="VS" runat="server" EnableViewState="false" />
                            </span>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
        
    </div>
</div>
</asp:Content>