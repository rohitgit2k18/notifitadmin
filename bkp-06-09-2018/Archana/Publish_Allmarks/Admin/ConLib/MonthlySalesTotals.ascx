<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MonthlySalesTotals.ascx.cs" Inherits="AbleCommerce.Admin.ConLib.MonthlySalesTotals" %>
<asp:Panel ID="MessagePanel" runat="server" Visible="false">
    <table class="pagedList">
        <tr class="empty">
            <td>
                <asp:Literal ID="Message" runat="server" Text="No orders to display."></asp:Literal>
            </td>
        </tr>
    </table>
</asp:Panel>
<asp:Panel ID="TotalsPanel" runat="server" Visible="false">
    <table class="pagedList">
        <tr>
            <th>&nbsp;</th>
            <th>Orders</th>
            <th>Products</th>
            <th>Cost</th>
            <th>Shipping</th>
            <th>Tax</th>
            <th>Discount</th>
            <th>Coupon</th>
            <th>Gift Wrap</th>
            <th>Other</th>
            <th>Profit</th>
            <th>Total</th>
        </tr>
        <tr>
            <td>
                <asp:Label ID="FooterTotalsLabel" runat="server" Text="Totals:" SkinID="FieldHeader"></asp:Label>
            </td>
            <td>
                <asp:Label ID="OrderCountTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="ProductTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="CostOfGoodsTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="ShippingTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="TaxTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="DiscountTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="CouponTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="GiftWrapTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="OtherTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="ProfitTotal" runat="server"></asp:Label>
            </td>
            <td>
                <asp:Label ID="GrandTotal" runat="server"></asp:Label>
            </td>
        </tr>
    </table>
</asp:Panel>