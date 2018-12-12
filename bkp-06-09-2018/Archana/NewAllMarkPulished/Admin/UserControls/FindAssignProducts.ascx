<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FindAssignProducts.ascx.cs"
    Inherits="AbleCommerce.Admin.UserControls.FindAssignProducts" %>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:Panel ID="SearchPanel" runat="server" CssClass="searchPanel" DefaultButton="SearchButton">
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
                            ErrorMessage="Sku must not start with wild card character." Text="*" ValidationGroup="SearchGroup"
                            AllowWildCardsInStart="false"></cb:SearchKeywordValidator>
                    </td>
                    <th>
                        <asp:Label ID="CategoriesListLabel" runat="server" Text="Category:" AssociatedControlID="CategoriesList"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:DropDownList ID="CategoriesList" runat="server" AppendDataBoundItems="true"
                            DataTextField="Text" DataValueField="Value" ViewStateMode="Enabled" Width="500px">
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
                            <asp:ListItem Text="- Without Manufacturer -" Value="-1"></asp:ListItem>
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
                        <asp:DropDownList ID="VendorList" runat="server" AppendDataBoundItems="True" DataSourceID="VendorDs"
                            DataTextField="Name" DataValueField="Id" Width="215px">
                            <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
                            <asp:ListItem Text="- Without Vendor -" Value="-1"></asp:ListItem>
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
                    <th>
                        <asp:Label ID="GroupLabel" runat="server" Text="Group:"></asp:Label>
                    </th>
                    <td>
                        <asp:DropDownList ID="ProductGroups" runat="server" AppendDataBoundItems="true" DataTextField="Name"
                            DataValueField="GroupId" DataSourceID="ProductGroupsDS" Width="216px">
                            <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="ProductGroupsDS" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="LoadNonAdminGroups" TypeName="CommerceBuilder.Users.GroupDataSource">
                        </asp:ObjectDataSource>
                    </td>
                    <th>
                        <asp:Label ID="TaxCodeLabel" runat="server" Text="Tax Code:"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:DropDownList ID="TaxCodeList" runat="server" AppendDataBoundItems="True" DataSourceID="TaxCodeDs"
                            DataTextField="Name" DataValueField="Id" Width="215px">
                            <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
                            <asp:ListItem Text="- Without Tax Code -" Value="-1"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="TaxCodeDS" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="LoadAll" TypeName="CommerceBuilder.Taxes.TaxCodeDataSource">
                            <SelectParameters>
                                <asp:Parameter Name="sortExpression" DefaultValue="Name" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="AssignmentLabel" runat="server" Text="Show:"></asp:Label>
                    </th>
                    <td>
                        <asp:DropDownList ID="ProductAssignment" runat="server">
                            <asp:ListItem Text="All Products" Value="Any"></asp:ListItem>
                            <asp:ListItem Text="Assigned Products Only" Value="True" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Unassigned Products Only" Value="False"></asp:ListItem>
                        </asp:DropDownList>
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
                    <td>
                        &nbsp;
                    </td>
                    <td colspan="5">
                        <asp:Button ID="SearchButton" runat="server" Text="Search" SkinID="Button" ValidationGroup="SearchGroup" OnClick="SearchButton_Click" />
                        <asp:Button ID="ResetButton" runat="server" Text="Reset" SkinID="CancelButton" CausesValidation="false" OnClick="ResetButton_Click" />
                        <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <div class="content">
            <cb:AbleGridView ID="PG" runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                DataSourceID="ProductsDS" AllowPaging="True" PageSize="20" TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching products"
                SkinID="PagedList" ShowWhenEmpty="False" AllowMultipleSelections="False" AllowSorting="true"
                Width="100%" ondatabound="PG_DataBound">
                <Columns>
                    <asp:TemplateField>
                        <ItemStyle HorizontalAlign="Center" Width="20px" />
                        <HeaderTemplate>
                            <input id="ALL" type="checkbox" runat="server" class="allRowsSelector" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="PID" runat="server" CssClass="rowSelector" />
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
                            <asp:HyperLink ID="N" runat="server" NavigateUrl='<%#Eval("Id", "~/Admin/Products/EditProduct.aspx?ProductId={0}") %>'
                                Text='<%#Eval("Name")%>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Groups">
                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                        <ItemTemplate>
                            <asp:Label ID="GroupLabel" runat="server" Text='<%#GetGroups(Container.DataItem) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Visibility" SortExpression="VisibilityId">
                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                        <ItemTemplate>
                            <asp:LinkButton ID="V" runat="server" ToolTip='<%#string.Format("Visibility : {0}",Eval("Visibility"))%>'
                                CommandName="Do_Pub" CommandArgument='<%#Eval("Id")%>'>
                    <img src="<%# GetVisibilityIconUrl(Container.DataItem) %>" border="0" alt="<%#Eval("Visibility")%>" />
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Link">
                        <ItemStyle Width="50px" HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:ImageButton ID="AttachButton" runat="server" CommandArgument='<%#Container.DataItemIndex%>'
                                AlternateText="Add" ToolTip="Associate with this product template" SkinID="AddIcon"
                                OnClientClick="this.visible=false" OnClick="AttachButton_Click" Visible='<%#!IsProductLinked((Product)Container.DataItem)%>' />
                            <asp:ImageButton ID="RemoveButton" runat="server" CommandArgument='<%#Container.DataItemIndex%>'
                                AlternateText="Remove" ToolTip="Unlink from this product template" SkinID="DeleteIcon"
                                OnClientClick="this.visible=false" OnClick="RemoveButton_Click" Visible='<%#IsProductLinked((Product)Container.DataItem)%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Label ID="NoProductLabel" runat="server" Text="There are no products to list matching your criteria."></asp:Label>
                </EmptyDataTemplate>
            </cb:AbleGridView>
            <div id="gridFooter" runat="server" clientidmode="Static">
                <span id="gridSelectionCount">0</span> Selected Item(s):
                <asp:DropDownList ID="GridActions" runat="server">
                    <asp:ListItem Text="" Value=""></asp:ListItem>
                    <asp:ListItem Text="Assign Selected Products" Value="True"></asp:ListItem>
                    <asp:ListItem Text="Remove Selected Products" Value="False"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="GoButton" runat="server" Text="Go" OnClick="GoButton_Click" OnClientClick="return validateActions();" />
            </div>
            <div id="selectAllDialog" title="Expand Selection?">
                <p>
                    You have selected only the items on the current page.</p>
                <p>
                    <a href="javascript:selectAll()">select results from all pages</a></p>
            </div>
            <asp:HiddenField ID="SelectAll" runat="server" Value="False" />
            <asp:ObjectDataSource ID="ProductsDS" runat="server" OldValuesParameterFormatString="original_{0}"
                SelectMethod="FindProducts" SelectCountMethod="FindProductsCount" TypeName="CommerceBuilder.Products.ProductDataSource"
                OnSelecting="ProductsDS_Selecting" SortParameterName="sortExpression" EnablePaging="true">
                <SelectParameters>
                    <asp:ControlParameter ControlID="Name" Name="name" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="SearchDescriptions" DefaultValue="False" Name="searchDescription"
                        PropertyName="Checked" Type="Boolean" />
                    <asp:ControlParameter ControlID="Sku" DefaultValue="" Name="sku" PropertyName="Text"
                        Type="String" />
                    <asp:ControlParameter ControlID="CategoriesList" DefaultValue="0" Name="categoryId"
                        PropertyName="SelectedValue" Type="Int32" />
                    <asp:ControlParameter ControlID="ManufacturerList" DefaultValue="0" Name="manufacturerId"
                        PropertyName="SelectedValue" Type="Int32" />
                    <asp:ControlParameter ControlID="VendorList" DefaultValue="0" Name="vendorId" PropertyName="SelectedValue"
                        Type="Int32" />
                    <asp:Parameter Name="featured" Type="Object" />
                    <asp:ControlParameter ControlID="TaxCodeList" DefaultValue="0" Name="taxCodeId" PropertyName="SelectedValue"
                        Type="Int32" />
                    <asp:ControlParameter ControlID="FromPrice" Name="lowPrice" PropertyName="Text" Type="Decimal" />
                    <asp:ControlParameter ControlID="ToPrice" Name="highPrice" PropertyName="Text" Type="Decimal" />
                    <asp:ControlParameter ControlID="OnlyDigitalGoods" DefaultValue="False" Name="digitalGoodsOnly"
                        PropertyName="Checked" Type="Boolean" />
                    <asp:ControlParameter ControlID="OnlyGiftCertificates" DefaultValue="False" Name="giftCertificatesOnly"
                        PropertyName="Checked" Type="Boolean" />
                    <asp:ControlParameter ControlID="OnlyKits" DefaultValue="False" Name="kitsOnly" PropertyName="Checked"
                        Type="Boolean" />
                    <asp:ControlParameter ControlID="OnlySubscriptions" DefaultValue="False" Name="subscriptionsOnly"
                        PropertyName="Checked" Type="Boolean" />
                    <asp:ControlParameter ControlID="ProductGroups" DefaultValue="0" Name="groupId" PropertyName="SelectedValue"
                        Type="Int32" />
                    <asp:Parameter DefaultValue="" Name="assignmentTable" Type="String" />
                    <asp:Parameter DefaultValue="0" Name="assignmentValue" Type="Int32" />
                    <asp:Parameter DefaultValue="Any" Name="assignmentStatus" Type="Object" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<script language="javascript" type="text/javascript">
    var allSelected = false;

    function updateSelectedCount() {
        allSelected = false;
        $('#<%=SelectAll.ClientID %>').val(allSelected);
        if ($('#selectAllDialog').dialog("isOpen")) $('#selectAllDialog').dialog("close");
        var selectedRows = $(".rowSelector input:checked").length;
        $("#gridSelectionCount").text(selectedRows.toString());
        var totalRows = $(".rowSelector input").length;
        var allRowsSelector = $(".allRowsSelector:first");
        allRowsSelector.attr("checked", (totalRows == selectedRows));
        var resultSize = parseInt($('#searchCount').text());
        var pageSize = parseInt($('#<%=PG.ClientID%> select').val());
        if ((totalRows == selectedRows) && (resultSize > pageSize)) {
            var position = allRowsSelector.position();
            var x = position.left + $(allRowsSelector).outerWidth() + 20;
            var y = position.top - $(document).scrollTop();
            $('#selectAllDialog').dialog("open");
            $('#selectAllDialog').dialog({ "show": { effect: "slide", duration: 100 }, "hide": { effect: "slide", duration: 100 }, "position": [x, y], resizable: false, height: 120 });
            setTimeout(function () { if ($('#selectAllDialog').dialog("isOpen")) { $('#selectAllDialog').dialog({ hide: { effect: "slide", duration: 500} }).dialog("close"); } }, 4000);
        }
    }

    function selectAll() {
        $('#gridSelectionCount').text($('#searchCount').text());
        if ($('#selectAllDialog').dialog("isOpen")) $('#selectAllDialog').dialog("close");
        allSelected = true;
        $('#<%=SelectAll.ClientID %>').val(allSelected);
    }

    function toggleAll(cb) {
        $(".rowSelector input").each(function () { this.checked = cb.checked });
        updateSelectedCount();
    }

    function bindEvents() {
        $(".rowSelector input").click(updateSelectedCount);
        $(".allRowsSelector").click(function () { toggleAll(this) });
        $('#selectAllDialog').dialog({ autoOpen: false });
    }

    function validateActions() {
        var action = $("#<%=GridActions.ClientID %>").val();
        if (action == "") {
            alert("You must select an action to perform.");
            return false;
        }

        // validate we have some rows
        var selectedRowCount = $(".rowSelector input:checked").length;
        if (selectedRowCount < 1) {
            alert("You must select at least one item.");
            return false;
        }

        return true;
    }

    $(document).ready(function () {
        bindEvents();
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () { bindEvents(); });
    });

</script>
