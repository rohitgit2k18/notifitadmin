<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._DHLInternational.Configure" title="Configure DHL International" CodeFile="Configure.aspx.cs" %>
<%@ Register Src="../ProviderShipMethods.ascx" TagName="ShipMethods" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1>Configure DHL International</h1>
	    </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="content">
                <p><asp:Label id="InstructionText" runat="server" Text="Specify the DHL configuration options below."></asp:Label></p>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Configuration has been saved at {0:t}." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <table class="inputForm">                               
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="UserIDLabel" runat="server" Text="User ID:" ToolTip="This is your DHL User ID." AssociatedControlID="UserID" />
                        </th>
                        <td>
				            <asp:TextBox ID="UserID" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="PasswordLabel" runat="server" Text="Password:" ToolTip="This is your DHL Password." AssociatedControlID="Password" />
                        </th>
                        <td>
				            <asp:TextBox ID="Password" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="AccountNumberLabel" runat="server" Text="Account Number:" ToolTip="DHL Account Number" AssociatedControlID="AccountNumber" />
                        </th>
                        <td>
                            <asp:TextBox ID="AccountNumber" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ShippingKeyLabel" runat="server" Text="Shipping Key:" ToolTip="DHL Shipping Key" AssociatedControlID="ShippingKey" />
                        </th>
                        <td>
                            <asp:TextBox ID="ShippingKey" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="DutiableFlagLabel" runat="server" Text="Shipments are Dutiable?" ToolTip="Indicates if the shipment sent via this DHL gateway are dutiable or non-dutiable." AssociatedControlID="DutiableFlag" />
                        </th>
                        <td>
                            <asp:CheckBox ID="DutiableFlag" runat="server" />
                        </td>
                    </tr>								

                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="CustomsValueMultiplierLabel" runat="server" Text="Customs Value Multiplier:" ToolTip="If shipments are dutiable customs value is required by DHL. Enter a multiplier to use to determine the customs value of shipments. Customs value is calculated as Customs Value = (Retail Value of the Package) * (Customs Value Multiplier). The default value is 1 which effectively means Customs Value = Retail Value." AssociatedControlID="CustomsValueMultiplier" />
                        </th>
                        <td>
                            <asp:TextBox ID="CustomsValueMultiplier" runat="server" Width="50px"></asp:TextBox> (default 1)
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="CommerceLicensedLabel" runat="server" Text="Commerce Licensed?" ToolTip="If Shipments are Dutiable, you must also indicate whether the shipments are commerce-licensed shipments. Note: An ITN number will be required if the shipments are commerce-licensed." AssociatedControlID="CommerceLicensed" />
                        </th>
                        <td>
                            <asp:CheckBox ID="CommerceLicensed" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="FilingTypeLabel" runat="server" Text="Filing Type:" ToolTip="If Shipments are Dutiable, you must also indicate the filing type. Use FTR if the shipments fulfils the requirements of an FTR (FTSR) exemption code. Use ITN if the shipments have been filed for and an ITN number is available. Use AES4 if the sender is an AES4 approved filer and will file for this shipment post-departure within the deadline." AssociatedControlID="FilingType" />
                        </th>
                        <td>
                            <asp:DropDownList ID="FilingType" runat="server"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="FTRExemptionCodeLabel" runat="server" Text="FTR Exemption Code:" ToolTip="If the filing type is FTR, provide FTR exemption code to use. Required when filing type is FTR." AssociatedControlID="FTRExemptionCode" />
                        </th>
                        <td>
                            <asp:TextBox ID="FTRExemptionCode" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ITNNumberLabel" runat="server" Text="ITN Number:" ToolTip="If the filing type is ITN, provide an ITN number. Required when filing type is ITN." AssociatedControlID="ITNNumber" />
                        </th>
                        <td>
                            <asp:TextBox ID="ITNNumber" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="EINCodeLabel" runat="server" Text="EIN Code:" ToolTip="If the filing type is AES4, provide an EIN code. Required when filing type is AES4." AssociatedControlID="EINCode" />
                        </th>
                        <td>
                            <asp:TextBox ID="EINCode" runat="server" ></asp:TextBox> (default 0)
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
                            <cb:ToolTipLabel ID="DaysToShipLabel" runat="server" Text="Days To Ship:" ToolTip="Number of days it takes to ship a package." AssociatedControlID="DaysToShip" />
                        </th>
                        <td>
                            <asp:TextBox ID="DaysToShip" runat="server" Width="40px"></asp:TextBox> (min 1)
                        </td>
                    </tr>
					<tr>
                        <th>
                            <cb:ToolTipLabel ID="LiveServerURLLabel" runat="server" Text="Rating URL:" ToolTip="The URL used for rating requests." AssociatedControlID="LiveServerURL" />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="LiveServerURL" runat="server" Text="${LiveServerURL}"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TestServerURLLabel" runat="server" Text="Test Server URL:" ToolTip="The URL to which requests are posted in Test Mode." />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="TestServerURL" runat="server" Text="${TestServerURL}"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TrackingURLLabel" runat="server" Text="Tracking URL:" ToolTip="The URL used for tracking requets. {0} is substituted with the tracking number at the time of request." />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="TrackingURL" runat="server" Text="${TrackingURL}"></asp:TextBox>
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
							<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" OnClick="CancelButton_Click"/>
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