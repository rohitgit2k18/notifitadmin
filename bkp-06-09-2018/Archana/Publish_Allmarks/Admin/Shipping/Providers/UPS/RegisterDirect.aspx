<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._UPS.RegisterDirect" Title="Register for UPS" CodeFile="RegisterDirect.aspx.cs" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1>
                <asp:Label ID="Caption" runat="server" Text="UPS OnLine&reg; Tools Advanced Configuration"></asp:Label>
            </h1>
    	</div>
    </div>
    <div class="content">
        <p><asp:Label ID="InstructionText" runat="server" Text="You can enable Negotiated Rates and Address Validation using this page. Enabling Negotiated Rates within your shipping or rating systems allows you to view the most current and accurate rates for your UPS account. Only shippers approved to ship using negotiated rates can use negotiated rates. Contact your UPS representative before enabling this feature."></asp:Label></p>
        <table class="inputForm">
            <tr>
                <th>
                    <asp:Label ID="UserIdLabel" runat="server" Text="UPS User Id:"></asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="UserId" runat="server"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="UserIdRequired" runat="server" ControlToValidate="UserId" Text="required" Display="Dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="PasswordLabel" runat="server" Text="UPS Password:"></asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="Password" runat="server"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" Text="required" Display="Dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="AccessKeyLabel" runat="server" Text="Access:"></asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="AccessKey" runat="server"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="AccessKeyRequired" runat="server" ControlToValidate="AccessKey" Text="required" Display="Dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    If your UPS account have the Address Validation feature enabled, then you can enable the Address Validation feature using following options:
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="EnableAddressValidationLabel" runat="server" Text="Enable Address Validation:" AssociatedControlID="EnableAddressValidation" CssClass="toolTip" ToolTip="Indicate whether address validation services will be used."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:CheckBox ID="EnableAddressValidation" runat="server" />
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="AddressServiceTestUrlLabel" runat="server" Text="Address Service Test Url:" ToolTip="The URL to which requests are posted in Test Mode." />
                </th>
                <td>
				    <asp:TextBox Width="500" ID="AddressServiceTestUrl" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="AddressServiceLiveUrlLabel" runat="server" Text="Address Service Live Url:" ToolTip="The URL to which requests are posted in live Mode." />
                </th>
                <td>
				    <asp:TextBox Width="500" ID="AddressServiceLiveUrl" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="NextButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                    <asp:Button ID="CancelButton" runat="server" SkinID="CancelButton"  Text="Cancel" OnClick="CancelButton_Click" CausesValidation="false" />
                </td>
            </tr>
        </table>
        <p><asp:Label ID="UPSCopyRight" runat="server" Text="UPS brandmark, and the Color Brown are trademarks of United Parcel Service of America, Inc. All Rights Reserved." SkinID="Copyright"></asp:Label></p>
    </div>    
</asp:Content>