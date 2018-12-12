<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BasketNonShippableItems.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.BasketNonShippableItems" %>
<%--
<conlib>
<summary>Displays details for non shpping basket items.</summary>
<param name="ShowSku" default="true">Indicates wheather the SKU should be displayed or not.</param>
<param name="ShowTaxes" default="false">Indicates wheather the Taxes should be displayed or not.</param>
<param name="ShowPrice" default="true">Indicates wheather the Price should be displayed or not.</param>
<param name="ShowTotal" default="true">Indicates wheather the Total should be displayed or not.</param>
</conlib>
--%>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<asp:Panel ID="NonShippingItemsPanel" runat="server" CssClass="widget basketNonShippableItemsWidget">
	<div class="section">
        <div class="header">
            <h2><asp:Localize ID="NonShippingItemsCaption" runat="server" Text="Non Shipping Items"></asp:Localize></h2>
        </div>
        <div class="content">
            <asp:Repeater ID="NonShippingItemsGrid" runat="server">
                <HeaderTemplate>
                    <ul class="itemList">
                </HeaderTemplate>
                <ItemTemplate>
                    <li class="itemNode <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                        <span class="label"><%#Eval("Quantity")%> of <%#Eval("Name")%></span>(<span class="price"><%#((Decimal)Eval("Price")).LSCurrencyFormat("ulc")%></span>)
                    </li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Panel>