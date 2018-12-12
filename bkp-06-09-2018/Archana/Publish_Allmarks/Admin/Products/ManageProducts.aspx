<%@ Page Title="Manage Products" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="ManageProducts.aspx.cs" Inherits="AbleCommerce.Admin.Products.ManageProducts" ViewStateMode="Disabled" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HtmlHeader" runat="server">
    <!-- we need to override the z-index to display the auto complete menu over the add product popup dialog -->
    <style type="text/css">
        ul.ui-autocomplete {
            z-index:999999 !important;
        }
    </style>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Manage Products"></asp:Localize></h1>
            <div class="links">
                <cb:NavigationLink ID="CategoryLink" runat="server" Text="Browse Catalog" SkinID="Button" NavigateUrl="../Catalog/Browse.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="ProductsLink" runat="server" Text="Manage Products" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
                <cb:NavigationLink ID="BatcheditLinkProd" runat="server" Text="Batch Edit Products" SkinID="Button" NavigateUrl="../Products/BatchEdit.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="BatcheditLinkCat" runat="server" Text="Batch Edit Categories" SkinID="Button" NavigateUrl="../Catalog/CategoryBatchEdit.aspx"></cb:NavigationLink>
            </div>
        </div>
    </div>
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <asp:PlaceHolder ID="TEST" runat="server"></asp:PlaceHolder>
            <asp:Panel ID="SearchPanel" runat="server"  CssClass="searchPanel" DefaultButton="SearchButton">
                <asp:ValidationSummary ID="SearchSummary" runat="server" ValidationGroup="SearchGroup" />
                <table cellspacing="0" class="inputForm">
                    <tr>
                        <th>
                            <asp:Label ID="NameLabel" runat="server" Text="Name:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Name" runat="server" Width="200px"></asp:TextBox>
                            <cb:SearchKeywordValidator ID="NameValidator" runat="server" ControlToValidate="Name"
                                ErrorMessage="Name must not start with wild card character." Text="*" ValidationGroup="SearchGroup"></cb:SearchKeywordValidator>
                        </td>
                        <td colspan="4">
                            <asp:CheckBox ID="SearchDescriptions" runat="server" Text="Search Descriptions" />
                            <asp:CheckBox ID="ShowProductThumbnails" runat="server" Text="Show Thumbnails" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="SKULabel" runat="server" Text="SKU:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Sku" runat="server" Width="200px"></asp:TextBox>
                            <cb:SearchKeywordValidator ID="SkuValidator" runat="server" ControlToValidate="Sku"
                                ErrorMessage="Sku must not start with wild card character." Text="*" ValidationGroup="SearchGroup" AllowWildCardsInStart="false"></cb:SearchKeywordValidator>
                        </td>
                        <th>
		                    <asp:Label ID="CategoriesListLabel" runat="server" Text="Category:"></asp:Label>
		                </th>
		                <td colspan="3">
		                    <asp:DropDownList ID="CategoriesList" runat="server" AppendDataBoundItems="true" DataTextField="Text" DataValueField="Value" ViewStateMode="Enabled" Width="500px">
                                <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
		                    </asp:DropDownList>
                            <asp:TextBox ID="CategoryAutoComplete" runat="server" ClientIDMode="Static" Visible="false" AutoCompleteType="Disabled"/>
                            <asp:HiddenField ID="HiddenSelectedCategoryId" runat="server" ClientIDMode="Static" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="PriceLabel" runat="server" Text="Price Range:"></asp:Label>
                        </th>
                        <td>
                            <asp:Label ID="FromPriceLabel" runat="server" Text="from"></asp:Label>
                            <asp:TextBox ID="FromPrice" runat="server" Width="80px"></asp:TextBox>
                            <asp:Label ID="ToPriceLabel" runat="server" Text="to"></asp:Label>
                            <asp:TextBox ID="ToPrice" runat="server" Width="80px"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Label ID="ManufacturersLabel" runat="server" Text="Manufacturer:"></asp:Label>
                        </th>
                        <td>
                            <asp:DropDownList ID="ManufacturerList" runat="server" AppendDataBoundItems="True"
                                DataSourceID="ManufacturerDs" DataTextField="Name" DataValueField="Id" Width="213px">
                                <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="ManufacturerDs" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="LoadAll" TypeName="CommerceBuilder.Products.ManufacturerDataSource">
                                <SelectParameters>
                                    <asp:Parameter Name="sortExpression" DefaultValue="Name" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </td>
                        <th>
                            <asp:Label ID="Label1" runat="server" Text="Vendor:"></asp:Label>
                        </th>
                        <td>
                            <asp:DropDownList ID="VendorList" runat="server" AppendDataBoundItems="True"
                                DataSourceID="VendorDs" DataTextField="Name" DataValueField="Id" Width="215px">
                                <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="VendorDS" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="LoadAll" TypeName="CommerceBuilder.Products.VendorDataSource">
                                <SelectParameters>
                                    <asp:Parameter Name="sortExpression" DefaultValue="Name" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                        <th><asp:Label ID="GroupLabel" runat="server" Text="Group:"></asp:Label></th>
                        <td>
                            <asp:DropDownList ID="ProductGroups" runat="server" AppendDataBoundItems="true" DataTextField="Name" DataValueField="GroupId" DataSourceID="ProductGroupsDS" Width="216px">
                                <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="ProductGroupsDS" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="LoadNonAdminGroups" TypeName="CommerceBuilder.Users.GroupDataSource">
                            </asp:ObjectDataSource>
                        </td>
                        <th>
                            <asp:Label ID="AttributesLabel" runat="server" Text="Attributes:"></asp:Label>
                        </th>
                        <td colspan="3">
                            <asp:CheckBox ID="OnlyFeatured" runat="server" Text="Featured" />
                            <asp:CheckBox ID="OnlyDigitalGoods" runat="server" Text="Digital Good" />
                            <asp:CheckBox ID="OnlyGiftCertificates" runat="server" Text="Gift Certificate" />
                            <asp:CheckBox ID="OnlyKits" runat="server" Text="Kit" />
                            <asp:CheckBox ID="OnlySubscriptions" runat="server" Text="Subscription" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="5">
                            <asp:Button ID="SearchButton" runat="server" Text="Search" SkinID="Button" onclick="SearchButton_Click" ValidationGroup="SearchGroup" />
                            <asp:Button ID="ResetButton" runat="server" Text="Reset" SkinID="CancelButton" CausesValidation="false" onclick="ResetButton_Click" />
                            <asp:Button ID="AddButton" runat="server" Text="Add Product" SkinID="AddButton"/>  
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <div class="content">
                <%-- Shorter grid ID = smaller viewstate. --%>
	            <cb:AbleGridView ID="PG" runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                    DataSourceID="ProductsDS" AllowPaging="True" PageSize="20" 
                    TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching products" SkinID="PagedList" 
                    ShowWhenEmpty="False" AllowMultipleSelections="False"
                    OnRowCommand="ProductsGrid_RowCommand" AllowSorting="true" Width="100%" DefaultSortExpression="LastModifiedDate" DefaultSortDirection="Descending">
                    <Columns>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" Width="20px" />
                            <HeaderTemplate>
                                <input id="ALL" type="checkbox" runat="server" class="allRowsSelector" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <input id="PID" type="checkbox" runat="server" class="rowSelector" value='<%#Eval("Id")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Thumbnail">
                            <ItemStyle HorizontalAlign="Center" Width="10px" />
                            <ItemTemplate>
                                <asp:Image ID="I" runat="server" ImageUrl='<%# Eval("ThumbnailUrl") %>' Visible='<%# !string.IsNullOrEmpty((string)Eval("ThumbnailUrl")) %>' AlternateText='<%# Eval("Name") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="N" runat="server" NavigateUrl='<%#Eval("Id", "EditProduct.aspx?ProductId={0}") %>' Text='<%#Eval("Name")%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Last Modified" SortExpression="LastModifiedDate">
                            <ItemStyle HorizontalAlign="Center" Width="140px" />
                            <ItemTemplate>
                                <%# Eval("LastModifiedDate") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Price" SortExpression="Price">
                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Visibility" SortExpression="VisibilityId">
                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                            <ItemTemplate>
                                <asp:LinkButton ID="V" runat="server" ToolTip='<%#string.Format("Visibility : {0}",Eval("Visibility"))%>' CommandName="Do_Pub" CommandArgument='<%#Eval("Id")%>'>
                                    <img src="<%# GetVisibilityIconUrl(Container.DataItem) %>" border="0" alt="<%#Eval("Visibility")%>" />
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Groups">
                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                            <ItemTemplate>
                                <asp:Label ID="GroupLabel" runat="server" Text='<%#GetGroups(Container.DataItem) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemStyle HorizontalAlign="Center" Width="130px" />
                            <ItemTemplate>
                                <asp:HyperLink ID="PL" runat="server" NavigateUrl='<%# GetPreviewUrl(Container.DataItem) %>' ToolTip="Preview" Target="_blank"><asp:Image ID="PI" runat="server" SkinID="PreviewIcon" AlternateText="Preview" /></asp:HyperLink>
                                <asp:LinkButton ID="C" runat="server" ToolTip="Copy" CommandName="Do_Copy" CommandArgument='<%#Eval("Id")%>'>
                                    <asp:Image ID="CI" runat="server" SkinID="CopyIcon" />
                                </asp:LinkButton>
                                <asp:HyperLink ID="EL" runat="server" NavigateUrl='<%# Eval("Id", "EditProduct.aspx?ProductId={0}") %>' ToolTip="Edit"><asp:Image ID="EI" runat="server" SkinID="EditIcon" /></asp:HyperLink>
                                <asp:LinkButton ID="D" runat="server" ToolTip="Delete" CommandName="Do_Delete" CommandArgument='<%#Eval("Id")%>' OnClientClick='<%#string.Format("return confirm(\"Are you sure you want to delete {0}?\")", StringHelper.EscapeSpecialCharacters((string)Eval("Name"))) %>'>
                                    <asp:Image ID="DI" runat="server" SkinID="DeleteIcon" />
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="NoProductLabel" runat="server" Text="There are no products to list matching your criteria."></asp:Label>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
                <div id="gridFooter" runat="server" clientidmode="Static">
                    <span id="gridSelectionCount">0</span> Selected Item(s): 
                    <select id="gridAction">
                        <option />
                        <option value="Export">Export</option>
                        <option>Delete</option>
                        <option disabled="disabled">---------------------</option>
                        <option>Assign Groups</option>
                        <asp:PlaceHolder ID="GroupPH" runat="server"></asp:PlaceHolder>
                    </select>
                    <asp:Button ID="BatchButton" runat="server" Text="Go" OnClick="BatchButton_Click" OnClientClick="return gridGo();" />
                    <input type="hidden" id="SelectedProductIds" name="SelectedProductIds" />
                </div>
                <div id="groupDialog" title="Choose groups">
                        <table>
                        <tr>
                            <td>
                                <asp:ListBox ID="GroupList" runat="server" Width="300px" Height="150px" SelectionMode="Multiple" DataSourceID="ProductGroupsDS" DataTextField="Name" DataValueField="Id"></asp:ListBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="EnableGroupRestrictionsLable" runat="server" SkinID="FieldHeader" Text="--- Update Group Restrictions ---"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList ID="EnableGroupRestrictions" runat="server">
                                    <asp:ListItem Text="Enable" Value="YES"></asp:ListItem>
                                    <asp:ListItem Text="Disable" Value="NO"></asp:ListItem>
                                    <asp:ListItem Text="Do Not Change" Value="NONE" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="button" class="button" value="Assign" onclick="doAssign()" />
                            </td>
                        </tr>
                        </table>
                </div>
                <div id="selectAllDialog" title="Expand Selection?">
                    <p>You have selected only the items on the current page.</p>
                    <p><a href="javascript:selectAll()">select results from all pages</a></p>
                </div>
                <asp:ObjectDataSource ID="ProductsDS" runat="server"  
                    OldValuesParameterFormatString="original_{0}" SelectMethod="FindProducts" SelectCountMethod="FindProductsCount"
                    TypeName="CommerceBuilder.Products.ProductDataSource" 
                    onselecting="ProductsDS_Selecting" SortParameterName="sortExpression" EnablePaging="true">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="Name" Name="name" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="SearchDescriptions" DefaultValue="False" Name="searchDescription" PropertyName="Checked" Type="Boolean" />
                        <asp:ControlParameter ControlID="Sku" DefaultValue="" Name="sku" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="CategoriesList" DefaultValue="0" Name="categoryId" PropertyName="SelectedValue" Type="Int32" />
                        <asp:ControlParameter ControlID="ManufacturerList" DefaultValue="0" Name="manufacturerId" PropertyName="SelectedValue" Type="Int32" />
                        <asp:ControlParameter ControlID="VendorList" DefaultValue="0" Name="vendorId" PropertyName="SelectedValue" Type="Int32" />
                        <asp:Parameter Name="featured" Type="Object" />
                        <asp:Parameter DefaultValue="0" Name="taxCodeId" Type="Int32" />
                        <asp:ControlParameter ControlID="FromPrice" Name="lowPrice" PropertyName="Text" Type="Decimal" />
                        <asp:ControlParameter ControlID="ToPrice" Name="highPrice" PropertyName="Text" Type="Decimal" />
                        <asp:ControlParameter ControlID="OnlyDigitalGoods" DefaultValue="False" Name="digitalGoodsOnly" PropertyName="Checked" Type="Boolean" />
                        <asp:ControlParameter ControlID="OnlyGiftCertificates" DefaultValue="False" Name="giftCertificatesOnly" PropertyName="Checked" Type="Boolean" />
                        <asp:ControlParameter ControlID="OnlyKits" DefaultValue="False" Name="kitsOnly" PropertyName="Checked" Type="Boolean" />
                        <asp:ControlParameter ControlID="OnlySubscriptions" DefaultValue="False" Name="subscriptionsOnly" PropertyName="Checked" Type="Boolean" />
                        <asp:ControlParameter ControlID="ProductGroups" DefaultValue="0" Name="groupId" PropertyName="SelectedValue" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
            <ajaxToolkit:ModalPopupExtender ID="SelectCategoryPopup" runat="server" TargetControlID="AddButton"
                PopupControlID="SelectCategoryDialog" BackgroundCssClass="modalBackground" CancelControlID="CancelAddButton"
                DropShadow="true" PopupDragHandleControlID="SelectCategoryDialogHeader" />
            <asp:Panel ID="SelectCategoryDialog" runat="server" Style="display: none; width: 350px;"
                CssClass="modalPopup">
                <asp:Panel ID="SelectCategoryDialogHeader" runat="server" CssClass="modalPopupHeader">
                    <h2><asp:Localize ID="SelectCategoryCaption" runat="server" Text="Select a Category"></asp:Localize></h2>
                </asp:Panel>
                <div class="content">
                    <p>Select a category for the new product.</p>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Localize ID="CategoryLabel" runat="server" Text="Category:"></asp:Localize>
                            </th>
                            <td>
                                <asp:DropDownList ID="CategoryDropDown" runat="server" DataTextField="Text" DataValueField="Value" ViewStateMode="Enabled">
                                </asp:DropDownList>
                                <asp:TextBox ID="NewProductCategory" runat="server" ClientIDMode="Static" Visible="false" AutoCompleteType="Disabled"/>
                                <asp:HiddenField ID="HiddenNewProductCategoryId" runat="server" ClientIDMode="Static" />
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="OkButton" runat="server" Text="Ok" OnClick="OkButton_Click" />
                                <asp:Button ID="CancelAddButton" runat="server" Text="Cancel" SkinID="CancelButton" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script language="javascript" type="text/javascript">
        var allSelected = false;

        function deleteConfirmation() {
            var selectedRows = $(".selectRow input:checkbox:checked").length;
            if (selectedRows > 0) {
                var msg = selectedRows == 1 ? "" : "s";
                return confirm("Delete " + selectedRows + " selected product" + msg + "?");
            }
            else {
                alert("At least one product must be selected.");
            }

            return false;
        }

        function updateSelectedCount() {
            allSelected = false;
            if ($('#selectAllDialog').dialog("isOpen")) $('#selectAllDialog').dialog("close");
            var selectedRows = $(".rowSelector:checked").length;
            $("#gridSelectionCount").text(selectedRows.toString());
            var totalRows = $(".rowSelector").length;
            var allRowsSelector = $(".allRowsSelector:first");
            allRowsSelector.attr("checked", (totalRows == selectedRows));
            var resultSize = parseInt($('#searchCount').text());
            var pageSize = parseInt($('#<%=PG.ClientID%> select').val());
            if ((totalRows == selectedRows) && (resultSize > pageSize)) {
                var position = allRowsSelector.position();
                var x = position.left + $(allRowsSelector).outerWidth() + 20;
                var y = position.top - $(document).scrollTop();
                $('#selectAllDialog').dialog( "open" );
                $('#selectAllDialog').dialog({ "show": { effect: "slide", duration: 100 }, "hide": { effect: "slide", duration: 100 }, "position": [x, y], resizable: false, height: 120 });
                setTimeout(function () { if ($('#selectAllDialog').dialog("isOpen")) { $('#selectAllDialog').dialog({ hide: { effect: "slide", duration: 500} }).dialog("close"); } }, 4000);
            }
        }

        function selectAll() {
            $('#gridSelectionCount').text($('#searchCount').text());
            if ($('#selectAllDialog').dialog("isOpen")) $('#selectAllDialog').dialog("close");
            allSelected = true;
        }

        function toggleAll(cb) {
            $(".rowSelector").each(function () { this.checked = cb.checked });
            updateSelectedCount();
        }

        function gridGo() {
            // validate our action
            var action = $("#gridAction").val();
            if (action != "Delete" && action != "Export" && action != "Assign Groups" && !action.match("^Remove From")) {
                alert("You must select an action to perform.");
                return false;
            }

            // validate we have some rows
            var selectedRowCount = $(".rowSelector:checked").length;
            if (selectedRowCount < 1) {
                alert("You must select at least one item.");
                return false;
            }

            // choose the correct the action
            var selectedRows = new Array();
            $(".rowSelector:checked").each(function () { selectedRows.push(this.value); });
            if (action == "Delete") {
                // confirm delete
                if (!confirm("Are you sure you want to delete " + $("#gridSelectionCount").text() + " selected item(s)?")) return false;
                // execute delete
                if (allSelected) deleteAll();
                else deleteSelected(selectedRows);
                $(".rowSelector:checked").each(function () { this.checked = false });
            } else if (action == "Export") {
                // redirect to export
                if (allSelected) window.location.href = "../DataExchange/ProductsExport.aspx?type=filter&filter=" + encodeURIComponent(JSON.stringify(searchQuery));
                else 
                {
                    $("#SelectedProductIds").val(selectedRows.join(","));
                    return true;
                }
            }
            else
            if(action == "Assign Groups"){
                $("#groupDialog" ).dialog({"width":330, "minWidth":330, "height":270, "minHeight":270});
                $('#groupDialog').dialog("open" );
            }
            else
            if(action.match("^Remove From")){
                var groupId = $('#<%=ProductGroups.ClientID %> :selected').val();
                var groupName = $('#<%=ProductGroups.ClientID %> :selected').text();
                if(confirm("Are you sure you want to remove selected products from '" + groupName + "' group?")){
                    if (allSelected) 
                        unAssignAll(groupId);
                    else
                        unAssignSelected(selectedRows, groupId);
                }
            }

            return false;
        }

        function deleteSelected(selectedRows) {
            $.ajax({
                type: "POST",
                url: "ManageProducts.aspx/DeleteProducts",
                data: "{productIds: " + JSON.stringify(selectedRows) + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {
                    <%=ClientScript.GetPostBackEventReference(PageAjax, "")%>
                }
            });
        }

        function deleteAll() {
            $.ajax({
                type: "POST",
                url: "ManageProducts.aspx/DeleteAllProducts",
                data: "{filter: " + JSON.stringify(searchQuery) + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    $(".allRowsSelector:checked").each(function () { this.checked = false });
                    allSelected = false;
                    <%=ClientScript.GetPostBackEventReference(PageAjax, "")%>
                }
            });
        }

        function doAssign(){
            var groupIds = []; 
            var groupRestrictions = "NONE";
            $('#<%=GroupList.ClientID %> :selected').each(function(i, selected){ 
              groupIds[i] = $(selected).val(); 
            });
            groupRestrictions = $('#<%=EnableGroupRestrictions.ClientID %>').val();
            if(groupIds.length == 0){
                alert("You must select at least one group to assign");
                return;
            }

            if (allSelected) {
                assignAll(groupIds, groupRestrictions);
            }
            else{
                var selectedRows = new Array();
                $(".rowSelector:checked").each(function () { selectedRows.push(this.value); });
                assignSelected(selectedRows, groupIds, groupRestrictions);
            }
        }

        function assignSelected(selectedRows, groupIds, groupRestrictions) {
            $.ajax({
                type: "POST",
                url: "ManageProducts.aspx/AssignProducts",
                data: "{productIds: " + JSON.stringify(selectedRows) + ", groupIds:" + JSON.stringify(groupIds) + ", groupRestrictions:"+ JSON.stringify(groupRestrictions) + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {
                    $("#groupDialog").dialog('close');
                    location.reload(true);
                }
            });
        }

        function assignAll(groupIds, groupRestrictions) {
            $.ajax({
                type: "POST",
                url: "ManageProducts.aspx/AssignAllProducts",
                data: "{filter: " + JSON.stringify(searchQuery) + ", groupIds:" + JSON.stringify(groupIds) + ", groupRestrictions:"+ JSON.stringify(groupRestrictions) + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    $("#groupDialog").dialog('close');
                    $(".allRowsSelector:checked").each(function () { this.checked = false });
                    allSelected = false;
                    location.reload(true);
                }
            });
        }

        function unAssignSelected(selectedRows, groupId) {
            $.ajax({
                type: "POST",
                url: "ManageProducts.aspx/UnAssignProducts",
                data: "{productIds: " + JSON.stringify(selectedRows) + ", groupId:" + JSON.stringify(groupId) + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {
                    location.reload(true);
                }
            });
        }

        function unAssignAll(groupId) {
            $.ajax({
                type: "POST",
                url: "ManageProducts.aspx/UnAssignAllProducts",
                data: "{filter: " + JSON.stringify(searchQuery) + ", groupId:" + JSON.stringify(groupId) + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    $(".allRowsSelector:checked").each(function () { this.checked = false });
                    allSelected = false;
                    location.reload(true);
                }
            });
        }

        function bindEvents() {
            $(".rowSelector").click(updateSelectedCount);
            $(".allRowsSelector").click(function () { toggleAll(this) });
            $('#selectAllDialog').dialog({ autoOpen: false });
            $('#groupDialog').dialog({ autoOpen: false });
        }

        $(document).ready(function () {
            bindEvents();
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () { bindEvents() });
        });

    </script>
</asp:Content>