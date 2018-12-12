<%@ Page Title="Site Disclaimer" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="True" CodeFile="Disclaimer.aspx.cs" Inherits="AbleCommerce.Disclaimer" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="disclaimerPage" class="mainContentWrapper">
		<div class="section">
			<div class="pageHeader">
				<h1>Site Disclaimer</h1>
			</div>
			<div class="content">
				You have to agree the following disclaimer, terms and conditions:
			</div>
		</div>

		<div class="section">
			<table cellspacing="0" cellpadding="0" class="page" width="90%">
				<tr id="trDisclaimerMessage" runat="server">
					<td class="pageMain">
						<asp:Label ID="DisclaimerText" runat="server"></asp:Label><br />
						<br />
						<div align="center">
							<asp:Button ID="OkButton" runat="server" Text="I Accept" OnClick="OkButton_Click"
								OnClientClick="document.cookie ='SiteDisclaimerAccepted=True';return true;" />
						</div>
					</td>
				</tr>
				<tr id="trNoCookies" runat="server">
					<td class="pageMain">
						<asp:Label CssClass="errorCondition" ID="NoCookiesMessageLabel" runat="server" Text="Your browser does not support cookies or cookies are disabled. This site uses cookies to store information, please enable cookies otherwise you will not be able to use our site." />
					</td>
				</tr>
			</table>
		</div>
    </div>
</asp:Content>
