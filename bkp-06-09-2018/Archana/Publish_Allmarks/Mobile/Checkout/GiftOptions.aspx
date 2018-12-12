<%@ Page Title="Checkout - Select Gift Options" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="True" CodeFile="GiftOptions.aspx.cs" Inherits="AbleCommerce.Mobile.Checkout.GiftOptions" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/BasketTotalSummary.ascx" TagName="BasketTotalSummary" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/GiftWrapChoices.ascx" TagName="GiftWrapChoices" TagPrefix="uc" %>
<%@ Register src="~/Mobile/UserControls/CheckoutNavBar.ascx" tagname="CheckoutNavBar" tagprefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="checkoutPage"> 
    <uc1:CheckoutNavBar ID="CheckoutNavBar" runat="server" />
    <div id="checkout_giftOptionsPage" class="mainContentWrapper"> 
	    <div class="pageHeader">
			<h1>Choose Gift Options</h1>
        </div>
        <div class="column_3 thirdsColumn">
            <div class="widget continueCheckoutWidget">
                <div class="section">
                    <div class="header">
                        <h2><asp:Localize ID="ContinueCaption" runat="server" Text="Continue Checkout"></asp:Localize></h2>
                    </div>
                    <div class="content">
					    <p class="instruction">
						    <asp:Localize ID="ContinueInstructions" runat="server" Text="Select the gift options for the item and then press continue to finish choosing your shipping methods."></asp:Localize>
						</p>
					    <asp:Button ID="ContinueButton" runat="server" Text="Continue" onclick="ContinueButton_Click" />
                    </div>
                </div>
            </div>
        </div>
        <div class="clear"></div>
        <div class="section">
            <div class="header">
                <h2><asp:Localize ID="ItemListCaption" runat="server" Text="Gift Options For:"></asp:Localize></h2>
            </div>
            <div class="content">
                <div class="address">
                    <asp:Literal ID="ShippingAddress" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
        <div class="items">
            <asp:GridView ID="GiftItemsGrid" runat="server" AutoGenerateColumns="false" SkinID="ItemList">
                <Columns>
                    <asp:TemplateField>
                        <HeaderStyle CssClass="item" />
                        <ItemStyle CssClass="item" />
                        <ItemTemplate>
                            <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("BasketItem.Id")%>' ShowAssets="false" LinkProducts="False" IgnoreKitShipment="false" />
                            <uc:GiftWrapChoices ID="GiftWrapChoices" runat="server" BasketItemId='<%#Eval("BasketItem.Id")%>' GiftMessage='<%#Eval("GiftMessage")%>' WrapStyleId='<%#Eval("WrapStyleId")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Quantity">
                        <HeaderStyle CssClass="quantity" />
                        <ItemStyle CssClass="quantity" />
                        <ItemTemplate>
                            1
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $(".billingAddressWidget,.basketTotalSummaryWidget,.continueCheckoutWidget").equalHeights();
    });
</script>
</asp:Content>