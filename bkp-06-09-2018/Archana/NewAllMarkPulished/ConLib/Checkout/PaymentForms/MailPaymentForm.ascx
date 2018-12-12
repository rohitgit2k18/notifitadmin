<%@ Control Language="C#" AutoEventWireup="True" CodeFile="MailPaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.MailPaymentForm" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Payment form for a mail based payment</summary>
<param name="ValidationGroup" default="MailPayment">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr>
        <td>
		    <p><asp:Localize ID="MailHelpText" runat="server" Text="Click below to submit your order. Allmark will confirm pricing and an invoice will be issued for payment when the goods are ready."></asp:Localize></p>
        </td>
    </tr>
    <tr>
        <td>
            <asp:TextBox ID="Comments" runat="server" Height="170px" TextMode="MultiLine" CssClass="form-control" ValidationGroup="ContactUs" placeholder="Comment"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Button ID="MailButton" runat="server" Text="{0}" OnClick="MailButton_Click" ValidationGroup="MailPayment" />
        </td>
    </tr>
</table>