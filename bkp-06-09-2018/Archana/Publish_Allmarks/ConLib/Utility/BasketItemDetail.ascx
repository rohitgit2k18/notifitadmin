<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Utility.BasketItemDetail" EnableViewState="false" CodeFile="BasketItemDetail.ascx.cs" %>
<%--
<conlib>
<summary>Displays details of a basket item</summary>
<param name="LinkProducts" default="False">If true displayed products are hyperlinked to their pages</param>
<param name="ShowShipTo" default="False">If true ship-to information is shown</param>
<param name="ShowAssets" default="False">If true the assets associated with the product are shown</param>
<param name="ShowSubscription" default="True">If true subscription details are shown</param>
<param name="ForceKitDisplay" default="False">If true a bundled display will be enforced</param>
<param name="IgnoreKitShipment" default="True">If true kit items will be treated separately irrespective of the shipment</param>
</conlib>
--%>
<div class="itemDetail basketItemDetail">
    <asp:PlaceHolder ID="phProductName" runat="server"></asp:PlaceHolder>
    <asp:Localize ID="KitMemberLabel" runat="Server" Text="<br />in {0}" Visible="false"></asp:Localize>
    <asp:ListView ID="InputList" runat="server">
        <LayoutTemplate>
            <ul class="inputList">
                <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
            </ul>
        </LayoutTemplate>
        <ItemTemplate>
            <li>
                <span class="label"><%#Eval("InputField.Name", "{0}")%>:</span>
			    <span class="value"><%#Eval("InputValue")%></span>
            </li>
        </ItemTemplate>
    </asp:ListView>
    <asp:PlaceHolder ID="KitProductPanel" runat="server" Visible="false">
        <ul class="kitInputList">
        <asp:Repeater ID="KitProductRepeater" runat="server">
            <ItemTemplate>
                <li ><asp:Literal ID="KitProductLabel" runat="server" Text='<%#Eval("Name")%>' /></li>
            </ItemTemplate>
        </asp:Repeater>
        </ul>
    </asp:PlaceHolder>
    <asp:Literal ID="WishlistLabel" runat="Server" Text="<br />from {0}&#39;s Wish List"></asp:Literal>
    <asp:PlaceHolder ID="ShipsToPanel" runat="server">
        <br />
        <b><asp:Literal ID="ShipsToLiteral" Runat="server" Text="Shipping to:"></asp:Literal></b>
        <asp:Literal ID="ShipsTo" Runat="server" Text=""></asp:Literal>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="GiftWrapPanel" runat="server">
        <br /><b><asp:Literal ID="GiftWrapLiteral" Runat="server" Text="Gift Wrap:"></asp:Literal></b>
        <asp:Literal ID="GiftWrap" Runat="server" Text=""></asp:Literal>
        <asp:Label ID="GiftWrapPrice" Runat="server" Text=""></asp:Label>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="GiftMessagePanel" runat="server">
        <br /><b><asp:Literal ID="GiftMessageLiteral" Runat="server" Text="Gift Message:"></asp:Literal></b>
        <asp:Literal ID="GiftMessage" Runat="server" Text=""></asp:Literal>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="SubscriptionPanel" runat="server" Visible="false">
        <br />
        <asp:Literal ID="RecurringPaymentMessage" runat="server"></asp:Literal><br />
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="AssetsPanel" runat="server">
        <ul class="assetList">
        <asp:Repeater ID="AssetLinkList" runat="server">
            <ItemTemplate>
                <li ><a href="<%#Eval("NavigateUrl")%>"><%#Eval("Text")%></a></li>
            </ItemTemplate>
        </asp:Repeater>
        </ul>
    </asp:PlaceHolder>
</div>