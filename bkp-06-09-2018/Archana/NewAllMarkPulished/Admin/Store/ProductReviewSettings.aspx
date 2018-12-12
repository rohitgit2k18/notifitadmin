<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.ProductReviewSettings"
    Title="Configure Product Reviews" EnableViewState="false" CodeFile="ProductReviewSettings.aspx.cs" %>

<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks"
    TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="Product Reviews"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
        </div>
    </div>
    <asp:UpdatePanel ID="PageAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="content aboveGrid">
                <asp:Button ID="SaveButon" runat="server" Text="Save Settings" OnClick="SaveButton_Click"
                    SkinID="Button" />
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Saved at {0:t}<br /><br />"
                    SkinID="GoodCondition" EnableViewState="False" Visible="false">
                </cb:Notification>
            </div>
            <div class="section">
                <div class="header">
                    <h2>
                        <asp:Localize ID="GeneralCaption" runat="server" Text="General"></asp:Localize></h2>
                </div>
                <div class="content">
                    <table class="inputForm">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="EnabledLabel" runat="server" Text="Enable Product Reviews:"
                                    AssociatedControlID="Enabled" ToolTip="Indicates whether the product review feature is enabled for the store.">
                                </cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:DropDownList ID="Enabled" runat="server">
                                    <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Registered Users Only"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="All Users"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ApprovalLabel" runat="server" Text="Require Approval for Reviews:"
                                    AssociatedControlID="Approval" ToolTip="Indicates whether product reviews made by a customer must be approved by the merchant before being published." />
                            </th>
                            <td>
                                <asp:DropDownList ID="Approval" runat="server">
                                    <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Anonymous Users Only"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="All Users"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ImageVerificationLabel" runat="server" Text="Use Image Verification"
                                    AssociatedControlID="ImageVerification" ToolTip="Indicates whether a verification image will be displayed for customers adding a review.  Using the verification image can help reduce review spamming." />
                            </th>
                            <td>
                                <asp:DropDownList ID="ImageVerification" runat="server">
                                    <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Anonymous Users Only"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="All Users"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="EmailVerificationLabel" runat="server" Text="Use Email Verification"
                                    AssociatedControlID="ImageVerification" ToolTip="Indicates whether an email will be sent to the customer with a link that must be clicked to publish the review.  Using email verification can help reduce review spamming." />
                            </th>
                            <td>
                                <asp:DropDownList ID="EmailVerification" runat="server">
                                    <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Anonymous Users Only"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="All Users"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="EmailTemplateLabel" runat="server" Text="Email Verification Message"
                                    AssociatedControlID="EmailTemplate" ToolTip="If you are using email verification, select the message that will be sent to the customer when a review is submitted.  If you do not wish to customize the message, choose 'Default Message' to use a simple default message." />
                            </th>
                            <td>
                                <asp:DropDownList ID="EmailTemplate" runat="server" DataTextField="Name" DataValueField="EmailTemplateId"
                                    AppendDataBoundItems="true">
                                    <asp:ListItem Value="" Text="Default Message"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th valign="top">
                                <cb:ToolTipLabel ID="TermsAndConditionsLabel" runat="server" Text="Review Terms and Conditions"
                                    AssociatedControlID="TermsAndConditions" ToolTip="Provide the terms and conditions or review posting policy that will be shown to customers posting a review." />
                                    <br />
                                    <asp:ImageButton ID="TermsAndConditionsHtml" runat="server" SkinID="HtmlIcon" />
                            </th>
                            <td>
                                <asp:TextBox ID="TermsAndConditions" runat="server" TextMode="MultiLine" Rows="6"
                                    Width="400"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="section">
                <div class="header">
                    <h2>
                        <asp:Localize ID="ReviewReminderCaption" runat="server" Text="Review Reminder Settings"></asp:Localize></h2>
                </div>
                <div class="content">
                    <table class="inputForm">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="EnableProductReviewRemindersLabel" runat="server" Text="Enable Review Reminders"
                                    AssociatedControlID="EnableProductReviewReminders" ToolTip="Enables or disables review reminder emails." />
                            </th>
                            <td>
                                <asp:CheckBox ID="EnableProductReviewReminders" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Label ID="RunDaysLabel" runat="server" Text="Run reminder service once every" SkinID="FieldHeader" />
                            </th>
                            <td>
                                <asp:TextBox ID="RunDays" runat="server" Width="50"></asp:TextBox>
                                &nbsp;<cb:ToolTipLabel ID="RunDaysToolTip" runat="server" Text="days" ToolTip="Number of days after which the review reminder service runs." AssociatedControlID="RunDays" SkinID="FieldHeader" />
                                <asp:RangeValidator ID="RangeValidator1" runat="server" Type="Integer" MinimumValue="0"
                                    MaximumValue="999" ControlToValidate="RunDays" ErrorMessage="Run days must be a numeric value between 0-999."
                                    Text="*"></asp:RangeValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Label ID="NotBeforeDaysLabel" runat="server" Text="Send the review email" SkinID="FieldHeader" />
                            </th>
                            <td>
                                <asp:TextBox ID="NotBeforeDays" runat="server" Width="50"></asp:TextBox>
                                &nbsp;<cb:ToolTipLabel ID="NotBeforeDaysTooltip" runat="server" Text="days after order fulfillment" ToolTip="Indicates number of days to wait before sending the review email is sent for the purchased product." AssociatedControlID="NotBeforeDays" SkinID="FieldHeader" />
                                <asp:RangeValidator ID="NotBeforeDaysValidator" runat="server" Type="Integer" MinimumValue="0"
                                    MaximumValue="999" ControlToValidate="NotBeforeDays" ErrorMessage="Days must be a numeric value between 0-999."
                                    Text="*"></asp:RangeValidator>
                            </td>
                        </tr>
                        </tr>
                        <tr>
                            <th>
                                <asp:Label ID="NotAfterDaysLabel" runat="server" Text="Do not process orders fulfilled more than" SkinID="FieldHeader" />
                            </th>
                            <td>
                                <asp:TextBox ID="NotAfterDays" runat="server" Width="50"></asp:TextBox>
                                &nbsp;<cb:ToolTipLabel ID="NotAfterDaysTooltip" runat="server" Text="days ago" ToolTip="Indicates number of days after which no attempt is made to send the review email for the purchased product." AssociatedControlID="NotAfterDays" SkinID="FieldHeader" />
                                <asp:RangeValidator ID="NotAfterDaysValidator" runat="server" Type="Integer" MinimumValue="0"
                                    MaximumValue="999" ControlToValidate="NotAfterDays" ErrorMessage="Days must be a numeric value between 0-999."
                                    Text="*"></asp:RangeValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ReviewReminderTemplateLabel" runat="server" Text="Email Message Template"
                                    AssociatedControlID="AllEmailTemplates" ToolTip="Select the email template used to send the review reminder email." />
                            </th>
                            <td>
                                <asp:DropDownList ID="AllEmailTemplates" runat="server" DataTextField="Name" DataValueField="EmailTemplateId"
                                    AppendDataBoundItems="true">
                                    <asp:ListItem Value="" Text=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
