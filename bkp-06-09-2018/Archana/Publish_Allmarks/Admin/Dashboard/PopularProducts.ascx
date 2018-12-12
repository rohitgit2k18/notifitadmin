<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Dashboard.PopularProducts" CodeFile="PopularProducts.ascx.cs" EnableViewState="false" %>
<div class="section">
    <div class="header">
        <h2>Popular Products</h2>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="PopularProductsAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Timer ID="PopularProductsTimer" runat="server" ontick="PopularProductsTimer_Tick" Interval="1" Enabled="true"></asp:Timer>
                <asp:Image ID="ProgressImage" runat="server" SkinID="Progress" />
                <asp:Panel ID="PopularProductsPanel" runat="server" Visible="false">
                    <ajaxToolkit:TabContainer ID="Tabs" runat="server" OnDemand="false">
                        <ajaxToolkit:TabPanel ID="BySalesPanel" runat="server" HeaderText="By Sales">
                            <ContentTemplate>
                                <asp:Chart ID="SalesChart1" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/popularproductsbysales">
                                    <Series>
                                        <asp:Series Name="Sales"  ChartArea="MainChartArea" 
                                        Color="#A0B340"
                                        BackGradientStyle="TopBottom"
                                        BackSecondaryColor="#69665F"
                                        Font="Arial, 7pt"
                                        BorderColor="#000000"
                                        ChartType="Bar"
                                        YValueType="Int32"
                                        XValueType="String"
                                        IsValueShownAsLabel="True">
                                        </asp:Series>
                                    </Series>
                                </asp:Chart>                    
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="BySalesDataPanel" runat="server" HeaderText="Sales Data">
                            <ContentTemplate>
                                <asp:GridView ID="SalesGrid" runat="server" SkinID="PagedList" AutoGenerateColumns="false" Width="100%">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Product">
                                            <HeaderStyle HorizontalAlign="left" />
                                            <ItemStyle HorizontalAlign="left" />
                                            <ItemTemplate>
                                                <asp:HyperLink ID="ProductLink" runat="server" NavigateUrl='<%# Eval("ProductId", "~/Admin/Products/EditProduct.aspx?ProductId={0}") %>' Text='<%# Eval("Name") %>'></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sales">
                                            <ItemStyle HorizontalAlign="Right" />
                                            <ItemTemplate>
                                                <asp:Label ID="TotalPrice" runat="server" Text='<%# ((decimal)Eval("TotalPrice")).LSCurrencyFormat("lc") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="TotalQuantity" HeaderText="Quantity" ItemStyle-HorizontalAlign="Center" />
                                    </Columns>
                                </asp:GridView>
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="ByViewsPanel" runat="server" HeaderText="By Views">
                            <ContentTemplate>
                                <asp:Chart ID="ViewsChart1" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/popularproductsbyviews">
                                    <Series>
                                        <asp:Series Name="Views"  ChartArea="MainChartArea" 
                                        Color="#A0B340"
                                        BackGradientStyle="TopBottom"
                                        BackSecondaryColor="#69665F"
                                        Font="Arial, 7pt"
                                        BorderColor="#000000"
                                        ChartType="Bar"
                                        YValueType="Int32"
                                        XValueType="String"
                                        IsValueShownAsLabel="True">
                                        </asp:Series>
                                    </Series>                        
                                </asp:Chart>
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="ByViewsDataPanel" runat="server" HeaderText="Views Data">
                            <ContentTemplate>
                                <asp:GridView ID="ViewsGrid" runat="server" SkinID="PagedList" AutoGenerateColumns="false" Width="100%">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Product">
                                            <HeaderStyle HorizontalAlign="left" />
                                            <ItemStyle HorizontalAlign="left" />
                                            <ItemTemplate>
                                                <asp:HyperLink ID="ProductLink" NavigateUrl='<%#((ICatalogable)Eval("Key")).NavigateUrl%>' runat="server"><%#((ICatalogable)Eval("Key")).Name%></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Value" HeaderText="Views" ItemStyle-HorizontalAlign="Center" />
                                    </Columns>
                                </asp:GridView>
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                    </ajaxToolkit:TabContainer>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>