<%@ Page Title="Password Assistance" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="true" CodeFile="PasswordHelp.aspx.cs" Inherits="AbleCommerce.PasswordHelp" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="passwordHelpPage" class="mainContentWrapper">
	<div class="section">
		<div class="pageHeader">
			<h1>Password Assistance</h1>
		</div>
		<div class="content">
			<div class="info">
				<span class="message">Your identity has been verified.  Please set a new password now.</span>
			</div>
			<div class="dialogSection">
				<table class="inputForm">
					<tr>
						<td align="left" colspan="3">
							<asp:Localize ID="PasswordPolicyLength" runat="server" Text="The new password must be at least {0} characters long.<br/>"></asp:Localize>
							<asp:Localize ID="PasswordPolicyHistoryCount" runat="server" Text="  You may not use any of your previous {0} passwords.<br/>"></asp:Localize>
							<asp:Localize ID="PasswordPolicyHistoryDays" runat="server" Text="  You may not reuse any passwords used within the last {0} days.<br/>"></asp:Localize>
							<asp:Localize ID="PasswordPolicyRequired" runat="server" Text="  The password must include at least one {0}."></asp:Localize>
						</td>
					</tr>
					<tr>
						<th class="rowHeader">
							<asp:Label ID="UserNameLabel" runat="server" Text="User Name:" CssClass="fieldHeader"></asp:Label>
						</th>
						<td nowrap>
							<asp:Label ID="UserName" runat="server" Text=""></asp:Label>
						</td>
						<td rowspan="4" valign="top">
					   
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<asp:ValidationSummary ID="ValidationSummary1" runat="server" />
						</td>
					</tr>
					<tr>
						<th class="rowHeader">
							<asp:Label ID="PasswordLabel" runat="server" Text="New Password:" CssClass="fieldHeader"></asp:Label>
						</th>
						<td>
							<asp:TextBox ID="Password" runat="server" TextMode="password"></asp:TextBox>                
							<asp:RequiredFieldValidator ID="PasswordValidator1" runat="server" ControlToValidate="Password"
								Display="Static" ErrorMessage="Password is required." Text="*"></asp:RequiredFieldValidator>
							<asp:PlaceHolder ID="phNewPasswordValidators" runat="server"></asp:PlaceHolder>                    
						</td>
					</tr>
					<tr>
						<th class="rowHeader" nowrap>
							<asp:Label ID="ConfirmPasswordLabel" runat="server" Text="Confirm Password:" CssClass="fieldHeader"></asp:Label>
						</th>
						<td>
							<asp:TextBox ID="ConfirmPassword" runat="server" TextMode="password"></asp:TextBox>
							<asp:RequiredFieldValidator ID="ConfirmPasswordValidator1" runat="server" ControlToValidate="ConfirmPassword"
								Display="Static" ErrorMessage="You must retype your password." Text="*"></asp:RequiredFieldValidator>
							<asp:CompareValidator ID="ConfirmPasswordValidator2" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" 
								Display="Static" ErrorMessage="You did not retype your new password correctly." Text="*"></asp:CompareValidator>                
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<asp:LinkButton ID="SubmitButton" runat="server" Text="Continue" OnClick="SubmitButton_Click" CssClass="button linkButton"></asp:LinkButton>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
</asp:Content>
