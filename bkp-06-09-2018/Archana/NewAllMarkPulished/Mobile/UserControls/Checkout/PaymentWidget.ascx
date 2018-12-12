<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PaymentWidget.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentWidget" ViewStateMode="Disabled" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/CreditCardPaymentForm.ascx" TagName="CreditCardPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/CheckPaymentForm.ascx" TagName="CheckPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/PayPalExpressPaymentForm.ascx" TagName="PayPalExpressPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/PayPalPaymentForm.ascx" TagName="PayPalPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/MailPaymentForm.ascx" TagName="MailPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/PhoneCallPaymentForm.ascx" TagName="PhoneCallPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/PurchaseOrderPaymentForm.ascx" TagName="PurchaseOrderPaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/GiftCertificatePaymentForm.ascx" TagName="GiftCertificatePaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/ZeroValuePaymentForm.ascx" TagName="ZeroValuePaymentForm" TagPrefix="uc" %>
<%@ Register Src="~/Mobile/UserControls/Checkout/PaymentForms/AmazonPaymentForm.ascx" TagName="AmazonPaymentForm" TagPrefix="uc" %>

<div class="widget paymentWidget">    
    <asp:Panel ID="CouponsPanel" runat="server" Visible="false" CssClass="applyCouponPanel">
    <div class="header">
            <h2><asp:Localize ID="Localize1" runat="server" Text="Do you have a coupon?"></asp:Localize></h2>
        </div>
        <div class="content">
            <div class="inputForm">
                <div class="inlineField">
                    <asp:Label ID="CouponCodeLabel" runat="server" AssociatedControlID="CouponCode" Text="Enter it here:" CssClass="fieldHeader"></asp:Label>
                    <span class="fieldValue">
                        <asp:TextBox ID="CouponCode" runat="server" Width="110px" ValidationGroup="CouponCodeValidation"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CouponCodeRequired" runat="server" ControlToValidate="CouponCode"
                        Text="*" Display="Dynamic" ValidationGroup="CouponCodeValidation"></asp:RequiredFieldValidator>
                    </span>
                    <asp:Button ID="ApplyCouponButton" runat="server" Text="Apply" OnClick="ApplyCouponButton_Click" ValidationGroup="CouponCodeValidation" CssClass="button" />
                </div>
                
            </div>
            
            <asp:Localize ID="ValidCouponMessage" runat="server" Text="<p class='success'>Coupon {0} accepted.</p>" Visible="false" SkinID="GoodCondition"></asp:Localize>
            <asp:Localize ID="CouponsRemovedMessage" runat="server" Text="<p class='error'>The coupon {0} entered earlier has been removed from your order.</p>" Visible="false"></asp:Localize>
            <asp:Literal ID="InvalidCouponMessage" runat="server" Visible="false"></asp:Literal>
        </div>
    </asp:Panel>
    <div class="payMethodsPanel">
    <div class="header">
        <h2><asp:Localize ID="PaymentMethodCaption" runat="server" Text="Select Payment Method"></asp:Localize></h2>
    </div>
    <div class="content">
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
                <div class="inputForm">
                    <div class="field">
                        <span class="fieldHeader">Payment Method:</span>
                        <span class="fieldValue">
                            <asp:DropDownList ID="PaymentMethodList" runat="server" DataTextField="Value" DataValueField="Key" AutoPostBack="true"></asp:DropDownList>
                        </span>
                    </div>
                </div>
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
                <uc:PayPalExpressPaymentForm ID="PayPalExpressPaymentForm" runat="server" Visible="false" />
                <uc:AmazonPaymentForm ID="AmazonPaymentForm" runat="server" Visible="false" ValidationGroup="OPC" />
            </div>
        </asp:Panel>
		<asp:Panel ID="FailurePanel" runat="server" CssClass="paymentFailurePanel" Visible="false">
            You have attempted a payment too many times.  You can try again in <asp:Literal ID="FailureTimeoutRemaining" runat="server"></asp:Literal> minutes.
        </asp:Panel>
    </div>
    </div>
</div>