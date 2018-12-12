<%@ Page Title="Checkout - Confirm and Pay" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="True" CodeFile="Payment.aspx.cs" Inherits="AbleCommerce.Mobile.Checkout.PaymentPage" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentWidget.ascx" TagName="PaymentWidget" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/BasketTotalSummary.ascx" TagName="BasketTotalSummary" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register src="~/Mobile/UserControls/Checkout/BasketNonShippableItems.ascx" tagname="BasketNonShippableItems" tagprefix="uc" %>
<%@ Register src="~/Mobile/UserControls/CheckoutNavBar.ascx" tagname="CheckoutNavBar" tagprefix="uc1" %>
<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="PageContent">
    <script language="javascript" type="text/javascript">
        function validateTC(source, args) {
            args.IsValid = document.getElementById('<%= AcceptTC.ClientID%>').checked;
        }
    </script>
    <uc1:CheckoutNavBar ID="CheckoutNavBar" runat="server" />
    <div id="checkoutPage">
    <div id="checkout_paymentPage" class="mainContentWrapper">
    <div class="section">
       <div class="pageHeader">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Confirm and Pay"></asp:Localize></h1>
        </div>
        <div class="header">
            <h2>Billing Address</h2>
        </div>
        <div class="content">
            <asp:Literal runat="server" ID="BillingAddress"></asp:Literal>
        </div>
        <asp:PlaceHolder runat="server" ID="ShippingAddressPanel">
        <div class="header">
            <h2>Shipping Address</h2>
        </div>
        <div class="content">
            <asp:Literal runat="server" ID="ShippingAddress"></asp:Literal>
        </div>
        </asp:PlaceHolder>

        <div class="header">
            <h2>Order Contents</h2>
        </div>
        <div class="content">
            <asp:Repeater ID="OrderItemsRepeater" runat="server">
                <HeaderTemplate>
                    <ul class="itemList">
                </HeaderTemplate>
                <ItemTemplate>
                    <li class="itemNode <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                        <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="True" LinkProducts="False" IgnoreKitShipment="false" />
                    </li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
             </asp:Repeater>
        </div>

        <div class="header">
            <h2>Order Total</h2>
        </div>
        <div class="content">
            <uc:BasketTotalSummary ID="BasketTotalSummary1" runat="server" showHeader="false" />
        </div>
        <hr />
        <div class="content">
            <h2 style="text-align:center">Make your payment(s) to complete the order</h2>
        </div>        
        <asp:UpdatePanel ID="PaymentAjax" runat="server">
            <ContentTemplate>
                <asp:Panel ID="TermsAndConditionsSection" runat="server" CssClass="widget termsAndConditionsWidget" visible="false">
                    <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="OrderTermsCaption" runat="server" Text="Order Terms"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p>
                            <asp:CheckBox ID="AcceptTC" runat="server" />
                            <asp:Label ID="AcceptTCLabel" runat="server" AssociatedControlID="AcceptTC" Text=" I have read and agree to terms and conditions of ordering." />
                            <asp:HyperLink ID="TermsAndConditionLink" runat="server" EnableViewState="false" Text="view the Terms and Conditions" NavigateUrl="TermsAndConditions.aspx" CssClass="linked"></asp:HyperLink>
                            <asp:CustomValidator ID="AcceptTCValidator" runat="server" Text="*" Display="Static" 
                                ErrorMessage="You must accept the terms and conditions." ClientValidationFunction="validateTC"
                                OnServerValidate="ValidateTC"  SetFocusOnError="false" ValidationGroup="OPC" CssClass="error"></asp:CustomValidator>
                            </p>
                        </div>
                    </div>
                </asp:Panel>
                <uc:PaymentWidget ID="PaymentWidget" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>

    </div>
    </div>
    </div>
</asp:Content>
