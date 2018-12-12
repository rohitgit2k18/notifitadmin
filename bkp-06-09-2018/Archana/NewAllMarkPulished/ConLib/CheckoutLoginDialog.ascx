<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.CheckoutLoginDialog" CodeFile="CheckoutLoginDialog.ascx.cs" %>

<%--
<conlib>
<summary>A login dialog which is used on the checkout page while an anonymous user is checking out.</summary>
</conlib>
--%>
<asp:UpdatePanel ID="LoginAjax" runat="server">
    <ContentTemplate>
        <div class="widget checkoutLoginDialog">
            <asp:Panel ID="LoginPanel" runat="server" CssClass="innerSection">
            <div class="header">
	            <h2><asp:Localize ID="Caption" runat="server" Text="Returning Customers"></asp:Localize></h2>
            </div>
            <div class="content nofooter">
				<div class="dialogSection">
                <table class="inputForm" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="InstructionText" runat="server" EnableViewState="False" Text="If you have already registered with <b>{0}</b>, please sign in now."></asp:Label>
                            <asp:ValidationSummary ID="LoginValidationSummary" runat="server" ValidationGroup="Login" />
                        </td>
                    </tr>
                    <tr>
                        <th class="rowHeader">
                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Text="Email:"></asp:Label>
                        </th>
                        <td align="left">
                            <asp:TextBox ID="UserName" runat="server" Columns="30"></asp:TextBox>
                            <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="UserName" ValidationGroup="Login" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" Display="Dynamic"></cb:EmailAddressValidator>                            
                            <asp:CustomValidator ID="InvalidLogin" runat="server" ControlToValidate="UserName"
                                ErrorMessage="The sign in information you provided was incorrect." ToolTip="The sign in information you provided was incorrect."
                                Display="Dynamic" ValidationGroup="Login" Text="*"></asp:CustomValidator>                            
                        </td>
                    </tr>
                    <tr>
                        <th class="rowHeader">
                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Text="Password:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Password" runat="server" TextMode="Password" Width="80px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                ErrorMessage="You must provide a password" ToolTip="You must provide a password"
                                ValidationGroup="Login" Text="*"></asp:RequiredFieldValidator>
                            <asp:LinkButton ID="ForgotPasswordButton" runat="server" Text="Forgot Password?" CausesValidation="false" OnClick="ForgotPasswordButton_Click"></asp:LinkButton>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td align="left">
                            <asp:CheckBox ID="RememberUserName" runat="server" Text="Remember Me" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Sign In" ValidationGroup="Login" OnClick="LoginButton_Click" /> 
                        </td>
                    </tr>
                </table>
				</div>
            </asp:Panel>
            <asp:Panel ID="ForgotPasswordPanel" runat="server" CssClass="innerSection">
                <div class="header">
	                <h2><asp:Localize ID="ForgotPasswordCaption" runat="server" Text="Forgot Password"></asp:Localize></h2>
                </div>
                <div class="content nofooter">
				<div class="dialogSection">
                <table class="inputForm" cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="ForgotPasswordHelpText" runat="server" EnableViewState="False" Text="Enter your registered email address for password assistance."></asp:Label>
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ForgotPassword" />
                        </td>
                    </tr>
                    <tr>
                        <th class="rowHeader">
                            <asp:Label ID="ForgotPasswordUserNameLabel" runat="server" AssociatedControlID="ForgotPasswordUserName" Text="Email:"></asp:Label>
                        </th>
                        <td align="left">
                            <asp:TextBox ID="ForgotPasswordUserName" runat="server" Columns="30"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="ForgotPasswordUserNameRequired" runat="server" ControlToValidate="ForgotPasswordUserName"
                                ErrorMessage="Email address is required" ToolTip="Email address is required" 
                                ValidationGroup="ForgotPassword" Display="Dynamic" Text="*"></asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="ForgotPasswordUserNameValidator" runat="server" ControlToValidate="ForgotPasswordUserName"
                                ErrorMessage="The given email address is not registered." ToolTip="The given email address is not registered."
                                Display="Dynamic" ValidationGroup="ForgotPassword" Text="*"></asp:CustomValidator>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <asp:Button ID="ForgotPasswordCancelButton" runat="server" Text="Cancel" CausesValidation="False" OnClick="ForgotPasswordCancelButton_Click" />
                            <asp:Button ID="ForgotPasswordNextButton" runat="server" Text="Next >" ValidationGroup="ForgotPassword" OnClick="ForgotPasswordNextButton_Click" /> 
                        </td>
                    </tr>
                </table>
                </div>
				</div>
            </asp:Panel>
            <asp:Panel ID="EmailSentPanel" runat="server" CssClass="innerSection">
                <div class="header">
	                <h2><asp:Localize ID="EmailSentCaption" runat="server" Text="Check Your Email"></asp:Localize></h2>
                </div>
                <div class="content nofooter">
					<div class="info">
						<div class="message">
							<asp:Label ID="EmailSentHelpText" runat="server" Text="We have sent an email to {0}.  Please check for the email and follow the link it contains to create your new password."></asp:Label>
						</div>
						<div class="actions">
						<asp:Button ID="KeepShoppingButton" runat="server" Text="Keep Shopping" OnClick="KeepShoppingButton_Click" />
						</div>
					</div>
                </div>
            </asp:Panel>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
