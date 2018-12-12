<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Checkout.BasketTotalSummary" EnableViewState="false" CodeFile="BasketTotalSummary.ascx.cs" %>
<%@ Register Src="~/ConLib/Checkout/TaxCloudTaxExemptionCert.ascx" TagName="TaxCloudTaxExemptionCert" TagPrefix="uc" %>
<%--
<conlib>
<summary>Shows a summary of basket totals</summary>
<param name="ShowTaxes" default="True">If true taxes are shown</param>
<param name="ShowTaxBreakdown" default="True">If true tax-breakdown is shown</param>
<param name="ShowShipping" default="True">If true shipping is shown</param>
<param name="ShowMessage" default="False">If true a message about pending calculations later is shown</param>
</conlib>
--%>
<div class="widget basketTotalSummaryWidget">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="Caption" runat="server" Text="Order Summary"></asp:Localize></h2>
        </div>
        <div class="content">
            <table cellspacing="0" class="orderTotalSummary">
			    <tr class="simpleRow">
                    <th><asp:Label ID="ProductTotalLabel" runat="server" Text="{0} Items in cart ex.gst: "></asp:Label></th>
                    <td align="right"><asp:Label ID="ProductTotal" runat="server"></asp:Label></td>
                </tr>
                
			    <tr class="simpleRow" id="trDiscounts" runat="server">
                    <th><asp:Label ID="DiscountsLabel" runat="server" Text="Discounts: "></asp:Label></th>
                    <td align="right"><asp:Label ID="Discounts" runat="server"></asp:Label></td>
                </tr>
                
			    <tr class="dividerRow"><td colspan="2"></td></tr>
                
			    <tr class="simpleRow">
                    <th><asp:Label ID="SubtotalLabel" runat="server" Text="Subtotal ex.gst: "></asp:Label></th>
                    <td align="right"><asp:Label ID="Subtotal" runat="server"></asp:Label></td>
                </tr>
                
                <tr class="simpleRow">
                    <th><asp:Label ID="GstLabel" runat="server" Text="GST: "></asp:Label></th>
                    <td align="right"><asp:Label ID="GstTotal" runat="server"></asp:Label></td>
                </tr>

			    <tr class="simpleRow" id="trGiftWrap" runat="server">
                    <th><asp:Label ID="GiftWrapLabel" runat="server" Text="Gift Wrap: "></asp:Label></th>
                    <td align="right"><asp:Label ID="GiftWrap" runat="server"></asp:Label></td>
                </tr>
                
			    <tr class="simpleRow" id="trShipping" runat="server">
                    <th><asp:Label ID="ShippingLabel" runat="server" Text="Shipping: "></asp:Label></th>
                    <td align="right"><asp:Label ID="Shipping" runat="server"></asp:Label></td>
                </tr>
                <tr class="simpleRow" id="trHandling" runat="server">
                    <th><asp:Label ID="HandlingLabel" runat="server" Text="Handling Fee: "></asp:Label></th>
                    <td align="right"><asp:Label ID="Handling" runat="server"></asp:Label></td>
                </tr>
			    <tr class="simpleRow" id="trTax" runat="server">
                    <th><asp:Label ID="TaxesLabel" runat="server" Text="Taxes: "></asp:Label></th>
                    <td align="right">
                        <asp:Label ID="Taxes" runat="server"></asp:Label>                    
                    </td>
                </tr>
                
			    <asp:Repeater ID="TaxesBreakdownRepeater" runat="server" Visible="false">
                    <ItemTemplate>
                        <tr class="simpleRow">
                            <th><asp:Label ID="TaxesLabel" runat="server" Text='<%#Eval("Key")%>'></asp:Label></th>
                            <td align="right">
                                <asp:Label ID="Taxes" runat="server" Text='<%#((decimal)Eval("Value")).LSCurrencyFormat("ulc")%>'></asp:Label>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
                
			    <tr id="trCouponsDivider" runat="server" class="dividerRow"><td colspan="2"></td></tr>

                <tr class="simpleRow" id="trCoupon" runat="server">
                    <th><asp:Label ID="CouponsLabel" runat="server" Text="Coupons: " ></asp:Label></th>
                    <td align="right"><asp:Label ID="Coupons" runat="server"></asp:Label></td>
                </tr>

                <tr class="simpleRow" id="trGifCodes" runat="server">
                    <th><asp:Label ID="GifCodesLabel" runat="server" Text="Gift Codes: " ></asp:Label></th>
                    <td align="right"><asp:Label ID="GifCodes" runat="server"></asp:Label></td>
                </tr>

                <tr class="dividerRow"><td colspan="2"></td></tr>
                
			    <tr class="importantRow">
                    <th><asp:Label ID="TotalLabel" runat="server" Text="Payment Total: " ></asp:Label></th>
                    <td><asp:Label ID="Total" runat="server"></asp:Label></td>
                </tr>
                <tr id="trTaxCloudTaxExemption" runat="server" visible="false">
                    <th style="text-align:right;" colspan="2">
                        <br />
                        <uc:TaxCloudTaxExemptionCert ID="TaxCloudTaxExemptionCert1" runat="server" />
                    </th>
                </tr>
            </table>
            <asp:PlaceHolder ID="TotalPendingMessagePanel" runat="server">
			    <div class="message"><asp:Localize ID="TotalPendingMessage" runat="server" Text="The final amount will be calculated and available for your review, before you complete your order."></asp:Localize></div>
            </asp:PlaceHolder>
        </div>
    </div>
</div>