<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.ProductAccessoriesGrid" EnableViewState="false" CodeFile="ProductAccessoriesGrid.ascx.cs" %>
<%--
<conlib>
<summary>Display Upsell/Accessory products of a product. This page is normally displayed when a product that has Upsell/Accessories gets added to cart.</summary>
<param name="Caption" default="Consider purchasing for the {0}">Caption / Title of the control</param>
<param name="Size" default="6">The maximum number of products that are shown.</param>
<param name="Columns" default="3">The number of columns to display in the grid.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<div class="productAccessoriesPage">
<div class="section">
    <div class="pageHeader">
        <h1 class="heading"><asp:Localize ID="CaptionLabel" runat="server" Text="Consider purchasing for the {0}"></asp:Localize></h1>
    </div>
    <div class="content">
        <p>
			<asp:Label runat="server" ID="InstructionText" Text="You just added '{0}' to your cart. Here are some additional items you might consider.." ></asp:Label>
        </p>    
		<div class="productAccessorriesListing">
			<div class="itemListingContainer">
				<cb:ExDataList ID="ProductList" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Width="100%" DataKeyField="ProductId" CssClass="itemListing" SkinID="ItemGrid">
					<ItemStyle HorizontalAlign="center" VerticalAlign="bottom" Width="33%" CssClass="tableNode" />
					<ItemTemplate>
						<div class="itemContainer">
							<uc1:ProductItemDisplay ID="ProductItemDisplay1" runat="server" Item='<%# Eval("ChildProduct")%>' ShowManufacturer="true" ShowRating="true" ShowAddToCart="true" />
						</div>
					</ItemTemplate>
				</cb:ExDataList>
			</div>
		</div>
		<div class="actions">
            <span class="checkout">            
			    <asp:HyperLink ID="KeepShoppingLink" runat="server" NavigateUrl="~/Default.aspx" Text="<< Keep Shopping" CssClass="button"></asp:HyperLink>
            </span>
		</div>
	</div>
</div>
</div>
