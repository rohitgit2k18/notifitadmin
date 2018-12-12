<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="AbleCommerce.Mobile.Default" ViewStateMode="Disabled" %>
<%@ Register src="~/Mobile/UserControls/SimpleCategoryList.ascx" tagname="SimpleCategoryList" tagprefix="uc1" %>
<%@ Register src="UserControls/FeaturedProducts.ascx" tagname="FeaturedProducts" tagprefix="uc2" %>
<%@ Register src="UserControls/StoreHeader.ascx" tagname="StoreHeader" tagprefix="uc3" %>
<%@ Register src="~/Mobile/UserControls/SearchBox.ascx" tagname="SearchBox" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
    <uc2:FeaturedProducts ID="FeaturedProducts1" runat="server" />
    <uc1:SimpleCategoryList ID="SimpleCategoryList1" runat="server" />
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="PageHeader">    
    <uc3:StoreHeader ID="StoreHeader1" runat="server" />
    <uc1:SearchBox ID="SearchBox1" runat="server" />
</asp:Content>

