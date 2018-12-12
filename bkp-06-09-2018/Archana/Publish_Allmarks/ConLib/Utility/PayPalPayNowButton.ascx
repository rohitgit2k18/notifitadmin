<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Utility.PayPalPayNowButton" EnableViewState="false" CodeFile="PayPalPayNowButton.ascx.cs" %>
<%-- 
<conlib>
<summary>Builds the paypal PayNow button</summary>
<param name="AutoClick" default="True">Indicates wheather to auto click the pay now button if page view is with in the 10 secs of order palcement, and redirect to Paypal website .</param>
</conlib>
--%>
<asp:PlaceHolder ID="phPayNow" runat="server"></asp:PlaceHolder>