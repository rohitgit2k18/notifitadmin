<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.RecentlyViewed" EnableViewState="false" CodeFile="RecentlyViewed.ascx.cs" %>
<%--
<conlib>
<summary>Displays a list or grid of recently viewed products.</summary>
<param name="Columns" default="1">The number of columns to display in the grid.</param>
<param name="Caption" default="Recently Viewed">Caption / Title of the control</param>
<param name="MaxItems" default="5">The maximum number of products that can be shown.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc2" %>
<div id="phContent" runat="server" class="widget recentlyViewedWidget">
    <div class="innerSection">
        <div class="header">
            <h2><asp:localize ID="phCaption" runat="server" Text="Recently Viewed"></asp:localize></h2>
        </div>
        <div class="content">
             <div class="recentlyViewedListing">
		        <div class="itemListingContainer">
                    <cb:ExDataList  ID="ProductList" runat="server" RepeatColumns="1" RepeatDirection="Horizontal" Width="100%" CssClass="itemListing" SkinID="ItemList">
                        <ItemStyle HorizontalAlign="center" CssClass="tableNode" />
                        <ItemTemplate>
                            <div class="itemContainer">
                                <uc2:ProductItemDisplay ID="ProductItemDisplay1" runat="server" Item='<%#(CommerceBuilder.Products.Product)Container.DataItem%>' ShowImage="true" ImageType="THUMBNAIL" ShowPrice="true" ShowSku="true" ShowManufacturer="false" ShowRating="false" ShowAddToCart="true" />
                            </div>
                        </ItemTemplate>
                    </cb:ExDataList>
                </div>
            </div>
        </div>
    </div>
</div>