<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.MonthlySales" Title="Monthly Sales" CodeFile="MonthlySales.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<%@ Register src="../ConLib/MonthlySalesTotals.ascx" tagname="MonthlySalesTotals" tagprefix="uc2" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Monthly Sales Report"></asp:Localize><asp:Localize ID="ReportCaption" runat="server" Text=" for {0:MMMM yyyy}" Visible="false" EnableViewState="false"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/sales" />
                </div>
            </div>
            <div class="content">
                <asp:Panel ID="SalesOverTimePanel" runat="server" Visible="false">
                    <ajaxToolkit:TabContainer ID="Tabs" runat="server" OnDemand="false">
                        <ajaxToolkit:TabPanel ID="CurrentMonthPanel" runat="server" HeaderText="Current Month">
                            <ContentTemplate>
                                <asp:Chart ID="CurrentMonthChart" runat="server" SkinID="Report" Width="950px" 
                                    ImageLocation="~/webcharts/currentmonthchart">
                                    <Series>
                                        <asp:Series Name="Sales"  ChartArea="MainChartArea" 
                                        Color="160, 179, 64"
                                        BackGradientStyle="TopBottom"
                                        BackSecondaryColor="105, 102, 95"
                                        Font="Arial, 7pt"
                                        BorderColor="Black" IsValueShownAsLabel="True"                            
                                        YValueType="Int32"
                                        XValueType="String">
                                        </asp:Series>
                                    </Series>                        
                                </asp:Chart>
                                <uc2:MonthlySalesTotals ID="CurrentMonthSales" runat="server"/>
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="LastMonthPanel" runat="server" HeaderText="Last Month">
                            <ContentTemplate>
                                <asp:Chart ID="LastMonthChart" runat="server" SkinID="Report" Width="950" Height="300" ImageLocation="~/webcharts/lastmonthchart">
                                    <Series>
                                        <asp:Series Name="Sales"  ChartArea="MainChartArea" 
                                        Color="#A0B340"
                                        BackGradientStyle="TopBottom"
                                        BackSecondaryColor="#69665F"
                                        Font="Arial, 7pt"
                                        BorderColor="#000000"
                                        ChartType="Column" IsValueShownAsLabel="True"                            
                                        YValueType="Int32"
                                        XValueType="String">
                                        </asp:Series>
                                    </Series>                        
                                </asp:Chart>
                                <uc2:MonthlySalesTotals ID="LastMonthSales" runat="server"/>
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="PastThreeMonthsPanel" runat="server" HeaderText="Past 3 Months">
                            <ContentTemplate>
                                <asp:Chart ID="PastThreeMonthChart" runat="server" SkinID="Report" Width="950" Height="300" ImageLocation="~/webcharts/pastthreemonthchart">
                                    <Series>
                                        <asp:Series Name="Sales"  ChartArea="MainChartArea" 
                                        Color="#A0B340"
                                        BackGradientStyle="TopBottom"
                                        BackSecondaryColor="#69665F"
                                        Font="Arial, 7pt"
                                        BorderColor="#000000"
                                        ChartType="Column"
                                        YValueType="Int32"
                                        XValueType="String"
                                        IsValueShownAsLabel="True">
                                        </asp:Series>
                                    </Series>
                                </asp:Chart>
                                <uc2:MonthlySalesTotals ID="PastThreeMonthSales" runat="server"/>
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="Past6MonthsPanel" runat="server" HeaderText="Past 6 Months">
                            <ContentTemplate>
                                <asp:Chart ID="PastSixMonthChart" runat="server" SkinID="Report" Width="950" Height="300" ImageLocation="~/webcharts/pastsixmonthchart">
                                    <Series>
                                        <asp:Series Name="Sales"  ChartArea="MainChartArea" 
                                        Color="#A0B340"
                                        BackGradientStyle="TopBottom"
                                        BackSecondaryColor="#69665F"
                                        Font="Arial, 7pt"
                                        BorderColor="#000000"
                                        ChartType="Column"
                                        YValueType="Int32"
                                        XValueType="String"
                                        IsValueShownAsLabel="True">
                                        </asp:Series>
                                    </Series>
                                </asp:Chart>
                                <uc2:MonthlySalesTotals ID="PastSixMonthSales" runat="server"/>
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="Past12MonthsPanel" runat="server" HeaderText="Past Year">
                            <ContentTemplate>
                                <asp:Chart ID="PastTwelveMonthChart" runat="server" SkinID="Report" Width="950" Height="300" ImageLocation="~/webcharts/pasttwelvemonthchart">
                                    <Series>
                                        <asp:Series Name="Sales"  ChartArea="MainChartArea" 
                                        Color="#A0B340"
                                        BackGradientStyle="TopBottom"
                                        BackSecondaryColor="#69665F"
                                        Font="Arial, 7pt"
                                        BorderColor="#000000"
                                        ChartType="Column"
                                        YValueType="Int32"
                                        XValueType="String"
                                        IsValueShownAsLabel="True">
                                        </asp:Series>
                                    </Series>
                                </asp:Chart>
                                <uc2:MonthlySalesTotals ID="Past12MonthSales" runat="server"/>
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                    </ajaxToolkit:TabContainer>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>