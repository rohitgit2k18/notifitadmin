<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Account.OrderSummary" CodeFile="OrderSummary.ascx.cs" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays order summary for an order</summary>
</conlib>
--%>
<div class="widget orderSummaryWidget">
    <div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Order Summary"></asp:Localize></h2>
    </div>
    <div class="content">
        <div class="orderDate">
            <h3><asp:Localize ID="OrderDateLabel" runat="server" Text="Order Date:"></asp:Localize></h3>
            <asp:Literal ID="OrderDate" runat="server"></asp:Literal>
        </div>
        <div class="orderStatus">
            <h3><asp:Localize ID="OrderStatusLabel" runat="server" Text="Status:"></asp:Localize></h3>
            <asp:Literal ID="OrderStatus" runat="server"></asp:Literal>
        </div>
    </div>
</div>