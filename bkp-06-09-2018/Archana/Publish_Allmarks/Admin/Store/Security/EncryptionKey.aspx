<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.Security._EncryptionKey" Title="Encryption Key"  CodeFile="EncryptionKey.aspx.cs" AutoEventWireup="True" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="EncryptionAjax" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="RestoreButton" />
        </Triggers>
        <ContentTemplate>
			<div class="pageHeader">
				<div class="caption">
					<h1><asp:Localize ID="Caption" runat="server" Text="Encryption Key"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/security" />
				</div>
			</div>
            <div class="content">
                <p><asp:Localize ID="InstructionText" runat="server" Text="Sensitive account data is encrypted within the database using a secret key.  Without this key the data cannot be read.  You must update your key on a regular schedule, at least once per year but every 90 days is recommended."></asp:Localize></p>
                <asp:Label ID="LastSetLabel" runat="server" Text="Key Last Updated:" SkinID="FieldHeader"></asp:Label>
                <asp:Label ID="LastSet" runat="server" Text=""></asp:Label>
            </div>
            <div class="grid_6 alpha">
                <div class="leftColumn">
			        <div class="section">
                        <div class="header">
                            <h2 class="encrypt"><asp:Localize ID="ChangeCaption" runat="server" Text="Change Encryption Key"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Localize ID="ChangeInstructionText" runat="server" Text="To change your key, all data in the database must be decrypted with the old key and then re-encrypted with the new key.  This process can take some time depending on the size of your database; the estimated workload is shown below.  Once you intiate a key change, a progress indicator will be shown to let you know when the process is complete.  Always ensure you have both a database backup and a key backup before initiating a key change."></asp:Localize></p>
			                <p><asp:Localize ID="ChangeInstructionText2" runat="server" Text="To ensure maximum security of your data, provide some random text to help generate the key.  You must type at least 20 characters; the more random the better."></asp:Localize></p>
			                <asp:Panel ID="ChangePanel" runat="server">
			                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ChangeKey" />
			                    <table class="inputForm" cellpadding="2" cellspacing="2">
			                        <tr>
			                            <th>
			                                <asp:Label ID="EstimatedWorkloadLabel" runat="server" Text="Estimated Workload:"></asp:Label>
			                            </th>
			                            <td>
			                                <asp:Label ID="EstimatedWorkload" runat="server" Text=""></asp:Label>
			                                <asp:Label ID="EstimatedWorkoadLabel2" runat="server" Text=" records"></asp:Label>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>
			                                <asp:Label ID="RandomTextLabel" runat="server" Text="Random Text:"></asp:Label>
			                            </th>
			                            <td>
			                                <asp:TextBox ID="RandomText" runat="server" Text="" AutoCompleteType="None" autocomplete="off" Width="200px"></asp:TextBox>
			                                <asp:RequiredFieldValidator ID="RandomTextValidator1" runat="server" ControlToValidate="RandomText"
			                                    Text="*" ErrorMessage="You must type at least 20 random characters to generate a new key." Display="Dynamic"
			                                    ValidationGroup="ChangeKey"></asp:RequiredFieldValidator>
			                                <asp:RegularExpressionValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="RandomText"
			                                    Text="*" ErrorMessage="You must type at least 20 random characters to generate a new key." Display="Dynamic"
			                                    ValidationExpression="^(DECRYPT)|(.{20,})$" ValidationGroup="ChangeKey"></asp:RegularExpressionValidator>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td>&nbsp;</td>
			                            <td>
			                                <asp:Button ID="UpdateButton" runat="server" Text="Change Encryption Key" OnClick="UpdateButton_Click" OnClientClick="if (Page_ClientValidate('ChangeKey')){if (confirm('The encryption key is about to be changed.  Click OK to confirm.')){this.value='Processing...';return true;}return false;}return false;" ValidationGroup="ChangeKey" />
			                            </td>
			                        </tr>
			                    </table>
			                </asp:Panel>
			                <asp:Panel ID="ChangeProgressPanel" runat="server" Visible="false">
			                    <asp:Timer ID="ChangeProgressTimer" runat="server" Interval="10000" OnTick="ChangeProgressTimer_Tick"></asp:Timer>
			                    <asp:Label ID="KeyUpdatingMessage" runat="server" SkinID="GoodCondition" Text="Your key is being updated..."></asp:Label>
			                    <table class="inputForm" cellpadding="2" cellspacing="2">
			                        <tr>
			                            <th>
			                                <asp:Label ID="RemainingWorkloadLabel" runat="server" Text="Remaining Workload:"></asp:Label>
			                            </th>
			                            <td>
			                                <asp:Label ID="RemainingWorkload" runat="server" Text=""></asp:Label>
			                                <asp:Label ID="RemainingWorkloadLabel2" runat="server" Text=" records"></asp:Label>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>
			                                <asp:Label ID="ProgressDateLabel" runat="server" Text="Status as of:"></asp:Label>
			                            </th>
			                            <td>
			                                <asp:Label ID="ProgressDate" runat="server" Text="" EnableViewState="false"></asp:Label>
			                            </td>
			                        </tr>
			                    </table>
    			                <asp:Panel ID="trRestartCancel" runat="server" Visible="false">
	                                <p><asp:Label ID="CancelChangeInstructionText" runat="server" Text="Has the key change stopped progressing?  You can try to restart or cancel.  It is recommended that you review the documentation before you choose either option."></asp:Label></p>
	                                <asp:LinkButton ID="RestartChangeButton" runat="server" Text="Restart" OnClientClick="return confirm('Are you sure you wish to restart the key change?')" OnClick="RestartChangeButton_Click"></asp:LinkButton>&nbsp;&nbsp;
	                                <asp:LinkButton ID="CancelChangeButton" runat="server" Text="Cancel" OnClientClick="return confirm('Are you sure you wish to cancel the key change?')" OnClick="CancelChangeButton_Click"></asp:LinkButton>
    			                </asp:Panel>
			                </asp:Panel>
		                    <asp:Label ID="KeyUpdatedMessage" runat="server" SkinID="GoodCondition" Text="Your key has been updated." Visible="false" EnableViewState="false"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
		            <div class="section">
                        <div class="header">
                            <h2 class="download"><asp:Localize ID="BackupCaption" runat="server" Text="Back-up Encryption Key"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Panel ID="BackupPanel" runat="server">
    			                <p><asp:Localize ID="BackupInstructionText" runat="server" Text="Your security key is stored apart from the database.  In the event that you must restore your database to another location it is vital that you have this key.  Whenever you change your key download the key backup and store it in a physically secure location.  You need the backup file to restore the key."></asp:Localize></p>
    			                <asp:HyperLink ID="GetBackup" runat="server" Text="Get Backup" NavigateUrl="GetKeyBackup.ashx" SkinID="Button"></asp:HyperLink>
                            </asp:Panel>
                            <asp:Panel ID="NoKeyNoBackupPanel" runat="server" Visible="false">
    			                <p><asp:Localize ID="NoKeyNoBackupInstructionText" runat="server" Text="You do not currently have an encryption key set.  You must set a key before you can use the backup tool."></asp:Localize></p>
                            </asp:Panel>
                        </div>
                    </div>
		            <div class="section">
                        <div class="header">
                            <h2 class="upload"><asp:Localize ID="RestoreCaption" runat="server" Text="Restore Encryption Key"></asp:Localize></h2>
                        </div>
                        <div class="content">
    			            <p><asp:Localize ID="RestoreInstructionText" runat="server" Text="When moving an installation to a different server, you will need to restore your encryption key by providing the backup file below. If you have a newer encryption key already set, then the key currently being used will be replaced with the backup resulting in loss of data. <b>Always use the latest key backup when performing a restore. </b>"></asp:Localize></p>
                            <p><asp:Localize ID="RestoreInstructionTextAC7" runat="server" Text="If you are restoring a backup key as part of an upgrade from AC7 you will have two backup files.  For backups generated from AC Gold there is only one file."></asp:Localize></p>
    			            <asp:ValidationSummary ID="RestoreValidationSummary" runat="server" ValidationGroup="Restore" />
		                    <asp:Label ID="RestoredMessage" runat="server" Text="Key backup restored at {0:t}" SkinID="GoodCondition" EnableViewState="false" Visible="false"></asp:Label>
		                    <table class="inputForm">
		                        <tr>
		                            <th>
		                                <asp:Label ID="BackupFileLabel" runat="server" Text="Backup File:"></asp:Label>
		                            </th>
		                            <td>
		                                <asp:FileUpload ID="BackupFile" runat="server" />
		                                <asp:RequiredFieldValidator ID="BackupFileValidator" runat="server" ControlToValidate="BackupFile"
		                                    Text="*" ErrorMessage="You must provide the backup file." Display="Dynamic"
		                                    ValidationGroup="Restore"></asp:RequiredFieldValidator>
		                                <asp:PlaceHolder ID="phRestoreValidators" runat="server"></asp:PlaceHolder>
		                            </td>
		                        </tr>
		                        <tr>
		                            <th>
		                                <asp:Label ID="BackupFile2Label" runat="server" Text="Backup File #2:"></asp:Label>
                                        <br />
                                        (AC7 upgrades only)
		                            </th>
		                            <td>
		                                <asp:FileUpload ID="BackupFile2" runat="server" /> 
		                            </td>
		                        </tr>
		                        <tr>
		                            <td>&nbsp;</td>
		                            <td>
		                                <asp:Button ID="RestoreButton" runat="server" Text="Restore Key" OnClientClick="if (Page_ClientValidate('Restore')){return confirm('The encryption key is about to be restored from backup.  Click OK to confirm.')}" OnClick="RestoreButton_Click" ValidationGroup="Restore" />
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