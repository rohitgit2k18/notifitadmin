<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.AddToCartLink" CodeFile="AddToCartLink.ascx.cs" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>The common control used for creating an add-to-cart link for a product</summary>
<param name="ProductId">The ID of the product to add to the cart when the link is clicked.</param>
</conlib>
--%>
<asp:LinkButton ID="AC" runat="server" Text="+ Add to Cart" CausesValidation="false" CssClass="button"></asp:LinkButton>
<asp:HyperLink ID="MD" runat="server" Text="More Info" CssClass="button"></asp:HyperLink>