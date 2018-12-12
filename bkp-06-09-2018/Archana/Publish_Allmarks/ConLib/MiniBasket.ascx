<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.MiniBasket" CodeFile="MiniBasket.ascx.cs" %>
<%--
<conlib>
<summary>Displays contents of the basket in concise format that can be used to display basket in side bars.</summary>
<param name="ShowAlternateControl" default="False">If true an alternate control is displayed in place if the basket is empty</param>
<param name="AlternateControl" default="PopularProductsDialog.ascx">A control that will be displayed when the cart is empty</param>
</conlib>
--%>
<%@ Register Src="~/ConLib/Utility/MiniBasketItemDetail.ascx" TagName="MiniBasketItemDetail" TagPrefix="uc1" %>
<%@ Register Src="~/ConLib/PayPalExpressCheckoutButton.ascx" TagName="PayPalExpressCheckoutButton" TagPrefix="uc1" %>
<%@ Register Src="~/ConLib/Checkout/AmazonCheckoutButton.ascx" TagName="AmazonCheckoutButton" TagPrefix="uc1" %>
<asp:UpdatePanel ID="BasketPanel" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <asp:PlaceHolder ID="MiniBasketHolder" runat="server">
            <div class="widget miniBasket">
                <div class="innerSection">
                    <div class="header">
                        <h2><asp:localize ID="Caption" runat="server" Text="Your Cart"></asp:localize></h2>
                    </div>
                    <asp:Button ID="DummyButtonForEnterSupress" runat="server" Text="" OnClientClick="return false;" style="display:none;" />
                    <asp:Panel ID="ContentPanel" runat="server" CssClass="content" DefaultButton="DummyButtonForEnterSupress">
                        <asp:PlaceHolder ID="BasketTable" runat="server">
	                        <div class="miniBasketWrapper">
                                <asp:Repeater ID="BasketRepeater" runat="server" OnItemCommand="BasketRepeater_ItemCommand" >
                                    <ItemTemplate>
                                        <div class="basketItemBox">
                                            <asp:PlaceHolder ID="ProductImagePanel" runat="server" visible='<%#IsParentProduct(Container.DataItem)%>' EnableViewState="false">
                                                <div class="<%# (HasImage(Container.DataItem) ? "iconBox" : "" ) %>">
                                                    <asp:HyperLink ID="IconLink" runat="server" NavigateUrl='<%#GetProductUrl(Container.DataItem)%>' EnableViewState="false">
                                                        <asp:Image ID="Icon" runat="server" AlternateText='<%# Eval("Product.IconAltText") %>' ImageUrl='<%# GetIconUrl(Container.DataItem) %>' Width="50" Height="50" EnableViewState="false" Visible='<%# HasImage(Container.DataItem) %>'/>
                                                    </asp:HyperLink>								
                                                </div>
                                            </asp:PlaceHolder>
                                            <div class="titleBox<%# (HasImage(Container.DataItem) || !IsParentProduct(Container.DataItem) ? "" : " noIcon") %>">
                                                <uc1:MiniBasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' LinkProducts="true" ShowAssets="false" ShowSubscription="false" />
                                            </div>
                                            <div id="Clear" runat="server" class="clear" visible='<%#IsParentProduct(Container.DataItem)%>'></div>
                                            <div id="ActionsPanel" runat="server" visible='<%#IsParentProduct(Container.DataItem)%>' class="actions">
                                                <span class="label quantityLabel">Qty:</span>
                                                <asp:PlaceHolder ID="ProductQuantityPanel" runat="server" >	
                                                    <asp:TextBox ID="Quantity" runat="server" Text='<%# Eval("Quantity") %>' onfocus="this.select()" CssClass="quantity" EnableViewState="false" Visible='<%#IsParentProduct(Container.DataItem)%>'></asp:TextBox>
                                                </asp:PlaceHolder>
                                                <asp:PlaceHolder ID="QuantityDeletePh" runat="server">
                                                    <asp:LinkButton ID="UpdateItemButton" runat="server" CommandName="UpdateItem" CommandArgument='<%#Eval("BasketItemId")%>' Text="Update" CausesValidation="false" SkinID="Button"></asp:LinkButton>
                                                    <asp:LinkButton ID="DeleteItemButton" runat="server" CommandName="DeleteItem" CommandArgument='<%#Eval("BasketItemId")%>' Text="Delete" OnClientClick="return confirm('Are you sure you want to remove this item from your cart?')" CausesValidation="false" SkinID="Button"></asp:LinkButton>
                                                </asp:PlaceHolder>
                                            </div>
                                            <asp:PlaceHolder ID="PricePh" runat="server" Visible='<%#IsParentProduct(Container.DataItem) || (GetItemShopPrice((BasketItem)Container.DataItem) != 0)%>'>
                                                <span id="PriceLabel" runat="server" Visible='<%#IsParentProduct(Container.DataItem)%>' class="label priceLabel">Price:</span>
                                                <span id="NoPriceLabel" runat="server" Visible='<%#!IsParentProduct(Container.DataItem)%>'>: </span>
                                                <span class="value price"><%#GetItemShopPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%></span>
                                            </asp:PlaceHolder>
                                        </div>
                                        <asp:HiddenField  Visible="false" ID="BasketItemId" runat="server" Value='<%#Eval("BasketItemId")%>' />
                                    </ItemTemplate>
                                </asp:Repeater>
		                        <div class="subTotalsBox">
			                        <asp:Panel ID="DiscountsPanel" runat="server" CssClass="discountPanel" >
				                        <span class="label discountLabel">Discounts:</span>
				                        <span class="value discount">
				                            <asp:Literal ID="Discounts" runat="server"></asp:Literal>
    			                        </span>
			                        </asp:Panel>
			                        <div class="subTotalPanel">
				                        <span class="label subTotalLabel">Subtotal:</span>
				                        <span class="value price subTotal">
				                            <asp:Literal ID="SubTotal" runat="server"></asp:Literal>
				                        </span>
			                        </div>
		                        </div>
		                        <div class="checkoutButtonsBox">
			                        <div class="standardCheckout">
				                        <asp:Button ID="CheckoutButton" runat="server" Text="Checkout >>" OnClick="CheckoutButton_Click" CssClass="button" />
			                        </div>
			                        <div class="alternateCheckouts">
				                        <div class="amazonCheckout">
					                        <uc1:AmazonCheckoutButton ID="AmazonCheckoutButton" runat="server" />							
				                        </div>
				                        <div class="paypalExpress">
					                        <uc1:PayPalExpressCheckoutButton ID="PayPalExpressCheckoutButton" runat="server" ShowHeader="false" ShowDescription="false" PanelCSSClass="" />
				                        </div>
				                    </div>
		                        </div>
	                        </div>
                        </asp:PlaceHolder>
                        <asp:Panel ID="EmptyBasketPanel" runat="server" CssClass="noResultsPanel" Visible="false">
                            <asp:Label ID="EmptyBasketMessage" runat="Server" Text="Empty" CssClass="message"></asp:Label>
                        </asp:Panel>
                    </asp:Panel>
                </div>
            </div>
        </asp:PlaceHolder>
		<asp:PlaceHolder ID="AlternateControlPanel" runat="server">
        </asp:PlaceHolder>
    </ContentTemplate>
</asp:UpdatePanel>