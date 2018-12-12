<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderShipments.ascx.cs" Inherits="AbleCommerce.ConLib.Account.OrderShipments" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays shipments of a given order</summary>
</conlib>
--%>
<%@ Register Src="~/ConLib/Account/OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<asp:Panel ID="ShipmentsPanel" runat="server" CssClass="orderShipmentWidgets">
    <asp:Repeater ID="ShipmentRepeater" runat="server">
        <ItemTemplate>
            <div class="widget shipmentWidget">
                <div class="header">
                    <h2>
                        <asp:Localize ID="ShipmentCaption" runat="server" Text="Shipment Information"></asp:Localize>
                    </h2>
                </div>
                <div class="content">
                    <div class="address">
                        <div class="shippingAddress">
                            <h3>Ship To:</h3>
                            <%# GetShipToAddress(Container.DataItem) %>
                        </div>
                        <div class="shippingStatus">
                            <h3>Status:</h3>
                            <%#GetShipStatus(Container.DataItem)%>
                        </div>
                        <div class="shippingMethod">
                            <h3>Method:</h3>
                            <%#Eval("ShipMethodName") %>
                        </div>
                        <asp:Panel ID="TrackingNumberPanel" runat="Server" Visible='<%#HasTrackingNumbers(Container.DataItem)%>' CssClass="tracking">
                            <h3>Tracking:</h3>
                            <asp:Repeater ID="TrackingRepeater" runat="server" DataSource='<%#Eval("TrackingNumbers")%>'>
                                <ItemTemplate>
                                    <asp:HyperLink ID="TrackingNumberData"  Target="_blank" runat="server" Text='<%#Eval("TrackingNumberData")%>' NavigateUrl='<%#GetTrackingUrl(Container.DataItem)%>'></asp:HyperLink>
                                </ItemTemplate>
                                <SeparatorTemplate>, </SeparatorTemplate>
                            </asp:Repeater>                         
                        </asp:Panel>
                    </div>
                    <div class="items">
                        <cb:ExGridView ID="ShipmentItemsGrid" runat="server" Width="100%" AutoGenerateColumns="false" DataSource='<%# AbleCommerce.Code.InvoiceHelper.RemoveDiscountItems(AbleCommerce.Code.OrderHelper.GetShipmentItems(Container.DataItem)) %>' SkinID="ItemList" OnDataBinding="ItemsGrid_DataBinding">
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
                                <asp:TemplateField Visible="false" HeaderText="SKU">
                                    <HeaderStyle CssClass="sku" />
                                    <ItemStyle CssClass="sku" />
                                    <ItemTemplate>
                                        <%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <%--<asp:TemplateField HeaderText="Tax">
                                    <HeaderStyle CssClass="tax" />
                                    <ItemStyle CssClass="tax" />
                                    <ItemTemplate>
                                        <%#TaxHelper.GetTaxRate((Order)Eval("Order"), (OrderItem)Container.DataItem).ToString("0.####")%>%
                                    </ItemTemplate>
                                </asp:TemplateField>--%>
                                <asp:TemplateField HeaderText="Price ex.gst">
                                    <HeaderStyle CssClass="price" />
                                    <ItemStyle CssClass="price" />
                                    <ItemTemplate>
                                        <%#AbleCommerce.Code.InvoiceHelper.GetShopPrice((OrderItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Quantity">
                                    <HeaderStyle CssClass="quantity" />
                                    <ItemStyle CssClass="quantity" />
                                    <ItemTemplate>
                                        <%#Eval("Quantity")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="GST">
                                    <HeaderStyle CssClass="price" />
                                    <ItemStyle CssClass="price" />
                                    <ItemTemplate>
                                        <%#AbleCommerce.Code.InvoiceHelper.GetGSTPrice((OrderItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Total ex.gst">
                                    <HeaderStyle CssClass="total" />
                                    <ItemStyle CssClass="total" />
                                    <ItemTemplate>
                                       <%#AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((OrderItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </cb:ExGridView>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Panel>