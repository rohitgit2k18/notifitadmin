<%@ Control Language="C#" AutoEventWireup="True" CodeFile="PayPalPaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.PayPalPaymentForm" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Payment form for a paypal payment</summary>
<param name="ValidationGroup" default="PayPalPayment">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr>
        <td>
    	    <p>
                <asp:Localize ID="PayPalHelpText" runat="server" Text="Click below to submit a payment with PayPal.  When you see the order receipt, click on the PayPal Pay Now button to continue to the PayPal site and pay the order balance."></asp:Localize>
            </p>
        </td>
    </tr>
    <tr>
        <td>
            <asp:ImageButton ID="PayPalButton" runat="server" OnClick="PayPalButton_Click" ValidationGroup="PayPalPayment" />
        </td>
    </tr>
</table>