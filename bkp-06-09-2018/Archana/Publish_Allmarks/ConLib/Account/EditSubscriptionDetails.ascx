<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EditSubscriptionDetails.ascx.cs" Inherits="AbleCommerce.ConLib.Account.EditSubscriptionDetails" %>
<%--
<conlib>
<summary>Displays subscription details and edit options.</summary>
<param name="SubscriptionId" default="0">The Subscription Id for which to show the details</param>
</conlib>
--%>

<table border="0" cellpadding="10" cellspacing="0" width="100%">
    <tr>
        <td valign="top" style="border:1px dashed;text-align:left;padding-left:10px;">
            <div>
	            <strong><asp:Localize ID="ShipAddressCaption" runat="server" Text="Shipping Address"></asp:Localize></strong>
                <asp:LinkButton ID="EditShipAddressLink" runat="server" Text="edit" OnClick="EditShipAddressLink_Click" SkinID="button"></asp:LinkButton>
            </div>
            <div>
                <div class="address">
                    <asp:Literal ID="ShipAddress" runat="server"></asp:Literal>
                </div>
            </div>
        </td>
        <td valign="top" style="border:1px dashed;text-align:left;padding-left:10px;">
            <div>
	            <strong><asp:Localize ID="BillAddressCaption" runat="server" Text="Billing Address"></asp:Localize></strong>
                <asp:LinkButton ID="EditBillAddressLink" runat="server" Text="edit" OnClick="EditBillAddressLink_Click" SkinID="button"></asp:LinkButton>
            </div>
            <div>
                <div class="address">
                    <asp:Literal ID="BillAddress" runat="server"></asp:Literal>
                </div>
            </div>
        </td>
        <td id="tdPaymentPanel" runat="server" valign="top" style="border:1px dashed;text-align:left;padding-left:10px;">
            <div>
	            <strong><asp:Localize ID="EditPaymentProfile" runat="server" Text="Payment Information"></asp:Localize></strong>
                <asp:LinkButton ID="AddPaymentLink" runat="server" Text="Add New" OnClick="AddPaymentLink_Click" SkinID="button"></asp:LinkButton>
            </div>
            <div>
                <div class="address">
                    <p>Credit card for next payment</p>
                    <asp:PlaceHolder ID="CreditCardMessagePH" runat="server" EnableViewState="false" Visible="false">
                    <p class="goodCondition">Credit Card changed successfully.</p>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="ProfileMessage" runat="server">
                        <p><asp:Label ID="ProfileSuccessMessage" runat="server" CssClass="goodCondition" EnableViewState="false" Visible="false"></asp:Label></p>
                        <p><asp:Label ID="ProfileErrorMessage" runat="server" CssClass="errorCondition" EnableViewState="false" Visible="false"></asp:Label></p> 
                    </asp:PlaceHolder>
                    <asp:DropDownList ID="PreferedCreditCard" runat="server" 
                        DataSourceID="GatewayProfilesDS" DataTextField="NameAndTypeWithReference" 
                        DataValueField="Id" AutoPostBack="true" 
                        onselectedindexchanged="PreferedCreditCard_SelectedIndexChanged" ViewStateMode="Enabled"></asp:DropDownList>
                    <asp:PlaceHolder ID="PaymentProfilePH" runat="server"></asp:PlaceHolder>
                    <asp:Button ID="UpdateCardButton" runat="server" Text="Update" OnClick="UpdateCardButton_Click" Visible="false" />
                    <asp:Button ID="EditProfileButton" runat="server" Text="Edit" OnClick="EditProfileButton_Click" Visible="false" />
                    <asp:Button ID="RemoveCardButton" runat="server" Text="Remove" OnClientClick="return confirm('Are you sure you want to remove this card?')" OnClick="RemoveCardButton_Click" Visible="false" />
                    <p>Please verify your billing address for this credit card.</p>
                    <asp:ObjectDataSource ID="GatewayProfilesDS" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="LoadForUser" 
                        TypeName="CommerceBuilder.Payments.GatewayPaymentProfileDataSource" 
                        SortParameterName="sortExpression" onselecting="GatewayProfilesDS_Selecting" OnSelected="GatewayProfilesDS_Selected">
                        <SelectParameters>
                            <asp:Parameter Name="userId" Type="Int32" DefaultValue="0" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>
            </div>
        </td>
    </tr>
</table>
<div class="popupContainer">
<asp:Panel ID="AddCardDialog" runat="server" style="display:none;width:450px;" CssClass="modalPopup" ViewStateMode="Enabled">
    <asp:Panel ID="AddCardDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
        <asp:Localize ID="AddCardDialogCaption" runat="server" Text="Add Credit Card" EnableViewState="false"></asp:Localize>
    </asp:Panel>
    <div style="padding-top:5px;">
        
        <table class="inputForm">
        <tr>
            <td style="padding: 5px!important; border-style: none!important; text-align:left;" colspan="2">
                <asp:ValidationSummary ID="CardSummary" runat="server" ValidationGroup="CreditCard" />
            </td>
        </tr>
        <tr>
            <td class="rowHeader" style="padding: 5px!important; border-style: none!important">
                <asp:Label ID="CardTypeLabel" runat="server" Text="Card Type:"></asp:Label>
            </td>
            <td style="padding: 5px!important; border-style: none!important; text-align:left;">
                <asp:DropDownList ID="CardType" runat="server" DataTextField="Name" DataValueField="PaymentMethodId" ValidationGroup="CreditCard">
                    <asp:ListItem></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="CardTypeRequired" runat="server" Text="*"
                    ErrorMessage="Card type is required." Display="Static" ControlToValidate="CardType"
                    ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="rowHeader" style="padding: 5px!important; border-style: none!important">
                <asp:Label ID="CardNameLabel" runat="server" Text="Name on Card:" AssociatedControlID="CardName"></asp:Label>
            </td>
            <td style="padding: 5px!important; border-style: none!important; text-align:left;">
                <asp:TextBox ID="CardName" runat="server" MaxLength="50" ValidationGroup="CreditCard" AutoCompleteType="Disabled"></asp:TextBox>
                <asp:RequiredFieldValidator ID="CardNameRequired" runat="server" 
                    ErrorMessage="You must enter the name as it appears on the card." 
                    ControlToValidate="CardName" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="rowHeader" style="padding: 5px!important; border-style: none!important">
                <asp:Label ID="CardNumberLabel" runat="server" Text="Card Number:" AssociatedControlID="CardNumber"></asp:Label>
            </td>
            <td style="padding: 5px!important; border-style: none!important; text-align:left;">
                <asp:TextBox ID="CardNumber" runat="server" MaxLength="19" ValidationGroup="CreditCard"></asp:TextBox>
                <cb:CreditCardValidator ID="CardNumberValidator1" runat="server" 
                    ControlToValidate="CardNumber" ErrorMessage="You must enter a valid card number."
                    Display="Dynamic" Text="*" ValidationGroup="CreditCard"></cb:CreditCardValidator>
                <cb:RequiredRegularExpressionValidator ID="CardNumberValidator2" runat="server" ValidationExpression="\d{12,19}"
                    ErrorMessage="Card number is required and should be between 12 and 19 digits (no dashes or spaces)." ControlToValidate="CardNumber"
                    Display="Static" Text="*" Required="true" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td class="rowHeader" style="padding: 5px!important; border-style: none!important">
                <asp:Label ID="ExpirationLabel" runat="server" Text="Expiration:" AssociatedControlID="ExpirationMonth"></asp:Label>
            </td>
            <td style="padding: 5px!important; border-style: none!important; text-align:left;">
                <asp:dropdownlist ID="ExpirationMonth" runat="server" ValidationGroup="CreditCard">
                    <asp:ListItem Text="Month" Value=""></asp:ListItem>
                    <asp:ListItem Value="01">01</asp:ListItem>
                    <asp:ListItem Value="02">02</asp:ListItem>
                    <asp:ListItem Value="03">03</asp:ListItem>
                    <asp:ListItem Value="04">04</asp:ListItem>
                    <asp:ListItem Value="05">05</asp:ListItem>
                    <asp:ListItem Value="06">06</asp:ListItem>
                    <asp:ListItem Value="07">07</asp:ListItem>
                    <asp:ListItem Value="08">08</asp:ListItem>
                    <asp:ListItem Value="09">09</asp:ListItem>
                    <asp:ListItem Value="10">10</asp:ListItem>
                    <asp:ListItem Value="11">11</asp:ListItem>
                    <asp:ListItem Value="12">12</asp:ListItem>
                </asp:dropdownlist>
                <asp:RequiredFieldValidator ID="MonthValidator" runat="server" ErrorMessage="You must select the expiration month." 
                    ControlToValidate="ExpirationMonth" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
                <asp:dropdownlist ID="ExpirationYear" Runat="server" ValidationGroup="CreditCard">
                    <asp:ListItem Text="Year" Value=""></asp:ListItem>
                </asp:dropdownlist>
                <cb:expirationdropdownvalidator ID="ExpirationDropDownValidator1" runat="server"
                    Display="Dynamic" errormessage="You must enter an expiration date in the future."
                    monthcontroltovalidate="ExpirationMonth" yearcontroltovalidate="ExpirationYear"
                    Text="*" ValidationGroup="CreditCard"></cb:expirationdropdownvalidator>
                <asp:RequiredFieldValidator ID="YearValidator" runat="server" ErrorMessage="You must select the expiration year." 
                    ControlToValidate="ExpirationYear" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
        <td class="rowHeader" style="padding: 5px!important; border-style: none!important">
            <asp:Label ID="SecurityCodeLabel" runat="server" Text="Verification Code:" AssociatedControlID="SecurityCode"></asp:Label>
        </td>
        <td style="padding: 5px!important; border-style: none!important; text-align:left;">
            <div class="securityCodeInput">
                <asp:TextBox ID="SecurityCode" runat="server" Columns="4" MaxLength="4" ValidationGroup="CreditCard" AutoCompleteType="Disabled"></asp:TextBox>
                <cb:RequiredRegularExpressionValidator ID="SecurityCodeValidator" runat="server" ValidationExpression="\d{3,4}"
                    ErrorMessage="Card security code should be a 3 or 4 digit number." ControlToValidate="SecurityCode"
                    Display="Dynamic" Text="*" Required="true" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
                <asp:CustomValidator ID="SecurityCodeValidator2" runat="server" Text="*" 
                    ErrorMessage="Card security code should be a 3 or 4 digit number." ValidationGroup="CreditCard"></asp:CustomValidator>
            </div>
        </td>
    </tr>
        <tr>
            <td style="padding: 5px!important; border-style: none!important">&nbsp;</td>
            <td style="padding: 5px!important; border-style: none!important; text-align:left;">
                <asp:Button ID="SaveCardButton" runat="server" Text="Save" ValidationGroup="CreditCard" OnClick="SaveCardButton_Click" />
                <asp:Button ID="CancelCardButton" runat="server" Text="Cancel" CausesValidation="false" /><br />
                <asp:Label ID="ErrorMessage" runat="server" CssClass="errorCondition" EnableViewState="false"></asp:Label>
            </td>
        </tr>
    </table>
    </div>
</asp:Panel>
</div>
<asp:LinkButton ID="DummyAddCardLink" runat="server" EnableViewState="false" />
<ajaxToolkit:ModalPopupExtender ID="AddCardPopup" runat="server" 
        TargetControlID="DummyAddCardLink"
        PopupControlID="AddCardDialog" 
        BackgroundCssClass="modalBackground"                         
        DropShadow="false"
        CancelControlID="CancelCardButton"
        PopupDragHandleControlID="AddCardDialogHeader" />