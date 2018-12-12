<%@ Page Language="C#"  MasterPageFile="~/Admin/Orders/Order.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Payments.CapturePayment" Title="Capture Payment" CodeFile="CapturePayment.aspx.cs" %>
<%@ Register Src="../../UserControls/AccountDataViewport.ascx" TagName="AccountDataViewport" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption"><h1><asp:Localize ID="Caption" runat="server" Text="Capture Funds for Payment #{0}: {1}"></asp:Localize></h1></div>
    </div>
    <div class="content">
        <table class="inputForm" cellspacing="0">
            <tr>
                <th>
                    <asp:Label ID="PaymentDateLabel" runat="server" Text="Date:"></asp:Label>
                </th>
                <td>
                    <asp:Label ID="PaymentDate" runat="server" Text=""></asp:Label>
                </td>
                <th>
                    <asp:Label ID="AmountLabel" runat="server" Text="Amount:"></asp:Label>
                </th>
                <td>
                    <asp:Label ID="Amount" runat="server" Text=""></asp:Label>
                </td>
                <th>
                    <asp:Label ID="PaymentStatusLabel" runat="server" Text="Status:"></asp:Label>
                </th>
                <td>
                    <asp:Label ID="CurrentPaymentStatus" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <asp:Label ID="AccountDataLabel" runat="server" Text="Method:"></asp:Label>
                </th>
                <td colspan="5">
                    <asp:Label ID="PaymentMethod" runat="server"></asp:Label><br />
                    <asp:Label ID="AccountReference" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <asp:Label ID="AccountDetailsLabel" runat="server" Text="Account Details:" AssociatedControlID="AccountDataViewport" EnableViewState="false"></asp:Label>
                </th>
                <td colspan="5">
                    <uc:AccountDataViewport ID="AccountDataViewport" runat="server" EnableViewState="false" UnavailableText="n/a"></uc:AccountDataViewport>
                </td>
            </tr>
        </table>
    </div>
    <div class="section">
        <div class="header">
            <h2><asp:Localize ID="CaptureCaption" runat="server" Text="Capture Options"></asp:Localize></h2>
        </div>
        <div class="content">
            <table cellspacing="0" class="inputForm">
                <tr>
                    <th>
                        <asp:Label ID="OriginalAuthorizationLabel" runat="server" Text="Original Authorization:"></asp:Label>
                    </th>
                    <td>
                        <asp:Label ID="OriginalAuthorization" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr runat="server" id="trRemainingAuthorization">
                    <th>
                        <asp:Label ID="RemainingAuthorizationLabel" runat="server" Text="Remaining Authorization:"></asp:Label>
                    </th>
                    <td>
                        <asp:Label ID="RemainingAuthorization" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="OrderBalanceLabel" runat="server" Text="Order Balance:"></asp:Label>
                    </th>
                    <td>
                        <asp:Label ID="OrderBalance" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="CaptureAmountLabel" runat="server" Text="Capture Amount:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="CaptureAmount" runat="server" Columns="6"></asp:TextBox>
                    </td>
                </tr>
                <tr id="trAdditionalCapture" runat="server">
                    <th>
                        <asp:Label ID="AdditionalCaptureLabel" runat="server" Text="Additional Capture Possible:"></asp:Label>
                    </th>
                    <td>
                        <asp:RadioButton ID="AdditionalCapture" runat="server" GroupName="AdditionalCapture" Text="Yes" />(option to capture additional funds on this authorization if needed)<br />
                        <asp:RadioButton ID="NoAdditionalCapture" runat="server" GroupName="AdditionalCapture" Text="No" Checked="true" /> (no additional capture needed; close authorization after this capture)<br />
                    </td>
                </tr>
                <tr>
                    <th>
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
                        <asp:Button ID="SubmitCaptureButton" runat="server" Text="Capture" OnClick="SubmitCaptureButton_Click"></asp:Button>
                        <asp:Button ID="CancelCaptureButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelCaptureButton_Click"></asp:Button>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>