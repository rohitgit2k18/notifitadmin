<%@ Control Language="C#" AutoEventWireup="True" CodeFile="CreditCardPaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.CreditCardPaymentForm" ViewStateMode="Disabled" EnableViewState="true" %>
<%@ Register assembly="wwhoverpanel" Namespace="Westwind.Web.Controls" TagPrefix="wwh" %>
<%--
<conlib>
<summary>Payment form for a credit card based payment</summary>
<param name="ValidationGroup" default="CreditCard">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr id="trAmount" runat="server" visible="false" ViewStateMode="Enabled">
        <th>
            <asp:Label ID="AmountLabel" runat="server" Text="Amount:"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="Amount" runat="server" Text="" Width="60px" MaxLength="10" ValidationGroup="CreditCard"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AmountRequired" runat="server" Text="*"
                ErrorMessage="Amount is required." Display="Dynamic" ControlToValidate="Amount"
                ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
            <asp:PlaceHolder ID="phAmount" runat="server"></asp:PlaceHolder>
        </td>
    </tr>
    <asp:PlaceHolder ID="CardPH" runat="server" EnableViewState="true" ViewStateMode="Enabled">
    <tr>
        <th>
            <asp:Label ID="CardTypeLabel" runat="server" Text="Card Type:"></asp:Label>
        </th>
        <td>
            <asp:DropDownList ID="CardType" runat="server" DataTextField="Name" DataValueField="PaymentMethodId" ValidationGroup="CreditCard">
                <asp:ListItem></asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="CardTypeRequired" runat="server" Text="*"
                ErrorMessage="Card type is required." Display="Static" ControlToValidate="CardType"
                ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="CardNameLabel" runat="server" Text="Name on Card:" AssociatedControlID="CardName"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="CardName" runat="server" MaxLength="50" ValidationGroup="CreditCard" AutoCompleteType="Disabled"></asp:TextBox>
            <asp:RequiredFieldValidator ID="CardNameRequired" runat="server" 
                ErrorMessage="You must enter the name as it appears on the card." 
                ControlToValidate="CardName" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="CardNumberLabel" runat="server" Text="Card Number:" AssociatedControlID="CardNumber"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="CardNumber" runat="server" MaxLength="19" ValidationGroup="CreditCard"></asp:TextBox>
            <cb:CreditCardValidator ID="CardNumberValidator1" runat="server" 
                ControlToValidate="CardNumber" ErrorMessage="Invalid card number, or it does not match the selected card type."
                Display="Dynamic" Text="*" ValidationGroup="CreditCard"></cb:CreditCardValidator>
            <cb:RequiredRegularExpressionValidator ID="CardNumberValidator2" runat="server" ValidationExpression="\d{12,19}"
                ErrorMessage="Card number is required and should be between 12 and 19 digits (no dashes or spaces)." ControlToValidate="CardNumber"
                Display="Static" Text="*" Required="true" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="ExpirationLabel" runat="server" Text="Expiration:" AssociatedControlID="ExpirationMonth"></asp:Label>
        </th>
        <td>
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
    <tr id="trIntlCVV" runat="server" visible="true">
        <td colspan="2">
            <asp:Literal ID="IntlCVVCredit" runat="server" Text="For {0} cards, the Verification Code is required.  "></asp:Literal>
            <asp:Literal ID="IntlCVVDebit" runat="server" Text="For {0} cards the Verification Code is optional - enter the number only if present on your card."></asp:Literal>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="SecurityCodeLabel" runat="server" Text="Verification Code:" AssociatedControlID="SecurityCode"></asp:Label>
        </th>
        <td>
            <div class="securityCodeInput">
                <asp:TextBox ID="SecurityCode" runat="server" Columns="4" MaxLength="4" ValidationGroup="CreditCard" AutoCompleteType="Disabled"></asp:TextBox>
                <cb:RequiredRegularExpressionValidator ID="SecurityCodeValidator" runat="server" ValidationExpression="\d{3,4}"
                    ErrorMessage="Card security code should be a 3 or 4 digit number." ControlToValidate="SecurityCode"
                    Display="Dynamic" Text="*" Required="true" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
                <asp:CustomValidator ID="SecurityCodeValidator2" runat="server" Text="*" 
                    ErrorMessage="Card security code should be a 3 or 4 digit number." ValidationGroup="CreditCard"></asp:CustomValidator>
                <a href="#" onmouseover='CVVHoverLookupPanel.startCallback(event, "CVVHELP", null, null);' onmouseout='CVVHoverLookupPanel.hide();' class="linked">What's this?</a>
            </div>
        </td>
    </tr>
    <tr id="trIntlInstructions" runat="server" visible="true">
        <td>&nbsp;</td>
        <td>
            <asp:Literal ID="IntlInstructions" runat="server" Text="Issue number and/or Start Date only apply to {0} cards.  Enter the value(s) if present on your card."></asp:Literal>
        </td>
    </tr>
    <tr id="trIssueNumber" runat="server" visible="true">
        <th>
            <asp:Label ID="IssueNumberLabel" runat="server" Text="Issue Number:" AssociatedControlID="IssueNumber" CssClass="fieldHeader"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="IssueNumber" runat="server" MaxLength="2" Width="40px"></asp:TextBox>
            <asp:CustomValidator ID="IntlDebitValidator1" runat="server" Text="*" ValidationGroup="CreditCard"></asp:CustomValidator>
        </td>
    </tr>
    <tr id="trStartDate" runat="server" visible="true">
        <th>
            <asp:Label ID="StartDateLabel" runat="server" Text="OR Start Date: " AssociatedControlID="StartDateMonth" CssClass="fieldheader"></asp:Label>
        </th>
        <td>
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
        </td>
    </tr>
    <tr id="trSaveCard" runat="server" visible="false">
        <th></th>
        <td>
            <asp:CheckBox ID="SaveCard" runat="server" Text="Save my payment information" />
        </td>
    </tr>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="ProfilesPH" runat="server" Visible="false" EnableViewState="true" ViewStateMode="Enabled">
    <tr>
        <th>
            <asp:Label ID="ProfilesLabel" runat="server" Text="Select Payment: " AssociatedControlID="ProfilesList" CssClass="fieldheader"></asp:Label>
        </th>
        <td>
            <asp:DropDownList ID="ProfilesList" runat="server" DataTextField="Value" DataValueField="Key" OnSelectedIndexChanged="ProfilesList_SelectedIndexChanged" AutoPostBack="true" EnableViewState="true" ViewStateMode="Enabled"></asp:DropDownList>
        </td>
    </tr>
    </asp:PlaceHolder>
    <tr>
        <td>&nbsp;</td>
        <td>
            <asp:Button ID="CreditCardButton" runat="server" Text="Pay With Card" ValidationGroup="CreditCard" OnClick="CreditCardButton_Click" />
            <asp:Button ID="CompleteButton" runat="server" Text="Complete Order" ValidationGroup="CreditCard" OnClick="CompleteButton_Click" Visible="false" />
        </td>
    </tr>
</table>
<wwh:wwHoverPanel ID="CVVHoverLookupPanel"
    runat="server" 
    serverurl="~/Checkout/CVVHelp.aspx"
    Navigatedelay="100"              
    scriptlocation="WebResource"
    style="display:none;"
    panelopacity="0.89" 
    shadowoffset="8"
    shadowopacity="0.18"
    PostBackMode="None"
    AdjustWindowPosition="true">
</wwh:wwHoverPanel>
<asp:PlaceHolder ID="BootstrapPopover" runat="server" Visible="false">
<script type="text/javascript">
    $('a.linked').attr('onmouseover', '');
    $('a.linked').attr('onmouseout', '');
    $('a.linked').popover({
        html: true,
        trigger: 'manual',
        content: function () {
            return $.ajax({
                url: 'cvvhelp.aspx',
                dataType: 'html',
                async: false
            }).responseText;
        }
    }).click(function (e) {
        $(this).popover('toggle');
    });
</script>
</asp:PlaceHolder>