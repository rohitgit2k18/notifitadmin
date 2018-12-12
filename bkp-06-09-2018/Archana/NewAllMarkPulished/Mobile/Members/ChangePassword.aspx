<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="AbleCommerce.Mobile.Members.ChangePassword" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" runat="server">
<div id="accountPage"> 
    <div id="account_credentialsPage" class="mainContentWrapper">
		<div class="section">
         <div class="header">
		    <h2>Change Password</h2>
		</div>
			<div class="content">
                <asp:Panel ID="EditPanel" runat="server" CssClass="tabpane" DefaultButton="SaveButton">
                    <asp:UpdatePanel ID="AjaxPanel" runat="server">
                        <ContentTemplate>
							<p class="instruction">
								<asp:Localize ID="UpdateAccountText" runat="server" Text="You must provide your current password in order to save the changes."></asp:Localize>
								<asp:Localize ID="NewAccountText" runat="server" Text="Enter your email address and password below so that you may access your account in the future."></asp:Localize>
							</p>
                            <div class="inputForm">
                                 <div class="field" id="trCurrentPassword" runat="server">
                                        <asp:Label ID="CurrentPasswordLabel" runat="server" Text="Current Password:" CssClass="fieldHeader"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="CurrentPassword" runat="server" TextMode="password" Width="150px" MaxLength="30"></asp:TextBox><span class="requiredField">(R)</span>
                                        <asp:CustomValidator ID="InvalidPassword" runat="server" ControlToValidate="CurrentPassword"
                                            Display="Dynamic" ErrorMessage="The password you provided is incorrect." Text="*" ValidationGroup="EditProfile"></asp:CustomValidator>
                                        <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword"
                                            Display="Static" ErrorMessage="Current password is required to save your changes." Text="*" ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
                                    </span>
                                 </div>
                                 <ul>
                                    <asp:Localize ID="PasswordPolicyLength" runat="server" Text="<li>The new password must be at least {0} characters long.</li>"></asp:Localize>
                                    <asp:Localize ID="PasswordPolicyHistoryCount" runat="server" Text="<li>You may not use any of your previous {0} passwords.</li>"></asp:Localize>
                                    <asp:Localize ID="PasswordPolicyHistoryDays" runat="server" Text="<li>You may not reuse any passwords used within the last {0} days.</li>"></asp:Localize>
                                    <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="<li>The password must include at least one {0}.</li>"></asp:Localize>
                                </ul>
                                <div class="field">
                                        <asp:Label ID="PasswordLabel" runat="server" Text="New Password:" CssClass="fieldHeader"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="Password" runat="server" TextMode="password" Width="150px" MaxLength="30"></asp:TextBox><span class="requiredField">(R)</span>
                                        <asp:RequiredFieldValidator ID="PasswordRequiredValidator" runat="server" ControlToValidate="Password"
                                            Display="Static" ErrorMessage="You must provide a new password to continue." Text="*" ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator ID="PasswordPolicyValidator" runat="server" ControlToValidate="Password"
                                            Display="Dynamic" ErrorMessage="The new password you provided does not meet the minimum requirements." Text="*" ValidationGroup="EditProfile"></asp:CustomValidator>
                                   </span>
                                </div>
                                <div class="field">
                                        <asp:Label ID="ConfirmPasswordLabel" runat="server" Text="Confirm Password:" CssClass="fieldHeader"></asp:Label>
                                     <span class="fieldValue">
                                        <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="password" Width="150px" MaxLength="30"></asp:TextBox><span class="requiredField">(R)</span>
                                        <asp:CompareValidator ID="ConfirmPasswordValidator2" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" 
                                            Display="Dynamic" ErrorMessage="You did not retype your new password correctly." Text="*" ValidationGroup="EditProfile"></asp:CompareValidator>
                                        <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                            Display="Static" ErrorMessage="You must confirm new password to continue." Text="*" ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
                                    </span>
                                </div>
                                <div class="validationSummary">
                                      <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="EditProfile" />
                                </div>
                                <div class="buttons">
                                     <asp:Button ID="SaveButton" runat="server" Text="Change Password" OnClick="SaveButton_Click" CssClass="button" OnClientClick="if (Page_ClientValidate('EditProfile')) { this.value = 'Updating...'; this.onclick=function(){return false;}; }" ValidationGroup="EditProfile" />
                                     <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="MyAccount.aspx" CssClass="button" />
                                </div>
                            </div>
                            <asp:Label ID="ConfirmationMsg" Text="Your password has been changed." Visible="false" runat="server" EnableViewState="false" CssClass="success"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </asp:Panel>
			</div>
		</div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageHeader"></asp:Content>
