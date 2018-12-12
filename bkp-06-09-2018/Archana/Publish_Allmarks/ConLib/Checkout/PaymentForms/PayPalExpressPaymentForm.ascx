<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PayPalExpressPaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.PayPalExpressPaymentForm" %>
<%--
<conlib>
<summary>Payment form for paypay express checkout payment</summary>
</conlib>
--%>
<table class="inputForm paypalExpressForm">
    <tr>
        <th>&nbsp;</th>
        <td>
            <p><asp:Localize ID="PayPalExpressHelpText" runat="server" Text="Click below to place your order.  Your payment will be made automatically using the PayPal funding source(s) you have supplied.  If you change your mind and wish to use another form of payment, click the 'change' link below."></asp:Localize></p>
            <div class="paypalAccount">
                <asp:Label ID="PayPalAccountLabel" runat="server" Text="PayPal Account: " AssociatedControlID="PayPalAccount" CssClass="fieldHeader"></asp:Label>
                <asp:Literal ID="PayPalAccount" runat="server"></asp:Literal>
                <asp:HyperLink ID="ChangeLink" runat="server" Text="change" NavigateUrl="~/PayPalExpressCheckout.aspx?Action=CANCEL&ReturnURL=PAY"></asp:HyperLink>
            </div>
        </td>
    </tr>
    <tr>
        <th>&nbsp;</th>
        <td>
            <asp:ImageButton ID="PayPalButton" runat="server" ImageUrl="{0}://www.paypal.com/en_US/i/btn/x-click-but1.gif" OnClick="PayPalButton_Click" ValidationGroup="PayPalExpressPayment" />
        </td>
    </tr>
</table>