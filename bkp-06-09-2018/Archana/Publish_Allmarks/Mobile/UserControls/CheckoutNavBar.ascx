<%@ Control Language="C#" Inherits="AbleCommerce.Mobile.UserControls.CheckoutNavBar" EnableViewState="false" CodeFile="CheckoutNavBar.ascx.cs" AutoEventWireup="True" %>
<%--
<conlib>
<summary>Displays a navigation bar for checkout pages on mobile store</summary>
</conlib>
--%>

<div class="checkoutNavBar" runat="server" id="CheckoutNavBarPanel">
<ul runat="server">
<li class="previous" runat="server" id="BillingNav">billing</li>
<li class="current" runat="server" id="ShippingNav">shipping</li>
<li class="next last" runat="server" id="PaymentNav">payment</li>
</ul>
</div>
