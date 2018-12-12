<%@ Page Title="Skinning Samples" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="AbleCommerce.Admin.Skinning.Default" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
	    <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Skinning Samples"></asp:Localize></h1>
        </div>
    </div>
    <div class="section">
        <div class="content">
            <p><asp:Localize ID="IntroText" runat="server" Text="These pages demonstrate various elements that will be common to admin pages."></asp:Localize> </p>
            <ul>
                <li><asp:HyperLink ID="EmptyPageLink" runat="server" Text="Empty Page" NavigateUrl="Empty.aspx"></asp:HyperLink></li>
                <li><asp:HyperLink ID="ButtonsLink" runat="server" Text="Button Page" NavigateUrl="Buttons.aspx"></asp:HyperLink></li>
                <li><asp:HyperLink ID="SummaryGridLink" runat="server" Text="Summary Grid" NavigateUrl="OneColumnSummaryGrid.aspx"></asp:HyperLink></li>
                <li><asp:HyperLink ID="RightColumnGridLink" runat="server" Text="Right Column Grid" NavigateUrl="RightColumnSummaryGrid.aspx"></asp:HyperLink></li>
                <li><asp:HyperLink ID="SettingsPageLink" runat="server" Text="Settings Page" NavigateUrl="TwoColumnSettingsPage.aspx"></asp:HyperLink></li>
            </ul>
        </div>
    </div>
</asp:Content>
