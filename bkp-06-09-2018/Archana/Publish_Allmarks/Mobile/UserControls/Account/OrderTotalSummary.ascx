<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderTotalSummary.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.OrderTotalSummary" %>
<%--
<UserControls>
<summary>Display summary of order totals.</summary>
<param name="ShowTaxBreakdown" default="true">Indicates whether taxes should be broken down by tax name, or shown as a lump sum.</param>
</UserControls>
--%>
<asp:Panel ID="OrderTotalSummaryPanel" runat="server" CssClass="widget orderTotalSummaryWidget">
    <div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Order Totals"></asp:Localize></h2>
    </div>
    <div class="content">
        <div class="inputForm">
           <div class="inlineField">
              <span class="fieldHeader"><asp:Label ID="SubtotalLabel" runat="server" Text="Item Subtotal:"></asp:Label></span>
              <span class="fieldValue"><asp:Label ID="Subtotal" runat="server" CssClass="price"></asp:Label></span>
           </div>
            <div class="inlineField" id="trGiftWrap" runat="server">
                <span class="fieldHeader"><asp:Label ID="GiftWrapLabel" runat="server" Text="Gift Wrap:"></asp:Label></span>
                <span class="fieldValue"><asp:Label ID="GiftWrap" runat="server" CssClass="price"></asp:Label></span>
            </div>

             <div class="inlineField">
                <span class="fieldHeader"><asp:Label ID="ShippingLabel" runat="server" Text="Shipping:"></asp:Label></span>
                <span class="fieldValue"><asp:Label ID="Shipping" runat="server" CssClass="price"></asp:Label></span>
            </div>

            <asp:PlaceHolder ID="phTaxes" runat="server"></asp:PlaceHolder>
            <div class="inlineField" id="trCoupon" runat="server">
                <span class="fieldHeader"><asp:Label ID="CouponsLabel" runat="server" Text="Coupons:"></asp:Label></span>
                <span class="fieldValue"><asp:Label ID="Coupons" runat="server" CssClass="price"></asp:Label></span>
            </div>

            <div class="inlineField" id="trAdjustments" runat="server">
                <span class="fieldHeader"><asp:Label ID="AdjustmentsLabel" runat="server" Text="Adjustments:"></asp:Label></span>
                <span class="fieldValue"><asp:Label ID="Adjustments" runat="server" CssClass="price"></asp:Label></span>
            </div>

            <div class="inlineField">
                <span class="fieldHeader"><asp:Label ID="TotalLabel" runat="server" Text="Total: "></asp:Label></span>
                <span class="fieldValue"><asp:Label ID="Total" runat="server" CssClass="price"></asp:Label></span>
            </div>
        </div>
    </div>
</asp:Panel>