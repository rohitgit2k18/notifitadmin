<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Marketing.Coupons._Default" Title="Coupons" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Coupons"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="marketing" />
    	</div>
    </div>
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="Coupons require the customer to enter a code during checkout for discounts toward the order amount, a specific product or line item, or shipping charges."></asp:Localize></p>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Panel ID="SearchPanel" runat="server"  CssClass="searchPanel" DefaultButton="SearchButton">
                <asp:ValidationSummary ID="SearchSummary" runat="server" ValidationGroup="SearchGroup" />
                <table cellspacing="0" class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="CouponCodeLabel" runat="server" Text="Coupon Code:" ToolTip="Coupon code to search." AssociatedControlID="CouponCode" />
                        </th>
                        <td>
                            <asp:TextBox ID="CouponCode" runat="server" Width="200px"></asp:TextBox>
                            <cb:SearchKeywordValidator ID="CouponCodeValidator" runat="server" ControlToValidate="CouponCode"
                                ErrorMessage="CouponCode must not start with wild card character." Text="*" ValidationGroup="CouponSearch"></cb:SearchKeywordValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="UsageFilterLabel" runat="server" Text="Filter By:" ToolTip="Select the coupon usage filter." AssociatedControlID="UsageFilter" />
                        </th>
                        <td>
                            <asp:DropDownList ID="UsageFilter" runat="server">
                                <asp:ListItem Text="All Coupons" Value="Any" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Used Coupons only" Value="UsedCouponsOnly" ></asp:ListItem>
                                <asp:ListItem Text="Unused Coupons only" Value="UnusedCouponsOnly"></asp:ListItem>
                                <asp:ListItem Text="Invalid/Expired Coupons only" Value="InvalidOrExpiredCouponsOnly"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                    <td colspan="2" align="center">
                        <asp:Button ID="SearchButton" runat="server" Text="Search" SkinID="Button" onclick="SearchButton_Click" ValidationGroup="SearchGroup" />
                        <asp:Button ID="ResetButton" runat="server" Text="Reset" SkinID="CancelButton" CausesValidation="false" onclick="ResetButton_Click" />
                        <asp:HyperLink ID="AddLink" runat="server" Text="Add Coupon" NavigateUrl="AddCoupon.aspx" SkinID="AddButton"></asp:HyperLink>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <div class="content">
                <cb:AbleGridView ID="CouponGrid" runat="server" 
                    AutoGenerateColumns="False" 
                    DataKeyNames="Id"
                    DataSourceID="CouponDs" 
                    AllowPaging="True" 
                    PageSize="10" 
                    TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching coupons" 
                    SkinID="PagedList" 
                    ShowWhenEmpty="False" 
                    AllowMultipleSelections="False"
                    AllowSorting="true" 
                    Width="100%" 
                    DefaultSortExpression="Name" 
                    OnRowDataBound="CouponGrid_RowDataBound"
                    OnRowCommand="CouponGrid_RowCommand">
                    <Columns>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" Width="20px" />
                            <HeaderTemplate>
                                <input id="ALL" type="checkbox" runat="server" class="allRowsSelector" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <input id="CID" type="checkbox" runat="server" class="rowSelector" value='<%#Eval("Id")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="Name" runat="server" NavigateUrl='<%# Eval("CouponId", "EditCoupon.aspx?CouponId={0}") %>' Text='<%# Eval("Name") %>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Code" SortExpression="CouponCode">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="CouponCode" runat="server" Text='<%# Eval("CouponCode") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="CouponType" runat="server" Text='<%# Eval("CouponType") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Discount">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="Discount" runat="server" Text='<%# GetDiscount((Coupon)Container.DataItem) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Restrictions">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Panel ID="MaxValuePanel" runat="server">
                                    <asp:Label ID="MaxValueLabel" runat="server" text="Max Value: " SkinID="FieldHeader"></asp:Label>
                                    <asp:Label ID="MaxValue" runat="server" Text='<%# ((decimal)Eval("MaxValue")).LSCurrencyFormat("lc") %>'></asp:Label><br />
                                </asp:Panel>
                                <asp:Panel ID="MinPurchasePanel" runat="server">
                                    <asp:Label ID="MinPurchaseLabel" runat="server" text="Min Purchase: " SkinID="FieldHeader"></asp:Label>
                                    <asp:Label ID="MinPurchase" runat="server" Text='<%# ((decimal)Eval("MinPurchase")).LSCurrencyFormat("lc") %>'></asp:Label><br />
                                </asp:Panel>
                                <asp:Panel ID="StartDatePanel" runat="server">
                                    <asp:Label ID="StartDateLabel" runat="server" text="Start Date: " SkinID="FieldHeader"></asp:Label>
                                    <asp:Label ID="StartDate" runat="server" Text='<%# Eval("StartDate", "{0:d}") %>'></asp:Label>
                                </asp:Panel>
                                <asp:Panel ID="EndDatePanel" runat="server">
                                    <asp:Label ID="EndDateLabel" runat="server" text="End Date: " SkinID="FieldHeader"></asp:Label>
                                    <asp:Label ID="EndDate" runat="server" Text='<%# Eval("EndDate", "{0:d}") %>'></asp:Label>
                                </asp:Panel>
                                <asp:Panel ID="MaximumUsesPanel" runat="server">
                                    <asp:Label ID="MaximumUsesLabel" runat="server" text="Max Uses: " SkinID="FieldHeader"></asp:Label>
                                    <asp:Label ID="MaximumUses" runat="server" Text='<%# Eval("MaxUses") %>'></asp:Label><br />
                                </asp:Panel>
                                <asp:Panel ID="MaximumUsesPerCustomerPanel" runat="server">
                                    <asp:Label ID="MaximumUsesPerCustomerLabel" runat="server" text="Uses Per Customer: " SkinID="FieldHeader"></asp:Label>
                                    <asp:Label ID="MaximumUsesPerCustomer" runat="server" Text='<%# Eval("MaxUsesPerCustomer") %>'></asp:Label><br />
                                </asp:Panel>
                                <asp:Panel ID="GroupsPanel" runat="server">
                                    <asp:Label ID="GroupsLabel" runat="server" text="Groups: " SkinID="FieldHeader"></asp:Label>
                                    <asp:Label ID="Groups" runat="server" Text='<%# GetNames((Coupon)Container.DataItem) %>'></asp:Label>
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Uses">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:HyperLink ID="UsageLink" runat="server" Text='<%#GetUseCount((string)Eval("CouponCode"))%>' NavigateUrl='<%# string.Format("../../Reports/CouponUsageDetail.aspx?CouponCode={0}", Server.UrlEncode(Eval("CouponCode").ToString())) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" Width="81px" />
                            <ItemTemplate>
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%# Eval("CouponId", "EditCoupon.aspx?CouponId={0}") %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit"></asp:Image></asp:HyperLink>
                                <asp:ImageButton ID="CopyButton" runat="server" AlternateText="Copy" SkinID="CopyIcon" CommandName="Copy" CommandArgument='<%#Eval("CouponId")%>' />
                                <asp:ImageButton ID="DeleteButton" runat="server" AlternateText="Delete" SkinID="DeleteIcon" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="NoCouponsText" runat="server" Text="<i>There are no coupons defined.</i>"></asp:Label>
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
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="CouponDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="Search"
        SelectCountMethod="SearchCount"
        TypeName="CommerceBuilder.Marketing.CouponDataSource" 
        DataObjectTypeName="CommerceBuilder.Marketing.Coupon" 
        DeleteMethod="Delete"
        SortParameterName="sortExpression">
        <SelectParameters>
            <asp:ControlParameter Name="couponCode" ControlID="CouponCode" DefaultValue="" PropertyName="Text" Type="String" />
            <asp:ControlParameter Name="usageFilter" DefaultValue="Any" ControlID="UsageFilter" PropertyName="SelectedValue" Type="Object" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <script language="javascript" type="text/javascript">
        var allSelected = false;
        function deleteConfirmation() {
            var selectedRows = $(".selectRow input:checkbox:checked").length;
            if (selectedRows > 0) {
                var msg = selectedRows == 1 ? "" : "s";
                return confirm("Delete " + selectedRows + " selected coupons" + msg + "?");
            }
            else {
                alert("At least one coupon must be selected.");
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
            var pageSize = parseInt($('#<%=CouponGrid.ClientID%> select').val());
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
                url: "Default.aspx/DeleteCoupons",
                data: "{couponIds: " + JSON.stringify(selectedRows) + "}",
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
                url: "Default.aspx/DeleteAllCoupons",
                data: "{filter: " + JSON.stringify(searchFilter) + "}",
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



