<%@ Page Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="ViewReadme.aspx.cs" Inherits="AbleCommerce.Mobile.ViewReadme" Title="View Readme" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
	<asp:Panel ID="ReadmeTextPanel" runat="server" CssClass="agreementView">
		<div class="textContent">
			<asp:Literal ID="ReadmeText" runat="server"></asp:Literal>
		</div>
		<div class="actions">
			<p align="center">
			<asp:HyperLink ID="OkButton" runat="server" Text="Close" CssClass="button hyperLinkButton" />
			</p>
		</div>
	</asp:Panel>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageFooter" />