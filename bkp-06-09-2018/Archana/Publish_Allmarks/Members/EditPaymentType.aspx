<%@ Page Title="Edit Payment Type" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="EditPaymentType.aspx.cs" Inherits="AbleCommerce.Members.EditPaymentType" %>

<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" runat="Server">
    <div id="accountPage">
        <div id="account_payment_types" class="mainContentWrapper">
            <div class="section">
                <div class="content">
                    <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                    <asp:Panel ID="EditPanel" runat="server" CssClass="tabpane">
                        <br />
                        <asp:Label ID="SuccessMessage" runat="server" CssClass="goodCondition" EnableViewState="false" Text="Profile updated successfully at {0}." Visible="false"></asp:Label>
                        <asp:Label ID="ErrorMessage" runat="server" CssClass="errorCondition" EnableViewState="false" Text="Somthing went wrong, unable to update profile." Visible="false"></asp:Label>
                        <table class="inputForm" width="auto">
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="CardTypeLabel" runat="server" Text="Card Type:"></asp:Label>
                                </th>
                                <td>
                                    <asp:Label ID="CardType" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="CardNameLabel" runat="server" Text="Name on Card:" AssociatedControlID="CardName"></asp:Label>
                                </th>
                                <td>
                                    <asp:Label ID="CardName" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="CardNumberLabel" runat="server" Text="Card Number:" AssociatedControlID="CardNumber"></asp:Label>
                                </th>
                                <td>
                                    <asp:Label ID="CardNumber" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="ExpirationLabel" runat="server" Text="Expiration:" AssociatedControlID="ExpirationMonth"></asp:Label>
                                </th>
                                <td>
                                    <asp:DropDownList ID="ExpirationMonth" runat="server" ValidationGroup="CreditCard">
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
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="MonthValidator" runat="server" ErrorMessage="You must select the expiration month."
                                        ControlToValidate="ExpirationMonth" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
                                    <asp:DropDownList ID="ExpirationYear" runat="server" ValidationGroup="CreditCard">
                                        <asp:ListItem Text="Year" Value=""></asp:ListItem>
                                    </asp:DropDownList>
                                    <cb:ExpirationDropDownValidator ID="ExpirationDropDownValidator1" runat="server"
                                        Display="Dynamic" ErrorMessage="You must enter an expiration date in the future."
                                        MonthControlToValidate="ExpirationMonth" YearControlToValidate="ExpirationYear"
                                        Text="*" ValidationGroup="CreditCard"></cb:ExpirationDropDownValidator>
                                    <asp:RequiredFieldValidator ID="YearValidator" runat="server" ErrorMessage="You must select the expiration year."
                                        ControlToValidate="ExpirationYear" Display="Static" Text="*" ValidationGroup="CreditCard"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <th class="rowHeader">
                                    <asp:Label ID="SecurityCodeLabel" runat="server" Text="Verification Code:" AssociatedControlID="SecurityCode"></asp:Label>
                                </th>
                                <td>
                                    <div class="securityCodeInput">
                                        <asp:TextBox ID="SecurityCode" runat="server" Columns="4" MaxLength="4" ValidationGroup="CreditCard" AutoCompleteType="Disabled"></asp:TextBox>
                                        <cb:RequiredRegularExpressionValidator ID="SecurityCodeValidator" runat="server" ValidationExpression="\d{3,4}"
                                            ErrorMessage="Card security code should be a 3 or 4 digit number." ControlToValidate="SecurityCode"
                                            Display="Dynamic" Text="*" Required="false" ValidationGroup="CreditCard"></cb:RequiredRegularExpressionValidator>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:Button ID="UpdateButton" runat="server" Text="Update" ValidationGroup="CreditCard" OnClick="UpdateButton_Click" />
                                    <asp:HyperLink ID="CloseLink" runat="server" NavigateUrl="~/Members/PaymentTypes.aspx" CssClass="button" Text="Close"></asp:HyperLink>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <div class="clear"></div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
