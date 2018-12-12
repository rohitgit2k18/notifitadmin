<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixUserConstraints.aspx.cs" Inherits="AbleCommerce.Install.FixUserConstraints" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Fix User Constraints</title>
    <style>
        p { font-size: 12px; margin:12px 0; }
        .sectionHeader { background-color: #EFEFEF; padding:3px; margin:12px 0px; }
        h2 { font-size: 14px; font-weight: bold; margin: 0px; }
        .error { font-weight:bold; color:red; }
        div.radio { margin:2px 0px 6px 0px; }
        div.radio label { font-weight:bold; padding-top: 6px; position:relative; top:1px; }
        .inputBox { padding:6px;margin: 4px 40px;border:solid 1px #CCCCCC; }
        div.submit { background-color: #EFEFEF; padding:4px; margin:12px 0px; text-align:center; }
        a.admin:link { color:black; text-decoration:underline; }
        a.admin:visited { color:black; text-decoration:underline; }
        a.admin:hover { color:blue; text-decoration:underline; }
        a.admin:active { color:black; text-decoration:underline; }
    </style>
</head>
<body style="width:780px;margin:auto">
    <form id="form1" runat="server">
    <h1>Fix User Constraints</h1>
    <asp:Panel ID="FixPanel" runat="server">
        This script can update the user constraints in your database.  You may need to do this if you have messages in your error log similar to:<br /><br />
        DELETE statement conflicted with COLUMN REFERENCE constraint 'ac_Users_ac_Orders_FK1'.<br /><br />
        When you click the button below, we will drop the existing constraint and recreate a new one with the correct values.  This should eliminate this error message from your logs.<br /><br />
        <asp:Button ID="FixButton" runat="server" Text="Fix Constraints" onclick="FixButton_Click" />
    </asp:Panel>
    <asp:Panel ID="ResultPanel" runat="server" Visible="false">
        The constraint has been updated in your database!<br /><br />If you continue to receive the errors in your log, please contact support for further assistance.<br /><br />
        <asp:HyperLink ID="AdminLink" runat="server" Text="Return to Admin" CssClass="admin"></asp:HyperLink>
    </asp:Panel>
    </form>
</body>
</html>
