<%@ Control Language="C#" Inherits="AbleCommerce.ConLib.CategoryBreadCrumbs" EnableViewState="false" CodeFile="CategoryBreadCrumbs.ascx.cs" %>
<%--
<conlib>
<summary>Displays bread crumbs for the current category</summary>
<param name="HideLastNode" default="True">If true last node is hidden</param>
</conlib>
--%>
<div class="breadCrumbs categoryBreadCrumbs">
    <div class="innerSection">
	    <div class="content">
		    <asp:HyperLink ID="HomeLink" runat="server" NavigateUrl="" Text="Home"></asp:HyperLink>
		    <asp:Repeater ID="BreadCrumbsRepeater" runat="server">
			    <HeaderTemplate>&nbsp;&nbsp;-&nbsp;&nbsp;</HeaderTemplate>
			    <ItemTemplate>
				    <asp:HyperLink ID="BreadCrumbsLink" runat="server" NavigateUrl='<%#Eval("NavigateUrl")%>' Text='<%#Eval("Name")%>'></asp:HyperLink>
			    </ItemTemplate>
			    <SeparatorTemplate>&nbsp;&nbsp;-&nbsp;&nbsp;</SeparatorTemplate>
		    </asp:Repeater>
	    </div>
    </div>
</div>