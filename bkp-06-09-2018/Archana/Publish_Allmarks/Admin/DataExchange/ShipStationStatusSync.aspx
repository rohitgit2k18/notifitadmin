<%@ Page Title="ShipStation Status Updates" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" CodeFile="ShipStationStatusSync.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.ShipStationStatusSync" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="ShipStation Export"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="data/shipstation" />
        </div>
    </div>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <div class="section">
        <asp:PlaceHolder ID="ProgressPanel" runat="server" Visible="false">
            <p>Status Sync is in progress, please be patient while the process completes.</p>
            <p><asp:Image ID="ProgressImage" runat="server" SkinID="Progress" /></p>
            <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
            <br />
        </asp:PlaceHolder>
        <asp:Button ID="SyncButton" runat="server" Text="Sync Statuses" OnClick="SyncButton_Click" /><br /><br />
        <cb:AbleGridView ID="OrderGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="True" PageSize="10"
            AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="OrderDs" DefaultSortExpression="O.OrderDate" DefaultSortDirection="Descending"
            ShowWhenEmpty="False" TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching orders">
            <Columns>
                <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status" SortExpression="OrderStatusId">
                    <ItemStyle HorizontalAlign="Left" Height="30px" />
                    <ItemTemplate>
                        <asp:Label ID="OrderStatus" runat="server" Text='<%# GetOrderStatus(Eval("OrderStatusId")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("OrderDate", "{0:G}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Payment">
                    <ItemStyle HorizontalAlign="Left" />
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phPaymentStatus" runat="server"></asp:PlaceHolder>
                        <asp:Label ID="PaymentStatus" runat="server" Text='<%# GetPaymentStatus(Container.DataItem) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Shipment">
                    <ItemStyle HorizontalAlign="Left" />
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phShipmentStatus" runat="server"></asp:PlaceHolder>
                        <asp:Label ID="ShipmentStatus" runat="server" Text='<%# Eval("ShipmentStatus") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyMessage" runat="server" Text="No orders match criteria."></asp:Label>
            </EmptyDataTemplate>
        </cb:AbleGridView>
        <asp:ObjectDataSource ID="OrderDs" runat="server" OldValuesParameterFormatString="original_{0}"
            SelectMethod="LoadWaitingOrders" SelectCountMethod="CountWaitingOrders" SortParameterName="sortExpression" TypeName="CommerceBuilder.DataExchange.ShipStationExportManager" EnablePaging="true">
        </asp:ObjectDataSource>
    </div>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>
