<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.DailySales" Title="Daily Sales"  CodeFile="DailySales.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:PostBackTrigger ControlID="ExportButton" />
        </Triggers>
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Daily Sales Report"></asp:Localize><asp:Localize ID="ReportCaption" runat="server" Text=" for {0:d}" Visible="false" EnableViewState="false"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/sales" />
                </div>
            </div>
            <div class="searchPanel">
                <div class="reportNav">
                    <asp:Label ID="ReportLabel" runat="server" Text="Show sales for: " SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="ReportDate" runat="server" />    
                    <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
                    <asp:Button ID="ExportButton" runat="server" Text="Export Results" OnClick="ExportButton_Click" />
                </div>
            </div>
            <div class="content">
                <asp:GridView ID="DailySalesGrid" runat="server" AutoGenerateColumns="False" ShowFooter="True" 
                    SkinID="PagedList" Width="100%" FooterStyle-CssClass="totalRow">
                    <Columns>
                        <asp:TemplateField HeaderText="Order">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:HyperLink ID="OrderNumberLink" runat="server" Text='<%# Eval("OrderNumber") %>' NavigateUrl='<%#String.Format("../Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="FooterTotalsLabel" runat="server" Text="Totals:" SkinID="FieldHeader"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Products">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# ((decimal)Eval("ProductTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="ProductTotal" runat="server" Text='<%# GetTotal("Product") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cost">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="CostTotalPerOrder" runat="server" Text='<%# ((decimal)Eval("CostOfGoodTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="CostTotal" runat="server" Text='<%# GetTotal("Cost") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Shipping">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="Label3" runat="server" Text='<%# ((decimal)Eval("ShippingTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="ShippingTotal" runat="server" Text='<%# GetTotal("Shipping") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tax">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="Label4" runat="server" Text='<%# ((decimal)Eval("TaxTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="TaxTotal" runat="server" Text='<%# GetTotal("Tax") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Discount">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="Label5" runat="server" Text='<%# ((decimal)Eval("DiscountTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="DiscountTotal" runat="server" Text='<%# GetTotal("Discount") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Coupon">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="Label6" runat="server" Text='<%# ((decimal)Eval("CouponTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="CouponTotal" runat="server" Text='<%# GetTotal("Coupon") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Other">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="Label7" runat="server" Text='<%# ((decimal)Eval("OtherTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="OtherTotal" runat="server" Text='<%# GetTotal("Other") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Profit">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="ProfitLabel" runat="server" Text='<%# ((decimal)Eval("ProfitTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="ProfitTotal" runat="server" Text='<%# GetTotal("Profit") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="Label8" runat="server" Text='<%# ((decimal)Eval("GrandTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="GrandTotal" runat="server" Text='<%# GetTotal("Grand") %>'></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no orders for the selected date."></asp:Label>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>