<%@ Page Language="C#" MasterPageFile="~/Layouts/Mobile.master" Inherits="AbleCommerce.Mobile.PayPalExpressCheckout" title="PayPal Express Checkout" EnableViewState="False" CodeFile="PayPalExpressCheckout.aspx.cs" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="paypalExpCheckoutPage" class="mainContentWrapper">
	<div class="section">
		<div class="pageHeader">
			<h1>PayPal Express Checkout Failure</h1>
		</div>
		<div class="content">
			<div class="errors">
				<asp:BulletedList ID="ErrorList" runat="server"></asp:BulletedList>
			</div>
			<div class="actions">
				<asp:HyperLink ID="RetryLink" runat="server" Text="Retry PayPal Request" NavigateUrl="PayPalExpressCheckout.aspx?action=RETRY" CssClass="button hyperLinkButton"></asp:HyperLink>&nbsp;
				<asp:HyperLink ID="CancelLink" runat="server" Text="Cancel Use of PayPal" NavigateUrl="PayPalExpressCheckout.aspx?action=CANCEL" CssClass="button hyperLinkButton"></asp:HyperLink>
				<asp:HyperLink ID="BasketLink" runat="server" Text="View Cart" NavigateUrl="PayPalExpressCheckout.aspx?action=CANCEL" CssClass="button hyperLinkButton" Visible="false"></asp:HyperLink>
			</div>
		</div>
	</div>
</div>
</asp:Content>
