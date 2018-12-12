<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdminFooter.ascx.cs" Inherits="AbleCommerce.Admin.ConLib.AdminFooter" EnableViewState="false" %>
<div class="grid_12" id="adminFooter">
    <div class="innerFrame">
     <div>
        <asp:HyperLink ID="DashboardLink" runat="server" NavigateUrl="~/Admin/Default.aspx" Text="Dashboard"></asp:HyperLink>|
        <asp:HyperLink ID="OrdersLink" runat="server" NavigateUrl="~/Admin/Orders/Default.aspx" Text="Orders"></asp:HyperLink>|
        <asp:HyperLink ID="UsersLink" runat="server" NavigateUrl="~/Admin/People/Users/Default.aspx" Text="Users"></asp:HyperLink>|
        <asp:HyperLink ID="CatalogLink" runat="server" NavigateUrl="~/Admin/Catalog/Browse.aspx" Text="Categories"></asp:HyperLink>|
        <asp:HyperLink ID="ProductLink" runat="server" NavigateUrl="~/Admin/Products/ManageProducts.aspx" Text="Products"></asp:HyperLink>|
        <asp:HyperLink ID="HomeLink" runat="server" NavigateUrl="~/Default.aspx" Text="Store"></asp:HyperLink>|
        <asp:HyperLink ID="LogoutLink" runat="server" NavigateUrl="~/logout.aspx" Text="Logout"></asp:HyperLink>
       </div>
        <p class="version">
            <asp:Literal ID="ProductVersion" runat="server" />
            <a href="http://help.ablecommerce.com/acgold/feedback" target="_blank">Report issue or request feature</a>
        </p>
        <p class="copyright">
            2012 - <asp:Label ID="copyright" runat="server"></asp:Label> &copy; Able Solutions Corporation
        </p>
    </div>
</div>