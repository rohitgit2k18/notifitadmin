<%@ Page Title="CanadaPost Activation" Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._CanadaPost.Register" CodeFile="Register.aspx.cs" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
	<div class="pageHeader">
		<div class="caption">
			<h1><asp:Localize ID="Caption" runat="server" Text="CanadaPost Activation"></asp:Localize></h1>
		</div>
	</div>
    <div class="grid_3">
        <div class="content" style="text-align:center">
            <asp:Image ID="Logo" runat="server" AlternateText="CanadaPost Logo" />
        </div>
    </div>
    <div class="grid_9">
        <div class="content">
            <p>With CanadaPost, customers can get shipping rate estimates based on their shipping addresses and order weights.</p>
		    <p>In order to use CanadaPost, you must provide your Merchant CPC ID.  If you need an account you must contact CanadaPost to set up your Sell Online account and request a Merchant Id for a shopping cart solution.</p>
            <table class="inputForm">
                <tr>
                    <th>
                        <asp:Label ID="MerchantIdLabel" runat="server" Text="Merchant CPC ID:" AssociatedControlID="MerchantId"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="MerchantId" runat="server"></asp:TextBox><span class="requiredField">*</span>
                        <asp:RequiredFieldValidator ID="MerchantIdValidator" runat="server"
                            ErrorMessage="Merchant CPC ID is required." ControlToValidate="MerchantId"
                            Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:Button ID="RegisterButton" runat="server" Text="Finish" OnClick="RegisterButton_Click" />
						<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false"/>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>