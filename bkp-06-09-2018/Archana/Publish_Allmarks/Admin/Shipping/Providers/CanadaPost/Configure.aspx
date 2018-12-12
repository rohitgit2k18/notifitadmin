<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._CanadaPost.Configure" title="Configure CanadaPost&reg;" CodeFile="Configure.aspx.cs" %>
<%@ Register Src="../ProviderShipMethods.ascx" TagName="ShipMethods" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1>Configure CanadaPost&reg;</h1>
	    </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="content">
                <p><asp:Label id="InstructionText" runat="server" Text="Specify the CanadaPost configuration options below."></asp:Label></p>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Configuration has been saved at {0:t}." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="MerchantIdLabel" runat="server" Text="Merchant CPC ID:" ToolTip="This is your CanadaPost Merchant CPC ID." AssociatedControlID="MerchantId" />
                        </th>
                        <td>
				            <asp:TextBox ID="MerchantId" runat="server"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="MerchantIdValidator" runat="server"
                                ErrorMessage="Merchant CPC ID is required." ControlToValidate="MerchantId"
                                Text="*" Display="Dynamic"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="EnablePackagingLabel" runat="server" Text="Enable Packaging:" ToolTip="If the weight of an order exceeds the specified maximum weight, should it be broken into multiple packages so that rates can be calculated?" AssociatedControlID="EnablePackaging" />
                        </th>
                        <td>
                            <asp:CheckBox ID="EnablePackaging" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="MaxWeightLabel" runat="server" Text="Maximum Weight:" ToolTip="Maximum package weight to use when requesting rates from the carrier." AssociatedControlID="MaxWeight" />
                        </th>
                        <td>
				            <asp:TextBox ID="MaxWeight" runat="server" Width="60"></asp:TextBox> kgs
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="MinWeightLabel" runat="server" Text="Minimum Weight:" ToolTip="Minimum package weight to use when requesting rates from the carrier." AssociatedControlID="MinWeight" />
                        </th>
                        <td>
					        <asp:TextBox ID="MinWeight" runat="server" Width="60"></asp:TextBox> kgs
                        </td>
                    </tr>
					<tr>
                        <th>
                            <cb:ToolTipLabel ID="LiveServerURLLabel" runat="server" Text="Rating URL:" ToolTip="The URL used for rating requests." AssociatedControlID="LiveServerURL" />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="LiveServerURL" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TrackingURLLabel" runat="server" Text="Tracking URL:" ToolTip="The URL used for tracking requets. {0} is substituted with the tracking number at the time of request." />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="TrackingURL" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="UseTestModeLabel" runat="server" Text="Test Mode:" ToolTip="When Test Mode is enabled, rate requests are sent to test server." />
                        </th>
                        <td>
                            <asp:CheckBox ID="UseTestMode" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TestServerURLLabel" runat="server" Text="Test Server URL:" ToolTip="The URL to which requests are posted in Test Mode." />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="TestServerURL" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="UseDebugModeLabel" runat="server" Text="Debug Mode:" ToolTip="When debug mode is enabled, all messages sent to and received from the shipping gateway are logged. This should only be enabled at the direction of qualified support personnel." AssociatedControlID="UseDebugMode" />
                        </th>
                        <td>
                            <asp:CheckBox ID="UseDebugMode" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click"/>
                            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
				            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" OnClick="CancelButton_Click" />
                        </td>
                    </tr>         
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="section">
        <uc:ShipMethods id="ShipMethods" runat="server"></uc:ShipMethods>
    </div>
</asp:Content>