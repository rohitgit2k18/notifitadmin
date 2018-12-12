<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="Search.aspx.cs" Inherits="AbleCommerce.Mobile.Search" %>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/AddToCartLink.ascx" TagName="AddToCartLink" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<%@ Register src="~/ConLib/SimpleCategoryList.ascx" tagname="SimpleCategoryList" tagprefix="uc" %>
<%@ Register src="~/Mobile/UserControls/StoreHeader.ascx" tagname="StoreHeader" tagprefix="uc1" %>
<%@ Register src="~/Mobile/UserControls/NavBar.ascx" tagname="NavBar" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageHeader" runat="server">
    <uc1:NavBar ID="NavBar" runat="server" />    
</asp:Content>

<asp:Content ID="PageContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="searchPage" class="mainContentWrapper">
    <asp:Panel ID="CriteriaPanel" runat="server" CssClass="criteriaPanel" DefaultButton="KeywordButton">
        <span class="fieldHeader">Search:</span>
        <asp:TextBox ID="KeywordField" runat="server" MaxLength="60" EnableViewState="false" ValidationGroup="SearchCriteria"></asp:TextBox>
        <asp:Button ID="KeywordButton" runat="server" Text="GO" EnableViewState="false" OnClick="GoButton_Click" UseSubmitBehavior="false" ValidationGroup="SearchCriteria" />
        <asp:RequiredFieldValidator ID="KeywordRequired" runat="server" ControlToValidate="KeywordField" Display="None" ValidationGroup="SearchCriteria"
            Text="*" ErrorMessage="Search Keyword is required."></asp:RequiredFieldValidator>
        <cb:SearchKeywordValidator ID="KeywordValidator" runat="server" Display="None" ControlToValidate="KeywordField" ValidationGroup="SearchCriteria"
            Text="*" ErrorMessage="Search keyword must be at least {0} characters in length excluding spaces and wildcards."></cb:SearchKeywordValidator>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="SearchCriteria" />         
    </asp:Panel>
    <asp:Panel ID="ResultsPanel" runat="server" CssClass="resultsPanel">        
		<div class="header">
			<h2>Search Results</h2>
		</div>
	    <div class="info">
		    <asp:Label ID="ResultTermMessage" runat="server" Text="Search Results{0}" EnableViewState="false" CssClass="message"></asp:Label>
	    </div>
        <div class="sortPanel" runat="server" id="SortPanel">
			<asp:Label ID="SortResultsLabel" runat="server" Text="Sort:" CssClass="fieldHeader"></asp:Label>&nbsp;
			<asp:DropDownList ID="SortResults" runat="server" AutoPostBack="true" CssClass="sorting" OnSelectedIndexChanged="SortResults_SelectedIndexChanged" EnableViewState="true">
                <asp:ListItem Text="Featured" Value="IsFeatured DESC, Name ASC"></asp:ListItem>
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
					<a class='<%#Eval("TagClass")%>'  href='<%#Eval("NavigateUrl")%>'><%#Eval("Text")%></a>
				</ItemTemplate>
			</asp:Repeater>
		</asp:Panel>
        <div class="searchListing">
			<div class="itemList<%=AbleContext.Current.Store.Settings.MobileStoreCatalogRowDisplay?"RowDisplay":""%>">
                <asp:Repeater ID="ProductList" runat="server" EnableViewState="false">
                    <ItemTemplate>
                        <div class="itemNode <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                            <uc1:ProductItemDisplay ID="ProductItemDisplay1" runat="server" Item='<%# Container.DataItem %>' ShowAddToCart="true" 
                                ShowSku='<%#AbleContext.Current.Store.Settings.MobileStoreCatalogRowDisplay%>' 
                                ShowSummary='<%#AbleContext.Current.Store.Settings.MobileStoreCatalogRowDisplay%>'
                                MaxSummaryLength = "100"
                                ShowManufacturer='<%#AbleContext.Current.Store.Settings.MobileStoreCatalogRowDisplay%>' 
                                ClientIDMode="Predictable" />
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
	    <asp:Panel runat="server" ID="NoResultsPanel" CssClass="noResultsPanel" Visible="false">
		    <asp:Label ID="NoSearchResults" runat="server" Text="No products match your search criteria." ></asp:Label>
	    </asp:Panel>
    </asp:Panel>
	<asp:HiddenField ID="HiddenPageIndex" runat="server" Value="0" />
    <asp:HiddenField ID="HiddenSearchKeywords" runat="server" Value="" />
    <asp:Panel ID="NoSearchCriteriaPanel" runat="server" CssClass="noResultsPanel">
        <asp:Label ID="NoSearchCriteriaLabel" runat="server" Text="Please enter a search criteria"></asp:Label>
    </asp:Panel>
 </div>
</asp:Content>
