<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Logout.aspx.cs" Inherits="AbleCommerce.Admin.Logout" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AbleCommerce: Software that Sells!(TM)</title>
	<script src="../Scripts/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui.min.js" type="text/javascript"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" AsyncPostBackTimeOut="600" />
        <div class="container_12" id="grid" style="margin-top:100px;">
            <div class="grid_6 push_3">
                <div class="section orphanSection">
                    <div class="header">
                        <h2><asp:Localize ID="Caption" runat="server" Text="Logged Out"></asp:Localize></h2>
                    </div>
                    <div class="content">
                        <p class="text">
                            You have been logged out. If you wish to access the administration again <asp:HyperLink ID="LoginLink" runat="server" Text="click here" NavigateUrl="~/Admin/Login.aspx"></asp:HyperLink> to login. 
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>