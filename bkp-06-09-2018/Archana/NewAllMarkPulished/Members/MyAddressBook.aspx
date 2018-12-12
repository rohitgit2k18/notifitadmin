<%@ Page Title="My Address Book" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MyAddressBook.aspx.cs" Inherits="AbleCommerce.Members.MyAddressBook" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_addressBookPage" class="mainContentWrapper">
		<div class="section">
    		<div class="content">
                <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                <div class="tabpane">
                    <asp:UpdatePanel ID="AddressBookAjax" runat="server">
                        <ContentTemplate>
                            <div class="addressBook">
                                <div class="entries">
                                    <div class="entry">
                                        <div class="caption">
                                            <h2>Billing Address</h2>
                                        </div>
                                        <div class="address">
                                            <asp:Localize ID="PrimaryAddress" runat="server" Text="Please update your billing address."></asp:Localize>
                                        </div>
                                        <div class="buttons">
                                            <asp:LinkButton ID="EditPrimaryAddressButton" runat="server" OnClick="EditPrimaryAddressButton_Click" CssClass="button linkButton" Text="Edit"></asp:LinkButton>
                                        </div>
                                    </div>
                                    <asp:Repeater ID="AddressList" runat="server" OnItemCommand="AddressList_ItemCommand">
                                        <ItemTemplate>
                                            <div class="entry">
                                                <div class="caption">
                                                    <h2>Shipping Address</h2>
                                                </div>
                                                <div class="address">
                                                    <asp:Literal ID="Address" runat="server" Text='<%#Container.DataItem.ToString().Trim() == ","? "Please fill in your primary address.":Container.DataItem.ToString() %>'></asp:Literal>
                                                </div>
                                                <div class="buttons">
                                                    <asp:LinkButton ID="EditAddressButton" runat="server" CommandArgument='<%#Eval("AddressId")%>' CommandName="Edit" CssClass="button linkButton" Text="Edit"></asp:LinkButton>
                                                    <asp:LinkButton ID="DeleteAddressButton" runat="server" CssClass="button linkButton" Text="Delete" CommandName="Delete" CommandArgument='<%#Eval("AddressId")%>' OnClientClick='<%# Eval("FullName", "return confirm(\"Are you sure you want to delete {0}?\")") %>'></asp:LinkButton>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <div class="entry addEntry">
                                        <div class="buttons">
                                            <asp:LinkButton ID="NewAddressButton" runat="server" CssClass="button linkButton" Text="New" OnClick="NewAddressButton_Click" CausesValidation="false"></asp:LinkButton>
                                        </div>
                                    </div>
                                 </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
    		</div>
        </div>
    </div>
</div>
</asp:Content>