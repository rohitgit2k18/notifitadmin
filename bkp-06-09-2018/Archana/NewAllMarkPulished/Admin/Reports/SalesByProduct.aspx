<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Title="Sales by Product" Inherits="AbleCommerce.Admin.Reports.ProductBreakdown" CodeFile="SalesByProduct.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:PostBackTrigger ControlID="ExportButton" />
        </Triggers>
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1>
                        <asp:Localize ID="Caption" runat="server" Text="Sales by Product"></asp:Localize>
                        <asp:Localize ID="FromCaption" runat="server" Text=" from {0}" EnableViewState="false"></asp:Localize>
                        <asp:Localize ID="ToCaption" runat="server" Text=" to {0}" EnableViewState="false"></asp:Localize>
                   </h1>
                   <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/products" />
                </div>
            </div>
            <div class="searchPanel">
                <table class="inputForm compact">
                    <tr>
                        <th>
                            <asp:Label ID="StartDateLabel" runat="server" Text="Show sales from:" AssociatedControlID="StartDate"></asp:Label>
                        </th>
                        <td>
                            <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                            <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader" AssociatedControlID="EndDate"></asp:Label>
                            <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                        </td>
                        <th>
                            <asp:Label ID="VendorListLabel" runat="server" Text="Vendor:" AssociatedControlID="VendorList"></asp:Label>
                        </th>
                        <td>
                            <asp:DropDownList ID="VendorList" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
                            <asp:Button ID="ExportButton" runat="server" Text="Export Results" OnClick="ExportButton_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content">
                <cb:SortedGridView ID="ProductBreakdownGrid" runat="server" AutoGenerateColumns="False" AllowSorting="true"
                    AllowPaging="false" Width="100%" SkinID="PagedList" ShowFooter="true" DefaultSortDirection="Descending" DefaultSortExpression="Amount">
                    <Columns>
                        <asp:TemplateField HeaderText="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>                                        
                                <asp:HyperLink ID="ProductLink" runat="server" Text='<%#Eval("Name")%>' NavigateUrl='<%#String.Format("~/Admin/Products/EditProduct.aspx?ProductId={0}",Eval("ProductId"))%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sku">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%# Eval("Sku") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Vendor">
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <%# Eval("Vendor") %>
                            </ItemTemplate>
                            <FooterTemplate>
                                Totals:
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity" SortExpression="Quantity">
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%# Eval("Quantity") %>
                            </ItemTemplate>
                            <FooterTemplate>
                                <%# TotalQuantity %>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cost of Goods" SortExpression="CostOfGoods">
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("CostOfGoods")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                            <FooterTemplate>
                                <%# CostOfGoods.LSCurrencyFormat("lc")%>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coupons">
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("Coupons")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                            <FooterTemplate>
                                <%# CouponsTotal.LSCurrencyFormat("lc")%>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Discounts">
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("Discounts")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                            <FooterTemplate>
                                <%# DiscountsTotal.LSCurrencyFormat("lc")%>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Amount" SortExpression="Amount">
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("Amount")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                            <FooterTemplate>
                                <%# TotalAmount.LSCurrencyFormat("lc") %>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Groups">
                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                            <ItemTemplate>
                                <asp:Label ID="GroupLabel" runat="server" Text='<%#Eval("GroupNames") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no results to display for the selected dates."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
                 <asp:ObjectDataSource ID="ProductBreakdownDS" runat="server" SelectMethod="GetProductBreakdownSummary" TypeName="CommerceBuilder.Reporting.ReportDataSource" 
                    SortParameterName="sortExpression" OnSelected="ProductBreakdownDS_Selected">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="StartDate" Name="fromDate" PropertyName="SelectedStartDate" Type="DateTime" />
                        <asp:ControlParameter ControlID="EndDate" Name="toDate" PropertyName="SelectedEndDate" Type="DateTime" />
                        <asp:ControlParameter ControlID="VendorList" DefaultValue="0" Name="vendorId" PropertyName="SelectedValue" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>