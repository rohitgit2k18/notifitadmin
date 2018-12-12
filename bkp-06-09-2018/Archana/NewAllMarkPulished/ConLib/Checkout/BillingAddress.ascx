<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BillingAddress.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.BillingAddress" EnableViewState="false" %>
<%--
<conlib>
<summary>Displays the billing address</summary>
</conlib>
--%>
<div class="widget billingAddressWidget">
    <div class="innerSection">
        <div class="header">
	        <h2><asp:Localize ID="BillingAddressCaption" runat="server" Text="Billing Address"></asp:Localize></h2>
        </div>
        <div class="content">
            <div class="billingAddress">
                <asp:Literal ID="AddressData" runat="server"></asp:Literal>
            </div>
        </div>
    </div>
</div>