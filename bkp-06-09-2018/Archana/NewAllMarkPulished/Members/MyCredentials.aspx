<%@ Page Title="My Credentials" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MyCredentials.aspx.cs" Inherits="AbleCommerce.Members.MyCredentials" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Account/CurrencyPreferenceWidget.ascx" TagName="CurrencyPreferenceWidget" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_credentialsPage" class="mainContentWrapper">
		<div class="section">
			<div class="content">
                <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                <asp:Panel ID="EditPanel" runat="server" CssClass="tabpane" DefaultButton="SaveButton">
                    <asp:UpdatePanel ID="AjaxPanel" runat="server">
                        <ContentTemplate>
							<p class="instruction">
								<asp:Localize ID="UpdateAccountText" runat="server" Text="You can update the username, email address or password associated with your account using the form below.  You must provide your current password in order to save the changes.  If you do not wish to change your password, leave the new and confirm password fields empty."></asp:Localize>
								<asp:Localize ID="NewAccountText" runat="server" Text="Enter your email address and password below so that you may access your account in the future."></asp:Localize>
							</p>
                            <cb:Notification ID="SavedMessage" runat="server" Text="Your profile has been updated." Visible="false" SkinID="Confirmation"></cb:Notification>
                            <table class="inputForm">
                                <tr>
                                    <th class="rowHeader">
                                        <asp:Label ID="UserNameLabel" runat="server" Text="User Name:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="UserName" runat="server" width="200px" MaxLength="200"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                            Display="Dynamic" ErrorMessage="You must provide a username." Text="*" ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
                                        <asp:PlaceHolder ID="phUserNameUnavailable" runat="server" Visible="false">
						                    <div class="errorCondition">The user name you have provided is already in use. Please choose a different user name.</div>
						                </asp:PlaceHolder>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="rowHeader">
                                        <asp:Label ID="EmailLabel" runat="server" Text="Email:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Email" runat="server" width="200px" MaxLength="200"></asp:TextBox>
                                        <asp:CustomValidator ID="DuplicateEmailValidator" runat="server" ControlToValidate="Email"
                                            Display="Dynamic" ErrorMessage="That email address is registered to another account." Text="*" ValidationGroup="EditProfile"></asp:CustomValidator>
                                        <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" 
                                            ErrorMessage="Email address should be in the format of name@domain.tld." ControlToValidate="Email" Display="Static" Text="*" Required="true" ValidationGroup="EditProfile"></cb:EmailAddressValidator>
                                    </td>
                                </tr>                                
                                <tr id="trEmailPrefs" runat="server">
                                    <th class="rowHeader" valign="top">
                                        <asp:Label ID="EmaiLListsLabel" runat="server" Text="Email Preferences:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:PlaceHolder runat="server" ID="phEmailLists">
					                    <asp:DataList ID="dlEmailLists" runat="server" DataKeyField="EmailListId">
						                    <ItemTemplate>
							                    <asp:CheckBox ID="Selected" runat="server" Checked='<%#IsInList(Container.DataItem)%>' />
							                    <asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>' CssClass="fieldHeader"></asp:Label><br />
							                    <asp:Label ID="Description" runat="server" Text='<%#Eval("Description")%>'></asp:Label>
						                    </ItemTemplate>
					                    </asp:DataList>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder runat="server" ID="phReviewReminders">
                                        <table><tr><td>
                                        <asp:CheckBox ID="ReviewReminders" runat="server" /> 
                                        <asp:Label ID="ReviewReminderLabel" runat="server" Text="Receive Review Reminders" CssClass="fieldHeader"></asp:Label><br />
                                        <asp:Label ID="ReviewReminderDescription" runat="server" Text="Check this if you want to receive review reminder emails."></asp:Label>
                                        </td></tr></table>
                                        </asp:PlaceHolder>
                                    </td>
                                </tr>

                                <tr id="trCurrentPassword" runat="server">
                                    <th class="rowHeader">
                                        <asp:Label ID="CurrentPasswordLabel" runat="server" Text="Current Password:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="CurrentPassword" runat="server" TextMode="password" Width="150px" MaxLength="30"></asp:TextBox>
                                        <asp:CustomValidator ID="InvalidPassword" runat="server" ControlToValidate="CurrentPassword"
                                            Display="Dynamic" ErrorMessage="The password you provided is incorrect." Text="*" ValidationGroup="EditProfile"></asp:CustomValidator>
                                        <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" ControlToValidate="CurrentPassword"
                                            Display="Static" ErrorMessage="Current password is required to save your changes." Text="*" ValidationGroup="EditProfile"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                     <td></td>
                                     <td>
                                        <ul style="margin:8px 0px;padding:0px;">
                                            <asp:Localize ID="PasswordPolicyLength" runat="server" Text="<li>The new password must be at least {0} characters long.</li>"></asp:Localize>
                                            <asp:Localize ID="PasswordPolicyHistoryCount" runat="server" Text="<li>You may not use any of your previous {0} passwords.</li>"></asp:Localize>
                                            <asp:Localize ID="PasswordPolicyHistoryDays" runat="server" Text="<li>You may not reuse any passwords used within the last {0} days.</li>"></asp:Localize>
                                            <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="<li>The password must include at least one {0}.</li>"></asp:Localize>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="rowHeader">
                                        <asp:Label ID="PasswordLabel" runat="server" Text="New Password:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Password" runat="server" TextMode="password" Width="150px" MaxLength="30"></asp:TextBox>
                                        <asp:CustomValidator ID="PasswordRequiredValidator" runat="server" ControlToValidate="Password"
                                            Display="Dynamic" ErrorMessage="You must provide a new password to continue." Text="*" ValidationGroup="EditProfile"></asp:CustomValidator>
                                        <asp:CustomValidator ID="PasswordPolicyValidator" runat="server" ControlToValidate="Password"
                                            Display="Dynamic" ErrorMessage="The new password you provided does not meet the minimum requirements." Text="*" ValidationGroup="EditProfile"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="rowHeader">
                                        <asp:Label ID="ConfirmPasswordLabel" runat="server" Text="Confirm Password:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="password" Width="150px" MaxLength="30"></asp:TextBox>
                                        <asp:CompareValidator ID="ConfirmPasswordValidator2" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" 
                                            Display="Dynamic" ErrorMessage="You did not retype your new password correctly." Text="*" ValidationGroup="EditProfile"></asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="EditProfile" />
                                        <asp:Button ID="SaveButton" runat="server" Text="Update Profile" OnClick="SaveButton_Click" CssClass="button" OnClientClick="if (Page_ClientValidate('EditProfile')) { this.value = 'Updating...'; this.onclick=function(){return false;}; }" ValidationGroup="EditProfile" />
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </asp:Panel>
			</div>
		</div> 
        <uc:CurrencyPreferenceWidget ID="CurrencyPreferenceWidget" runat="server" />
    </div>
</div>
</asp:Content>