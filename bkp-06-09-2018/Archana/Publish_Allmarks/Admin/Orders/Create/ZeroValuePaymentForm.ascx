<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Create.ZeroValuePaymentForm" CodeFile="ZeroValuePaymentForm.ascx.cs" %>
<table class="paymentForm">
    <tr>
        <td class="content">
		    <p align="justify">
		        <asp:Localize ID="NoValueHelpText" runat="server" Text="There is no charge for your item(s).  Click below to complete your order." EnableViewState="False"></asp:Localize>
		    </p>
        </td>
    </tr>
    <tr>
        <td class="submit">
            <asp:ValidationSummary runat="server" ID="ValidationSummary1" ValidationGroup="ZeroValue" />
            <asp:Button ID="CompleteButton" runat="server" Text="Complete Order" OnClick="CompleteButton_Click" EnableViewState="false" ValidationGroup="ZeroValue" />
        </td>
    </tr>
</table>