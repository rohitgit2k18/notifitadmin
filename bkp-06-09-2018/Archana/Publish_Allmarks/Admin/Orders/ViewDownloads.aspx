<%@ Page Language="C#" MasterPageFile="Order.master" Inherits="AbleCommerce.Admin.Orders.ViewDownloads" Title="View Downloads"  EnableViewState="false" CodeFile="ViewDownloads.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Order #{0} - Digital Goods" EnableViewState="false"></asp:Localize></h1>
            <div class="links">
                <asp:HyperLink ID="DigitalGoodsLink" runat="server" Text="Finish" SkinID="Button" NavigateUrl="ViewDigitalGoods.aspx"></asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="The table below shows all downloads for this digital good.  If applicable, only relevant downloads will count toward the maximum allowed."></asp:Localize></p>
        <asp:GridView ID="DownloadsGrid" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="DownloadId" Width="100%" SkinID="PagedList">
            <Columns>
                <asp:BoundField DataField="DownloadDate" HeaderText="Date" ItemStyle-Wrap="false" SortExpression="DownloadDate" />
                <asp:BoundField DataField="RemoteAddr" HeaderText="IP" SortExpression="RemoteAddr" />
                <asp:BoundField DataField="UserAgent" HeaderText="Browser" SortExpression="UserAgent" />
                <asp:BoundField DataField="Referrer" HeaderText="Referrer" SortExpression="Referrer" />
                <asp:TemplateField HeaderText="Relevant">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:CheckBox ID="Relevant" runat="server" Enabled=false Checked='<%#(OrderItemDigitalGood.DownloadDate > DateTime.MinValue && (DateTime)Eval("DownloadDate") >= OrderItemDigitalGood.DownloadDate)%>' />
                    </ItemTemplate>
                </asp:TemplateField>          
            </Columns>
            <EmptyDataTemplate>
                <asp:Localize ID="EmptyMessage" runat="server" Text="There are no downloads for the specified digital good."></asp:Localize>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>