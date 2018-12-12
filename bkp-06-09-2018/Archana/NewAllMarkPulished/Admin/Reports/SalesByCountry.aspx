<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.SalesByCountryReport" Title="Sales By Country"  CodeFile="SalesByCountry.aspx.cs" AutoEventWireup="True" %>
<%@ Register TagPrefix="uc1" TagName="NavagationLinks" Src="~/Admin/ConLib/NavagationLinks.ascx" %>
<%@ Register TagPrefix="uc1" TagName="PickerAndCalendar_1" Src="~/Admin/UserControls/PickerAndCalendar.ascx" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Sales By Country"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/marketing" />
        </div>
    </div>
    <div class="searchPanel">
        <div class="reportNav">
            <asp:Label ID="StartDateLabel" runat="server" Text="Show sales from:" SkinID="FieldHeader"></asp:Label>
            <uc1:PickerAndCalendar_1 ID="StartDate" runat="server" />
            <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
            <uc1:PickerAndCalendar_1 ID="EndDate" runat="server" />
            <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
        </div>
    </div>
    <div class="content">
        <center>
        <asp:chart id="Chart1" runat="server" Height="600px" Width="700px" ImageLocation="~/webcharts/salesbycountry" ImageStorageMode="UseImageLocation">
            <series>
                <asp:Series Name="Default" ChartArea="ChartArea1" 
                Color="#A0B340"
                BackGradientStyle="TopBottom"
                BackSecondaryColor="#69665F"
                Font="Arial, 8pt"
                BorderColor="#000000"
                ChartType="Pie"
                YValueType="Int32"
                XValueType="String"
                CustomProperties="MinimumRelativePieSize=60"
                IsValueShownAsLabel="True">
                </asp:Series>
            </series>
            <chartareas>
            <asp:ChartArea Name="ChartArea1" BorderWidth="0" />
            </chartareas>
        </asp:chart>                            
            </center>
        <cb:SortedGridView ID="grd_Sales" runat="server" AutoGenerateColumns="False" Width="900" SkinID="PagedList" FooterStyle-CssClass="totalRow">
            <Columns>
                <asp:TemplateField HeaderText="Country">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <FooterStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <asp:Label ID="CountryNameLabel" runat="server" Text='<%# Eval("Country.Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <Columns>
                <asp:TemplateField HeaderText="Total Sales">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <FooterStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <asp:Label ID="TotalSalesLabel" runat="server" Text='<%# ((decimal)Eval("TotalSales")).LSCurrencyFormat("lc") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>No orders found for the selected date range</EmptyDataTemplate>
        </cb:SortedGridView>
    </div>
</asp:Content>