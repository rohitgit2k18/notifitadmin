<%@ Control Language="C#" AutoEventWireup="True" CodeFile="MailPaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.MailPaymentForm" ViewStateMode="Disabled" %>
<div class="inputForm">
    <div class="field">
        <span class="fieldValue">
		    <p><asp:Localize ID="MailHelpText" runat="server" Text="Click below to submit a request to pay by mail.  You can then print the invoice and send it in with your payment."></asp:Localize></p>
        </span>
    </div>
    <div class="buttons">
        <asp:Button ID="MailButton" runat="server" Text="Pay by {0}" OnClick="MailButton_Click" ValidationGroup="MailPayment" />
    </div>
</div>