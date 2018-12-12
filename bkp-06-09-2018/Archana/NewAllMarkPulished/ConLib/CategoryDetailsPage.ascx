<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.CategoryDetailsPage"  CodeFile="CategoryDetailsPage.ascx.cs" %>
<%--
<conlib>
<summary>A category page that displays all contents of a category with summary description in a row format.  This page displays products, webpages, and links.</summary>
<param name="DefaultCaption" default="Catalog">Caption text that will be shown as caption when root category will be browsed.</param>
<param name="DefaultCategorySummary" default="Welcome to our store.">Summary that will be shown when root category will be browsed.</param>
<param name="PagingLinksLocation" default="BOTTOM">Indicates where the paging links will be displayd, possible values are "TOP", "BOTTOM" and "TOPANDBOTTOM".</param>
<param name="ShowSummary" default="True">Indicates wheather the summary should be displayed or not, default value is true.</param>
<param name="ShowDescription" default="False">Indicates wheather the description should be displayed or not, default value is false.</param>
</conlib>
--%>

<%@ Register Src="~/ConLib/CategoryBreadCrumbs.ascx" TagName="CategoryBreadCrumbs" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/CategorySearchSidebar.ascx" TagName="CategorySearchSidebar" TagPrefix="uc" %>
<div id="categoryDetailsPage">
	<div class="section">
		<uc:CategoryBreadCrumbs id="CategoryBreadCrumbs1" runat="server" HideLastNode="True" />
	</div>
	<div class="section">
		<div class="pageHeader">
			<h1><asp:Literal ID="Caption" runat="server" EnableViewState="False"></asp:Literal></h1>
		</div>
		<div class="content">
			<asp:Literal ID="CategorySummary" runat="server" EnableViewState="false"></asp:Literal>
		</div>
	</div>
    <asp:PlaceHolder ID="CategoryDescriptionPanel" runat="server" EnableViewState="false">
	<div class="section">
		<div class="content">
		<asp:Literal ID="CategoryDescription" runat="server" Text="" EnableViewState="false" />		
		</div>
	</div>
	</asp:PlaceHolder>
	<div class="section">
		<div class="content">
        <asp:PlaceHolder ID="phCategoryContents" runat="server">
            <asp:Panel ID="PagerPanelTop" runat="server" CssClass="pagingPanel">
				<asp:Repeater ID="PagerControlsTop" runat="server">
				    <ItemTemplate>
					    <a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
				    </ItemTemplate>
				</asp:Repeater>
			</asp:Panel>
            <div class="section searchSortHeader">
			    <div class="content">
				    <table width="100%" cellpadding="3" cellspacing="0" border="0">
				    <tr>
					    <td align="left">
                            <div class="sortPanel">
						        <asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="SortResults"></asp:Label>&nbsp;
						        <asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" EnableViewState="false">
							        <asp:ListItem Text="Default" Value="OrderBy ASC, Name ASC"></asp:ListItem>
                                    <asp:ListItem Text="By Name (A -> Z)" Value="Name ASC"></asp:ListItem>
							        <asp:ListItem Text="By Name (Z -> A)" Value="Name DESC"></asp:ListItem>
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
            <div class="categoryDetailsListing">
                <div class="itemListing">
                    <asp:Repeater ID="CatalogNodeList" runat="server" OnItemDataBound="CatalogNodeList_ItemDataBound" EnableViewState="false">
                        <ItemTemplate>
                            <div class="itemContainer">
                                <div class="itemDisplay">
                                    <asp:Panel ID="ThumbnailPanel" runat="server" CssClass="thumbnailArea">
                                        <div class="thumbnailWrapper"> 
                                            <div class="thumbnail">
                                            <asp:HyperLink ID="ItemThumbnailLink" runat="server" NavigateUrl="#">
                                                <asp:Image ID="ItemThumbnail" runat="server" />
                                                <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible="false" EnableViewState="false" />
                                            </asp:HyperLink>
                                            </div> 
                                        </div> 
                                    </asp:Panel>
                                    <div class="detailsArea"> 
                                        <div class="features"> 
                                            <asp:Panel ID="NamePanel" runat="server" CssClass="itemName">
                                                <asp:HyperLink ID="ItemName" runat="server"></asp:HyperLink>
                                            </asp:Panel>
                                            <asp:Panel ID="SummaryPanel" runat="server" CssClass="summary">
                                                <asp:Label ID="ItemSummary" runat="server"></asp:Label>
                                            </asp:Panel> 
                                        </div>
                                    </div> 
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>            
            <asp:Panel ID="PagerPanel" runat="server" CssClass="pagingPanel">
				<asp:Repeater ID="PagerControls" runat="server">
					<ItemTemplate>
						<a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
					</ItemTemplate>
				</asp:Repeater>
			</asp:Panel>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="phEmptyCategory" runat="server" Visible="false" EnableViewState="false">
            <div align="center">
                <asp:Localize ID="EmptyCategoryMessage" runat="server" Text="The category is empty." EnableViewState="false"></asp:Localize>
            </div>
        </asp:PlaceHolder>
		</div>
	</div>    
</div>
