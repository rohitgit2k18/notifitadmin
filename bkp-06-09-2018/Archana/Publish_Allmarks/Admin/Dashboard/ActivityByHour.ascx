<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Dashboard.ActivityByHour" CodeFile="ActivityByHour.ascx.cs" EnableViewState="false" %>
<div class="section">
    <div class="header">
        <h2>Page Views Over Time</h2>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="ActivityByHourAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Timer ID="ActivityByHourTimer" runat="server" ontick="ActivityByHourTimer_Tick" Interval="1" Enabled="true"></asp:Timer>
                <asp:Image ID="ProgressImage" runat="server" SkinID="Progress" />
                <asp:Panel ID="ActivityByHourPanel" runat="server" Visible="false">
                    <ajaxToolkit:TabContainer ID="Tabs" runat="server" OnDemand="false">
                        <ajaxToolkit:TabPanel ID="TabPanel1" runat="server" HeaderText="Last 24 Hours">
                            <ContentTemplate>
                                <asp:Chart ID="Last24HoursChart" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/last24hoursactivity">
                                    <Series>
                                        <asp:Series Name="Views"  ChartArea="MainChartArea" 
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
                        <ajaxToolkit:TabPanel ID="TabPanel2" runat="server" HeaderText="By Hour">
                            <ContentTemplate>
                                <asp:Chart ID="ViewsByHourChart" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/viewsbyhourchart">
                                    <Series>
                                        <asp:Series Name="Views"  ChartArea="MainChartArea" 
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
                        <ajaxToolkit:TabPanel ID="TabPanel3" runat="server" HeaderText="By Day">
                            <ContentTemplate>
                                <asp:Chart ID="ViewsByDayChart" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/viewsbydaychart">
                                    <Series>
                                        <asp:Series Name="Views"  ChartArea="MainChartArea" 
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
                        <ajaxToolkit:TabPanel ID="TabPanel4" runat="server" HeaderText="By Month">
                            <ContentTemplate>
                                <asp:Chart ID="ViewsByMonthChart" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/viewsbymonthchart">
                                    <Series>
                                        <asp:Series Name="Views"  ChartArea="MainChartArea" 
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