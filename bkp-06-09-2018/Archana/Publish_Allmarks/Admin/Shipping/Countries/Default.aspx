<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Countries._Default" Title="Manage Countries"  CodeFile="Default.aspx.cs"  %>
<%@ Register Src="AddCountryDialog.ascx" TagName="AddCountryDialog" TagPrefix="uc" %>
<%@ Register Src="EditCountryDialog.ascx" TagName="EditCountryDialog" TagPrefix="uc" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server" UpdateMode="conditional">
        <ContentTemplate>
            <div class="pageHeader">
            	<div class="caption">
            		<h1><asp:Localize ID="Caption" runat="server" Text="Countries"></asp:Localize></h1>
	                <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/regions" />
            	</div>
            </div>
            <div class="grid_6 alpha">
                <div class="mainColumn">
                    <div class="searchPanel">
                        <asp:Label ID="AlphabetRepeaterLabel" AssociatedControlID="AlphabetRepeater" runat="server" Text="Quick Search:" SkinID="FieldHeader"></asp:Label>
                        <asp:Repeater runat="server" id="AlphabetRepeater">
                            <ItemTemplate>
                                <asp:HyperLink runat="server" ID="HyperLink1" Text="<%#Container.DataItem%>" NavigateUrl='<%# "Default.aspx?c=" + DataBinder.Eval(Container, "DataItem").ToString() %>' ></asp:HyperLink>
                            </ItemTemplate>                                    
                        </asp:Repeater>
                    </div>
                    <div class="content">
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="CountryList" />
                        <cb:AbleGridView ID="CountryGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceId="CountryDs" 
                            SkinID="PagedList" AllowPaging="true" PageSize="20" AllowSorting="true" DefaultSortDirection="ascending" 
                            DefaultSortExpression="Name" Width="100%" OnRowEditing="CountryGrid_RowEditing" OnRowCancelingEdit="CountryGrid_RowCancelingEdit"
                            TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching countries">
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
                                <asp:TemplateField HeaderText="Code" SortExpression="Id">
                                    <HeaderStyle Width="50px" HorizontalAlign="left" />
                                    <ItemStyle Width="50px" HorizontalAlign="left" />
                                    <ItemTemplate>
                                        <asp:Label ID="CountryCode" runat="server" Text='<%#Eval("CountryCode")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                    <HeaderStyle HorizontalAlign="left" />
                                    <ItemStyle HorizontalAlign="left" />
                                    <ItemTemplate>
                                        <asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="State/Province" ItemStyle-HorizontalAlign="center">
                                    <ItemTemplate>
                                        <asp:HyperLink ID="ProvincesLink" runat="server" Text='<%#Eval("Provinces.Count")%>' NavigateUrl='<%# Eval("CountryCode", "EditProvinces.aspx?CountryCode={0}")%>' SkinID="GridLink"></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemStyle HorizontalAlign="Center" width="60px" />
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="CancelLinkButton" runat="server" CausesValidation="False" CommandName="Cancel"><asp:Image ID="CancelIcon" runat="server" SkinID="CancelIcon" AlternateText="Cancel" /></asp:LinkButton>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditLinkButton" runat="server" CausesValidation="False" CommandName="Edit"><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></asp:LinkButton>
                                        <asp:LinkButton ID="DeleteLinkButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="emptyData">
                                    <asp:Label ID="CountriesInstructionText" runat="server" Text="No countries match the current filter."></asp:Label><br /><br />
                                </div>
                            </EmptyDataTemplate>
                        </cb:AbleGridView>
                        <div id="gridFooter" runat="server" clientidmode="Static">
                            <span id="gridSelectionCount">0</span> Selected Item(s): 
                            <select id="gridAction">
                                <option />
                                <option>Delete</option>
                            </select>
                            <input type="button" class="button" value="Go" onclick="gridGo()" />
                        </div>
                        <div id="selectAllDialog" title="Expand Selection?">
                            <p>You have selected only the items on the current page.</p>
                            <p><a href="javascript:selectAll()">select results from all pages</a></p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <uc:AddCountryDialog ID="AddCountryDialog1" runat="server" />
                    <uc:EditCountryDialog ID="EditCountryDialog1" runat="server" OnItemUpdated="EditCountryDialog1_ItemUpdated" OnCancelled="EditCountryDialog1_Cancelled"  Visible="false" />
                </div>
            </div>
    <asp:ObjectDataSource ID="CountryDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="SearchByName" 
        TypeName="CommerceBuilder.Shipping.CountryDataSource" SelectCountMethod="SearchByNameCount"
        SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Shipping.Country"
        DeleteMethod="Delete" EnablePaging="true" 
        onselecting="CountryDs_Selecting">
            <SelectParameters>
                <asp:Parameter Name="name" Type="string" DefaultValue="" />
            </SelectParameters>
    </asp:ObjectDataSource>
    </ContentTemplate>
</asp:UpdatePanel>
    <script language="javascript" type="text/javascript">
        var allSelected = false;
        function deleteConfirmation() {
            var selectedRows = $(".selectRow input:checkbox:checked").length;
            if (selectedRows > 0) {
                var msg = selectedRows == 1 ? "" : "s";
                return confirm("Delete " + selectedRows + " selected country" + msg + "?");
            }
            else {
                alert("At least one country must be selected.");
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
            var pageSize = parseInt($('#<%=CountryGrid.ClientID%> select').val());
            if ((totalRows == selectedRows) && (resultSize > pageSize)) {
                var position = allRowsSelector.position();
                var x = position.left + $(allRowsSelector).outerWidth() + 20;
                var y = position.top - $(document).scrollTop();
		$('#selectAllDialog').dialog("open" );
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
            if (action != "Delete" && action != "Export") {
                alert("You must select an action to perform.");
                return;
            }

            // validate we have some rows
            var selectedRowCount = $(".rowSelector:checked").length;
            if (selectedRowCount < 1) {
                alert("You must select at least one item.");
                return;
            }

            // choose the correct the action
            var selectedRows = new Array();
            $(".rowSelector:checked").each(function () { selectedRows.push(this.value); });
            if (action == "Delete") {
                // confirm delete
                if (!confirm("Are you sure you want to delete " + $("#gridSelectionCount").text() + " selected item(s)?")) return;
                // execute delete
                if (allSelected) deleteAll();
                else deleteSelected(selectedRows);
                $(".rowSelector:checked").each(function () { this.checked = false });
            }
        }

        function deleteSelected(selectedRows) {
            $.ajax({
                type: "POST",
                url: "Default.aspx/DeleteCountries",
                data: "{countryIds: " + JSON.stringify(selectedRows) + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {
                    location.reload(true);
                }
            });
        }

        function deleteAll() {
            $.ajax({
                type: "POST",
                url: "Default.aspx/DeleteAllCountries",
                data: "{alphabet: " + JSON.stringify(searchedAlphabet) + "}",
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
        }

        $(document).ready(function () {
            bindEvents();
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () { bindEvents() });
        });
    </script>
</asp:Content>