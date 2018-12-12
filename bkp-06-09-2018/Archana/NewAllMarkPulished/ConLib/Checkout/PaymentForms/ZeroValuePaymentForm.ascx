<%@ Control Language="C#" AutoEventWireup="True" CodeFile="ZeroValuePaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.ZeroValuePaymentForm" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Payment form when order total is 0</summary>
<param name="ValidationGroup" default="ZeroValue">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr>
        <th>&nbsp;</th>
        <td>
		    <p>
		        <asp:Localize ID="NoValueHelpText" runat="server" Text="There is no charge for your item(s).  Click below to complete your order."></asp:Localize>
		    </p>
        </td>
    </tr>
    <tr>
        <th>&nbsp;</th>
        <td>
            <asp:Button ID="CompleteButton" runat="server" Text="Complete Order" OnClick="CompleteButton_Click" ValidationGroup="ZeroValue" />
        </td>
    </tr>
</table>