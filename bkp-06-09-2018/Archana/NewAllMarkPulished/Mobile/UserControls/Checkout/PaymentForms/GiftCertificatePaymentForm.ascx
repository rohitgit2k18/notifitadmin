<%@ Control Language="C#" AutoEventWireup="True" CodeFile="GiftCertificatePaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.GiftCertificatePaymentForm" ViewStateMode="Disabled" %>
<div class="inputForm">
    <div class="field">
        <asp:Label ID="GiftCertificateNumberLabel" runat="server" Text="Gift Certificate #:" AssociatedControlID="GiftCertificateNumber" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <asp:TextBox ID="GiftCertificateNumber" runat="server" MaxLength="50" ValidationGroup="GiftCertificate"></asp:TextBox>
            <asp:RequiredFieldValidator ID="GiftCertificateNumberRequired" runat="server" 
                ErrorMessage="You must enter the gift certificate number." 
                ControlToValidate="GiftCertificateNumber" Display="Static" Text="*" ValidationGroup="GiftCertificate"></asp:RequiredFieldValidator>
        </span>
    </div>
    <div class="buttons">
            <asp:Button ID="GiftCertificateButton" runat="server" Text="Pay With Gift Certificate" ValidationGroup="GiftCertificate" OnClick="GiftCertificateButton_Click" />
            <asp:Panel runat="server" Visible="false" ID="GiftCertErrorsPanel">
                <asp:Label CssClass="errorCondition" ID="GiftCertPaymentErrors" runat="server" Text=""></asp:Label>
            </asp:Panel>
    </div>
</div>