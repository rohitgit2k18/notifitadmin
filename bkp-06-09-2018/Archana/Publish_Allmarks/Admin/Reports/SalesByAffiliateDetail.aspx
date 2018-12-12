<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.SalesByAffiliateDetail" Title="Sales by Affiliate" CodeFile="SalesByAffiliateDetail.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
			<div class="pageHeader noPrint">
                <div class="caption">
                     <h1><asp:Localize ID="Caption" runat="server" Text="Affiliate Detail"></asp:Localize><asp:Localize ID="ReportDateCaption" runat="server" Text=" for {0:MMMM yyyy}" Visible="false" EnableViewState="false"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/marketing" />
                </div>
            </div>
			<div class="searchPanel">
                <div class="reportNav">
                    <asp:Button ID="PreviousButton" runat="server" Text="&laquo; Prev" OnClick="PreviousButton_Click" />&nbsp;<asp:Label ID="MonthLabel" runat="server" Text="Month: " SkinID="FieldHeader"></asp:Label>
                    <asp:DropDownList ID="MonthList" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DateFilter_SelectedIndexChanged">
                        <asp:ListItem Value="1" Text="January"></asp:ListItem>
                        <asp:ListItem Value="2" Text="February"></asp:ListItem>
                        <asp:ListItem Value="3" Text="March"></asp:ListItem>
                        <asp:ListItem Value="4" Text="April"></asp:ListItem>
                        <asp:ListItem Value="5" Text="May"></asp:ListItem>
                        <asp:ListItem Value="6" Text="June"></asp:ListItem>
                        <asp:ListItem Value="7" Text="July"></asp:ListItem>
                        <asp:ListItem Value="8" Text="August"></asp:ListItem>
                        <asp:ListItem Value="9" Text="September"></asp:ListItem>
                        <asp:ListItem Value="10" Text="October"></asp:ListItem>
                        <asp:ListItem Value="11" Text="November"></asp:ListItem>
                        <asp:ListItem Value="12" Text="December"></asp:ListItem>
                    </asp:DropDownList>&nbsp;
                    <asp:Label ID="YearLabel" runat="server" Text="Year: " SkinID="FieldHeader"></asp:Label>
                    <asp:DropDownList ID="YearList" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DateFilter_SelectedIndexChanged">
                    </asp:DropDownList>
                    &nbsp;
                    <asp:Button ID="NextButton" runat="server" Text="Next &raquo;" OnClick="NextButton_Click" />
                    &nbsp;
                    <asp:Label ID="AffiliateListLabel" runat="server" Text="Affiliate: " SkinID="FieldHeader"></asp:Label>
                    <asp:DropDownList ID="AffiliateList" runat="server" DataTextField="Name" DataValueField="AffiliateId" AppendDataBoundItems="True" AutoPostBack="true" OnSelectedIndexChanged="DateFilter_SelectedIndexChanged">
                        <asp:ListItem Text="All Affiliates" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <asp:Repeater ID="AffiliateSalesRepeater" runat="server" DataSourceID="AffiliateSalesDs" Visible="false">
                <ItemTemplate>
                    <div class="section">
                        <div class="header">
                            <h2>
                                <asp:Localize ID="AffiliateName" runat="server" Text='<%# Eval("AffiliateName") %>'></asp:Localize>
                                <asp:Localize ID="SalesForText" runat="server" Text=" Sales for "></asp:Localize>
                                <asp:Localize ID="ReportDate" runat="server" Text='<%# Eval("StartDate", "{0:MMMM yyyy}") %>'></asp:Localize>
                            </h2>
                        </div>
                        <div class="content">
                            <table width="100%" style="margin-bottom:10px;">
                                <tr>
                                    <th>
                                        <asp:Label ID="ReferralCountLabel" runat="server" Text="Referrals"></asp:Label>
                                    </th>
                                    <th>
                                        <asp:Label ID="OrderCountLabel" runat="server" Text="Orders"></asp:Label>
                                    </th>
                                    <th>
                                        <asp:Label ID="ConversionRateLabel" runat="server" Text="Conversion"></asp:Label>
                                    </th>
                                    <th>
                                        <asp:Label ID="ProductSubtotalLabel" runat="server" Text="Products"></asp:Label>
                                    </th>
                                    <th>
                                        <asp:Label ID="OrderTotalLabel" runat="server" Text="Total"></asp:Label>
                                    </th>
                                    <th>
                                        <asp:Label ID="CommissionRateLabel" runat="server" Text="Rate"></asp:Label>
                                    </th>
                                    <th>
                                        <asp:Label ID="CommissionLabel" runat="server" Text="Commission"></asp:Label>
                                    </th>
                                </tr>
                                <tr class="oddRow">
                                    <td align="center">
                                        <asp:Label ID="ReferralCount" runat="server" Text='<%#Eval("ReferralCount") %>'></asp:Label>
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="OrderCount" runat="server" Text='<%#Eval("OrderCount") %>'></asp:Label>
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="ConversionRate" runat="server" Text='<%#GetConversionRate(Container.DataItem)%>'></asp:Label><br />
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="ProductSubtotal" runat="server" Text='<%#((decimal)Eval("ProductSubtotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="OrderTotal" runat="server" Text='<%#((decimal)Eval("OrderTotal")).LSCurrencyFormat("lc") %>'></asp:Label><br />
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="CommissionRate" runat="server" Text='<%# GetCommissionRate(Container.DataItem) %>'></asp:Label>
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="Commission" runat="server" Text='<%# ((decimal)Eval("Commission")).LSCurrencyFormat("lc") %>'></asp:Label>
                                    </td>
                                </tr>
                            </table>
                            <asp:GridView ID="OrdersGrid" runat="server" AllowPaging="False" AllowSorting="False" 
                                AutoGenerateColumns="False" DataKeyNames="OrderId" SkinID="PagedList" Width="100%"
                                DataSource='<%# GetAffiliateOrders(Container.DataItem) %>'>
                                <Columns>
                                    <asp:TemplateField HeaderText="Order #" SortExpression="OrderId">
                                        <ItemStyle HorizontalAlign="Center" Width="25%" />
                                        <ItemTemplate>
                                            <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' NavigateUrl='<%#String.Format("../Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber")) %>' SkinId="Link"></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                                        <ItemStyle HorizontalAlign="Center" Width="25%" />
                                        <ItemTemplate>
                                            <asp:Label ID="OrderDate" runat="server" Text='<%# Eval("OrderDate", "{0:d}") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Products" SortExpression="ProductSubtotal">
                                        <ItemStyle HorizontalAlign="Center" Width="25%" />
                                        <ItemTemplate>
                                            <asp:Label ID="Subtotal" runat="server" Text='<%# ((decimal)Eval("ProductSubtotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Order Total" SortExpression="TotalCharges">
                                        <ItemStyle HorizontalAlign="Center" Width="25%" />
                                        <ItemTemplate>
                                            <asp:Label ID="Total" runat="server" Text='<%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Commission">
                                        <ItemStyle HorizontalAlign="Center" Width="25%" />
                                        <ItemTemplate>
                                            <asp:Label ID="Commission" runat="server" Text='<%# ((decimal)GetCommissionForOrder(Container.DataItem)).LSCurrencyFormat("lc") %>'></asp:Label>
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
            <asp:HiddenField ID="HiddenStartDate" runat="server" Value="" />
            <asp:HiddenField ID="HiddenEndDate" runat="server" Value="" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="AffiliateSalesDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSalesByAffiliate" 
        TypeName="CommerceBuilder.Reporting.ReportDataSource">
        <SelectParameters>
            <asp:ControlParameter ControlID="HiddenStartDate" Name="startDate" PropertyName="Value" Type="DateTime" />
            <asp:ControlParameter ControlID="HiddenEndDate" Name="endDate" PropertyName="Value" Type="DateTime" />
            <asp:ControlParameter ControlID="AffiliateList" Name="affiliateId" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>