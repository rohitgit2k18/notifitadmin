<%@ Page Title="My Account" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="True" CodeFile="MyAccount.aspx.cs" Inherits="AbleCommerce.Mobile.Members.MyAccount" ViewStateMode="Disabled" %>
<%@ Register Src="~/Mobile/UserControls/Account/OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_mainPage" class="mainContentWrapper"> 
        <div class="section">
        <div class="header">
		    <h2>My Orders</h2>
		</div>
            <div class="content">
                <div class="tabpane">
                <div class="inputForm">
                    <asp:GridView ID="OrderGrid" runat="server" AutoGenerateColumns="False" Width="100%" CssClass="orderItems" AllowPaging="true" PageSize="3" onpageindexchanging="OrderGrid_PageIndexChanging">
                       <PagerStyle CssClass="pagingPanel" />
                        <Columns>
                            <asp:TemplateField>
                                    <HeaderTemplate></HeaderTemplate>
                                    <ItemStyle CssClass="itemDetail" />
									<ItemTemplate>
                                            <div class="inlineField">
                                                <span class="fieldHeader">Order #: </span>                               
											        <span class="fieldValue"><%# Eval("OrderNumber") %></span>
                                            </div> 
                                            <div class="inlineField">
                                                <span class="fieldHeader">Date: </span>                               
											        <span class="fieldValue"><%# Eval("OrderDate", "{0:d}")%></span>
                                            </div>
                                            <div class="inlineField">
                                                <span class="fieldHeader">Status: </span>                               
											        <span class="fieldValue"><%#GetOrderStatus(Container.DataItem)%></span>
                                            </div>
                                             <div class="inlineField">
                                                <span class="fieldHeader">Items: </span>
                                             </div>
                                             <div class="inlineField">                                                    
											    <asp:Repeater ID="ItemsRepeater" runat="server" DataSource='<%#AbleCommerce.Code.OrderHelper.GetVisibleProducts(Container.DataItem)%>'>
                                                    <HeaderTemplate>
                                                        <ul class="items">
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <li class="itemNode <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                                                            <uc:OrderItemDetail ID="OrderItemDetail1" runat="server" OrderItem='<%#(OrderItem)Container.DataItem%>' ShowAssets="False" LinkProducts="False" EnableFriendlyFormat="true" />
                                                        </li>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        </ul>
                                                    </FooterTemplate>
                                                </asp:Repeater>
                                             </div>                           	                                                    
                                    <div class="buttons">
                                        <asp:HyperLink ID="ViewOrderLink" runat="server" Text="View Order" NavigateUrl='<%# AbleCommerce.Code.NavigationHelper.GetMobileStoreUrl(Eval("OrderNumber", "~/Members/MyOrder.aspx?OrderNumber={0}").ToString())%>' CssClass="button"></asp:HyperLink>
								    </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:localize ID="EmptyOrderHistory" runat="server" Text="You have not placed any orders."></asp:localize>
                        </EmptyDataTemplate>
                    </asp:GridView>
                    </div>
                </div>
                <div class="header">
		    <h2>Account Settings</h2>
		</div>
        <div class="accLinks">
                <ul>
                    <li><asp:HyperLink ID="UpdateEmailLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Update Username or Email" /></li>
                    <asp:PlaceHolder ID="EmailPreferences" runat="server" Visible="false">
                    <li><asp:HyperLink ID="EmailPreferencesLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Email Preferences" /></li>
                    </asp:PlaceHolder>
                    <li><asp:HyperLink ID="ChangePassLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Change Password" /></li>
                    <li><asp:HyperLink ID="WishlistLink" runat="server" NavigateUrl="#" CssClass="tab" Text="My Wishlist" /></li>
                    <li><asp:HyperLink ID="AddressBookLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Manage Address Book" /></li>
                    <asp:PlaceHolder ID="PhPaymentTypes" runat="server" Visible="false">
                    <li><asp:HyperLink ID="PaymentTypesLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Payment Types"/></li>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="PhMyReviews" runat="server" Visible="false">
                    <li><asp:HyperLink ID="MyReviewsLink" runat="server" NavigateUrl="#" CssClass="tab" Text="My Product Reviews"/></li>
                    </asp:PlaceHolder>
                </ul>
         </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageHeader"></asp:Content>
