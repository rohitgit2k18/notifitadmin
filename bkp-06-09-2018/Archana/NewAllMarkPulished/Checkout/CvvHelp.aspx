<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CvvHelp.aspx.cs" Inherits="AbleCommerce.Checkout.CvvHelp" Theme="" EnableTheming="false" %>
<div class="hoverPanel cvvHelpHoverPanel">
    <div class="header">
        <h2>Locating your Card Verification Code</h2>
    </div>
    <div class="content">
        <div class="helpSection generalHelp">
            <h3>Discover, Visa, or MasterCard</h3>
            <p>
                Your card security code for your MasterCard, Visa or Discover 
                card is a three-digit number on the back of your credit card, 
                immediately following your main card number typically to the 
                right of the signature strip.
            </p>
            <div class="cvvVisa"></div>
        </div>
        <asp:Panel ID="AmexPanel" runat="server" CssClass="helpSection amexHelp">
            <h3>American Express</h3>
            <p>
                The card security code for your American Express card is a 
                four-digit number located on the front of your credit card, 
                to the right or left above your main credit card number.
            </p>
            <div class="cvvAmex"></div>
        </asp:Panel>
        <div class="clear"></div>
    </div>
</div>