<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdminHeader.ascx.cs" Inherits="AbleCommerce.Admin.ConLib.AdminHeader" EnableViewState="false" %>
<%@ Register src="AdminMenu.ascx" tagname="AdminMenu" tagprefix="uc" %>
 <script>
     $(function () {
         $("#AdminSearchButton")
         .button({
             icons: {
                 secondary: "ui-icon-triangle-1-s"
             }
         })
         .click(function () {
             var menu = $(this).parent().next().show().position({
                 my: "right top",
                 at: "right bottom",
                 of: this
             });
             $(document).one("click", function () {
                 menu.hide();
             });
             return false;
         })
         .parent()
         .buttonset()
         .next()
         .click()
         .hide()
         .menu()
     });
</script>
<div id="adminHeader" class="grid_12">
    <div class="grid_4 alpha">
        <div id="headerLogo">
            <asp:Image ID="AdminLogo" runat="server" SkinID="Logo" />
        </div>
    </div>
    <div class="grid_8 omega">
        <div id="headerNav">
            <ul>
                <li class="dashboard"><asp:HyperLink ID="DashboardLink" runat="server" Text="Dashboard" ToolTip="Dashboard"></asp:HyperLink></li>
                <li class="orders"><asp:HyperLink ID="OrdersLink" runat="server" Text="Orders" ToolTip="Orders"></asp:HyperLink></li>
                <li class="users"><asp:HyperLink ID="UsersLink" runat="server" Text="Users" ToolTip="Users"></asp:HyperLink></li>
                <li class="catalog"><asp:HyperLink ID="CatalogLink" runat="server" Text="Categories" ToolTip="Categories"></asp:HyperLink></li>
                <li class="products"><asp:HyperLink ID="ProductsLink" runat="server" Text="Products" ToolTip="Products"></asp:HyperLink></li>
                <li class="store"><asp:HyperLink ID="StoreLink" runat="server" Text="Store" ToolTip="Store"></asp:HyperLink></li>
                <li class="logout"><asp:HyperLink ID="LogoutLink" runat="server" Text="Logout" ToolTip="Logout"></asp:HyperLink></li>
            </ul>
        </div>
    </div>
</div>
<div id="menuBar" class="grid_12">
    <div class="grid_10 alpha">
        <uc:AdminMenu ID="AdminMenu1" runat="server" />
    </div>
    <div class="grid_2 omega">
        <div id="headerSearch">
             <div>
                <div>
                    <asp:TextBox ID="SearchPhrase" runat="server" MaxLength="100"></asp:TextBox>
                    <asp:Button ID="AdminSearchButton" runat="server" CausesValidation="false" 
                        Text="Search" ClientIDMode="Static" CssClass="button" />
                    <asp:HiddenField ID="HiddenSearchArea" runat="server" />
                </div>
                <ul id="SearchAreaList">
                    <li><asp:LinkButton ID="SearchAll" runat="server" Text="Search All" OnClick="SearchAll_Click" EnableViewState="false" /></li>
                    <li><asp:LinkButton ID="SearchOrders" runat="server" Text="Search Orders" OnClick="SearchOrders_Click" EnableViewState="false"/></li>
                    <li><asp:LinkButton ID="SearchUsers" runat="server" Text="Search Users" OnClick="SearchUsers_Click" EnableViewState="false"/></li>
                    <li><asp:LinkButton ID="SearchProducts" runat="server" Text="Search Products" OnClick="SearchProducts_Click" EnableViewState="false"/></li>
                    <li><asp:LinkButton ID="SearchCategories" runat="server" Text="Search Categories" OnClick="SearchCategories_Click" EnableViewState="false"/></li>
                    <li><asp:LinkButton ID="SearchWebpages" runat="server" Text="Search Webpages" OnClick="SearchWebpages_Click" EnableViewState="false"/></li>
                    <li><asp:LinkButton ID="SearchLinks" runat="server" Text="Search Links" OnClick="SearchLinks_Click" EnableViewState="false"/></li>
                </ul>
            </div>
        </div>
    </div>
</div>
<div class="clear"></div>