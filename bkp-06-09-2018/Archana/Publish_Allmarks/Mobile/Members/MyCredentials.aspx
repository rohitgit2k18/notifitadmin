<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="MyCredentials.aspx.cs" Inherits="AbleCommerce.Mobile.Members.MyCredentials" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" runat="server">
<div id="accountPage"> 
    <div id="account_credentialsPage" class="mainContentWrapper">
		<div class="section">
         <div class="header">
		    <h2>Account Update</h2>
		</div>
			<div class="content">
                <asp:Panel ID="EditPanel" runat="server" CssClass="tabpane" DefaultButton="SaveButton">
                    <asp:UpdatePanel ID="AjaxPanel" runat="server">
                        <ContentTemplate>
							<p class="instruction">
								<asp:Localize ID="UpdateAccountText" runat="server" Text="You must provide your username or email address in order to save the changes."></asp:Localize>
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
                                <div class="field">
                                    <asp:Label ID="UserNameLabel" runat="server" Text="User Name:" CssClass="fieldHeader"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="UserName" runat="server" width="200px" MaxLength="200"></asp:TextBox><span class="requiredField">(R)</span>
                                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                            Display="Dynamic" ErrorMessage="You must provide a username." Text="*" ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
                                        <asp:PlaceHolder ID="phUserNameUnavailable" runat="server" Visible="false">
						                    <div class="errorCondition">The user name you have provided is already in use. Please choose a different user name.</div>
						                </asp:PlaceHolder>
                                   </span>
                                </div>
                                <div class="field">
                                    <asp:Label ID="EmailLabel" runat="server" Text="Email:" CssClass="fieldHeader"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="Email" runat="server" width="200px" MaxLength="200"></asp:TextBox><span class="requiredField">(R)</span>
                                        <asp:CustomValidator ID="DuplicateEmailValidator" runat="server" ControlToValidate="Email"
                                            Display="Dynamic" ErrorMessage="That email address is registered to another account." Text="*" ValidationGroup="EditProfile"></asp:CustomValidator>
                                        <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" 
                                            ErrorMessage="Email address should be in the format of name@domain.tld." ControlToValidate="Email" Display="Static" Text="*" Required="true" ValidationGroup="EditProfile"></cb:EmailAddressValidator>
                                   </span>
                                </div>
                                <div class="validationSummary">
                                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="EditProfile" />
                                </div>
                                <div class="buttons">
                                    <asp:Button ID="SaveButton" runat="server" Text="Update Username or Email" OnClick="SaveButton_Click" CssClass="button" OnClientClick="if (Page_ClientValidate('EditProfile')) { this.value = 'Updating...'; this.onclick=function(){return false;}; }" ValidationGroup="EditProfile" />
                                    <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="MyAccount.aspx" CssClass="button" />
                                </div>
                            </div>
                            <asp:Label ID="ConfirmationMsg" Text="Your profile has been updated." Visible="false" runat="server" EnableViewState="false" CssClass="success"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </asp:Panel>
			</div>
		</div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageHeader"></asp:Content>