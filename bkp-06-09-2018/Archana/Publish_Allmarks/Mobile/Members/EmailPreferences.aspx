<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="EmailPreferences.aspx.cs" Inherits="AbleCommerce.Mobile.Members.EmailPreferences" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" runat="server">
<div id="account_emailSubscriptionsPage" class="mainContentWrapper">
	<div class="section">
        <div class="header">
            <h2>Email Preferences</h2>
        </div>
		<div class="content">
            <asp:Panel ID="EditPanel" runat="server" CssClass="tabpane" DefaultButton="SaveButton">
                <asp:UpdatePanel ID="AjaxPanel" runat="server">
                    <ContentTemplate>
						<div class="info">
                            <asp:Label ID="EmaiLListsLabel" runat="server" Text="Please update your email preferences below."></asp:Label>
                        </div>
					    <asp:Repeater ID="dlEmailLists" runat="server">
                            <HeaderTemplate>
                                <div class="emailSubscriptions">
                            </HeaderTemplate>
						    <ItemTemplate>
                                <div class="emailSubscription <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                                    <div class="title">
                                        <asp:HiddenField ID="EmailListId" runat="server" Value='<%#Eval("EmailListId") %>' />
							            <asp:CheckBox ID="Selected" runat="server" Checked='<%#IsInList(Container.DataItem)%>' />
							            <asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                                    </div>
                                    <asp:PlaceHolder ID="PHContents" runat="server" Visible='<%#!String.IsNullOrEmpty(Eval("Description").ToString())%>'>
                                    <div class="contents">
							            <asp:Label ID="Description" runat="server" Text='<%#Eval("Description")%>'></asp:Label>
                                    </div>
                                    </asp:PlaceHolder>
                                </div>
						    </ItemTemplate>
                            <FooterTemplate>
                                </div>
                            </FooterTemplate>
					    </asp:Repeater>
                        <asp:Button ID="SaveButton" runat="server" Text="Update" OnClick="SaveButton_Click" CssClass="button"  />
                        <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="MyAccount.aspx" CssClass="button" /><br />
                        <asp:Label ID="ConfirmationMsg" Text="Your Email preferences have been updated." Visible="false" runat="server" EnableViewState="false" CssClass="success"></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
		</div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageHeader"></asp:Content>