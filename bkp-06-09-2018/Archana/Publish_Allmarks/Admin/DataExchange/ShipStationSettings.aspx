<%@ Page Title="ShipStation Status Updates" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" CodeFile="ShipStationSettings.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.ShipStationSettings" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="ShipStation Export"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="data/shipstation" />
        </div>
    </div>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <div class="section">
        <asp:ValidationSummary ID="ValidationSummary2" runat="server" />
        <cb:Notification ID="SavedMessage" runat="server" Text="The ShipStation settings have been saved." Visible="false" SkinID="GoodCondition"></cb:Notification>
        <table cellpadding="0" cellspacing="0" class="inputForm">
            <tr>
                <th>
                    <cb:ToolTipLabel ID="APIKeyLabel" runat="server" AssociatedControlID="APIKey" Text="API Key:" ToolTip="Your Ship Station API key." /> 
                </th>
                <td>
                    <asp:TextBox ID="APIKey" runat="server" Width="350"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="APIKeyRequired" ControlToValidate="APIKey" runat="server" Text="*" ErrorMessage="API key is required."></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="APISecretLabel" runat="server" AssociatedControlID="APISecret" Text="API Secret:" ToolTip="Your Ship Station API secret." /> 
                </th>
                <td>
                    <asp:TextBox ID="APISecret" runat="server" Width="350"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="APISecretRequired" ControlToValidate="APISecret" runat="server" Text="*" ErrorMessage="API secret is required."></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="APIBaseUrlLabel" runat="server" AssociatedControlID="APIBaseUrl" Text="API Base Url:" ToolTip="API base Url." />
                </th>
                <td>
                    <asp:TextBox ID="APIBaseUrl" runat="server" Width="350"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="APIBaseURLRequired" ControlToValidate="APIBaseUrl" runat="server" Text="*" ErrorMessage="API base URL is required."></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <th></th>
                <td>
                    <asp:Button ID="SaveButton" runat="server" OnClick="SaveButton_Click" Text="Save" />
                </td>
            </tr>
        </table>
    </div>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>
