<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="PasswordHelp.aspx.cs" Inherits="AbleCommerce.Mobile.PasswordHelp" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="passwordHelpPage" class="mainContentWrapper">
	<div class="section">
		<div class="header">
			<h2>Password Assistance</h2>
		</div>
		<div class="content">
			<div class="info">
				<span class="message">Your identity has been verified.  Please set a new password now.</span>
			</div>
			<div class="dialogSection">
				<div class="inputForm">
					<div class="field">
                        <span class="fieldHeader">
							<asp:Localize ID="PasswordPolicyLength" runat="server" Text="The new password must be at least {0} characters long.<br/>"></asp:Localize>
						</span>
                        <span class="fieldHeader">	
                            <asp:Localize ID="PasswordPolicyHistoryCount" runat="server" Text="  You may not use any of your previous {0} passwords.<br/>"></asp:Localize>
						</span>
                        <span class="fieldHeader">	
                            <asp:Localize ID="PasswordPolicyHistoryDays" runat="server" Text="  You may not reuse any passwords used within the last {0} days.<br/>"></asp:Localize>
						</span>
                        <span class="fieldHeader">	
                            <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="  The password must include at least one {0}."></asp:Localize>
						</span>
					</div>
					<div class="field">
							<asp:Label ID="UserNameLabel" runat="server" Text="User Name:" CssClass="fieldHeader"></asp:Label>
						<span class="fieldValue">
							<asp:Label ID="UserName" runat="server" Text=""></asp:Label>
						</span>
					</div>
					<div class="validationSummary">
						<asp:ValidationSummary ID="ValidationSummary1" runat="server" />
				    </div>
					<div class="field">
							<asp:Label ID="PasswordLabel" runat="server" Text="New Password:" CssClass="fieldHeader"></asp:Label>
                       <span class="fieldValue">
							<asp:TextBox ID="Password" runat="server" TextMode="password"></asp:TextBox><span class="requiredField">(R)</span>                
							<asp:RequiredFieldValidator ID="PasswordValidator1" runat="server" ControlToValidate="Password"
								Display="Static" ErrorMessage="Password is required." Text="*"></asp:RequiredFieldValidator>
							<asp:PlaceHolder ID="phNewPasswordValidators" runat="server"></asp:PlaceHolder>                    
						</span>
					</div>
					<div class="field">
							<asp:Label ID="ConfirmPasswordLabel" runat="server" Text="Confirm Password:" CssClass="fieldHeader"></asp:Label>
						<span class="fieldValue">
							<asp:TextBox ID="ConfirmPassword" runat="server" TextMode="password"></asp:TextBox><span class="requiredField">(R)</span> 
							<asp:RequiredFieldValidator ID="ConfirmPasswordValidator1" runat="server" ControlToValidate="ConfirmPassword"
								Display="Static" ErrorMessage="You must retype your password." Text="*"></asp:RequiredFieldValidator>
							<asp:CompareValidator ID="ConfirmPasswordValidator2" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" 
								Display="Static" ErrorMessage="You did not retype your new password correctly." Text="*"></asp:CompareValidator>                
						</span>
					</div>
					<div class="buttons">
							<asp:LinkButton ID="SubmitButton" runat="server" Text="Continue" OnClick="SubmitButton_Click" CssClass="button"></asp:LinkButton>
				    </div>
				</div>
			</div>
		</div>
	</div>
</div>
</asp:Content>
