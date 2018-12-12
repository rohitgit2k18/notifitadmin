<%@ Control Language="C#" Inherits="AbleCommerce.ConLib.SimpleCategoryList" EnableViewState="false" CodeFile="SimpleCategoryList.ascx.cs" %>
<%--
<conlib>
<summary>A simple category list suitable for displaying in sidebar. It which shows the nested categories under the selected category.</summary>
<param name="CategoryId" default="-1">The category id from which you want to list child categories</param>
<param name="CssClass" default="innerSection">The css class to apply on the main outer panel.</param>
<param name="HeaderCssClass" default="header">The css class to apply on the header panel.</param>
<param name="HeaderText" default="Categories">Title Text for the header.</param>
<param name="ContentCssClass" default="content">The css class to apply on the content panel.</param>
</conlib>
--%>
<div class="widget simpleCategoryListWidget">
    <asp:Panel ID="MainPanel" runat="server" CssClass="innerSection">
        <asp:Panel ID="HeaderPanel" runat="server" CssClass="header">
	        <h2><asp:Localize ID="HeaderTextLabel" runat="server" Text="Categories"></asp:Localize></h2>
        </asp:Panel>
	    <asp:Panel ID="ContentPanel" runat="server" CssClass="content">
            <asp:Repeater ID="CategoryList" runat="server">
                <HeaderTemplate>
                    <ul class="category">
                </HeaderTemplate>
                <ItemTemplate>
                    <li><asp:HyperLink ID="CategoryLink" runat="server"  Text='<%#Eval("Name")%>' NavigateUrl='<%#Eval("NavigateUrl")%>'></asp:HyperLink></li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Label ID="NoSubcategoryMessage" runat="server" Text="There are no subcategories." Visible="false"></asp:Label>
        </asp:Panel>
    </asp:Panel>
</div>
