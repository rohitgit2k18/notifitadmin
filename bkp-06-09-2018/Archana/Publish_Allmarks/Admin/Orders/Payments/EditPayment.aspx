<%@ Page Language="C#" MasterPageFile="../Order.master" Inherits="AbleCommerce.Admin.Orders.Payments.EditPayment" Title="Edit Payment" CodeFile="EditPayment.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption"><h1><asp:Localize ID="Caption" runat="server" Text="Edit Payment {0} {1}"></asp:Localize></h1></div>
    </div>
    <div class="content">
        <table class="inputForm">
            <tr>
                <th>
                    <asp:Label ID="CurrentPaymentStatusLabel" runat="server" Text="Status: "></asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="CurrentPaymentStatus" runat="server"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="PaymentDateLabel" runat="server" Text="Date: "></asp:Label>
                </th>
                <td>
                    <asp:Label ID="PaymentDate" runat="server" Text=""></asp:Label>
                </td>
            </tr>                
            <tr>
                <th>
                    <asp:Label ID="AmountLabel" runat="server" Text="Amount: "></asp:Label>
                </th>
                <td>
                    <asp:Label ID="Amount" runat="server" Text=""></asp:Label>
                </td>
            </tr>                
            <tr>
                <th>
                    <asp:Label ID="PaymentMethodLabel" runat="server" Text="Method: "></asp:Label>
                </th>
                <td>
                    <asp:Label ID="PaymentMethod" runat="server" Text=""></asp:Label>
                </td>
           </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />     
                    <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>