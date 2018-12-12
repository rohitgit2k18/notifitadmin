<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Catalog.WebpageMenu" CodeFile="WebpageMenu.ascx.cs" %>
<asp:Panel ID="WebPageMenuPanel" runat="server">
    <asp:HyperLink ID="WebpageDetails" runat="server" NavigateUrl="~/Admin/Catalog/EditWebPage.aspx" Text="WebPage Details" CssClass="contextMenuButton"></asp:HyperLink>
    <asp:HyperLink ID="ManageCategories" runat="server" NavigateUrl="~/Admin/Catalog/EditWebpageCategories.aspx" Text="Categories" CssClass="contextMenuButton"></asp:HyperLink>
	<asp:LinkButton ID="DeleteWebpage" runat="server" Text="Delete Webpage" OnClick="DeleteWebpage_Click" CssClass="contextMenuButton" ></asp:LinkButton>
    <asp:HyperLink ID="Preview" runat="server" NavigateUrl="" Text="Preview!" CssClass="contextMenuButton" Target="_blank"></asp:HyperLink>
</asp:Panel>
