<%@ Page Title="Navigation" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Menu.aspx.cs" Inherits="AbleCommerce.Admin.Menu" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
         <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Navigation: {0} Menu"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p>Where would you like to go?</p>
        <asp:Repeater ID="MenuItemRepeater" runat="server">
            <HeaderTemplate>
                <div class="tilesMenu">
                <ul>
            </HeaderTemplate>
            <ItemTemplate>
                <li class="tile_<%#Container.ItemIndex%>"><a href='<%#Eval("Url") %>' desc='<%#GetDescription(Container.DataItem)%>'><div><span><%#Eval("Title") %></span><p><%#Eval("Description") %></p></div></a></li>
                
            </ItemTemplate>
            <FooterTemplate>
                </ul>
                </div>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>