<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Create.DeferPaymentForm" CodeFile="DeferPaymentForm.ascx.cs" %>
<table class="paymentForm">
    <tr>
        <th class="caption">
            <asp:Label ID="Caption" runat="server" Text="Defer Payment"></asp:Label>
        </th>
    </tr>
    <tr>
        <td class="content">
		    <p align="justify"><asp:Label ID="DeferHelpText" runat="server" Text="Click below to complete the order without providing payment details."></asp:Label></p>
        </td>
    </tr>
    <tr>
        <td class="submit">
            <asp:Button ID="SubmitButton" runat="server" Text="Defer Payment" OnClick="SubmitButton_Click" ValidationGroup="MailFax" />
        </td>
    </tr>
</table>