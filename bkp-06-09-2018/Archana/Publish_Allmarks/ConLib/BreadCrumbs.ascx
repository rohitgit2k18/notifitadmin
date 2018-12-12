<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.BreadCrumbs" CodeFile="BreadCrumbs.ascx.cs" %>
<%--
<conlib>
<summary>Displays dynamic bread crumb links for the current page.</summary>
</conlib>
--%>
<div class="breadCrumbs accountBreadCrumbs">
    <div class="innerSection">
	    <div class="content">
		    <asp:SiteMapPath ID="StoreBreadCrumbs" runat="server" SiteMapProvider="StoreSiteMap" EnableViewState="False">
			    <NodeStyle CssClass="breadCrumbs" />
			    <CurrentNodeStyle Font-Underline="false" Font-Bold="true" />
			    <PathSeparatorTemplate><asp:Localize ID="PathSeparator" runat="server" Text=" > "></asp:Localize></PathSeparatorTemplate>
		    </asp:SiteMapPath>
	    </div>
    </div>
</div>