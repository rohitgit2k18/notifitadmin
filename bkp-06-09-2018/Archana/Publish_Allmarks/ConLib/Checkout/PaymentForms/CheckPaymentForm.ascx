<%@ Control Language="C#" AutoEventWireup="True" CodeFile="CheckPaymentForm.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.PaymentForms.CheckPaymentForm" ViewStateMode="Disabled" %>
<%@ Register assembly="wwhoverpanel" Namespace="Westwind.Web.Controls" TagPrefix="wwh" %>
<%--
<conlib>
<summary>Payment form for a check based payment</summary>
<param name="ValidationGroup" default="Check">Gets or sets the validation group for this control and all child controls.</param>
</conlib>
--%>
<table class="inputForm">
    <tr id="trAmount" runat="server" ViewStateMode="Enabled">
        <th>
            <asp:Label ID="AmountLabel" runat="server" Text="Amount:"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="Amount" runat="server" Text="" Width="60px" MaxLength="10" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AmountRequired" runat="server" Text="*"
                ErrorMessage="Amount is required." Display="Static" ControlToValidate="Amount"
                ValidationGroup="Check"></asp:RequiredFieldValidator>
            <asp:PlaceHolder ID="phAmount" runat="server"></asp:PlaceHolder>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="AccountHolderLabel" runat="server" Text="Name on Account:" AssociatedControlID="AccountHolder"></asp:Label>
	    </th>
        <td>
            <asp:TextBox id="AccountHolder" runat="server" MaxLength="50" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AccountHolderValidator" runat="server" ErrorMessage="You must enter the name on the account." 
                ControlToValidate="AccountHolder" Display="Static" Text="*" ValidationGroup="Check" ></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="BankNameLabel" runat="server" Text="Bank Name:" AssociatedControlID="BankName"></asp:Label>
	    </th>
        <td>
            <asp:TextBox id="BankName" runat="server" MaxLength="50" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="BankNameRequiredValidator" runat="server" ErrorMessage="You must enter the bank name." 
                ControlToValidate="BankName" Display="Static" Text="*" ValidationGroup="Check" ></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="RoutingNumberLabel" runat="server" Text="Routing Number:" AssociatedControlID="RoutingNumber"></asp:Label>
	    </th>
        <td>
            <asp:TextBox id="RoutingNumber" runat="server" MaxLength="9" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RoutingNumberValidator2" runat="server" ErrorMessage="You must enter a valid routing number." 
                ControlToValidate="RoutingNumber" Display="Static" Text="*" ValidationGroup="Check" ></asp:RequiredFieldValidator>
            <cb:RoutingNumberValidator ID="RoutingNumberValidator" runat="server" ErrorMessage="You must enter a valid routing number."
                ControlToValidate="RoutingNumber" Display="Static" Text="*" ValidationGroup="Check" ></cb:RoutingNumberValidator>
            <a href="#" onmouseover='CheckHoverLookupPanel.startCallback(event, "CHECKHELP", null, null);' onmouseout='CheckHoverLookupPanel.hide();' class="linked">Need help?</a>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="AccountNumberLabel" runat="server" Text="Account Number:" AssociatedControlID="AccountNumber"></asp:Label>
	    </th>
        <td>
            <asp:TextBox id="AccountNumber" runat="server" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AccountNumberValidator" runat="server" ErrorMessage="You must enter the account number." 
                ControlToValidate="AccountNumber" Display="Static" Text="*" ValidationGroup="Check" ></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <asp:Button ID="CheckButton" runat="server" Text="Pay by {0}" ValidationGroup="Check" OnClick="CheckButton_Click" />
        </td>
    </tr>
</table>
<wwh:wwHoverPanel ID="CheckHoverLookupPanel"
    runat="server" 
    serverurl="~/Checkout/CheckHelp.aspx"
    Navigatedelay="250"              
    scriptlocation="WebResource"
    style="display:none;"
    panelopacity="0.89" 
    shadowoffset="8"
    shadowopacity="0.18"
    PostBackMode="None"
    AdjustWindowPosition="true">
</wwh:wwHoverPanel>