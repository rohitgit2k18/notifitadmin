<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.CheckoutRegisterButtonDialog" CodeFile="CheckoutRegisterButtonDialog.ascx.cs" %>
<%--
<conlib>
<summary>Displays a register button for anonymous users during checkout process.</summary>
</conlib>
--%>
<div class="widget checkoutRegisgerButton">
  <div class="innerSection">
	<div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="New Customers"></asp:Localize></h2>
    </div>
    <div class="content nofooter">
		<div class="dialogSection">
			<table class="inputForm" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<asp:Label ID="InstructionText" runat="server" EnableViewState="False" Text="If this is your first purchase from {0}, click Continue to proceed."></asp:Label>
					</td>
				</tr>
				<tr>
					<td>
						<br /><asp:Button ID="RegisterButton" runat="server" Text="Continue" OnClick="RegisterButton_Click" />
					</td>
				</tr>
			</table>
		</div>
    </div>
  </div>
</div>
