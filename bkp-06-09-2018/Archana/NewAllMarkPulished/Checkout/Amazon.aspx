<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.master" AutoEventWireup="true" CodeFile="Amazon.aspx.cs" Inherits="AbleCommerce.Checkout.Amazon" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="checkoutPage"> 
    <div id="checkout_amazon" class="mainContentWrapper"> 
	    <div id="pageHeader">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Checkout with Amazon"></asp:Localize></h1>
        </div>
        <table cellspacing="0" cellpadding="4">
            <tr>
                <td valign="top">
                    <asp:PlaceHolder ID="ShippingAddress" runat="server"></asp:PlaceHolder>
                    <asp:UpdatePanel ID="ShippingMethodUpdatePanel" runat="server" UpdateMode="Always">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ShipMethodsList"/>
                        </Triggers>
                        <ContentTemplate>
                            <br />
                            <asp:PlaceHolder ID="ShippingMethodPanel" runat="server" Visible="false" ViewStateMode="Enabled">
                                <div class="section" style="width:399px;">
                                    <div class="header">
                                        <h2><asp:Localize ID="ShippingMethodCaption" runat="server" Text="Shipping Method"></asp:Localize></h2>
                                    </div>
                                    <div class="content">
                                        <asp:RadioButtonList ID="ShipMethodsList" runat="server" DataValueField="Key" DataTextField="Value" AutoPostBack="true" OnSelectedIndexChanged="ShipMethod_SelectedIndexChanged"></asp:RadioButtonList>
                                        <asp:PlaceHolder ID="phNoShippingMethods" runat="server" Visible="false">
                                            <p>
                                                <asp:Localize ID="ShipMethodErrorMessage" runat="server" Visible="false" Text="There are no shipping methods available for the specified shipping address."></asp:Localize>
                                                <asp:Localize ID="ShipMethodUPSErrorMessage" runat="server" Visible="false" Text=" Remember that UPS cannot ship to PO boxes."></asp:Localize>
                                            </p>
                                        </asp:PlaceHolder>
                                    </div>
                                </div>
                            </asp:PlaceHolder>
                            <asp:Button ID="RecalculateShippingButton" runat="server" Text="Recalculate" style="display:none" onclick="RecalculateShippingButton_Click" />
                            <asp:PlaceHolder ID="PaymentPanel" runat="server" Visible="false" ViewStateMode="Enabled">
                                <asp:PlaceHolder ID="phPaymentWidget" runat="server"></asp:PlaceHolder>
                            </asp:PlaceHolder><br />
                            <asp:Button ID="PlaceOrderButton" runat="server" Text="Place Order" onclick="PlaceOrderButton_Click" OnClientClick="this.value = 'Submitting...'; this.enabled= false;" style="display:none"/>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td valign="top">
                    <asp:UpdatePanel ID="BasketItemsUpdatePanel" runat="server" UpdateMode="Always">
                        <ContentTemplate>
                            <asp:PlaceHolder ID="BasketItemsPanel" runat="server">
                                <div class="section shipmentSection">
                                    <div class="header">
                                        <h2><asp:Localize ID="CartCaption" runat="server" Text="Your Cart"></asp:Localize></h2>
                                    </div>
                                    <div class="content">
                                        <cb:ExGridView ID="BasketItemsGrid" runat="server" AutoGenerateColumns="false" SkinID="ItemList" ShowFooter="True" >
                                            <Columns>
                                                <asp:TemplateField HeaderText="Item">
                                                    <HeaderStyle CssClass="thumbnail" />
                                                    <ItemStyle CssClass="thumbnail" />
                                                    <ItemTemplate>
                                                        <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>'>
                                                            <asp:HyperLink ID="IconLink" runat="server" NavigateUrl='<%#Eval("Product.NavigateUrl") %>'>
                                                                <asp:Image ID="Icon" runat="server" AlternateText='<%# Eval("Product.IconAltText") %>' ImageUrl='<%# Eval("Product.IconUrl") %>' Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.IconUrl")) %>' EnableViewState="false" />
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
                                                <asp:TemplateField >
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
                                                    <FooterStyle CssClass="footerSubtotalLabel" />
									                <FooterTemplate>
										                <asp:Label ID="SubtotalLabel" runat="server" Text="Subtotal:" CssClass="fieldHeader" EnableViewState="false"></asp:Label>
									                </FooterTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Total">
                                                    <HeaderStyle CssClass="total" />
                                                    <ItemStyle CssClass="total" />
                                                    <ItemTemplate>
                                                        <%#AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                                                    </ItemTemplate>
                                                    <FooterStyle CssClass="footerSubtotal" />
									                <FooterTemplate>
										                <asp:Label ID="Subtotal" runat="server" Text='<%# GetBasketSubtotal().LSCurrencyFormat("ulc") %>' CssClass="fieldHeader" EnableViewState="false"></asp:Label>
									                </FooterTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </cb:ExGridView>
				                    </div>
			                    </div>
                            </asp:PlaceHolder>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
    </div>
</div>
</asp:Content>
