<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Admin.master" CodeFile="DatabaseBackup.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.DatabaseBackup" Title="Backup Database" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Backup Database"></asp:Localize></h1>
            <div class="links">
                <cb:NavigationLink ID="ProductExportLink" runat="server" SkinID="Button" NavigateUrl="productsexport.aspx" Text="EXPORT PRODUCTS"></cb:NavigationLink>
                <cb:NavigationLink ID="OrderExportLink" runat="server" SkinID="Button" NavigateUrl="ordersexport.aspx" Text="EXPORT ORDERS"></cb:NavigationLink>
                <cb:NavigationLink ID="UpsWSExportLink" runat="server" SkinID="Button" NavigateUrl="upswsexport.aspx" Text="EXPORT WORLDSHIP"></cb:NavigationLink>
                <cb:NavigationLink ID="ProductImportLink" runat="server" SkinID="Button" NavigateUrl="productimport.aspx" Text="IMPORT PRODUCTS"></cb:NavigationLink>
                <cb:NavigationLink ID="OrderImportLink" runat="server" SkinID="Button" NavigateUrl="variantsimport.aspx" Text="IMPORT VARIANTS"></cb:NavigationLink>
                <cb:NavigationLink ID="UpsWSImportLink" runat="server" SkinID="Button" NavigateUrl="upswsimport.aspx" Text="IMPORT WORLDSHIP"></cb:NavigationLink>
                <cb:NavigationLink ID="BackUpLink" runat="server" SkinID="ActiveButton" NavigateUrl="databasebackup.aspx" Text="BACKUP"></cb:NavigationLink>
            </div>
    	</div>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="BackupUpdatePanel" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="HiddenStartedTime" runat="server" />
                <asp:Panel ID="BackupPanel" runat="server">
                    <asp:Label ID="Instructions" runat="server" Text="Click the backup button to backup your database as sql scripts. It will take some time depending upon the database size."></asp:Label>
                    <br />
                    <asp:Button ID="BackupButton" runat="server" Text="Backup Database" OnClick="BackupButton_Click" />
                </asp:Panel>
                <asp:Panel ID="ProgressPanel" runat="server" Visible="false">
                    <asp:HiddenField ID="BackupFileName" runat="server" />
                    <p><asp:Image ID="ProgressImage" runat="server" SkinID="Progress" /></p>
                    <p><asp:Localize ID="ProgressLabel" runat="server" Text="A database backup operation was started and has been running for {0} minutes and {1} seconds." EnableViewState="false"></asp:Localize></p>
                    <p>Please be patient while the process completes.</p>
                </asp:Panel>
                <cb:Notification ID="BackupCompleteMessage" runat="server" Text="Database backup complete at {0:t}" SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
                <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <asp:UpdatePanel ID="BackupFilesPanel" runat="server">
        <ContentTemplate>
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="BackupCaption" runat="server" Text="Database Backups" EnableViewState="false"></asp:Localize></h2>
                </div>
                <div class="content">
                    <cb:AbleGridView ID="BackupFilesGrid" runat="server"
                        AutoGenerateColumns="False"
                        AllowPaging="false"
                        AllowSorting="false"
                        TotalMatchedFormatString=" {0} backup files."
                        SkinID="PagedList"
                        ShowWhenEmpty="true"
                        OnRowCommand="BackupFilesGrid_RowCommand"
                        Width="100%">
                        <Columns>
                            <asp:BoundField HeaderText="File Name" DataField="FileName" HeaderStyle-HorizontalAlign="Left"/>
                            <asp:BoundField HeaderText="Size (KB)" DataField="Size" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"/>
                            <asp:TemplateField HeaderText="Action">
                                <ItemStyle HorizontalAlign="Center" Width="100" />
                                <ItemTemplate>
                                    <asp:HyperLink ID="DownloadLink" runat="server" NavigateUrl='<%# Eval("FileName", "BackupDownloader.ashx?File=DbBackup/{0}") %>'><asp:Image ID="DownloadIcon" runat="server" SkinID="DownloadIcon" /></asp:HyperLink>
                                    <asp:ImageButton ID="DeleteButton" runat="server" ToolTip="Delete" CommandName="Do_Delete" CommandArgument='<%#Eval("FileName")%>' SkinID="DeleteIcon" OnClientClick='<%# Eval("FileName", "return confirm(\"Are you sure you want to delete {0}?\")") %>'></asp:ImageButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Localize ID="NoBackupMessage" runat="server" Text="No database backup available."></asp:Localize>
                        </EmptyDataTemplate>
                    </cb:AbleGridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
