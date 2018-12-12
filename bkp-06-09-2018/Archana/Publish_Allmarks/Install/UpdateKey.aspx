<%@ Page Language="C#" AutoEventWireup="true" Inherits="CommerceBuilder.Licensing.UpdateKey" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Update License Key</title>
    <style type="text/css">
        html {overflow-y: scroll;}
        body{ background:#071f45; margin:0; font-family:Arial, Helvetica, sans-serif; font-size:medium; }
        #container{ margin:0px auto; width:960px; background:#FFFFFF; top:0px; left:0px;}
        hr.border{background:#9a2c5d;height:10px;margin:0px;border:0;}
        #pageBody{width:920px; padding:10px 20px;}
        h1 { font-size:24px; font-weight: bold; margin: 8px 0px; color:#0A1A33}
        .sectionHeader { background-color: #EFEFEF; padding:3px; margin:12px 0px;}
        .sectionHeader h2 {font-size: 16px; font-weight: bold; margin: 0px; padding:5px 0 5px 5px}
        .sectionHeader h2.warning {padding-left:30px;background:url('warning.gif') no-repeat left top;}
        p{margin-top:0px;}
        div.buttonPanel{text-align:center;margin-top:20px;}
        div.buttonPanel input.button { background:#5271A2; color:#fff; font-weight:bold; padding:5px 10px 4px; border:1px solid #000; min-width:80px; margin:0 6px; }
        div.buttonPanel input.button:hover { background:#98AED1; color:#9a2c5d; font-weight:bold; padding:5px 10px 4px; border:1px solid #9a2c5d; min-width:80px; }
        div.progressPanel{margin:6px 0;display:none}
        .errorPanel{color:#000;font-weight:bold;border:solid 1px #9a2c5d;margin:6px;padding:4px;}
        .inputBox {padding:6px;margin:4px 40px;border:solid 1px #CCCCCC; }
    </style>
</head>
<body>
<form id="form1" runat="server">
<asp:ScriptManager ID="ScriptManager" runat="server" EnablePartialRendering="true"></asp:ScriptManager>
<div id="container">
<hr class="border" />
<div id="pageBody">
    <h1><asp:Localize ID="PageCaption" runat="server" Text="Update License Key" /></h1>
    <asp:UpdatePanel ID="UpdatePanel" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="FullPostbackUpdateButton" />
        </Triggers>
        <ContentTemplate>
            <asp:Panel ID="FormPanel" runat="server">
                <p>Update your license key using one of the options below.</p>
                <asp:Panel ID="MessagePanel" runat="server" Visible="false">
                    <div class="sectionHeader"><h2 class="warning">License Error</h2></div>
                    <asp:Literal ID="ReponseMessage" runat="server"></asp:Literal>
                </asp:Panel>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <div class="radio"><asp:RadioButton ID="DemoKeyOption" runat="server" Checked="false" Text="30 Day Free Trial" OnCheckedChanged="KeyChoiceChanged" AutoPostBack="true" GroupName="KeyOption" /></div>
                <asp:PlaceHolder ID="DemoKeyPanel" runat="server" Visible="false">
                    <div class="inputBox">
                        <table cellpadding="5" cellspacing="0">
                            <tr>
                                <th align="right" valign="top">
                                    Your Email:
                                </th>
                                <td>
                                    <asp:TextBox ID="Email" runat="server" MaxLength="200"></asp:TextBox> required
                                    <asp:RequiredFieldValidator ID="EmailRequired" runat="server" Text="*"
                                        ErrorMessage="You must enter your email." ControlToValidate="Email"></asp:RequiredFieldValidator><br />
                                </td>
                            </tr>
                            <tr>
                                <th align="right">
                                    Your Name:
                                </th>
                                <td>
                                    <asp:TextBox ID="Name" runat="server" MaxLength="50"></asp:TextBox> required
                                    <asp:RequiredFieldValidator ID="NameRequired" runat="server" Text="*"
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
                <div class="radio"><asp:RadioButton ID="LicenseKeyOption" runat="server" Checked="true" Text="Enter License Key" OnCheckedChanged="KeyChoiceChanged" AutoPostBack="true" GroupName="KeyOption" /></div>
                <asp:PlaceHolder ID="LicenseKeyPanel" runat="server" Visible="true">
                    <div class="inputBox">
                        <table cellpadding="5" cellspacing="0">
                            <tr>
                                <th align="right" valign="top">
                                    License Key:
                                </th>
                                <td>
                                    <asp:TextBox ID="LicenseKey" runat="server" Text="" MaxLength="38" Width="300px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="LicenseKeyRequired" runat="server" Text="*"
                                        ErrorMessage="You must enter the license key." ControlToValidate="LicenseKey"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="LicenseKeyFormat" runat="server" Text="*"
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
                <div class="buttonPanel">
                    <asp:Button ID="UpdateButton" runat="server" Text="Update Key" OnClick="UpdateButton_Click" OnClientClick="return ExecuteInstall();" CssClass="button" />
                    <asp:Button ID="FullPostbackUpdateButton" runat="server" Text="Update Key" OnClick="UpdateButton_Click" OnClientClick="return ExecuteInstall();" CssClass="button" Visible="false" />
                </div>
            </asp:Panel>
            <asp:Placeholder ID="KeyUpdatedPanel" runat="server" Visible="false">
                <div class="sectionHeader">
                    <h2><asp:Localize ID="KeyUpdatedCaption" runat="server" Text="License Key Updated"></asp:Localize></h2>
                </div>
                <p>
                    <asp:Localize ID="KeyUpdatedText" runat="server" Text="The license key has been updated. "></asp:Localize>
                    <asp:HyperLink ID="StoreLink" runat="server" NavigateUrl="../default.aspx">Click here</asp:HyperLink> to view store.
                </p>
            </asp:Placeholder>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
<hr class="border" />
</div>
</form>
</body>
</html>