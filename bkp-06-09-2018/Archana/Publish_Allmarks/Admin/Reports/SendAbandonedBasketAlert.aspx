<%@ Page Title="Send Abandoned Basket Alert" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="SendAbandonedBasketAlert.aspx.cs" Inherits="AbleCommerce.Admin.Reports.SendAbandonedBasketAlert" ViewStateMode="Disabled" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="Send Abandoned Basket Alert"></asp:Localize>
            </h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/customers" />
        </div>
    </div>
    <div class="content">
        <asp:PlaceHolder ID="SettingAlertPanel" runat="server" Visible="false">
            <p>
                <asp:Localize ID="SettingAlert" runat="server" Text="You don't have an email template configured for abandoned basket alerts. Please choose a suitable template in the <b>Administration > Configure > Email > Settings</b> menu.  You must create or select a template in order to enable abandoned basket alert functionality."></asp:Localize>
            </p>
        </asp:PlaceHolder>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:PlaceHolder ID="SendAlertPanel" runat="server">
                    <asp:ValidationSummary ID="SendValidationSummary" runat="server" ValidationGroup="SendEmail" />
                    <cb:Notification ID="ErrorMessage" runat="server" SkinID="ErrorCondition" EnableViewState="false" Visible="false"></cb:Notification>
                    <table class="inputForm">
                        <tr id="trCustomerName" runat="server">
                            <th>
                                <asp:Localize ID="CustomerNameLabel" runat="server" Text="Customer:"></asp:Localize>
                            </th>
                            <td>
                                <asp:Literal ID="CustomerName" runat="server"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Localize ID="BasketContentsLabel" runat="server" Text="Basket Content:"></asp:Localize>
                            </th>
                            <td>
                                <asp:Literal ID="BasketContents" runat="server"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Localize ID="LastActivityLabel" runat="server" Text="Last Activity:"></asp:Localize>
                            </th>
                            <td>
                                <asp:Literal ID="LastActivity" runat="server"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ToEmailLabel" runat="server" Text="To:" AssociatedControlID="ToEmail" ToolTip="Email address of the user."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="ToEmail" runat="server" MaxLength="200" Width="250px"></asp:TextBox>
                                <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="ToEmail" ValidationGroup="SendEmail" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>                                
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="SubjectLabel" runat="server" Text="Subject:" AssociatedControlID="Subject" ToolTip="Email message subject."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="Subject" runat="server" MaxLength="200" Width="250px"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="SubjectRequired" runat="server" ValidationGroup="SendEmail" Text="*" ErrorMessage="Subject is required" ControlToValidate="Subject"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <cb:HtmlEditor ID="HtmlMessageContents" runat="server" Width="690" Height="400" ViewStateMode="Enabled"></cb:HtmlEditor>
                                <asp:TextBox ID="TextMessageContents" runat="server" Width="690" Height="400" TextMode="MultiLine" ViewStateMode="Enabled" Visible="false"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="SendButton" runat="server" Text="Send Alert" ValidationGroup="SendEmail" OnClick="SendButton_Click" />
                                <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" SkinID="Button" NavigateUrl="DailyAbandonedBaskets.aspx" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="ConfirmPanel" runat="server" Visible="false">
                    <asp:Localize ID="ConfirmMessage" runat="server" Text="The alert was sent to {0} successfully."></asp:Localize>
                    <asp:HyperLink ID="FinishButton" runat="server" Text="Finish" SkinID="Button" NavigateUrl="DailyAbandonedBaskets.aspx"></asp:HyperLink>
                </asp:PlaceHolder>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>