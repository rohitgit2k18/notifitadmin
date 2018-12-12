<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Orders._Default" Title="Order Manager" CodeFile="Default.aspx.cs" %>
<%@ Register Src="../UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<link type="text/css" rel="Stylesheet" href="../../Scripts/qTip2/jquery.qtip.min.css" />
<script language="javascript" type="text/javascript" src="../../Scripts/qTip2/jquery.qtip.min.js"></script>
<div class="pageHeader">
    <div class="caption">
        <h1><asp:Localize ID="Caption" runat="server" Text="Order Manager"></asp:Localize></h1>
        <div class="links">
            <cb:NavigationLink ID="OrderManagerLink" runat="server" Text="Order Manager" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
            <cb:NavigationLink ID="PayManagerLink" runat="server" Text="Payments" SkinID="Button" NavigateUrl="PaymentManager.aspx"></cb:NavigationLink>
            <cb:NavigationLink ID="NotesLink" runat="server" Text="Order Notes" SkinID="Button" NavigateUrl="OrderNotesManager.aspx"></cb:NavigationLink>
        </div>
    </div>
</div>
<asp:UpdatePanel ID="SearchFormAjax" runat="server">
    <ContentTemplate>
        <div class="searchPanel">
            <table cellspacing="0" class="inputForm">
                 <tr>
                    <td>&nbsp;</td>
                    <td colspan="5">
                        <asp:Panel ID="HeaderPanel" runat="server" DefaultButton="JumpToOrderButton">
                            <asp:Label ID="JumpToOrderLabel" runat="server" Text="Jump to Order #:" AssociatedControlID="JumpToOrderNumber" SkinID="FieldHeader"></asp:Label>
                            <asp:TextBox ID="JumpToOrderNumber" runat="server" Width="50px" ValidationGroup="QuickOrderView" AutoComplete="off"></asp:TextBox>
                            <asp:Button ID="JumpToOrderButton" runat="server" ValidationGroup="JumpToOrder" Text="Go" OnClick="JumpToOrderButton_Click" />
                            <asp:PlaceHolder ID="phJumpToOrder" runat="server"></asp:PlaceHolder>
                            <asp:RequiredFieldValidator ID="JumpToOrderNumberRequired" runat="server"
                                ControlToValidate="JumpToOrderNumber" Text="enter order number" 
                                ErrorMessage="" ValidationGroup="JumpToOrder" Display="dynamic"></asp:RequiredFieldValidator><asp:RegularExpressionValidator ID="JumpToOrderNumberValidator" runat="server"
                                ControlToValidate="JumpToOrderNumber" ValidationExpression="^\d+$" Text="enter numbers only" 
                                ErrorMessage="" ValidationGroup="JumpToOrder" Display="dynamic"></asp:RegularExpressionValidator>
                        </asp:Panel>
                    </td>
                 </tr>
                 <tr>
                    <th>
                        <cb:ToolTipLabel ID="DateFilterLabel" runat="server" Text="Date Range:" ToolTip="Filter orders that were placed within the start and end dates." />
                    </th>
                    <td>
                        <uc1:PickerAndCalendar ID="OrderStartDate" runat="server" />
                        to <uc1:PickerAndCalendar ID="OrderEndDate" runat="server" />
                    </td>
                    <td colspan="2">
                        <asp:DropDownList ID="DateQuickPick" runat="server" onchange="alert(this.selectedIndex);">
                            <asp:ListItem Value="-- Date Quick Pick --"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="StatusFilterLabel" runat="server" Text="Order Status:" AssociatedControlID="StatusFilter" ToolTip="Filter by order status." />
                    </th>
                    <td>
                        <asp:DropDownList ID="StatusFilter" runat="server">
                            <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="OrderNumberFilterLabel" runat="server" Text="Order Number(s):" AssociatedControlID="OrderNumberFilter"
                            ToolTip="You can enter order number(s) to filter the list.  Separate multiple orders with a comma.  You can also enter ranges like 4-10 for all orders numbered 4 through 10." />
                    </th>
                    <td colspan="3">
                        <asp:TextBox ID="OrderNumberFilter" runat="server" Text="" Width="200px" AutoComplete="off"></asp:TextBox>
                        <cb:IdRangeValidator ID="OrderNumberFilterValidator" runat="server" Required="false"
                            ControlToValidate="OrderNumberFilter" Text="*" 
                            ErrorMessage="The range is invalid.  Enter a specific order number or a range of numbers like 4-10.  You can also include mulitple values separated by a comma."></cb:IdRangeValidator>                
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="ShipmentStatusFilterLabel" runat="server" Text="Shipment Status:" AssociatedControlID="ShipmentStatusFilter" ToolTip="Filter orders by shipment status." />
                    </th>
                    <td>
                        <asp:DropDownList ID="ShipmentStatusFilter" runat="server">
                            <asp:ListItem Text="All" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Unshipped" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Shipped" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Non-Shippable" Value="3"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="KeywordSearchTextLabel" runat="server" Text="Find Keyword:" AssociatedControlID="KeywordSearchText" ToolTip="Enter a keyword to find.  Use of wildcard * allowed."></cb:ToolTipLabel>
                    </th>
                    <td colspan="3">
                        <asp:TextBox ID="KeywordSearchText" runat="server" Width="200px" MaxLength="100" AutoComplete="off"></asp:TextBox> 
                        <asp:Label ID="KeywordSearchFieldLabel" runat="server" Text=" in "></asp:Label>
                        <asp:DropDownList ID="KeywordSearchField" runat="server">
                            <asp:ListItem Value="BillingInfo" Text="Billing Info"></asp:ListItem>
                            <asp:ListItem Value="ShippingInfo" Text="Shipping Info"></asp:ListItem>
                            <asp:ListItem Value="Notes" Text="Notes"></asp:ListItem>
                            <asp:ListItem Value="Sku" Text="Sku"></asp:ListItem>
                            <asp:ListItem Value="ProductName" Text="Product Name"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="PaymentStatusFilterLabel" runat="server" Text="Payment Status:" AssociatedControlID="PaymentStatusFilter" ToolTip="Filter orders by payment status." />
                    </th>
                    <td>
                        <asp:DropDownList ID="PaymentStatusFilter" runat="server">
                            <asp:ListItem Text="All" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Unpaid" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Paid" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td colspan="5">
                        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" CausesValidation="false"/>
                        <asp:Button ID="ResetSearchButton" runat="server" Text="Reset" Visible="false" SkinID="CancelButton" OnClick="ResetButton_Click" CausesValidation="false"/>
                        <asp:Button ID="CreateOrderButton" runat="server" Text="New Order" SkinID="AddButton" OnClick="CreateOrderButton_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<div class="content">
    <asp:UpdatePanel ID="SearchResultAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <cb:Notification ID="BatchMessage" runat="server" SkinID="GoodCondition" Visible="false"></cb:Notification>
            <cb:AbleGridView ID="OrderGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="True" PageSize="20" 
                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="OrderDs"
                OnRowCommand="OrderGrid_RowCommand" DefaultSortExpression="Id" DefaultSortDirection="Descending" 
                OnRowDataBound="OrderGrid_RowDataBound" ShowWhenEmpty="False" OnRowCreated="OrderGrid_RowCreated"
                TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching orders">
                <Columns>
                    <asp:TemplateField>
                        <ItemStyle HorizontalAlign="Center" Width="20px" />
                        <HeaderTemplate>
                            <input id="ALL" name="ALL" type="checkbox" class="allRowsSelector" />
                        </HeaderTemplate>
                        <ItemTemplate>
                            <input id="OID" name="OID" type="checkbox" class="rowSelector" value='<%#Eval("OrderNumber")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" SortExpression="OrderStatusId">
                        <ItemStyle HorizontalAlign="Left" Height="30px" />
                        <ItemTemplate>
                            <asp:Label ID="OrderStatus" runat="server" Text='<%# GetOrderStatus(Eval("OrderStatusId")) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Customer" SortExpression="BillToLastName">
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:Label ID="CustomerName" runat="server" Text='<%# string.Format("{1}, {0}", Eval("BillToFirstName"), Eval("BillToLastName")) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Amount" SortExpression="TotalCharges">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:Label ID="Label5" runat="server" Text='<%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:Label ID="Label6" runat="server" Text='<%# Eval("OrderDate", "{0:G}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Payment">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:PlaceHolder ID="phPaymentStatus" runat="server"></asp:PlaceHolder>
                            <asp:Label ID="PaymentStatus" runat="server" Text='<%# GetPaymentStatus(Container.DataItem) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Shipment">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:PlaceHolder ID="phShipmentStatus" runat="server"></asp:PlaceHolder>
                            <asp:Label ID="ShipmentStatus" runat="server" Text='<%# Eval("ShipmentStatus") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:HyperLink ID="DetailsLink" runat="server" NavigateUrl='<%#String.Format("ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber")) %>' rel='<%#String.Format("OrderSummary.ashx?OrderId={0}", Eval("OrderId")) %>'><asp:Image ID="PreviewIcon" runat="server" SkinID="PreviewIcon" AlternateText="View Order" ToolTip="View Order" /></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Label ID="EmptyMessage" runat="server" Text="No orders match criteria."></asp:Label>
                </EmptyDataTemplate>
            </cb:AbleGridView>
            <asp:HiddenField ID="SelectAll" runat="server" value="False" />
            <asp:PlaceHolder ID="selectedOrdersPanel" runat="server">
                <div id="gridFooter">
                    <span id="gridSelectionCount">0</span> Selected Item(s): 
                    <asp:DropDownList ID="BatchAction" runat="server">
                        <asp:ListItem Text=""></asp:ListItem>
                        <asp:ListItem Text="Process Payment" Value="PAY"></asp:ListItem>
                        <asp:ListItem Text="Mark Shipped" Value="SHIP"></asp:ListItem>
                        <asp:ListItem Text="Mark Shipped with Options" Value="SHIPOPT"></asp:ListItem>
                        <asp:ListItem Text="Cancel" Value="CANCEL"></asp:ListItem>
                        <asp:ListItem Text="-----------"></asp:ListItem>
                        <asp:ListItem Text="Print Invoices" Value="INVOICE"></asp:ListItem>
                        <asp:ListItem Text="Print Packing Slips" Value="PACKSLIP"></asp:ListItem>
                        <asp:ListItem Text="Print Pull Sheet" Value="PULLSHEET"></asp:ListItem>
                        <asp:ListItem Text="-----------"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="BatchButton" runat="server" Text="Go" OnClick="BatchButton_Click" OnClientClick="return gridGo();" />
                </div>
                <div id="selectAllDialog" title="Expand Selection?">
                    <p>You have selected only the items on the current page.</p>
                    <p><a href="javascript:selectAll()">select results from all pages</a></p>
                </div>
            </asp:PlaceHolder>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<asp:HiddenField ID="HiddenStartDate" runat="server" />
<asp:HiddenField ID="HiddenEndDate" runat="server" />
<asp:ObjectDataSource ID="OrderDs" runat="server" OldValuesParameterFormatString="original_{0}"
    SelectMethod="LoadForFilter" SelectCountMethod="CountForFilter" SortParameterName="sortExpression" TypeName="CommerceBuilder.Search.OrderFilterDataSource"
    OnSelecting="OrderDs_Selecting" EnablePaging="true">
    <SelectParameters>
        <asp:Parameter Name="filter" Type="Object" />
    </SelectParameters>
</asp:ObjectDataSource>
<script language="javascript" type="text/javascript">
    var allSelected = false;

    function updateSelectedCount() {
        allSelected = false;
        $('#<%=SelectAll.ClientID %>').val(allSelected);
        if ($('#selectAllDialog').dialog("isOpen")) $('#selectAllDialog').dialog("close");
        var selectedRows = $(".rowSelector:checked").length;
        $("#gridSelectionCount").text(selectedRows.toString());
        var totalRows = $(".rowSelector").length;
        var allRowsSelector = $(".allRowsSelector:first");
        allRowsSelector.attr("checked", (totalRows == selectedRows));
        var resultSize = parseInt($('#searchCount').text());
        var pageSize = parseInt($('#<%=OrderGrid.ClientID%> select').val());
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
        $('#<%=SelectAll.ClientID %>').val(allSelected);
    }

    function toggleAll(cb) {
        $(".rowSelector").each(function () { this.checked = cb.checked });
        updateSelectedCount();
    }

    function gridGo() {
        // validate we have some rows
        var selectedRowCount = $(".rowSelector:checked").length;
        if (selectedRowCount < 1) {
            alert("You must select at least one item.");
            return false;
        }

        // examine the action
        var action = $("#<%=BatchAction.ClientID %>").val();
        if (action == "") {
            alert("You must select an action.");
            return false;
        }

        // confirm delete
        if (action == "DELETE") {
            return confirm("Delete " + $('#gridSelectionCount').text() + " order(s)?");
        }

        // ignore anything else but export
        if (action != "EXPORT" || !allSelected) return true;

        // redirect to export
        if (allSelected) {
            window.location.href = "../DataExchange/OrdersExport.aspx?type=filter&filter=" + encodeURIComponent(JSONstringify(searchQuery));
        }

        return false;
    }
    
    function JSONstringify(obj) {
        return JSON.stringify(obj).replace(/\/Date/g, "\\\/Date").replace(/\)\//g, "\)\\\/")
    }

    function bindEvents() {
        $(".rowSelector").click(updateSelectedCount);
        $(".allRowsSelector").click(function () { toggleAll(this) });
        $('#selectAllDialog').dialog({ autoOpen: false });
    }

    $(document).ready(function () {
        bindEvents();
        bindHoverPanel();
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () { bindEvents(); bindHoverPanel(); });
    });

    function bindHoverPanel() {
        $('a[href*="ViewOrder.aspx?"][rel]').each(function () {
            $(this).qtip(
		{
		    content: {
		        text: '<img class="throbber" src="/Scripts/qtip2/throbber.gif" alt="Loading..." />',
		        ajax: {
		            url: $(this).attr('rel')
		        }
		    },
		    position: {
		        at: 'bottom center',
		        my: 'top center',
		        viewport: $(window),
		        effect: false
		    },
		    show: {
		        event: 'mouseover',
		        solo: true
		    },
		    hide: {
		        event: 'mouseout',
		        delay: 200,
		        fixed: true
		    },
		    style: {
		        classes: 'qtip-light qtip-shadow'
		    }
		})
        });
    }
</script>
</asp:Content>