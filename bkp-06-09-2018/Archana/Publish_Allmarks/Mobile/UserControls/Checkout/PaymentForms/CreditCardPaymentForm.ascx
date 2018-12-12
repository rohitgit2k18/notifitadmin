<%@ Control Language="C#" AutoEventWireup="True" CodeFile="CreditCardPaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.CreditCardPaymentForm" ViewStateMode="Disabled" %>
<div class="inputForm">
    <div id="trAmount" runat="server" visible="false" ViewStateMode="Enabled" class="field">
        <asp:Label ID="AmountLabel" runat="server" Text="Amount:" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <asp:TextBox ID="Amount" runat="server" Text="" Width="60px" MaxLength="10" ValidationGroup="CreditCard"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AmountRequired" runat="server" Text="*"
                ErrorMessage="Amount is required." Display="Dynamic" ControlToValidate="Amount"
                ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
            <asp:PlaceHolder ID="phAmount" runat="server"></asp:PlaceHolder>
        </span>
    </div>
    <asp:PlaceHolder ID="CardPH" runat="server" EnableViewState="true" ViewStateMode="Enabled">
    <div class="field">
        <asp:Label ID="CardTypeLabel" runat="server" Text="Card Type:" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <asp:DropDownList ID="CardType" runat="server" DataTextField="Name" DataValueField="PaymentMethodId" ValidationGroup="CreditCard">
                <asp:ListItem Text="--Select--" Value=""></asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="CardTypeRequired" runat="server" Text="*"
                ErrorMessage="Card type is required." Display="Static" ControlToValidate="CardType"
                ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
        </span>
    </div>
    <div class="field">
        <asp:Label ID="CardNameLabel" runat="server" Text="Name on Card:" AssociatedControlID="CardName" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <asp:TextBox ID="CardName" runat="server" MaxLength="50" ValidationGroup="CreditCard" AutoCompleteType="Disabled"></asp:TextBox>
            <asp:RequiredFieldValidator ID="CardNameRequired" runat="server" 
                ErrorMessage="You must enter the name as it appears on the card." 
                ControlToValidate="CardName" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
        </span>
    </div>
    <div class="field">
        <asp:Label ID="CardNumberLabel" runat="server" Text="Card Number:" AssociatedControlID="CardNumber" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <asp:TextBox ID="CardNumber" runat="server" MaxLength="19" ValidationGroup="CreditCard"></asp:TextBox>
            <cb:CreditCardValidator ID="CardNumberValidator1" runat="server" 
                ControlToValidate="CardNumber" ErrorMessage="Invalid card number, or it does not match the selected card type."
                Display="Dynamic" Text="*" ValidationGroup="CreditCard"></cb:CreditCardValidator>
            <cb:RequiredRegularExpressionValidator ID="CardNumberValidator2" runat="server" ValidationExpression="\d{12,19}"
                ErrorMessage="Card number is required and should be between 12 and 19 digits (no dashes or spaces)." ControlToValidate="CardNumber"
                Display="Static" Text="*" Required="true" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
        </span>
    </div>
    <div class="field">
        <asp:Label ID="ExpirationLabel" runat="server" Text="Expiration:" AssociatedControlID="ExpirationMonth" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
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
        </span>
    </div>
    <div id="trIntlCVV" runat="server" visible="true" class="field">
        <asp:Literal ID="IntlCVVCredit" runat="server" Text="For {0} cards, the Verification Code is required.  "></asp:Literal>
        <asp:Literal ID="IntlCVVDebit" runat="server" Text="For {0} cards the Verification Code is optional - enter the number only if present on your card."></asp:Literal>
    </div>
    <div class="field">
        <asp:Label ID="SecurityCodeLabel" runat="server" Text="Verification Code:" AssociatedControlID="SecurityCode" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <div class="securityCodeInput">
                <asp:TextBox ID="SecurityCode" runat="server" Columns="4" Width="40px" MaxLength="4" ValidationGroup="CreditCard" AutoCompleteType="Disabled"></asp:TextBox>
                <cb:RequiredRegularExpressionValidator ID="SecurityCodeValidator" runat="server" ValidationExpression="\d{3,4}"
                    ErrorMessage="Card security code should be a 3 or 4 digit number." ControlToValidate="SecurityCode"
                    Display="Dynamic" Text="*" Required="true" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
                <asp:CustomValidator ID="SecurityCodeValidator2" runat="server" Text="*" 
                    ErrorMessage="Card security code should be a 3 or 4 digit number." ValidationGroup="CreditCard"></asp:CustomValidator>                
                <asp:LinkButton ID="HelpLink" runat="server" Text="What's this?" EnableViewState="false" OnClientClick="return false;" CssClass="linked"></asp:LinkButton>
            </div>
        </span>
    </div>
    <div id="trIntlInstructions" runat="server" visible="true">
        <span class="fieldValue">
            <asp:Literal ID="IntlInstructions" runat="server" Text="Issue number and/or Start Date only apply to {0} cards.  Enter the value(s) if present on your card."></asp:Literal>
        </span>
    </div>
    <div id="trIssueNumber" runat="server" visible="true" class="field">
        <asp:Label ID="IssueNumberLabel" runat="server" Text="Issue Number:" AssociatedControlID="IssueNumber" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <asp:TextBox ID="IssueNumber" runat="server" MaxLength="2" Width="40px"></asp:TextBox>
            <asp:CustomValidator ID="IntlDebitValidator1" runat="server" Text="*" ValidationGroup="CreditCard"></asp:CustomValidator>
        </span>
    </div>
    <div id="trStartDate" runat="server" visible="true" class="field">
        <asp:Label ID="StartDateLabel" runat="server" Text="OR Start Date: " AssociatedControlID="StartDateMonth" CssClass="fieldheader"></asp:Label>
        <span class="fieldValue">
            <asp:dropdownlist ID="StartDateMonth" runat="server" ValidationGroup="IntlCard">
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
            <asp:dropdownlist ID="StartDateYear" Runat="server" ValidationGroup="IntlCard">
                <asp:ListItem Text="Year" Value=""></asp:ListItem>
            </asp:dropdownlist>
            <asp:CustomValidator ID="IntlDebitValidator2" runat="server" Text="*" ErrorMessage="Issue number or start date is required." ValidationGroup="CreditCard"></asp:CustomValidator>
            <asp:CustomValidator ID="StartDateValidator1" runat="server" ErrorMessage="You cannot select a start date in the future." 
                ControlToValidate="StartDateYear" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:CustomValidator>
        </span>
    </div>
    <div id="trSaveCard" runat="server" visible="false">
        <span class="fieldValue">
            <asp:CheckBox ID="SaveCard" runat="server" Text="Save my payment information" />
        </span>
    </div>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="ProfilesPH" runat="server" Visible="false" EnableViewState="true" ViewStateMode="Enabled">
     <div id="Div1" runat="server" visible="true" class="field">
        <asp:Label ID="ProfilesLabel" runat="server" Text="Select Payment: " AssociatedControlID="ProfilesList" CssClass="fieldheader"></asp:Label>
        <span class="fieldValue">
            <asp:DropDownList ID="ProfilesList" runat="server" DataTextField="Value" DataValueField="Key" OnSelectedIndexChanged="ProfilesList_SelectedIndexChanged" AutoPostBack="true" EnableViewState="true" ViewStateMode="Enabled"></asp:DropDownList>
        </span>
    </div>
    </asp:PlaceHolder>
    <div class="buttons">
        <asp:Button ID="CreditCardButton" runat="server" Text="Pay With Card" ValidationGroup="CreditCard" OnClick="CreditCardButton_Click" />
    </div>
</div>
<asp:Panel ID="HelpDialog" runat="server" Style="display:none;" CssClass="modalPopup">
    <asp:Panel ID="HelpDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
        <h3>CVV Help</h3>
        <div class="closeIcon" onclick="$find('PnlHelpPopup').hide();"></div>
    </asp:Panel>
    <div class="helpSection">
        <div>
            <h3>Discover, Visa, or MasterCard</h3>
            <p>
                Your card security code for your MasterCard, Visa or Discover 
                card is a three-digit number on the back of your credit card, 
                immediately following your main card number typically to the 
                right of the signature strip.
            </p>
            <div class="cvvVisa"></div>
        </div>
        <asp:Panel ID="AmexPanel" runat="server" CssClass="helpSection amexHelp">
            <h3>American Express</h3>
            <p>
                The card security code for your American Express card is a 
                four-digit number located on the front of your credit card, 
                to the right or left above your main credit card number.
            </p>
            <div class="cvvAmex"></div>
        </asp:Panel>
        <div class="modalPopupFooter"><asp:LinkButton ID="CloseButton" Text="Close" runat="server" EnableViewState="false"></asp:LinkButton></div>
    </div>
</asp:Panel>
<ajaxToolkit:ModalPopupExtender ID="HelpPopup" runat="server" 
    TargetControlID="HelpLink"
    PopupControlID="HelpDialog" 
    BackgroundCssClass="modalBackground"                         
    CancelControlID="CloseButton" 
    DropShadow="false"
    RepositionMode="None"
    BehaviorID="PnlHelpPopup"
    PopupDragHandleControlID="HelpDialogHeader" />