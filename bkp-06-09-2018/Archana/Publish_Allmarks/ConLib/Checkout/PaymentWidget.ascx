
<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PaymentWidget.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentWidget" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/AmazonPaymentForm.ascx" TagName="AmazonPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/CreditCardPaymentForm.ascx" TagName="CreditCardPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/CheckPaymentForm.ascx" TagName="CheckPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/PayPalExpressPaymentForm.ascx" TagName="PayPalExpressPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/PayPalPaymentForm.ascx" TagName="PayPalPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/MailPaymentForm.ascx" TagName="MailPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/PhoneCallPaymentForm.ascx" TagName="PhoneCallPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/PurchaseOrderPaymentForm.ascx" TagName="PurchaseOrderPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/GiftCertificatePaymentForm.ascx" TagName="GiftCertificatePaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Checkout/PaymentForms/ZeroValuePaymentForm.ascx" TagName="ZeroValuePaymentForm" TagPrefix="uc" %>
<%--
<conlib>
<summary>The main payment widget on payment page</summary>
</conlib>
--%>
<div class="widget paymentWidget">
    <div class="header">
        <h2><asp:Localize ID="PaymentMethodCaption" runat="server" Text="Select Payment Method"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:Panel ID="CouponsPanel" runat="server" Visible="false" CssClass="applyCouponPanel">
            <div class="couponForm">
                <asp:Label ID="CouponCodeLabel" runat="server" AssociatedControlID="CouponCode" Text="Do you have a coupon? Enter it here:"></asp:Label>
                <asp:TextBox ID="CouponCode" runat="server" Width="110px" ValidationGroup="CouponCodeValidation"></asp:TextBox>
                <asp:RequiredFieldValidator ID="CouponCodeRequired" runat="server" ControlToValidate="CouponCode"
                Text="*" Display="Dynamic" ValidationGroup="CouponCodeValidation"></asp:RequiredFieldValidator>
                <asp:Button ID="ApplyCouponButton" runat="server" Text="Apply" OnClick="ApplyCouponButton_Click" ValidationGroup="CouponCodeValidation" CssClass="button" />
            </div>
            <asp:Localize ID="ValidCouponMessage" runat="server" Text="<p class='success'>Coupon {0} accepted.</p>" Visible="false" SkinID="GoodCondition"></asp:Localize>
            <asp:Localize ID="CouponsRemovedMessage" runat="server" Text="<p class='error'>The coupon {0} entered earlier has been removed from your order.</p>" Visible="false"></asp:Localize>
            <asp:Literal ID="InvalidCouponMessage" runat="server" Visible="false"></asp:Literal>
        </asp:Panel>
	    <asp:ListView ID="WarningMessageList" runat="server">
            <LayoutTemplate>
                <div class="validationSummary">
                    <ul>
                        <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                    </ul>
                </div>
            </LayoutTemplate>
		    <ItemTemplate><li><%# Container.DataItem %></li></ItemTemplate>
	    </asp:ListView>
		<asp:Panel ID="PaymentFormContainer" runat="server" CssClass="paymentFormContainer">
    		<asp:ValidationSummary ID="PaymentValidationSummary" runat="server" ValidationGroup="OPC" />
            <asp:Panel ID="PaymentMethodListPanel" runat="server" CssClass="paymentMethodList" Visible="false">
                <table class="inputForm">
                    <tr>
                        <td>
                            <asp:Label ID="PaymentMethodLabel" runat="server" CssClass="fieldHeader" Text="Select a Payment Method:" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:RadioButtonList ID="PaymentMethodList" runat="server" DataTextField="Value" DataValueField="Key" AutoPostBack="true"></asp:RadioButtonList>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="NoPaymentMethodsPanel" runat="server" Visible="false">
                <p>
                We are sorry we can not process the order at this time. There is no suitable payment methods available to complete this purchase.
                </p>
            </asp:Panel>
            <div class="paymentForm">
                <uc:CreditCardPaymentForm ID="CreditCardPaymentForm" runat="server" ValidationGroup="OPC" ValidationSummaryVisible="false" visible="false" />
                <uc:GiftCertificatePaymentForm ID="GiftCertificatePaymentForm" runat="server" ValidationGroup="OPC" ValidationSummaryVisible="false" Visible="false" />
                <uc:CheckPaymentForm ID="CheckPaymentForm" runat="server" ValidationGroup="OPC" ValidationSummaryVisible="false" Visible="false" />
                <uc:PurchaseOrderPaymentForm ID="PurchaseOrderPaymentForm" runat="server" ValidationGroup="OPC" ValidationSummaryVisible="false" Visible="false" />
                <uc:PayPalPaymentForm ID="PayPalPaymentForm" runat="server" ValidationGroup="OPC" ValidationSummaryVisible="false" Visible="false" />
                <uc:MailPaymentForm ID="MailPaymentForm" runat="server" ValidationGroup="OPC" ValidationSummaryVisible="false" Visible="false" />
                <uc:PhoneCallPaymentForm ID="PhoneCallPaymentForm" runat="server" ValidationGroup="OPC" ValidationSummaryVisible="false" Visible="false" />
                <uc:ZeroValuePaymentForm ID="ZeroValuePaymentForm" runat="server" ValidationGroup="OPC" ValidationSummaryVisible="false" Visible="false" />
                <uc:PayPalExpressPaymentForm ID="PayPalExpressPaymentForm" runat="server" Visible="false" ValidationGroup="OPC"/>
                <uc:AmazonPaymentForm ID="AmazonPaymentForm" runat="server" Visible="false" ValidationGroup="OPC" />
            </div>
        </asp:Panel>
		<asp:Panel ID="FailurePanel" runat="server" CssClass="paymentFailurePanel" Visible="false">
            You have attempted a payment too many times.  You can try again in <asp:Literal ID="FailureTimeoutRemaining" runat="server"></asp:Literal> minutes.
        </asp:Panel>
    </div>
</div>