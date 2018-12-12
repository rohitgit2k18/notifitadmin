<%@ Control Language="C#" AutoEventWireup="True" CodeFile="OrderPayments.ascx.cs" Inherits="AbleCommerce.ConLib.Account.OrderPayments" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays payments made for an order</summary>
</conlib>
--%>
<%@ Register Src="~/ConLib/Utility/PayPalPayNowButton.ascx" TagName="PayPalPayNowButton" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/AmazonPaymentButton.ascx" TagName="AmazonPaymentButton" TagPrefix="uc" %>
<asp:Panel ID="PaymentPanel" runat="server" CssClass="widget orderPaymentHistoryWidget">
    <div class="header">
        <h2><asp:Localize ID="OrderPaymentsCaption" runat="server" Text="Payment Information"></asp:Localize></h2>
    </div>
    <div class="content">
        <cb:ExGridView ID="PaymentGrid" runat="server" AutoGenerateColumns="false" Width="100%" SkinID="ItemList">
            <Columns>
                <asp:BoundField HeaderText="Date" DataFormatString="{0:d}" DataField="PaymentDate" HeaderStyle-CssClass="paymentDate" ItemStyle-CssClass="paymentDate" />
                <asp:TemplateField HeaderText="Amount ex.gst">
                    <HeaderStyle CssClass="paymentAmount" />
                    <ItemStyle CssClass="paymentAmount" />
                    <ItemTemplate>
                        <%# ((decimal)Eval("Amount")).LSCurrencyFormat("ulc") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <HeaderStyle CssClass="paymentStatus" />
                    <ItemStyle CssClass="paymentStatus" />
                    <ItemTemplate>
                        <%# AbleCommerce.Code.StoreDataHelper.GetFriendlyPaymentStatus((Payment)Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Method">
                    <HeaderStyle CssClass="paymentMethod" />
                    <ItemStyle CssClass="paymentMethod" />
                    <ItemTemplate>
                        <%# Eval("PaymentMethodName") %> <%# Eval("ReferenceNumber") %>
                        <uc:PayPalPayNowButton ID="PayPalPayNowButton" runat="server" Payment='<%#Container.DataItem%>'></uc:PayPalPayNowButton>
                        <uc:AmazonPaymentButton ID="AmazonPaymentButton" runat="server" PaymentId='<%#Eval("Id")%>'></uc:AmazonPaymentButton>
                        <asp:Panel ID="MailPayMethodMessage" runat="server" Visible='<%# ShowMailPaymentMessage(Container.DataItem) %>'>
                            <asp:Label ID="MessageLabel" runat="server" Text="Make your check payable to:" SkinID="FieldHeader"></asp:Label><br />
                            <asp:Label ID="StoreNameLabel" runat="server" Text='<%# AbleContext.Current.Store.Name%>'></asp:Label><br />
                            <asp:Label ID="StoreAddress" runat="server" Text='<%# AbleContext.Current.Store.DefaultWarehouse.FormatAddress(true)%>'></asp:Label>
                        </asp:Panel>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </cb:ExGridView>
	</div>
</asp:Panel>