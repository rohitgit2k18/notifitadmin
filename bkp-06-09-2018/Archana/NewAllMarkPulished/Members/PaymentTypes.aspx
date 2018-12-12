<%@ Page Title="Payment Types" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="PaymentTypes.aspx.cs" Inherits="AbleCommerce.Members.PaymentTypes" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".rowSelect").click(function () {
                $('.hdnRowHandle input').val("false");
                $('#' + this.id + '_wrap input').val("true");
            });
        });
    </script>
    <div id="accountPage"> 
    <div id="account_payment_types" class="mainContentWrapper">
        <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
        <div class="tabpane">
            <asp:Panel ID="ReviewsPanel" runat="server" CssClass="section profilePanel">
                <asp:Panel ID="ReviewsCaptionPanel" runat="server" CssClass="header">
                    <h2><asp:Localize ID="ReviewsCaption" runat="server" Text="" /></h2>
                </asp:Panel>
                <div class="column_1">
                    <div class="section">
                        <div class="content">
                            <asp:PlaceHolder ID="SubscriptionProfilesNoticePH" runat="server" Visible="false" EnableViewState="false">
                                <p><asp:Label ID="SubscriptionProfilesNoticeLabel" runat="server" Text="* Recurring subscription purchases are limited to <b>{0}</b> profiles only." EnableViewState="false"></asp:Label></p>
                            </asp:PlaceHolder>
                            <asp:Label ID="DeleteMessage" runat="server" CssClass="errorCondition" EnableViewState="false"></asp:Label>
                            <asp:Repeater ID="CardsList" runat="server" OnItemCommand="CardsList_ItemCommand">
                                <HeaderTemplate>
                                     <div class="paymentList" cellpadding="0" cellspacing="0">
                                </HeaderTemplate>
                                <ItemTemplate>

                                    <div class="mainContainer">
                                    <asp:PlaceHolder ID="SelectPH" runat="server" Visible='<%#ShowSelectDefault() %>'>
                                    <div  class="innerLeft">
                                        <input type="radio" name="CCards" id='r<%#Container.ItemIndex %>c1' class="rowSelect" <%#IsDefaultProfile((int)Eval("Id")) ? "checked" : "" %> />
                                        <asp:HiddenField ID="HDNProfileId" runat="server" Value='<%#Eval("Id") %>' />
                                        <span id='r<%#Container.ItemIndex %>c1_wrap' style="display:none;" class="hdnRowHandle">
                                            <asp:HiddenField ID="HDNSelected" runat="server" />
                                        </span>
                                    </div>
                                    </asp:PlaceHolder>

                                    <div class="innerRight">
                                    <div class="paymentItem">
                                        <div class="reference">
                                            <%#Eval("InstrumentType") %> ending in <%#Eval("ReferenceNumber") %>
                                        </div>
                                        <asp:PlaceHolder ID="DefaultPaymentPH" runat="server" Visible='<%#IsDefaultProfile((int)Eval("Id")) %>'>
                                        <div class="deafultPayment">
                                            <i>Default</i>
                                        </div>
                                        </asp:PlaceHolder>
                                        <div class="expiration">
                                            <b>Expiration: <asp:Label ID="ExpiryLabel" runat="server" CssClass='<%#(DateTime)Eval("Expiry") < DateTime.Now ? "errorCondition" : string.Empty %>' Text='<%#GetExpiration(Container.DataItem) %>'></asp:Label></b>
                                        </div>
                                        <asp:PlaceHolder ID="InUsePH" runat="server" Visible='<%#!CanBeDeleted((int)Eval("Id")) %>'>
                                        <div class="expiration">
                                            <i>(In use for a subscription)</i>
                                        </div>
                                        </asp:PlaceHolder>
                                        <asp:Panel ID="ButtonsPanel" runat="server" CssClass="deleteLink">
                                            <asp:Button ID="DeletePaymentButton" runat="server" Text="Remove" CommandName="DELETE_PROFILE" CommandArgument='<%#Eval("Id") %>' OnClientClick="return confirm('Are you sure you want to delete?');" Visible='<%#CanBeDeleted((int)Eval("Id")) %>' />
                                            <asp:Button ID="EditButton" runat="server" Text="Edit" CommandName="EDIT_PROFILE" CommandArgument='<%#Eval("Id") %>' />
                                        </asp:Panel>
                                        <div class="clear"></div>
                                        </div>
                                    </div>
                                    </div>                            
                                </ItemTemplate>
                                <FooterTemplate>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>
                            <asp:Panel ID="NoPaymentTypePanel" runat="server" Visible="false" CssClass="noPayments">
                                No payment types available to list.
                            </asp:Panel>
                            <div class="clear"></div>
                            <div>
                               <asp:Button ID="SetDefaultButton" runat="server" Text="Set Default" OnClick="SetDefaultButton_Click" />
                                <div id="InstructionText" class="instructionText" runat="server">Select your default payment type.</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="column_2">
                    <asp:ValidationSummary ID="PaymentValidationSummary" runat="server" ValidationGroup="CreditCard" />
                    <div class="inputForm">
                        <div class="mainContainer">
                            <div class="rowHeader">
                                <asp:Label ID="CardTypeLabel" runat="server" Text="Card Type:"></asp:Label>
                            </div>
                            <div class="inputFied">
                                <asp:DropDownList ID="CardType" runat="server" DataTextField="Name" DataValueField="PaymentMethodId" ValidationGroup="CreditCard">
                                    <asp:ListItem></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="CardTypeRequired" runat="server" Text="*"
                                    ErrorMessage="Card type is required." Display="Static" ControlToValidate="CardType"
                                    ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div>
                            <div class="rowHeader">
                                <asp:Label ID="CardNameLabel" runat="server" Text="Name on Card:" AssociatedControlID="CardName"></asp:Label>
                            </div>
                            <div class="inputFied">
                                <asp:TextBox ID="CardName" runat="server" MaxLength="50" ValidationGroup="CreditCard" AutoCompleteType="Disabled" Width="135" SkinID="CardName"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="CardNameRequired" runat="server" 
                                    ErrorMessage="You must enter the name as it appears on the card." 
                                    ControlToValidate="CardName" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div>
                            <div class="rowHeader">
                                <asp:Label ID="CardNumberLabel" runat="server" Text="Card Number:" AssociatedControlID="CardNumber"></asp:Label>
                            </div>
                            <div class="inputFied">
                                <asp:TextBox ID="CardNumber" runat="server" MaxLength="19" ValidationGroup="CreditCard" Width="135" SkinID="CardNumber"></asp:TextBox>
                                <cb:CreditCardValidator ID="CardNumberValidator1" runat="server" 
                                    ControlToValidate="CardNumber" ErrorMessage="You must enter a valid card number."
                                    Display="Dynamic" Text="*" ValidationGroup="CreditCard"></cb:CreditCardValidator>
                                <cb:RequiredRegularExpressionValidator ID="CardNumberValidator2" runat="server" ValidationExpression="\d{12,19}"
                                    ErrorMessage="Card number is required and should be between 12 and 19 digits (no dashes or spaces)." ControlToValidate="CardNumber"
                                    Display="Static" Text="*" Required="true" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
                            </div>
                        </div>
                        <div>
                            <div class="rowHeader">
                                <asp:Label ID="ExpirationLabel" runat="server" Text="Expiration:" AssociatedControlID="ExpirationMonth"></asp:Label>
                            </div>
                            <div class="inputFied">
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
                            </div>
                        </div>
                        <div id="trIntlCVV" runat="server" visible="true" class="inputFied">
                            <div>
                                <asp:Literal ID="IntlCVVCredit" runat="server" Text="For {0} cards, the Verification Code is required.  "></asp:Literal>
                                <asp:Literal ID="IntlCVVDebit" runat="server" Text="For {0} cards the Verification Code is optional - enter the number only if present on your card."></asp:Literal>
                            </div>
                        </div>
                        <div>
                            <div class="rowHeader">
                                <asp:Label ID="SecurityCodeLabel" runat="server" Text="Verification Code:" AssociatedControlID="SecurityCode"></asp:Label>
                            </div>
                            <div class="inputFied">
                                <div class="securityCodeInput">
                                    <asp:TextBox ID="SecurityCode" runat="server" Columns="4" MaxLength="4" ValidationGroup="CreditCard" AutoCompleteType="Disabled"></asp:TextBox>
                                    <cb:RequiredRegularExpressionValidator ID="SecurityCodeValidator" runat="server" ValidationExpression="\d{3,4}"
                                        ErrorMessage="Card security code should be a 3 or 4 digit number." ControlToValidate="SecurityCode"
                                        Display="Dynamic" Text="*" Required="true" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
                                    <asp:CustomValidator ID="SecurityCodeValidator2" runat="server" Text="*" 
                                        ErrorMessage="Card security code should be a 3 or 4 digit number." ValidationGroup="CreditCard"></asp:CustomValidator>
                                </div>
                            </div>
                        </div>
                        <div id="trIntlInstructions" runat="server" visible="true">
                            <div>&nbsp;</div>
                            <div>
                                <asp:Literal ID="IntlInstructions" runat="server" Text="Issue number and/or Start Date only apply to {0} cards.  Enter the value(s) if present on your card."></asp:Literal>
                            </div>
                        </div>
                        <div id="trIssueNumber" runat="server" visible="true">
                            <div class="rowHeader">
                                <asp:Label ID="IssueNumberLabel" runat="server" Text="Issue Number:" AssociatedControlID="IssueNumber" CssClass="fieldHeader"></asp:Label>
                            </div>
                            <div class="inputFied">
                                <asp:TextBox ID="IssueNumber" runat="server" MaxLength="2" Width="40px"></asp:TextBox>
                                <asp:CustomValidator ID="IntlDebitValidator1" runat="server" Text="*" ValidationGroup="CreditCard"></asp:CustomValidator>
                            </div>
                        </div>
                        <div id="trStartDate" runat="server" visible="true">
                            <div class="rowHeader">
                                <asp:Label ID="StartDateLabel" runat="server" Text="OR Start Date: " AssociatedControlID="StartDateMonth" CssClass="fieldheader"></asp:Label>
                            </div>
                            <div class="inputFied">
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
                            </div>
                        </div>
                        <div class="clear"></div>
                        <div>
                            <div class="btn">
                                <asp:Button ID="SaveCardButton" runat="server" Text="Save Card" ValidationGroup="CreditCard" OnClick="SaveCardButton_Click" />
                            </div>
                        </div>
                        <div>
                            <div class="error">
                                <asp:Label ID="ErrorMessage" runat="server" EnableViewState="false" CssClass="errorCondition"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="clear"></div>
            </asp:Panel>
        </div>
    </div>
</div>
</asp:Content>