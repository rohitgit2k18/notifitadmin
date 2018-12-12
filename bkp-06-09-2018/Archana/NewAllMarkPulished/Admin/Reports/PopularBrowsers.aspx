<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.PopularBrowsers" Title="Browser Popularity Report" CodeFile="PopularBrowsers.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Popular Browsers"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/customers" />
        </div>
    </div>
    <div class="content">
        <asp:Chart ID="BrowserChart" runat="server" ImageLocation="~/webcharts/popularbrowsers" SkinID="Report" Width="600" Height="300">
            <Series>
                <asp:Series Name="Browsers"  ChartArea="MainChartArea" 
                Color="#C5B28B"
                Font="Arial, 7pt"
                BorderColor="#0162BE"
                ChartType="Pie">
                </asp:Series>
            </Series>
            <legends>
				<asp:Legend TitleFont="Arial, 7pt" BackColor="#F5F1E1" Font="Arial, 7pt" Enabled="True" Name="Default"></asp:Legend>
			</legends>
            <ChartAreas>              
                <asp:ChartArea Name="MainChartArea" BackSecondaryColor="Transparent" BackColor="Transparent" ShadowColor="Transparent">
                    <axisy TitleFont="Arial, 7pt" Minimum="0">
                        <LabelStyle ForeColor="#A0B340" />
                        <MajorGrid LineColor="#dddddd" />
                    </axisy>
                    <axisx TitleFont="Arial, 6pt" Interval="1">
                        <LabelStyle ForeColor="#69665F" />
                        <MajorGrid LineColor="#dddddd" />
                    </axisx>
                </asp:ChartArea>
            </ChartAreas>
        </asp:Chart>
        <cb:SortedGridView ID="PopularBrowsersGrid" runat="server" AutoGenerateColumns="False"
            PageSize="40" AllowSorting="True" AllowPaging="True" DataSourceID="BrowserViewsDs"
            DefaultSortExpression="ViewCount" DefaultSortDirection="Descending" SkinID="PagedList"
            Width="600">
            <Columns>       
                <asp:TemplateField HeaderText="Browser" SortExpression="Browser">
                    <HeaderStyle HorizontalAlign="Left" Wrap="false" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:Label ID="BrowserName" runat="server" Text='<%#Eval("Key")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Views" SortExpression="ViewCount">
                    <HeaderStyle Wrap="false" Width="100px" HorizontalAlign="Center" />
                    <ItemStyle Width="100px" HorizontalAlign="Center" />
                    <ItemTemplate>                    
                        <asp:Label ID="CountLabel" runat="server" Text='<%#Eval("Value")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </cb:SortedGridView>
    </div>
    <asp:ObjectDataSource ID="BrowserViewsDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}"
        SelectCountMethod="GetViewsByBrowserCount" SelectMethod="GetViewsByBrowser"
        SortParameterName="sortExpression" TypeName="CommerceBuilder.Reporting.PageViewDataSource">
    </asp:ObjectDataSource>
</asp:Content>