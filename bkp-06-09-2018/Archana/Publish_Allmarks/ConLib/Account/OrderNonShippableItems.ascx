<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderNonShippableItems.ascx.cs" Inherits="AbleCommerce.ConLib.Account.OrderNonShippableItems" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays non-shippable items of an order</summary>
</conlib>
--%>
<%@ Register Src="~/ConLib/Account/OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<asp:Panel ID="NonShippingItemsPanel" runat="server" CssClass="widget orderNonShippableItemsWidget">
    <div class="header">
        <h2>
            <asp:Localize ID="NonShippingItemsCaption" runat="server" Text="Non Shipping Items"></asp:Localize>
        </h2>
    </div>
    <div class="content">
        <cb:ExGridView ID="NonShippingItemsGrid" runat="server" Width="100%" AutoGenerateColumns="false" SkinID="ItemList" OnDataBinding="ItemsGrid_DataBinding">
            <Columns>
                <asp:TemplateField HeaderText="Item">
                    <HeaderStyle CssClass="thumbnail" />
                    <ItemStyle CssClass="thumbnail" />
                    <ItemTemplate>
                        <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>'>
                            <asp:HyperLink ID="IconLink" runat="server" NavigateUrl='<%#Eval("Product.NavigateUrl") %>'>
                                <asp:Image ID="Icon" runat="server" AlternateText='<%# Eval("Product.IconAltText") %>' ImageUrl='<%# AbleCommerce.Code.ProductHelper.GetIconUrl(Container.DataItem) %>' Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.IconUrl")) %>' EnableViewState="false" />
                            </asp:HyperLink>
                        </asp:PlaceHolder>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderStyle CssClass="item" />
                    <ItemStyle CssClass="item" />
                    <ItemTemplate>
                        <uc:OrderItemDetail ID="OrderItemDetail1" runat="server" OrderItem='<%#(OrderItem)Container.DataItem%>' ShowAssets="False" LinkProducts="False" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="SKU">
                    <HeaderStyle CssClass="sku" />
                    <ItemStyle CssClass="sku" />
                    <ItemTemplate>
                        <%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tax">
                    <HeaderStyle CssClass="tax" />
                    <ItemStyle CssClass="tax" />
                    <ItemTemplate>
                        <%#TaxHelper.GetTaxRate((Order)Eval("Order"), (OrderItem)Container.DataItem).ToString("0.####")%>%
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Price">
                    <HeaderStyle CssClass="price" />
                    <ItemStyle CssClass="price" />
                    <ItemTemplate>
                        <%#TaxHelper.GetInvoicePrice((Order)Eval("Order"), (OrderItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Quantity">
                    <HeaderStyle CssClass="quantity" />
                    <ItemStyle CssClass="quantity" />
                    <ItemTemplate>
                        <%#Eval("Quantity")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Total">
                    <HeaderStyle CssClass="total" />
                    <ItemStyle CssClass="total" />
                    <ItemTemplate>
                        <%#AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((OrderItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </cb:ExGridView>
	</div>
</asp:Panel>