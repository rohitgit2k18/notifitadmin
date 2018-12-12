<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.SEO.Settings" Title="SEO Settings" CodeFile="Settings.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel id="SettingsAjax" runat="server" >
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="SettingsCaption" runat="server" Text="SEO Settings"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/seo" />
                </div>
            </div>
            <div class="content aboveGrid">
                <asp:Button ID="SaveButton" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="SaveButton_Click" ValidationGroup="SEOSettings"></asp:Button>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="SEOSettings" />
                <cb:Notification ID="SavedMessage" runat="server" Text="The configuration has been saved at {0}." SkinID="GoodCondition" Visible="False" EnableViewState="false"></cb:Notification>
            </div>
            <div class="grid_6 alpha">
                <div class="leftColumn">
		            <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="GeneralCaption" runat="server" Text="General"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Localize ID="CacheSizeHelpText" runat="server" Text="Using SEO features like redirects and custom URLs requires incoming requests to be checked and routed to the correct destination.  A second level cache helps this process run much faster than a database lookup.  Indicate the maximum size of your cache below.  A value of 1000 is suitable unless you have more than that number of custom urls and an extremely active site."></asp:Localize></p>
                            <asp:Label ID="CacheSizeLabel" runat="Server" Text="Cache Size:" SkinID="FieldHeader"></asp:Label>
                            <asp:TextBox ID="CacheSize" runat="server" MaxLength="7" Columns="3" ValidationGroup="SEOSettings"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RangeValidator ID="CacheRangeValidator" runat="server" Text="*" ErrorMessage="Cache size is should be at least 100." ControlToValidate="CacheSize" ValidationGroup="SEOSettings" Type="Integer" MinimumValue="100" MaximumValue="9999999"></asp:RangeValidator>
                            <asp:RequiredFieldValidator ID="CacheSizeRequired" runat="server" ErrorMessage="Cache size is required and should be at least 100." Text="*" ControlToValidate="CacheSize" ValidationGroup="SEOSettings"></asp:RequiredFieldValidator>
                            <p><asp:Localize ID="TrackingHelpText" runat="server" Text="When a redirect is triggered, the date and time can be recorded and a hit counter can be updated. This can help you see what redirects are being used and which may be outdated and safe to remove. There is a small processing overhead due to a database update when a redirected URL is visited, so this feature is optional."></asp:Localize></p>
                            <asp:CheckBox ID="EnableTracking" runat="server" />
                            <asp:Label ID="EnableTrackingLabel" runat="Server" Text="Enable Statistics Tracking" SkinID="FieldHeader" AssociatedControlID="EnableTracking"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
		            <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="CustomExtensionsCaption" runat="server" Text="Custom Extensions"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:PlaceHolder ID="phCustomExtensionsUnavailable" runat="server" Visible="false">
                                <p><asp:Literal ID="CustomExtensionsMessage" runat="server"></asp:Literal></p>
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="phCustomExtensionsUnconfigured" runat="server" Visible="false">
                                <p>
                                    <asp:Localize ID="WebConfigChangeRequiredMessage" runat="server">
                                        For custom extensions to function, a change must be made to the web.config. 
                                        The runAllManagedModulesForAllRequests attribute must be set to true for the 
                                        system.webServer/modules element. You can make this change yourself, or we can 
                                        attempt to make the change for you automatically.<br /><br />                                
                                        Be aware that enabling this option will come at some performance cost.  Depending
                                        on the number of page requests you receive and your server hardware, the difference
                                        may be negligible.  Still you should enable it only if you need to use custom urls with
                                        exensions other than aspx.  Once the configuration change is made, you will be able
                                        to specify the additional extensions you wish to support.
                                    </asp:Localize>
                                </p>
                                <asp:Button ID="SetWebConfiguration" runat="server" Text="Enable Automatically" OnClick="SetWebConfiguration_Click" />
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="phCustomExtensionsConfigured" runat="server" Visible="false">
                                <p>
                                    <asp:Localize ID="CustomExtensionsHelpText" runat="server">
                                        When custom extensions are enabled, your redirects and custom urls can use extensions other than aspx.
                                    </asp:Localize>
                                </p>
                                <asp:CheckBox ID="AllowCustomExtensions" runat="server" /> 
                                <asp:Label ID="AllowCustomExtensionsLabel" runat="Server" Text="Allow Custom Extensions" AssociatedControlID="AllowCustomExtensions" SkinID="FieldHeader"></asp:Label>
                                <asp:Panel ID="CustomExtensionsPanel" runat="server">
                                    <p>Enter the extension(s) you want to support.  Do not enter a leading period, and separate multiple the extensions with a comma.  You may also elect to enable support for URLs that do not have an extension.</p>
                                    <table class="inputPanel">
                                        <tr>
                                            <th>
                                                <asp:Label ID="AllowedExtensionsLabel" runat="Server" Text="Extensions:" AssociatedControlID="AllowedExtensions"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:TextBox ID="AllowedExtensions" runat="server" MaxLength="200" Width="200px"></asp:TextBox> (e.g. htm,php)
                                                <asp:RegularExpressionValidator ID="AllowedExtensionsValidator" runat="server" ControlToValidate="AllowedExtensions" ValidationExpression="^.{1,6}(?:,\s*.{1,6})*$" Text="*" ErrorMessage="Allowed extensions value should be a comma delimited list of extensions." ValidationGroup="SEOSettings"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>
                                                <asp:CheckBox ID="AllowUrlWithoutExtensions" runat="server" Text="Allow URLs Without Extensions" />
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                                <asp:Panel ID="RemoveWebConfigurationPanel" runat="server">
                                    <p>
                                        <asp:Localize ID="RemoveWebConfiguration" runat="server">
                                            You do not have custom extensions turned on, but in your web.config file the runAllManagedModulesForAllRequests
                                            attribute of system.webServer/modules is enabled.  If you have not enabled this 
                                            setting for some other reason, you will improve site performance by disabling the option.<br /><br />
                                            You can either make the change manually by editing your web.config and setting the attribute 
                                            value to false, or we can attempt to disable this setting automatically.
                                        </asp:Localize>
                                    </p>
                                    <asp:Button ID="RemoveWebConfigurationButton" runat="server" Text="Disable Automatically" OnClick="RemoveWebConfigurationButton_Click" />
                                </asp:Panel>
                            </asp:PlaceHolder>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>