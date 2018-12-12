<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.CategoryGridPage3" CodeFile="CategoryGridPage3.ascx.cs" %>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<%--
<conlib>
<summary>Category Grid with Add To Cart Option. The category page that displays products in a grid format. Allows customers to browse your catalog, with options to directly add your products to cart and specify the quantity.</summary>
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

<div id="categoryGridPage3">
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
<asp:UpdatePanel ID="SearchResultsAjaxPanel" runat="server" UpdateMode="Conditional">
    <ContentTemplate>        
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
                        <div class="sortPanel">
						    <asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader"></asp:Label>&nbsp;
						    <asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" OnSelectedIndexChanged="SortResults_SelectedIndexChanged">
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
			<div class="categoryGridListing3">
            <asp:Panel ID="ProductsListPanel" runat="server" DefaultButton="MultipleAddToBasketButton" CssClass="itemListingContainer">
            <cb:ExDataList ID="ProductList" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" Width="100%" 
                OnItemDataBound="ProductList_ItemDataBound" DataKeyField="ProductId" CssClass="itemListing" EnableViewState="true" HorizontalAlign="left" SkinID="ItemList">
                <ItemStyle HorizontalAlign="center" VerticalAlign="middle" Width="33%" CssClass="tableNode" />
                <ItemTemplate>
                    <div class="itemContainer">
                        <uc1:ProductItemDisplay ID="ProductItemDisplay1" runat="server" Item='<%# Container.DataItem %>' ShowManufacturer="true" ShowRating="true" />
                        <div id="QuantityPanel" runat="Server">
                            <asp:Label ID="QuantityLabel" runat="server" Text="Quantity:"></asp:Label>&nbsp;<asp:TextBox ID="Quantity" runat="server" Text="" MaxLength="4" Columns="3"></asp:TextBox>
                            <asp:HiddenField ID="HiddenProductId" runat="server" Value='<%#Eval("ProductId")%>' />
                        </div>
                    </div>
                </ItemTemplate>
            </cb:ExDataList>
            </asp:Panel>
			</div>
            <div class="actions">
                <asp:Button ID="MultipleAddToBasketButton" runat="server" Text="Add to Cart" OnClick="MultipleAddToBasketButton_Click" ToolTip="Fill in the quantity and Click this to add multiple products to baskt." UseSubmitBehavior="false" />       
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
    </ContentTemplate>
</asp:UpdatePanel>
</div>
