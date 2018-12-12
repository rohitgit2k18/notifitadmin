<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CategoryMenu.ascx.cs" Inherits="AbleCommerce.ConLib.CategoryMenu" %>
<%--
<conlib>
<summary>A simple category menu suitable for displaying in sidebar. It will shows all categories.</summary>
<param name="CategoryId" default="-1">The category id from which you want to list child categories</param>
<param name="HeaderText" default="Categories">Title Text for the header.</param>
</conlib>
--%>
<script type="text/javascript">
    $(document).ready(function () {
        $("#menu").menu();
    });
</script>
<div class="widget categoryMenu">
    <div class="innerSection">
        <div class="header">
            <h2><asp:localize ID="phCaption" runat="server" Text="Categories"></asp:localize></h2>
        </div>
        <div class="content">
            <asp:Literal ID="phMenu" runat="server"></asp:Literal>
        </div>
        <asp:PlaceHolder ID="phReload" runat="server">
            <div style="text-align:center;">
                <asp:LinkButton ID="RefreshButton" runat="server" Text="Refresh" OnClick="RefreshButton_Click" ToolTip="Click to invalidate the cache and reload category menu." ></asp:LinkButton>
            </div>
        </asp:PlaceHolder>
    </div>
</div>