<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.UserControls.HeaderNavigation" EnableViewState="false" CodeFile="HeaderNavigation.ascx.cs" %>
<asp:Panel ID="AdminNavigationHeaderPanel" runat="server" >
	<asp:HyperLink ID="DashboardLink" runat="server" NavigateUrl="~/Admin/Default.aspx" CssClass="dashboard" Text="Dashboard"></asp:HyperLink>
	<asp:HyperLink ID="OrdersLink" runat="server" NavigateUrl="~/Admin/Orders/Default.aspx" CssClass="orders" text="Orders"></asp:HyperLink>
	<asp:HyperLink ID="CatalogLink" runat="server" NavigateUrl="~/Admin/Catalog/Browse.aspx" CssClass="catalog" Text="Catalog"></asp:HyperLink>
	<asp:HyperLink ID="StoreLink" runat="server" NavigateUrl="~/Default.aspx" CssClass="stores" Text="Store"></asp:HyperLink>
	<asp:HyperLink ID="LogoutLink" runat="server" NavigateUrl="~/Logout.aspx" CssClass="logout" Text="Logout"></asp:HyperLink>
</asp:Panel>
