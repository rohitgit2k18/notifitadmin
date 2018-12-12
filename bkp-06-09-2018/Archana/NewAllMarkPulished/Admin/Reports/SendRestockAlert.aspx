<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Reports.SendRestockAlert" Title="Send Restock Notification" CodeFile="SendRestockAlert.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<asp:UpdatePanel ID="MailAjax" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:PlaceHolder ID="ComposePanel" runat="server">                
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="ComposeCaption" runat="server" Text="Compose a Message"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <p><asp:Localize ID="InstructionText" runat="server" Text="Compose your message below.  You can choose to send HTML mail or text only mail, but not both!" EnableViewState="false"></asp:Localize></p>
                <asp:Label ID="EmailTemplateErrorLabel" runat="server" SkinID="errorCondition" Visible="false" EnableViewState="false" Text="<br/><br/>Some error has occurred while parsing email contents using nVelocity. Please fix the email '{0}' before trying to send email. Error details:<br/> {1}"></asp:Label>
                <asp:ValidationSummary ID="SendMailValidation" runat="server" />                    
                <table cellspacing="0" class="inputForm" width="100%">                    
                    <tr>
                        <th style="width:90px" valign="top">
                            <asp:Localize ID="ToAddressLabel" runat="Server" Text="Send To:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:Literal ID="ToAddress" runat="Server" EnableViewState="false"></asp:Literal>
                        </td>
                    </tr>
                    <tr id="trRemoveNotificationSubscriptions" runat="server">
                        <th valign="top">
                            <asp:Localize ID="RemoveNotificationSubscriptionsLabel" runat="Server" Text="Unsubscribe:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:CheckBox ID="RemoveNotificationSubscriptions" runat="Server" Text=" Remove all users from the notification list"></asp:CheckBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Localize ID="CCAddressLabel" runat="Server" Text="Send CC To:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="CCAddress" runat="Server" MaxLength="250" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Localize ID="BCCAddressLabel" runat="Server" Text="Send BCC To:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="BCCAddress" runat="Server" MaxLength="250" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th style="width:90px">
                            <asp:Localize ID="FromAddressLabel" runat="Server" Text="Send From:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="FromAddress" runat="Server" Width="400px" MaxLength="200"></asp:TextBox>
                            <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="FromAddress" Required="true" ErrorMessage="From email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>                                
                        </td>
                    </tr>
                    <tr>
                        <th style="width:90px">
                            <asp:Localize ID="EmailTemplateLabel" runat="Server" Text="Template:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:DropDownList ID="EmailTemplates" runat="server" DataTextField="Name" DataValueField="EmailTemplateId" AppendDataBoundItems="true" AutoPostBack="true" CausesValidation="false" OnSelectedIndexChanged="EmailTemplates_SelectedIndexChanged">
                                <asp:ListItem Text="Blank Message" Selected="true"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th style="width:90px">
                            <asp:Localize ID="SubjectLabel" runat="Server" Text="Subject:" EnableViewState="false"></asp:Localize>
                        </th>
                        <td>
                            <asp:TextBox ID="Subject" runat="Server" Width="400px" MaxLength="200"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th style="width:90px">
                            <asp:Localize ID="MailFormatLabel" runat="Server" Text="Format:"></asp:Localize>
                        </th>
                        <td>
                            <asp:DropDownList ID="MailFormat" runat="server">
                                <asp:ListItem Text="HTML"></asp:ListItem>
                                <asp:ListItem Text="Text"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th style="width:90px" valign="top">
                            <asp:Localize ID="MessageLabel" runat="Server" Text="Message:" /><br />
                            <asp:ImageButton ID="MessageHtml" runat="server" SkinID="HtmlIcon" />
                        </th>
                        <td>
                            <asp:TextBox ID="Message" runat="Server" TextMode="multiLine" Rows="15" Width="95%"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="MessageValidator" runat="server" ErrorMessage="Message content is required." ControlToValidate="Message" Text="*" Display="Static"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:LinkButton ID="PreviewButton" runat="server" Text="Preview &amp; Send" OnClick="PreviewButton_Click" SkinID="Button" />&nbsp;
                            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" OnClick="CancelButton_Click" />&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="PreviewPanel" runat="server" Visible="false">
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="PreviewCaption" runat="server" Text="Preview Message"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <p><asp:Localize ID="PreviewHelpText" runat="server" Text="Here is a sample of how your message will look.  If it is correct, click the send button to send to {0} recipient(s)." EnableViewState="false"></asp:Localize></p>
                <div style="height:300px;width:98%;overflow:scroll;border:inset 2px black;padding:2px;word-wrap:break-word;margin:4px 0px 4px 0px;">
                    <asp:Literal ID="PreviewMessage" runat="server"></asp:Literal>
                </div>
                <asp:HiddenField ID="RemoveNotificationSubscriptionsFlag" runat="server" />
                <asp:Button ID="SendButton" runat="server" Text="Send Message" OnClick="SendButton_Click" /> 
                <asp:Button ID="BackButton" runat="server" Text="Edit Message" CausesValidation="false" OnClick="BackButton_Click" />&nbsp; 
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="ConfirmationPanel" runat="server" Visible="false">
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="ConfirmCaption" runat="server" Text="Message Sent"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <asp:Label ID="ConfirmationMessage" runat="server" Text="Success!  Your message is being sent to {0} recipient(s)." SkinID="GoodCondition" EnableViewState="false"></asp:Label>
                <br /><br />
                <asp:HyperLink ID="OKButton" runat="server" Text="Finish" SkinID="Button" />
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="SmtpErrorPanel" runat="server" Visible="false" EnableViewState="false">
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="SmtpErrorCaption" runat="server" Text="Configure Email"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <p><asp:Localize ID="SmtpErrorMessage" runat="server" Text="You have not completed the setup of your email server, so messages cannot be sent." EnableViewState="false" /></p>
                <asp:HyperLink ID="SmtpConfigLink" runat="server" Text="Configure Email" NavigateUrl="~/Admin/Store/EmailTemplates/Settings.aspx" SkinID="Button"></asp:HyperLink>&nbsp;
                <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" SkinID="CancelButton"></asp:HyperLink>
            </div>
        </asp:PlaceHolder>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>