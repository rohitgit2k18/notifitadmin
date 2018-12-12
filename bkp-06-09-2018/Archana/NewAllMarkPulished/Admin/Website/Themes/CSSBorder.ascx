<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CSSBorder.ascx.cs" Inherits="AbleCommerce.Admin.Website.Themes.CSSBorder" %>
<asp:TextBox ID="BorderWidth_Style" runat="server" Width="40"></asp:TextBox>
<asp:DropDownList ID="BorderStyle_Style" runat="server" Width="70">
    <asp:ListItem Value="" Text=""></asp:ListItem>
    <asp:ListItem Value="none" Text="None"></asp:ListItem>
    <asp:ListItem Value="dotted" Text="Dotted"></asp:ListItem>
    <asp:ListItem Value="dashed" Text="Dashed"></asp:ListItem>
    <asp:ListItem Value="solid" Text="Solid line"></asp:ListItem>
    <asp:ListItem Value="double" Text="Duble line"></asp:ListItem>
    <asp:ListItem Value="groove" Text="Groove"></asp:ListItem>
    <asp:ListItem Value="ridge" Text="Ridge"></asp:ListItem>
    <asp:ListItem Value="inset" Text="Inset"></asp:ListItem>
    <asp:ListItem Value="outset" Text="Outset"></asp:ListItem>
</asp:DropDownList>
<asp:TextBox ID="BorderColor_Style" runat="server" CssClass="Multiple"></asp:TextBox>