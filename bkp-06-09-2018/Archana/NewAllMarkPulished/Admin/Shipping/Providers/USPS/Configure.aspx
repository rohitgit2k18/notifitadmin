<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._USPS.Configure" title="Configure USPS&reg;" CodeFile="Configure.aspx.cs" %>
<%@ Register Src="../ProviderShipMethods.ascx" TagName="ShipMethods" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1>Configure USPS&reg;</h1>
	    </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="content">
                <p><asp:Label ID="InstructionText" runat="server" Text="The United States Postal Service integration retrieves real-time estimates for shipping costs.  The estimated shipping costs are charged to an order when a USPS shipping method is used.  Shipping can be estimated for for all shipments of US origin, to both domestic and international destinations.  The integration also allows merchants to provide real-time tracking information to customers."></asp:Label></p>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Configuration has been saved at {0:t}." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="UserIdLabel" runat="server" Text="User ID:" ToolTip="Your USPS user ID." />
                        </th>
                        <td>
                            <asp:TextBox ID="UserId" runat="server" Text=""></asp:TextBox><span class="requiredField">*</span>
			                <asp:RequiredFieldValidator ID="UserIdRequired" runat="server" 
			                    ErrorMessage="User Id is required." Text="*" Display="Static" 
			                    ControlToValidate="UserId"></asp:RequiredFieldValidator>
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
                            <cb:ToolTipLabel ID="LiveServerURLLabel" runat="server" Text="Rating URL:" ToolTip="The URL used for rating requests." AssociatedControlID="LiveServerURL" />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="LiveServerURL" runat="server" Text="${LiveServerURL}"></asp:TextBox>
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
                            <cb:ToolTipLabel ID="EnableAddressValidationLabel" runat="server" Text="Enable Address Validation:" AssociatedControlID="EnableAddressValidation" CssClass="toolTip" ToolTip="Indicate whether address validation services will be used."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBox ID="EnableAddressValidation" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="AddressServiceUrlLabel" runat="server" Text="Address Service Url:" ToolTip="The URL to which address validation requests are posted." />
                        </th>
                        <td>
				            <asp:TextBox Width="500" ID="AddressServiceUrl" runat="server"></asp:TextBox>
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
                        <th>&nbsp;</th>
                        <td>
				            <asp:CheckBox ID="UseOnlineRates" runat="server" CssClass="fieldHeader" Text="Use Online Rates" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="IntlMailTypeLabel" runat="server" Text="Intl Mail Type:" ToolTip="Package mail type for international rate quotes." />
                        </th>
                        <td>
				            <asp:DropDownList ID="IntlMailType" runat="server">
                                <asp:ListItem Text="All" Value="All"></asp:ListItem>
                                <asp:ListItem Text="Package" Value="Package"></asp:ListItem>
                                <asp:ListItem Text="Postcards or aerogrammes" Value="Postcards or aerogrammes"></asp:ListItem>
                                <asp:ListItem Text="Envelope" Value="Envelope"></asp:ListItem>
                                <asp:ListItem Text="LargeEnvelope" Value="LargeEnvelope"></asp:ListItem>
                                <asp:ListItem Text="FlatRate" Value="FlatRate"></asp:ListItem>
                            </asp:DropDownList>
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
</asp:Content>