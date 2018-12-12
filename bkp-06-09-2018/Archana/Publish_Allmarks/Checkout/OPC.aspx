<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Fixed/OPC.Master" AutoEventWireup="true" CodeFile="OPC.aspx.cs" Inherits="AbleCommerce.Checkout.OPC" %>
<%@ Register src="~/ConLib/Checkout/BasketDetails.ascx" tagname="BasketDetails" tagprefix="uc1" %>
<%@ Register src="~/ConLib/Checkout/AddressDetails.ascx" tagname="AddressDetails" tagprefix="uc2" %>
<%@ Register Src="~/ConLib/Checkout/PaymentWidget.ascx" TagName="PaymentWidget" TagPrefix="uc" %>

<asp:Content ID="ContentPageLeftSidebar" runat="server" contentplaceholderid="LeftSidebar">
    <script language="javascript" type="text/javascript">
        Page_ClientValidate();
    </script>  
    <div ID="PageOverlay" runat="server" visible="false" class="opcOverlay"></div>    
    <div id="billingAddr" class="widget billingAddressWidget aboveOpcOverlay">
        <div class="innerSection">
		    <div class="header">
			    <h2>Billing Information</h2>
		    </div>
		    <div class="content">                
                <asp:PlaceHolder ID="LoginPanel" runat="server" EnableViewState="False" Visible="false">
                    <p class="LoginMessage">
                    If you have previously created an account, you can <asp:HyperLink ID="LoginLink" runat="server" Text="log in" EnableViewState="false" CssClass="button" ></asp:HyperLink> to retrieve your saved addresses.
                    </p>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="EmailRegisteredPanel" runat="server" EnableViewState="False" Visible="false">
                    <p class="requiredField">
                        This email address is already associated with an existing user account. Please <asp:HyperLink ID="LoginLink2" runat="server" Text="sign in" EnableViewState="false" CssClass="button" ></asp:HyperLink> or use the 'Forgot User Name or Password' feature if you need to retrieve your login information, or use a different email address to place order.
                    </p>
                </asp:PlaceHolder>
                <uc2:AddressDetails ID="BillingAddress" runat="server" CollectEmail="True" ValidationGroupName="Billing" />
                <div runat="server" ID="BillingAddressTextPanel">
                    <div class="addressText">
                        <asp:Literal runat="server" ID="FormattedBillingAddress"></asp:Literal>
                    </div>
                    <div class="addressLink">
                        <asp:LinkButton ID="EditBillAddress" runat="server" Text="Edit" OnClick="EditBillAddress_Click" CssClass="button" ValidationGroup="None"></asp:LinkButton>
                    </div>
                </div>
				<p>
                    <asp:CheckBox ID="UseBillingAsShippingAddress" runat="server" Text="This is also my delivery address"
                        Checked="True" OnCheckedChanged="UseBillingAsShippingAddress_CheckedChanged" CssClass="fieldHeader"
                        AutoPostBack="true" />
				</p> 
            </div>
        </div>
    </div>
    <asp:Panel ID="ShippingAddressPanel" CssClass="widget shippingAddressWidget aboveOpcOverlay" runat="server" Visible="false">
        <div class="innerSection">
		    <div class="header">
			    <h2>Shipping Information</h2>
		    </div>
		    <div class="content">
                <div class="opcInputForm">
                <table>
                     <tr runat="server" ID="ShippingAddressTextPanel">
                        <td>
                        <div class="addressText">
                        <asp:Literal runat="server" ID="FormattedShippingAddress"></asp:Literal>
                        </div>
                        <div class="addressLink">
                        <asp:LinkButton ID="EditShipAddress" runat="server" Text="Edit" OnClick="EditShipAddress_Click" CssClass="button" ValidationGroup="None"></asp:LinkButton>
                        </div>
                        </td>
                    </tr>
                    <tr id="trUseExistingAddress" runat="server" visible="false">
                        <td>
                            <asp:RadioButton ID="UseExistingAddress" runat="server" Text="I want to use an existing address" Checked="true" GroupName="ShippingAddresses" AutoPostBack="true" OnCheckedChanged="UseExistingAddress_CheckedChanged" />
                        </td>
                    </tr>
                    <tr id="trAddressList" runat="server" visible="false">
                        <td>
                            <asp:ListBox ID="AddressList" runat="server" CssClass="large" AutoPostBack="true" OnSelectedIndexChanged="AddressList_SelectedIndexChanged"></asp:ListBox>
                        </td>
                    </tr>
                    <tr id="trNewAddress" runat="server" visible="false">
                        <td>
                            <asp:RadioButton ID="UseNewAddress" runat="server" Text="I want to use a new address" GroupName="ShippingAddresses" AutoPostBack="true" OnCheckedChanged="UseNewAddress_CheckedChanged" />
                        </td>
                    </tr>
                    <tr id="trShippingAddress" runat="server" visible="false">
                        <td>
                            <uc2:AddressDetails ID="ShippingAddress" runat="server" ValidationGroupName="Shipping" />
                        </td>
                    </tr>
                </table>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="ShipMultiPanel" runat='server' CssClass="widget multipleShipmentsOPC" EnableViewState="false">
        <div class="innerSection">
            <div class="header">
                <h2>Multiple Destinations?</h2>
            </div>
            <div class="content">
                <p>Click below to send your items to more than one location.</p>
                <div align="center">
                    <asp:Button ID="MultipleShipmentsButton" runat="server" Text="Multiple Destinations" OnClick="MultipleShipmentsButton_Click" EnableViewState="false" CausesValidation="false" />
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="EmailListsPanel" runat="server" CssClass="widget emailListsOPC">
        <div class="innerSection">
            <div class="header">
                <h2>Email Lists</h2>
            </div>
            <div class="content">
                <asp:ListView ID="EmailLists" runat="server">
                    <ItemTemplate>
                        <div class="emailList">
                            <asp:CheckBox ID="Selected" runat="server" Checked="<%#IsEmailListChecked(Container.DataItem)%>" EnableViewState="false" /><%#Eval("Name")%>
                            <asp:PlaceHolder ID="EmailListDescriptionPH" runat="server" Visible='<%#HasDescription(Container.DataItem) %>'>
                                <p><%#Eval("Description")%></p>
                            </asp:PlaceHolder>
                        </div>
                    </ItemTemplate>
                </asp:ListView>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="checkout_onePage" class="mainContentWrapper opcOverlayWrapper">    
        <asp:Panel ID="DelieveryMethodsPanel" runat="server" CssClass="widget delieveryMethodWidget">
            <div class="innerSection">
		        <div class="header">
			        <h2>Select Shipping Method</h2>
		        </div>
		        <div class="content">
                    <asp:PlaceHolder ID="ShippingMethods" runat="server">
                        <table class="inputForm">
                        <asp:Repeater runat="server" ID="ShipmentsRepeater">
                        <ItemTemplate>
                            <tr>
                                <th class="rowHeader">
                                    <span class="label">Shipment #:<%# Container.ItemIndex + 1 %></span></th>
                                <td>
                                    <asp:DropDownList ID="ShipMethodsList" runat="server" DataSource='<%#GetShipMethods(Container.DataItem)%>' DataValueField="Value" ShipmentId='<%#GetShipmentId(Container.DataItem)%>' OnDataBound="ShipMethods_Databound"
                                        DataTextField="Text" Width="300px" onselectedindexchanged="ShipMethodsList_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="ShipMethodRequired" runat="server" ControlToValidate="ShipMethodsList" Text="You must select a delivery method." ErrorMessage="*"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                        </ItemTemplate>
                        </asp:Repeater>
                           <tr id="DeliveryInstructionsForm" runat="server" visible="false">
                                <th valign="top" class="rowHeader">
                                    <span class="label">Delivery Instructions?</span>
                                </th>
                                <td>
                                    <asp:TextBox ID="Comments" runat="server" TextMode="MultiLine" Width="300" MaxLength="255" Height="50" onKeyUp="javascript:Check(this, 255);"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="NoShippingMethods" runat="server" Visible="false">
                        <p>No shipping methods available for specified shipping address.</p>
                    </asp:PlaceHolder>
                    <div class="clear"></div>
                </div>
            </div>
        </asp:Panel>
        <div class="clear"></div>
        <div class="widget confirmOrderWidget">
            <div class="innerSection">
		        <div class="header">
			        <h2>Confirm Order</h2>
		        </div>
		        <div class="content">
                    <uc1:BasketDetails ID="BasketDetails1" runat="server" />
                </div>
            </div>
        </div>        
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
        <asp:HiddenField ID="VS_CustomState" runat="server" EnableViewState="false" />
        <asp:Panel ID="CheckoutMessagePanel" runat="server" CssClass="widget checkoutMessageWidget" EnableViewState="false" Visible="false">
            <div class="innerSection">
                <div class="header"><h2>Checkout Message</h2></div>
                <div class="content">
                    <asp:Label Id="CheckoutMessage" runat="server" Text="" CssClass="checkoutErrorMessage" />
                    <asp:Localize ID="RefreshRatesMessage" runat="server" Text="<br /><br />If any or all of the shipping methods are missing, there may have been a problem communicating with the shipper.  <a href='../basket.aspx'>Click here</a> to restart the checkout."></asp:Localize>
                </div>
            </div>
        </asp:Panel>
        <uc:PaymentWidget ID="PaymentWidget" runat="server" />
    </div>
    <script type="text/javascript">
        function Check(textBox, maxLength) {
            if (textBox.value.length > maxLength) {
                alert("Please enter a maximum of " + maxLength + " characters.");
                textBox.value = textBox.value.substr(0, maxLength);
            }
        }
</script>
</asp:Content>
