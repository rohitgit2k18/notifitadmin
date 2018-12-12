<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.PopularProductsDialog" CodeFile="PopularProductsDialog.ascx.cs" %>
<%--
<conlib>
<summary>Display top seller products.</summary>
<param name="Columns" default="1">The number of columns to display.</param>
<param name="Caption" default="Top Sellers">Caption / Title of the control</param>
<param name="MaxItems" default="3">The maximum number of products that can be shown.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<div id="phContent" runat="server" class="widget popularProductsDialogWidget">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="CaptionLabel" runat="server" Text="Top Sellers" /></h2>
        </div>   
        <div class="content"> 
            <div class="popularProductsListing">
		        <div class="itemListingContainer">
                    <cb:ExDataList ID="ProductList" runat="server" RepeatColumns="1" RepeatDirection="Horizontal" Width="100%" CssClass="itemListing" SkinID="ItemList" >
                        <ItemStyle HorizontalAlign="center" CssClass="tableNode" />
                        <ItemTemplate>
                            <div class="itemContainer">
					            <uc1:ProductItemDisplay ID="ProductItemDisplay1" runat="server" Item='<%#(CommerceBuilder.Products.Product)Container.DataItem%>' ShowManufacturer="false" ShowRating="false" ShowAddToCart="true" />
				            </div>   
                        </ItemTemplate>
                    </cb:ExDataList>
                </div>
            </div>
       </div>
    </div>
</div>
