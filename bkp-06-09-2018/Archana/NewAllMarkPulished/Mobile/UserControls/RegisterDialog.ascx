<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegisterDialog.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.RegisterDialog" %>
<%--
<UserControls>
<summary>Display a form using that a new customer can register for a new account.</summary>
</UserControls>
--%>
<div class="widget registerDialog">
<asp:Panel ID="RegisterPanel" runat="server" DefaultButton="RegisterButton">
    <div class="content nofooter">
		<div class="dialogSection">
        <div class="inputForm">
         <div class="validationSummary">
            <asp:ValidationSummary ID="RegisterValidationSummary" runat="server" ValidationGroup="Register" />
         </div>
        <div class="field">
          <span class="fieldHeader">
            <asp:Localize ID="InstructionText" runat="server" Text="If you are a new customer, take a moment to register below." EnableViewState="False"></asp:Localize>
         </span>
        </div>
        <div class="field">
            <asp:Label ID="FailureText" runat="server" EnableViewState="False" CssClass="fieldHeader"></asp:Label>
        </div>
        <div class="field">
          <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" CssClass="fieldHeader" Text="Email:<span style='font-size:smaller;'>(username)</span>"></asp:Label>
          <span class="fieldValue">
            <asp:TextBox ID="UserName" runat="server" Columns="30" TabIndex="8"></asp:TextBox><span class="requiredField">(R)</span>
          <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="UserName" 
                ValidationGroup="Register" Display="Dynamic" Required="true" 
                ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>
            <asp:CustomValidator ID="InvalidRegistration" runat="server" ControlToValidate="UserName"
                ErrorMessage="Registration was not successful." ToolTip="Registration was not successful."
                Display="Dynamic" ValidationGroup="Register" Text="*"></asp:CustomValidator>
            <asp:CustomValidator ID="DuplicateEmailValidator" runat="server" ControlToValidate="UserName" ValidationGroup="Register" Display="Dynamic"
                Text="*" ErrorMessage="This email address is already associated with an existing user account.  Use the 'Forgot User Name or Password' feature if you need to retrieve your login information, or use a different email address to register." />
          </span>
        </div>
            <div class="field" id="trRememberMe" runat="server">
               <asp:CheckBox ID="RememberUserName" runat="server" CssClass="fieldHeader" Text="Remember Me" TabIndex="9" />                
           </div>
           <div class="field">
             <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" CssClass="fieldHeader" Text="Password:"></asp:Label>
             <span class="fieldValue">
                <asp:TextBox ID="Password" runat="server" TextMode="Password" Columns="30" 
                        MaxLength="24" TabIndex="10"></asp:TextBox><span class="requiredField">(R)</span>
                  <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                            ErrorMessage="You must provide a password" ToolTip="You must provide a password"
                            ValidationGroup="Register" Text="*"></asp:RequiredFieldValidator>
                  <asp:PlaceHolder ID="PasswordValidatorPanel" runat="server" EnableViewState="false"></asp:PlaceHolder>
             </span>
           </div>
            <div class="field">
               <span class="fieldHeader">
                    <i><asp:Localize ID="PasswordPolicyLength" runat="server" Text="Your password must be at least {0} characters long."></asp:Localize>
                    <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="You must include at least one {0}."></asp:Localize></i>
               </span>
            </div>
            <div class="field">
                    <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword" CssClass="fieldHeader" Text="Re-enter:"></asp:Label>
                <span class="fieldValue">
                    <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" Columns="30" 
                        MaxLength="24" TabIndex="12"></asp:TextBox><span class="requiredField">(R)</span>
                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                        ErrorMessage="You must re-enter the password." ToolTip="You must re-enter the password."
                        ValidationGroup="Register" Text="*"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                        ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="You did not re-enter the password correctly."
                        ValidationGroup="Register" Text="*"></asp:CompareValidator>
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
                    <asp:Button ID="RegisterButton" runat="server" Text="Register" 
                        OnClick="RegisterButton_Click" ValidationGroup="Register" TabIndex="13" />
             </div>
             </div>   
		</div>
    </div>
</asp:Panel>
</div>