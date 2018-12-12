<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin._Store.EmailTemplates.Settings" Title="Configure Email Settings" CodeFile="Settings.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Email Settings"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/email" />
        </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="grid_6 alpha">
                <div class="leftColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="GeneralCaption" runat="server" Text="General"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <cb:Notification ID="GeneralSavedMessage" runat="server" Text="General email settings saved at {0:t}." Visible="false" SkinID="GoodCondition" EnableViewState="false"></cb:Notification>
                            <asp:ValidationSummary ID="GeneralValidationSummary" runat="server" ValidationGroup="General" />
                            <table cellspacing="0" class="inputForm">
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="DefaultAddressLabel" runat="server" Text="Default Email Address:" ToolTip="Email address used as default from address in email templates and default to address for incoming emails templates like 'Note Added to Customer'. In email templates this address can be accessed using '$merchant' variable. This is the address that will appear in the from field by default when you create new email message templates.  You can always alter the from address on a per-message basis." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="DefaultAddress" runat="server" Width="200px" MaxLength="200" ValidationGroup="General"></asp:TextBox>                                            
                                        <cb:EmailAddressValidator ID="DefaultFromEmailAddressValidator" runat="server" ControlToValidate="DefaultAddress" ValidationGroup="General" Required="true" ErrorMessage="Default 'from' email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator><br />
                                    </td>
                                </tr>
                                <tr class="sectionHeader">
                                    <th colspan="2">
                                        <asp:Localize ID="MailingListCaption" runat="server" Text="Mailing Lists"></asp:Localize>
                                    </th>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="SubscriptionAddressLabel" runat="server" Text="Service 'From' Address:" ToolTip="If you configure mailing lists, this is the email address used for opt-in confirmation and/or verification service notifications.  It will also be the from address for some generated system messages.  It is recommended this be set to an unattended email address like noreply@yourdomain.xyz." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SubscriptionAddress" runat="server" Width="200px" MaxLength="200" ValidationGroup="General"></asp:TextBox>
                                        <cb:EmailAddressValidator ID="SubscriptionEmailAddressValidator" runat="server" ControlToValidate="SubscriptionAddress" ValidationGroup="General" Required="true" ErrorMessage="The service 'from' email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>                                            
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="SubscriptionRequestExpirationDaysLabel" runat="server" Text="List Request Expiration:" ToolTip="If you configure an opt-in mailing list with verification, this is the number of days a customer has to verify the request before it is considered expired and removed from the database." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SubscriptionRequestExpirationDays" runat="server" width="30px" MaxLength="3" ValidationGroup="General"></asp:TextBox>&nbsp;
                                        <asp:Localize ID="DaysLabel" runat="server" Text="days"></asp:Localize><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="SubscriptionRequestExpirationDaysRequired" runat="server" ControlToValidate="SubscriptionRequestExpirationDays" ValidationGroup="General"
                                            ErrorMessage="You must enter the number of days before a list request is expired." Text="*"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="RequestExpirationRangeValidator" runat="server" ControlToValidate="SubscriptionRequestExpirationDays" ValidationGroup="General"
                                            ErrorMessage="The list request expiration must be in the range of 1 to 30." Text="*"
                                            Type="Integer" MinimumValue="1" MaximumValue="30"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="DefaultEmailListLabel" runat="server" Text="Default Email List:" ToolTip="This is the default email list for your store - if you allow anonymous users to sign up for your mailing list this is the one that will be used." />
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="DefaultEmailList" runat="server" DataTextField="Name" DataValueField="EmailListId" AppendDataBoundItems="true" EnableViewState="false">
    	                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr class="sectionHeader">
                                    <th colspan="2">
                                        <asp:Localize ID="ProductTellAFriendCaption" runat="server" Text="Send Product to Friend"></asp:Localize>
                                    </th>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="EmailTemplatesListLabel" runat="server" Text="Email Template:" AssociatedControlID="EmailTemplatesList" ToolTip="When a customer uses the 'Send to Friend' feature on the product detail page, select the template that will be used to populate the message." EnableViewState="false" />
                                    </th>
                                    <td>
    	                                <asp:DropDownList ID="EmailTemplatesList" runat="server" DataTextField="Name" DataValueField="EmailTemplateId" AppendDataBoundItems="true" EnableViewState="false" Width="200px">
    	                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
    	                                </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:CheckBox ID="TellAFriendCaptcha" runat="server" />
                                        <cb:ToolTipLabel ID="TellAFriendCaptchaLabel" runat="server" Text="Use CAPTCHA:" ToolTip="If checked, an image CAPTCHA must be solved to use the product 'Send to Friend' feature."></cb:ToolTipLabel>
                                    </td>
                                </tr>
                                <tr class="sectionHeader">
                                    <th colspan="2">
                                        <asp:Localize ID="AbandonedBasketAlertCaption" runat="server" Text="Abandoned Basket Alerts"></asp:Localize>
                                    </th>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="AbandonedBasketAlertLabel" runat="server" Text="Email Template:" AssociatedControlID="EmailTemplatesList" ToolTip="When you will send an Email alert for an abandoned basket, select the template that will be used to populate that message." EnableViewState="false" />
                                    </th>
                                    <td>
    	                                <asp:DropDownList ID="AbandonedBasketEmailTemplateList" runat="server" DataTextField="Name" DataValueField="EmailTemplateId" AppendDataBoundItems="true" EnableViewState="false" Width="200px">
    	                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
    	                                </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr class="sectionHeader">
                                    <th colspan="2">
                                        <asp:Localize ID="ContactUsConfirmationCaption" runat="server" Text="Contact Us Confirmation Email"></asp:Localize>
                                    </th>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="ContactUsEmailTemplatesListLabel" runat="server" Text="Email Template:" AssociatedControlID="EmailTemplatesList" ToolTip="When a customer uses the 'Contact Us Email' feature on the Contact Us page, select the template that will be sent back to customer as confirmation message." EnableViewState="false" />
                                    </th>
                                    <td>
    	                                <asp:DropDownList ID="ContactUsEmailTemplatesList" runat="server" DataTextField="Name" DataValueField="EmailTemplateId" AppendDataBoundItems="true" EnableViewState="false" Width="200px">
    	                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
    	                                </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Button ID="SaveGeneralButton" runat="server" OnClick="SaveGeneralButton_Click" Text="Save Settings" ValidationGroup="General" CausesValidation="true" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="SMTPserver"><asp:Localize ID="ServerCaption" runat="server" Text="Email Server Configuration"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Localize ID="EmailServerHelpText" runat="server" Text="To enable the email system, enter applicable SMTP server settings below.  You may need to aquire this information from your system administrator."></asp:Localize></p>
                            <cb:Notification ID="SmtpSavedMessage" runat="server" Text="SMTP config saved at {0:t}." Visible="false" SkinID="GoodCondition" EnableViewState="false"></cb:Notification>
                            <asp:ValidationSummary ID="SMTPValidationSummary" runat="server" ValidationGroup="SMTP" />
                            <asp:Label ID="WarningLabel" runat="server" SkinID="warnCondition" Text="Warning: Your email server settings have been removed. You will not be able to send email notifications." EnableViewState="false" Visible="false"></asp:Label>
                            <table cellspacing="0" class="inputForm">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="SmtpServerLabel" runat="server" Text="SMTP Server:" ToolTip="This is the IP address or dns name of your SMTP host, for example mail.yourdomain.xyz." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SmtpServer" runat="server" Width="200px"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="SmtpServerRequired" runat="server" ControlToValidate="SmtpServer" ValidationGroup="SMTP"
                                            ErrorMessage="You must provide the DNS name or IP address of the SMTP server." Text="*"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="SmtpPortLabel" runat="server" Text="SMTP Port:" ToolTip="This is the port that will be used to communicate with the server.  This will almost always port 25." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SmtpPort" runat="server" Text="25" Columns="3" MaxLength="5"></asp:TextBox><span class="requiredField">*</span>&nbsp;&nbsp;
                                            <asp:RequiredFieldValidator ID="SmtpPortRequired" runat="server" ControlToValidate="SmtpPort" ValidationGroup="SMTP"
                                                ErrorMessage="The SMTP port is required.  If you aren't sure of the value, use 25." Text="*"></asp:RequiredFieldValidator>
                                            <asp:RangeValidator ID="SmtpPortRangeValidator" runat="server" ControlToValidate="SmtpPort" ValidationGroup="SMTP"
                                                ErrorMessage="The SMTP port must be in the range of 1 to 65535.  The value 25 is the most common." Text="*"
                                                Type="Integer" MinimumValue="1" MaximumValue="65535"></asp:RangeValidator>
                                        <asp:CheckBox ID="SmtpEnableSSL" runat="server" />
                                        <cb:ToolTipLabel ID="SSLEnabledLabel" runat="server" Text="Enable SSL:" ToolTip="Check here if your server uses Secure SMTP.  This is not the same as having an SSL certificate on your website.  Only Secure SMTP over Transport Layer Security (TLS) is supported; SMTP/SSL (usually requiring port 465) is not." />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="SmtpUserNameLabel" runat="server" Text="SMTP Username:" ToolTip="If your server requires authentication, provide the username here." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SmtpUserName" runat="server" Width="120px" MaxLength="50" autocomplete="off"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="SmtpPasswordLabel" runat="server" Text="SMTP Password:" ToolTip="If your server requires authentication, provide the password here." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SmtpPassword" runat="server" TextMode="Password" Width="120px" MaxLength="50" autocomplete="off"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:CheckBox ID="RequiresAuth" runat="server"></asp:CheckBox>&nbsp;
                                        <cb:ToolTipLabel ID="RequiresAuthLabel" runat="server" Text="Use Authentication:" ToolTip="Check here if your server requires authentication." />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Button ID="SaveSmtpButton" runat="server" Text="Save Config" OnClick="SaveSmtpButton_Click" ValidationGroup="SMTP" CausesValidation="true" />
                                        <asp:Button ID="RemoveButton" runat="server" Text="Remove Config" OnClick="RemoveButton_Click" CausesValidation="false" OnClientClick="return confirm('If your email server settings are removed, no email notifications will be sent. Are you sure to remove email settings?')"/>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <asp:PlaceHolder ID="TestPanel" runat="server">
                        <div class="section">
                            <div class="header">
                                <h2 class="SMTPserver"><asp:Localize ID="TestSmtpCaption" runat="server" Text="Test Message"></asp:Localize></h2>
                            </div>
                            <div class="content">
                                <asp:ValidationSummary ID="TestSMTPValidationSummary" runat="server" ValidationGroup="TestSMTP" />
                                <asp:PlaceHolder ID="TestResultPanel" runat="server"></asp:PlaceHolder>
                                <div id="TestInputPanel">
                                    <p><asp:Localize ID="TestSmtpIntroText" runat="server" Text="You can generate a test message to check your server configuration.  Provide the address where the message should be sent and click Send."></asp:Localize></p>
                                    <table class="inputForm">
                                        <tr>
                                            <th>
                                                <asp:Label ID="TestSendToLabel" runat="server" Text="Send To:" AssociatedControlID="TestSendTo"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:TextBox ID="TestSendTo" runat="server" Width="200px" MaxLength="200" ValidationGroup="SMTP"></asp:TextBox>
                                                <cb:EmailAddressValidator ID="TestMessageToValidatior" runat="server" ControlToValidate="TestSendTo" ValidationGroup="TestSMTP" Required="true" ErrorMessage="Send to email address should be in the format of name@domain.tld." Text="*" EnableViewState="False" Display="Dynamic"></cb:EmailAddressValidator>
                                                <asp:Button ID="SendTestButton" runat="server" Text="Send" OnClick="SendTestButton_Click" ValidationGroup="TestSMTP" OnClientClick="if (Page_ClientValidate('TestSMTP')) {$('#TestProgressPanel').show();$('#TestInputPanel').hide();}" />&nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="TestProgressPanel" style="display:none">
                                    <p>Attempting to send test message...</p>
                                    <asp:Image ID="TestProgressImage" runat="server" SkinID="Progress" />
                                </div>
                            </div>
                        </div>
                    </asp:PlaceHolder>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>