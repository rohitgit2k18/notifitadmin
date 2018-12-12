<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BasketNonShippableItems.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.BasketNonShippableItems" %>
<%--
<conlib>
<summary>Displays non-shippable items in a basket</summary>
<param name="ShowSku" default="True">If true SKU is shown</param>
<param name="ShowTaxes" default="False">If true taxes are shown</param>
<param name="ShowPrice" default="True">If true price is shown</param>
<param name="ShowTotal" default="True">If true total is shown</param>
</conlib>
--%>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<asp:Panel ID="NonShippingItemsPanel" runat="server" CssClass="widget basketNonShippableItemsWidget">
	<div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="NonShippingItemsCaption" runat="server" Text="Non Shipping Items"></asp:Localize></h2>
        </div>
        <div class="content">
            <cb:ExGridView ID="NonShippingItemsGrid" runat="server" Width="100%" AutoGenerateColumns="false" SkinID="ItemList">
                <Columns>
                    <asp:TemplateField HeaderText="Item">
                        <HeaderStyle CssClass="thumbnail" />
                        <ItemStyle CssClass="thumbnail" />
                        <ItemTemplate>
                            <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>' EnableViewState="false">
                                <asp:HyperLink ID="IconLink" runat="server" NavigateUrl='<%#Eval("Product.NavigateUrl") %>' EnableViewState="false">
                                    <asp:Image ID="Icon" runat="server" AlternateText='<%# Eval("Product.IconAltText") %>' ImageUrl='<%# AbleCommerce.Code.ProductHelper.GetIconUrl(Container.DataItem) %>' Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.IconUrl")) %>' EnableViewState="false" />
                                </asp:HyperLink>
                            </asp:PlaceHolder>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <HeaderStyle CssClass="item" />
                        <ItemStyle CssClass="item" />
                        <ItemTemplate>
                            <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="True" LinkProducts="False" IgnoreKitShipment="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="SKU">
                        <HeaderStyle CssClass="sku" />
                        <ItemStyle CssClass="sku" />
                        <ItemTemplate>
                            <asp:Label ID="SKU" runat="server" Text='<%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <HeaderStyle CssClass="tax" />
                        <ItemStyle CssClass="tax" />
                        <HeaderTemplate>
                            <%#GetTaxHeader()%>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%#TaxHelper.GetTaxRate((BasketItem)Container.DataItem).ToString("0.####")%>%
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Price">
                        <HeaderStyle CssClass="price" />
                        <ItemStyle CssClass="price" />
                        <ItemTemplate>
                            <%#TaxHelper.GetInvoicePrice(AbleContext.Current.User.Basket, (BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Quantity">
                        <HeaderStyle CssClass="quantity" />
                        <ItemStyle CssClass="quantity" />
                        <ItemTemplate>
                            <asp:Label ID="Quantity" runat="server" Text='<%#Eval("Quantity")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total">
                        <HeaderStyle CssClass="total" />
                        <ItemStyle CssClass="total" />
                        <ItemTemplate>
                            <%#AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </cb:ExGridView>
        </div>
    </div>
</asp:Panel>