<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BasketDetails.ascx.cs"
    Inherits="AbleCommerce.ConLib.Checkout.BasketDetails" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/GiftWrapChoices.ascx" TagName="GiftWrapChoices" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/TaxCloudTaxExemptionCert.ascx" TagName="TaxCloudTaxExemptionCert" TagPrefix="uc" %>
<table cellpadding="5px" cellspacing="0" class="basketSummary" style="width:100%;">
    <tr class="headerRow">
        <th class="item">&nbsp;</th>
        <th class="sku">SKU</th>
        <th class="tax"><asp:Literal ID="TaxColumnHeaderText" runat="server" /></th>
        <th class="price">Price</th>
        <th class="quantity">Quantity</th>
        <th class="total">Total</th>
    </tr>
    <tr class="dividerRow">
        <td colspan="6"></td>
    </tr>
    <asp:Repeater ID="CartSummary" runat="server" OnItemCommand="CartSummary_ItemCommand" >
        <HeaderTemplate></HeaderTemplate>
        <ItemTemplate>
                <tr class="<%# Container.ItemIndex % 2 == 0 ? "evenRow" : "oddRow" %>">
                    <td class="item">
                        <asp:PlaceHolder ID="ProductPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") == OrderItemType.Product)%>'>
				            <uc:BasketItemDetail id="BasketItemDetail2" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="true" ShowSubscription="true" LinkProducts="True" />
                            <asp:PlaceHolder ID="phGiftOptions" runat="server" Visible='<%#ShowGiftOptionsLink(Container.DataItem)%>' >
                                <div class="setGiftOptions">
                                    <asp:LinkButton ID="GiftOptionsLink" runat="server" Text="Gift Options" CommandName="ShowGiftOptions" CommandArgument='<%#Eval("Id")%>'></asp:LinkButton>
                                </div>
                            </asp:PlaceHolder>
				        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="OtherPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") != OrderItemType.Product)%>' EnableViewState="false">
					        <strong><%#Eval("Name")%></strong>                            
				        </asp:PlaceHolder>    
                    </td>
                    <td class="sku">
                        <%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%>
                    </td>
                    <td class="tax" >
                        <asp:Literal ID="TaxColumnHeaderText" runat="server" Text='<%#string.Format("{0}%", TaxHelper.GetTaxRate((BasketItem)Container.DataItem).ToString("0.####"))%>' visible='<%#TaxHelper.ShowTaxColumn %>' />
                    </td>
                    <td class="price">
                        <%#TaxHelper.GetInvoicePrice(AbleContext.Current.User.Basket, (BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                    </td>
                    <td class="quantity">
                        <asp:Label ID="Quantity" runat="server" Text='<%#Eval("Quantity")%>'></asp:Label>
                    </td>
                    <td class="total">
                        <%#AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                    </td>
                </tr>
            </ItemTemplate>
        <FooterTemplate></FooterTemplate>
    </asp:Repeater>
    <tr class="dividerRow">
        <td colspan="6"></td>
    </tr>
    <tr class="simpleRow">
        <td colspan="3"></td>
        <th colspan="2">
            <asp:Label ID="SubtotalLabel" runat="server" Text="Subtotal: " ></asp:Label>
        </th>
        <td class="subTotals">
            <asp:Label ID="Subtotal" runat="server"></asp:Label>
        </td>
    </tr>
    <tr class="simpleRow" id="trShipping" runat="server">
        <td colspan="3"></td>
        <th colspan="2">
            <asp:Label ID="ShippingLabel" runat="server" Text="Shipping: " ></asp:Label>
        </th>
        <td class="subTotals">
            <asp:Label ID="Shipping" runat="server"></asp:Label>
        </td>
    </tr>
    <tr class="simpleRow" id="trHandling" runat="server">
        <td colspan="3"></td>
        <th colspan="2">
            <asp:Label ID="HandlingLabel" runat="server" Text="Handling Fee: " ></asp:Label>
        </th>
        <td class="subTotals">
            <asp:Label ID="Handling" runat="server"></asp:Label>
        </td>
    </tr>
    <tr class="simpleRow" id="trTax" runat="server">
        <td colspan="3"></td>
        <th colspan="2">
            <asp:Label ID="TaxesLabel" runat="server" Text="Taxes: " ></asp:Label>
        </th>
        <td class="subTotals">
            <asp:Label ID="Taxes" runat="server"></asp:Label>
        </td>
    </tr>
    <asp:Repeater ID="TaxesBreakdownRepeater" runat="server" Visible="false">
        <ItemTemplate>
            <tr class="simpleRow">
				<td colspan="3"></td>
                <th colspan="2"><asp:Label ID="TaxesLabel" runat="server" Text='<%#Eval("Key")%>'></asp:Label></th>
                <td class="subTotals">
                    <asp:Label ID="Taxes" runat="server" Text='<%#((decimal)Eval("Value")).LSCurrencyFormat("ulc")%>'></asp:Label>
                </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
    <tr id="trCouponsDivider" runat="server" class="dividerRow">
        <td colspan="6"></td>
    </tr>
    <tr class="simpleRow" id="trGifCodes" runat="server">
        <td colspan="3"></td>
        <th colspan="2">
            <asp:Label ID="GifCodesLabel" runat="server" Text="Gift Codes: " ></asp:Label>
        </th>
        <td class="subTotals">
            <asp:Label ID="GifCodes" runat="server"></asp:Label>
        </td>
    </tr>
    <tr class="dividerRow">
        <td colspan="6"></td>
    </tr>
    <tr class="importantRow">
        <td colspan="3" style="text-align:left"><uc:TaxCloudTaxExemptionCert ID="TaxCloudTaxExemptionCert1" runat="server" /></td>
        <td class="rowHeader" colspan="2">
            <asp:Label ID="TotalLabel" runat="server" Text="Payment Total: " ></asp:Label>
        </td>
        <td class="subTotals">
            <asp:Label ID="Total" runat="server"></asp:Label>
        </td>
    </tr>
</table>
<asp:Panel ID="GiftOptionsDialog" runat="server" Style="display:none;width:750px" CssClass="modalPopup">
    <asp:HiddenField ID="GiftOptionsBasketItemId" runat="server" />
    <asp:Panel ID="GiftOptionsDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
        <asp:Localize ID="GiftDialogCaption" runat="server" Text="Gift Options For '{0}'" EnableViewState="false"></asp:Localize>
    </asp:Panel>
    <asp:PlaceHolder ID="phGiftOptions" runat="server" Visible="false">
        <div class="modalPopupContent">
            <asp:Localize ID="ContinueInstructions" runat="server" Text="Select the gift options for the item and then press continue button."></asp:Localize>
            <div style="height:500px;overflow:scroll;">
                <table class="inputForm">
                    <tr>
                        <td colspan="2">
                            <asp:GridView ID="GiftItemsGrid" runat="server" AutoGenerateColumns="false" SkinID="ItemList">
                                <Columns>
                                    <asp:TemplateField HeaderText="Item">
                                        <HeaderStyle CssClass="thumbnail" />
                                        <ItemStyle CssClass="thumbnail" />
                                        <ItemTemplate>
                                            <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.IconUrl"))%>' EnableViewState="false">
                                                <asp:Image ID="Icon" runat="server" AlternateText='<%# Eval("Product.IconAltText") %>' ImageUrl='<%# Eval("Product.IconUrl") %>' EnableViewState="false" />
                                            </asp:PlaceHolder>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <HeaderStyle CssClass="item" />
                                        <ItemStyle CssClass="item" />
                                        <ItemTemplate>
                                            <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("BasketItem.Id")%>' ShowAssets="false" LinkProducts="False" IgnoreKitShipment="false" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Quantity">
                                        <HeaderStyle CssClass="quantity" />
                                        <ItemStyle CssClass="quantity" />
                                        <ItemTemplate>
                                            1
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Select Giftwrap">
                                        <HeaderStyle CssClass="giftOption" />
                                        <ItemStyle CssClass="giftOption" />
                                        <ItemTemplate>
                                            <uc:GiftWrapChoices ID="GiftWrapChoices" runat="server" BasketItemId='<%#Eval("BasketItem.Id")%>' GiftMessage='<%#Eval("GiftMessage")%>' WrapStyleId='<%#Eval("WrapStyleId")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Button ID="ContinueButton" runat="server" Text="Continue" onclick="ContinueButton_Click" CausesValidation="false" />
            <asp:Button ID="CancelGiftOptionsButton" runat="server" Text="Cancel" CausesValidation="false" EnableViewState="false"/>
        </div>
    </asp:PlaceHolder>
</asp:Panel>
<asp:LinkButton ID="DummyLink" runat="server" EnableViewState="false" />
<asp:LinkButton ID="DummyCancelLink" runat="server" EnableViewState="false" />
<ajaxToolkit:ModalPopupExtender ID="GiftOptionsPopup" runat="server" 
    TargetControlID="DummyLink"
    PopupControlID="GiftOptionsDialog" 
    BackgroundCssClass="modalBackground"                         
    CancelControlID="CancelGiftOptionsButton" 
    DropShadow="false"
    PopupDragHandleControlID="GiftOptionsDialogHeader" />
<asp:PlaceHolder ID="TotalPendingMessagePanel" runat="server">
    <div class="message">
        <asp:Localize ID="TotalPendingMessage" runat="server" Text="The final amount will be calculated and available for your review, before you complete your order."></asp:Localize></div>
</asp:PlaceHolder>
