<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.Maintenance" Title="Maintenance Settings" CodeFile="Maintenance.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Store Maintenance"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
                </div>
            </div>
            <div class="content aboveGrid">
                <asp:Button Id="SaveButon" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="SaveButton_Click" />
		        <asp:ValidationSummary ID="ValidationSummary2" runat="server" />                
		        <cb:Notification ID="SavedMessage" runat="server" Text="The store settings have been saved." Visible="false" SkinID="GoodCondition"></cb:Notification>
            </div>
            <div class="grid_6 alpha">
                <div class="leftColumn">
			        <div class="section">
                        <div class="header">
                            <h2 class="AnonymousUserMaintenance"><asp:Localize ID="UserMaintenanceCaption" runat="server" Text="Anonymous User Maintenance"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Panel ID="phAnonymousLifespanWarning" runat="server" Visible="false">
                                <asp:Label ID="AnonymousLifespanWarning" runat="server" Text="<i><font color=red>WARNING:</font> You do not have any value configured for the number of days to save anonymous users.  Over time this will lead to a very large user database and reduce performance.  It is recommended that anonymous users are retained no longer than needed for reporting purposes.  The suggested value for these fields is 30 days.</i>"></asp:Label>
                                <br /><br />
                            </asp:Panel>
                            <asp:Label ID="AnonymousLifespanLabel1" runat="server" Text="For how many days should anonymous users (and their abandoned baskets) be retained in the database? Reports on abandoned baskets are only valid when these records are available for the reporting period."></asp:Label><br /><br />
                            <asp:Label ID="AnonymousLifespanLabel2" runat="Server" SkinID="FieldHeader" Text="Days to Save: "></asp:Label>
                            <asp:TextBox ID="AnonymousLifespan" runat="server" Width="60px" MaxLength="4"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="AnonymousLifespanRequired" runat="server" ControlToValidate="AnonymousLifespan" ErrorMessage="Days to save anonymous users must be a numeric value between 1 and 9999." Text="*"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="AnonymousLifespanValidator" runat="server" Type="Integer" MinimumValue="1" MaximumValue="365" ControlToValidate="AnonymousLifespan" ErrorMessage="Days to save anonymous users must be a numeric value between 1 and 9999." Text="*"></asp:RangeValidator><br/><br />
                            <asp:Label ID="AnonymousAffiliateLifespanLabel1" runat="server" Text="How long should anonymous users be retained when they have an affiliate association?  Reports on user referrals and conversion rates are only valid when these records are available for the reporting period."></asp:Label><br /><br />
                            <asp:Label ID="AnonymousAffiliateLifespanLabel2" runat="Server" SkinID="FieldHeader" Text="Days to Save: "></asp:Label>
                            <asp:TextBox ID="AnonymousAffiliateLifespan" runat="server" Width="60px" MaxLength="4"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="AnonymousAffiliateLifespanRequired" runat="server" ControlToValidate="AnonymousAffiliateLifespan" ErrorMessage="Days to save anonymous affiliate users must be a numeric value between 1 and 9999." Text="*"></asp:RequiredFieldValidator> 
                            <asp:RangeValidator ID="AnonymousAffiliateLifespanValidator" runat="server" Type="Integer" MinimumValue="1" MaximumValue="9999" ControlToValidate="AnonymousAffiliateLifespan" ErrorMessage="Days to save anonymous affiliate users must be a numeric value between 1 and 9999." Text="*"></asp:RangeValidator>
                        </div>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2>Current Anonymous User Status</h2>
                        </div>
                        <div class="content">
                            <asp:UpdatePanel ID="AnonymousUsersPanel" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:Panel ID="InstructionsPanel" runat="server">
                                    <asp:Localize ID="AnonymousUserDelayWarning" runat="server">
                                    To view the current status of the anonymous user table please click the Check Database button below. This may cause a slight delay if you have a large user table.
                                    </asp:Localize><br /><br />
                                    <asp:Button ID="CheckDatabaseButton" runat="server" Text="Check Database" OnClick="CheckDatabaseButton_Click" CausesValidation="false" />
                                </asp:Panel>                                    
                                <asp:Panel ID="AnonymousUsersDataPanel" runat="server" Visible="false">
                                    <asp:Label ID="AnonymousUserCountLabel" runat="server" Text="Anonymous User Count:" SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                    <asp:Literal ID="AnonymousUserCount" runat="server"></asp:Literal><br />
                                    <asp:Label ID="OldestAnonUserLabel" runat="server" Text="Oldest Record:" SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                    <asp:Literal ID="OldestAnonUser" runat="server" Text="n/a"></asp:Literal><br /><br />
                                    <asp:Label ID="AffiliateAnonymousUserCountLabel" runat="server" Text="Affiliate Anonymous User Count:" SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                    <asp:Literal ID="AffiliateAnonymousUserCount" runat="server"></asp:Literal><br />
                                    <asp:Label ID="OldestAffAnonUserLabel" runat="server" Text="Oldest Record:" SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                    <asp:Literal ID="OldestAffAnonUser" runat="server" Text="n/a"></asp:Literal><br />
                                </asp:Panel>
                                <br />
                            </ContentTemplate>                                    
                            </asp:UpdatePanel>
                            <asp:Localize ID="ManualCleanupHelpText" runat="server">
                                You may trigger user maintenance manually using the form below.  This is a good idea if you are turning on user maintenance for the first time or reducing the number of days to save these records.  If you expect to delete a lot of records, trigger this process at an off-peak time as it could be resource intensive for the database server.
                            </asp:Localize><br /><br />
                            <asp:Label ID="ManualCleanupDaysLabel1" runat="server" Text="Delete anonymous users older than " EnableViewState="false"></asp:Label>
                            <asp:TextBox ID="ManualCleanupDays1" runat="server" Width="40px" MaxLength="4"></asp:TextBox> days.
                            <asp:RequiredFieldValidator ID="ManualCleanupDays1Required" runat="server" ControlToValidate="ManualCleanupDays1" Text="number required" ValidationGroup="ManualCleanup" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="ManualCleanupDays1Format" runat="server" Type="Integer" MinimumValue="0" MaximumValue="9999" ControlToValidate="ManualCleanupDays1" Text="number required" ValidationGroup="ManualCleanup" Display="Dynamic"></asp:RangeValidator><br/>
                            <asp:Label ID="ManualCleanupDaysLabel2" runat="server" Text="Delete affiliated anonymous users older than " EnableViewState="false"></asp:Label>
                            <asp:TextBox ID="ManualCleanupDays2" runat="server" Width="40px" MaxLength="4"></asp:TextBox> days.
                            <asp:RangeValidator ID="ManualCleanupDays2Format" runat="server" Type="Integer" MinimumValue="0" MaximumValue="9999" ControlToValidate="ManualCleanupDays2" Text="number required" ValidationGroup="ManualCleanup" Display="Dynamic"></asp:RangeValidator><br/>
                            <asp:Button ID="ManualCleanupButton" runat="server" Text="Delete Anonymous Users" ValidationGroup="ManualCleanup" onclick="ManualCleanupButton_Click" />
                        </div>                    
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="SearchHistoryMaintinence" runat="server" Text="Search History"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Label ID="SearchHistoryTrackingDaysLbl1" runat="server" Text="How many days should a search be saved in history before it is removed?. '0' means keeps forever."></asp:Label><br /><br />
                            <asp:Label ID="SearchHistoryTrackingDaysLbl2" runat="Server" SkinID="FieldHeader" Text="Days to Save: "></asp:Label>
                            <asp:TextBox ID="SearchHistoryDays" runat="server" Width="60px" MaxLength="3"></asp:TextBox>
                            <asp:RangeValidator ID="SearchHistoryDaysRangeValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="999" ControlToValidate="SearchHistoryDays" ErrorMessage="Search history days must be a numeric value." Text="*"></asp:RangeValidator>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="StoreMaintenanceCaption" runat="server" Text="Store Maintenance"></asp:Localize></h2>
                        </div>
                        <div class="content">                        
                            <table class="inputForm">
                                <tr>
                                    <th valign="top" style="white-space:nowrap">
                                        <cb:ToolTipLabel ID="IsStoreClosedLabel" runat="Server" Text="Store Status:" AssociatedControlID="StoreClosedOptions" ToolTip="Use this setting to temporarily close the store front for your maintenance or testing purposes. This setting has no impact on the availability of the admin pages."></cb:ToolTipLabel>
                                    </th>
                                    <td>                                    
                                        <asp:DropDownList ID="StoreClosedOptions" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr> 
                                <tr>
                                    <th valign="top" style="white-space:nowrap">
                                        <cb:ToolTipLabel ID="StoreClosedMessageLabel" runat="server" Text="Closed Message:" ToolTip="If the storefront is temporarily closed, this message will be displayed to customers instead."></cb:ToolTipLabel><br />
                                        <asp:RequiredFieldValidator ID="StoreClosedMessageRequired" runat="server" Text="*" ErrorMessage="Store close message is required." ControlToValidate="StoreClosedMessage"></asp:RequiredFieldValidator>
                                        <asp:ImageButton ID="StoreClosedMessageHtml" runat="server" SkinID="HtmlIcon" />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="StoreClosedMessage" runat="server" Rows="7" TextMode="MultiLine" Width="260px"  Columns="50"></asp:TextBox>                                                
                                    </td>
                                </tr> 
                            </table>                                                    
                        </div>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="SubscriptionMaintenanceCaption" runat="server" Text="Subscription Expiry"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Label ID="RetainExpiredSubscriptionsHelpLabel" runat="server" Text="The number of days to keep the expired subscriptions in the database before deleting them. Specify a zero value to delete expired subscriptions during first maintenance after expiration."></asp:Label><br /><br />
                            <asp:Label ID="RetainExpiredSubscriptionsLabel" runat="Server" SkinID="FieldHeader" Text="Retain Expired Subscriptions:" ></asp:Label>
                            <asp:TextBox ID="RetainExpiredSubscriptionDays" runat="server" Width="80px" MaxLength="80" ></asp:TextBox> days after expiration.
                            <asp:RangeValidator ID="RetainExpiredSubscriptionDaysValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="999" ControlToValidate="GiftCertExpireDays" ErrorMessage="Retain expired subscriptions days must be a numeric value." Text="*"></asp:RangeValidator>
                        </div>
                    </div>
			        <div class="section">
                        <div class="header">
                            <h2 class="giftcertificateexpiry"><asp:Localize ID="GiftCertificateExpiryLabel" runat="server" Text="Gift Certificate Expiry"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Label ID="GiftCertExpireDaysLbl1" runat="server" Text="How many days should it take before before a gift certificate expires - 0 means no expiration. (Expiration setting affects new gift certificates only)."></asp:Label><br /><br />
                            <asp:Label ID="GiftCertExpireDaysLbl2" runat="Server" SkinID="FieldHeader" Text="Days to Gift Certificate Expiry: "></asp:Label>
                            <asp:TextBox ID="GiftCertExpireDays" runat="server" Width="60px" MaxLength="4"></asp:TextBox>
                            <asp:RangeValidator ID="GiftCertExpireDaysValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="99999" ControlToValidate="GiftCertExpireDays" ErrorMessage="Gift Certificate expiry days must be a numeric value." Text="*"></asp:RangeValidator>
                        </div>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2 class="dataexchange"><asp:Localize ID="DataExchangeLabel" runat="server" Text="Data Exchange"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Localize ID="DataExchangeDescription" runat="server">
                                How you want to manage your old data files for import and export? You can either setup the maintenance routine to manage the old files based upon the following settings or alternately you can disable it (using a zero value) and manually manage the files yourself.
                            </asp:Localize>
                            <br />
                            <br />
                            <asp:Label ID="ExportFilesLabel" runat="server" EnableViewState="false" Text=" Export Data Files Settings:" SkinID="FieldHeader"></asp:Label>
                            <table class="inputForm" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="width:150px;">
                                        <cb:ToolTipLabel ID="MaxNumOfExportFilesLabel" runat="server" Text="Max No of Files :" EnableViewState="false" ToolTip="The maximum number of files that are allowed in the export folder. 0 means no restriction." />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="MaxNumOfExportFiles" runat="server" Width="40px" MaxLength="4" Text="0"></asp:TextBox>
                                        <asp:RangeValidator ID="MaxNumOfExportFilesValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="9999" ControlToValidate="MaxNumOfExportFiles" ErrorMessage="Max no. of export files must be a numeric value between 0-9999." Text="*"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <cb:ToolTipLabel ID="MaxAgeOfExportFilesLabel" runat="server" Text="Max Age (No of Days) :" EnableViewState="false" ToolTip="The maximum age in number of days a file can have in the export folder. 0 means no restriction." />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="MaxAgeOfExportFiles" runat="server" Width="40px" MaxLength="4" Text="0"></asp:TextBox>
                                        <asp:RangeValidator ID="MaxAgeOfExportFilesValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="9999" ControlToValidate="MaxAgeOfExportFiles" ErrorMessage="Max age of export files must be a numeric value between 0-9999." Text="*"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <cb:ToolTipLabel ID="MaxSizeOfExportFolderLabel" runat="server" Text="Max Size of Folder (MB) :" EnableViewState="false" ToolTip="The maximum total size of the export folder. 0 means no restriction." />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="MaxSizeOfExportFolder" runat="server" Width="40px" MaxLength="4" Text="0"></asp:TextBox>
                                        <asp:RangeValidator ID="MaxSizeOfExportFolderValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="9999" ControlToValidate="MaxSizeOfExportFolder" ErrorMessage="Max size of export files must be a numeric value between 0-9999." Text="*"></asp:RangeValidator>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <asp:Label ID="ImportFilesLabel" runat="server" EnableViewState="false" Text=" Import Data Files Settings:" SkinID="FieldHeader"></asp:Label>                            
                            <table class="inputForm" cellpadding="0" cellspacing="0">
	                            <tr>
		                            <td style="width:150px;">
			                            <cb:ToolTipLabel ID="MaxNumOfImportFilesLabel" runat="server" Text="Max No of Files :" EnableViewState="false" ToolTip="The maximum number of files that are allowed in the import folder. 0 means no restriction." />
		                            </td>
		                            <td>
			                            <asp:TextBox ID="MaxNumOfImportFiles" runat="server" Width="40px" MaxLength="4" Text="0"></asp:TextBox>
                                        <asp:RangeValidator ID="MaxNumOfImportFilesValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="9999" ControlToValidate="MaxNumOfImportFiles" ErrorMessage="Max no. of import files must be a numeric value between 0-9999." Text="*"></asp:RangeValidator>
		                            </td>
	                            </tr>
	                            <tr>
		                            <td>
			                            <cb:ToolTipLabel ID="MaxAgeOfImportFilesLabel" runat="server" Text="Max Age (No of Days) :" EnableViewState="false" ToolTip="The maximum age in number of days a file can have in the import folder. 0 means no restriction." />
		                            </td>
		                            <td>
			                            <asp:TextBox ID="MaxAgeOfImportFiles" runat="server" Width="40px" MaxLength="4" Text="0"></asp:TextBox>
                                        <asp:RangeValidator ID="MaxAgeOfImportFilesValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="9999" ControlToValidate="MaxAgeOfImportFiles" ErrorMessage="Max age of import files must be a numeric value between 0-9999." Text="*"></asp:RangeValidator>
		                            </td>
	                            </tr>
	                            <tr>
		                            <td>
			                            <cb:ToolTipLabel ID="MaxSizeOfImportFolderLabel" runat="server" Text="Max Size of Folder (MB) :" EnableViewState="false" ToolTip="The maximum total size of the import folder. 0 means no restriction." />
		                            </td>
		                            <td>
			                            <asp:TextBox ID="MaxSizeOfImportFolder" runat="server" Width="40px" MaxLength="4" Text="0"></asp:TextBox>
                                        <asp:RangeValidator ID="MaxSizeOfImportFolderValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="9999" ControlToValidate="MaxSizeOfImportFolder" ErrorMessage="Max size of import files must be a numeric value between 0-9999." Text="*"></asp:RangeValidator>
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