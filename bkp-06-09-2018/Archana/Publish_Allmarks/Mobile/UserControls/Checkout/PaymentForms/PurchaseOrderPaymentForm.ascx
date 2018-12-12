<%@ Control Language="C#" AutoEventWireup="True" CodeFile="PurchaseOrderPaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.PurchaseOrderPaymentForm" ViewStateMode="Disabled" %>
<div class="inputForm">
    <div class="field">
        <asp:Label ID="PurchaseOrderNumberLabel" runat="server" Text="PO Number:" AssociatedControlID="PurchaseOrderNumber" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <asp:TextBox ID="PurchaseOrderNumber" runat="server" MaxLength="50" ValidationGroup="PurchaseOrder"></asp:TextBox>
            <asp:RequiredFieldValidator ID="PurchaseOrderNumberRequired" runat="server" 
                ErrorMessage="You must enter the purchase order number." 
                ControlToValidate="PurchaseOrderNumber" Display="Static" Text="*" ValidationGroup="PurchaseOrder"></asp:RequiredFieldValidator>
        </span>
    </div>
    <div class="buttons">
        <asp:Button ID="PurchaseOrderButton" runat="server" Text="Pay by {0}" ValidationGroup="PurchaseOrder" OnClick="PurchaseOrderButton_Click" />
    </div>
</div>