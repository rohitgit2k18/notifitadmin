<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Account.OrderTotalSummary" CodeFile="OrderTotalSummary.ascx.cs" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays totals summary for an order</summary>
<param name="ShowTaxBreakdown" default="true">Indicates whether taxes should be broken down by tax name, or shown as a lump sum.</param>
</conlib>
--%>
<asp:Panel ID="OrderTotalSummaryPanel" runat="server" CssClass="widget orderTotalSummaryWidget">
    <div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Order Total"></asp:Localize></h2>
    </div>
    <div class="content">
        <table cellpadding="0" cellspacing="0" class="orderTotalSummary">
            <tr class="simpleRow">
                <th><asp:Label ID="SubtotalLabel" runat="server" Text="Item Subtotal:"></asp:Label></th>
                <td><asp:Label ID="Subtotal" runat="server"></asp:Label></td>
            </tr>
            <tr class="simpleRow">
                <th><asp:Label ID="GSTlLabel" runat="server" Text="GST:"></asp:Label></th>
                <td><asp:Label ID="Gst" runat="server"></asp:Label></td>
            </tr>

            <tr class="simpleRow" id="trGiftWrap" runat="server">
                <th><asp:Label ID="GiftWrapLabel" runat="server" Text="Gift Wrap:"></asp:Label></th>
                <td><asp:Label ID="GiftWrap" runat="server"></asp:Label></td>
            </tr>

            <tr class="simpleRow" id="trShipping" runat="server">
                <th><asp:Label ID="ShippingLabel" runat="server" Text="Shipping:"></asp:Label></th>
                <td><asp:Label ID="Shipping" runat="server"></asp:Label></td>
            </tr>
            <tr class="simpleRow" id="trHandling" runat="server">
                <th><asp:Label ID="HandlingLabel" runat="server" Text="Handling Fee: "></asp:Label></th>
                <td align="right"><asp:Label ID="Handling" runat="server"></asp:Label></td>
            </tr>
            <asp:PlaceHolder ID="phTaxes" runat="server"></asp:PlaceHolder>
            <tr class="simpleRow" id="trCoupon" runat="server">
                <th><asp:Label ID="CouponsLabel" runat="server" Text="Coupons:"></asp:Label></th>
                <td><asp:Label ID="Coupons" runat="server"></asp:Label></td>
            </tr>

            <tr class="simpleRow" id="trAdjustments" runat="server">
                <th><asp:Label ID="AdjustmentsLabel" runat="server" Text="Adjustments:"></asp:Label></th>
                <td><asp:Label ID="Adjustments" runat="server"></asp:Label></td>
            </tr>

            <tr class="dividerRow"><td colspan="2"></td></tr>

            <tr class="importantRow">
                <th><asp:Label ID="TotalLabel" runat="server" Text="Grand Total: "></asp:Label></th>
                <td><asp:Label ID="Total" runat="server"></asp:Label></td>
            </tr>
        </table>
    </div>
</asp:Panel>