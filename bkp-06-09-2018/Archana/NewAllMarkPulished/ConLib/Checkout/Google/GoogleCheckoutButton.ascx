<%@ Control Language="C#" ClassName="GoogleCheckoutButton" Inherits="AbleCommerce.ConLib.Checkout.Google.GoogleCheckoutButton" CodeFile="GoogleCheckoutButton.ascx.cs" %>
<%@ Register TagPrefix="gc1" Namespace="CommerceBuilder.Payments.Providers.GoogleCheckout.Checkout" Assembly="CommerceBuilder.GoogleCheckout" %>
<%--
<conlib>
<summary>Implements GoogleCheckout button</summary>
</conlib>
--%>
<gc1:GCheckoutButton id="GCheckoutButton" onclick="GCheckoutButton_Click" runat="server" EnableViewState="false" />
<asp:PlaceHolder ID="phWarnings" runat="server" Visible="false">
	<div class="warnings">
	<asp:DataList ID="GCWarningMessageList" runat="server" EnableViewState="false">
		<HeaderTemplate><ul></HeaderTemplate>
		<ItemTemplate>
			<li><%# Container.DataItem %></li>
		</ItemTemplate>
		<FooterTemplate></ul></FooterTemplate>
	</asp:DataList>
	</div>
</asp:PlaceHolder>
