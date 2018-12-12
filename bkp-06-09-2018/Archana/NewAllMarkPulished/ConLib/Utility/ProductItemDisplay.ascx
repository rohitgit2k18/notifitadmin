<%@ Control Language="C#" AutoEventWireup="True" CodeFile="ProductItemDisplay.ascx.cs" Inherits="AbleCommerce.ConLib.Utility.ProductItemDisplay" EnableViewState="true" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays a product item</summary>
<param name="ShowImage" default="True">If true product image is displayed</param>
<param name="ImageType" default="THUMBNAIL">The type of image to display. Valid values are THUMBNAIL, ICON and IMAGE</param>
<param name="ShowPrice" default="True">If true price is displayed</param>
<param name="ShowSku" default="True">If true SKU is displayed</param>
<param name="ShowManufacturer" default="False">If true manufacturer is displayed</param>
<param name="ShowRating" default="True">If true rating stars are displayed</param>
<param name="ShowSummary" default="False">If true summary text is displayed</param>
<param name="ShowAddToCart" default="False">If true add-to-cart button is displayed</param>
<param name="MaxSummaryLength" default="-1">Maximum number of characters to display for summary. Value of 0 or less means no restriction.</param>
<param name="Item" default="Null">Product item to display</param>
</conlib>
--%>

<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/AddToCartLink.ascx" TagName="AddToCartLink" TagPrefix="uc" %>

<div class="productItemDisplay"> 
   <asp:Panel ID="ThumbnailPanel" runat="server" CssClass="thumbnailArea">
       <div class="thumbnailWrapper"> 
         <div class="thumbnail">
            <asp:HyperLink ID="ProductThumbnailLink" runat="server" NavigateUrl="#">
                <asp:Image ID="ProductThumbnail" runat="server" />
                <asp:Image ID="NoIcon" runat="server" SkinID="NoIcon" Visible="false" EnableViewState="false" />
                <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible="false" EnableViewState="false" />
                <asp:Image ID="NoImage" runat="server" SkinID="NoImage" Visible="false" EnableViewState="false" />
            </asp:HyperLink>
         </div> 
      </div> 
   </asp:Panel>
   <div class="detailsArea"> 
     <div class="details">
        <asp:Panel ID="NamePanel" runat="server" CssClass="itemName">
            <asp:HyperLink ID="ProductName" runat="server"></asp:HyperLink>
        </asp:Panel>
        <asp:Panel ID="ManufacturerPanel" runat="server" CssClass="manufacturer">
            <asp:HyperLink ID="ProductManufacturer" runat="server" NavigateUrl="#"></asp:HyperLink>
        </asp:Panel>
        <asp:Panel ID="SkuPanel" runat="server" CssClass="sku">
            <asp:Label ID="ProductSku" runat="server"></asp:Label>
        </asp:Panel>
        <asp:Panel ID="RatingPanel" runat="server" CssClass="rating">
            <uc1:ProductRatingStars ID="ProductRating" runat="server"/>
        </asp:Panel>
        <asp:Panel ID="PricePanel" runat="server" CssClass="price"> 
            <uc:ProductPrice ID="ProductPrice" runat="server" PriceFormat="<span class='label'>Price:</span> <span class='value'>{0}</span>" BasePriceFormat='Price: <span class="msrp">{0}</span> '></uc:ProductPrice>
        </asp:Panel>
        <asp:Panel ID="SummaryPanel" runat="server" CssClass="summary">
            <asp:Label ID="ProductSummary" runat="server"></asp:Label>
        </asp:Panel> 
     </div> 
  </div> 
 <asp:Panel ID="ActionsPanel" runat="server" CssClass="actionsArea">
	<div class="actions">
		<uc:AddToCartLink ID="ProductAddToCart" runat="server" />
	</div>
 </asp:Panel>
</div>
