<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.CategoryGridPage" CodeFile="CategoryGridPage.ascx.cs" %>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<%--
<conlib>
<summary>The defualt category page that displays products in a grid format. Allows customers to browse your catalog.</summary>
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

<div class="categoryGridPage1">
	<div class="section">
		<uc:CategoryBreadCrumbs id="CategoryBreadCrumbs1" runat="server" HideLastNode="True" />
	</div>
	<div class="section">
		<div class="pageHeader">
			<h1><asp:Localize ID="Caption" runat="server" EnableViewState="False"></asp:Localize></h1>
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

    <asp:Panel ID="SearchResultsPanel" runat="server" CssClass="searchResults">
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
                        <div class="sortPanel">
						    <asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="SortResults"></asp:Label>&nbsp;
						    <asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" EnableViewState="false">
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
                            <asp:Label ID="PageSizeLabel" runat="server" Text="Display:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="PageSizeOptions"></asp:Label>&nbsp;
						    <asp:DropDownList ID="PageSizeOptions" runat="server" AutoPostBack="true" CssClass="pageSizeOptions" EnableViewState="false">
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
			<asp:Panel ID="PagerPanelTop" runat="server" CssClass="pagingPanel">
				<asp:Repeater ID="PagerControlsTop" runat="server" OnItemCommand="PagerControls_ItemCommand">
				<ItemTemplate>
					<a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
				</ItemTemplate>
				</asp:Repeater>
			</asp:Panel> 
			<div class="categoryGridListing1">
				<div class="itemListingContainer">
					<cb:ExDataList ID="ProductList" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Width="100%" 
						DataKeyField="ProductId" CssClass="itemListing" EnableViewState="false" SkinID="ItemGrid" >
						<ItemStyle HorizontalAlign="center" VerticalAlign="bottom" Width="33%" CssClass="tableNode" />
						<ItemTemplate>
							<div class="itemContainer">
								<uc1:ProductItemDisplay ID="ProductItemDisplay1" runat="server" Item='<%# Container.DataItem %>' ShowManufacturer="true" ShowRating="true" ShowAddToCart="true" />
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
    </asp:Panel>
</div>
