<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AmazonPaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.AmazonPaymentForm" %>
<%--
<conlib>
<summary>Payment form for Amazon Payment</summary>
<param name="ValidationGroup" default="Amazon">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr>
        <td>
    	    <p>
                <asp:Localize ID="AmazonHelpText" runat="server" Text="To pay with amazon, click the button below to submit your order.  When you see the order receipt, click on the Pay Now with Amazon button to submit your payment."></asp:Localize>
            </p>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Button ID="AmazonButton" runat="server" Text="Place Order" OnClick="AmazonButton_Click" />
        </td>
    </tr>
</table>