<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Payments.ucRecordPayment" CodeFile="ucRecordPayment.ascx.cs" %>
<asp:UpdatePanel ID="PaymentAjaxPanel" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <table class="inputForm" cellspacing="0">
            <tr>
                <th>
                    <asp:Label ID="PaymentMethodLabel" runat="server" Text="Payment Method:"></asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="SelectedPaymentMethod" runat="server" DataValueField="PaymentMethodId" DataTextField="Name" AppendDataBoundItems="true" OnSelectedIndexChanged="SelectedPaymentMethod_SelectedIndexChanged" AutoPostBack="true">
                        <asp:ListItem Value="" Text=""></asp:ListItem>
                    </asp:DropDownList><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="PaymentMethodRequiredValidator" runat="server"
                        ErrorMessage="You must select a payment method." ControlToValidate="SelectedPaymentMethod" Display="Dynamic">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="ReferenceNumberLabel" runat="server" Text="Reference Number:"></asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="ReferenceNumber" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="AmountLabel" runat="server" Text="Amount:"></asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="Amount" runat="server"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="AmountRequiredValidator" runat="server" 
                    ErrorMessage="You must enter the amount of payment." ControlToValidate="Amount">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="PaymentStatusLabel" runat="server" Text="Status:"></asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="selPaymentStatus" runat="server">
                        <asp:ListItem Value=""></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="PaymentStatusReasonLabel" runat="server" Text="Status Notes:"></asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="PaymentStatusReason" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" runat="server" OnClick="SaveButton_Click" Text="Save"></asp:Button>
                    <asp:HyperLink ID="CancelLink" runat="server" SkinID="CancelButton" NavigateUrl="Default.aspx">Cancel</asp:HyperLink>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>