<%@ Page Title="My Cart" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="True" CodeFile="Basket.aspx.cs" Inherits="AbleCommerce.BasketPage" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/AmazonCheckoutDialog.ascx" TagName="AmazonCheckoutDialog" TagPrefix="uc" %>
<%@ Register src="~/ConLib/PayPalExpressCheckoutButton.ascx" tagname="PayPalExpressCheckoutButton" tagprefix="uc1" %>
<%@ Register src="~/ConLib/BasketShippingEstimate.ascx" tagname="BasketShippingEstimate" tagprefix="uc2" %>
<%@ Register src="~/ConLib/PopularProductsDialog.ascx" tagname="PopularProductsDialog" tagprefix="uc3" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="basketPage" class="mainContentWrapper">
	<div class="pageHeader">
		<h1>MY BASKET</h1>
	</div>
	<div class="section">
		<div class="content">
			<asp:UpdatePanel ID="BasketPanel" runat="server" UpdateMode="Always">
				<ContentTemplate>
					<div class="warnings">
					    <asp:Repeater ID="OrderVolumeAmountMessageList" runat="server" EnableViewState="false">
                            <HeaderTemplate><ul></HeaderTemplate>
						    <ItemTemplate><li class="errorCondition"><%# Container.DataItem %></li></ItemTemplate>
					    </asp:Repeater>
                        <asp:Repeater ID="WarningMessageList" runat="server" EnableViewState="false">
						    <HeaderTemplate><ul></HeaderTemplate>
						    <ItemTemplate><li class="errorCondition"><%# Container.DataItem %></li></ItemTemplate>
					    </asp:Repeater>
					</div>
					<asp:Panel ID="BasketGridPanel" runat="server" DefaultButton="UpdateButton" CssClass="basketContainer">
						<div class="basketItems">
						    <cb:ExGridView ID="BasketGrid" runat="server" AutoGenerateColumns="False" ShowFooter="True" DataKeyNames="BasketItemId" OnRowCommand="BasketGrid_RowCommand" OnDataBound="BasketGrid_DataBound" OnRowDataBound="BasketGrid_RowDataBound" SkinID="Basket" FixedColIndexes="0,6,7">
							    <Columns>
								    <asp:TemplateField HeaderText="CART ITEMS">
									    <HeaderStyle CssClass="thumbnail" />
									    <ItemStyle CssClass="thumbnail" />
									    <ItemTemplate>
										    <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>' EnableViewState="false">
											    <asp:HyperLink ID="ThumbnailLink" runat="server" NavigateUrl='<%#GetProductUrl(Container.DataItem)%>' EnableViewState="false">
												    <asp:Image ID="Thumbnail" runat="server" AlternateText='<%# Eval("Product.ThumbnailAltText") %>' ImageUrl='<%#AbleCommerce.Code.ProductHelper.GetThumbnailUrl(Container.DataItem)%>' EnableViewState="false" Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' />
                                                    <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible='<%#string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' EnableViewState="false" />
											    </asp:HyperLink>
										    </asp:PlaceHolder>
									    </ItemTemplate>
								    </asp:TemplateField>
								    <asp:TemplateField>
									    <HeaderStyle CssClass="item" />
									    <ItemStyle CssClass="item" />
									    <ItemTemplate>
										    <asp:PlaceHolder ID="ProductPanel" runat="server" Visible='<%#IsProduct(Container.DataItem)%>'>
											    <uc:BasketItemDetail id="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="true" ShowSubscription="true" LinkProducts="True" />
										    </asp:PlaceHolder>
                                            <%-- <asp:Panel ID="ItemDatePanel" runat="server" Visible='<%#IsParentProduct(Container.DataItem)%>' CssClass="itemDate">
                                                <%#Eval("CreatedDate", "Item Added on {0:d}")%>
                                            </asp:Panel>--%>
                                            <asp:Panel ID="ItemActionsPanel" runat="server" Visible='<%#IsParentProduct(Container.DataItem)%>' CssClass="itemActions">
											   <%-- <asp:LinkButton ID="SaveItemButton" runat="server" CssClass="link" CommandName="SaveItem" CommandArgument='<%# Eval("BasketItemId") %>' Text="Move to wishlist" Visible='<%#AbleContext.Current.Store.Settings.WishlistsEnabled %>'></asp:LinkButton>--%>
											    <asp:LinkButton ID="DeleteItemButton" runat="server" CssClass="button remove-btn" CommandName="DeleteItem" CommandArgument='<%# Eval("BasketItemId") %>' Text="x" OnClientClick="return confirm('Are you sure you want to remove this item from your cart?')"></asp:LinkButton>
										    </asp:Panel>
										    <asp:PlaceHolder ID="OtherPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") != OrderItemType.Product)%>' EnableViewState="false">
											    <%#Eval("Name")%>
										    </asp:PlaceHolder>
										    <asp:PlaceHolder ID="CouponPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") == OrderItemType.Coupon)%>' EnableViewState="true">
											    <br/>
											    <asp:LinkButton ID="DeleteCouponItemButton" runat="server" CommandName="DeleteCoupon" CommandArgument='<%# Eval("Sku") %>' Text="delete" OnClientClick="return confirm('Are you sure you want to remove this coupon from your cart?')" EnableViewState="true" CssClass="link"></asp:LinkButton>
										    </asp:PlaceHolder>
									    </ItemTemplate>
								    </asp:TemplateField>
								    <asp:TemplateField Visible="false" HeaderText="SKU">
									    <HeaderStyle CssClass="sku" />
									    <ItemStyle CssClass="sku" />
									    <ItemTemplate>
										    <%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%>
									    </ItemTemplate>
								    </asp:TemplateField>
								    <asp:TemplateField Visible="false" HeaderText="TAX">
									    <HeaderStyle CssClass="tax" />
									    <ItemStyle CssClass="tax" />
									    <ItemStyle HorizontalAlign="Center" Width="40px" />
									    <ItemTemplate>
										    <%#TaxHelper.GetTaxRate((BasketItem)Container.DataItem) > 0 ? TaxHelper.GetTaxRate((BasketItem)Container.DataItem).ToString("0.####") : ""%>
									    </ItemTemplate>
								    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="QTY">
									    <HeaderStyle CssClass="quantity" />
									    <ItemStyle CssClass="quantity" />
									    <ItemTemplate>
										    <asp:PlaceHolder ID="ProductQuantityPanel" runat="server" Visible='<%#IsParentProduct(Container.DataItem)%>'>
											    <asp:TextBox ID="Quantity" runat="server" MaxLength="5" Text='<%# Eval("Quantity") %>' Width="50px"></asp:TextBox>
										    </asp:PlaceHolder>
										    <asp:PlaceHolder ID="OtherQuantityPanel" runat="server" Visible='<%#!IsParentProduct(Container.DataItem)%>' EnableViewState="false">
											    <%#Eval("Quantity")%>
										    </asp:PlaceHolder>							
									    </ItemTemplate>
								    </asp:TemplateField>
								    <asp:TemplateField HeaderText="ITEM PRICE ex.gst">
									    <HeaderStyle CssClass="price" />
									    <ItemStyle CssClass="price" />
									    <ItemTemplate>
                                             <%#AbleCommerce.Code.InvoiceHelper.GetGSTPrice((BasketItem)Container.DataItem) > 0 ? AbleCommerce.Code.InvoiceHelper.GetShopPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc") : ""%>
									    </ItemTemplate>
								    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="GST">
									    <HeaderStyle CssClass="price" />
									    <ItemStyle CssClass="price" />
									    <ItemTemplate>
										    <%#AbleCommerce.Code.InvoiceHelper.GetGSTPrice((BasketItem)Container.DataItem) > 0 ? AbleCommerce.Code.InvoiceHelper.GetGSTPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc") : ""%>
									    </ItemTemplate>
                                        <FooterStyle CssClass="footerSubtotalLabel" />
 									    <FooterTemplate>
                                            <div><asp:Label ID="SubtotalLabel" runat="server" Text="Subtotal:" CssClass="fieldHeader small-total" EnableViewState="false"></asp:Label></div>
                                            <div><asp:Label ID="GstTotalLabel" runat="server" Text="GST:" CssClass="fieldHeader small-total" EnableViewState="false"></asp:Label></div>
                                            <div><asp:Label ID="GrandTotalLabel" runat="server" Text="Total:" CssClass="fieldHeader" EnableViewState="false"></asp:Label></div>
 									    </FooterTemplate>
								    </asp:TemplateField>
								    <asp:TemplateField HeaderText="ITEM TOTAL ex.gst">
									    <HeaderStyle CssClass="total" />
									    <ItemStyle CssClass="total" />
									    <ItemTemplate>
										    <%#AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((BasketItem)Container.DataItem) > 0 ? AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc") : ""%>
									    </ItemTemplate>
                                        <FooterStyle CssClass="footerSubtotal" />
 									    <FooterTemplate>
                                            <div><asp:Label ID="Subtotal" runat="server" Text='<%# GetBasketSubtotal().LSCurrencyFormat("ulc") %>' CssClass="fieldHeader small-total" EnableViewState="false"></asp:Label></div>
                                            <div><asp:Label ID="GstTotal" runat="server" Text='<%# GetBasketGSTtotal().LSCurrencyFormat("ulc") %>' CssClass="fieldHeader small-total" EnableViewState="false"></asp:Label></div>
                                            <div><asp:Label ID="Grandtotal" runat="server" Text='<%# GetBasketGrandtotal().LSCurrencyFormat("ulc") %>' CssClass="fieldHeader" EnableViewState="false"></asp:Label></div>
 									    </FooterTemplate>
								    </asp:TemplateField>
							    </Columns>
						    </cb:ExGridView>
                            <%--<table class="pagedList default footable-loaded footable">
                                <tfoot>
                                    <tr class="footable-disabled">
                                        <td class="footerSubtotalLabel footable-visible">
                                            <div><asp:Label ID="SubtotalLabel" runat="server" Text="Subtotal Total:" CssClass="fieldHeader small-total" EnableViewState="false"></asp:Label></div>
                                            <div><asp:Label ID="GstTotalLabel" runat="server" Text="GST:" CssClass="fieldHeader small-total" EnableViewState="false"></asp:Label></div>
                                            <div><asp:Label ID="GrandTotalLabel" runat="server" Text="Grand Total:" CssClass="fieldHeader" EnableViewState="false"></asp:Label></div>
									    </td>
                                        <td class="footerSubtotal footable-visible footable-last-column">
                                            <ItemTemplate><div><asp:Label ID="Subtotal" runat="server" Text='<%# GetBasketSubtotal().LSCurrencyFormat("ulc") %>' CssClass="fieldHeader small-total" EnableViewState="false"></asp:Label></div></ItemTemplate>
                                            <ItemTemplate><div><asp:Label ID="GstTotal" runat="server" Text='<%# GetBasketGSTtotal().LSCurrencyFormat("ulc") %>' CssClass="fieldHeader small-total" EnableViewState="false"></asp:Label></div></ItemTemplate>
                                            <ItemTemplate><div><asp:Label ID="Grandtotal" runat="server" Text='<%# GetBasketGrandtotal().LSCurrencyFormat("ulc") %>' CssClass="fieldHeader" EnableViewState="false"></asp:Label></div></ItemTemplate>
									    </td>
                                    </tr>
                                </tfoot>
                            </table>--%>
						</div>
						<asp:Panel ID="EmptyBasketPanel" runat="server" CssClass="emptyBasketPanel" EnableViewState="false">
							<asp:Label ID="EmptyBasketMessage" runat="server" Text="Your cart is empty." CssClass="message" EnableViewState="false"></asp:Label>
						</asp:Panel>
						<div class="actions">
							<span class="basket">
                                <div class="clear-btn btn-wrapper">
                                    <asp:Button ID="ClearBasketButton" runat="server" OnClientClick="return confirm('Are you sure you want to clear your cart?')" Text="Clear Cart" OnClick="ClearBasketButton_Click" EnableViewState="false" CssClass="button"></asp:Button>
                                </div>
                                <div class="btn-wrapper">
                                    <asp:Button ID="KeepShoppingButton" runat="server" OnClick="KeepShoppingButton_Click" Text="KEEP BROWSING" EnableViewState="false" CssClass="button"></asp:Button>
                                </div>
                                <div class="btn-wrapper">
                                    <asp:Button ID="UpdateButton" runat="server" OnClick="UpdateButton_Click" Text="UPDATE" EnableViewState="false" CssClass="button"></asp:Button>
                                </div>
							</span>
							<span class="checkout">
                                <% if (showQuoteButton) { %>
                                <a href="/Quote.aspx" class="btn btn-default">GET QUOTE</a>
                                <% } else { %>
                                <asp:Button ID="CheckoutButton" runat="server" OnClick="CheckoutButton_Click" Text="PROCEED TO CHECKOUT" EnableViewState="false" CssClass="checkoutbutton"></asp:Button>
                                <% } %>
							</span>
						</div>
					</asp:Panel>
				</ContentTemplate>
			</asp:UpdatePanel>
		</div>
        <% if (!showQuoteButton) { %>
        <div runat="server">
            <script type="text/javascript">
                //File Upload response from the server
                Dropzone.options.dropzoneForm = {
                    maxFiles: null,
                    maxFilesize: 9, // MB
                    url: "Basket.aspx",
                    init: function () {
                        this.on("maxfilesexceeded", function (data) {
                            var res = eval('(' + data.xhr.responseText + ')');
                        });
                        this.on("addedfile", function (file) {
                            // Create the remove button
                            var removeButton = Dropzone.createElement("<button>Remove file</button>");
                            // Capture the Dropzone instance as closure.
                            var _this = this;
                            // Listen to the click event
                            removeButton.addEventListener("click", function (e) {
                                // Make sure the button click doesn't submit the form:
                                e.preventDefault();
                                e.stopPropagation();
                                // Remove the file preview.
                                _this.removeFile(file);
                                // If you want to the delete the file on the server as well,
                                // you can do the AJAX request here.
                                $.ajax({
                                    type: "POST",
                                    url: "Basket.aspx/RemoveFile",
                                    data: JSON.stringify({ 'name': file.name }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (msg) {
                                    }
                                });
                            });
                            // Add the button to the file preview element.
                            file.previewElement.appendChild(removeButton);
                        });
                    }
                };
   
            </script>
            Max Fileupload size: 9mb
            <div class="dropzone" id="dropzoneForm">
                <div class="fallback" runat="server">
                    <input name="file" type="file" multiple />
                    <input type="submit" value="Upload" />
                </div>
            </div>
        </div>
        <% } %>
	</div>
</div>
</asp:Content>
<%--<asp:Content ID="Content1" runat="server" contentplaceholderid="RightSidebar">
    <asp:UpdatePanel ID="ShippingEstimateUpdatePanel" runat="server" UpdateMode="Conditional">
	  <ContentTemplate>
         <uc:AmazonCheckoutDialog ID="AmazonCheckoutDialog1" runat="server" />
         <uc1:PayPalExpressCheckoutButton ID="PayPalExpressCheckoutButton1" runat="server" />
         <uc2:BasketShippingEstimate ID="BasketShippingEstimate1" runat="server" />
         <uc3:PopularProductsDialog ID="PopularProductsDialog1" runat="server" />
      </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>--%>