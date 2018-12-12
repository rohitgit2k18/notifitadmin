<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.SalesOverTime" Title="Sales Over Time" CodeFile="SalesOverTime.aspx.cs" %>
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
                    <h1><asp:Localize ID="Caption" runat="server" Text="Sales Over Time Report"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/sales" />
                </div>
            </div>
            <div class="searchPanel">
                <div class="reportNav">
                    <asp:Label ID="StartDateLabel" runat="server" Text="Show sales from:" SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                    <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                    <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
                    <asp:Button ID="ExportButton" runat="server" Text="Export Results" OnClick="ExportButton_Click" />
                </div>
            </div>
            <div class="content">
                <asp:Chart ID="SalesChart" runat="server" SkinID="Report" RenderType="ImageTag" BackColor="#C7B48D" Width="900" Height="270" ImageLocation="~/webcharts/monthlysales" ImageStorageMode="UseImageLocation">
                    <Series>
                        <asp:Series Name="Sales"  ChartArea="MainChartArea" 
                        Color="#A0B340"
                        BackGradientStyle="TopBottom"
                        BackSecondaryColor="#69665F"
                        Font="Arial, 7pt"
                        BorderColor="#000000"
                        ChartType="Column"
                        YValueType="Int32"
                        XValueType="String" >
                        </asp:Series>
                    </Series>
                    <ChartAreas>              
                        <asp:ChartArea Name="MainChartArea" BackColor="#F5F1E1">
                        <axisy TitleFont="Arial, 7pt" Minimum="0">
                            <LabelStyle ForeColor="#000000" />
                            <MajorGrid LineColor="#dddddd" />
                        </axisy>
                        <axisx TitleFont="Arial, 6pt" Interval="1">
                            <LabelStyle ForeColor="#000000" />
                            <MajorGrid LineColor="#dddddd" />
                        </axisx>
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
                <asp:GridView ID="MonthlySalesGrid" runat="server" AutoGenerateColumns="False" Width="900" ShowFooter="True" 
                    SkinID="PagedList" FooterStyle-CssClass="totalRow">
                    <Columns>
                        <asp:TemplateField HeaderText="Date" SortExpression="StartDate">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="DateLabel" runat="server" Text='<%# Eval("StartDate", "{0:d}") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="FooterTotalsLabel" runat="server" Text="Totals:" SkinID="FieldHeader"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Orders">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <FooterStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("OrderCount") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="OrderCountTotal" runat="server" Text='<%# GetTotal("Count") %>'></asp:Label>
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
                                <asp:Label ID="CostLabel" runat="server" Text='<%# ((decimal)Eval("CostOfGoodTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="CostOfGoodsTotal" runat="server" Text='<%# GetTotal("Cost") %>'></asp:Label>
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
                        <asp:TemplateField HeaderText="Gift Wrap">
                            <HeaderStyle HorizontalAlign="Right" />
                            <ItemStyle HorizontalAlign="Right" />
                            <FooterStyle HorizontalAlign="Right" />
                            <ItemTemplate>
                                <asp:Label ID="GiftWrapLabel" runat="server" Text='<%# ((decimal)Eval("GiftWrapTotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="GiftWrapTotal" runat="server" Text='<%# GetTotal("GiftWrap") %>'></asp:Label>
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
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" CssClass="noPrint" />
                            <ItemTemplate>
                                <asp:HyperLink ID="DetailsLink" runat="server" Text="Details" SkinID="Button" NavigateUrl='<%#Eval("StartDate", "DailySales.aspx?Date={0:yyyy-MMM-dd}")%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No orders to display.
                    </EmptyDataTemplate>              
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>