<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.NewExistingCustomersReport" Title="New vs Existing Customers" CodeFile="NewExistingCustomers.aspx.cs" %>
<%@ Register TagPrefix="uc1" TagName="NavagationLinks" Src="~/Admin/ConLib/NavagationLinks.ascx" %>
<%@ Register TagPrefix="uc1" TagName="PickerAndCalendar_1" Src="~/Admin/UserControls/PickerAndCalendar.ascx" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="New & Existing Customers"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/customers" />
        </div>
    </div>
    <div class="searchPanel">
        <div class="reportNav">
            <asp:Label ID="StartDateLabel" runat="server" Text="Show sales from:" SkinID="FieldHeader"></asp:Label>
            <uc1:PickerAndCalendar_1 ID="StartDate" runat="server" />
            <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
            <uc1:PickerAndCalendar_1 ID="EndDate" runat="server" />
            <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
            <br/>
            Recommend no more than 45 days worth of data for a readable graph.  Report only includes completed orders.
        </div>
    </div>
    <div class="content">
        <center>
        <asp:chart id="Chart1" runat="server" Height="600px" Width="1000px" ImageLocation="~/webcharts/newversusexistingcustomers" ImageStorageMode="UseImageLocation">
            <chartareas>
            <asp:ChartArea Name="ChartArea1" BorderWidth="0" />
            </chartareas>
        </asp:chart>                            
            </center>

        <div id="rawDataGrid"><asp:GridView runat="server" ID="grd_RawData" SkinID="PagedList" OnRowDataBound="grd_RawData_RowDataBound"/></div>
    </div>
 
</asp:Content>