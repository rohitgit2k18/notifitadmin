<%@ Page Title="Install AbleCommerce (Step 1 of 2)" Language="C#" MasterPageFile="Install.Master" AutoEventWireup="true" CodeFile="Configure1.aspx.cs" Inherits="AbleCommerce.Install.Configure1" %>
<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <h1><asp:Localize ID="PageCaption" runat="server" Text="Install AbleCommerce {0} (Step 1 of 2)" /></h1>   
    <asp:Panel ID="FormPanel" runat="server">
        <p>Provide your license key and database connection to complete the first step of installation.</p>
        <asp:Panel ID="MessagePanel" runat="server" Visible="false">
            <div class="sectionHeader"><h2 class="warning">Configuration Error</h2></div>
            <asp:Literal ID="ReponseMessage" runat="server"></asp:Literal>
        </asp:Panel>
        <asp:ValidationSummary ID="ValidationSummary1" CssClass="validationSummary" runat="server" />
        <div class="sectionHeader">
            <h2>License Key</h2>
        </div>
        <div class="radio"><asp:RadioButton ID="DemoKeyOption" runat="server" Checked="true" Text="30 Day Free Trial" OnCheckedChanged="KeyChoiceChanged" AutoPostBack="true" GroupName="KeyOption" /></div>
        <asp:PlaceHolder ID="DemoKeyPanel" runat="server" Visible="true">
            <div class="inputBox">
                <table cellpadding="5" cellspacing="0">
                    <tr>
                        <th align="right" valign="top">
                            Your Email:
                        </th>
                        <td>
                            <asp:TextBox ID="Email" runat="server" MaxLength="200"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="EmailRequired" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter your email." ControlToValidate="Email"></asp:RequiredFieldValidator><br />
                        </td>
                    </tr>
                    <tr>
                        <th align="right">
                            Your Name:
                        </th>
                        <td>
                            <asp:TextBox ID="Name" runat="server" MaxLength="50"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="NameRequired" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter your name." ControlToValidate="Name"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th align="right">
                            Company Name:
                        </th>
                        <td>
                            <asp:TextBox ID="Company" runat="server" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th align="right">
                            Phone Number:
                        </th>
                        <td>
                            <asp:TextBox ID="Phone" runat="server" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div><br />
        </asp:PlaceHolder>
        <div class="radio"><asp:RadioButton ID="LicenseKeyOption" runat="server" Checked="false" Text="Enter License Key" OnCheckedChanged="KeyChoiceChanged" AutoPostBack="true" GroupName="KeyOption" /></div>
        <asp:PlaceHolder ID="LicenseKeyPanel" runat="server" Visible="false">
            <div class="inputBox">
                <table cellpadding="5" cellspacing="0">
                    <tr>
                        <th align="right" valign="top">
                            License Key:
                        </th>
                        <td>
                            <asp:TextBox ID="LicenseKey" runat="server" Text="" MaxLength="38" Width="300px"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="LicenseKeyRequired" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter the license key." ControlToValidate="LicenseKey"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="LicenseKeyFormat" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="Your license key does not match the expected format." ControlToValidate="LicenseKey"
                                ValidationExpression="^\{?[A-Fa-f0-9]{8}-?([A-Fa-f0-9]{4}-?){3}[A-Fa-f0-9]{12}\}?$"></asp:RegularExpressionValidator>
                            <br />(e.g. FD6B09C0-2AC9-4059-AE89-F27AB9285AAF)
                        </td>
                    </tr>
                </table>
            </div><br />
        </asp:PlaceHolder>
        <div class="radio"><asp:RadioButton ID="UploadKeyOption" runat="server" Checked="false" Text="Upload License File" OnCheckedChanged="KeyChoiceChanged" AutoPostBack="true" GroupName="KeyOption" /></div>
        <asp:PlaceHolder ID="UploadKeyPanel" runat="server" Visible="false">
            <div class="inputBox">
                <table cellpadding="5" cellspacing="0">
                    <tr>
                        <th align="right" valign="top">
                            Key File:
                        </th>
                        <td>
                            <asp:FileUpload ID="KeyFile" runat="server" Width="200px" />
                        </td>
                    </tr>
                </table>
            </div><br />
        </asp:PlaceHolder>
        <div class="sectionHeader">
            <h2>Database Connection</h2>
        </div>
        <p>Specify the database that will be used by AbleCommerce:</p>
        <div class="radio"><asp:RadioButton ID="DbLocal" runat="server" Checked="true" Text="Use supplied SQL Server database (Non-Production Environments)" OnCheckedChanged="DatabaseChoiceChanged" AutoPostBack="true" GroupName="DbOption" /></div>
        <asp:PlaceHolder ID="DbLocalPanel" runat="server" Visible="true">
            <div class="inputBox">
                <p>To use this option, you must ensure that the server running AbleCommerce has SQL Server 2005 or higher installed and running.  Express editions are supported.  Also note that user instances must be enabled in SQL Server.  If you aren't sure what this means you can safely ignore it and try to continue the setup.  You will be notified if the database is not configured correctly.</p>
                <p>You can also change the database instance name if it is different from the supplied default.  Again if you aren't sure, just leave it alone and continue.  You'll receive a warning if a connection to the database can't be established and no harm will result.</p>
                <table cellpadding="5" cellspacing="0">
                    <tr>
                        <th align="right">
                            Database Instance:
                        </th>
                        <td>
                            <asp:TextBox ID="DbLocalInstanceName" runat="server" MaxLength="100" Width="200px" Text=".\SQLEXPRESS"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="DbLocalInstanceNameRequired" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter the database instance name." ControlToValidate="DbLocalInstanceName"></asp:RequiredFieldValidator>
                        </td>
                    </tr>                                    
                </table>
            </div>
        </asp:PlaceHolder>
        <div class="radio"><asp:RadioButton ID="DbSimple" runat="server" Checked="false" Text="Specify database"  OnCheckedChanged="DatabaseChoiceChanged" AutoPostBack="true" GroupName="DbOption" /></div>
        <asp:PlaceHolder ID="DbSimplePanel" runat="server" Visible="false">
            <div class="inputBox">
                <p>To use this option, the database you specify must already exist.  Also, the user name you provide must have permission to create tables and indexes.</p>
                <table cellpadding="5" cellspacing="0">
                    <tr>
                        <th align="right" valign="top">
                            Server Name:
                        </th>
                        <td>
                            <asp:TextBox ID="DbServerName" runat="server" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="DbServerNameRequired" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter the host name of the database server." ControlToValidate="DbServerName"></asp:RequiredFieldValidator><br />
                            <p>You can enter <b>.</b> if the database server is the same as the web server.</p>
                        </td>
                    </tr>
                    <tr>
                        <th align="right" valign="top">
                            Database Name:
                        </th>
                        <td>
                            <asp:TextBox ID="DbDatabaseName" runat="server" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="DbDatabaseNameRequired" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter the name of the database." ControlToValidate="DbDatabaseName"></asp:RequiredFieldValidator><br />
                        </td>
                    </tr>
                    <tr>
                        <th align="right" valign="top">
                            Database User:
                        </th>
                        <td>
                            <asp:TextBox ID="DbUserName" runat="server" MaxLength="50"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="DbUserNameValidator" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter the user name for the database." ControlToValidate="DbUserName"></asp:RequiredFieldValidator><br />
                        </td>
                    </tr>
                    <tr>
                        <th align="right" valign="top">
                            Database Password:
                        </th>
                        <td>
                            <asp:TextBox ID="DbPassword" runat="server" MaxLength="40" TextMode="Password"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="DbPasswordValidator" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter the password for the database user." ControlToValidate="DbPassword"></asp:RequiredFieldValidator><br />
                        </td>
                    </tr>
                    <tr>
	                    <th valign="top" align="right">
	                        Install Type:
	                    </th>
	                    <td>
	                        <asp:RadioButton ID="NewInstall1" runat="server" Checked="true" Text="This is a new database." GroupName="InstallType" />
	                        <br />
	                        <asp:RadioButton ID="AC7Database1" runat="server" Text="This is an existing AC7 database to be upgraded." GroupName="InstallType" />
	                    </td>
                    </tr>
                </table>
            </div><br />
        </asp:PlaceHolder>
        <div class="radio"><asp:RadioButton ID="DbAdvanced" runat="server" Checked="false" Text="Specify connection string (Advanced)" OnCheckedChanged="DatabaseChoiceChanged" AutoPostBack="true" GroupName="DbOption" /></div>
        <asp:PlaceHolder ID="DbAdvancedPanel" runat="server" Visible="false">
            <div class="inputBox">
                <p>To use this option, specify the connection string for the database you want to use.</p>
                <table cellpadding="5" cellspacing="0">
                    <tr>
                        <th align="right">
                            Connection String:
                        </th>
                        <td>
                            <asp:TextBox ID="DbConnectionString" runat="server" MaxLength="200" Width="300px"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="DbConnectionStringRequired" runat="server" Text="*" CssClass="requiredField"
                                ErrorMessage="You must enter the database connection string." ControlToValidate="DbConnectionString"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th valign="top" align="right">
                            Install Type:
                        </th>
                        <td>
                            <asp:RadioButton ID="NewInstall2" runat="server" Checked="true" Text="This is a new database." GroupName="InstallType" />
                            <br />
                            <asp:RadioButton ID="AC7Database2" runat="server" Text="This is an existing AC7 database to be upgraded." GroupName="InstallType" />
                        </td>
                    </tr>                                    
                </table>
            </div><br />
        </asp:PlaceHolder>                
        <div class="sectionHeader">
            <h2>PCI Compliance</h2>
        </div>
        <div class="inputBox">
            <p>AbleCommerce provides documentation and a moderated forum to assist you with configuring your software in a PCI compliant manner.  Please review the secure implementation guide prior to installation of AbleCommerce.</p>
            <p>The secure implementation guide is at: <a href="http://www.ablecommerce.com/Able_Gold_R11_PCI_Guide.pdf" target="_blank">http://www.ablecommerce.com/Able_Gold_R11_PCI_Guide.pdf</a><br />
            The moderated forum is at: <a href="http://forums.ablecommerce.com/viewforum.php?f=46" target="_blank">http://forums.ablecommerce.com/viewforum.php?f=46</a></p>
            <asp:CheckBox ID="PCIAcknowledgement" runat="server" Checked="false" /> <b>Check here to acknowledge that you have reviewed the secure implementation guide.</b>
        </div>
        <div class="buttonPanel">
            <asp:Button ID="InstallButton" runat="server" Text="Continue >" OnClick="InstallButton_Click" OnClientClick="return ExecuteInstall();" CssClass="button" />
            <asp:Button ID="FullPostbackInstallButton" runat="server" Text="Continue >" OnClick="InstallButton_Click" OnClientClick="return ExecuteInstall();" CssClass="button" Visible="false" />
        </div>
    </asp:Panel>
    <div id="progressPanel" class="progressPanel">
        <div class="sectionHeader"><h2>Configuring Database</h2></div>  
        <p>Please be patient as this may take a few moments...</p>
        <img src="installing.gif" alt="" />
    </div>
    <asp:Placeholder ID="ConfigurationCompletePanel" runat="server" Visible="false">
        <div class="sectionHeader">
            <h2><asp:Localize ID="ConfigurationCompleteCaption" runat="server" Text="Database Configuration Complete"></asp:Localize></h2>
        </div>
        <p><asp:Localize ID="ConfigurationCompleteText" runat="server" Text="The database has been configured.  Click continue to provide the basic details of your new store."></asp:Localize></p>
        <div class="buttonPanel">
            <asp:Button ID="ContinueButton" runat="server" Text="Continue &gt;" OnClientClick="window.location.href='Configure2.aspx';return false;" CssClass="button" />
        </div>
    </asp:Placeholder>
    <asp:Placeholder ID="ConfigurationErrorPanel" runat="server" Visible="false">
        <div class="sectionHeader">
            <h2 class="warning"><asp:Localize ID="ConfigurationErrorCaption" runat="server" Text="Database Configuration Failed"></asp:Localize></h2>
        </div>
        <p><asp:Localize ID="ConfigurationErrorText" runat="server" Text="The errors listed below occurred while trying to configure the database.  You may be able to continue the install depending on the error messages."></asp:Localize></p>
        <asp:Literal ID="ConfigurationErrorList" runat="server"></asp:Literal>
        <div class="buttonPanel">
            <asp:Button ID="ContinueButton2" runat="server" Text="Continue &gt;" OnClientClick="window.location.href='Configure2.aspx';return false;" CssClass="button" />
        </div>
    </asp:Placeholder>
    <script type="text/javascript">
    function ExecuteInstall() {
        if (Page_ClientValidate()) {
            document.getElementById('progressPanel').style.display = "block";
            document.getElementById('<%=FormPanel.ClientID%>').style.display = "none";
            return true;
        }
        return false;
    }
    </script>
</asp:Content>
