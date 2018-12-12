<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.PageViewOverTime" Title="Page View Over Time"  CodeFile="PageViewOverTime.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                     <h1>
                        <asp:Localize ID="Caption" runat="server" Text="Page Views Over Time"></asp:Localize>
                     </h1>
                     <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/customers" />
                </div>
            </div>
            <div class="content">
                <asp:UpdatePanel ID="ActivityByHourAjax" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Panel ID="ActivityByHourPanel" runat="server" Visible="false">
                            <ajaxToolkit:TabContainer ID="Tabs" runat="server" OnDemand="false">
                                <ajaxToolkit:TabPanel ID="TabPanel1" runat="server" HeaderText="Last 24 Hours">
                                    <ContentTemplate>
                                        <asp:Chart ID="Last24HoursChart" runat="server" SkinID="Report" Width="950" Height="400" ImageLocation="~/webcharts/last24hoursactivity">
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
                                        <asp:Chart ID="ViewsByHourChart" runat="server" SkinID="Report" Width="950" Height="400" ImageLocation="~/webcharts/viewsbyhourchart">
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
                                        <asp:Chart ID="ViewsByDayChart" runat="server" SkinID="Report" Width="950" Height="400" ImageLocation="~/webcharts/viewsbydaychart">
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
                                        <asp:Chart ID="ViewsByMonthChart" runat="server" SkinID="Report" Width="950" Height="400" ImageLocation="~/webcharts/viewsbymonthchart">
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
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>