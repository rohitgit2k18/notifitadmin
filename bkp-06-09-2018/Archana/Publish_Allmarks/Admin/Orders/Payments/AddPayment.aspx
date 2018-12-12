<%@ Page Language="C#" MasterPageFile="../Order.master" Inherits="AbleCommerce.Admin.Orders.Payments.AddPayment" Title="Add Payment" CodeFile="AddPayment.aspx.cs" %>
<%@ Register Src="ucProcessPayment.ascx" TagName="ucProcessPayment" TagPrefix="uc1" %>
<%@ Register Src="ucRecordPayment.ascx" TagName="ucRecordPayment" TagPrefix="uc2" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Add Payment"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PaymentAjax" runat="server">
        <ContentTemplate>
            <div class="section">
                <div class="content">
                    <asp:Label ID="BalanceLabel" runat="server" Text="Order Balance:" SkinID="FieldHeader"></asp:Label>
                    <asp:Label ID="Balance" runat="server"></asp:Label>
                    <asp:Label ID="PendingMessage" runat="server" Text="One or more payments are in a pending state."></asp:Label>
                </div>
            </div>
            <div class="section">
                <div class="header">
                    <asp:RadioButton ID="ProcessPayment" runat="server" Text="Process Payment" GroupName="PaymentType" AutoPostBack="true" Checked="true" OnCheckedChanged="ProcessPayment_CheckedChanged" />
                </div>
                <div class="content">
                    <p><asp:Label ID="ProcessPaymentHelpText" runat="server" Text="Process a credit card payment online.  This is only available for payment methods that are linked to a real-time payment gateway." EnableViewState="false" CssClass="helpText"></asp:Label></p>
                    <asp:Panel ID="ProcessPaymentPanel" runat="server">
                        <uc1:ucProcessPayment id="UcProcessPayment1" runat="server">
                        </uc1:ucProcessPayment>
                    </asp:Panel>
                </div>
            </div>
            <div class="section">
                <div class="header">
                    <asp:RadioButton ID="RecordPayment" runat="server" Text="Record Payment" GroupName="PaymentType" AutoPostBack="true" OnCheckedChanged="RecordPayment_CheckedChanged" ToolTip="Record payment, sent in by check or other method outside the store." />
                </div>
                <div class="content">
                    <p><asp:Label ID="RecordPaymentHelpText" runat="server" Text="Sent in by check or some other offline method." EnableViewState="false" CssClass="helpText"></asp:Label></p>
                    <asp:Panel ID="RecordPaymentPanel" runat="server" Visible="false">
                        <uc2:ucRecordPayment id="UcRecordPayment1" runat="server">
                        </uc2:ucRecordPayment>
                    </asp:Panel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>