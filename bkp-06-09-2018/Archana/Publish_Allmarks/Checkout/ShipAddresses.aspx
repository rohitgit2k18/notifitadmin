<%@ Page Title="Checkout - Multiple Shipping Addresses" Language="C#" MasterPageFile="~/Layouts/Fixed/Checkout.Master" AutoEventWireup="True" CodeFile="ShipAddresses.aspx.cs" Inherits="AbleCommerce.Checkout.ShipAddresses" %>
<%@ Register Src="~/ConLib/Checkout/BasketTotalSummary.ascx" TagName="BasketTotalSummary" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Checkout/BillingAddress.ascx" tagname="BillingAddress" tagprefix="uc1" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="PageContent">
<script language="javascript" type="text/javascript">
    $(document).ready(function () {
        $('.shippingAddressChoices select').change(function () {
            if ($(this).val() == "-1") {
                window.location = '<%=ShipAddressPageUrl %>';
            }
        });
    });
</script>
<div id="checkoutPage"> 
    <div id="checkout_shipMultiPage" class="mainContentWrapper">
	    <div id="pageHeader">
			<h1><asp:Localize ID="Caption" runat="server" Text="Select Shipping Addresses"></asp:Localize></h1>
        </div>
        <div class="columnsWrapper">
        <div class="column_1 thirdsColumn">
	        <uc1:BillingAddress ID="BillingAddress" runat="server" />
        </div>
        <div class="column_2 thirdsColumn">
			<uc:BasketTotalSummary ID="BasketTotalSummary1" runat="server" ShowEditLink="false"/>
        </div>
        <div class="column_3 thirdsColumn">
            <div class="widget continueCheckoutWidget">
                <div class="innerSection">
                    <div class="header">
                        <h2><asp:Localize ID="ContinueCaption" runat="server" Text="Select Shipping Addresses"></asp:Localize></h2>
                    </div>
                    <div class="content">
					    <div class="info">
						    <p class="instruction">
						        <asp:Localize ID="ContinueInstructions" runat="server" Text="Confirm you have selected a shipping address for each item in your order."></asp:Localize>
						    </p>
                            <asp:PlaceHolder ID="InvalidShipMethodPanel" runat="server" Visible="false" EnableViewState="false">
                                <p class="errorCondition">
                                    <asp:Localize ID="InvalidShipMethodMessage" runat="server" Text="Invalid shipping method. Either you have not selected a shipping method or the selected method is not valid."></asp:Localize>
                                </p>
                            </asp:PlaceHolder>
					    </div>
                        <div class="actions">   
                            <asp:HyperLink ID="NewAddressLink" runat="server" CssClass="button" Text="+ New Address" NavigateUrl="~/Checkout/ShipAddress.aspx"></asp:HyperLink>                 
                            <asp:Button ID="Button1" runat="server" Text="Continue >>" OnClick="ContinueButton_Click" CssClass="button" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </div>
        <div class="clear"></div>
        <div class="widget">
            <div class="innerSection">
                <div class="header">
                    <h2><asp:Localize ID="OrderItemsCaption" runat="server" Text="Items to Ship"></asp:Localize></h2>
                </div>
                <div class="content">
				    <cb:ExGridView ID="BasketGrid" runat="server" AutoGenerateColumns="False"
					    ShowFooter="false" DataKeyNames="BasketItemId" SkinID="ItemList" FixedColIndexes="0,6">
                        <Columns>
                            <asp:TemplateField HeaderText="Item">
                                <HeaderStyle CssClass="thumbnail" />
                                <ItemStyle CssClass="thumbnail" />
                                <ItemTemplate>
                                    <asp:PlaceHolder ID="ProductImagePanel" runat="server" EnableViewState="false">
                                        <asp:Image ID="Icon" runat="server" AlternateText='<%# Eval("IconAltText") %>' ImageUrl='<%# AbleCommerce.Code.ProductHelper.GetIconUrl(Eval("BasketItem")) %>' Visible='<%#!string.IsNullOrEmpty((string)Eval("IconUrl")) %>' EnableViewState="false" />
                                    </asp:PlaceHolder>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderStyle CssClass="item" />
                                <ItemStyle CssClass="item" />
                                <ItemTemplate>
                                    <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("BasketItem.Id")%>' ShowAssets="True" LinkProducts="False" IgnoreKitShipment="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="SKU">
                                <HeaderStyle CssClass="sku" />
                                <ItemStyle CssClass="sku" />
                                <ItemTemplate>
                                    <asp:Label ID="SKU" runat="server" Text='<%#AbleCommerce.Code.ProductHelper.GetSKU(Eval("BasketItem"))%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderStyle CssClass="tax" />
                                <ItemStyle CssClass="tax" />
                                <HeaderTemplate>
                                    Tax
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#TaxHelper.GetTaxRate((BasketItem)Eval("BasketItem")).ToString("0.####")%>%
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Price">
                                <HeaderStyle CssClass="price" />
                                <ItemStyle CssClass="price" />
                                <ItemTemplate>
                                    <%#TaxHelper.GetInvoicePrice(AbleContext.Current.User.Basket, (BasketItem)Eval("BasketItem")).LSCurrencyFormat("ulc")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Quantity">
                                <HeaderStyle CssClass="quantity" />
                                <ItemStyle CssClass="quantity" />
                                <ItemTemplate>
                                    1
                                </ItemTemplate>
                            </asp:TemplateField>
							<asp:TemplateField HeaderText="Select Shipping Address">
                                <HeaderStyle CssClass="shipTo" />
                                <ItemStyle CssClass="shipTo" />
								<ItemTemplate>
									<div class="shippingAddressChoices"><asp:DropDownList ID="ShippingAddress" runat="server"></asp:DropDownList></div>
								</ItemTemplate>
							</asp:TemplateField>
                        </Columns>
				    </cb:ExGridView>
                </div>
            </div>
		</div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $(".billingAddressWidget,.basketTotalSummaryWidget,.continueCheckoutWidget").equalHeights();
    });
</script>
</asp:Content>