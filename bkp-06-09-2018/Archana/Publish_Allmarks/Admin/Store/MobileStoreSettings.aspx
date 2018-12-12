<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Admin.master"  CodeFile="MobileStoreSettings.aspx.cs" Inherits="AbleCommerce.Admin._Store.MobileStoreSettings" Title="Mobile Store Settings" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Configure Mobile Store"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
        </div>
    </div>
    <asp:UpdatePanel ID="SettingsPanel" runat="server">
        <ContentTemplate>
            <div class="content aboveGrid">
                <asp:Button Id="SaveButton" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="SaveButton_Click" />
                <asp:ValidationSummary ID="ValidationSummary2" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="The mobile store settings have been saved." Visible="false" SkinID="GoodCondition"></cb:Notification>
            </div>
            <div class="grid_6 alpha">
                <div class="leftColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="StoreStatusCaption" runat="server" Text="Mobile Store Status"></asp:Localize></h2>
                        </div>
                        <div class="content">                        
                            <table class="inputForm">
                                <tr>
                                    <th valign="top" style="white-space:nowrap">
                                        <cb:ToolTipLabel ID="IsStoreClosedLabel" runat="Server" Text="Mobile Browsing:" ToolTip="Use this setting to temporarily close the mobile store for your maintenance or testing purposes. This setting has no impact on the availability of the admin pages or standard store."></cb:ToolTipLabel>
                                    </th>
                                    <td>                                    
                                        <asp:CheckBox ID="EnableMobileBrowsing" runat="server" Text="Enable Mobile Support" />
                                    </td>
                                </tr>
                            </table>                                                    
                        </div>
                    </div>
			        <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="CatalogCaption" runat="server" Text="Catalog Display"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="PageSizeLabel" runat="Server" Text="Page Size:" AssociatedControlID="PageSize" ToolTip="The number of products/categories listed per page for mobile store." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="PageSize" runat="server" Columns="3" MaxLength="2"></asp:TextBox>
                                        <asp:RangeValidator ID="PageSizeValidator" runat="server" Type="Integer" MinimumValue="1" MaximumValue="99" ControlToValidate="PageSize" ErrorMessage="Page size must be a numeric value between '1' and '99'." Text="*" EnableViewState="false"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="DisplayTypeLabel" runat="Server" Text="Display Type:" AssociatedControlID="DisplayType" ToolTip="Select which way you want to display the prodcuts on category/search pages at mobile store." />
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="DisplayType" runat="server">
                                            <asp:ListItem Text="Grid Display" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Row Display" Value="1"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
			        <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="ProductDisplayCaption" runat="server" Text="Product Display"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <table class="inputForm compact">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="ProductUseSummaryLabel" runat="Server" Text="Use Summary:" AssociatedControlID="ProductUseSummary" ToolTip="Check this box to show the summary when a product is initially viewed.  The regular description will be accessible behind the 'more details' link.  If this is left unchecked the regular description will show on the main product view and 'more details' will only be used for extended description." />
                                    </th>
                                    <td>
                                        <asp:CheckBox ID="ProductUseSummary" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel> 
</asp:Content>