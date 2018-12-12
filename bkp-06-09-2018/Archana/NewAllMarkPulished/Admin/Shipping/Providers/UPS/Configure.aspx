<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._UPS.Configure" title="Configure UPS&reg;" CodeFile="Configure.aspx.cs" %>
<%@ Register Src="../ProviderShipMethods.ascx" TagName="ShipMethods" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1>Configure UPS OnLine&reg; Tools</h1>
	    </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="content">
                <p>
                    <asp:Label id="InstructionText" runat="server" Text="Specify the configuration options below. The settings can impact the real-time rates returned by the UPS Rates & Service Selection Tool." EnableViewState="false"></asp:Label>
                    <br />
                    <asp:Literal id="NegotiatedRatesInstructionText" runat="server" Text="To edit your UPS account details for enabling Negotiated Rates, or to enable Address Validation feature <a href='RegisterDirect.aspx'>click here</a>" EnableViewState="false" />
                </p>
                <cb:Notification ID="SavedMessage" runat="server" Text="Configuration has been saved at {0:t}." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <table class="inputForm" width="100%">          
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="UserIdLabel" runat="server" Text="User Id:" ToolTip="This is your UPS Online Tools&reg; user id." />
                        </th>
                        <td>
                            <asp:Literal ID="UserId" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="AccessKeyLabel" runat="server" Text="Access Key:" ToolTip="This is your UPS Online Tools&reg; access key." />
                        </th>
                        <td>
                            <asp:Literal ID="AccessKey" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ShipperNumberLabel" runat="server" Text="Shipper Number:" ToolTip="If you have a shipper number for negotiated rates you may enter it here.  Additionally UPS support must configure your UPS Online Tools&reg; account to return these rates.  You may need to reference the user id and access key given above." AssociatedControlId="ShipperNumber" />
                        </th>
                        <td>
                            <asp:TextBox ID="ShipperNumber" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="EnableLabelsLabel" runat="server" Text="Enable Labels:" ToolTip="Check to enable the retrieval of automated tracking numbers and printing of labels. This feature requires that you have a Shipper Number." AssociatedControlId="EnableLabels" />
                        </th>
                        <td>
                            <asp:CheckBox ID="EnableLabels" runat="server"></asp:CheckBox>
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <cb:ToolTipLabel ID="CustomerTypeLabel" runat="server" Text="Customer Type:" ToolTip="An incorrect setting for Customer Type will result in less accurate rate estimates. To the right are descriptions of each option to help you make the correct choice." />
                        </th>
                        <td>
                            <asp:RadioButton ID="CustomerType_DailyPickup" runat="Server" GroupName="CustomerType" />
                            <asp:Label ID="DailyPickupHelpText" runat="server" Text="<strong>Daily Pickup</strong><br />A UPS driver comes to the merchant location each day (weekly service charge applies)."></asp:Label><br />
                            <asp:RadioButton ID="CustomerType_Occasional" runat="Server" GroupName="CustomerType" />
                            <asp:Label ID="OccasionalHelpText" runat="server" Text="<strong>Occasional Shipper</strong><br />Merchant has their own account number. It is the responsibility of the merchant to drop the package into the UPS System."></asp:Label><br />
                            <asp:RadioButton ID="CustomerType_Retail" runat="Server" GroupName="CustomerType" />
                            <asp:Label ID="RetailHelpText" runat="server" Text="<strong>Suggested Retail Rates</strong><br /> Merchant pays for shipments at the UPS Store. The shipping label is created and printed at the UPS Store or UPS Customer Counter."></asp:Label><br />
                            <asp:RadioButton ID="CustomerType_Negotiated" runat="Server" GroupName="CustomerType" />
                            <asp:Label ID="NegotiatedHelpText" runat="server" Text="<strong>Negotiated Rates</strong><br /> Negotiated Rates are the contract rates established with UPS and your UPS Account Representative.."></asp:Label><br />
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
				            <asp:TextBox ID="MaxWeight" runat="server" Width="60"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="MinWeightLabel" runat="server" Text="Minimum Weight:" ToolTip="Minimum package weight to use when requesting rates from the carrier." AssociatedControlID="MinWeight" />
                        </th>
                        <td>
					        <asp:TextBox ID="MinWeight" runat="server" Width="60"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="UseInsuranceLabel" runat="server" Text="Insurance:" ToolTip="Turns on or off the optional shipping insurance.  When enabled, all real-time rates will reflect the additional cost (if any) for insurance." AssociatedControlID="UseInsurance" />
                        </th>
                        <td>
                            <asp:CheckBox ID="UseInsurance" runat="server" />
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
                            <cb:ToolTipLabel ID="TestServerURLLabel" runat="server" Text="Test Server URL:" ToolTip="The URL to which requests are posted in Test Mode." />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="TestServerURL" runat="server"></asp:TextBox>
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
                    <!--
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
                    -->
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
                            <cb:ToolTipLabel ID="UseDebugModeLabel" runat="server" Text="Debug Mode:" ToolTip="When debug mode is enabled, all messages sent to and received from the shipping gateway are logged. This should only be enabled at the direction of qualified support personnel." AssociatedControlID="UseDebugMode" />
                        </th>
                        <td>
                            <asp:CheckBox ID="UseDebugMode" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
							<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="section">
        <uc:ShipMethods id="ShipMethods" runat="server"></uc:ShipMethods>
    </div>
    <div class="content">
	    <asp:Label ID="UPSCopyRight" runat="server" Text="UPS brandmark, and the Color Brown are trademarks of United Parcel Service of America, Inc. All Rights Reserved." SkinID="Copyright"></asp:Label>
    </div>
</asp:Content>