<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Mobile.UserControls.FeaturedProducts" EnableViewState="false" CodeFile="FeaturedProducts.ascx.cs" %>
<%--
<conlib>
<summary>Displays featured items in a category.</summary>
<param name="Caption" default="Featured Items">Possible value can be any string.  Title of the control.</param>
<param name="Size" default="3">Possible value cab be any integer greater then zero. Indicates that at maximum how many items can be shown.</param>
<param name="Columns" default="2">Possible value cab be any integer greater then zero. Indicates that the grid will contain how much columns.</param>
<param name="IncludeOutOfStockItems" default="false">Possible values be true of false. Indicates that the grid will display out of sctock items or not.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc2" %>
<div class="featuredProductsGrid">
<div class="section">
<div class="header">
<h2><asp:Localize ID="CaptionLabel" runat="server" Text="Featured Products"></asp:Localize></h2>
</div>
<div class="content">
<div class="itemList">
<asp:Repeater ID="ProductList" runat="server">
<ItemTemplate>
<div class="itemNode <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
<uc2:ProductItemDisplay ID="FeaturedItem" runat="server" Item='<%#(CommerceBuilder.Products.Product)Container.DataItem%>' ShowImage="true" ImageType="THUMBNAIL" ShowPrice="true" ShowSku="false" ShowManufacturer="false" ShowRating="true" ShowAddToCart="true" ClientIDMode="Predictable" />
</div>
</ItemTemplate>
</asp:Repeater>
</div>
</div>
</div>
</div>