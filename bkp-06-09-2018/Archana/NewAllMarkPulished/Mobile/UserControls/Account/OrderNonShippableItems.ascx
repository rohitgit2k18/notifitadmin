<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderNonShippableItems.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.OrderNonShippableItems" %>
<%@ Register Src="~/Mobile/UserControls/Account/OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<%--
<UserControls>
<summary>Displays non shippable items for an order.</summary>
</UserControls>
--%>

<asp:Panel ID="NonShippingItemsPanel" runat="server" CssClass="widget orderNonShippableItemsWidget">
    <div class="header">
        <h2>
            <asp:Localize ID="NonShippingItemsCaption" runat="server" Text="Non Shipping Items"></asp:Localize>
        </h2>
    </div>
    <div class="content">
        <asp:Repeater ID="NonShippingItemsGrid" runat="server">
            <HeaderTemplate>
                <ul class="itemList">
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
</asp:Panel>