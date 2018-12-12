<%@ Page Title="Checkout - Confirm and Pay" Language="C#" MasterPageFile="~/Layouts/Fixed/Checkout.master" AutoEventWireup="True" CodeFile="Payment.aspx.cs" Inherits="AbleCommerce.Checkout.PaymentPage" %>
<%@ Register Src="~/ConLib/Checkout/PaymentWidget.ascx" TagName="PaymentWidget" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/CheckoutProgress.ascx" TagName="CheckoutProgress" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/BasketTotalSummary.ascx" TagName="BasketTotalSummary" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Checkout/BillingAddress.ascx" tagname="BillingAddress" tagprefix="uc" %>
<%@ Register src="~/ConLib/Checkout/ShippingAddress.ascx" tagname="ShippingAddress" tagprefix="uc" %>
<%@ Register src="~/ConLib/Checkout/BasketNonShippableItems.ascx" tagname="BasketNonShippableItems" tagprefix="uc" %>
<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="checkoutPage"> 
    <div id="checkout_payPage" class="mainContentWrapper"> 
	    <div id="pageHeader">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Confirm and Pay"></asp:Localize></h1>
        </div>
        <asp:UpdatePanel ID="PaymentAjax" runat="server">
            <ContentTemplate>
                <div class="columnsWrapper">
                <div class="column_1 sidebarColumn">
				    <uc:BasketTotalSummary ID="BasketTotalSummary1" runat="server" />
	                <uc:BillingAddress ID="BillingAddress" runat="server" />
                </div>
                <div class="column_2 mainColumn">
                    <asp:Panel ID="TermsAndConditionsSection" runat="server" CssClass="widget termsAndConditionsWidget" visible="false">
                        <div class="innerSection">
                            <div class="header">
                                <h2><asp:Localize ID="OrderTermsCaption" runat="server" Text="Order Terms"></asp:Localize></h2>
                            </div>
                            <div class="content">
                                <asp:Localize ID="TermsAndConditionsInstructions" runat="server" Text="Please read the following conditions of ordering. To complete your order, you must agree to the terms by checking the box below."></asp:Localize>
                                <br />
                                <div class="orderTerms">
                                    <asp:Literal ID="TermsAndConditions" runat="server"></asp:Literal>
                                </div>
                                <br />
                                <asp:CheckBox ID="AcceptTC" runat="server" />
                                <asp:Label ID="AcceptTCLabel" runat="server" AssociatedControlID="AcceptTC" Text=" I have read and agree to terms and conditions of ordering." />
                                <asp:CustomValidator ID="AcceptTCValidator" runat="server" Text="*" Display="Static" 
                                    ErrorMessage="You must accept the terms and conditions." ClientValidationFunction="validateTC"
                                    OnServerValidate="ValidateTC"  SetFocusOnError="false" ValidationGroup="OPC"></asp:CustomValidator>
                            </div>
                        </div>
                    </asp:Panel>
                    <uc:PaymentWidget ID="PaymentWidget" runat="server" />
                </div>
                </div>
		        <div class="section shipmentSection">
                    <div class="content">
                        <asp:Repeater ID="ShipmentRepeater" runat="server" OnItemDataBound="ShipmentRepeater_OnItemDataBound">
                            <ItemTemplate>
                                <div class="widget shipmentWidget">
                                    <div class="header">
                                        <h2>
                                            <asp:Localize ID="Localize1" runat="server" Text="Shipment Details"></asp:Localize>
                                        </h2>
                                    </div>
                                    <div class="content">
                                        <div class="address">
                                            <uc:ShippingAddress ID="ShippingAddress" runat="server" ShipmentId='<%#Eval("Id") %>' />
                                        </div>
                                        <div class="items">
                                            <cb:ExGridView ID="ShipmentItemsGrid" runat="server" AutoGenerateColumns="false" DataSource='<%#AbleCommerce.Code.InvoiceHelper.RemoveDiscountItems(AbleCommerce.Code.BasketHelper.GetShipmentItems(Container.DataItem))%>' SkinID="ItemList">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Item">
                                                        <HeaderStyle CssClass="thumbnail" />
                                                        <ItemStyle CssClass="thumbnail" />
                                                        <ItemTemplate>
                                                            <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>'>
                                                                <asp:HyperLink ID="IconLink" runat="server" NavigateUrl='<%#Eval("Product.NavigateUrl") %>'>
                                                                    <asp:Image ID="Icon" runat="server" AlternateText='<%# Eval("Product.IconAltText") %>' ImageUrl='<%# AbleCommerce.Code.ProductHelper.GetIconUrl(Container.DataItem) %>' Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.IconUrl")) %>' EnableViewState="false" />
                                                                </asp:HyperLink>
                                                            </asp:PlaceHolder>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <HeaderStyle CssClass="item" />
                                                        <ItemStyle CssClass="item" />
                                                        <ItemTemplate>
                                                            <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="True" LinkProducts="False" IgnoreKitShipment="false" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField Visible="false" HeaderText="SKU">
                                                        <HeaderStyle CssClass="sku" />
                                                        <ItemStyle CssClass="sku" />
                                                        <ItemTemplate>
                                                            <asp:Label ID="SKU" runat="server" Text='<%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <%--<asp:TemplateField >
                                                        <HeaderStyle CssClass="tax" />
                                                        <ItemStyle CssClass="tax" />
                                                        <HeaderTemplate>
                                                            <%#GetTaxHeader()%>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#TaxHelper.GetTaxRate((BasketItem)Container.DataItem).ToString("0.####")%>%
                                                        </ItemTemplate>
                                                    </asp:TemplateField>--%>
                                                    <asp:TemplateField HeaderText="Price ex.gst">
                                                        <HeaderStyle CssClass="price" />
                                                        <ItemStyle CssClass="price" />
                                                        <ItemTemplate>
                                                            <%#AbleCommerce.Code.InvoiceHelper.GetShopPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Quantity">
                                                        <HeaderStyle CssClass="quantity" />
                                                        <ItemStyle CssClass="quantity" />
                                                        <ItemTemplate>
                                                            <asp:Label ID="Quantity" runat="server" Text='<%#Eval("Quantity")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="GST">
                                                        <HeaderStyle CssClass="price" />
                                                        <ItemStyle CssClass="price" />
                                                        <ItemTemplate>
                                                            <%#AbleCommerce.Code.InvoiceHelper.GetGSTPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Total ex.gst">
                                                        <HeaderStyle CssClass="total" />
                                                        <ItemStyle CssClass="total" />
                                                        <ItemTemplate>
                                                            <%#AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((BasketItem)Container.DataItem).LSCurrencyFormat("ulc")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </cb:ExGridView>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
				    </div>
			    </div>
                <uc:BasketNonShippableItems ID="BasketNonShippableItems1" runat="server" ShowSku="false" ShowTaxes="true" ShowPrice="true" ShowTotal="true" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>
</asp:Content>
