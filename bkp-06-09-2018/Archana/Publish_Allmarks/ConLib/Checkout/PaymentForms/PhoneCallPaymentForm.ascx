<%@ Control Language="C#" AutoEventWireup="True" CodeFile="PhoneCallPaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.PhoneCallPaymentForm" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Payment form for phone call type payment</summary>
<param name="ValidationGroup" default="PhoneCall">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr>
        <td>
    	    <p>
                <asp:Localize ID="PhoneCallHelpText" runat="server" Text="Click below if you wish to provide your payment information over the phone."></asp:Localize>
            </p>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Button ID="PhoneCallButton" runat="server" Text="Pay by {0}" OnClick="PhoneCallButton_Click" ValidationGroup="PhoneCall" />
        </td>
    </tr>
</table>