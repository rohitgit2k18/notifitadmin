﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="MyOrder.aspx.cs" Inherits="AbleCommerce.Mobile.Members.MyOrder" %>
<%@ Register Src="~/Mobile/UserControls/Account/OrderSummary.ascx" TagName="OrderSummary" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Account/BillingAddress.ascx" TagName="BillingAddress" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Account/OrderTotalSummary.ascx" TagName="OrderTotalSummary" TagPrefix="uc" %>
<%@ Register src="~/Mobile/UserControls/Account/OrderPayments.ascx" tagname="OrderPayments" tagprefix="uc" %>
<%@ Register src="~/Mobile/UserControls/Account/OrderShipments.ascx" tagname="OrderShipments" tagprefix="uc" %>
<%@ Register src="~/Mobile/UserControls/Account/OrderNonShippableItems.ascx" tagname="OrderNonShippableItems" tagprefix="uc" %>
<%@ Register src="~/Mobile/UserControls/Account/OrderDigitalGoods.ascx" tagname="OrderDigitalGoods" tagprefix="uc" %>
<%@ Register src="~/Mobile/UserControls/Account/OrderGiftCertificates.ascx" tagname="OrderGiftCertificates" tagprefix="uc" %>
<%@ Register src="~/Mobile/UserControls/Account/OrderSubscriptions.ascx" tagname="OrderSubscriptions" tagprefix="uc" %>
<%@ Register src="~/Mobile/UserControls/Account/OrderNotes.ascx" tagname="OrderNotes" tagprefix="uc" %>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="server">
<div id="checkoutPage"> 
    <div id="checkout_receiptPage" class="mainContentWrapper">	
		<div class="pageHeader">
			<h1><asp:Localize ID="Caption" runat="server" Text="Order #{0}"></asp:Localize></h1>
		</div>
        <uc:OrderSummary ID="OrderSummary" runat="server" />
        <uc:OrderTotalSummary ID="OrderTotalSummary" runat="server" />
        
        <div class="clear"></div>

		<asp:PlaceHolder ID="BalanceDuePanel" runat="server" Visible="false">
			<div class="section balanceDueSection">
				<div class="content">
					<asp:Label ID="BalanceDueMessage" runat="server" Text="** Your order has a balance of {0} due.&nbsp&nbsp;<a href='{1}'><u>Pay Now</u></a>" CssClass="errorCondition"></asp:Label>
				</div>
			</div>
		</asp:PlaceHolder>

		<asp:PlaceHolder ID="OrderInvalidPanel" runat="server" Visible="false">
			<div class="section orderInvalidSection">
				<div class="content">        
				    <asp:Label ID="OrderInvalidMessage" runat="server" Text="** Your order has been cancelled or invalidated." CssClass="errorCondition"></asp:Label>
				</div>
			</div>
		</asp:PlaceHolder>

        <uc:OrderPayments ID="OrderPayments" runat="server" />        
        <uc:BillingAddress ID="BillingAddress" runat="server" />
	    <uc:OrderShipments ID="OrderShipments" runat="server" />
        <uc:OrderNonShippableItems ID="OrderNonShippableItems" runat="server" />
	    <uc:OrderDigitalGoods ID="OrderDigitalGoods" runat="server" />
        <uc:OrderGiftCertificates ID="OrderGiftCertificates" runat="server" />
        <uc:OrderSubscriptions ID="OrderSubscriptions" runat="server" />
	    <uc:OrderNotes ID="OrderNotes" runat="server" />
        <div class="section repeatOrder">
            <div class="header">
                <h2>Repeat Order</h2>
            </div>
            <div class="content">
                <p>Click below to repeat this order.</p>
                <asp:HyperLink ID="ReorderButton" runat="server" Text="Repeat Order" CssClass="button hyperLinkButton" />
            </div>
        </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageHeader"></asp:Content>