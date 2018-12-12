<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LoginDialog.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.LoginDialog" %>
<%--
<UserControls>
<summary>Displays a standard login dialog that includes support for recovering forgotten passwords.</summary>
<param name="EnableAdminRememberMe" default="true">Set to <b>true</b> or <b>false</b>.  Indicates whether the remember me option is available to admin users.</param>
</UserControls>
--%>
<div class="widget loginWidget">
    <asp:UpdatePanel ID="LoginAjax" runat="server">
        <ContentTemplate>		
            <asp:Panel ID="LoginPanel" runat="server" DefaultButton="LoginButton">
                <div class="content nofooter">
				    <div class="dialogSection">
                    <div class="inputForm">
                         <div class="field">
                             <span class="fieldValue">
                                  <asp:Label ID="InstructionText" runat="server" CssClass="fieldHeader" Text="" EnableViewState="False"></asp:Label>
                            </span>
                        </div>
                        <div class="validationSummary">
                                <asp:ValidationSummary ID="LoginValidationSummary" runat="server" ValidationGroup="Login" EnableViewState="False" />
                        </div>
                        <div class="field">
                                <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" CssClass="fieldHeader" Text="Email Address:" EnableViewState="False"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="UserName" runat="server" Columns="30" CssClass="txt" 
                                    TabIndex="1"></asp:TextBox><span class="requiredField">(R)</span>   
                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                    ErrorMessage="You must provide a user name." ToolTip="You must provide a user name."
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
                        <div class="field" id="trRememberMe" runat="server">                            
                           <asp:CheckBox ID="RememberUserName" runat="server" CssClass="fieldHeader" Text="Remember Me" TabIndex="2" />
                        </div>
                        <div class="field">
                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" CssClass="fieldHeader" Text="Password:" EnableViewState="False"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="Password" runat="server" TextMode="Password" Columns="30" 
                                    EnableViewState="False" TabIndex="3"></asp:TextBox><span class="requiredField">(R)</span>
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
                                <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Sign In" 
                                    ValidationGroup="Login" OnClick="LoginButton_Click" UseSubmitBehavior="false" 
                                    EnableViewState="false" TabIndex="5" />
                        </div>
                         <div class="buttons">
                                <asp:LinkButton ID="ForgotPasswordButton" runat="server" 
                                    Text="Forgot User Name or Password?" CausesValidation="false" 
                                    OnClick="ForgotPasswordButton_Click" EnableViewState="False" TabIndex="7" CssClass="link"></asp:LinkButton>
                         </div>
                        </div>
				    </div>
			    </div>
            </asp:Panel>
            <asp:Panel ID="ForgotPasswordPanel" runat="server" DefaultButton="ForgotPasswordNextButton">
                    <div class="field">
                    <span class="fieldHeader">
                      <asp:Localize ID="ForgotPasswordCaption" runat="server" Text="Forgot Password" EnableViewState="false"></asp:Localize>
                    </span>
                    </div>
                </div>
                <div class="content nofooter">
				    <div class="dialogSection">
                     <div class="inputForm">
                        <div class="field">
                            <asp:Label ID="ForgotPasswordHelpText" runat="server" CssClass="fieldHeader" EnableViewState="False" Text="Enter your registered email address for user name or password assistance."></asp:Label>
                        </div>
                        <div class="validationSummary">        
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ForgotPassword" EnableViewState="false" />
                        </div>
                        <div class="field">
                            <asp:Label ID="ForgotPasswordUserNameLabel" runat="server" CssClass="fieldHeader" AssociatedControlID="ForgotPasswordUserName" Text="Email:" EnableViewState="false"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="ForgotPasswordUserName" runat="server" Columns="30" EnableViewState="false"></asp:TextBox><span class="requiredField">(R)</span>
                                <asp:RequiredFieldValidator ID="ForgotPasswordUserNameRequired" runat="server" ControlToValidate="ForgotPasswordUserName"
                                    ErrorMessage="Email address is required" ToolTip="Email address is required" 
                                    ValidationGroup="ForgotPassword" Display="Dynamic" Text="*" EnableViewState="false"></asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="ForgotPasswordUserNameValidator" runat="server" ControlToValidate="ForgotPasswordUserName"
                                    ErrorMessage="The given email address is not registered." ToolTip="The given email address is not registered."
                                    Display="Dynamic" ValidationGroup="ForgotPassword" Text="*" EnableViewState="false"></asp:CustomValidator>
                                <asp:CustomValidator ID="DisabledUsernameValidator" runat="server" ControlToValidate="ForgotPasswordUserName"
                                    ErrorMessage="The account associated with this address has been disabled." ToolTip="The account associated with this address has been disabled."
                                    Display="Dynamic" ValidationGroup="ForgotPassword" Text="*" EnableViewState="false"></asp:CustomValidator>
                            </span>
                        </div>
                        <div class="buttons">
                                <asp:Button ID="ForgotPasswordCancelButton" runat="server" Text="Cancel" CausesValidation="False" OnClick="ForgotPasswordCancelButton_Click" EnableViewState="false" />
                                <asp:Button ID="ForgotPasswordNextButton" runat="server" Text="Next >" ValidationGroup="ForgotPassword" OnClick="ForgotPasswordNextButton_Click" EnableViewState="false" /> 
                        </div>
				    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="EmailSentPanel" runat="server">
                <div class="field">
                    <span class="fieldHeader">
                     <asp:Localize ID="EmailSentCaption" runat="server" Text="Check Your Email" EnableViewState="false"></asp:Localize>
                     </span>
                </div>
                <div class="field">
					    <asp:Label ID="EmailSentHelpText" runat="server"  CssClass="fieldHeader" Text="We have sent an email to '{0}'. Please check your email to get the user name or follow the link it contains to create a new password." EnableViewState="false"></asp:Label>
				 </div>
				    <div class="buttons">
					    <asp:Button ID="KeepShoppingButton" runat="server" Text="Keep Shopping" OnClick="KeepShoppingButton_Click" EnableViewState="false" />
				    </div>				
                </div>
            </asp:Panel>
            <asp:Panel ID="PasswordExpiredPanel" runat="server" DefaultButton="ChangePasswordButton">
                <div class="field">
                    <span class="fieldHeader">
                      <asp:Localize ID="PasswordExpiredCaption" runat="server" Text="Password Expired" EnableViewState="false"></asp:Localize>
                    </span>
                </div>
                <div class="content nofooter">
				    <div class="dialogSection">
                    <div class="inputForm">
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
                        <div class="field">
                                <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword" CssClass="fieldHeader" Text="New Password" EnableViewState="false"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="NewPassword" runat="server" Font-Size="0.8em" TextMode="Password" EnableViewState="false"></asp:TextBox><span class="requiredField">(R)</span>
                                <asp:PlaceHolder ID="phNewPasswordValidators" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" ControlToValidate="NewPassword"
                                    ErrorMessage="New password is required." ToolTip="New Password is required."
                                    Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:RequiredFieldValidator>
                        </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="ConfirmNewPasswordLabel" runat="server" CssClass="fieldHeader" AssociatedControlID="ConfirmNewPassword" Text="Retype:" EnableViewState="false"></asp:Label></td>
                            <span class="fieldValue">
                                <asp:TextBox ID="ConfirmNewPassword" runat="server" Font-Size="0.8em" TextMode="Password" EnableViewState="false"></asp:TextBox><span class="requiredField">(R)</span>
                                <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword"
                                    ErrorMessage="Confirm New Password is required." ToolTip="Confirm New Password is required."
                                    Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword"
                                    ControlToValidate="ConfirmNewPassword" Display="Dynamic" ErrorMessage="You did not retype the new password correctly."
                                    Text="*" ValidationGroup="PasswordExpired" EnableViewState="false"></asp:CompareValidator>
                           </span>
                        </div>
                        <div class="buttons">
                            <asp:Button ID="ChangePasswordButton" runat="server" Text="Continue >" EnableViewState="false" ValidationGroup="PasswordExpired" OnClick="ChangePasswordButton_Click" />
                        </div>
                    </div>
				    </div>
                </div>
            </asp:Panel>
            <asp:HiddenField ID="VS" runat="server" EnableViewState="false" />
        </ContentTemplate>
    </asp:UpdatePanel>
</div>