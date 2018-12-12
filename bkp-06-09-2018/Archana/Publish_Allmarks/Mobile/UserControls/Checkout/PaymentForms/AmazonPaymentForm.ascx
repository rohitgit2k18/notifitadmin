<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AmazonPaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.AmazonPaymentForm" %>
<p><asp:Localize ID="AmazonHelpText" runat="server" Text="To pay with amazon, click the button below to submit your order.  When you see the order receipt, click on the Pay Now with Amazon button to submit your payment."></asp:Localize></p>
<asp:Button ID="AmazonButton" runat="server" Text="Place Order" OnClick="AmazonButton_Click" />
        