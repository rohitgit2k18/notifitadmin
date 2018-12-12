<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderShipments.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.mOrderShipments" %>
<%@ Register Src="~/Mobile/UserControls/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%--
<UserControls>
<summary>Displays Order Shipment details.</summary>
</UserControls>
--%>
<%@ Register Src="~/Mobile/UserControls/Account/OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<asp:Panel ID="ShipmentsPanel" runat="server" CssClass="orderShipmentWidgets">
    <div class="header">
        <h2>Shipping Information</h2>
    </div>
    <asp:Repeater ID="ShipmentRepeater" runat="server">
        <ItemTemplate>
            <div class="widget shipmentWidget">
                <div class="caption">
                    Shipment#<%#Container.ItemIndex + 1 %>
                </div>
                <div class="address">
                    <b>SHIP TO: </b>
                    <%# GetShipToAddress(Container.DataItem) %>
                </div>
                <div class="info">
                    <div class="inputForm">
                        <div class="shippingStatus">
                            <div class="inlineField">
                                <span class="fieldHeader">Status:</span>
                                <span class="fieldValue"><%#GetShipStatus(Container.DataItem)%></span>
                            </div>
                        </div>
                        <div class="inlineField">
                            <span class="fieldHeader">Method:</span>
                            <span class="fieldValue"><%#Eval("ShipMethodName") %></span>
                        </div>
                    </div>
                    <asp:Panel ID="TrackingNumberPanel" runat="Server" Visible='<%#HasTrackingNumbers(Container.DataItem)%>' CssClass="tracking">
                        <h3>Tracking:</h3>
                        <asp:Repeater ID="TrackingRepeater" runat="server" DataSource='<%#Eval("TrackingNumbers")%>'>
                            <ItemTemplate>
                                <asp:HyperLink ID="TrackingNumberData"  Target="_blank" runat="server" Text='<%#Eval("TrackingNumberData")%>' NavigateUrl='<%#GetTrackingUrl(Container.DataItem)%>'></asp:HyperLink>
                            </ItemTemplate>
                            <SeparatorTemplate>, </SeparatorTemplate>
                        </asp:Repeater>                         
                    </asp:Panel>
                </div>
                <div class="items">
                    <asp:Repeater ID="ShipmentItemsGrid" runat="server" DataSource='<%# AbleCommerce.Code.OrderHelper.GetShipmentItems(Container.DataItem) %>'>
                        <HeaderTemplate>
                            <ul class="itemList">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <li class="itemNode <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                                <uc:OrderItemDetail ID="OrderItemDetail1" runat="server" OrderItem='<%#(OrderItem)Container.DataItem%>' ShowAssets="False" LinkProducts="False" ShowSubscription="true" />
                            </li>
                        </ItemTemplate>
                        <FooterTemplate>
                            </ul>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Panel>