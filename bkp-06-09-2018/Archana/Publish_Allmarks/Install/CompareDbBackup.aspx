<%@ Page Language="C#" AutoEventWireup="True" CodeFile="CompareDbBackup.aspx.cs" MasterPageFile="Install.Master" Inherits="AbleCommerce.Install.CompareDbBackup" %>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1><asp:Localize ID="PageCaption" runat="server" Text="Compare Database Backup Files" /></h1>   
    <asp:Panel ID="FormPanel" runat="server">
        <p>This is a beta version of a new compare database backup tool. It compares two 
            versions of database backup files and will list the unique Insert statements in 
            each backup file, which can then be used to generate a custom upgrade SQL 
            script. To use this utility, you need to provide two database backup files:</p>
            
        <ol>
            <li>First backup file: an earlier version of the database, e.g. a backup taken just 
                after installing/upgrading your store.</li>
            <li>Second backup file: a recent backup with some changes, e.g. after preparing your 
                upgraded store for production.</li>
        </ol>
        <p>The compare database backup tool can help you quickly apply changes to your live 
            server by helping you generate an upgrade SQL script. However, in most of the 
            cases, the SQL compare results/script cannot be used as an SQL script to 
            directly execute and upgrade the database in this format, as records with same 
            ID values might already exist. In some cases, you may need to delete/drop the 
            existing records and insert new ones, or create upgrade statements where needed. </p>
        <p>While upgrading your LIVE website using a local staging website, the compare 
            results can also be used as a reference and to quickly apply the changes 
            manually one by one.</p>
        <p><strong>NOTE: Database backup can be saved/downloaded as a SQL file using the database backup feature (Administration &gt; Data &gt; Database Backup)</strong></p>
        <p class="disclaimer">Disclaimer: This is an unsupported tool. Make a backup of your database before using this script.</p>
        <asp:ValidationSummary ID="ValidationSummary1" CssClass="validationSummary" runat="server" />
        <table cellpadding="5" cellspacing="0">
            <tr>
                <th align="right" valign="top">
                    First Database backup file:
                </th>
                <td>
                    <asp:FileUpload ID="FirstBackup" runat="server" />
                    <asp:RequiredFieldValidator ID="FirstBackupValidator" runat="server" ControlToValidate="FirstBackup" Text="*" ErrorMessage="First backup file is not provided."></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th align="right" valign="top">
                    Second Database backup file:
                </th>
                <td>
                    <asp:FileUpload ID="SecondBackup" runat="server" />
                    <asp:RequiredFieldValidator ID="SecondBackupValidator" runat="server" ControlToValidate="FirstBackup" Text="*" ErrorMessage="Second backup file is not provided."></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="CompareButton" runat="server" Text="Compare" OnClick="CompareButton_Click" />
                </td>
            </tr>
        </table>
        <br />
        <asp:TextBox ID="results" runat="server" Rows="10" Columns="100" Visible="false" TextMode="MultiLine"></asp:TextBox>

    </asp:Panel>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="HtmlHead">
    <style type="text/css">
        .disclaimer {
            color: #FF0000;
            font-weight:bold;
        }
    </style>
</asp:Content>
