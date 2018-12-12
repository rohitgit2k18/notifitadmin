<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AccountTabPage.ascx.cs" Inherits="AbleCommerce.Admin.People.Users.AccountTabPage" %>
<%@ Register Src="../../UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <div class="content">
            <cb:Notification ID="SavedMessage" runat="server" Text="User saved at {0:t}" Visible="false" SkinID="GoodCondition"></cb:Notification>
            <asp:ValidationSummary ID="AccountValidationSummary" runat="server" ValidationGroup="Account" />
            <cb:Notification ID="AccountSavedMessage" runat="server" Text="Account settings saved at {0:T}." SkinID="GoodCondition" Visible="false"></cb:Notification>            
            <table class="inputForm" cellspacing="0">
                <tr>
                    <th>
                        <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" Text="User Name:"></asp:Label> 
                    </th>
                    <td>
	                    <asp:TextBox ID="UserName" runat="server" Width="250px" MaxLength="250"></asp:TextBox>
                        <asp:CustomValidator ID="UserNameAvailableValidator" runat="server" ControlToValidate="UserName" ErrorMessage="The username '{0}' is already registered to another user." Text="*"  ValidationGroup="Account"/>
                        <asp:LinkButton ID="LoginUserButton" runat="server" Text="Login as this User" onclick="LoginUserButton_Click" OnClientClick="return confirm('Are you sure you want to login as {0}');" />
                    </td>
                    <th>
                        <asp:Label ID="RegisteredSinceDateLabel" runat="server" AssociatedControlID="RegisteredSinceDate" Text="Registered Since:"></asp:Label>
                    </th>
                    <td align="left">
                        <asp:Literal ID="RegisteredSinceDate" runat="server" Text=""></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email" Text="Email:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="Email" runat="server" Width="250px" MaxLength="250"></asp:TextBox>
                        <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="Email" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*"></cb:EmailAddressValidator>
                        <asp:CustomValidator ID="EmailAvailableValidator" runat="server" ControlToValidate="Email" ErrorMessage="The email address '{0}' is already registered to another user." Text="*" />
                    </td>
                    <th>
                        <asp:Label ID="LastActiveDateLabel" runat="server" AssociatedControlID="LastActiveDate" Text="Last Active:"></asp:Label>
                    </th>
                    <td align="left">
                        <asp:Literal ID="LastActiveDate" runat="server" Text="-"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <th valign="top">
                        <asp:Label ID="ChangePasswordLabel" runat="server" AssociatedControlID="ChangePasswordButton" Text="Password:"></asp:Label>
                    </th>
                    <td>
                        <asp:Label ID="PasswordLastChangedText" runat="server" Text="Password last changed {0} ago."></asp:Label>
                        <br />
                        <asp:LinkButton ID="ChangePasswordButton" runat="server" Text="Change Password" />
                        <asp:Panel ID="ChangePasswordDialog" runat="server" Style="display:none;width:400px" CssClass="modalPopup">
                            <asp:Panel ID="ChangePasswordDialogHeader" runat="server" CssClass="modalPopupHeader">
                                <asp:Label ID="ChangePasswordDialogCaption" runat="server" Text="Change Password"></asp:Label>
                            </asp:Panel>
                            <div style="padding-top:5px;">
                                <table class="inputForm" cellpadding="3">
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="ChangePasswordHelpText" runat="server" Text="Set the new password below.  Changing a password takes effect immediately after saving.  Set the new password according to the policy rules:"></asp:Label><br /><br />
                                            <asp:Localize ID="PasswordPolicyLength" runat="server" Text="* The new password must be at least {0} characters long."></asp:Localize><br />
                                            <asp:Localize ID="PasswordPolicyRequired" runat="server" Text="* The password must include at least one {0}."></asp:Localize><br /><br />
                                            <asp:ValidationSummary ID="ChangePasswordValidationSummary" runat="server" ValidationGroup="ChangePassword" />
                                        </td>
                                    </tr>   
                                    <tr>
                                        <th>
                                            <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword" Text="Password:"></asp:Label>
                                        </th>
                                        <td align="left">
                                            <asp:TextBox ID="NewPassword" runat="server" TextMode="Password" Columns="20" MaxLength="50"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequiredValidator" runat="server" 
                                                ControlToValidate="NewPassword" ErrorMessage="New password is required."
                                                Text="*" ValidationGroup="ChangePassword"></asp:RequiredFieldValidator>
                                            <asp:CustomValidator ID="PasswordPolicyValidator" runat="server" ErrorMessage="Password does not meet the policy requirements."
                                                Text="*" ValidationGroup="ChangePassword"></asp:CustomValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <asp:Label ID="ConfirmNewPasswordLabel" runat="server" AssociatedControlID="ConfirmNewPassword" Text="Retype Password:"></asp:Label>
                                        </th>
                                        <td align="left">
                                            <asp:TextBox ID="ConfirmNewPassword" runat="server" TextMode="Password" Columns="20" MaxLength="50"></asp:TextBox>
                                            <asp:CompareValidator ID="NewPasswordComparer" runat="server" ControlToCompare="ConfirmNewPassword"
                                                ControlToValidate="NewPassword" Display="Static" ErrorMessage="You did not retype the password correctly."
                                                Text="*" ValidationGroup="ChangePassword"></asp:CompareValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>
                                            <asp:CheckBox ID="ForceExpiration" runat="server" Checked="true" />
                                            <asp:Label ID="ForceExpirationLabel" runat="server" AssociatedControlID="ForceExpiration" Text="User must change password at next login"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>
                                            <br />
                                            <asp:Button ID="ChangePasswordOKButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="ChangePasswordOKButton_Click" OnClientClick="return Page_ClientValidate('ChangePassword')" ValidationGroup="ChangePassword" />
                                            <asp:Button ID="ChangePasswordCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="ChangePasswordCancelButton_Click" CausesValidation="false" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>
                        <ajaxToolkit:ModalPopupExtender ID="ChangePasswordPopup" runat="server" 
                            TargetControlID="ChangePasswordButton"
                            PopupControlID="ChangePasswordDialog" 
                            BackgroundCssClass="modalBackground"                         
                            CancelControlID="ChangePasswordCancelButton" 
                            DropShadow="true"
                            PopupDragHandleControlID="ChangePasswordDialogHeader" />
                    </td>
                    <th>
                        <asp:Label ID="FailedLoginCountLabel" runat="server" AssociatedControlID="FailedLoginCount" Text="Failed Logins:"></asp:Label>
                    </th>
                    <td align="left">
                        <asp:Literal ID="FailedLoginCount" runat="server" Text=""></asp:Literal>
                    </td>
                </tr>
                <tr>

                    <th valign="top">
                        <asp:Label ID="GroupListLabel" runat="server" AssociatedControlID="GroupList" Text="Group(s):"></asp:Label>
                    </th>
                    <td>
                        <asp:Label ID="GroupList" runat="server" Text="-"></asp:Label>
                        <asp:HiddenField ID="GroupListChanged" runat="server" />
                        <asp:HiddenField ID="HiddenSelectedGroups" runat="server" />
                        <asp:LinkButton ID="ChangeGroupListButton" runat="server" Text="Change Group" />
                        <asp:Panel ID="ChangeGroupListDialog" runat="server" Style="display: none" CssClass="modalPopup" Width="600px">
                            <asp:Panel ID="ChangeGroupListDialogHeader" runat="server" CssClass="modalPopupHeader">
                                Change Assigned Groups
                            </asp:Panel>
                            <div align="center">
                                <ul class="information">
                                    <li id="SubscriptionGroupLI" runat="server" visible="false">Subscription Groups can not be altered. These groups are managed by the system.</li>
                                    <li>A user must belong to at least one group. If you don't select any group, the user will automatically be added to _Default_ group.</li>
                                </ul>
                                Hold CTRL to select multiple groups.  Double click to move a group to the other list.
                                <br /><br />
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="center" valign="top" width="42%">
                                            <b>Groups Available</b><br />
                                            <asp:ListBox ID="AvailableGroups" runat="server" Rows="12" SelectionMode="multiple" Width="220" Height="230"></asp:ListBox>
                                        </td>
                                        <td align="center" valign="middle" width="6%">
                                            <asp:Button ID="SelectAllGroups" runat="server" Text=" >> " /><br />
                                            <asp:Button ID="SelectGroup" runat="server" Text=" > " /><br />
                                            <asp:Button ID="UnselectGroup" runat="server" Text=" < " /><br />
                                            <asp:Button ID="UnselectAllGroups" runat="server" Text=" << " /><br />
                                        </td>
                                        <td align="center" valign="top" width="42%">
                                            <b>Groups Assigned</b><br />
                                            <asp:ListBox ID="SelectedGroups" runat="server" Rows="12" SelectionMode="multiple" Width="220" Height="160"></asp:ListBox>
                                            <select multiple="multiple" style="width:220px; height:70px;" >
                                                <option disabled="disabled">--- Subscription Groups ---</option>
                                                <asp:PlaceHolder ID="PHSubscriptionGroups" runat="server"></asp:PlaceHolder>
                                            </select>
                                        </td>
                                    </tr>
                                </table><br />
                                <asp:PlaceHolder ID="phMyGroupsWarning" runat="server" Visible="false">
                                    <br />
                                    <asp:Label ID="MyGroupsWarning" runat="server" Text="WARNING: You are modifying your own groups.  Be careful not to lock yourself out!" SkinID="ErrorCondition"></asp:Label>
                                    <br /><br />
                                </asp:PlaceHolder>
                                <asp:Button ID="ChangeGroupListOKButton" runat="server" Text="Save" SkinID="SaveButton" OnClientClick="changeGroupList()" OnClick="ChangeGroupListOKButton_Click" />
                                <asp:Button ID="ChangeGroupListCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" />
                                <br /><br />
                            </div>
                        </asp:Panel>
                        <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender" runat="server" 
                            TargetControlID="ChangeGroupListButton"
                            PopupControlID="ChangeGroupListDialog" 
                            BackgroundCssClass="modalBackground" 
                            CancelControlID="ChangeGroupListCancelButton" 
                            DropShadow="true"
                            PopupDragHandleControlID="ChangeGroupListDialogHeader" />
                    </td>
                    <th>
                        <asp:Label ID="LastLockoutDateLabel" runat="server" AssociatedControlID="LastLockoutDate" Text="Last Lockout:"></asp:Label>
                    </th>
                    <td align="left">
                        <asp:Literal ID="LastLockoutDate" runat="server" Text="-"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="AffiliateLabel" runat="server" AssociatedControlID="Affiliate" Text="Referred By: "></asp:Label>
                    </th>
                    <td>
                        <asp:DropDownList ID="Affiliate" runat="server" AppendDataBoundItems="true" DataSourceID="AffiliateDS" DataTextField="Name" DataValueField="AffiliateId" OnDataBound="Affiliate_DataBound">
                            <asp:ListItem Selected="True" Value="0" Text="No Affliate"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label ID="ReferredDate" runat="server" Text=""></asp:Label>
                        <asp:ObjectDataSource ID="AffiliateDS" runat="server" SelectMethod="LoadAll" TypeName="CommerceBuilder.Marketing.AffiliateDataSource" DataObjectTypeName="CommerceBuilder.Marketing.Affiliate">
                            <SelectParameters>
                                <asp:Parameter Name="sortExpression" DbType="String" DefaultValue="Name" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="TaxExemptionTypeLabel" runat="server" AssociatedControlID="TaxExemptionType" Text="Tax Exemption:" ToolTip="If this customer is tax exempt select the type of exemption." EnableViewState="false" />
                    </th>
                    <td>
                        <asp:DropDownList ID="TaxExemptionType" runat="server" EnableViewState="false"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="IsDisabledLabel" runat="server" AssociatedControlID="IsDisabled" Text="Disabled:"></asp:Label>
                    </th>
                    <td>
                        <asp:CheckBox ID="IsDisabled" runat="server" ForeColor="Red"></asp:CheckBox>
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="TaxExemptionReferenceLabel" runat="server" AssociatedControlID="TaxExemptionReference" Text="Tax Reference:" ToolTip="For tax exempt customers you should record a tax id, permit number, or other reference value proving the exemption status." EnableViewState="false" />
                    </th>
                    <td>
                        <asp:TextBox ID="TaxExemptionReference" runat="server" Width="200px" MaxLength="200" EnableViewState="false"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td colspan="3">
                        <asp:Button ID="SaveAccountButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveAccountButton_Click" />
                        <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
                        <asp:Button ID="BackButton" runat="server" SkinID="CancelButton" OnClick="BackButton_Click" Text="Cancel" CausesValidation="false" />
                    </td>
                </tr>
            </table>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:Panel ID="SubscriptionsPanel" runat="server" CssClass="section">
    <div class="header">
        <h2><asp:Label ID="SubscriptionsCaption" runat="server" Text="Suscriptions"></asp:Label></h2>
    </div>
    <div class="content">
        <cb:SortedGridView ID="SubscriptionGrid" runat="server" AutoGenerateColumns="False" DataSourceID="SubscriptionDs"  DataKeyNames="SubscriptionId"
            SkinID="PagedList" AllowSorting="true" ShowWhenEmpty="False" Width="100%" AllowPaging="true" PageSize="20" EnableViewState="False" 
            DefaultSortDirection="Ascending" DefaultSortExpression="S.ExpirationDate" OnRowCommand="SubscriptionGrid_RowCommand" OnRowUpdating="SubscriptionGrid_RowUpdating">
            <Columns>
                <asp:TemplateField HeaderText="Plan" SortExpression="SP.Name">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <a href="../../Products/EditSubscription.aspx?ProductId=<%#Eval("ProductId")%>"><%# String.Format("{0} of: {1}", Eval("Quantity"), Eval("Name")) %></a>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order" SortExpression="O.OrderNumber">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:HyperLink ID="orderLink" runat="server" NavigateUrl='<%#String.Format("../../Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderItem.Order.OrderNumber"))%>' Text='<%# Eval("OrderItem.Order.OrderNumber") %>' SkinID="Link"></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Group">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%#GetSubGroupName(Container.DataItem)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Active">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:CheckBox ID="Active" runat="server" Checked='<%#Eval("IsActive")%>' Enabled="False" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Next Payment">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:Label ID="NextPayment" runat="server" text='<%#GetNextPayment(Container.DataItem)%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Expiration" SortExpression="S.ExpirationDate">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:Label ID="Expiration" runat="server" text='<%#GetExpiration(Container.DataItem)%>'></asp:Label>
                        <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Visible='<%#((short)Eval("NumberOfPayments")) == 1%>' ><span style="padding-left:10px; font-weight:bold;">EDIT</span></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <uc1:PickerAndCalendar ID="EditExpiration" runat="server" SelectedDate='<%# Bind("ExpirationDate") %>' /> 
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>                    
                    <ItemStyle HorizontalAlign="right" />
                    <ItemTemplate>
                        <asp:LinkButton ID="ActivateLink" runat="server" visible='<%#(!(bool)Eval("IsActive"))%>' text="activate" SkinID="Button" CommandName="Activate" CommandArgument='<%#Eval("SubscriptionId")%>' />
                        <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#GetEditSubscriptionUrl(Container.DataItem) %>'><asp:Image ID="Image1" runat="server" SkinID="EditIcon" /></asp:HyperLink>
                        <asp:LinkButton ID="CancelLink" runat="server"  SkinID="Link" CommandName="CancelSubscription" CommandArgument='<%#Eval("SubscriptionId")%>' OnClientClick='javascript:return confirm("Are you sure you want to cancel the subscription?")'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" /></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:ImageButton ID="EditSaveButton" runat="server" CommandName="Update" SkinID="SaveIcon" ToolTip="Save"></asp:ImageButton>
                        <asp:ImageButton ID="EditCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" SkinID="CancelIcon" ToolTip="Cancel Editing"></asp:ImageButton>
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate> 
                <asp:Label ID="EmptyMessage" runat="server" Text="There are no active or pending subscriptions for this user."></asp:Label>
            </EmptyDataTemplate>
        </cb:SortedGridView>
    </div>
    <asp:ObjectDataSource ID="SubscriptionDs" runat="server" SelectMethod="Search" SelectCountMethod="SearchCount"
        TypeName="CommerceBuilder.Orders.SubscriptionDataSource" DataObjectTypeName="CommerceBuilder.Orders.Subscription"
        SortParameterName="sortExpression" EnablePaging="true">
        <SelectParameters>
            <asp:Parameter Name="subscriptionPlanId" Type="int32" DefaultValue="0" />
            <asp:Parameter Name="orderRange" Type="String" DefaultValue="" />
            <asp:QueryStringParameter Name="userIdRange" Type="String" QueryStringField="UserId" />
            <asp:Parameter Name="firstName" Type="String" DefaultValue="" />
            <asp:Parameter Name="lastName" Type="String" DefaultValue="" />
            <asp:Parameter Name="email" Type="String" DefaultValue="" />
            <asp:Parameter Name="expirationStart" DefaultValue="" />
            <asp:Parameter Name="expirationEnd" DefaultValue="" />
            <asp:Parameter Name="active" DefaultValue="Any" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Panel>