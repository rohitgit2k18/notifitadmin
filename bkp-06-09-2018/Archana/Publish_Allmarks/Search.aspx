<%@ Page Title="Search Page" Language="C#" MasterPageFile="~/Layouts/Fixed/LeftSidebar.Master" AutoEventWireup="True" CodeFile="Search.aspx.cs" Inherits="AbleCommerce.Search" %>
<%@ Register Src="~/ConLib/CategorySearchSidebar.ascx" TagName="CategorySearchSidebar" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/AddToCartLink.ascx" TagName="AddToCartLink" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<%@ Register src="ConLib/SimpleCategoryList.ascx" tagname="SimpleCategoryList" tagprefix="uc" %>

<asp:Content ID="PageContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="searchPage" class="mainContentWrapper">
    <div class="section">
		<div class="pageHeader">
			<h1>Search Products</h1>
		</div>
	</div>

	<div class="info">
		<asp:Label ID="ResultTermMessage" runat="server" Text="Search Results For '{0}'" EnableViewState="false" CssClass="message"></asp:Label>
	</div>

	<div class="section searchSortHeader">
		<div class="content">
			<table width="100%">
			<tr>
				<td align="left">
                    <div class="sortPanel">
					    <asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader"></asp:Label>&nbsp;
					    <asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" OnSelectedIndexChanged="SortResults_SelectedIndexChanged" EnableViewState="true">
						    <asp:ListItem Text="By Name (A -> Z)" Value="Name ASC"></asp:ListItem>
						    <asp:ListItem Text="By Name (Z -> A)" Value="Name DESC"></asp:ListItem>
						    <asp:ListItem Text="Featured" Value="IsFeatured DESC, Name ASC"></asp:ListItem>
						    <asp:ListItem Text="By Price (Low to High)" Value="Price ASC"></asp:ListItem>
						    <asp:ListItem Text="By Price (High to Low)" Value="Price DESC"></asp:ListItem>
                            <asp:ListItem Text="By Manufacturer (A -> Z)" Value="Manufacturer ASC"></asp:ListItem>
                            <asp:ListItem Text="By Manufacturer (Z -> A)" Value="Manufacturer DESC"></asp:ListItem>                            
					    </asp:DropDownList>
                    </div>
                    <asp:Panel ID="PageSizePanel" runat="server" CssClass="pageSizePanel">
                        <asp:Label ID="PageSizeLabel" runat="server" Text="Display:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="PageSizeOptions"></asp:Label>&nbsp;
						<asp:DropDownList ID="PageSizeOptions" runat="server" AutoPostBack="true" CssClass="sorting" EnableViewState="false">
							<asp:ListItem Text="12 Items" Value="12" Selected="True"></asp:ListItem>
							<asp:ListItem Text="24 Items" Value="24"></asp:ListItem>
							<asp:ListItem Text="48 Items" Value="48"></asp:ListItem>
						</asp:DropDownList>
                    </asp:Panel>
				</td>
                <td align="right">
					<asp:Label ID="ResultIndexMessage" runat="server" Text="Displaying {0} - {1} of {2} results" EnableViewState="false"></asp:Label>
				</td>
			</tr>
			</table>
		</div>
	</div>

	<div class="catalogWrapper">
        <div class="searchListing">
			<div class="itemListingContainer">
                <cb:ExDataList ID="ProductList" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Width="100%" 
                    DataKeyField="ProductId" CssClass="itemListing" EnableViewState="false" SkinID="ItemGrid">
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
                            <uc1:ProductItemDisplay ID="ProductItemDisplay1" runat="server" Item='<%# Container.DataItem %>' ShowPrice="false" ShowSku="false" ShowSummary="false" ShowRating="false" ShowAddToCart="false" ShowManufacturer="false" />
                        </div>
                    </ItemTemplate>
                </cb:ExDataList>
			</div>
		</div>			
		<asp:Panel ID="PagerPanel" runat="server" CssClass="pagingPanel">
			<asp:Repeater ID="PagerControls" runat="server" OnItemCommand="PagerControls_ItemCommand">
				<ItemTemplate>
					<a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
				</ItemTemplate>
			</asp:Repeater>
		</asp:Panel>
		<div class="noResultsPanel">
			<asp:Label ID="NoSearchResults" runat="server" Text="No products match your search criteria." Visible="false"></asp:Label>
		</div>
		<asp:HiddenField ID="HiddenPageIndex" runat="server" Value="0" />
    </div>
</div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="LeftSidebar">
    <uc:CategorySearchSidebar ID="CategorySearchSidebar1" runat="server" />
</asp:Content>

