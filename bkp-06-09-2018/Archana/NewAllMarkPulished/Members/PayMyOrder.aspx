<%@ Page Title="Make Payment" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.master" AutoEventWireup="true" CodeFile="PayMyOrder.aspx.cs" Inherits="AbleCommerce.Members.PayMyOrder" %>
<%@ Register Src="~/ConLib/Account/OrderSummary.ascx" TagName="OrderSummary" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Account/BillingAddress.ascx" TagName="BillingAddress" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Account/OrderTotalSummary.ascx" TagName="OrderTotalSummary" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentWidget.ascx" TagName="PaymentWidget" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderPayments.ascx" tagname="OrderPayments" tagprefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderShipments.ascx" tagname="OrderShipments" tagprefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderNonShippableItems.ascx" tagname="OrderNonShippableItems" tagprefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" runat="server">
<div id="checkoutPage"> 
    <div id="checkout_payPage" class="mainContentWrapper"> 
	    <div id="pageHeader">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Make Payment for Order #{0}"></asp:Localize></h1>
        </div>
        <asp:UpdatePanel ID="PaymentAjax" runat="server">
            <ContentTemplate>
                <div class="columnsWrapper">
                <div class="column_1 mainColumn">
                    <asp:PlaceHolder ID="TooManyTriesPanel" runat="server" Visible="False">
                        <asp:Label ID="TooManyTriesMessage" runat="server" SkinID="ErrorCondition" Text="There have been too many failed payment attempts.  Contact us for assistance to place your order."></asp:Label>
                    </asp:PlaceHolder>
                    <asp:Panel ID="PaymentFailedPanel" runat="server" Visible="false" EnableViewState="false" CssClass="checkoutAlert">
                        <p>Oops! We could not process your last payment. The bank said: <asp:Literal ID="PaymentFailedReason" runat="server" EnableViewState="false"></asp:Literal></p>
                        <p>Your order has been placed but it will not be processed until payment is completed.</p>
                    </asp:Panel>
                    <uc:PaymentWidget ID="PaymentWidget" runat="server" />
                </div>
                <div class="column_2 sidebarColumn">
                    <uc:BillingAddress ID="BillingAddress" runat="server" ShowEditLink="true"/>
				    <uc:OrderTotalSummary ID="OrderTotalSummary" runat="server" />
                </div>
                </div>
                <div class="clear"></div>
                <uc:OrderPayments ID="OrderPayments" runat="server" />
	            <uc:OrderShipments ID="OrderShipments" runat="server" />
                <uc:OrderNonShippableItems ID="OrderNonShippableItems" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>
</asp:Content>