<%@ Page Language="C#" MasterPageFile="../../Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin._Store.EmailTemplates.EditTemplate" Title="Edit Email Template" CodeFile="EditTemplate.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
        <ajaxToolkit:TabContainer ID="TabContainer1" runat="server" 
                    Width="100%"
                    ActiveTabIndex="0"        
                    OnDemand="true"        
                    AutoPostBack="false"
                    TabStripPlacement="Top"
                    ScrollBars="None">
                <ajaxToolkit:TabPanel ID="MessageContentTab" runat="server" 
                    HeaderText="Message Content"
                    Enabled="true"
                    ScrollBars="Auto"        
                    OnDemandMode="None">
                    <ContentTemplate>
                        <div class="pageHeader">
    	                    <div class="caption">
    		                    <h1><asp:Localize ID="Caption" runat="server" Text="Edit Email Template '{0}'" EnableViewState="false"></asp:Localize></h1>
    	                    </div>
                        </div>
                        <div class="content">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                            <cb:Notification ID="SavedMessage" runat="server" Text="Email template updated at {0:t}" SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
                            <table class="inputForm" cellpadding="3" width="100%">
                                <tr>
                                    <th width="130px">
                                        <cb:ToolTipLabel ID="NameLabel" runat="Server" Text="Template Name:" AssociatedControlID="Name" ToolTip="Enter the name of the email template. This is not shown to customers and is for your reference only."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Name" runat="Server" MaxLength="100" Width="250px"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="NameValidator" runat="server" Display="Static" 
                                            ErrorMessage="Template name is required." ControlToValidate="Name" Text="*" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="ToAddressLabel" runat="Server" Text="To:" AssociatedControlID="ToAddress" ToolTip="Enter the recipient(s) for the email message. You can enter multiple addresses separated by a comma."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="ToAddress" runat="Server" MaxLength="250" Width="250px"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="ToAddressValidator" runat="server" ErrorMessage="To address is required." ControlToValidate="ToAddress" Text="*"></asp:RequiredFieldValidator>
                                        <asp:Label ID="ToAddressHintText" runat="server" Text="<i>Hint: Some event triggers support the email aliases <b>merchant</b>, <b>customer</b> and/or <b>vendor</b>.</i>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="FromAddressLabel" runat="Server" Text="From:" AssociatedControlID="FromAddress" ToolTip="Specify the email address the message will be sent from."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="FromAddress" runat="Server" MaxLength="250" Width="250px"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="FromAddress" ErrorMessage="From email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></asp:RequiredFieldValidator>
                                        <asp:Label ID="FromAddressHintText" runat="server" Text="<i>Hint:You can use <b>merchant</b> keyword alias for default store email address.</i>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="CCAddressLabel" runat="Server" Text="CC:" AssociatedControlID="CCAddress" ToolTip="Additional recipient(s) for the email message.  Addresses are visible to all recipients.  You cannot use email aliases 'customer' and/or 'vendor'."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="CCAddress" runat="Server" MaxLength="250" Width="250px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="BCCAddressLabel" runat="Server" Text="BCC:" AssociatedControlID="BCCAddress" ToolTip="Additional recipient(s) for the email message.  Addresses are not visible to any recipients.  You cannot use email aliases 'customer' and/or 'vendor'."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="BCCAddress" runat="Server" MaxLength="250" Width="250px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Label ID="BodyInstructionText" runat="Server" Text="Enter the subject and message body below. Both subject and body use the NVelocity template engine, providing scripting capability and dynamic variable support. For details and examples on how to leverage NVelocity scripting, view the <a href='help.aspx' target='_blank'>help</a> (new window)."></asp:Label><br />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="SubjectLabel" runat="Server" Text="Subject:" AssociatedControlID="Subject" ToolTip="Subject of the message" />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Subject" runat="Server" Columns="60" MaxLength="250"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="SubjectValidator" runat="server" ErrorMessage="Subject is required." ControlToValidate="Subject" Text="*"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="MailFormatLabel" runat="Server" Text="Message Format:" AssociatedControlID="MailFormat" ToolTip="Templates can be created for either HTML or text only email."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="MailFormat" runat="server">
                                            <asp:ListItem Text="HTML"></asp:ListItem>
                                            <asp:ListItem Text="Text"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Localize ID="MessageHtmlHelpText" runat="Server" Text="The built-in HTML editor is best suited for static email content.  If you need to use dynamic variables and NVelocity script, it is better to modify the content in the field below or you can edit the content file using an external editor. The html file associated with this email template's content is:<br /> {0}" />
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="MessageLabel" runat="Server" Text="Message:" AssociatedControlID="Message" ToolTip="Content of the message" /><br />
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
                                        <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                                        <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
							            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" OnClick="CancelButton_Click" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="EmailTriggerTab" runat="server" 
                    HeaderText="Event Triggers"
                    Enabled="true"
                    ScrollBars="Auto"        
                    OnDemandMode="None">
                    <ContentTemplate>
                        <div class="content">
                            <p><asp:Localize ID="TriggersInstructionText" runat="Server" Text="Optional: Place a check next to the events that cause this message to be sent automatically.  Depending on the events chosen, you may have access to email aliases to use with the to address and/or you may gain access to dynamic data through additional nVelocity variables.  Note that all email templates always have access to the $store variable and any template can be used to manually generate messages in the merchant admin."></asp:Localize></p>
                            <asp:GridView ID="TriggerGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="EventId" 
                                AllowPaging="false" AllowSorting="false" SkinID="PagedList" Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="Select" >
                                        <HeaderStyle horizontalalign="Center" />
                                        <ItemStyle horizontalalign="Center" Width="80px" />
                                        <ItemTemplate>
                                            <asp:CheckBox ID="Selected" runat="server"></asp:CheckBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="Event" DataField="Name">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="Email Aliases" DataField="EmailAliases">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField HeaderText="NVelocity Variables" DataField="NVelocityVariables">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <asp:Button ID="SaveButton2" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                            <asp:Button ID="SaveAndCloseButton2" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
                            <asp:Button ID="CancelButton2" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" OnClick="CancelButton_Click" />
                        </div>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
            </ajaxToolkit:TabContainer>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>