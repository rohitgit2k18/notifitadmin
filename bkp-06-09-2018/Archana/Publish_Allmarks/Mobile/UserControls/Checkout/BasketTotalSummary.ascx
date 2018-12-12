<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Mobile.UserControls.Checkout.BasketTotalSummary" EnableViewState="false" CodeFile="BasketTotalSummary.ascx.cs" %>
<%--
<conlib>
<summary>Display totals and summary of contents of basket.</summary>
<param name="ShowTaxes" default="true">Indicates whether taxes should be shown in summary.</param>
<param name="ShowTaxBreakdown" default="true">Indicates whether taxes should be broken down by tax name, or shown as a lump sum.</param>
</conlib>
--%>
<div class="widget basketTotalSummaryWidget">
    <div class="section">
        <asp:Panel ID="HeaderPanel" runat="server" class="header">
            <h2><asp:Localize ID="Caption" runat="server" Text="Order Summary"></asp:Localize></h2>
        </asp:Panel>
        <div class="content">
            <table cellspacing="0" class="orderTotalSummary">
			    <tr class="simpleRow">
                    <th><asp:Label ID="ProductTotalLabel" runat="server" Text="{0} Items in cart: "></asp:Label></th>
                    <td align="right"><asp:Label ID="ProductTotal" runat="server" CssClass="price"></asp:Label></td>
                </tr>
                
			    <tr class="simpleRow" id="trDiscounts" runat="server">
                    <th><asp:Label ID="DiscountsLabel" runat="server" Text="Discounts: "></asp:Label></th>
                    <td align="right"><asp:Label ID="Discounts" runat="server" CssClass="price"></asp:Label></td>
                </tr>
                
			    <tr class="dividerRow"><td colspan="2"></td></tr>
                
			    <tr class="simpleRow">
                    <th><asp:Label ID="SubtotalLabel" runat="server" Text="Subtotal: "></asp:Label></th>
                    <td align="right"><asp:Label ID="Subtotal" runat="server" CssClass="price"></asp:Label></td>
                </tr>
                
			    <tr class="simpleRow" id="trGiftWrap" runat="server">
                    <th><asp:Label ID="GiftWrapLabel" runat="server" Text="Gift Wrap: "></asp:Label></th>
                    <td align="right"><asp:Label ID="GiftWrap" runat="server" CssClass="price"></asp:Label></td>
                </tr>
                
			    <tr class="simpleRow" id="trShipping" runat="server">
                    <th><asp:Label ID="ShippingLabel" runat="server" Text="Shipping: "></asp:Label></th>
                    <td align="right"><asp:Label ID="Shipping" runat="server" CssClass="price"></asp:Label></td>
                </tr>
                
			    <tr class="simpleRow" id="trTax" runat="server">
                    <th><asp:Label ID="TaxesLabel" runat="server" Text="Taxes: "></asp:Label></th>
                    <td align="right">
                        <asp:Label ID="Taxes" runat="server" CssClass="price"></asp:Label>                    
                    </td>
                </tr>
                
			    <asp:Repeater ID="TaxesBreakdownRepeater" runat="server" Visible="false">
                    <ItemTemplate>
                        <tr class="simpleRow">
                            <th><asp:Label ID="TaxesLabel" runat="server" Text='<%#Eval("Key")%>'></asp:Label>:</th>
                            <td align="right">
                                <asp:Label ID="Taxes" runat="server" Text='<%#((decimal)Eval("Value")).LSCurrencyFormat("ulc")%>' CssClass="price"></asp:Label>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                
			    <tr id="trCouponsDivider" runat="server" class="dividerRow"><td colspan="2"></td></tr>

                <tr class="simpleRow" id="trCoupon" runat="server">
                    <th><asp:Label ID="CouponsLabel" runat="server" Text="Coupons: " ></asp:Label></th>
                    <td align="right"><asp:Label ID="Coupons" runat="server" CssClass="price"></asp:Label></td>
                </tr>

                <tr class="simpleRow" id="trGifCodes" runat="server">
                    <th><asp:Label ID="GifCodesLabel" runat="server" Text="Gift Codes: " ></asp:Label></th>
                    <td align="right"><asp:Label ID="GifCodes" runat="server" CssClass="price"></asp:Label></td>
                </tr>

                <tr class="dividerRow"><td colspan="2"></td></tr>
                
			    <tr class="importantRow">
                    <th><asp:Label ID="TotalLabel" runat="server" Text="Payment Total: " ></asp:Label></th>
                    <td><asp:Label ID="Total" runat="server" CssClass="price"></asp:Label></td>
                </tr>
            </table>
            <asp:PlaceHolder ID="TotalPendingMessagePanel" runat="server">
			    <div class="message"><asp:Localize ID="TotalPendingMessage" runat="server" Text="The final amount will be calculated and available for your review, before you complete your order."></asp:Localize></div>
            </asp:PlaceHolder>
        </div>
    </div>
</div>