<%@ Page Language="C#" MasterPageFile="~/Admin/Catalog/Webpage-Link.master" Inherits="AbleCommerce.Admin.Catalog.EditWebpageCategories" Title="Edit Webpage Categories" CodeFile="EditWebpageCategories.aspx.cs" AutoEventWireup="True" %>
<%@ Register Src="~/Admin/Catalog/WebpageMenu.ascx" TagName="WebpageMenu" TagPrefix="uc" %>
<%@ Register src="~/Admin/ConLib/CategoryTree.ascx" tagname="CategoryTree" tagprefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PrimarySidebarContent" runat="Server">
    <uc:WebpageMenu ID="WebpageMenu1" runat="server" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:localize id="Caption" runat="server" text="Categories for {0}"></asp:localize></h1>
        </div>
    </div>
    <div class="content">
        <asp:label id="SuccessMessage" runat="server" text="" skinid="GoodCondition" visible="false"></asp:label>
        <asp:label id="FailureMessage" runat="server" text="" skinid="ErrorCondition" visible="false"></asp:label>
        <uc:CategoryTree ID="CategoryTree" runat="server"></uc:CategoryTree>
        <asp:button id="SaveButton" runat="server" text="Save" onclick="SaveButton_Click" />
    </div>
</asp:Content>