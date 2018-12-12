<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderPayments.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.OrderPayments"  ViewStateMode="Disabled" %>
<%--
<UserControls>
<summary>Displays payment information for an order.</summary>
</UserControls>
--%>
<%@ Register Src="~/ConLib/Utility/PayPalPayNowButton.ascx" TagName="PayPalPayNowButton" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/AmazonPaymentButton.ascx" TagName="AmazonPaymentButton" TagPrefix="uc" %>
<asp:Panel ID="PaymentPanel" runat="server" CssClass="widget orderPaymentHistoryWidget">
    <div class="header">
        <h2><asp:Localize ID="OrderPaymentsCaption" runat="server" Text="Payment Information"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:Repeater ID="PaymentGrid" runat="server">
            <HeaderTemplate>
                <div class="payments">
            </HeaderTemplate>
            <ItemTemplate>
                <div class="payment <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                    <div class="inputForm">
                        <div class="inlineField">
                            <span class="fieldHeader">Date: </span>                               
						    <span class="fieldValue"><%# Eval("paymentDate", "{0:d}")%></span>
                        </div>
                        <div class="inlineField">
                            <span class="fieldHeader">Amount: </span>                               
						    <span class="fieldValue price"><%# ((decimal)Eval("Amount")).LSCurrencyFormat("ulc") %></span>
                        </div>
                        <div class="inlineField">
                            <span class="fieldHeader">Status:</span>
                            <span class="fieldValue"><%# AbleCommerce.Code.StoreDataHelper.GetFriendlyPaymentStatus((Payment)Container.DataItem) %></span>
                        </div>
                        <div class="inlineField">
                         <span class="fieldHeader">Method:</span>
                            <span class="fieldValue"><%# Eval("PaymentMethodName") %> <%# Eval("ReferenceNumber") %><span>
                                <uc:PayPalPayNowButton ID="PayPalPayNowButton" runat="server" Payment='<%#Container.DataItem%>'></uc:PayPalPayNowButton>
                                <uc:AmazonPaymentButton ID="AmazonPaymentButton" runat="server" PaymentId='<%#Eval("Id")%>'></uc:AmazonPaymentButton>
                                <asp:Panel ID="MailPayMethodMessage" runat="server" Visible='<%# ShowMailPaymentMessage(Container.DataItem) %>'>
                                <asp:Label ID="MessageLabel" runat="server" Text="Make your check payable to:" SkinID="FieldHeader"></asp:Label><br />
                                <asp:Label ID="StoreNameLabel" runat="server" Text='<%# AbleContext.Current.Store.Name%>'></asp:Label><br />
                                <asp:Label ID="StoreAddress" runat="server" Text='<%# AbleContext.Current.Store.DefaultWarehouse.FormatAddress(true)%>'></asp:Label>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>
	</div>
</asp:Panel>