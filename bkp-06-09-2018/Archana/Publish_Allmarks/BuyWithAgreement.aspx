<%@ Page Title="License Agreement" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="True" CodeFile="BuyWithAgreement.aspx.cs" Inherits="AbleCommerce.BuyWithAgreement" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="agreementPage" class="mainContentWrapper">
		<div class="section">
			<div class="content">
			<asp:Label ID="AgreementText" runat="server" EnableViewState="false"></asp:Label>
			</div>
		</div>
		<div align="actions">
			<asp:Localize ID="InstructionText" runat="server" Text="You must accept the license agreement to continue." EnableViewState="false"></asp:Localize><br /><br />
			<asp:Button ID="AcceptButton" runat="server" Text="Accept" OnClick="AcceptButton_Click" EnableViewState="false" />
			&nbsp;<asp:Button ID="DeclineButton" runat="server" Text="Decline" OnClick="DeclineButton_Click" EnableViewState="false" />
		</div>
    </div>
</asp:Content>
