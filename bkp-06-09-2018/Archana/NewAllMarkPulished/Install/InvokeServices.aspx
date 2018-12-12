<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvokeServices.aspx.cs" Inherits="AbleCommerce.Install.InvokeServices" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Invoke Services</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="MeesageLabel" runat="server" EnableViewState="false" ForeColor="Green"></asp:Label>
        <table class="inputForm">
            <tr>
                <th class="rowHeader">
                    Recurring Order Service:
                </th>
                <td>
                    <asp:LinkButton ID="InvokeRecurringOrderServiceButton" runat="server" 
                        Text="Invoke" onclick="InvokeRecurringOrderServiceButton_Click"></asp:LinkButton>
                </td>
            </tr>
            <tr>
                <th class="rowHeader">
                    Maintenance Service:
                </th>
                <td>
                    <asp:LinkButton ID="MaintenanceServiceButton" runat="server" 
                        Text="Invoke" onclick="MaintenanceServiceButton_Click"></asp:LinkButton>
                </td>
            </tr>
            <tr>
                <th class="rowHeader">
                    Review Reminder Service:
                </th>
                <td>
                    <asp:LinkButton ID="ReviewReminderServiceButton" runat="server" 
                        Text="Invoke" onclick="ReviewReminderServiceButton_Click"></asp:LinkButton>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
