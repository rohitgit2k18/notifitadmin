<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.ProductImageControl" ViewStateMode="Disabled" EnableViewState="true"
    CodeFile="ProductImage.ascx.cs" %>
<%--
<conlib>
<summary>Displays one of the specified product image.</summary>
<param name="ShowImage" default="thumbnail">The image to display. Possible values are icon, thumbnail, image.</param>
<param name="ThumbnailClickInstructionText" default="click on thumbnail to zoom">The text for the instruction text link for cliking thumbnail</param>
<param name="Product">The prouct to display the image for. If not specified then it will look into query string for a ProductId parameter.</param>
</conlib>
--%>
<script language="javascript" type="text/javascript">
    $(document).ready(function () {
        $(".fancybox-thumbs").fancybox();
        $(".thumbnailImage").hover(function () {
            var thumb = $(this).parent();
            var src = $(thumb).attr("rel");
            var href = $(thumb).attr("href");
            $(".productImage").each(function (i) {
                $(this).attr("src", src);
                $('#ProductImageUrl').attr("href", href);
                $(this).unbind("click", mainImageClick);
                $(this).bind("click", { thumbId: $(thumb).attr('id') }, mainImageClick);
            });
        });

    });

    function mainImageClick(event) {
        $("#" + event.data.thumbId).trigger("click");
    }
</script>
<div class="mainImageArea" >
   <div class="mainImageWrapper">
       <div class="mainImage">
            <a id="ProductImageUrl" runat="server" class="fancybox-thumbs" data-fancybox-group="thumb" ClientIDMode="Static">
                <asp:Image ID="ProductImage" runat="server" BorderWidth="0" CssClass="productImage" ClientIDMode="Static" itemprop="image" />
            </a>
            <asp:Image ID="NoIcon" runat="server" SkinID="NoIcon" Visible="false" EnableViewState="false" CssClass="productImage"/>
            <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible="false" EnableViewState="false" CssClass="productImage"/>
            <asp:Image ID="NoImage" runat="server" Width="300" Height="300" SkinID="NoImage" Visible="false" EnableViewState="false" CssClass="productImage"/>
       </div>
   </div>
</div> 
<asp:PlaceHolder ID="phAdditionalImages" runat="server" EnableViewState="false">
    <div class="additionalImages">
        <div class="thumbnailsList">
           <asp:Repeater ID="MoreImagesList" runat="server" OnItemCreated="MoreImagesList_OnItemCreated">
            <HeaderTemplate>
                <ul>
            </HeaderTemplate>
            <ItemTemplate>
                <li><a ID="miAnchor" runat="server" rel='<%#GetResizedImage(Eval("ImageUrl").ToString())%>' class="fancybox-thumbs" data-fancybox-group="thumb" title='<%#Eval("ImageAltText")%>' href='<%#GetLargeImageUrl(Eval("ImageUrl").ToString())%>'><div class="thumbnailImage"><img runat="server" ID="miImage" alt='<%#Eval("ImageAltText")%>' src='<%#GetThumbnailUrl(Eval("ImageUrl").ToString())%>' class="thumbnail"/></div></a></li>
            </ItemTemplate>
            <FooterTemplate>
                </ul>
                <br />
            </FooterTemplate>
            </asp:Repeater>
           <div class="clear"></div>
           <%--<asp:Label ID="InstructionTextLabel" runat="server" Visible="false" Text="click on thumbnail to zoom"></asp:Label>--%>
        </div>
    </div> 
</asp:PlaceHolder>