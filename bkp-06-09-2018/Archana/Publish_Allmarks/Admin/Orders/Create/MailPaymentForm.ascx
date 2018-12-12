<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Create.MailPaymentForm" CodeFile="MailPaymentForm.ascx.cs" %>
<table class="paymentForm">
    <tr>
        <th class="caption">
            <asp:Label ID="Caption" runat="server" Text="Pay by {0}"></asp:Label>
        </th>
    </tr>
    <tr>
        <td class="content">
		    <p align="justify"><asp:Label ID="MailHelpText" runat="server" Text="Click below to submit your order. Allmark will confirm pricing and an invoice will be issued for payment when the goods are ready."></asp:Label></p>
        </td>
    </tr>
    <tr>
        <td class="submit">
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="MailFax" Visible="false" />
            <asp:Button ID="MailButton" runat="server" Text="{0}" OnClick="MailButton_Click" ValidationGroup="MailFax" />
        </td>
    </tr>
</table>