<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.SalesByStateReport" Title="Sales By State" CodeFile="SalesByState.aspx.cs" %>
<%@ Register TagPrefix="uc1" TagName="NavagationLinks" Src="~/Admin/ConLib/NavagationLinks.ascx" %>
<%@ Register TagPrefix="uc1" TagName="PickerAndCalendar_1" Src="~/Admin/UserControls/PickerAndCalendar.ascx" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Sales By State"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/marketing" />
        </div>
    </div>
    <div class="searchPanel">
        <div class="reportNav">
            <asp:Label ID="StartDateLabel" runat="server" Text="Show sales from:" SkinID="FieldHeader"></asp:Label>
            <uc1:PickerAndCalendar_1 ID="StartDate" runat="server" />
            <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
            <uc1:PickerAndCalendar_1 ID="EndDate" runat="server"/><br/>
            <br/>
            <cb:ToolTipLabel runat="server" ID="Tip1" Text="Country: " SkinID="FieldHeader" ToolTip="Select the desired country or use the default of the primary warehouse country." AssociatedControlID="list_Country"/>&nbsp;&nbsp;
            <asp:DropDownList runat="server" ID="list_Country"/>
            <cb:ToolTipLabel runat="server" ID="Tip2" Text="Show: " SkinID="FieldHeader" ToolTip="Choose how many states/provinces to include in the report." AssociatedControlID="list_TopCount"/>&nbsp;&nbsp;
            <asp:DropDownList runat="server" ID="list_TopCount">
                <asp:ListItem Text="10"/>
                <asp:ListItem Text="15"/>
                <asp:ListItem Text="20"/>
                <asp:ListItem Text="25"/>
                <asp:ListItem Text="50"/>
            </asp:DropDownList><br/><br/>
            <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
        </div>
    </div>
    <div class="content">
        <center>
        <asp:chart id="Chart1" runat="server" Height="600px" Width="700px" ImageLocation="~/webcharts/salesbystate" ImageStorageMode="UseImageLocation">
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
        <asp:GridView ID="grd_Sales" runat="server" AutoGenerateColumns="False" Width="900" SkinID="PagedList" FooterStyle-CssClass="totalRow">
            <Columns>
                <asp:TemplateField HeaderText="State/Province">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <FooterStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <asp:Label ID="ProvinceNameLabel" runat="server" Text='<%# GetProvinceName(Container.DataItem) %>'></asp:Label>
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
        </asp:GridView>
    </div>
</asp:Content>