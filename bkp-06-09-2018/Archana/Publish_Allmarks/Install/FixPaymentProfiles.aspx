<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixPaymentProfiles.aspx.cs" Inherits="AbleCommerce.Install.FixPaymentProfiles" Title="Fix Payment Profiles" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:CheckBox ID="UseSandBox" runat="server" Text="Use Sandbox" />
        <asp:TextBox ID="FixLog" runat="server" TextMode="MultiLine" Height="300px" Width="100%"></asp:TextBox>
        <asp:Button ID="GoButton" runat="server" OnClick="GoButton_Click" Text="Fix"/>
    <div>
    </div>
</form>
</body>
</html>
