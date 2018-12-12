<%@ Control Language="C#" AutoEventWireup="True" CodeFile="ZeroValuePaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.ZeroValuePaymentForm" ViewStateMode="Disabled" %>
<div class="inputForm">
    <div class="field">        
		<p>
		    <asp:Localize ID="NoValueHelpText" runat="server" Text="There is no charge for your item(s).  Click below to complete your order."></asp:Localize>
		</p>        
    </div>
    <div class="buttons">
        <asp:Button ID="CompleteButton" runat="server" Text="Complete Order" OnClick="CompleteButton_Click" ValidationGroup="ZeroValue" />
    </div>
</div>
