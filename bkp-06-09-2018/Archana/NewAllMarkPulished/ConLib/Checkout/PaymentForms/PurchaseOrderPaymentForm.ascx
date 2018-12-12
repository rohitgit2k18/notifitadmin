<%@ Control Language="C#" AutoEventWireup="True" CodeFile="PurchaseOrderPaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.PurchaseOrderPaymentForm" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Payment form for a purchase order type payment</summary>
<param name="ValidationGroup" default="PurchaseOrder">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr>
        <th>
            <asp:Label ID="PurchaseOrderNumberLabel" runat="server" Text="PO Number:" AssociatedControlID="PurchaseOrderNumber"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="PurchaseOrderNumber" runat="server" MaxLength="50" ValidationGroup="PurchaseOrder"></asp:TextBox>
            <asp:RequiredFieldValidator ID="PurchaseOrderNumberRequired" runat="server" 
                ErrorMessage="You must enter the purchase order number." 
                ControlToValidate="PurchaseOrderNumber" Display="Static" Text="*" ValidationGroup="PurchaseOrder"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <asp:Button ID="PurchaseOrderButton" runat="server" Text="Pay by {0}" ValidationGroup="PurchaseOrder" OnClick="PurchaseOrderButton_Click" />
        </td>
    </tr>
</table>