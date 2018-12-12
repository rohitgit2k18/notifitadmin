<%@ Page Title="Advanced Search" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="True" CodeFile="AdvancedSearch.aspx.cs" Inherits="AbleCommerce.AdvancedSearch" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/AddToCartLink.ascx" TagName="AddToCartLink" TagPrefix="uc" %>
<asp:Content ID="PageContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="advancedSearchPage" class="mainContentWrapper">
	<div class="pageHeader">
		<h1>Advanced Search</h1>
	</div>
    <asp:UpdatePanel ID="SearchAjax" runat="server">
        <ContentTemplate>
            <div class="searchPanel">
    		    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
			    <table class="inputForm">
				    <tr>
					    <th class="rowHeader">
						    <asp:Label ID="KeywordsLabel" runat="server" Text="Search Keywords:"></asp:Label>
					    </th>
					    <td>
						    <asp:TextBox ID="Keywords" runat="server"></asp:TextBox>
						    <cb:SearchKeywordValidator ID="KeywordValidator" runat="server" ControlToValidate="Keywords"
							    ErrorMessage="Search keyword must be at least {0} characters in length excluding spaces and wildcards and must not start with wild card." Text="*"></cb:SearchKeywordValidator>
					    </td>
					    <th class="rowHeader">
						    <asp:Label ID="SearchInLabel" runat="server" Text="Search In:"></asp:Label>
					    </th>
					    <td>
						    <asp:CheckBox ID="SearchName" runat="server" Text="Name" Checked="true" />
						    <asp:CheckBox ID="SearchDescription" runat="server" Text="Description" Checked="true" />
						    <asp:CheckBox ID="SearchSKU" runat="server" Text="SKU" />
					    </td>
				    </tr>
				    <tr>
					    <th class="rowHeader">
						    <asp:Label ID="SelectCategoryLabel" runat="server" Text="Select Category:"></asp:Label>
                            <asp:Label ID="EnterCategoryLabel" runat="server" Text="Enter Category:" Visible="false"></asp:Label>
					    </th>
					    <td >
						    <asp:DropDownList ID="CategoryList" runat="server" AppendDataBoundItems="True" 
							    DataTextField="Name" DataValueField="CategoryId" ViewStateMode="Enabled" Width="400px">
							    <asp:ListItem Text="- Any Category -" Value="0"></asp:ListItem>
						    </asp:DropDownList>
                            <asp:TextBox ID="CategoryAutoComplete" runat="server" ClientIDMode="Static" Visible="false" AutoCompleteType="Disabled"/>
                            <asp:HiddenField ID="HiddenSelectedCategoryId" runat="server" ClientIDMode="Static" />
					    </td>
					    <th class="rowHeader">
                            <asp:Label ID="ManufacturerLabel" runat="server" Text="Select Manufacturer:"></asp:Label>
					    </th>
					    <td>
						    <asp:DropDownList ID="ManufacturerList" runat="server" AppendDataBoundItems="True"
							    DataSourceID="ManufacturerDs" DataTextField="Name" DataValueField="ManufacturerId" Width="280px">
							    <asp:ListItem Text="- Any Manufacturer -" Value="0"></asp:ListItem>
						    </asp:DropDownList>
					    </td>
				    </tr>
				    <tr>
					    <th class="rowHeader">
						    <asp:Label ID="PriceRangeLabel" runat="server" Text="Price Range:"></asp:Label>
					    </th>
					    <td>
						    <asp:Label ID="Label4" runat="server" Text="Low:"></asp:Label>
						    <asp:TextBox ID="LowPrice" runat="server" Columns="4" MaxLength="4"></asp:TextBox>
						    <asp:RangeValidator ID="LowPriceValidator1" runat="server" Type="Currency" MinimumValue="0" MaximumValue="99999999" ControlToValidate="LowPrice" ErrorMessage="Low price must be a valid value." Text="*"></asp:RangeValidator>
						    <asp:Label ID="Label3" runat="server" Text="High:"></asp:Label>
						    <asp:TextBox ID="HighPrice" runat="server" Columns="4" MaxLength="4"></asp:TextBox>
						    <asp:RangeValidator ID="HighPriceValidator1" runat="server" Type="Currency" MinimumValue="0" MaximumValue="99999999" ControlToValidate="HighPrice" ErrorMessage="High price must be a valid value.<br/>" Text="*"></asp:RangeValidator>
						    <asp:CompareValidator ID="LowHighPriceValidator1" runat="server" Type="Currency" Operator="GreaterThanEqual" ControlToValidate="HighPrice" ControlToCompare="LowPrice" ErrorMessage="High price should be greater then low price." Text="*" ></asp:CompareValidator>
					    </td>
				    </tr>
				    <tr>
                        <td>&nbsp;</td>
					    <td>
						    <asp:Button ID="SearchButton" runat="server" OnClick="SearchButton_Click" Text="Search" />
					    </td>
				    </tr>
			    </table>
		    </div>
	        <asp:Panel ID="SearchResultsPanel" runat="server" CssClass="section" Visible="false" ViewStateMode="Enabled">
		        <div class="content">
                    <cb:ExGridView ID="ProductsGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="ProductId"
				        Width="100%" SkinID="PagedList" AllowPaging="true" PageSize="5" AllowSorting="true" 
				        DataSourceID="ProductDs" FixedColIndexes="0,1,5">
				        <Columns>
						    <asp:TemplateField HeaderText="Name" SortExpression="Name">
							    <HeaderStyle CssClass="thumbnail" />
							    <ItemStyle CssClass="thumbnail" />
							    <ItemTemplate>
									<asp:HyperLink ID="ThumbnailLink" runat="server" NavigateUrl='<%#Eval("NavigateUrl") %>' EnableViewState="false">
										<asp:Image ID="Thumbnail" runat="server" AlternateText='<%# Eval("ThumbnailAltText") %>' ImageUrl='<%# Eval("ThumbnailUrl") %>' EnableViewState="false" Visible='<%#!string.IsNullOrEmpty((string)Eval("ThumbnailUrl")) %>' />
                                        <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible='<%#string.IsNullOrEmpty((string)Eval("ThumbnailUrl")) %>' EnableViewState="false" />
									</asp:HyperLink>
							    </ItemTemplate>
						    </asp:TemplateField>
					        <asp:TemplateField>
						        <HeaderStyle CssClass="item" />
						        <ItemStyle CssClass="item" />
						        <ItemTemplate>
							        <asp:HyperLink ID="Name" runat="server" Text='<%#Eval("Name")%>' NavigateUrl='<%#Eval("NavigateUrl")%>'></asp:HyperLink>
						        </ItemTemplate>
					        </asp:TemplateField>
					        <asp:BoundField DataField="Sku" HeaderText="SKU" SortExpression="Sku">
						        <HeaderStyle CssClass="sku" />
						        <ItemStyle CssClass="sku" />
					        </asp:BoundField>
					        <asp:TemplateField HeaderText="Manufacturer" SortExpression="ManufacturerId">
						        <HeaderStyle CssClass="manufacturer" />
						        <ItemStyle CssClass="manufacturer" />
						        <ItemTemplate>
							        <%#Eval("Manufacturer.Name")%>
						        </ItemTemplate>
					        </asp:TemplateField>
					        <asp:TemplateField HeaderText="Categories">
						        <HeaderStyle CssClass="categories" />
						        <ItemStyle CssClass="categories" />
						        <ItemTemplate>
							        <asp:PlaceHolder ID="Categories" runat="server"></asp:PlaceHolder>
							        <%#GetCatsList(Container.DataItem)%>
						        </ItemTemplate>
					        </asp:TemplateField>
					        <asp:TemplateField HeaderText="Price" SortExpression="Price">
						        <HeaderStyle CssClass="price" />
						        <ItemStyle CssClass="price" />
						        <ItemTemplate>
							        <uc:ProductPrice ID="Price" runat="server" Product='<%#Container.DataItem%>'></uc:ProductPrice>
						        </ItemTemplate>
					        </asp:TemplateField>
					        <asp:TemplateField>
						        <HeaderStyle CssClass="actions" />
						        <ItemStyle CssClass="actions" />
						        <ItemTemplate>
							        <uc:AddToCartLink ID="Add2Cart" runat="server" ProductId='<%#Eval("ProductId")%>' />
						        </ItemTemplate>
					        </asp:TemplateField>
				        </Columns>
				        <EmptyDataTemplate>
					        <asp:Localize ID="EmptyMessage" runat="server" Text="- no matching products -"></asp:Localize>
				        </EmptyDataTemplate>
			        </cb:ExGridView>
		        </div>
	        </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<asp:ObjectDataSource ID="ProductDs" runat="server" DataObjectTypeName="CommerceBuilder.Products.Product"
	OldValuesParameterFormatString="original_{0}" SelectMethod="AdvancedSearch" SelectCountMethod="AdvancedSearchCount" SortParameterName="sortExpression"  TypeName="CommerceBuilder.Products.ProductDataSource" OnSelecting="ProductDs_Selecting" EnablePaging="true" OnSelected="ProductDs_Selected">
	<SelectParameters>
		<asp:ControlParameter Name="keyword" Type="String" ControlID="Keywords" PropertyName="Text" />
		<asp:ControlParameter Name="categoryId" Type="Int32" ControlID="CategoryList" PropertyName="SelectedValue" />
		<asp:ControlParameter Name="manufacturerId" Type="Int32" ControlID="ManufacturerList" PropertyName="SelectedValue" />
		<asp:ControlParameter Name="searchName" Type="boolean" ControlID="SearchName" PropertyName="Checked" />
		<asp:ControlParameter Name="searchDescription" Type="boolean" ControlID="SearchDescription" PropertyName="Checked" />
		<asp:ControlParameter Name="searchSKU" Type="boolean" ControlID="SearchSKU" PropertyName="Checked" />
		<asp:ControlParameter Name="lowPrice" Type="decimal" ControlID="LowPrice" PropertyName="Text" />
		<asp:ControlParameter Name="highPrice" Type="decimal" ControlID="HighPrice" PropertyName="Text" />
	</SelectParameters>
</asp:ObjectDataSource>
<asp:ObjectDataSource ID="ManufacturerDs" runat="server" OldValuesParameterFormatString="original_{0}"
	SelectMethod="LoadAll" TypeName="CommerceBuilder.Products.ManufacturerDataSource">
	<SelectParameters>
		<asp:Parameter Name="sortExpression" DefaultValue="Name" />
	</SelectParameters>
</asp:ObjectDataSource>
</asp:Content>