<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Catalog.Browse" Title="Browse Catalog" CodeFile="Browse.aspx.cs" %>
<%@ Register Src="../UserControls/SearchCategory.ascx" TagName="SearchCategory" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">
        function checkSelected()
        {
            for(i = 0; i< document.forms[0].elements.length; i++)
            {
                var e = document.forms[0].elements[i];
                var name = e.name;
                if ((e.type == 'checkbox') && (name.indexOf('Selected') != -1))
                {                
                    if(e.checked) return true;
                }            
            }
            return false;
        }
    
        function confirmSelection()
        {
            var bulkOptionsList = document.getElementById('<%=BulkOptions.ClientID%>'); 
            if(!checkSelected())
            { 
                alert("Please first select some catalog items.");
                bulkOptionsList.selectedIndex = 0;
                return false;
            }
        
            // Delete
            if(bulkOptionsList.selectedIndex == 2)
            {
                var proceed = confirm("Are you sure to delete all selected items?");
                if(!proceed) bulkOptionsList.selectedIndex = 0;
                return proceed;
            }
            return true;
        }
    
        function selectCatalogItems(items)
        {
            if(items == "All" || items == "None")
            {
                var checkState = false;
                if (items == "All")
                    checkState = true;

                $(".rowSelector input").each(function () { this.checked = checkState; });
            }
            else {
                if (items != null) {
                    $(".rowSelector input").each(function () {
                        this.checked = false;
                    });

                    for (var i = 0; i < items.length; i++)
                    {
                        var id = items[i];
                        var cb = document.getElementById(id);
                        if (cb != null)
                            cb.checked = true;
                    }
                }
            }

            updateSelectedCount();
        }    
    
        $(document).ready(function () {
            bindEvents();
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () { bindEvents() });
        });

        function bindEvents() {
            $(".rowSelector").click(updateSelectedCount);
            $(".allRowsSelector").click(function () { toggleAll(this) });
        }

        function updateSelectedCount() {
            var selectedRows = $(".rowSelector input:checked").length;
            $("#gridSelectionCount").text(selectedRows.toString());
            var totalRows = $(".rowSelector input").length;
            var allRowsSelector = $(".allRowsSelector:first");
            allRowsSelector.attr("checked", (totalRows == selectedRows));
        }

        function selectAll() {
            $('#gridSelectionCount').text($('#searchCount').text());
        }

        function toggleAll(cb) {
            $(".rowSelector input").each(function () { this.checked = cb.checked });
            updateSelectedCount();
        }

    </script>
    <div class="pageHeader">
	    <div class="caption">
            <h1>
                <asp:Localize ID="CategoryNameLabel" runat="server" Text="Browsing " EnableViewState="false"></asp:Localize>
                <asp:Localize ID="CategoryName" runat="server" Text="Catalog" EnableViewState="false"></asp:Localize>
            </h1>
            <div class="links">
                <cb:NavigationLink ID="CategoryLink" runat="server" Text="Browse Catalog" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
                <cb:NavigationLink ID="ProductsLink" runat="server" Text="Manage Products" SkinID="Button" NavigateUrl="../Products/ManageProducts.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="BatcheditLinkProd" runat="server" Text="Batch Edit Products" SkinID="Button" NavigateUrl="../Products/BatchEdit.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="BatcheditLinkCat" runat="server" Text="Batch Edit Categories" SkinID="Button" NavigateUrl="../Catalog/CategoryBatchEdit.aspx"></cb:NavigationLink>
            </div>
	    </div>
    </div>
    <div class="grid_9 alpha">
        <div class="mainColumn">
            <div class="section">
                <div class="header">
                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                        <tr>
                            <td>
                                <h2><asp:Localize ID="ContentsCaption" runat="server" Text="Contents of {0}" EnableViewState="false"></asp:Localize></h2>
                            </td>
                            <td align="right">
                                <asp:HyperLink ID="SortCategoryButton" runat="server" Text="Sort" NavigateUrl="SortCategory.aspx?CategoryId={0}" EnableViewState="false" SkinID="Button" />
                                <asp:HyperLink ID="EditCategory" runat="server" Text="Edit" EnableViewState="false" SkinID="Button"></asp:HyperLink>
                                <asp:HyperLink ID="ViewCategory" runat="server" Text="Preview" Target="_blank" EnableViewState="false" SkinID="Button"></asp:HyperLink>
                                <asp:ImageButton ID="ParentCategory" runat="server" SkinID="ParentCategoryIcon" OnClick="ParentCategory_Click" EnableViewState="false" ToolTip="Parent Category" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="content">
                    <asp:UpdatePanel ID="GridAjax" runat="server" UpdateMode="Always">
                        <ContentTemplate>
                            <cb:AbleGridView ID="CGrid" runat="server" AutoGenerateColumns="False" Width="100%" DataKeyNames="CatalogNodeId,CatalogNodeType" 
                                AllowSorting="False" AllowPaging="True" PageSize="50" OnRowCommand="CGrid_RowCommand" OnRowDataBound="CGrid_RowDataBound"
                                SkinId="PagedList" ShowHeader="true" DataSourceID="CatalogDs" EnableViewState="false" OnDataBound="CGrid_DataBound"
                                TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching catalog items">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderStyle Width="24px" />
                                        <HeaderTemplate>
                                            <input id="ALL" type="checkbox" runat="server" class="allRowsSelector" />
                                        </HeaderTemplate>                                            
                                        <ItemStyle HorizontalAlign="Center" Width="24px" />
                                        <ItemTemplate>
                                            <asp:CheckBox ID="Selected" runat="server" CssClass="rowSelector" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Sort">
                                        <HeaderStyle HorizontalAlign="center" Width="54px" />
                                        <ItemStyle Width="54px" HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:LinkButton ID="MU" runat="server" CommandName="Do_Up" ToolTip="Move Up" CommandArgument='<%#string.Format("{0}|{1}", Eval("CatalogNodeTypeId"), Eval("CatalogNodeId"))%>'><img src="<%# GetIconUrl("arrow_up.gif") %>" border="0" alt="Move Up" /></asp:LinkButton>
                                            <asp:LinkButton ID="MD" runat="server" CommandName="Do_Down" ToolTip="Move Down"  CommandArgument='<%#string.Format("{0}|{1}", Eval("CatalogNodeTypeId"), Eval("CatalogNodeId"))%>'><img src="<%# GetIconUrl("arrow_down.gif") %>" border="0" alt="Move Down" /></asp:LinkButton>
                                         </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Type">
                                        <HeaderStyle HorizontalAlign="center" Width="36px" />
                                        <ItemStyle Width="36px" HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <img src="<%# GetCatalogIconUrl(Container.DataItem) %>" border="0" alt="<%#Eval("CatalogNodeType")%>" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="BrowseLink" runat="server" Text='<%# Eval("Name") %>' NavigateUrl='<%#GetBrowseUrl(Container.DataItem)%>'></asp:HyperLink>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
									        <a href="<%# GetPreviewUrl(Eval("CatalogNodeType"), Eval("CatalogNodeId"), Eval("Name")) %>" Title="Preview" Target="_blank"><img src="<%# GetIconUrl("Preview.gif") %>" border="0" alt="Preview" /></a>

                                            <asp:LinkButton ID="C" runat="server" ToolTip="Copy" CommandName="Do_Copy" CommandArgument='<%#string.Format("{0}|{1}", Eval("CatalogNodeTypeId"), Eval("CatalogNodeId"))%>' Visible='<%#((CatalogNodeType)Eval("CatalogNodeType") != CatalogNodeType.Category) %>'><img src="<%# GetIconUrl("copy.gif") %>" alt="Copy" border="0" / ></asp:LinkButton>

                                            <asp:LinkButton ID="P" runat="server" ToolTip='<%#string.Format("Visibility : {0}",Eval("Visibility"))%>' CommandName="Do_Pub" CommandArgument='<%#string.Format("{0}|{1}", Eval("CatalogNodeTypeId"), Eval("CatalogNodeId"))%>'><img src="<%# GetVisibilityIconUrl(Container.DataItem) %>" border="0" alt="<%#Eval("Visibility")%>" /></asp:LinkButton>

                                            <a href="<%# GetEditUrl(Eval("CatalogNodeType"), Eval("CatalogNodeId")) %>" Title="Edit"><img src="<%# GetIconUrl("edit.gif") %>" border="0" alt="Edit" /></a>
                                                    
									        <asp:LinkButton ID="D" runat="server" ToolTip="Delete" CommandName="Do_Delete" CommandArgument='<%#string.Format("{0}|{1}", Eval("CatalogNodeTypeId"), Eval("CatalogNodeId"))%>'><img src="<%# GetIconUrl("delete.gif") %>" border="0" alt="Delete" /></asp:LinkButton>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="right" Width="145px" />
                                    </asp:TemplateField>
                                </Columns>
                                <AlternatingRowStyle CssClass="even" />
                                <EmptyDataTemplate>
                                    <div class="emptyResult">This category is empty.  Please add an item to view this category in your store.</div>
                                    <asp:Panel ID="AddContentPanel" runat="server" CssClass="section">
                                        <div class="content" align="center">
                                            <asp:HyperLink ID="AddCategoryLink" runat="server" NavigateUrl="AddCategory.aspx" SkinID="Link" EnableViewState="false">
                                                <asp:Image ID="CategoryIcon" runat="server" SkinID="BigCategoryIcon" EnableViewState="false" ToolTip="Category" />
                                            </asp:HyperLink>
                                            <asp:HyperLink ID="AddProductLink" runat="server" NavigateUrl="../Products/AddProduct.aspx" EnableViewState="false">
                                                <asp:Image ID="ProductIcon" runat="server" SkinID="BigProductIcon" EnableViewState="false" ToolTip="Product" />
                                            </asp:HyperLink>
                                            <asp:HyperLink ID="AddWebpageLink" runat="server" NavigateUrl="AddWebpage.aspx" EnableViewState="false">
                                                <asp:Image ID="WebpageIcon" runat="server" SkinID="BigWebpageIcon" EnableViewState="false" ToolTip="Webpage" />
                                            </asp:HyperLink>
                                            <asp:HyperLink ID="AddLinkLink" runat="server" NavigateUrl="AddLink.aspx" EnableViewState="false">
                                                <asp:Image ID="LinkIcon" runat="server" SkinID="BigLinkIcon" EnableViewState="false" ToolTip="Link" />
                                            </asp:HyperLink>
                                        </div>
                                    </asp:Panel>
                                </EmptyDataTemplate>
                                <PagerSettings Position="TopAndBottom" />
                            </cb:AbleGridView>
                            <div id="gridFooter" runat="server" clientidmode="Static">
                                <span id="gridSelectionCount">0</span> Selected Item(s): 
                                <asp:DropDownList ID="BulkOptions" runat="server" EnableViewState="false">
                                    <asp:ListItem Text="" Selected="true" Value=""/>
                                    <asp:ListItem Text="Move Selected" Value="Move" />
                                    <asp:ListItem Text="Delete Selected" Value="Delete" />
                                    <asp:ListItem Text="Change Visibility" Value="ChangeVisibility" />
                                </asp:DropDownList>
                                <asp:Button ID="GoButton" runat="server" Text="Go" CssClass="button" OnClientClick="return confirmSelection();" OnClick="GoButton_Click" />
                                <span class="selectOptions">
                                    <span class="selectHeader">
                                        <asp:Localize ID="SelectHeaderText" runat="server" SkinID="FieldHeader" Text="Auto Select:" EnableViewState="false"></asp:Localize>
                                    </span>
                                    <span class="selectLinks">
                                        <asp:LinkButton ID="SelectAll" runat="server" Text="All" EnableViewState="false" OnClientClick="selectCatalogItems('All');return false;"></asp:LinkButton>
                                        <asp:LinkButton ID="SelectNone" runat="server" Text="None" EnableViewState="false" OnClientClick="selectCatalogItems('None');return false;"></asp:LinkButton>
                                        <asp:LinkButton ID="SelectCategories" runat="server" Text="Categories" EnableViewState="false" OnClientClick="return false;"></asp:LinkButton>
                                        <asp:LinkButton ID="SelectProducts" runat="server" Text="Products" EnableViewState="false" OnClientClick="return false;"></asp:LinkButton>
                                        <asp:LinkButton ID="SelectLinks" runat="server" Text="Links" EnableViewState="false" OnClientClick="return false;"></asp:LinkButton>
                                        <asp:LinkButton ID="SelectWebpages" runat="server" Text="Webpages" EnableViewState="false" OnClientClick="return false;"></asp:LinkButton>
                                    </span>
                                </span>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:ObjectDataSource ID="CatalogDs" runat="server" OldValuesParameterFormatString="original_{0}" 
                        SelectMethod="LoadForCategory" TypeName="CommerceBuilder.Catalog.CatalogDataSource"
                        SelectCountMethod="CountForCategory" OnSelecting="CatalogDs_Selecting" EnablePaging="true" EnableViewState="false">
                        <SelectParameters>
                            <asp:Parameter Name="categoryId" Type="Object" />
                            <asp:Parameter Name="publicOnly" Type="Boolean" DefaultValue="false" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>
            </div>
        </div>
    </div>
    <div class="grid_3 omega">
        <div class="rightColumn">
            <asp:Panel ID="ActionMenuPanel" runat="server">
                <asp:Panel ID="AddCategoryPanel" runat="server" CssClass="section" DefaultButton="AddCategory" EnableViewState="false">
                    <div class="header">
                        <h2 class="newcategory"><asp:Localize ID="ActionMenuCaption" runat="server" Text="New Category" EnableViewState="false"></asp:Localize></h2>
                    </div>
                    <div class="content">
                        <asp:UpdatePanel ID="AddAjax" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table class="inputForm">
                                    <tr>
                                        <td align="left">
                                            <asp:TextBox ID="AddCategoryName" runat="server" width="130px" MaxLength="255" EnableViewState="false"></asp:TextBox>
                                        </td>
                                        <td align="left">
                                            <asp:Button ID="AddCategory" runat="server" Text="Add" OnClick="AddCategory_Click" OnClientClick="this.value='Adding';this.enabled=false" EnableViewState="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <asp:Label ID="CategoryAddedMessage" runat="server" Text="{0} added." SkinID="GoodCondition" Visible="false" EnableViewState="False"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="AddCategoryHelpText" runat="server" Text="For more options, click the 'Category' icon below." EnableViewState="false"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </asp:Panel>
                <asp:Panel ID="AddContentPanel" runat="server" CssClass="section">
                    <div class="header">
                        <h2 class="additems"><asp:Localize ID="AddContentCaption" runat="server" Text="Add Item" EnableViewState="false"></asp:Localize></h2>
                    </div>
                    <div class="content" align="center">
                        <asp:HyperLink ID="AddCategoryLink" runat="server" NavigateUrl="AddCategory.aspx" SkinID="Link" EnableViewState="false">
                            <asp:Image ID="CategoryIcon" runat="server" SkinID="BigCategoryIcon" EnableViewState="false" ToolTip="Category" />
                        </asp:HyperLink>
                        <asp:HyperLink ID="AddProductLink" runat="server" NavigateUrl="../Products/AddProduct.aspx" EnableViewState="false">
                            <asp:Image ID="ProductIcon" runat="server" SkinID="BigProductIcon" EnableViewState="false" ToolTip="Product" />
                        </asp:HyperLink>
                        <asp:HyperLink ID="AddWebpageLink" runat="server" NavigateUrl="AddWebpage.aspx" EnableViewState="false">
                            <asp:Image ID="WebpageIcon" runat="server" SkinID="BigWebpageIcon" EnableViewState="false" ToolTip="Webpage" />
                        </asp:HyperLink>
                        <asp:HyperLink ID="AddLinkLink" runat="server" NavigateUrl="AddLink.aspx" EnableViewState="false">
                            <asp:Image ID="LinkIcon" runat="server" SkinID="BigLinkIcon" EnableViewState="false" ToolTip="Link" />
                        </asp:HyperLink>
                    </div>
                </asp:Panel>
        		<asp:Panel ID="SearchPanel" runat="server" CssClass="section" DefaultButton="Search" EnableViewState="false">
			        <div class="header">
				        <h2 class="searchthiscategory"><asp:Localize ID="SearchCaption" runat="server" Text="Search this Category" EnableViewState="false"></asp:Localize></h2>
				    </div>
				    <div class="content">
		                <asp:Label ID="SearchInstructionText" runat="server" Text="Enter all, or part, of the phrase you are searching for." EnableViewState="false"></asp:Label><br /><br />
                        <asp:Label ID="SearchPhraseLabel" runat="server" Text="Keyword: " SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                        <asp:TextBox ID="SearchPhrase" runat="server" EnableViewState="false"></asp:TextBox><br />
                        <asp:CheckBox ID="TitlesOnly" runat="server" Text="Search Titles Only" Checked="true" EnableViewState="false" /><br />
                        <asp:CheckBox ID="Recursive" runat="server" Text="Include Subcategories" Checked="true" EnableViewState="false" /><br /><br />
                        <asp:Label ID="TypeFilterLabel" runat="server" Text="Include:" SkinID="FieldHeader" EnableViewState="false"></asp:Label><br />
                        <asp:CheckBox ID="IncludeCategories" runat="server" Text="Categories" Checked="false" EnableViewState="false" />
                        <asp:CheckBox ID="IncludeProducts" runat="server" Text="Products" Checked="true" EnableViewState="false" /><br />
                        <asp:CheckBox ID="IncludeWebpages" runat="server" Text="Webpages" Checked="false" EnableViewState="false" />
                        <asp:CheckBox ID="IncludeLinks" runat="server" Text="Links" Checked="false" EnableViewState="false" /><br /><br />
                        <asp:Button ID="Search" runat="server" Text="Search" OnClientClick="this.value='Searching...'" OnClick="Search_Click" EnableViewState="false" />
			        </div>
		        </asp:Panel>
            </asp:Panel>
        </div>
    </div>
</asp:Content>