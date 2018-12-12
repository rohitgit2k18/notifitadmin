<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderSummary.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.mOrderSummary" %>
<%--
<UserControls>
<summary>Display summary of the order.</summary>
</UserControls>
--%>
<div class="widget orderSummaryWidget">
    <div class="content">
        <div class="inputForm">
            <div class="inlineField">
                <span class="fieldHeader"><asp:Localize ID="OrderNumberLabel" runat="server" Text="Order#:"></asp:Localize></span>
                <asp:Literal ID="OrderNumber" runat="server"></asp:Literal>
            </div>
            <div class="inlineField">
                <span class="fieldHeader"><asp:Localize ID="OrderDateLabel" runat="server" Text="Order Date:"></asp:Localize></span>
                <asp:Literal ID="OrderDate" runat="server"></asp:Literal>
            </div>
            <div class="inlineField">
                <span class="fieldHeader"><asp:Localize ID="OrderStatusLabel" runat="server" Text="Status:"></asp:Localize></span>
                <asp:Literal ID="OrderStatus" runat="server"></asp:Literal>
           </div>
        </div>
    </div>
</div>