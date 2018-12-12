<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Utility.MiniBasketItemDetail" EnableViewState="false" CodeFile="MiniBasketItemDetail.ascx.cs" %>
<%-- 
<conlib>
<summary>Displays details of a basket item in mini-basket display</summary>
<param name="LinkProducts" default="False">If true displayed products will be hyperlinked to their pages</param>
<param name="ShowShipTo" default="False">If true ship-to information is displayed</param>
<param name="ShowAssets" default="False">If true product assets are displayed</param>
<param name="ShowSubscription" default="False">If true subscription details are displayed</param>
</conlib>
--%>
<div class="miniBasketItemDetail">
	<div class="title">
		<asp:PlaceHolder ID="phProductName" runat="server"></asp:PlaceHolder>
	</div>
	<asp:DataList ID="InputList" runat="server" CssClass="subTitle">
		<HeaderTemplate><br /></HeaderTemplate>
		<ItemTemplate>
			<div>
			<asp:Label ID="InputName" Runat="server" Text='<%#Eval("InputField.Name", "{0}:")%>' CssClass="fieldHeader"> </asp:Label>
			<asp:Label ID="InputValue" Runat="server" Text='<%#Eval("InputValue")%>' CssClass="fieldValue" ></asp:Label>
			</div>
		</ItemTemplate>
	</asp:DataList>
	<asp:PlaceHolder ID="KitProductPanel" runat="server">
		<ul class="subTitle">
		<asp:Repeater ID="KitProductRepeater" runat="server">
			<ItemTemplate>
				<li ><asp:Label ID="KitProductLabel" runat="server" Text='<%#Eval("Name")%>' /></li>
			</ItemTemplate>
		</asp:Repeater>
		</ul>
	</asp:PlaceHolder>
	<asp:Literal ID="WishlistLabel" runat="Server" Text="from {0}&#39;s Wish List<br />"></asp:Literal>
	<asp:PlaceHolder ID="SubscriptionPanel" runat="server">
		<div class="subscriptions">		
		<asp:Label ID="RecuringPaymentMessage" runat="server" Text="This item includes a recurring payment." CssClass="lineBlock"></asp:Label>
		<asp:Label ID="InitialPayment" runat="server" Text="Initial Payment: {0}" CssClass="lineBlock"></asp:Label>
		<asp:Label ID="RecurringPayment" runat="server" Text="Recurring Payment: {0} payments of {1}, every {2}." CssClass="lineBlock"></asp:Label>
		</div>
	</asp:PlaceHolder>
	<asp:PlaceHolder ID="AssetsPanel" runat="server">
		<ul class="subTitle">
		<asp:Repeater ID="AssetLinkList" runat="server">
			<ItemTemplate>
				<li><a href="<%#Eval("NavigateUrl")%>"><%#Eval("Text")%></a></li>
			</ItemTemplate>
		</asp:Repeater>
		</ul>
	</asp:PlaceHolder>
</div>
