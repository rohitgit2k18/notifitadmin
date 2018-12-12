<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.UserControls.AVSHelpDialog" CodeFile="AVSHelpDialog.ascx.cs" %>
<table class="section" cellspacing="0">
    <caption>
        <asp:Label ID="Caption" runat="server" Text="AVS Codes"></asp:Label>
    </caption>
	<tr>
		<td class="InstructionText" colspan="3">
            <asp:Label ID="DomesticInstructionText" runat="server" Text="The following codes are returned by the address verification system for US based transactions."></asp:Label>
		</td>
	</tr>
	<tr>
		<th>
			Code
		</th>
		<th>
			Summary
		</th>
		<th>
			Explanation
		</th>
	</tr>
	<tr>
		<td align="center">A</td>
		<td>Partial Match</td>
		<td>Street Address matches, ZIP does not.</td>
	</tr>
	<tr>
		<td align="center">E</td>
		<td>Invalid</td>
		<td>AVS error or data invalid.</td>
	</tr>
	<tr>
		<td align="center">N</td>
		<td>No Match</td>
		<td>No Match on Street Address or ZIP.</td>
	</tr>
	<tr>
		<td align="center">R</td>
		<td>Retry</td>
		<td>AVS System unavailable or timed out.</td>
	</tr>
	<tr>
		<td align="center">S</td>
		<td>Not Supported</td>
		<td>U.S. issuing bank does not support AVS.</td>
	</tr>
	<tr>
		<td align="center">U</td>
		<td>System Unavailable</td>
		<td>Address information unavailable.</td>
	</tr>
	<tr>
		<td align="center">W</td>
		<td>Partial Match</td>
		<td>9 digit ZIP matches, Address (Street) does not.</td>
	</tr>
	<tr>
		<td align="center">X</td>
		<td>Match</td>
		<td>Street Address and 9 digit ZIP match.</td>
	</tr>
	<tr>
		<td align="center">Y</td>
		<td>Match</td>
		<td>Street Address and 5 digit ZIP match.</td>
	</tr>
	<tr>
		<td align="center">Z</td>
		<td>Partial Match</td>
		<td>5 digit ZIP matches, Street Address does not.</td>
	</tr>
	<tr>
		<td class="InstructionText" colspan="3">
            <asp:Label ID="InternationalInstructionText" runat="server" Text="The following codes are returned by the address verification system for US based transactions."></asp:Label>
		</td>
	</tr>
	<tr>
		<th>
			Code
		</th>
		<th>
			Summary
		</th>
		<th>
			Explanation
		</th>
	</tr>
	<tr>
		<td align="center">B</td>
		<td>Partial Match</td>
		<td>Street address matches, but postal code not verified.</td>
	</tr>
	<tr>
		<td align="center">C</td>
		<td>No Match</td>
		<td>Street address and postal code not verified.</td>
	</tr>
	<tr>
		<td align="center">D</td>
		<td>Match</td>
		<td>Street address and postal code both match.</td>
	</tr>
	<tr>
		<td align="center">G</td>
		<td>Not Supported</td>
		<td>Non-U.S. issuing bank does not support AVS.</td>
	</tr>
	<tr>
		<td align="center">I</td>
		<td>No Match</td>
		<td>Address information not verified.</td>
	</tr>
	<tr>
		<td align="center">M</td>
		<td>Match</td>
		<td>Street address and postal code both match.</td>
	</tr>
	<tr>
		<td align="center">P</td>
		<td>Partial Match</td>
		<td>Postal code matches, but street address not verified.</td>
	</tr>
	<tr>
		<td align="center">S</td>
		<td>Not Supported</td>
		<td>U.S. issuing bank does not support AVS.</td>
	</tr>
	<tr>
		<td align="center">U</td>
		<td>System Unavailable</td>
		<td>Address information unavailable.</td>
	</tr>
</table>
