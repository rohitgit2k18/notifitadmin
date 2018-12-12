<%@ Control Language="C#" AutoEventWireup="True" CodeFile="PayPalPaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.PayPalPaymentForm" ViewStateMode="Disabled" %>
<div class="inputForm">
    <div class="field">        
    	<p>
            <asp:Localize ID="PayPalHelpText" runat="server" Text="Click below to submit a payment with PayPal.  When you see the order receipt, click on the PayPal Pay Now button to continue to the PayPal site and pay the order balance."></asp:Localize>
        </p>        
    </div>
    <div class="buttons">
        <asp:ImageButton ID="PayPalButton" runat="server" OnClick="PayPalButton_Click" ValidationGroup="PayPalPayment" />
    </div>
</div>