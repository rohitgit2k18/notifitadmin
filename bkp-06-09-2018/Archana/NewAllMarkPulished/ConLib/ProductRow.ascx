<%@ Control Language="C#" AutoEventWireup="True" CodeFile="ProductRow.ascx.cs" Inherits="AbleCommerce.ConLib.ProductRow" %>
<%--
<conlib>
<summary>Control that implements the product detail page. Instead of tabs, separate rows are used to display different sections of information.</summary>
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
<div class="productRowDisplay">
<uc1:CategoryBreadCrumbs ID="CategoryBreadCrumbs1" runat="server" HideLastNode="false" />
    <div class="pageHeader">
	    <h1><asp:Label ID="ProductName" runat="server" EnableViewState="false" itemprop="name"></asp:Label></h1> 
    </div>
    <div class="section">
	    <div class="content">
	        <table class="buyProductForm">
                <tr>
                    <td>
			            <uc2:ProductImage ID="ProductImage1" runat="server" ShowImage="Image" />
		            </td>
                </tr>
	            <tr>
		            <td>
			            <asp:PlaceHolder ID="ManufacturerDetails" runat="server"></asp:PlaceHolder>
			            <uc6:ProductDiscountsDialog ID="ProductDiscountsDialog1" runat="server" />
			            <uc7:BuyProductDialog ID="BuyProductDialog1" runat="server" />
                        <uc8:BuyProductDialogOptionsList ID="BuyProductDialogOptionsList1" runat="server" Visible="false" />
		            </td>
	            </tr>
	        </table>
         </div>
    </div>
</div>
<a name="desc"></a>
<uc4:ProductDescription ID="ProductDescription1" runat="server" ShowCustomFields="true" />
<uc9:ProductReviewsPanel ID="ProductReviewsPanel1" runat="server" />
<uc5:MoreCategoryItems ID="MoreCategoryItems1" runat="server" Caption="Also in {0}" Orientation="Horizontal" MaxItems="3" DisplayMode="Sequential" />
