<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Dashboard.AdminAlerts" EnableViewState="false" CodeFile="AdminAlerts.ascx.cs" %>
<div class="section">
    <div class="header">
        <h2>Action Items</h2>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="AlertAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Repeater ID="AlertList" runat="server">
                    <HeaderTemplate>
                        <ul>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li><%#Container.DataItem%></li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Localize ID="CachedAtLabel" runat="server" Text="As of "></asp:Localize>
                <asp:Literal ID="CachedAt" runat="server"></asp:Literal>
                <asp:LinkButton ID="RefreshButton" runat="server" Text="refresh" OnClick="RefreshButton_Click"></asp:LinkButton>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>