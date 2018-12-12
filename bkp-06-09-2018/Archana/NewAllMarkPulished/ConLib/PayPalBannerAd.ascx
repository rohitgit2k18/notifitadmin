<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PayPalBannerAd.ascx.cs" Inherits="AbleCommerce.ConLib.PayPalBannerAd" %>
<%--
<conlib>
<summary>A UI control to configure and show PayPal banner ads.</summary>
<param name="PublisherId" default="">The unique PayPal publisher Id, you can get it by logging in to your PayPal account at PayPal website.</param>
<param name="BannerSize" default="170x100">Choose from the defined available sizes of banner Ads, check PayPal financing portal for more information.(https://financing.paypal.com/ppfinportal/home/index)</param>
</conlib>
--%>
<div class="widget paypalBannerAd">
	<div class="innerSection">
		<div  id="Header" runat="server" class="header">
			<h2><asp:Literal ID="Caption" runat="server" EnableViewState="False" Text="PayPal Credit&#174 ; Advertising"></asp:Literal></h2>
		</div>
        <div class="content">
            <asp:Panel ID="BannerScripts" runat="server">
                <script type="text/javascript" data-pp-pubid="<%=PublisherId%>" data-pp-placementtype="<%=BannerSize%>"> (function (d, t) {
                     "use strict";
                     var s = d.getElementsByTagName(t)[0], n = d.createElement(t);
                     n.src = "//paypal.adtag.where.com/merchant.js";
                     s.parentNode.insertBefore(n, s);
                 }(document, "script"));
                </script>
            </asp:Panel>
            <asp:Panel ID="Instructions" runat="server">
                <p>You can advertise PayPal Credit&#174; (formerly Bill Me Later) to your customers and encourage them to use this service from PayPal. For this you will need to specify the PayPal publisher Id which You can get from PayPal website.</p>
                <p>Once you have your publisher Id, use it to configure this control from layout administration and pass the publisher Id as a parameter.</p>
            </asp:Panel>
        </div>
	</div>
</div>