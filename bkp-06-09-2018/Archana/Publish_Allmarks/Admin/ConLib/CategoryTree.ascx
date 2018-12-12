<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CategoryTree.ascx.cs" Inherits="AbleCommerce.Admin.ConLib.CategoryTree" EnableViewState="true" %>
<asp:UpdatePanel ID="u" runat="server">
    <ContentTemplate>
        <asp:TreeView ID="t" runat="server" ShowCheckBoxes="All" EnableClientScript="false" OnTreeNodePopulate="PopulateNode" ShowExpandCollapse="true" ShowLines="true" ExpandDepth="0" CssClass="categoryTree"></asp:TreeView>
    </ContentTemplate>
</asp:UpdatePanel>