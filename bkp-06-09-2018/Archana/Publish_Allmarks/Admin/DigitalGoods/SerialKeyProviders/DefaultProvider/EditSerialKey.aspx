<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.DigitalGoods.SerialKeyProviders.DefaultProvider.EditSerialKey" Title="Configure Serial Keys"  CodeFile="EditSerialKey.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="pageHeader">
    <div class="caption">
        <h1><asp:Localize ID="Caption" runat="server" Text="Edit A Serial Key For '{0}'"></asp:Localize></h1>
    </div>
</div>
<div class="content">
    <table cellspacing="0" class="inputForm">
        <tr>
            <th valign="top">
                <cb:ToolTipLabel ID="SerialKeyDataLabel" runat="server" Text="Serial Key Data:" AssociatedControlID="SerialKeyData" ToolTip="Enter the full serial key here." />
            </th>
            <td>
                <asp:TextBox ID="SerialKeyData" runat="server" Width="400" TextMode="multiLine" style="height:100px;"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>            
                <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
			    <asp:Button ID="CancelButton" runat="server" Text="Cancel" CausesValidation="false" OnClick="CancelButton_Click" />
            </td>
        </tr>
    </table>
</div>
</asp:Content>