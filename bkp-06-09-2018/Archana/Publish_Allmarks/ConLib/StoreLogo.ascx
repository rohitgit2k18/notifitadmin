<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.StoreLogo" EnableViewState="false" CodeFile="StoreLogo.ascx.cs" %>
<%--
<conlib>
<summary>Displays the store logo.</summary>
</conlib>
--%>
<div class="storeLogo">
    <asp:HyperLink ID="LogoLink" runat="server" NavigateUrl="~/"><asp:Image ID="Logo" runat="server" /></asp:HyperLink>
</div>