<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.Mobile.UserControls.ProductImageControl" ViewStateMode="Disabled" EnableViewState="true"
    CodeFile="ProductImage.ascx.cs" %>
<%--
<conlib>
<summary>Displays one of the specified product image.</summary>
<param name="ShowImage" default="Thumbnail">Possible values are 'Thumbnail' or 'Icon' or 'Image'.  Indicates which product image should be displayed.</param>
<param name="Product">The prouct to display the image for. If not specified then it will look into query string for a ProductId parameter.</param>
</conlib>
--%>
<div class="imageArea">
    <div class="mainImageArea">
        <div class="mainImage">
            <asp:Image ID="ProductImage" runat="server" BorderWidth="0" CssClass="productImage" ClientIDMode="Static" />
            <asp:Image ID="NoIcon" runat="server" SkinID="NoIcon" Visible="false" EnableViewState="false" CssClass="productImage"/>
            <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible="false" EnableViewState="false" CssClass="productImage"/>
            <asp:Image ID="NoImage" runat="server" Width="300" Height="300" SkinID="NoImage" Visible="false" EnableViewState="false" CssClass="productImage"/>
        </div>
    </div> 
    <asp:Panel ID="MoreImagesPanel" runat="server" CssClass="moreImagesArea">
        <asp:HyperLink ID="MoreImages" runat="server" Text="More Images >" NavigateUrl="#"></asp:HyperLink>
    </asp:Panel>
</div>
