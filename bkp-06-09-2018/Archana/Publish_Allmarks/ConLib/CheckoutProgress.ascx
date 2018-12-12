<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.CheckoutProgress" EnableViewState="false" CodeFile="CheckoutProgress.ascx.cs" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays the 4 checkout progress steps dynamically.</summary>
</conlib>
--%>
<div class="checkoutProgressBar">
    <asp:PlaceHolder ID="PHNavHeader" runat="server" Visible="false" EnableViewState="false">
    <nav role="navigation" class="navbar navbar-default">
    </asp:PlaceHolder>
    <div class="checkoutProgress">
        <span ID="Step1" runat="server" class="off"><span><asp:HyperLink ID="Step1Text" runat="server" Text="Billing" NavigateUrl="~/Checkout/EditBillAddress.aspx" ></asp:HyperLink></span></span>
        <span ID="Step2" runat="server" class="off"><span><asp:HyperLink ID="Step2Text" runat="server" Text="Shipping" NavigateUrl="~/Checkout/ShipMethod.aspx"></asp:HyperLink></span></span>
        <span ID="Step3" runat="server" class="off"><span><asp:HyperLink ID="Step3Text" runat="server" Text="Gift Wrap" NavigateUrl="~/Checkout/GiftOptions.aspx"></asp:HyperLink></span></span>
        <span ID="Step4" runat="server" class="off"><span><asp:HyperLink ID="Step4Text" runat="server" Text="Payment" NavigateUrl="~/Checkout/Payment.aspx"></asp:HyperLink></span></span>
    </div>
    <asp:PlaceHolder ID="PHNavFooter" runat="server" Visible="false" EnableViewState="false">
    </nav>
    </asp:PlaceHolder>
</div>