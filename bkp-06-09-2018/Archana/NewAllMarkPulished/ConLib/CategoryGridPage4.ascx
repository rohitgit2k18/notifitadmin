<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.CategoryGridPage4" CodeFile="CategoryGridPage4.ascx.cs" %>
<%--
<conlib>
<summary>A category page that displays all contents in a grid format.  This page displays products, webpages, and links.</summary>
<param name="Cols" default="3">The number of columns to display</param>
<param name="MaximumSummaryLength" default="250">Maximum characters to display for summary</param>
<param name="PagingLinksLocation" default="BOTTOM">Indicates where the paging links will be displayd, possible values are "TOP", "BOTTOM" and "TOPANDBOTTOM".</param>
<param name="DisplayBreadCrumbs" default="True">Indicates wheather the breadcrumbs should be displayed or not, default value is true.</param>
<param name="DefaultCaption" default="Catalog">Caption text that will be shown as caption when root category will be browsed.</param>
<param name="ShowSummary" default="False">Indicates wheather the summary should be displayed or not, default value is false.</param>
<param name="ShowDescription" default="True">Indicates wheather the description should be displayed or not, default value is true.</param>
</conlib>
--%>
<%@ Register Src="~/ConLib/CategoryBreadCrumbs.ascx" TagName="CategoryBreadCrumbs" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/CategorySearchSidebar.ascx" TagName="CategorySearchSidebar" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/AddToCartLink.ascx" TagName="AddToCartLink" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<%@ Register src="~/ConLib/Utility/WebpageItemDisplay.ascx" tagname="WebpageItemDisplay" tagprefix="uc2" %>
<%@ Register src="~/ConLib/Utility/LinkItemDisplay.ascx" tagname="LinkItemDisplay" tagprefix="uc3" %>
<%@ Register src="~/ConLib/Utility/CategoryItemDisplay.ascx" tagname="CategoryItemDisplay" tagprefix="uc4" %>
<%@ Register src="~/ConLib/Utility/SimpleSearch.ascx" tagname="SimpleSearch" tagprefix="uc" %>

<script type="text/javascript">
    $(document).ready(function () {
        $('.product-info').mouseover(function () {
            var id = $(this).parent().parent().attr("id");
            var idName = id+"_CategoryItem_SummaryPanel"
            var idSummary = id+"_CategoryItem_NamePanel";
            $("#" + idName).css({ 'visibility': 'hidden' });
            $("#" + idSummary).css({ 'visibility': 'hidden' });
        }).mouseleave(function () {
            var id = $(this).parent().parent().attr("id");
            var idName = id + "_CategoryItem_SummaryPanel"
            var idSummary = id + "_CategoryItem_NamePanel";
            $("#" + idName).css({ 'visibility': 'visible' });
            $("#" + idSummary).css({ 'visibility': 'visible' });
        });
    });
</script>

<div id="categoryGridPage4">
	<div class="section">
		<uc:CategoryBreadCrumbs id="CategoryBreadCrumbs1" runat="server" HideLastNode="True" />
	</div>
    <div class="section-wrapper">
        <div class="col-md-6">
	        <div class="section">
		        <div class="pageHeader">
			        <h1><asp:Literal ID="Caption" runat="server" EnableViewState="False"></asp:Literal></h1>
		        </div>
	        </div>
	        <asp:PlaceHolder ID="CategoryHeaderPanel" runat="server" EnableViewState="false"></asp:PlaceHolder>

            <asp:PlaceHolder ID="CategorySummaryPanel" runat="server" EnableViewState="false">
	        <div class="section">
                <div class="content">
			        <asp:Literal ID="CategorySummary" runat="server" EnableViewState="false"></asp:Literal>
		        </div>
            </div>
            </asp:PlaceHolder>
	        <asp:PlaceHolder ID="CategoryDescriptionPanel" runat="server" EnableViewState="false">
	        <div class="section">
		        <div class="content">
		        <asp:Literal ID="CategoryDescription" runat="server" Text="" EnableViewState="false" />		
		        </div>
	        </div>
	        </asp:PlaceHolder>
            <div class="section">
                <div class="search">
                    <uc:SimpleSearch ID="SimpleSearch2" runat="server"/>
                </div>
            </div>
        </div>
        <div class="col-md-6 text-center">
            <div class="section">
                <div class="content">
		            <asp:Image ID="CategoryThumbnail" runat="server" CssClass="display-img" ImageUrl='<%#Eval("path") %>'></asp:Image>	
		        </div>
            </div>
        </div>
    </div>
    <div class="fullWidth">
    <asp:UpdatePanel ID="SearchResultsAjaxPanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
			<!--<div class="section searchSortHeader">
				<div class="content">
					<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<tr>
						<td align="left">
                            <div class="sortPanel">
							    <asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="SortResults"></asp:Label>&nbsp;
							    <asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" EnableViewState="false">
                                    <asp:ListItem Text="Default" Value="OrderBy ASC, Name ASC"></asp:ListItem>
								    <asp:ListItem Text="Featured" Value="Featured ASC"></asp:ListItem>
								    <asp:ListItem Text="By Name (A -> Z)" Value="Name ASC"></asp:ListItem>
								    <asp:ListItem Text="By Name (Z -> A)" Value="Name DESC"></asp:ListItem>
								    <asp:ListItem Text="By Price (Low to High)" Value="Price ASC"></asp:ListItem>
								    <asp:ListItem Text="By Price (High to Low)" Value="Price DESC"></asp:ListItem>                                
                                    <asp:ListItem Text="By Manufacturer (A -> Z)" Value="Manufacturer ASC"></asp:ListItem>
                                    <asp:ListItem Text="By Manufacturer (Z -> A)" Value="Manufacturer DESC"></asp:ListItem>
							    </asp:DropDownList>
                            </div>
                            <asp:Panel ID="PageSizePanel" runat="server" CssClass="pageSizePanel">
                                <asp:Label ID="PageSizeLabel" runat="server" Text="Display:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="PageSizeOptions"></asp:Label>&nbsp;
						        <asp:DropDownList ID="PageSizeOptions" runat="server" AutoPostBack="true" CssClass="pageSizeOptions" EnableViewState="false">
							        <asp:ListItem Text="12 Items" Value="12" Selected="True"></asp:ListItem>
							        <asp:ListItem Text="24 Items" Value="24"></asp:ListItem>
							        <asp:ListItem Text="48 Items" Value="48"></asp:ListItem>
						        </asp:DropDownList>
                            </asp:Panel>
						</td>
                        <td align="right">
							<span><asp:Localize ID="ResultIndexMessage" runat="server" Text="Displaying {0} - {1} of {2} results" EnableViewState="false"></asp:Localize></span>
						</td>
					</tr>
					</table>
				</div>
            </div>-->

            <asp:PlaceHolder ID="phCategoryContents" runat="server">            
                <div class="catalogWrapper">
                    <asp:PlaceHolder ID="PagerPanelTop" runat="server">
                        <div class="pagingPanel">
                            <asp:Repeater ID="PagerControlsTop" runat="server" OnItemCommand="PagerControls_ItemCommand" EnableViewState="true">
                                <ItemTemplate>
                                    <a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </asp:PlaceHolder>
					<div class="categoryGridListing4">
					<div class="itemListingContainer">
                    <cb:ExDataList ID="CatalogNodeList" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Width="100%" 
                        DataKeyField="CatalogNodeId" CssClass="itemListing" EnableViewState="false" HorizontalAlign="Left" SkinID="ItemList">
                        <ItemStyle HorizontalAlign="center" VerticalAlign="top" Width="33%" CssClass="tableNode" />
                        <ItemTemplate>
                            <div class="itemContainer">
                                    <div class="product-info">
                                        <div class="display-info">
                                            <asp:Literal ID="CategoryItemName" runat="server" Text='<%# GetCategoryName(Container.DataItem) %>' />
                                        </div>
                                        <div>
                                            <asp:HyperLink ID="CategoryItemUrl" runat="server" NavigateUrl='<%# GetCategoryUrl(Container.DataItem) %>' CssClass="tab" Text="Contact Us">
                                                <input type="button" class="btn-success view-product" value="VIEW PRODUCTS" />
                                            </asp:HyperLink>
                                        </div>
                                    </div>
                                    <uc1:ProductItemDisplay ID="ProductItem" runat="server" ShowRating="true" ShowAddToCart="false" ShowSummary="true" Item='<%# GetProduct(Container.DataItem) %>' ShowManufacturer="true" />
                                    <uc2:WebpageItemDisplay ID="WebpageItem" runat="server" ShowSummary="true" Item='<%# GetWebpage(Container.DataItem) %>' />
                                    <uc3:LinkItemDisplay ID="LinkItem" runat="server" ShowSummary="true" Item='<%# GetLink(Container.DataItem) %>' />
                                    <uc4:CategoryItemDisplay ID="CategoryItem" runat="server" ShowSummary="true" Item='<%# GetCategory(Container.DataItem) %>' />
                            </div>
                        </ItemTemplate>
                    </cb:ExDataList>
					</div>
					</div>
                    <asp:PlaceHolder ID="PagerPanel" runat="server">
                        <div class="pagingPanel">
                            <asp:Repeater ID="PagerControls" runat="server" OnItemCommand="PagerControls_ItemCommand" EnableViewState="true">
                                <ItemTemplate>
                                    <a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </asp:PlaceHolder>                    
                </div>
                <asp:HiddenField ID="HiddenPageIndex" runat="server" Value="0" />
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="phEmptyCategory" runat="server" Visible="false" EnableViewState="false">
                <div class="noResultsPanel">
                    <asp:Localize ID="EmptyCategoryMessage" runat="server" Text="The category is empty." EnableViewState="false"></asp:Localize>
                </div>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="phNoSearchResults" runat="server" Visible="false" EnableViewState="false">
                <div class="noResultsPanel">
                    <asp:Localize ID="NoSearchResults" runat="server" Text="No products match your search criteria." EnableViewState="false"></asp:Localize>
                </div>
            </asp:PlaceHolder>
        </ContentTemplate>
    </asp:UpdatePanel>
    </div>
</div>
