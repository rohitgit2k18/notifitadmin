<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master"
    Inherits="AbleCommerce.Admin.Shipping.Providers._DHLInternational.Register" Title="DHLInternational&reg; Activation" CodeFile="Register.aspx.cs" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1>
                <asp:Label ID="Caption" runat="server" Text="DHL&reg; Activation"></asp:Label>
            </h1>
    	</div>
    </div>
    <div class="grid_3">
        <div class="content" style="text-align:center">
            <asp:Image ID="Logo" runat="server" AlternateText="DHL Logo" />
        </div>
    </div>
    <div class="grid_9">
        <div class="content">
            <p>With DHL, customers can get shipping rate estimates based on their shipping addresses and order weights.</p>
		    <p>In order to use DHL, you must provide your DHL username and password.</p>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
            <table class="inputForm">
                <tr>
                    <th>
                        <asp:Label ID="DHLUserIDLabel" runat="server" Text="DHL User ID:" AssociatedControlID="DHLUserID"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="DHLUserID" runat="server"></asp:TextBox><span class="requiredField">*</span>
                        <asp:RequiredFieldValidator ID="DHLUserIDValidator" runat="server" ErrorMessage="DHL User ID is required."
                            ControlToValidate="DHLUserID" Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="DHLPasswordLabel" runat="server" Text="DHL Password:" AssociatedControlID="DHLPassword"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="DHLPassword" runat="server"></asp:TextBox><span class="requiredField">*</span>
                        <asp:RequiredFieldValidator ID="DHLPasswordValidator" runat="server" ErrorMessage="DHL Password is required."
                            ControlToValidate="DHLPassword" Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                    </td>
                </tr>                    
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:Button ID="RegisterButton" runat="server" Text="Register" OnClick="RegisterButton_Click" />
						<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>