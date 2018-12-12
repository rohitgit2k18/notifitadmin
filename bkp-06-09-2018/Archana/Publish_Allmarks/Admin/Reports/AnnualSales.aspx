<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.AnnualSales" Title="Annual Sales Report" CodeFile="AnnualSales.aspx.cs" %>
<%@ Register TagPrefix="uc1" TagName="NavagationLinks" Src="~/Admin/ConLib/NavagationLinks.ascx" %>
<%@ Register TagPrefix="uc1" TagName="PickerAndCalendar_1" Src="~/Admin/UserControls/PickerAndCalendar.ascx" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Annual Sales"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/sales" />
        </div>
    </div>
    <div class="searchPanel">
        <div class="reportNav">
            <asp:Label ID="StartDateLabel" runat="server" Text="Show sales from:" SkinID="FieldHeader"></asp:Label>
            <asp:DropDownList runat="server" ID="list_StartYear">
            </asp:DropDownList>
            <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
            <asp:DropDownList runat="server" ID="list_EndYear">
            </asp:DropDownList>
            <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
            <br/>
        </div>
    </div>
    <div class="content">
        <center>
        <asp:chart id="Chart1" runat="server" Height="600px" Width="960px" ImageLocation="~/webcharts/annualsalesreport" 
            ImageStorageMode="UseImageLocation" OnCustomize="Chart1_Customize" SkinID="Report" >            
        </asp:chart>                            
            </center>

        <div id="rawDataGrid"><asp:GridView runat="server" ID="grd_RawData" SkinID="PagedList" OnRowCreated="grd_RawData_RowDataBound">
        <EmptyDataTemplate>No orders found for the selected date range</EmptyDataTemplate>
        </asp:GridView></div>
    </div>
</asp:Content>