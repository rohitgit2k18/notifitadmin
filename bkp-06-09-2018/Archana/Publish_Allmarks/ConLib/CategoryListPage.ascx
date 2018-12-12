<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.CategoryListPage" CodeFile="CategoryListPage.ascx.cs" %>
<%--
<conlib>
<summary>A category page that displays all contents of a category in a simple list format. This page displays products, webpages, and links.</summary>
<param name="PagingLinksLocation" default="BOTTOM">Indicates where the paging links will be displayd, possible values are "TOP", "BOTTOM" and "TOPANDBOTTOM".</param>
<param name="DisplayBreadCrumbs" default="True">Indicates wheather the breadcrumbs should be displayed or not, default value is true.</param>
<param name="DefaultCaption" default="Catalog">Caption text that will be shown as caption when root category will be browsed.</param>
<param name="PageSize" default="20">Number of items to display on one page.</param>
<param name="ShowSummary" default="False">Indicates wheather the summary should be displayed or not, default value is false.</param>
<param name="ShowDescription" default="False">Indicates wheather the description should be displayed or not, default value is false.</param>
</conlib>
--%>
<%@ Register Src="~/ConLib/CategoryBreadCrumbs.ascx" TagName="CategoryBreadCrumbs" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/CategorySearchSidebar.ascx" TagName="CategorySearchSidebar" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/AddToCartLink.ascx" TagName="AddToCartLink" TagPrefix="uc" %>
<div id="categoryListPage">
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

    <asp:UpdatePanel ID="SearchResultsAjaxPanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>            
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
                            <span><asp:Localize ID="ResultIndexMessage" runat="server" Text="Displaying {0} - {1} of {2} results" EnableViewState="false"></asp:Localize></span>
                        </td>
                        <td align="right">
                            <asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="SortResults"></asp:Label>&nbsp;
                            <asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" EnableViewState="false">
                                <asp:ListItem Text="Default" Value="OrderBy ASC, Name ASC"></asp:ListItem>
                                <asp:ListItem Text="Featured" Value="IsFeatured DESC, OrderBy ASC, Name ASC"></asp:ListItem>
                                <asp:ListItem Text="By Name (A -> Z)" Value="Name ASC"></asp:ListItem>
                                <asp:ListItem Text="By Name (Z -> A)" Value="Name DESC"></asp:ListItem>
                                <asp:ListItem Text="By Price (Low to High)" Value="Price ASC"></asp:ListItem>
                                <asp:ListItem Text="By Price (High to Low)" Value="Price DESC"></asp:ListItem>
                                <asp:ListItem Text="By Manufacturer (A -> Z)" Value="Manufacturer ASC"></asp:ListItem>
 	 	 	 		            <asp:ListItem Text="By Manufacturer (Z -> A)" Value="Manufacturer DESC"></asp:ListItem>                                 
                            </asp:DropDownList>
                        </td>
                    </tr>
					</table>
				</div>
            </div>
            <asp:PlaceHolder ID="phCategoryContents" runat="server">
                <div class="catalogWrapper">
                    <asp:PlaceHolder ID="PagerPanelTop" runat="server">
                        <div class="pagingPanel">
                            <asp:Repeater ID="PagerControlsTop" runat="server" EnableViewState="true">
                                <ItemTemplate>
                                    <a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </asp:PlaceHolder>
					<div class="categoryListListing">
                    <asp:Repeater ID="CatalogNodeList" runat="server" OnItemDataBound="CatalogNodeList_ItemDataBound" EnableViewState="false">                    
                        <HeaderTemplate>
                            <table  class="pagedList" border="0" cellspacing="1">
                                <tr>
				                    <th scope="col" class="sku">SKU</th>
				                    <th scope="col" class="itemName" >Name</th>
				                    <th scope="col" class="manufacturer" >Manufacturer</th>
				                    <th scope="col" class="price retail">Retail&nbsp;Price</th>
				                    <th scope="col" class="price">Our&nbsp;Price</th>
				                    <th scope="col" class="actions">&nbsp;</th>
			                    </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="sku">
                                    <asp:Label ID="ProductSku" runat="server" CssClass="sku"></asp:Label>
                                </td>
                                <td class="itemName">
                                    <asp:HyperLink ID="ProductName" runat="server" CssClass="itemName"></asp:HyperLink>
                                </td>
                                <td class="manufacturer">
                                    <asp:HyperLink ID="ProductManufacturer" runat="server"></asp:HyperLink>
                                </td>
                                <td class="price retail">
                                    <asp:Label ID="ProductRetailPrice" runat="server" CssClass="msrp"></asp:Label>
                                </td>
                                <td  class="price">
                                    <uc:ProductPrice ID="Price" runat="server" Product='<%#Container.DataItem %>' />
                                </td>
                                <td class="actions">
                                    <uc:AddToCartLink ID="Add2Cart" runat="server" ProductId='<%#Eval("Id")%>' />
                                </td>
                            </tr>                       
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
					</div>
                    <asp:PlaceHolder ID="PagerPanel" runat="server">
                        <div class="pagingPanel">
                            <asp:Repeater ID="PagerControls" runat="server" EnableViewState="true">
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
