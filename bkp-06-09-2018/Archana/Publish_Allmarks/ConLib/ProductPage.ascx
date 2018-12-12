<%@ Control Language="C#" AutoEventWireup="True" CodeFile="ProductPage.ascx.cs" Inherits="AbleCommerce.ConLib.ProductPage" %>
<%--
<conlib>
<summary>Control that implements the product detail page</summary>
<param name="OptionsView" default="DROPDOWN">Indicates whether the product options will be displayed as dropdowns or you want to show variants in a grid. Possible values are 'DROPDOWN' and 'TABULAR'</param>
<param name="ShowVariantThumbnail" default="False">If true thumbnails will be shown for variants. This setting only works for 'TABULAR' view.</param>
<param name="ShowAddAndUpdateButtons" default="False">If true inventory is add button will be shown while editing basket items.</param>
<param name="ShowPartNumber" default="False">If true Part/Model number is displayed.</param>
<param name="GTINName" default="GTIN">Indicates the display name. Possible values are 'GTIN', 'UPC' and 'ISBN'.</param>
<param name="ShowGTIN" default="False">If true GTIN number is displayed.</param>
<param name="DisplayBreadCrumbs" default="True">Indicates whether the breadcrumbs should be displayed or not, default value is true.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/CategoryBreadCrumbs.ascx" tagname="CategoryBreadCrumbs" tagprefix="uc1" %>
<%@ Register src="~/ConLib/ProductImage.ascx" tagname="ProductImage" tagprefix="uc2" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc3" %>
<%@ Register src="~/ConLib/ProductDescription.ascx" tagname="ProductDescription" tagprefix="uc4" %>
<%@ Register src="~/ConLib/MoreCategoryItems.ascx" tagname="MoreCategoryItems" tagprefix="uc5" %>
<%@ Register src="~/ConLib/ProductDiscountsDialog.ascx" tagname="ProductDiscountsDialog" tagprefix="uc6" %>
<%@ Register src="~/ConLib/BuyProductDialog.ascx" tagname="BuyProductDialog" tagprefix="uc7" %>
<%@ Register src="~/ConLib/BuyProductDialogOptionsList.ascx" tagname="BuyProductDialogOptionsList" tagprefix="uc8" %>
<%@ Register src="~/ConLib/ProductReviewsPanel.ascx" tagname="ProductReviewsPanel" tagprefix="uc9" %>
<%@ Register src="~/ConLib/RelatedProducts.ascx" tagname="RelatedProducts" tagprefix="uc10" %>
<div class="productDisplay">
<uc1:CategoryBreadCrumbs ID="CategoryBreadCrumbs1" runat="server" HideLastNode="false" />
<div class="pageHeader">
	<h1><asp:Label ID="ProductName" runat="server" EnableViewState="false" itemprop="name"></asp:Label></h1>
    <hr /> 
</div>
<div class="section">
	<div class="content">
	    <asp:Panel ID="ProductDetailsPanel" runat="server" CssClass="simpleProduct">
            <div class="productImageArea">
			    <uc2:ProductImage ID="ProductImage1" runat="server" ShowImage="Image" />
		    </div>
		    <div id="ProductDetailsArea" class="productDetails" runat="server" >
			    <%--<asp:PlaceHolder ID="ManufacturerDetails" runat="server"></asp:PlaceHolder>--%>
			    <uc6:ProductDiscountsDialog ID="ProductDiscountsDialog1" runat="server" />
			    <uc7:BuyProductDialog ID="BuyProductDialog1" runat="server" />
                <uc8:BuyProductDialogOptionsList ID="BuyProductDialogOptionsList1" runat="server" Visible="false" />
            </div>
        </asp:Panel>
	</div>
</div>
</div>
<div style="clear:both;"></div>
<a name="desc"></a>
<div id="tabs" class="col-md-6">
    <ul id="tabStrip" runat="server" class="hiddenPanel">
        <li id="descTab" runat="server" clientidmode="Static" class="active"><a href="#descPane" class="tab">DESCRIPTION</a></li>
        <li id="detailsTab" runat="server" clientidmode="Static"><a href="#detailsPane" class="tab">DETAILS</a></li>
        <li id="downloadsTab" runat="server" clientidmode="Static"><a href="#downloadsPane" class="tab">DOWNLOADS</a></li>
    </ul>
    <div class="tab-content">
    <div id="descPane" runat="server" clientidmode="Static" class="tab-pane active">
        <uc4:ProductDescription ID="ProductDescription1" runat="server" ShowCustomFields="true" />
    </div>
    <div id="detailsPane" runat="server" clientidmode="Static" class="tab-pane">
        <div class="widget extendedDescriptionWidget">
            <div class="content">
                <asp:Literal ID="ExtendedDescription" runat="server"></asp:Literal>
            </div>
        </div>
    </div>
    <div id="downloadsPane" runat="server" clientidmode="Static" class="tab-pane">
        <div class="widget downloadsWidget">
            <div class="content">
                <asp:Literal ID="Downloads" runat="server"></asp:Literal>
            </div>
        </div>
    </div>
    <div id="reviewsPane" visible="false" runat="server" clientidmode="Static" class="tab-pane">
        <uc9:ProductReviewsPanel ID="ProductReviewsPanel1" runat="server" />
    </div>
    </div>
</div>

    <div id="tabs2" class="col-md-6">
        <ul id="Ul1" runat="server" class="nav nav-tabs nav-tabs-justified">
            <li id="Li1" runat="server" clientidmode="Static" class="active"><asp:Localize ID="MoreItemsTabText" runat="server" Text="MORE ITEMS IN {0}" EnableViewState="false"></asp:Localize></li>
        </ul>
        <div class="tab-content">
            <div id="moreItemsPane" runat="server" clientidmode="Static" class="tab-pane active">
                <uc5:MoreCategoryItems ID="MoreCategoryItems1" runat="server" Orientation="Horizontal" MaxItems="4" DisplayMode="Sequential" />
            </div>
        </div>
    </div>
<asp:PlaceHolder ID="jqTabs" runat="server" EnableViewState="false">
<script>
    $(function () {
        $("#tabs").tabs();
        $("#tabs ul").removeClass("hiddenPanel");
    });
</script>
</asp:PlaceHolder>
<asp:PlaceHolder ID="bsTabs" runat="server" Visible="false" EnableViewState="false">
<script>
    $('#tabs ul.nav-tabs a').click(function (e) {
        e.preventDefault()
        $(this).tab('show')
    })

    function resizeHeight() {
        $('#moreItemsPane .itemContainer').each(function () {
            $(this).attr("style", "");
        });
        $('#moreItemsPane .itemContainer').equalHeights();
    }

    resizeHeight();

    window.onresize = function (event) {
        resizeHeight();
    };

</script>
</asp:PlaceHolder>