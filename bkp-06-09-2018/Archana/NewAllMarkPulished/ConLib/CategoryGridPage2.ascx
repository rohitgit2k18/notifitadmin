<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.CategoryGridPage2" CodeFile="CategoryGridPage2.ascx.cs" %>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<%@ Register src="~/ConLib/Utility/WebpageItemDisplay.ascx" tagname="WebpageItemDisplay" tagprefix="uc2" %>
<%@ Register src="~/ConLib/Utility/LinkItemDisplay.ascx" tagname="LinkItemDisplay" tagprefix="uc3" %>
<%--
<conlib>
<summary>A category page that displays all products in a grid format.</summary>
<param name="Cols" default="3">The number of columns to display</param>
<param name="PagingLinksLocation" default="BOTTOM">Indicates where the paging links will be displayd, possible values are "TOP", "BOTTOM" and "TOPANDBOTTOM".</param>
<param name="DisplayBreadCrumbs" default="True">Indicates wheather the breadcrumbs should be displayed or not, default value is true.</param>
<param name="DefaultCaption" default="Catalog">Caption text that will be shown as caption when root category will be browsed.</param>
<param name="ShowSummary" default="False">Indicates wheather the summary should be displayed or not, default value is false.</param>
<param name="ShowDescription" default="False">Indicates wheather the description should be displayed or not, default value is false.</param>
</conlib>
--%>
<%@ Register Src="~/ConLib/CategoryBreadCrumbs.ascx" TagName="CategoryBreadCrumbs" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/CategorySearchSidebar.ascx" TagName="CategorySearchSidebar" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/AddToCartLink.ascx" TagName="AddToCartLink" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Utility/SimpleSearch.ascx" tagname="SimpleSearch" tagprefix="uc" %>

<div id="categoryGridPage2">
    <div class="section-wrapper">
	    <div class="section">
		    <uc:CategoryBreadCrumbs id="CategoryBreadCrumbs1" runat="server" HideLastNode="True" />
	    </div>
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
    <div class="searchResults">
		<asp:PlaceHolder ID="SubCategoryPanel" runat="server" EnableViewState="false">
		<div class="section subCategories">
			<div class="content">
				<asp:Repeater ID="SubCategoryRepeater" runat="server" EnableViewState="false">						
					<ItemTemplate>
						<span><asp:HyperLink ID="SubCategoryLink" runat="server" Text='<%#String.Format("{0} ({1})", Eval("Name"), Eval("ProductCount"))%>' NavigateUrl='<%#Eval("NavigateUrl")%>'></asp:HyperLink></span>
					</ItemTemplate>
				</asp:Repeater>
			</div>
		</div>
		</asp:PlaceHolder>

        <div class="section searchSortHeader">
			<div class="content">
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
				<tr>
					<td align="left">
                        <span class="display-results-text"><asp:Localize ID="ResultIndexMessage" runat="server" Text="Displaying items {0} - {1} of {2}" EnableViewState="false"></asp:Localize></span>
					</td>
                    <td align="right">
                        <div class="sortPanel">
							<asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="SortResults"></asp:Label>&nbsp;
							<asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" OnSelectedIndexChanged="SortResults_SelectedIndexChanged" EnableViewState="true">
                                <asp:ListItem Text="Default" Value="OrderBy ASC, Name ASC"></asp:ListItem>
								<asp:ListItem Text="Featured" Value="IsFeatured DESC, OrderBy ASC, Name ASC"></asp:ListItem>
							    <asp:ListItem Text="By Name (A -> Z)" Value="Name ASC"></asp:ListItem>
							    <asp:ListItem Text="By Name (Z -> A)" Value="Name DESC"></asp:ListItem>
							    <asp:ListItem Text="By Price (Low to High)" Value="Price ASC"></asp:ListItem>
							    <asp:ListItem Text="By Price (High to Low)" Value="Price DESC"></asp:ListItem>                            
                                <asp:ListItem Text="By Manufacturer (A -> Z)" Value="Manufacturer ASC"></asp:ListItem>
                                <asp:ListItem Text="By Manufacturer (Z -> A)" Value="Manufacturer DESC"></asp:ListItem>
							</asp:DropDownList>
                        </div>
                        <asp:Panel ID="PageSizePanel" runat="server" CssClass="pageSizePanel">
                            <asp:Label ID="PageSizeLabel" runat="server" Text="Display:" CssClass="fieldHeader" AssociatedControlID="PageSizeOptions"></asp:Label>&nbsp;
						    <asp:DropDownList ID="PageSizeOptions" runat="server" AutoPostBack="true" CssClass="pageSizeOptions" EnableViewState="false">
							    <asp:ListItem Text="12 Items" Value="12" Selected="True"></asp:ListItem>
							    <asp:ListItem Text="24 Items" Value="24"></asp:ListItem>
							    <asp:ListItem Text="48 Items" Value="48"></asp:ListItem>
						    </asp:DropDownList>
                        </asp:Panel>
					</td>
				</tr>
				</table>
			</div>
        </div>
			
		<div class="catalogWrapper">
        <asp:PlaceHolder ID="phCategoryContents" runat="server">                
            <asp:PlaceHolder ID="PagerPanelTop" runat="server">
                <div class="pagingPanel">
	            <asp:Repeater ID="PagerControlsTop" runat="server" OnItemCommand="PagerControls_ItemCommand" EnableViewState="true">
	                <ItemTemplate>
		            <a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
	                </ItemTemplate>
	            </asp:Repeater>
                </div>
            </asp:PlaceHolder>
            <div class="categoryGridListing2">
            <div class="itemListingContainer">
                <cb:ExDataList ID="CatalogNodeList" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Width="100%" 
                    DataKeyField="ProductId" CssClass="itemListing" EnableViewState="false" HorizontalAlign="Left" SkinID="ItemList">
                    <ItemStyle HorizontalAlign="center" VerticalAlign="bottom" Width="33%" CssClass="tableNode" />
                    <ItemTemplate>
                        <div class="itemContainer">
                            <asp:HyperLink ID="CategoryItemUrl" runat="server" NavigateUrl='<%# GetProductUrl(Container.DataItem) %>' CssClass="product-anchor" Text="Contact Us">
                                <div class="product-info">
                                    <div class="display-info">
                                        <asp:Literal ID="ProductItemName" runat="server" Text='<%# GetProductName(Container.DataItem) %>' />
                                    </div>
                                    <div class="price-info">
                                        <asp:Literal ID="ProductPriceRange" runat="server" Text='<%# GetProductPrice(Container.DataItem) %>' />
                                    </div>
                                    <div>
                                        <input type="button" class="btn-success view-product" value="VIEW PRODUCT" />
                                    </div>
                                </div>
                            </asp:HyperLink>
                            <uc1:ProductItemDisplay ID="ProductItem" runat="server" ShowPrice="false" ShowSku="false" ShowSummary="false" ShowRating="false" ShowAddToCart="false" Item='<%#Container.DataItem%>' ShowManufacturer="false" />
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
        </div>
    </div>
</div>
