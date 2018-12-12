<%@ Page Language="C#" MasterPageFile="Install.Master" AutoEventWireup="true" Inherits="Install_Upgrade" Title="Upgrade AbleCommerce Database" CodeFile="Upgrade.aspx.cs" %>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
<script type="text/javascript" language="JavaScript">
    var counter = 0;
    function plswt() {
        counter++;
        if (counter > 1) {
            alert("You have already submitted this form.  Please wait while the install processes.");
            return false;
        }
        return true;
    }
    function ExecuteInstall() {
        if (Page_ClientValidate()) {
            document.getElementById('progressPanel').style.display = "block";
            document.getElementById('<%=UpgradePanel.ClientID%>').style.display = "none";
            return true;
        }
        return false;
    }
</script>
<asp:PlaceHolder ID="phUpgrade" runat="server" EnableViewState="false" Visible="true">
    <br />
    <div class="sectionHeader">
        <h1 style="font-size:16px">Upgrade AbleCommerce Database</h1>
    </div>
    <asp:Panel ID="UpgradePanel" runat="server" CssClass="inputBox">
        You are about to upgrade your database to AC Gold.<br /><br />
        Make sure you have a backup of your database before you run the upgrade scripts.  Upgrade scripts are designed to keep your data safe, but if something unexpectedly goes wrong and you do not have a backup you may not be able to recover your data.<br /><br />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="validationSummary" />
        Type <b>BACKUP</b> in the space provided to confirm you understand: <asp:TextBox ID="TypeBackup" runat="server" Text="" MaxLength="6" Width="80"></asp:TextBox><span class="requiredField">*</span>
        <asp:RequiredFieldValidator ID="TypeBackupRequired" runat="server" Text="*"
            ErrorMessage="You must type BACKUP in the space provided." ControlToValidate="TypeBackup" CssClass="requiredField"></asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="TypeBackupFormat" runat="server" Text="*"
            ErrorMessage="You must type BACKUP in the space provided." ControlToValidate="TypeBackup"
            ValidationExpression="^BACKUP$" CssClass="requiredField"></asp:RegularExpressionValidator><br /><br />
        <br />
        <div class="buttonPanel">
            <asp:Button ID="UpgradeButton" runat="server" Text="UPGRADE" OnClick="UpgradeButton_Click" OnClientClick="return ExecuteInstall();" />
        </div>
    </asp:Panel>
</asp:PlaceHolder>
<div id="progressPanel" class="progressPanel">
    <div class="sectionHeader"><h2>Initializing Data</h2></div>  
    <p>Please be patient as this may take a few moments...</p>
    <img src="installing.gif" alt="" />
</div>
<asp:Panel ID="MessagePanel" runat="server" Visible="false">
    <div class="sectionHeader"><h2 class="warning">Upgrade Error</h2></div>
    <asp:Literal ID="ReponseMessage" runat="server"></asp:Literal>
</asp:Panel>
<asp:Placeholder ID="UpgradeCompletePanel" runat="server" Visible="false">
    <div class="sectionHeader">
        <h2><asp:Localize ID="UpgradeCompleteCaption" runat="server" Text="Database Upgrade Complete"></asp:Localize></h2>
    </div>
    <asp:PlaceHolder ID="IndexesInfoPanel" runat="server" Visible="false">
        <p><asp:Localize ID="IndexesInfoText" runat="server" Text="As part of the upgrade process, a rebuild of your search indexes was started. If you have upgraded a database with lots of data, this could take a few minutes, and the process needs to complete before searches of your store data will be fully functional. You can check on and monitor the progress of the index rebuild by going to the Website > Indexes menu of your merchant administration."></asp:Localize> </p>
    </asp:PlaceHolder>
    <asp:Placeholder ID="UpgradeErrorPanel" runat="server" Visible="false">
        <p><asp:Localize ID="UpgradeErrorText" runat="server" Text="The errors listed below occurred while upgrading the database:"></asp:Localize></p>
        <asp:Literal ID="UpgradeErrorList" runat="server"></asp:Literal>
    </asp:Placeholder>
    <asp:Placeholder ID="UpgradeWarningPanel" runat="server" Visible="false">
        <p><asp:Localize ID="UpgradeWarnText" runat="server" Text="The following messages are for informational purposes:"></asp:Localize></p>
        <asp:Literal ID="UpgradeWarnList" runat="server"></asp:Literal>
    </asp:Placeholder>
    <p><asp:Localize ID="UpgradeCompleteText" runat="server" Text="The database has been upgraded."></asp:Localize></p>
    <div class="buttonPanel">
        <asp:HyperLink ID="ContinueButton" runat="server" Text="Continue To Admin" NavigateUrl="~/Admin/Default.aspx" CssClass="button" />
    </div>
</asp:Placeholder>
</asp:Content>
