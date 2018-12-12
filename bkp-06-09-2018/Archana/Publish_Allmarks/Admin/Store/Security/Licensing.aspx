<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.Security.Licensing" Title="AbleCommerce License"  CodeFile="Licensing.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">	
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Licensing"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/security" />
        </div>
    </div>	
    <asp:UpdatePanel ID="SettingsPanel" runat="server">
        <ContentTemplate>
            <div class="grid_6 alpha">
                <div class="leftColumn">
			        <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="LicenseCaption" runat="server" Text="License Details"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <table class="inputForm">
                                <tr>
                                    <th width="50%">
                                        <asp:Localize ID="LicenseTypeLabel" runat="server" Text="License Type:"></asp:Localize>
                                    </th>
                                    <td>
                                        <asp:Literal ID="LicenseType" runat="server" Text="" EnableViewState="false"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Localize ID="SubscriptionDateLabel" runat="server" Text="Subscription:"></asp:Localize>
                                    </th>
                                    <td>
                                        <asp:Literal ID="SubscriptionDate" runat="server" Text="" EnableViewState="false"></asp:Literal>
                                    </td>
                                </tr>
                                <tr id="trExpiration" runat="server" visible="false" enableviewstate="false">
                                    <th>
                                        <asp:Localize ID="ExpirationLabel" runat="server" Text="Expires:" EnableViewState="False"></asp:Localize>
                                    </th>
                                    <td>
                                        <asp:Literal ID="Expiration" runat="server" Text="" EnableViewState="false"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="LicensedDomainLabel" runat="server" Text="Registered Domain(s):"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:Repeater ID="DomainList" runat="server">
                                            <ItemTemplate>
                                                <asp:Label ID="LicensedDomain" runat="server" Text='<%#Container.DataItem%>'></asp:Label><br />
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <asp:PlaceHolder ID="DemoModePanel" runat="server">
			            <div class="section">
                            <div class="header">
                                <h2 class="commonicon"><asp:Localize ID="DemoModeCaption" runat="server" Text="Demo Mode"></asp:Localize></h2>
                            </div>
                            <div class="content">
                                <asp:Localize ID="DemoModeHelpText" runat="server" Text="Your license is registered to the domain(s) listed above, and one of these must used to access the store site.  You can also configure your store to run in a non-expiring demo mode.  In demo mode any domain may be used to access the store site, but order billing and shipping addresses will not be recorded."></asp:Localize><br /><br />
                                <asp:Localize ID="DemoModeEnabledText" runat="server" Text="Demo mode is currently <b>ENABLED</b>.  You may use any url to access your site, but order billing and shipping addresses will not be recorded."></asp:Localize>
                                <asp:Localize ID="DemoModeDisabledText" runat="server" Text="Demo mode is currently <b>DISABLED</b>.  You must use a registered domain to access your site.  To turn on demo mode, click below."></asp:Localize><br /><br />
                                <asp:Button ID="DemoModeButton" runat="server" Text="Enable Demo Mode" OnClick="DemoModeButton_Click" CausesValidation="false" />
                            </div>
                        </div>
                    </asp:PlaceHolder>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
			        <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="UpdateCaption" runat="server" Text="Update License"></asp:Localize></h2>
                        </div>
				        <asp:PlaceHolder ID="phUpdateKey" runat="server" Visible="true">
                        <div class="content">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
		                    <cb:Notification ID="SavedMessage" runat="server" Text="Store license updated at {0}." Visible="false" SkinID="GoodCondition" EnableViewState="false"></cb:Notification>
		                    <cb:Notification ID="FailedMessage" runat="server" Text="The store license could not be updated: {0}" Visible="false" SkinID="ErrorCondition" EnableViewState="false"></cb:Notification>
                            <table class="inputForm compact">
                                <tr>
                                    <th>
                                        <asp:Label ID="LicenseKeyLabel" runat="server" Text="Enter License Key:" AssociatedControlID="LicenseKey" EnableViewState="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="LicenseKey" runat="server" Text="" MaxLength="36" Width="240px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="LicenseKeyRequired" runat="server" Text="*"
                                            ErrorMessage="You must enter the license key." ControlToValidate="LicenseKey" Display="dynamic"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="LicenseKeyFormat" runat="server" Text="*"
                                            ErrorMessage="Your license key does not match the expected format." ControlToValidate="LicenseKey"
                                            ValidationExpression="^\{?[A-Fa-f0-9]{8}-?([A-Fa-f0-9]{4}-?){3}[A-Fa-f0-9]{12}\}?$" Display="dynamic"></asp:RegularExpressionValidator>
                                        <asp:Button Id="SaveButon" runat="server" Text="Save" OnClick="SaveButton_Click" OnClientClick="if(Page_ClientValidate()){return confirm('Are you sure you want to update the license key?')}" />
                                    </td>
                                </tr>
                            </table>
                            <p>
                            <asp:Localize ID="LicensingHelpText" runat="server">
                                For more information on licensing, please go to <a href="http://help.ablecommerce.com/acgold/licensing" target="_blank">License Keys</a>.
                            </asp:Localize>
                            </p>
                        </div>
				        </asp:PlaceHolder>
				        <asp:PlaceHolder ID="phPermissions" runat="server" EnableViewState="false" Visible="false">					
					        <div class="pageHeader">
                                <div class="caption">
                                    <h1><asp:Localize ID="Localize1" runat="server" Text="Store License">Testing permissions for key update</asp:Localize></h1>
                                </div>
					        </div>
					        <div class="content">
					            <p>Sufficient file permissions are not available for AbleCommerce to update your license key file. Please ensure that the specified process identity has permissions to write or create '<b>~/App_Data/CommerceBuilder.lic</b>' file.</p>
					            <b>Process Identity:</b> <asp:Literal ID="ProcessIdentity" runat="server"></asp:Literal><br /><br />
					            <b>Test Result:</b><asp:Literal ID="PermissionsTestResult" runat="server"></asp:Literal>
					        </div>
				        </asp:PlaceHolder>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
