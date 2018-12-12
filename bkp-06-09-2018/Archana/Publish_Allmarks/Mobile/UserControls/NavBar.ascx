<%@ Control Language="C#" Inherits="AbleCommerce.Mobile.UserControls.NavBar" EnableViewState="false" CodeFile="NavBar.ascx.cs" AutoEventWireup="True" %>
<%--
<conlib>
<summary>Displays a navigation bar for catalog pages on mobile store</summary>
</conlib>
--%>

<table class="navBar" cellpadding="0" cellspacing="0">
    <tr>
        <td class="left">
        <a runat="server" id="NavLink" class="navLink"><span class="arrowLeft"></span><asp:Literal ID="NavLinkText" runat="server"></asp:Literal></a>
        </td>
        <td class="right">
            <a runat="server" id="NavHomeLink"><span class="navHomeLink"></span></a>
            <a runat="server" id="NavCartLink"><span class="navCartLink"></span></a>
        </td>
    </tr>
</table>
