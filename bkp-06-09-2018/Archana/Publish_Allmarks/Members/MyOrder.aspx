<%@ Page Title="View Order" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MyOrder.aspx.cs" Inherits="AbleCommerce.Members.MyOrder" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Account/OrderSummary.ascx" TagName="OrderSummary" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Account/BillingAddress.ascx" TagName="BillingAddress" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Account/OrderTotalSummary.ascx" TagName="OrderTotalSummary" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderPayments.ascx" tagname="OrderPayments" tagprefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderShipments.ascx" tagname="OrderShipments" tagprefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderNonShippableItems.ascx" tagname="OrderNonShippableItems" tagprefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderDigitalGoods.ascx" tagname="OrderDigitalGoods" tagprefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderGiftCertificates.ascx" tagname="OrderGiftCertificates" tagprefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderSubscriptions.ascx" tagname="OrderSubscriptions" tagprefix="uc" %>
<%@ Register src="~/ConLib/Account/OrderNotes.ascx" tagname="OrderNotes" tagprefix="uc" %>
<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="checkoutPage"> 
    <div id="checkout_receiptPage" class="mainContentWrapper">	
		<div id="pageHeader">
			<h1><asp:Localize ID="Caption" runat="server" Text="Order #{0}"></asp:Localize></h1>
            <div class="links">
                <asp:HyperLink ID="ReorderButton" runat="server" Text="Reorder" CssClass="button hyperLinkButton" />
                <asp:HyperLink ID="PrintButton" runat="server" Text="Print" CssClass="button hyperLinkButton" NavigateUrl="javascript:window.print()" />
            </div>
		</div>
        <div class="columnsWrapper">
         <div class="column_1 thirdsColumn">
	        <uc:BillingAddress ID="BillingAddress" runat="server" />
        </div>
        <div class="column_2 thirdsColumn">
			<uc:OrderSummary ID="OrderSummary" runat="server" />
        </div>
        <div class="column_3 thirdsColumn">
			<uc:OrderTotalSummary ID="OrderTotalSummary" runat="server" />
        </div>
        </div>
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
	    <uc:OrderShipments ID="OrderShipments" runat="server" />
        <uc:OrderNonShippableItems ID="OrderNonShippableItems" runat="server" />
	    <uc:OrderDigitalGoods ID="OrderDigitalGoods" runat="server" />
        <uc:OrderGiftCertificates ID="OrderGiftCertificates" runat="server" />
        <uc:OrderSubscriptions ID="OrderSubscriptions" runat="server" />
	    <uc:OrderNotes ID="OrderNotes" runat="server" />
    </div>
</div>
</asp:Content>