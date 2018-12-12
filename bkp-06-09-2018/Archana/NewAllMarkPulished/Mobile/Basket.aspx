<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="Basket.aspx.cs" Inherits="AbleCommerce.Mobile.BasketPage" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register src="~/ConLib/PayPalExpressCheckoutButton.ascx" tagname="PayPalExpressCheckoutButton" tagprefix="uc1" %>
<%@ Register src="~/ConLib/BasketShippingEstimate.ascx" tagname="BasketShippingEstimate" tagprefix="uc2" %>
<%@ Register src="~/ConLib/PopularProductsDialog.ascx" tagname="PopularProductsDialog" tagprefix="uc3" %>
<%@ Register src="~/Mobile/UserControls/StoreHeader.ascx" tagname="StoreHeader" tagprefix="uc1" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="basketPage" class="mainContentWrapper">
	<div class="header">
		<h2>Cart</h2>
	</div>
	<div class="section">
		<div class="content">
			<asp:UpdatePanel ID="BasketPanel" runat="server" UpdateMode="Conditional">
				<ContentTemplate>
					<div class="warnings">
					    <asp:Label ID="OrderBelowMinimumAmountMessage" runat="server" Text="Your order does not yet meet the minimum value of {0}.  You must increase your purchase and click Recalculate, in order to checkout." CssClass="errorCondition" Visible="false" EnableViewState="false"></asp:Label>
					    <asp:Label ID="OrderAboveMaximumAmountMessage" runat="server" Text="Your order exceeds the maximum value of {0}.  You must reduce your purchase and click Recalculate, in order to checkout." CssClass="errorCondition" Visible="false" EnableViewState="false"></asp:Label>
					    <asp:DataList ID="WarningMessageList" runat="server" EnableViewState="false" CssClass="errorCondition" >
						    <HeaderTemplate><ul></HeaderTemplate>
						    <ItemTemplate><li><%# Container.DataItem %></li></ItemTemplate>
						    <FooterTemplate></ul></FooterTemplate>
					    </asp:DataList>
					</div>
					<asp:Panel ID="BasketGridPanel" runat="server" DefaultButton="UpdateButton" CssClass="basketContainer">						
						<asp:GridView ID="BasketGrid" runat="server" AutoGenerateColumns="False" ShowFooter="True" DataKeyNames="BasketItemId" OnRowCommand="BasketGrid_RowCommand" OnDataBound="BasketGrid_DataBound" CssClass="basketItems" >
							<Columns>                                
								<asp:TemplateField>
                                    <HeaderTemplate></HeaderTemplate>
									<ItemStyle CssClass="thumbnail" />
									<ItemTemplate>
										<asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>' EnableViewState="false">
											<asp:HyperLink ID="ThumbnailLink" runat="server" NavigateUrl='<%#GetProductUrl(Container.DataItem)%>' EnableViewState="false">
												<asp:Image ID="Thumbnail" runat="server" AlternateText='<%# Eval("Product.ThumbnailAltText") %>' ImageUrl='<%# AbleCommerce.Code.ProductHelper.GetThumbnailUrl(Container.DataItem) %>' EnableViewState="false" Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' />
                                                <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible='<%#string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' EnableViewState="false" />
											</asp:HyperLink>
										</asp:PlaceHolder>
									</ItemTemplate>
                                    <FooterStyle CssClass="subtotalLabel" />
                                    <FooterTemplate>                                        
								        <asp:Label ID="SubtotalLabel" runat="server" Text="Subtotal:" CssClass="fieldHeader" EnableViewState="false"></asp:Label>
	 			    		        </FooterTemplate>
								</asp:TemplateField>
								<asp:TemplateField>
                                    <HeaderTemplate></HeaderTemplate>
									<ItemStyle CssClass="itemDetail" />
									<ItemTemplate>
										<asp:PlaceHolder ID="ProductPanel" runat="server" Visible='<%#IsProduct(Container.DataItem)%>'>
										    <uc:BasketItemDetail id="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="true" ShowSubscription="true" LinkProducts="True" />
                                            <%-- 
                                            <div class="sku">
                                               <span class="label">SKU: </span><span class="value"><%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%></span>
                                            </div>
                                            --%>
                                            <div class="price">
                                            <span class="label">Price: </span><span class="value"><%#TaxHelper.GetShopPrice(AbleContext.Current.User.Basket, (BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%></span>
                                            </div>
                                            <asp:Panel ID="TaxPanel" runat="server" Visible="false" CssClass="tax">                                                
                                                <span class="label">Tax: </span><span class="value"><%#TaxHelper.GetTaxRate((BasketItem)Container.DataItem).ToString("0.####")%>%</span>
                                            </asp:Panel>
                                            <div class="qty">
                                                <span class="label">Qty: </span>
                                                <asp:PlaceHolder ID="ProductQuantityPanel" runat="server" Visible='<%#IsParentProduct(Container.DataItem)%>'>
											        <asp:TextBox ID="Quantity" runat="server" MaxLength="5" Text='<%# Eval("Quantity") %>' Width="40px" CssClass="value"></asp:TextBox>
										        </asp:PlaceHolder>                                        
										        <asp:PlaceHolder ID="OtherQuantityPanel" runat="server" Visible='<%#!IsParentProduct(Container.DataItem)%>' EnableViewState="false">
											        <span class="value"><%#Eval("Quantity")%></span>
										        </asp:PlaceHolder>
                                            </div>                            	        
                                            <asp:Panel ID="ItemActionsPanel" runat="server" Visible='<%#IsParentProduct(Container.DataItem)%>' CssClass="rowActions">
											    <asp:LinkButton ID="DeleteItemButton" runat="server" CssClass="link button" CommandName="DeleteItem" CommandArgument='<%# Eval("BasketItemId") %>' Text="Delete" OnClientClick="return confirm('Are you sure you want to remove this item from your cart?')"></asp:LinkButton>
										    </asp:Panel>
                                        </asp:PlaceHolder>
										<asp:PlaceHolder ID="OtherPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") != OrderItemType.Product)%>' EnableViewState="false">
											<%#Eval("Name")%> (<span class="price"><%#TaxHelper.GetShopPrice(AbleContext.Current.User.Basket, (BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%></span>)
										</asp:PlaceHolder>
										<asp:Panel ID="CouponPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") == OrderItemType.Coupon)%>' EnableViewState="true">
											<asp:LinkButton ID="DeleteCouponItemButton" runat="server" CommandName="DeleteCouponItem" CommandArgument='<%# Eval("BasketItemId") %>' Text="Delete" OnClientClick="return confirm('Are you sure you want to remove this coupon from your cart?')" EnableViewState="true" CssClass="button linkButton"></asp:LinkButton>
										</asp:Panel>
									</ItemTemplate>
                                    <FooterStyle CssClass="subtotalValue" />
                                    <FooterTemplate>
                                        <asp:Label ID="Subtotal" runat="server" CssClass="price" Text='<%# GetBasketSubtotal().LSCurrencyFormat("ulc") %>' EnableViewState="false"></asp:Label>
	 			    		        </FooterTemplate>  
								</asp:TemplateField>                                                                
							</Columns>
						</asp:GridView>
						
						<asp:Panel ID="EmptyBasketPanel" runat="server" CssClass="emptyBasketPanel" EnableViewState="false">
							<asp:Label ID="EmptyBasketMessage" runat="server" Text="Your cart is empty." CssClass="message" EnableViewState="false"></asp:Label>
						</asp:Panel>

						<div class="actions">
							<span class="basket">
								<asp:Button ID="KeepShoppingButton" runat="server" OnClick="KeepShoppingButton_Click" Text="<< Keep Shopping" EnableViewState="false" CssClass="button"></asp:Button>
								<asp:Button ID="ClearBasketButton" runat="server" OnClientClick="return confirm('Are you sure you want to clear your cart?')" OnClick="ClearBasketButton_Click" Text="Clear Cart" EnableViewState="false" CssClass="button"></asp:Button>
								<asp:Button ID="UpdateButton" runat="server" OnClick="UpdateButton_Click" Text="Update" EnableViewState="false" CssClass="button"></asp:Button>
							</span>
							<span class="checkout">
								<asp:Button ID="CheckoutButton" runat="server" OnClick="CheckoutButton_Click" Text="Checkout >>" EnableViewState="false" CssClass="checkoutbutton"></asp:Button>
							</span>
                            <span class="paypalExpressCheckout">
                                <uc1:PayPalExpressCheckoutButton ID="PayPalExpressCheckoutButton1" runat="server" />
                            </span>
						</div>
					</asp:Panel>
				</ContentTemplate>
			</asp:UpdatePanel>
		</div>
	</div>
</div>
</asp:Content>
<asp:Content ID="PageHeader" runat="server" ContentPlaceHolderID="PageHeader">
    <uc1:StoreHeader ID="StoreHeader" runat="server" />
</asp:Content>