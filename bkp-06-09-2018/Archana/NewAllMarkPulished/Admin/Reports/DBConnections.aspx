<%@ Page Title="Database Connections Status" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Reports.DBConnections" CodeFile="DBConnections.aspx.cs" %>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" Runat="Server">
    
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Database Connections Status"></asp:Localize></h1>
        </div>
    </div>
    <div class="searchPanel">
        <div class="reportNav">
            <asp:CheckBox runat="server" ID="ActiveOnly" Text="Check Only Active Connections"/>&nbsp;<asp:Button ID="CheckConnections" runat="server" Text="Check Connections" OnClick="CheckConnections_OnClick" />
        </div>
    </div>    
    <div class="content">
        <table class="inputForm">
            <tr>
                <th width="200px">Total Connections: </th>
                <td>
                    <asp:Label ID="ConnectionsCount" runat="server" />
                </td>
                <th width="200px">Change from Last Time:</th>
                <td>
                    <asp:Label ID="Changed" runat="server" />
                </td>
            </tr>
        </table>
        <cb:SortedGridView runat="server" ID="ConnectionsGrid" SkinID="PagedList" Width="100%" 
            AllowSorting="true" OnSorting="ConnectionsGrid_OnSorting" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="Spid" HeaderText="SPID" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="SPID2" HeaderText="SPID2" ItemStyle-HorizontalAlign="Center"/>
                <asp:BoundField DataField="DbName" HeaderText="DB Name" />                
                <asp:BoundField DataField="Login" HeaderText="Login" />
                <asp:BoundField DataField="HostName" HeaderText="Host Name" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="BlkBy" HeaderText="BlkBy" />
                <asp:BoundField DataField="Command" HeaderText="Command" />
                <asp:BoundField DataField="CPUTime" HeaderText="CPU Time" ItemStyle-HorizontalAlign="Center"/>
                <asp:BoundField DataField="DiskIO" HeaderText="DiskIO" ItemStyle-HorizontalAlign="Center"/>
                <asp:BoundField DataField="LastBatch" HeaderText="Last Batch" />
                <asp:BoundField DataField="ProgramName" HeaderText="Program Name" />    
                <asp:BoundField DataField="Request" HeaderText="Request" ItemStyle-HorizontalAlign="Center"/>
            </Columns>
        </cb:SortedGridView>
    </div>
</asp:Content>

