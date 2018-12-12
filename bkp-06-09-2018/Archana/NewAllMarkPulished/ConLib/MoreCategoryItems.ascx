<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.MoreCategoryItems" CodeFile="MoreCategoryItems.ascx.cs" %>
<%--
<conlib>
<summary>Displays other products in the same category.</summary>
<param name="Caption" default="Also in Category">Caption / Title of the control</param>
<param name="MaxItems" default="3">The maximum number of products that can be shown.</param>
<param name="DisplayMode" default="SEQUENTIAL">Possible values are 'SEQUENTIAL' or 'RANDOM'. Indicates whether the contents will be selected randomly or in sequence.</param>
<param name="Columns" default="3">The number of columns to display in the grid.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc2" %>
<div id="phContent" runat="server" class="widget moreCategoryItems">
    <div class="innerSection">
        <div class="content">
            <div class="moreCategoryItemsListing">
			    <div class="itemListingContainer">
                    <cb:ExDataList ID="ProductList" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Width="100%" DataKeyField="ProductId" CssClass="itemListing" SkinID="ItemList" >
                        <ItemTemplate>
                            <div class="itemContainer">
                                <uc2:ProductItemDisplay ID="Thumbnail" runat="server" Item='<%#(CommerceBuilder.Products.Product)Container.DataItem%>' ShowImage="true" ImageType="THUMBNAIL" ShowPrice="false" ShowSku="false" ShowManufacturer="false" ShowRating="false" ShowAddToCart="false" />
                            </div>
                        </ItemTemplate>
                    </cb:ExDataList>
                </div>
            </div>
        </div>
    </div>
</div>