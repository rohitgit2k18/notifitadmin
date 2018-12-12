<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.CouponUsageDetail" Title="Sales by Coupon"  CodeFile="CouponUsageDetail.aspx.cs" AutoEventWireup="True" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
            	<div class="caption">
            		<h1>
                        <asp:Localize ID="Caption" runat="server" Text="Sales by Coupon Code"></asp:Localize>
                        <asp:Localize ID="FromCaption" runat="server" Text=" from {0}" EnableViewState="false"></asp:Localize>
                        <asp:Localize ID="ToCaption" runat="server" Text=" to {0}" EnableViewState="false"></asp:Localize>
                    </h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/marketing" />
            	</div>
            </div>
            <div class="searchPanel">
                <table class="inputForm compact">
                    <tr>
                        <th>
                            <asp:Label ID="CouponLabel" runat="server" Text="Coupon Code:" AssociatedControlID="CouponList" ToolTip="Coupon to report on"></asp:Label> 
                        </th>
                        <td>
                            <asp:DropDownList ID="CouponList" runat="server" AppendDataBoundItems="true">
                                <asp:ListItem Text="All Coupons" Value=""></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <th>
                            <asp:Label ID="StartDateLabel" runat="server" Text="From:" AssociatedControlID="StartDate" ToolTip="Start date for report"></asp:Label> 
                        </th>
                        <td>
                            <uc1:PickerAndCalendar id="StartDate" runat="server"></uc1:PickerAndCalendar>
                            <asp:Label ID="EndDateLabel" runat="server" Text="to" AssociatedControlID="EndDate" ToolTip="End date for report"></asp:Label> 
                            <uc1:PickerAndCalendar id="EndDate" runat="server"></uc1:PickerAndCalendar>
                            <asp:DropDownList ID="DateFilter" runat="server" OnSelectedIndexChanged="DateFilter_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Value="">-- Date Quick Pick --</asp:ListItem>
                                <asp:ListItem Value="TODAY">Today</asp:ListItem>
                                <asp:ListItem Value="THISWEEK">This Week</asp:ListItem>
                                <asp:ListItem Value="LASTWEEK">Last Week</asp:ListItem>
                                <asp:ListItem Value="THISMONTH">This Month</asp:ListItem>
                                <asp:ListItem Value="LASTMONTH">Last Month</asp:ListItem>
                                <asp:ListItem Value="LAST30">Last 30 Days</asp:ListItem>
                                <asp:ListItem Value="LAST60">Last 60 Days</asp:ListItem>
                                <asp:ListItem Value="LAST90">Last 90 Days</asp:ListItem>
                                <asp:ListItem Value="LAST120">Last 120 Days</asp:ListItem>
                                <asp:ListItem Value="THISYEAR">This Year</asp:ListItem>
                                <asp:ListItem Value="ALL">All Dates</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:Button ID="ReportButton" runat="server" Text="Generate Report" OnClick="ReportButton_Click" ToolTip="Generate Report" />
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Repeater ID="CouponSalesRepeater" runat="server" DataSourceID="CouponSalesDs" Visible="false">
                <ItemTemplate>
                    <div class="section">
                        <div class="header">
                            <asp:Localize ID="CouponName" runat="server" Text='<%# Eval("CouponCode", "Orders that used {0}") %>'></asp:Localize>
                        </div>
                        <div class="content">
                            <asp:GridView ID="OrdersGrid" runat="server" AllowPaging="False" AllowSorting="False" 
                                AutoGenerateColumns="False" DataKeyNames="OrderId" SkinID="PagedList" Width="100%"
                                DataSource='<%# GetCouponOrders(Container.DataItem) %>'>
                                <Columns>
                                    <asp:TemplateField HeaderText="Order #" SortExpression="OrderId">
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' NavigateUrl='<%#String.Format("../Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber")) %>' SkinId="Link"></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:Label ID="OrderDate" runat="server" Text='<%# Eval("OrderDate", "{0:d}") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Products" SortExpression="ProductSubtotal">
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:Label ID="Subtotal" runat="server" Text='<%# ((decimal)Eval("ProductSubtotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total" SortExpression="TotalCharges">
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:Label ID="Total" runat="server" Text='<%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <asp:Label ID="EmptyMessage" runat="server" Text="There are no associated orders for this month."></asp:Label>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="CouponSalesDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSalesByCoupon" 
        TypeName="CommerceBuilder.Reporting.ReportDataSource">
        <SelectParameters>
            <asp:ControlParameter ControlID="StartDate" Name="startDate" PropertyName="SelectedDate" Type="DateTime" />
            <asp:ControlParameter ControlID="EndDate" Name="endDate" PropertyName="SelectedEndDate" Type="DateTime" />
            <asp:ControlParameter ControlID="CouponList" Name="couponCode" PropertyName="SelectedValue" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>