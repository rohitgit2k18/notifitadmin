<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Countries.EditProvinces" Title="Edit Provinces"  CodeFile="EditProvinces.aspx.cs" %>
<%@ Register Src="AddProvinceDialog.ascx" TagName="AddProvinceDialog" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ContentAjax" runat="server" UpdateMode="conditional">
        <ContentTemplate>
            <div class="pageHeader">
            	<div class="caption">
            		<h1><asp:Localize ID="Caption" runat="server" Text="{0}: States and Provinces"></asp:Localize></h1>
            	</div>
            </div>
            <div class="grid_6 alpha">
                <div class="mainColumn">
                    <div class="content">
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="EditProvince" />
                        <cb:AbleGridView ID="ProvinceGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="ProvinceId,CountryCode" DataSourceId="ProvinceDs"
 	 	 	                SkinID="PagedList" AllowPaging="true" PageSize="20" AllowSorting="true" DefaultSortDirection="ascending"
 	 	 	                DefaultSortExpression="Name" Width="100%"
 	 	 	                TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching provinces">
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
                                <asp:TemplateField HeaderText="Code" SortExpression="ProvinceCode">
                                    <HeaderStyle HorizontalAlign="Center" Width="60px" />
                                    <ItemStyle HorizontalAlign="Center" Width="60px" />
                                    <ItemTemplate>
                                        <asp:Label ID="ProvinceCode" runat="server" Text='<%# Eval("ProvinceCode") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="EditProvinceCode" runat="server" Width="45px" MaxLength="4" Text='<%# Bind("ProvinceCode") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                    <HeaderStyle HorizontalAlign="Left" Width="200px" />
                                    <ItemStyle HorizontalAlign="Left" Width="200px" />
                                    <ItemTemplate>
                                        <asp:Label ID="Name" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="EditName" runat="server" Text='<%# Bind("Name") %>' Width="185px" MaxLength="50"></asp:TextBox><span class="requiredField">*</span>
                                        <cb:RequiredRegularExpressionValidator ID="NameValidator" runat="server" ControlToValidate="EditName"
                                            Display="Static" ErrorMessage="Name must be between 1 and 50 characters in length." Text="*"
                                            ValidationGroup="EditProvince" ValidationExpression=".{1,50}" Required="true">
                                        </cb:RequiredRegularExpressionValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderStyle HorizontalAlign="Center" Width="60px" />
                                    <ItemStyle HorizontalAlign="Center" Width="60px" />
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit"><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" /></asp:LinkButton>
                                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" /></asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:ImageButton ID="EditSaveButton" runat="server" CausesValidation="True" ValidationGroup="EditProvince" CommandName="Update" SkinID="SaveIcon" ToolTip="Save"></asp:ImageButton>
                                        <asp:ImageButton ID="EditCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" SkinID="CancelIcon" ToolTip="Cancel"></asp:ImageButton>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="EmptyMessage" runat="server" Text="There are no states or provinces defined for this country."></asp:Label>
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
                        <asp:ObjectDataSource ID="ProvinceDs" runat="server" DataObjectTypeName="CommerceBuilder.Shipping.Province"
                            DeleteMethod="Delete" InsertMethod="Insert" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="LoadForCountry" TypeName="CommerceBuilder.Shipping.ProvinceDataSource"
                            UpdateMethod="Update" SortParameterName="sortExpression">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="countryCode" QueryStringField="CountryCode" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <uc:AddProvinceDialog ID="AddProvinceDialog1" runat="server" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script language="javascript" type="text/javascript">
        var allSelected = false;
        function deleteConfirmation() {
            var selectedRows = $(".selectRow input:checkbox:checked").length;
            if (selectedRows > 0) {
                var msg = selectedRows == 1 ? "" : "s";
                return confirm("Delete " + selectedRows + " selected proince" + msg + "?");
            }
            else {
                alert("At least one province must be selected.");
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
            var pageSize = parseInt($('#<%=ProvinceGrid.ClientID%> select').val());
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
                url: "EditProvinces.aspx/DeleteProvinces",
                data: "{provinceIds: " + JSON.stringify(selectedRows) + "}",
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
                url: "EditProvinces.aspx/DeleteAllProvinces",
                data: "{countryCode: " + JSON.stringify(countryCode) + "}",
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