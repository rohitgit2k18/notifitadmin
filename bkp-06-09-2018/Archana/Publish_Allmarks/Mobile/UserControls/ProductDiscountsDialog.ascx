<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductDiscountsDialog.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.ProductDiscountsDialog" %>
<%--
<UserControls>
<summary>Display all the discounts that can be applicable on selected product.</summary>
<param name="Caption" default="Available Discounts">Possible value can be any string.  Title of the control.</param>
</UserControls>
--%>
<div class="discountsDialog">
<div class="section ">
    <div class="header">
        <asp:Localize ID="phCaption" runat="server" Text="Available Discounts"></asp:Localize>
    </div>
    <div class="content">
        <asp:Repeater ID="DiscountsGrid" runat="server">        
            <ItemTemplate>
            <div class="discountInfo">
                <div class="name"><%# Eval("Name") %></div>
                <div class="levels"><%# GetLevels(Container.DataItem) %></div>
            </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>
</div>
