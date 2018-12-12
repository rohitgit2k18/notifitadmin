<%@ Control Language="C#" AutoEventWireup="True" CodeFile="PhoneCallPaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.PhoneCallPaymentForm" ViewStateMode="Disabled" %>
<div class="inputForm">
    <div class="field">
    	<p>
            <asp:Localize ID="PhoneCallHelpText" runat="server" Text="Click below to submit your payment by phone."></asp:Localize>
        </p>
    </div>
    <div class="buttons">
        <asp:Button ID="PhoneCallButton" runat="server" Text="Pay by {0}" OnClick="PhoneCallButton_Click" ValidationGroup="PhoneCall" />
    </div>
</div>
