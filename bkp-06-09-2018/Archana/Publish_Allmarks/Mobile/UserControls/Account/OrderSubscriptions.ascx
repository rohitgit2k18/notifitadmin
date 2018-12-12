<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderSubscriptions.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.OrderSubscriptions" %>
<%--
<UserControls>
<summary>Displays subscriptions information for an order.</summary>
</UserControls>
--%>
<asp:Panel ID="SubscriptionsPanel" runat="server" CssClass="widget orderSubscriptions" Visible="false">
	<div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Subscriptions"></asp:Localize></h2>
    </div>
	<div class="content">
        <asp:Repeater ID="SubscriptionsGrid" runat="server" OnItemDataBound="SubscriptionsGrid_ItemDataBound">
            <ItemTemplate>
                <div class="subscription <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                    <div class="inputForm">
                        <div class="inlineField">
                            <span class="fieldHeader">Name:</span>
                            <span class="fieldValue">
                                <asp:Label ID="SubscriptionPlan" runat="server" text='<%#Eval("SubscriptionPlan.Name")%>'></asp:Label>
                                <br />
                                <asp:Label ID="ItemPriceLabel" runat="server" Text="Price:" CssClass="fieldHeader"></asp:Label>
                                <asp:Label ID="ItemPrice" runat="server" Text='<%#((decimal)Eval("OrderItem.Price")).LSCurrencyFormat("ulc")%>' CssClass="price"></asp:Label>
                                <br />
                                <asp:Label ID="AutoDeliveryDescription" runat="server"> </asp:Label>
                            </span>
                        </div>
                        <div class="inlineField">
                            <span class="fieldHeader">Delivery Frequency:</span>
                            <span class="fieldValue">
                                <asp:Label ID="DeliveryFrequencyLabel" runat="server" Text=""></asp:Label>
                            </span>
                        </div>
                        <asp:PlaceHolder ID="StatusPlaceHolder" runat="server">
                            <div class="inlineField">
                                <span class="fieldHeader">Expiration:</span>
                                <span class="fieldValue">
                                    <asp:Literal ID="Expiration" runat="server" text='<%#GetExpirationDate(Container.DataItem)%>'></asp:Literal>
                                </span>
                            </div>
                        </asp:PlaceHolder>
                        <div class="inlineField">
                            <span class="fieldHeader">Active:</span>
                            <span class="fieldValue">
                                <asp:Label ID="Active" runat="server" Text='<%#GetIsActive(Container.DataItem)%>'></asp:Label>
                            </span>
                        </div>
                        <div class="inlineField">
                            <span class="fieldHeader">Next Payment Due:</span>
                            <span class="fieldValue">
                                <asp:Label ID="NextPayment" runat="server" Text='<%#GetNextOrderDate(Container.DataItem)%>' EnableViewState="false"></asp:Label>
                            </span>
                        </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
	</div>
</asp:Panel>