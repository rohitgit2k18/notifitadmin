<%@Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.PageTracking._Default" Title="Configure Page Tracking"  CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
	<div class="pageHeader">
		<div class="caption">
			<h1><asp:Localize ID="Caption" runat="server" Text="Page Tracking"></asp:Localize></h1>
			<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
		</div>
	</div>
    <asp:UpdatePanel ID="SettingsPanel" runat="server">
        <ContentTemplate>
            <div class="grid_6 alpha">
                <div class="leftColumn">
                    <div class="content">
                        <p><asp:Label ID="InstructionText" runat="server" Text="When you enable tracking of page views, you can see statistics about what categories and products are popular.  It will also enable customers to see their recently viewed items."></asp:Label></p>
                        <cb:Notification ID="ResponseMessage" SkinID="GoodCondition" runat="server" Text="Your changes to the to the activity logging settings have been saved." Visible="false"></cb:Notification>
                        <table class="inputForm">
                            <tr>
                                <th>
                                    <asp:Label ID="TrackPageViewsLabel" runat="Server" Text="Enable Tracking: "></asp:Label>
                                </th>
                                <td>
                                    <asp:CheckBox ID="TrackPageViews" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="HistoryLengthLabel" runat="Server" Text="History Length: "></asp:Label>
                                </th>
                                <td>
                                    <asp:Label ID="HistoryLengthPrefix" runat="Server" Text="Maintain history for "></asp:Label>
                                    <asp:TextBox ID="HistoryLength" runat="server" Columns="4"></asp:TextBox>
                                    <asp:Label ID="HistoryLengthSuffix" runat="Server" Text=" days"></asp:Label><br />
                                </td>
                            </tr>
                            <tr>
                                <th valign="top">
                                    <asp:Label ID="SaveArchiveLabel" runat="Server" Text="Archive Option: "></asp:Label>
                                </th>
                                <td>
                                    <asp:DropDownList ID="SaveArchive" runat="server" AutoPostBack="true" OnSelectedIndexChanged="SaveArchive_SelectedIndexChanged">
                                        <asp:ListItem Text="Delete" Value="false"></asp:ListItem>
                                        <asp:ListItem Text="Save to File" Value="true"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:Panel ID="SaveArchiveWarningPanel" runat="server">
                                        <p><asp:Label ID="SaveArchiveHelpText" runat="server" text="<strong>Note:</strong> When you select the 'Save to File' option, history is written to file before deletion from database.  The log is written to the App_Data/Logs folder in extended log file format.  You must have write permissions to this location, and you are responsible for maintaining and/or removing the log files."></asp:Label></p>
                                    </asp:Panel>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <asp:Panel ID="CurrentLogPanel" runat="server" CssClass="section">
                        <div class="header">
                            <h2><asp:Localize ID="CurrentLogCaption" runat="server" Text="Current Log"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Label ID="CurrentRecordsLabel" runat="Server" Text="Current Records: " SkinID="FieldHeader"></asp:Label>
                            <asp:Label ID="CurrentRecords" runat="server"></asp:Label><br /><br />
                            <asp:Button ID="ViewButton" runat="server" Text="View" OnClick="ViewButton_Click" />
                            <asp:Button ID="ClearButton" runat="server" Text="Clear" OnClientClick="return confirm('WARNING: This will reset all page tracking statistics. Are you sure you want to clear all records from the log?')" OnClick="ClearButton_Click" />
                        </div>
                    </asp:Panel>
                    <p><asp:Label ID="InstructionTextImp" runat="server" CssClass="errorCondition" Text="There is a significant performance hit when tracking is enabled, but many features require it to work.  Please refer to the Merchant Guide for more information."></asp:Label></p>
                </div>
            </div>
            <div class="clear"></div>
	        <div class="pageHeader">
		        <div class="caption">
			        <h1><asp:Localize ID="GoogleAnalyticsCaption" runat="server" Text="Google Universal Analytics"></asp:Localize></h1>
		        </div>
	        </div>
            <div class="grid_6">
                <div class="leftColumn">
                    <div class="content">
                        <p><asp:Label ID="InstructionTextGA" runat="server" Text="Enter the Google web property ID that will be used for tracking." EnableViewState="false"></asp:Label></p>
                        <cb:Notification ID="ResponseMessageGA" SkinID="GoodCondition" runat="server" Text="Your Google Universal Analytics settings have been updated." Visible="false"></cb:Notification>
                        <table class="inputForm">
                            <tr>
                                <th>
                                    <asp:Label ID="GoogleUrchinIdLabel" runat="Server" Text="Web Property ID: " EnableViewState="false"></asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="GoogleUrchinId" runat="server" EnableViewState="true"></asp:TextBox> (UA-XXXXX-X)
                                </td> 
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:CheckBox ID="EnablePageTracking" runat="server" EnableViewState="true"></asp:CheckBox>
                                    <asp:Label ID="GooglePageTrackLabel" runat="Server" Text="Enable Page Tracking" EnableViewState="false" SkinID="FieldHeader"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:CheckBox ID="EnableEcommerceTracking" runat="server" EnableViewState="true" ></asp:CheckBox>
                                    <asp:Label ID="GoogleEcomTrackLabel" runat="Server" Text="Enable E-Commerce Tracking" EnableViewState="false" SkinID="FieldHeader"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:Button ID="SaveButtonGA" runat="server" Text="Save" OnClick="SaveButtonGA_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <asp:Panel ID="GoogleAnalyticsHelp" runat="server" CssClass="section">
                        <div class="header">
                            <h2><asp:Localize ID="GoogleAnalyticsHelpCaption" runat="server" Text="Configuring Google Universal Analytics"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Label ID="InstructionText1" runat="server" Text="If you enable Google Universal Analytics make sure you are using layouts that include the store footer.  Page tracking will not function if the footer is omitted."></asp:Label>
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <div class="clear"></div>
	        <div class="pageHeader">
		        <div class="caption">
			        <h1><asp:Localize ID="UserActivityCaption" runat="server" Text="User Activity"></asp:Localize></h1>
		        </div>
	        </div>
            <div class="grid_6">
                <div class="leftColumn">
					<div class="content">
						<cb:Notification ID="ResponseMessageUserSettings" SkinID="GoodCondition" runat="server" Text="User Activity settings have been updated." Visible="false"></cb:Notification>
						<asp:Label ID="ActivityDateUpdateIntervalLabel" runat="Server" Text="Update User's Last Activity Date Every &nbsp;" SkinID="FieldHeader"></asp:Label>
						<asp:TextBox ID="ActivityDateUpdateInterval" runat="server" Columns="3"></asp:TextBox>
						<cb:ToolTipLabel ID="SecondsLabel" runat="Server" Text="Seconds" ToolTip="Time in seconds after which the to update the last activity date for users. If the value is zero (0) update will happen on each request." SkinID="FieldHeader" />
						<p>
						<br/>
						<asp:Button ID="SaveUserSettingsButton" runat="server" Text="Save" 
							onclick="SaveUserSettingsButton_Click" />
						</p>
					</div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <asp:Panel ID="UserActivityHelp" runat="server" CssClass="section">
                        <div class="content">
                            <asp:Label ID="InstructionText2" runat="server" Text="For performance reasons user's activity date is not updated on each request. The setting here controls the time after which the to update the last activity date is made. If the value is set to zero (0) last activity date will be updated on each request."></asp:Label>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>