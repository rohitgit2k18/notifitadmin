<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductSpecialsDialog.ascx.cs" Inherits="AbleCommerce.ConLib.ProductSpecialsDialog" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<%--
<conlib>
<summary>Displays product specials</summary>
<param name="Caption" default="Product Specials">The caption / title of the control</param>
<param name="Columns" default="1">The number of columns to display in the grid.</param>
<param name="MaxItems" default="3">The maximum number of product specials that can be shown.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc2" %>

<div class="widget productSpecialsDialog">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="CaptionLabel" runat="server" Text="Product Specials"></asp:Localize></h2>
        </div>
        <div class="content">
          <div class="productSpecialsListing">
			<div class="itemListingContainer">			
                <cb:ExDataList ID="ProductList" runat="server" RepeatColumns="1" RepeatDirection="Horizontal" Width="100%" DataKeyField="ProductId" SkinID="ItemGrid">
                    <ItemTemplate>
	                    <div class="itemContainer">
                            <uc2:ProductItemDisplay ID="SpecialsItem" runat="server" Item='<%#(CommerceBuilder.Products.Product)Container.DataItem%>' ShowImage="true" ImageType="THUMBNAIL" ShowPrice="true" ShowSku="false" ShowManufacturer="true" ShowRating="true" ShowAddToCart="true"  />
					    </div>
                    </ItemTemplate>
                </cb:ExDataList>
            </div>
        </div>
    </div>
</div>
</div>