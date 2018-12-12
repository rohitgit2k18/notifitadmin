<%@Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.Security.Connection" Title="Edit Database Connection String"  CodeFile="Connection.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Database Connection String"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/security" />
        </div>
    </div>
    <asp:UpdatePanel ID="SettingsPanel" runat="server">
        <ContentTemplate>
            <div class="content">
                <p><asp:Localize ID="DatabaseHelpText" runat="server" Text="You can modify the connection string in the field below.  You are responsible for making sure that the specified database has the appropriate structure and data.  Providing an incorrect connection string can disable your installation of AbleCommerce."></asp:Localize></p>
                <cb:Notification ID="ErrorMessage" runat="server" Visible="false" SkinID="ErrorCondition" EnableViewState="false"></cb:Notification>
                <cb:Notification ID="SavedMessage" runat="server" Visible="false" SkinID="GoodCondition" EnableViewState="false"></cb:Notification>
                <table class="inputForm">
                    <tr>
                        <th>
                            <asp:Localize ID="ExistingConnectionStringLabel" runat="Server" Text="Current Connection String:"></asp:Localize>
                        </th>
                        <td>
                            <asp:Literal ID="ExistingConnectionString" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Localize ID="ConnectionStringLabel" runat="Server" Text="New Connection String:"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="ConnectionString" runat="server" Width="700px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:CheckBox ID="EncryptIt" runat="server" Checked="true" />
                            <asp:Localize ID="EncryptItText" runat="server" Text="Encrypt the connection string in the database.config file."></asp:Localize>
                            <asp:PlaceHolder ID="NoFullTrustPanel" runat="server" Visible="true">
                                <p style="width:700px;"><asp:Localize ID="NoFullTrustLocalize" runat="server">We detected that your application is not running under ASP.NET Full Trust which means you will not be able to use Encrypt/Decrypt connection string feature. Any updates made to connection string will be stored in plain text.</asp:Localize> </p>
                            </asp:PlaceHolder>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:CheckBox ID="AckBox" runat="server" />
                            <asp:Localize ID="AckHelpText" runat="server" Text="I understand that providing an incorrect connection string can disable your installation of AbleCommerce."></asp:Localize>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="UpdateButton" runat="server" Text="Change" OnClick="UpdateButton_Click" />
                            <asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>