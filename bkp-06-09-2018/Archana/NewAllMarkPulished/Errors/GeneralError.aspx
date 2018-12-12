<%@ Page language="c#" AutoEventWireup="false" Inherits="AbleCommerce.Errors.GeneralError" CodeFile="GeneralError.aspx.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" > 
<html>
<head id="Head1" runat="server">
    <title>Server error</title>
</head>
<body>    
    <p>We are sorry, but the page you are trying to access has experienced an error.</p>    
    <p>Please contact <b><%=GetContact()%></b> to report this problem.</p>
</body>
</html>
