<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Dashboard.PopularCategories" EnableViewState="false" CodeFile="PopularCategories.ascx.cs" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<div id="tabs" runat="server">
	<ul>
		<li id="tab1" runat="server">by Views</li>
		<li id="tab2" runat="server">data</li>
	</ul>
	<div id="tabpage1" runat="server">
        <asp:Chart ID="ViewsChart" runat="server" SkinID="Report" Width="455" Height="300" ImageLocation="~/webcharts/popularcategoriesbyviews">
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
        <div align="center" style="padding:4px;">
            <asp:Literal ID="CacheDate1" runat="server" Text="as of {0:t}" EnableViewState="false"></asp:Literal> 
            <asp:LinkButton ID="RefreshLink1" runat="server" Text="refresh" OnClick="RefreshLink_Click"></asp:LinkButton>
        </div>
    </div>
	<div id="tabpage2" runat="server">
        <asp:GridView ID="ViewsGrid" runat="server" SkinID="PagedList" AutoGenerateColumns="false" Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Category">
                    <HeaderStyle HorizontalAlign="left" />
                    <ItemStyle HorizontalAlign="left" />
                    <ItemTemplate>
                        <asp:HyperLink ID="CategoryLink" NavigateUrl='<%#((ICatalogable)Eval("Key")).NavigateUrl%>' runat="server"><%#((ICatalogable)Eval("Key")).Name%></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Value" HeaderText="Views" ItemStyle-HorizontalAlign="Center" />
            </Columns>
        </asp:GridView>
        <div align="center" style="padding:4px;">
            <asp:Literal ID="CacheDate2" runat="server" Text="as of {0:t}" EnableViewState="false"></asp:Literal> 
            <asp:LinkButton ID="RefreshLink2" runat="server" Text="refresh" OnClick="RefreshLink_Click"></asp:LinkButton>
        </div>
    </div>
</div>