<%@ Control Language="C#" AutoEventWireup="True" CodeFile="GiftCertificatePaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.GiftCertificatePaymentForm" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Payment form for a gift certificate based payment</summary>
<param name="ValidationGroup" default="GiftCertificate">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr>
        <th>
            <asp:Label ID="GiftCertificateNumberLabel" runat="server" Text="Gift Certificate #:" AssociatedControlID="GiftCertificateNumber"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="GiftCertificateNumber" runat="server" MaxLength="50" ValidationGroup="GiftCertificate"></asp:TextBox>
            <asp:RequiredFieldValidator ID="GiftCertificateNumberRequired" runat="server" 
                ErrorMessage="You must enter the gift certificate number." 
                ControlToValidate="GiftCertificateNumber" Display="Static" Text="*" ValidationGroup="GiftCertificate"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <asp:Button ID="GiftCertificateButton" runat="server" Text="Pay With Gift Certificate" ValidationGroup="GiftCertificate" OnClick="GiftCertificateButton_Click" />
            <asp:Panel runat="server" Visible="false" ID="GiftCertErrorsPanel">
                <asp:Label CssClass="errorCondition" ID="GiftCertPaymentErrors" runat="server" Text=""></asp:Label>
            </asp:Panel>            
        </td>
    </tr>
</table>