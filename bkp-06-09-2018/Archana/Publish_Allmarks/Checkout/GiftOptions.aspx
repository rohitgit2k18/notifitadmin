<%@ Page Title="Checkout - Select Gift Options" Language="C#" MasterPageFile="~/Layouts/Fixed/Checkout.master" AutoEventWireup="True" CodeFile="GiftOptions.aspx.cs" Inherits="AbleCommerce.Checkout.GiftOptions" %>
<%@ Register Src="~/ConLib/Checkout/BasketTotalSummary.ascx" TagName="BasketTotalSummary" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/GiftWrapChoices.ascx" TagName="GiftWrapChoices" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Checkout/ShippingAddress.ascx" tagname="ShippingAddress" tagprefix="uc1" %>
<%@ Register src="~/ConLib/Checkout/BillingAddress.ascx" tagname="BillingAddress" tagprefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="checkoutPage"> 
    <div id="checkout_giftOptionsPage" class="mainContentWrapper"> 
	    <div id="pageHeader">
			<h1>Choose Gift Options</h1>
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
                        <h2><asp:Localize ID="ContinueCaption" runat="server" Text="Continue Checkout"></asp:Localize></h2>
                    </div>
                    <div class="content">
					    <div class="info">
						    <p class="instruction">
						        <asp:Localize ID="ContinueInstructions" runat="server" Text="Select the gift options for the item and then press continue to finish choosing your shipping methods."></asp:Localize>
						    </p>
					    </div>
                        <div class="actions">                    
                            <asp:Button ID="ContinueButton" runat="server" Text="Continue" onclick="ContinueButton_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </div>
        <div class="clear"></div>
        <div class="widget shipmentWidget">
            <div class="header">
                <h2>
                    <asp:Localize ID="ItemListCaption" runat="server" Text="Gift Options For:"></asp:Localize>
                </h2>
            </div>
            <div class="content">
                <div class="address">
                    <uc1:ShippingAddress ID="ShippingAddress" runat="server" />
                </div>
                <div class="items">
                    <cb:ExGridView ID="GiftItemsGrid" runat="server" AutoGenerateColumns="false" SkinID="ItemList">
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