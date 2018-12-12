<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.PopularProducts" Title="Popular Products" CodeFile="PopularProducts.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Popular Products"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/products" />
        </div>
    </div>
    <div class="content">
        <asp:Panel ID="PopularProductsPanel" runat="server" Visible="false">
            <ajaxToolkit:TabContainer ID="Tabs" runat="server" OnDemand="false">
                <ajaxToolkit:TabPanel ID="BySalesPanel" runat="server" HeaderText="By Sales">
                    <ContentTemplate>
                        <asp:Chart ID="SalesChart1" runat="server" SkinID="Report" Width="950" Height="400" ImageLocation="~/webcharts/popularproductsbysales">
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
                        <br />
                        <asp:Button ID="ExportBySalesButton2" runat="server" Text="Export Results" OnClick="ExportBySalesButton_Click" />
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
                                <asp:TemplateField HeaderText="Groups">
                                    <ItemStyle HorizontalAlign="Center" Width="80px" />
                                    <ItemTemplate>
                                        <asp:Label ID="GroupLabel" runat="server" Text='<%#GetGroups(Container.DataItem) %>' />
                                    </ItemTemplate>
                               </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <br />
                        <asp:Button ID="ExportBySalesButton" runat="server" Text="Export Results" OnClick="ExportBySalesButton_Click" />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="ByViewsPanel" runat="server" HeaderText="By Views">
                    <ContentTemplate>
                        <asp:Chart ID="ViewsChart1" runat="server" SkinID="Report" Width="950" Height="400" ImageLocation="~/webcharts/popularproductsbyviews">
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
                        <br />
                        <asp:Button ID="ExportByViewsButton2" runat="server" Text="Export Results" OnClick="ExportByViewsButton_Click" />
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
                                <asp:TemplateField HeaderText="Groups">
                                    <ItemStyle HorizontalAlign="Center" Width="80px" />
                                    <ItemTemplate>
                                        <asp:Label ID="GroupLabel" runat="server" Text='<%#GetViewsGroups(Eval("Key"))%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <br />
                        <asp:Button ID="ExportByViewsButton" runat="server" Text="Export Results" OnClick="ExportByViewsButton_Click" />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
            </ajaxToolkit:TabContainer>
        </asp:Panel>
    </div>
</asp:Content>