<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Dashboard.SalesOverTime" CodeFile="SalesOverTime.ascx.cs" EnableViewState="false" %>
<div class="section">
    <div class="header">
        <h2>Sales over Time</h2>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="SalesOverTimeAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Timer ID="SalesOverTimeTimer" runat="server" ontick="SalesOverTimeTimer_Tick" Interval="1" Enabled="true"></asp:Timer>
                <asp:Image ID="ProgressImage" runat="server" SkinID="Progress" />
                <asp:Panel ID="SalesOverTimePanel" runat="server" Visible="false">
                    <ajaxToolkit:TabContainer ID="Tabs" runat="server" OnDemand="false">
                        <ajaxToolkit:TabPanel ID="Past7DaysPanel" runat="server" HeaderText="Past 7 Days">
                            <ContentTemplate>
                                <asp:Chart ID="SalesByDayChart" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/salesbydaychart">
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
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="CurrentMonthPanel" runat="server" HeaderText="Current Month">
                            <ContentTemplate>
                                <asp:Chart ID="CurrentMonthChart" runat="server" SkinID="Report" Width="455px" Height="300"
                                    ImageLocation="~/webcharts/dashboardcurrentmonthchart">
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
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        <ajaxToolkit:TabPanel ID="Past6MonthsPanel" runat="server" HeaderText="Past 6 Months">
                            <ContentTemplate>
                                <asp:Chart ID="SalesByMonthChart" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/salesbymonthchart">
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
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                    </ajaxToolkit:TabContainer>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>