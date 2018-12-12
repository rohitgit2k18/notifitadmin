<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdminBreadCrumbs.ascx.cs" Inherits="AbleCommerce.Admin.ConLib.AdminBreadCrumbs" EnableViewState="false" %>
<div class="grid_12" id="adminBreadCrumbs">
    <div class="innerFrame">
        <asp:Repeater ID="BreadCrumbs" runat="server">
            <ItemTemplate>
                <a href="<%#Eval("Url")%>" class="<%#Eval("CssClass")%>"><%# Eval("Title") %></a>
            </ItemTemplate>
            <SeparatorTemplate>&nbsp;&gt;&nbsp;</SeparatorTemplate>
        </asp:Repeater>
    </div>
</div>