<%@ Control Language="C#" AutoEventWireup="True" CodeFile="CheckPaymentForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Checkout.PaymentForms.CheckPaymentForm" ViewStateMode="Disabled" %>
<div class="inputForm">
    <div id="trAmount" runat="server" ViewStateMode="Enabled" class="field">
        <asp:Label ID="AmountLabel" runat="server" Text="Amount:" CssClass="fieldHeader"></asp:Label>
        <span class="fieldValue">
            <asp:TextBox ID="Amount" runat="server" Text="" Width="60px" MaxLength="10" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AmountRequired" runat="server" Text="*"
                ErrorMessage="Amount is required." Display="Static" ControlToValidate="Amount"
                ValidationGroup="Check"></asp:RequiredFieldValidator>
            <asp:PlaceHolder ID="phAmount" runat="server"></asp:PlaceHolder>
        </span>
    </div>
    <div class="field">
        <asp:Label ID="AccountHolderLabel" runat="server" Text="Name on Account:" AssociatedControlID="AccountHolder" CssClass="fieldHeader"></asp:Label>
	    <span class="fieldValue">
            <asp:TextBox id="AccountHolder" runat="server" MaxLength="50" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AccountHolderValidator" runat="server" ErrorMessage="You must enter the name on the account." 
                ControlToValidate="AccountHolder" Display="Static" Text="*" ValidationGroup="Check" ></asp:RequiredFieldValidator>
        </span>
    </div>
    <div class="field">
        <asp:Label ID="BankNameLabel" runat="server" Text="Bank Name:" AssociatedControlID="BankName" CssClass="fieldHeader"></asp:Label>
	    <span class="fieldValue">
            <asp:TextBox id="BankName" runat="server" MaxLength="50" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="BankNameRequiredValidator" runat="server" ErrorMessage="You must enter the bank name." 
                ControlToValidate="BankName" Display="Static" Text="*" ValidationGroup="Check" ></asp:RequiredFieldValidator>
        </span>
    </div>
    <div class="field">
        <asp:Label ID="RoutingNumberLabel" runat="server" Text="Routing Number:" AssociatedControlID="RoutingNumber" CssClass="fieldHeader"></asp:Label>
	    <span class="fieldValue">
            <asp:TextBox id="RoutingNumber" runat="server" MaxLength="9" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RoutingNumberValidator2" runat="server" ErrorMessage="You must enter a valid routing number." 
                ControlToValidate="RoutingNumber" Display="Static" Text="*" ValidationGroup="Check" ></asp:RequiredFieldValidator>
            <cb:RoutingNumberValidator ID="RoutingNumberValidator" runat="server" ErrorMessage="You must enter a valid routing number."
                ControlToValidate="RoutingNumber" Display="Static" Text="*" ValidationGroup="Check" ></cb:RoutingNumberValidator>
            <asp:LinkButton ID="HelpLink" runat="server" Text="Need help?" EnableViewState="false" OnClientClick="return false;" CssClass="linked"></asp:LinkButton>
        </span>
    </div>
    <div class="field">
        <asp:Label ID="AccountNumberLabel" runat="server" Text="Account Number:" AssociatedControlID="AccountNumber" CssClass="fieldHeader"></asp:Label>
	    <span class="fieldValue">
            <asp:TextBox id="AccountNumber" runat="server" ValidationGroup="Check"></asp:TextBox>
            <asp:RequiredFieldValidator ID="AccountNumberValidator" runat="server" ErrorMessage="You must enter the account number." 
                ControlToValidate="AccountNumber" Display="Static" Text="*" ValidationGroup="Check" ></asp:RequiredFieldValidator>
        </span>
    </div>
    <div class="buttons">
        <asp:Button ID="CheckButton" runat="server" Text="Pay by {0}" ValidationGroup="Check" OnClick="CheckButton_Click" />
    </div>
</div>
<asp:Panel ID="HelpDialog" runat="server" Style="display:none;" CssClass="modalPopup">
    <asp:Panel ID="HelpDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
        <h3>Check Help</h3>
        <div class="closeIcon" onclick="$find('PnlHelpPopup').hide();"></div>
    </asp:Panel>
    <div class="helpSection">
        The routing number and account number can be found by looking at one of your checks.
        <div class="checkHelp"></div>
    </div>
    <div class="modalPopupFooter"><asp:LinkButton ID="CloseButton" Text="Close" runat="server" EnableViewState="false"></asp:LinkButton></div>
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