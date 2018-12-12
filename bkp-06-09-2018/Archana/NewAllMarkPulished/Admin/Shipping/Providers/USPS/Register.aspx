<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._USPS.Register" title="USPS Setup" CodeFile="Register.aspx.cs" %>
<asp:Content ID="Content" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1><asp:Localize ID="Caption" runat="server" Text="U.S. Postal Service&reg; Registration"></asp:Localize></h1>
	    </div>
    </div>
    <div class="grid_3">
        <div class="content" style="text-align:center">
            <asp:Image ID="Logo" runat="server" AlternateText="USPS Logo" />
        </div>
    </div>
    <div class="grid_9">
        <div class="content">
            <p>You must register with the U.S. Postal Service in order to enable online rate estimates and tracking. Please follow the  instructions below to complete this one-time setup process:</p>
			<ol>
			    <li>
			    Register with USPS to obtain your User Id.  You must do this step at the following USPS website:<br/>
			    <br/>
			    <a href="https://secure.shippingapis.com/Registration/" target="_blank" class="link">https://secure.shippingapis.com/Registration/</a><br/><br/>
                </li>
			    <li>
			    Contact the USPS ICCC (Internet Customer Care Center) and ask to have your User Id activated for 'Production' use:<br/>
			    <br/>
			    E-mail: <a href="mailto:icustomercare@USPS.com" class="link">icustomercare@USPS.com</a><br/>
			    Phone: 1-800-344-7779 (7AM to 11PM Eastern Time)<br/><br/>
                </li>
			    <li>
			    Once your account is activated, provide your User Id in the field below and click Finish.
                </li>
            </ol>
			<asp:ValidationSummary ID="ValidationSummary1" runat="server" />
			<table class="inputForm">
			    <tr>
			        <th>
			            <asp:Label ID="UserIdLabel" runat="server" Text="User ID:"></asp:Label>
			        </th>
			        <td>
			            <asp:TextBox ID="UserId" runat="server"></asp:TextBox>
			            <asp:RequiredFieldValidator ID="UserIdRequired" runat="server" 
			                ErrorMessage="User Id is required." Text="*" Display="Static" 
			                ControlToValidate="UserId"></asp:RequiredFieldValidator>
			        </td>
			    </tr>
			    <tr>
			        <td>&nbsp;</td>
			        <td>
			            <asp:Button ID="NextButton" runat="server" Text="Finish" OnClick="NextButton_Click" />
			            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
			        </td>
			    </tr>
			</table>
        </div>
    </div>
</asp:Content>