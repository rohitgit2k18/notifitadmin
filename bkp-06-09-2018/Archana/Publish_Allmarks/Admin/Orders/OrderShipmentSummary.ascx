<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderShipmentSummary.ascx.cs" Inherits="AbleCommerce.Admin.Orders.OrderShipmentSummary" ViewStateMode="Disabled" %>
<asp:PlaceHolder ID="ShipmentsPanel" runat="server">
    <asp:Panel ID="ShipButtonsPanel" runat="server" CssClass="shipmentButtons">
        <asp:HyperLink ID="ShipButton" runat="server" Text="Ship Items" NavigateUrl="Shipments/ShipOrder.aspx?OrderShipmentId={0}" SkinID="Button" EnableViewState="false"></asp:HyperLink>
        <asp:HyperLink ID="PackingListButton" runat="server" Text="Print Packing Slip" NavigateUrl="Print/PackSlips.aspx?OrderNumber={0}&is=1" SkinID="Button"></asp:HyperLink>
        <asp:HyperLink ID="ShippingDetailsButton" runat="server" Text="Shipments" NavigateUrl="Shipments/Default.aspx?OrderNumber={0}" SkinID="Button"></asp:HyperLink>
    </asp:Panel>
    <div class="shipmentList">
        <asp:ListView ID="ShipmentList" runat="server">
            <LayoutTemplate>
                <ul>
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                </ul>
            </LayoutTemplate>
            <ItemTemplate>
                <li>
                    <asp:PlaceHolder ID="ShipmentNumberPanel" runat="server" Visible="<%# ShowShipmentNumbers %>">
                        <asp:Label ID="ShipmentNumber" runat="server" Text='<%# Eval("ShipmentNumber", "Shipment #{0}:") %>' SkinID="FieldHeader"></asp:Label><br />
                    </asp:PlaceHolder>
                    <asp:Label ID="ShippingStatusLabel" runat="server" Text="Shipping Status:" SkinID="FieldHeader"></asp:Label>
                    <%# GetShippingStatus(Container.DataItem) %><br />
                    <asp:Label ID="ShippingMethodLabel" runat="server" Text="Shipping Method: " SkinID="FieldHeader"></asp:Label>
                    <%# Eval("ShipMethodName") %>
                </li>
            </ItemTemplate>
        </asp:ListView>
        <asp:HyperLink ID="MoreShipmentsLink" runat="server" Text="View more shipments..."></asp:HyperLink>
    </div>
    <asp:Panel ID="ShippingAddressPanel" runat="server" CssClass="shippingAddress">
        <asp:Literal ID="ShippingAddress" runat="server"></asp:Literal><br />
        <asp:Localize ID="ShipToEmail" runat="server" Text="Email: {0}<br />" />
        <asp:Localize ID="ShipToPhone" runat="server" Text="Phone: {0}<br />" />
        <asp:Localize ID="ShipToFax" runat="server" Text="Fax: {0}<br />" />
    </asp:Panel>
</asp:PlaceHolder>
<asp:PlaceHolder ID="NoShipmentsPanel" runat="server" Visible="false">
    This order does not have any shipments.
</asp:PlaceHolder>