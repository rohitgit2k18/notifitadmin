<%@ Page Title="Checkout - Select Ship Method" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="True" CodeFile="ShipMethod.aspx.cs" Inherits="AbleCommerce.Mobile.Checkout.ShipMethod" %>
<%@ Register Src="~/Mobile/UserControls/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Checkout/ShippingAddress.ascx" tagname="ShippingAddress" tagprefix="uc1" %>
<%@ Register src="~/Mobile/UserControls/Checkout/BasketNonShippableItems.ascx" tagname="BasketNonShippableItems" tagprefix="uc1" %>
<%@ Register src="~/Mobile/UserControls/CheckoutNavBar.ascx" tagname="CheckoutNavBar" tagprefix="uc1" %>
<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="PageContent">
    <uc1:CheckoutNavBar ID="CheckoutNavBar" runat="server" />
    <div id="checkoutPage"> 
        <div id="checkout_shipMethodPage" class="mainContentWrapper"> 
		    <div class="pageHeader">
			    <h1><asp:Localize ID="Caption" runat="server" Text="Select Shipping Method"></asp:Localize></h1>
            </div>
		    <div class="section shipmentSection">
		        <div class="content">
                    <asp:Panel runat="server" id="MultipleShipmentsMsg" CssClass="multiShipmentMsg">
                        <span class="title">Your order contains multiple shipments</span>
                        <span class="text">Please select a shipping method for each shipment</span>
                    </asp:Panel>
                    <asp:Repeater ID="ShipmentRepeater" runat="server" OnItemDataBound="ShipmentRepeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="widget shipmentWidget">
                                <div runat="server" class="title" ><h3>Shipment #<%#(Container.ItemIndex + 1)%></h3></div>
                                <div class="itemsContainer">
                                <ul class="itemList">
                                <asp:Repeater ID="ShipmentItemsGrid" runat="server" DataSource='<%#GetShipmentItems(Container.DataItem)%>'>               
                                    <ItemTemplate>
                                        <li class="itemNode <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                                            <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="false" LinkProducts="False" IgnoreKitShipment="false" EnableFriendlyFormat="true" />
                                            <asp:PlaceHolder ID="phGiftOptions" runat="server" Visible='<%#ShowGiftOptionsLink(Container.DataItem)%>' >
                                                <div class="setGiftOptions">
                                                    <asp:HyperLink ID="GiftOptionsLink" runat="server" NavigateUrl='<%#Eval("Id", "GiftOptions.aspx?i={0}")%>' Text="Gift Options"></asp:HyperLink>
                                                </div>
                                            </asp:PlaceHolder> 
                                        </li>
                                    </ItemTemplate>                                   
                                </asp:Repeater>
                                </ul>
                                </div>
                            
                                <div class="method">
                                    <asp:RadioButtonList ID="ShipMethodsList" runat="server" DataValueField="Key" DataTextField="Value" RepeatLayout="UnorderedList" CssClass="shipMethList"></asp:RadioButtonList>
                                    <asp:PlaceHolder ID="phNoShippingMethods" runat="server" EnableViewState="false" Visible="false">
                                        <p>
                                            <asp:Localize ID="ShipMethodErrorMessage" runat="server" Visible="false" EnableViewState="false" Text="There are no shipping methods available for the specified shipping address."></asp:Localize>
                                            <asp:Localize ID="ShipMethodUPSErrorMessage" runat="server" Visible="false" EnableViewState="false" Text=" Remember that UPS cannot ship to PO boxes."></asp:Localize>
                                        </p>
                                    </asp:PlaceHolder>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
		        </div>
		    </div>
            <uc1:BasketNonShippableItems ID="BasketNonShippableItems1" runat="server" ShowSku="false" ShowTaxes="false" ShowPrice="false" ShowTotal="false" />
            <div class="widget continueCheckoutWidget">
                <div class="section">
                    <div class="content">
					    <asp:PlaceHolder ID="InvalidShipMethodPanel" runat="server" Visible="false" EnableViewState="false">
                            <p class="errorCondition">
                                <asp:Localize ID="InvalidShipMethodMessage" runat="server" Text="Invalid shipping method(s). Please make sure all shipments have ship methods selected."></asp:Localize>
                            </p>
                        </asp:PlaceHolder>
					    <asp:Button ID="ContinueButton" runat="server" Text="Continue >>" OnClick="ContinueButton_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>