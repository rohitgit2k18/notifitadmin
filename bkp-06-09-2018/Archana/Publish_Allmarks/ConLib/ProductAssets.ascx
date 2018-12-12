<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.ProductAssets" CodeFile="ProductAssets.ascx.cs" %>
<%--
<conlib>
<summary>Display additional details of assets of a product like digital goods, read me files and license agreements.</summary>
<param name="Caption" default="Additional Details">Caption / Title of the control</param>
</conlib>
--%>
<asp:PlaceHolder ID="ProductAssetsPanel" runat="server" Visible="false">
<div class="widget productAssets">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="CaptionText" runat="server" Text="Additional Details"></asp:Localize></h2>
        </div>
        <div class="content">
            <asp:Repeater ID="AssetLinkList" runat="server">
                <ItemTemplate>
                    <a href="<%#Eval("NavigateUrl")%>"><%#Eval("Text")%></a><br />
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</div>
</asp:PlaceHolder>
