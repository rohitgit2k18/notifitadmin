<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Layouts/Mobile.master" CodeFile="ViewLicenseAgreement.aspx.cs" Inherits="AbleCommerce.Mobile.ViewLicenseAgreement" Title="View Agreement" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
	<asp:Panel ID="AgreementTextPanel" runat="server" CssClass="section agreementView">
		<div class="content">
			<asp:Literal ID="AgreementText" runat="server"></asp:Literal>
		</div>
		<div class="actions">
			<p align="center">
			<asp:HyperLink ID="OKLink" runat="server" Text="Close" CssClass="button hyperLinkButton" />
			<asp:HyperLink ID="AcceptLink" runat="server" Text="Accept" CssClass="button hyperLinkButton" />&nbsp;&nbsp;&nbsp;
			<asp:HyperLink ID="DeclineLink" runat="server" Text="Decline" CssClass="button hyperLinkButton" />
			</p>
		</div>
	</asp:Panel>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageFooter" />
