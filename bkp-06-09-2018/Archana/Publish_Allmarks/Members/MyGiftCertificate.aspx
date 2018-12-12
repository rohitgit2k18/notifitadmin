<%@ Page Title="Print Gift Certificate" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MyGiftCertificate.aspx.cs" Inherits="AbleCommerce.Members.MyGiftCertificate" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_giftCertificatePage" class="mainContentWrapper">
		<div class="section">
			<div class="pageHeader noPrint">
				<h1><asp:Localize ID="Caption" runat="server" Text="Gift Certificate - {0}, Order #{1}"></asp:Localize></h1>        
			</div>

			<div class="actions noPrint">
				<asp:LinkButton ID="PrintButton" runat="server" Text="Print" CssClass="button linkButton" OnClientClick="window.print();return false;" />
				<asp:LinkButton ID="BackButton" runat="server" Text="Back" CssClass="button linkButton" OnClick="BackButton_Click" />     
			</div>

			<div class="content">
			<table align="center" class="inputForm" cellpadding="0" cellspacing="0">
				<tr>
					<th colspan="2" style="border-bottom:solid 1px">
						<asp:Localize ID="GiftCertificateSummayCaption" runat="server" Text="GIFT CERTIFICATE DETAILS"></asp:Localize>
					</th>
				</tr>
				<tr>
					<th class="rowHeader">Name:</th>
					<td><asp:Label runat="server" ID="Name"></asp:Label></td>
				</tr>
				<tr>
					<th class="rowHeader">Status Description:</th>
					<td><asp:Label runat="server" ID="Description" ></asp:Label></td>
				</tr>
				<tr>
					<th class="rowHeader">Certificate Number:</th>
					<td><asp:Label runat="server" ID="Serial" ></asp:Label></td>
				</tr>
				 <tr>
					<th class="rowHeader">Balance:</th>
					<td><asp:Label runat="server" ID="Balance" ></asp:Label></td>
				</tr>
				<tr>
					<th class="rowHeader">Expiration Date:</th>
					<td><asp:Label runat="server" ID="Expires" ></asp:Label></td>
				</tr>
			</table>
			</div>
		</div>
    </div>
</div>
</asp:Content>
