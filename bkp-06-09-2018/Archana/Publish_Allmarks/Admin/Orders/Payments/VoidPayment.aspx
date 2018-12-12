<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Payments.VoidPayment" Title="Void Payment" CodeFile="VoidPayment.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption"><h1><asp:Localize ID="Caption" runat="server"></asp:Localize></h1></div>
    </div>
    <div class="content">
        <p>
            <asp:Localize ID="ProcessVoidHelpText" runat="server" Text="By initiating this void, you are canceling this authorization and will be unable to capture any funds remaining on the authorization.  You may optionally enter a message to the customer, then click Void to process the request." />
            <asp:Localize ID="ForcedVoidPaymentHelpText" runat="Server" Text="The current payment method or processor does not support void transactions.  You may optionally enter a message to the customer, then submit the form to force the status of this payment to Void.  Be sure to void the payment offline if necessary." /> 
            <asp:Localize ID="ForcedVoidAuthorizationHelpText" runat="Server" Text="The current payment method or processor does not support void transactions.  You may optionally enter a message to the customer, then submit the form to force the status of this authorization to Void.  Be sure to void the authorization offline if necessary." /> 
        </p>
        <table cellspacing="0" class="inputForm">
            <tr>
                <th>
                    <asp:Label ID="PaymentMethodLabel" runat="server" Text="Method:"></asp:Label>
                </th>
                <td>
                    <asp:Label ID="PaymentReference" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="PaymentAmountLabel" runat="server" Text="Payment Amount:"></asp:Label>
                </th>
                <td>
                    <asp:Literal ID="PaymentAmount" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="AuthorizationAmountLabel" runat="server" Text="Authorization Amount:"></asp:Label>
                </th>
                <td>
                    <asp:Label ID="AuthorizationAmount" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="CaptureAmountLabel" runat="server" Text="Prior Captures:"></asp:Label>
                </th>
                <td>
                    <asp:Label ID="CaptureAmount" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="VoidAmountLabel" runat="server" Text="Void Amount:"></asp:Label>
                </th>
                <td>
                    <asp:Label ID="VoidAmount" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <asp:Label ID="CustomerNoteLabel" runat="server" Text="Note to Customer:"></asp:Label><br />
                    (Optional)
                </th>
                <td>
                    <asp:TextBox ID="CustomerNote" runat="server" TextMode="MultiLine" Rows="6" Columns="50"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SubmitVoidButton" runat="server" Text="Void" OnClick="SubmitVoidButton_Click"></asp:Button>
                    <asp:Button ID="CancelVoidButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelVoidButton_Click"></asp:Button>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

