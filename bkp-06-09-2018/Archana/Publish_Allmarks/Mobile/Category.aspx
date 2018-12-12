<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="Category.aspx.cs" Inherits="AbleCommerce.Mobile.CategoryPage" ViewStateMode="Disabled"%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<%@ Register src="~/Mobile/UserControls/NavBar.ascx" tagname="NavBar" tagprefix="uc1" %>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/AddToCartLink.ascx" TagName="AddToCartLink" TagPrefix="uc" %>
<%@ Register src="~/Mobile/UserControls/SimpleCategoryList.ascx" tagname="SimpleCategoryList" tagprefix="uc1" %>
<%@ Register src="~/Mobile/UserControls/SearchBox.ascx" tagname="SearchBox" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
<uc1:NavBar ID="NavBar" runat="server" />
<div id="categoryPage" class="mainContentWrapper">	
	<div class="section">
		<div class="header">
			<h2><asp:Localize ID="Caption" runat="server" EnableViewState="False"></asp:Localize></h2>
		</div>
        <div class="content">            
            <asp:Panel ID="SubCategoryPanel" runat="server" EnableViewState="false" CssClass="subcategories">	
                <uc1:SimpleCategoryList ID="SimpleCategoryList1" runat="server" ShowHeader="false" />	
	        </asp:Panel>
            <asp:Panel ID="ProductsPanel" runat="server">
                <div class="sortPanel">
					<asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader" EnableViewState="false" AssociatedControlID="SortResults"></asp:Label>&nbsp;
					<asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" EnableViewState="false">
						<asp:ListItem Text="Featured" Value="IsFeatured DESC, OrderBy ASC, Name ASC"></asp:ListItem>
						<asp:ListItem Text="By Name (A -> Z)" Value="Name ASC"></asp:ListItem>
						<asp:ListItem Text="By Name (Z -> A)" Value="Name DESC"></asp:ListItem>
						<asp:ListItem Text="By Price (Low to High)" Value="Price ASC"></asp:ListItem>
						<asp:ListItem Text="By Price (High to Low)" Value="Price DESC"></asp:ListItem>
					</asp:DropDownList>
                </div>
                <asp:Panel ID="PagerPanelTop" runat="server" CssClass="pagingPanel">
                    <asp:Label ID="PagerMessageTop" runat="server" Text="Page {0} of {1}" EnableViewState="false" CssClass="resultMessage"></asp:Label>
				    <asp:Repeater ID="PagerControlsTop" runat="server">
				        <ItemTemplate>
					        <a class='<%#Eval("TagClass")%>' href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
				        </ItemTemplate>
				    </asp:Repeater>
			    </asp:Panel>
                <div class="searchListing">
				    <div class="itemList<%=AbleContext.Current.Store.Settings.MobileStoreCatalogRowDisplay?"RowDisplay":""%>">
					    <asp:Repeater ID="ProductList" runat="server" EnableViewState="false">
						    <ItemTemplate>
							    <div class="itemNode <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
								    <uc1:ProductItemDisplay ID="ProductItemDisplay1" runat="server" Item='<%# Container.DataItem %>' ShowRating="true" ShowAddToCart="true" 
                                        ShowSku='<%#AbleContext.Current.Store.Settings.MobileStoreCatalogRowDisplay%>' 
                                        ShowSummary='<%#AbleContext.Current.Store.Settings.MobileStoreCatalogRowDisplay%>' 
                                        MaxSummaryLength = "100"
                                        ShowManufacturer='<%#AbleContext.Current.Store.Settings.MobileStoreCatalogRowDisplay%>' 
                                        ClientIDMode="Predictable" alt='<%#Eval("ImageAltText")%>' />
							    </div>
						    </ItemTemplate>
					    </asp:Repeater>
				    </div>
			    </div>
                <asp:Panel ID="PagerPanel" runat="server" CssClass="pagingPanel">
                    <asp:Label ID="PagerMessageBottom" runat="server" Text="Page {0} of {1}" EnableViewState="false" CssClass="resultMessage"></asp:Label>
				    <asp:Repeater ID="PagerControls" runat="server">
					    <ItemTemplate>
						    <a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
					    </ItemTemplate>
				    </asp:Repeater>
			    </asp:Panel>
			    <asp:HiddenField ID="HiddenPageIndex" runat="server" Value="0" />		
            </asp:Panel>
            <asp:Panel ID="NoResultPanel" runat="server" CssClass="noResultsPanel" Visible="false" EnableViewState="false">
                <asp:Label ID="NoResults" runat="server" Text="No products are currently available in this category."></asp:Label>
            </asp:Panel>
       </div>        
	</div>	
</div>
</asp:Content>
<asp:Content ID="Content2" runat="server" ContentPlaceHolderID="PageHeader">
    <uc1:SearchBox ID="SearchBox1" runat="server" />
</asp:Content>

