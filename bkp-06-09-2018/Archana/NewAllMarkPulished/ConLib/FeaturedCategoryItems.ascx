<%@ Control Language="C#" Inherits="AbleCommerce.ConLib.FeaturedCategoryItems" CodeFile="FeaturedCategoryItems.ascx.cs" %>
<%--
<conlib>
<summary>Displays featured items in a category.</summary>
<param name="IncludeOutOfStockItems" default="False">If true out of stock items are also included for display</param>
<param name="Caption" default="Featured Items">The caption / title of the control</param>
<param name="MaxItems" default="3">The maximum number of featured items that can be shown.</param>
<param name="Columns" default="3">The number of columns to display in the grid.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc2" %>

<div id="phContent" runat="server" class="widget featuredCategoryItems">
    <div class="innerSection">
        <div class="header">
            <h2><asp:localize ID="phCaption" runat="server" Text="Featured Items"></asp:localize></h2>
        </div>
        <div class="content">
            <div class="featuredCategoryItemsListing">
			    <div class="itemListingContainer">
                    <asp:DataList ID="ProductList" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Width="100%" DataKeyField="ProductId" CssClass="itemListing" >
                        <ItemStyle HorizontalAlign="center" CssClass="tableNode" />
                        <ItemTemplate>
                            <div class="itemContainer">
                                <uc2:ProductItemDisplay ID="Thumbnail" runat="server" Item='<%#(CommerceBuilder.Products.Product)Container.DataItem%>' ShowImage="true" ImageType="THUMBNAIL" ShowPrice="false" ShowSku="false" ShowManufacturer="false" ShowRating="false"  />
                            </div>
                        </ItemTemplate>            
                    </asp:DataList>
                </div>
            </div>
        </div>
    </div>
</div>
