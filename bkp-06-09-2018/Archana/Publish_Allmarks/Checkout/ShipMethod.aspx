<%@ Page Title="Checkout - Select Ship Method" Language="C#" MasterPageFile="~/Layouts/Fixed/Checkout.master" AutoEventWireup="True" CodeFile="ShipMethod.aspx.cs" Inherits="AbleCommerce.Checkout.ShipMethod" %>
<%@ Register Src="~/ConLib/CheckoutProgress.ascx" TagName="CheckoutProgress" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/BasketTotalSummary.ascx" TagName="BasketTotalSummary" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Checkout/BillingAddress.ascx" tagname="BillingAddress" tagprefix="uc1" %>
<%@ Register src="~/ConLib/Checkout/ShippingAddress.ascx" tagname="ShippingAddress" tagprefix="uc1" %>
<%@ Register src="~/ConLib/Checkout/BasketNonShippableItems.ascx" tagname="BasketNonShippableItems" tagprefix="uc1" %>
<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="checkoutPage"> 
    <div id="checkout_shipMethodPage" class="mainContentWrapper"> 
        <div id="pageHeader">
			<h1><asp:Localize ID="Caption" runat="server" Text="Select Shipping Method"></asp:Localize></h1>
        </div>
        <div class="columnsWrapper">
		<div class="column_1 thirdsColumn">
	        <uc1:BillingAddress ID="BillingAddress" runat="server" />
        </div>
        <div class="column_2 thirdsColumn">
            <asp:UpdatePanel ID="BasketTotalsAjax" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
			        <uc:BasketTotalSummary ID="BasketTotalSummary1" runat="server" ShowEditLink="false"/>
                </ContentTemplate>
            </asp:UpdatePanel>
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
						        <asp:Localize ID="ContinueInstructions" runat="server" Text="Confirm you have selected a shipping method for each shipment in your order before you continue."></asp:Localize>
						    </p>
                            <asp:PlaceHolder ID="InvalidShipMethodPanel" runat="server" Visible="false" EnableViewState="false">
                                <p class="errorCondition">
                                    <asp:Localize ID="InvalidShipMethodMessage" runat="server" Text="Invalid shipping method. Either you have not selected a shipping method or the selected method is not valid."></asp:Localize>
                                </p>
                            </asp:PlaceHolder>
					    </div>
                        <div>                    
                            <asp:Button ID="ContinueButton" runat="server" Text="Continue >>" OnClick="ContinueButton_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </div>
        <div class="clear"></div>
		<div class="section shipmentSection">
		    <div class="content">
                <asp:Repeater ID="ShipmentRepeater" runat="server" OnItemDataBound="ShipmentRepeater_ItemDataBound">
                    <ItemTemplate>
                        <div class="widget shipmentWidget">
                            <div class="header">
                                <h2>
                                    <asp:Localize ID="ShipmentCaption" runat="server" Text="Shipment Details"></asp:Localize>
                                </h2>
                            </div>
                            <div class="content">
                                <div class="address">
                                    <uc1:ShippingAddress ID="ShippingAddress" runat="server" ShipmentId='<%#Eval("Id") %>' />
                                </div>
                                <div class="items">
                                    <cb:ExGridView ID="ShipmentItemsGrid" runat="server" AutoGenerateColumns="false" DataSource='<%#AbleCommerce.Code.InvoiceHelper.RemoveDiscountItems(GetShipmentItems(Container.DataItem))%>' SkinID="ItemList">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Item">
                                                <HeaderStyle CssClass="thumbnail" />
                                                <ItemStyle CssClass="thumbnail" />
                                                <ItemTemplate>
                                                    <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>' EnableViewState="false">
                                                        <asp:HyperLink ID="IconLink" runat="server" NavigateUrl='<%#Eval("Product.NavigateUrl") %>' EnableViewState="false">
                                                            <asp:Image ID="Icon" runat="server" AlternateText='<%# Eval("Product.IconAltText") %>' ImageUrl='<%# AbleCommerce.Code.ProductHelper.GetIconUrl(Container.DataItem) %>' Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.IconUrl")) %>' EnableViewState="false" />
                                                        </asp:HyperLink>
                                                    </asp:PlaceHolder>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <HeaderStyle CssClass="item" />
                                                <ItemStyle CssClass="item" />
                                                <ItemTemplate>
                                                    <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="false" LinkProducts="False" IgnoreKitShipment="false" />
                                                    <asp:PlaceHolder ID="phGiftOptions" runat="server" Visible='<%#ShowGiftOptionsLink(Container.DataItem)%>' >
                                                        <div class="setGiftOptions">
                                                            <asp:HyperLink ID="GiftOptionsLink" runat="server" NavigateUrl='<%#Eval("Id", "GiftOptions.aspx?i={0}")%>' Text="Gift Options"></asp:HyperLink>
                                                        </div>
                                                    </asp:PlaceHolder> 
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Quantity">
                                                <HeaderStyle CssClass="quantity" />
                                                <ItemStyle CssClass="quantity" />
                                                <ItemTemplate  >
                                                    <asp:Label ID="Quantity" runat="server" Text='<%#Eval("Quantity")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </cb:ExGridView>
                                </div>
                                <div class="method">
                                    <h5><asp:Localize ID="ShippingMethodCaption" runat="server" Text="Select Shipping Method"></asp:Localize></h5>
                                    <asp:UpdatePanel ID="ShipMethodsAjax" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="ShipMethodsList" runat="server" DataValueField="Key" DataTextField="Value" AutoPostBack="true"></asp:DropDownList>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <asp:PlaceHolder ID="phNoShippingMethods" runat="server" EnableViewState="false" Visible="false">
                                        <p>
                                            <asp:Localize ID="ShipMethodErrorMessage" runat="server" Visible="false" EnableViewState="false" Text="There are no shipping methods available for the specified shipping address."></asp:Localize>
                                            <asp:Localize ID="ShipMethodUPSErrorMessage" runat="server" Visible="false" EnableViewState="false" Text=" Remember that UPS cannot ship to PO boxes."></asp:Localize>
                                        </p>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder ID="PHShipMessage" runat="server" Visible="false">
                                    <p>
                                        <asp:Label ID="ShipMessageLabel" runat="server" Text="Delivery Instructions?" SkinID="FieldHeader"></asp:Label>&nbsp;
                                        <asp:TextBox ID="ShipMessage" runat="server" Text="" MaxLength="255" Width="250" TextMode="MultiLine" onKeyUp="javascript:Check(this, 255);"></asp:TextBox>
                                    </p>
                                    </asp:PlaceHolder>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
		    </div>
		</div>
        <uc1:BasketNonShippableItems ID="BasketNonShippableItems1" runat="server" ShowSku="false" ShowTaxes="false" ShowPrice="false" ShowTotal="false" />
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $(".billingAddressWidget,.basketTotalSummaryWidget,.continueCheckoutWidget").equalHeights();
    });

    function Check(textBox, maxLength) {
        if (textBox.value.length > maxLength) {
            alert("Please enter a maximum of " + maxLength + " characters.");
            textBox.value = textBox.value.substr(0, maxLength);
        }
    }
</script>
</asp:Content>