<%@ Page Language="C#" MasterPageFile="~/Admin/Catalog/Webpage-Link.master" Inherits="AbleCommerce.Admin.Catalog.EditLinkCategories" Title="Edit Link Categories" CodeFile="EditLinkCategories.aspx.cs" AutoEventWireup="True" %>
<%@ Register Src="~/Admin/Catalog/LinkMenu.ascx" TagName="LinkMenu" TagPrefix="uc" %>
<%@ Register src="~/Admin/ConLib/CategoryTree.ascx" tagname="CategoryTree" tagprefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PrimarySidebarContent" Runat="Server">
    <uc:LinkMenu ID="LinkMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Categories for {0}"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <asp:Label ID="SuccessMessage" runat="server" Text="" SkinID="GoodCondition" Visible="false"></asp:Label>
        <asp:Label ID="FailureMessage" runat="server" Text="" SkinID="ErrorCondition" Visible="false"></asp:Label>
        <uc:CategoryTree ID="CategoryTree" runat="server"></uc:CategoryTree>
        <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
    </div>
</asp:Content>