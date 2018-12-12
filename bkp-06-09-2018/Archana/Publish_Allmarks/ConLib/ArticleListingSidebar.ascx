<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.ArticleListingSidebar"  CodeFile="ArticleListingSidebar.ascx.cs" %>
<%--
<conlib>
<summary>A sidebar control that list webpages of a category in a row format.</summary>
<param name="DefaultCaption" default="Blog">Caption text that will be shown as caption when root category will be browsed.</param>
<param name="CategoryId" default="0">Category Id from where blog pages will be displayed.</param>
<param name="MaxItems" default="10">Number of blog posts to list at one page by default.</param>
<param name="DefaultSortOrder" default="PublishDate DESC">The default sort order for the blog posts to be shown.</param>
</conlib>
--%>
<div class="widget articleListingSidebar">
    <asp:Panel ID="MainPanel" runat="server" CssClass="innerSection">
        <asp:Panel ID="HeaderPanel" runat="server" CssClass="header">
	        <h2><asp:Literal ID="Caption" runat="server" EnableViewState="False"></asp:Literal></h2>
        </asp:Panel>
	    <asp:Panel ID="ContentPanel" runat="server" CssClass="content">
            <asp:Repeater ID="BlogRepeater" runat="server">
                <HeaderTemplate><ul class="webpage"></HeaderTemplate>
				<ItemTemplate><li><asp:HyperLink id="WebPageName" runat="server" NavigateUrl='<%#Eval("NavigateUrl")%>'><%#Eval("Name")%></asp:HyperLink></li></ItemTemplate>
                <FooterTemplate></ul></FooterTemplate>
            </asp:Repeater>
            <asp:Label ID="NoArticlesMessage" runat="server" Text="There are no articles to display."></asp:Label>
        </asp:Panel>
    </asp:Panel>
</div>
