<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BillingAddress.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.mBillingAddress" %>
<%--
<UserControls>
<summary>Displays the user billing address for a specific order.</summary>
</UserControls>
--%>
<div class="widget billingAddressWidget">
    <div class="header">
	    <h2><asp:Localize ID="BillingAddressCaption" runat="server" Text="Billing Address"></asp:Localize></h2>
    </div>
    <div class="content">
        <div class="billingAddress">
            <asp:Literal ID="AddressData" runat="server"></asp:Literal>
        </div>
        <div class="editLink">
            <asp:LinkButton ID="EditAddressLink" runat="server" Text="Edit" EnableViewState="false" OnClick="EditAddressButton_Click" CssClass="button hyperLinkButton"></asp:LinkButton>
        </div>
    </div>
</div>