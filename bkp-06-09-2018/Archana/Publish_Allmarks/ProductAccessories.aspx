<%@ Page Title="Products Accessories" Language="C#" MasterPageFile="~/Layouts/Fixed/RightSidebar.Master" AutoEventWireup="True" CodeFile="ProductAccessories.aspx.cs" Inherits="AbleCommerce.ProductAccessories" %>
<%@ Register src="~/ConLib/ProductAccessoriesGrid.ascx" tagname="ProductAccessoriesGrid" tagprefix="uc1" %>
<%@ Register src="~/ConLib/MiniBasket.ascx" tagname="MiniBasket" tagprefix="uc2" %>
<%@ Register src="~/ConLib/RecentlyViewed.ascx" tagname="RecentlyViewed" tagprefix="uc3" %>

<asp:Content ID="Content1" runat="server" contentplaceholderid="PageContent">
<div id="accessoriesPage" class="mainContentWrapper">
    <uc1:ProductAccessoriesGrid ID="ProductAccessoriesGrid1" runat="server" />
</div>
</asp:Content>

<asp:Content ID="Content2" runat="server" contentplaceholderid="RightSidebar">
	<div>
		<uc2:MiniBasket ID="MiniBasket1" runat="server" />
	</div>
	<div>
		<uc3:RecentlyViewed ID="RecentlyViewed1" runat="server" />
	</div>	
</asp:Content>
