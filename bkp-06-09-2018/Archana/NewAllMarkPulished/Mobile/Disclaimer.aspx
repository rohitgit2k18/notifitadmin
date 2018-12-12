<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="Disclaimer.aspx.cs" Inherits="AbleCommerce.Mobile.Disclaimer" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="disclaimerPage" class="mainContentWrapper">
		<div class="section">
			<div class="header">
				<h2>Site Disclaimer</h2>
			</div>
			<div class="content descSummary">
               <span class="summary">You have to agree the following disclaimer, terms and conditions: </span>
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
								OnClientClick="document.cookie ='SiteDisclaimerAccepted=True;path=/;';return true;" />
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
