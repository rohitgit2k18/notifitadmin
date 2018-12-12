<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Account.OrderItemDetail" CodeFile="OrderItemDetail.ascx.cs" ViewStateMode="Disabled" %>
<%-- 
<conlib>
<summary>Displays details of an order item</summary>
<param name="LinkProducts" default="False">If true listed products are hyperlinked to their pages</param>
<param name="ShowShipTo" default="False">If true ship-to address is shown</param>
<param name="ShowAssets" default="False">If true associated assets are shown</param>
</conlib>
--%>
<div class="orderItemDetail">
	<asp:HyperLink ID="ProductLink" runat="Server" NavigateUrl="" />
	<asp:Localize ID="ProductName" runat="server" Text="" />
	<asp:Localize ID="KitMemberLabel" runat="Server" Text="<br />in {0}" Visible="false"></asp:Localize>
    <asp:ListView ID="InputList" runat="server">
        <LayoutTemplate>
            <ul class="inputList">
                <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
            </ul>
        </LayoutTemplate>
        <ItemTemplate>
            <li>
			    <span class="label"><%#Eval("Name")%>:</span>
			    <span class="value"><%#Eval("InputValue")%></span>
            </li>
        </ItemTemplate>
    </asp:ListView>
	<asp:PlaceHolder ID="KitProductPanel" runat="server" Visible="false">
		<ul class="BasketSubItemLabel">
		    <asp:Repeater ID="KitProductRepeater" runat="server">
			    <ItemTemplate>
				    <li ><asp:Literal ID="KitProductLabel" runat="server" Text='<%#Eval("Name")%>' /></li>
			    </ItemTemplate>
		    </asp:Repeater>
		</ul>
	</asp:PlaceHolder>
	<asp:Label ID="WishlistLabel" runat="Server" Text="<br/>from {0}&#39;s Wish List" CssClass="noteText"></asp:Label>
	<asp:Panel ID="ShipsToPanel" runat="server">
		<br />
		<asp:Label ID="ShipsToLabel" Runat="server" Text="Shipping to:" CssClass="fieldheader"></asp:Label>
		<asp:Label ID="ShipsTo" Runat="server" Text="" CssClass="noteText"></asp:Label>
	</asp:Panel>
	<asp:Panel ID="GiftWrapPanel" runat="server">
		<br />
		<asp:Label ID="GiftWrapLabel" Runat="server" Text="Gift Wrap:" CssClass="fieldheader"></asp:Label>
		<asp:Label ID="GiftWrap" Runat="server" Text="" CssClass="noteText"></asp:Label>
		<asp:Label ID="GiftWrapPrice" Runat="server" Text="" ></asp:Label>
	</asp:Panel>
	<asp:Panel ID="GiftMessagePanel" runat="server">
		<br />
		<asp:Label ID="GiftMessageLabel" Runat="server" Text="Gift Message:" CssClass="fieldheader"></asp:Label>
		<asp:Label ID="GiftMessage" Runat="server" Text="" CssClass="noteText"></asp:Label>
	</asp:Panel>
    <asp:PlaceHolder ID="SubscriptionPanel" runat="server" Visible="false">
        <br />
        <asp:Literal ID="RecurringPaymentMessage" runat="server"></asp:Literal><br />
    </asp:PlaceHolder>
	<asp:Panel ID="AssetsPanel" runat="server">
		<ul>
		<asp:Repeater ID="AssetLinkList" runat="server">
			<ItemTemplate>
				<li><asp:HyperLink ID="AssetLink" runat="server" NavigateUrl='<%#Eval("NavigateUrl")%>' Text='<%#Eval("Text")%>'></asp:HyperLink></li>
			</ItemTemplate>
		</asp:Repeater>
		</ul>
	</asp:Panel>
</div>