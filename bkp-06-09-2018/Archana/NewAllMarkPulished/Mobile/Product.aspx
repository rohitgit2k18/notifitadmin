<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="True" CodeFile="Product.aspx.cs" Inherits="AbleCommerce.Mobile.ProductPage" ClientIDMode="AutoID"%>
<%@ Register src="~/Mobile/UserControls/NavBar.ascx" tagname="NavBar" tagprefix="uc1" %>
<%@ Register src="~/Mobile/UserControls/ProductImage.ascx" tagname="ProductImage" tagprefix="uc2" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc3" %>
<%@ Register src="~/Mobile/UserControls/ProductDiscountsDialog.ascx" tagname="ProductDiscountsDialog" tagprefix="uc6" %>
<%@ Register src="~/Mobile/UserControls/BuyProductDialog.ascx" tagname="BuyProductDialog" tagprefix="uc7" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<%@ Register src="~/Mobile/UserControls/SearchBox.ascx" tagname="SearchBox" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
<uc1:NavBar ID="NavBar" runat="server" />
<div id="productPage" class="productDisplay">
    <div class="pageHeader">
	    <h1><asp:Label ID="ProductName" runat="server" EnableViewState="false"></asp:Label></h1>
        <asp:PlaceHolder ID="phManufacturer" runat="server" Visible="false">
        <asp:HyperLink ID="ManufLink" runat="server" CssClass="manufName"></asp:HyperLink>
        </asp:PlaceHolder>
        <asp:Panel ID="RatingPanel" runat="server" CssClass="rating">
            <uc1:ProductRatingStars ID="ProductRating" runat="server" />
        </asp:Panel>
    </div>
    <div class="section">
	    <div class="content productMain">
            <uc2:ProductImage ID="ProductImage1" runat="server" ShowImage="Image" />            
            <uc6:ProductDiscountsDialog ID="ProductDiscountsDialog1" runat="server" />
            <uc7:BuyProductDialog ID="BuyProductDialog1" runat="server" />            	        
         </div>
    </div>
    <div class="section">
        <div class="header" id="descriptionHeader" runat="server">
            <h2>Description & Details</h2>
        </div>
        <div class="content descSummary">
                <span class="summary">
                    <asp:Label ID="ProductSummary" runat="server" EnableViewState="false"></asp:Label>
                </span>
                <asp:HyperLink ID="moreDetails" runat="server" CssClass="button" Text="More Details" />
        </div>  
    </div>
    
    <asp:Panel ID="ProductReviewsPanel" runat="server" CssClass="section">        
        <div class="header">
            <h2>Product Reviews</h2>
        </div>
        <div class="content reviewsSummary">
            <div class="inputForm">
                <div class="inlineField" id="averageRating" runat="server">
                    <span class="fieldHeader">
                        <asp:Localize ID="AverageRatingLocalize" runat="server" Text="Average Rating:"></asp:Localize>
                    </span>
                    <span class="fieldValue">
                        <uc1:ProductRatingStars ID="ProductRatingStars1" runat="server" />
                    </span>
                </div>
                <div class="inlineField" id="reviewsTotal" runat="server">
                    <span class="fieldHeader">
                        <asp:Localize ID="TotalReviewsLocalize" runat="server" Text="Total Reviews:"></asp:Localize>
                    </span>
                    <span class="fieldValue">
                        <asp:Localize ID="TotalReviews" runat="server" Text=" (based on {0} review{1})"></asp:Localize>
                    </span>
                </div>
                <asp:Panel ID="NoReviewsPanel" runat="server" Visible="false" CssClass="noReviewsPanel">
                    <asp:Label ID="NoReviewsMessage" runat="server" Text="Be the first to review this product!"></asp:Label>
                </asp:Panel>
                <div class="buttons">
                    <p><asp:HyperLink ID="MoreDetailsLink" runat="server" CssClass="button" NavigateUrl="#" Text="Read Reviews"></asp:HyperLink></p>
                </div>
            </div>
        </div>
    </asp:Panel>
</div>
</asp:Content>
<asp:Content ID="Content2" runat="server" ContentPlaceHolderID="PageHeader">
    <uc1:SearchBox ID="SearchBox1" runat="server" />
</asp:Content>
