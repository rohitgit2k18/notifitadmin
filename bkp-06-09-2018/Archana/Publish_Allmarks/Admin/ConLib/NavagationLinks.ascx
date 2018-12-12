<%@ Control Language="C#" AutoEventWireup="true" CodeFile="NavagationLinks.ascx.cs" Inherits="AbleCommerce.Admin.ConLib.NavagationLinks" EnableViewState="false" %>
<div id="MainPanel" runat="server" class="links">
    <asp:Repeater ID="MenuItemRepeater" runat="server">
        <ItemTemplate>
            <asp:HyperLink ID="CurrentMenuLink" runat="server" Text='<%#Eval("Title") %>' ToolTip='<%#Eval("Description") %>' SkinID="ActiveButton" Visible='<%#Eval("IsCurrentPageItem")%>' />
            <asp:HyperLink ID="MenuLink" runat="server" Text='<%#Eval("Title") %>' ToolTip='<%#Eval("Description") %>' SkinID="Button" NavigateUrl='<%#Eval("Url") %>' Visible='<%#!(bool)Eval("IsCurrentPageItem")%>' />
        </ItemTemplate>
    </asp:Repeater>
</div>
