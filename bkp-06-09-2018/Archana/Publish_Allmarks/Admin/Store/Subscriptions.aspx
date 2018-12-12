<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Admin.master"  CodeFile="Subscriptions.aspx.cs" Inherits="AbleCommerce.Admin._Store.Subscriptions" Title="Subscriptions" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
<script type="text/javascript">
    function ValidateCancellationDays(source, args) {
        var cancelDays = parseInt($('#<%= SubscriptionsCancellationDays.ClientID %>').val());
        var nextOrderDays = parseInt($('#<%= CreateNextOrderDays.ClientID %>').val());
        if (cancelDays == 0 || cancelDays > nextOrderDays) {
            args.IsValid = true;
            return;
        }
        args.IsValid = false;
    }

    function ValidateChangeDays(source, args) {
        var nextOrderDays = parseInt($('#<%= CreateNextOrderDays.ClientID %>').val());
        var changeDays = parseInt($('#<%= SubscriptionChangesDays.ClientID %>').val());
        if (changeDays == 0 || changeDays > nextOrderDays) {
            args.IsValid = true;
            return;
        }
        args.IsValid = false;
    }

    </script>    
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Subscription Settings"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
        </div>
    </div>
    <asp:Panel ID="RONotEnabledPanel" runat="server">
        <div style="padding:25px; text-align:center">
            <p runat="server" id="LblDisabled" style="font-size:large;">Automatic Recurring Orders are Disabled</p>
            <p runat="server" id="LblEnabling" style="font-size:large;">Enabling Recurring Orders Feature</p>
            <p><asp:Button ID="EnableROFeature" runat="server" Text="Enable Automatic Recurring Orders" onclick="EnableROFeature_Click" /></p>
            <asp:Panel ID="EnableInstructions" runat="server" style="text-align:left; font-size:1.1em">
                <p>
                Before enabling the recurring orders feature please make sure that you understand the following 
                and ensure that you have taken necessary steps in order for this feature to work smoothly.
                </p>
                <p>
                <b>IMPORTANT:</b> When you enable recurring orders feature, you have to <b>make sure there is at least one
                payment method setup that is enabled for subscription payments</b>. Otherwise your customers 
                may not be able to complete checkout when they have recurring subscriptions in the basket.
                </p>
                <p>
                <b>To make best use of recurring orders feature please make sure that</b>
                <ul style="padding-left:10px;">
                <li style="list-style: square inside none;font-weight:bold;">You have credit-card payment methods setup and allowed for subscription payments</li>
                <li style="list-style: square inside none;font-weight:bold;">You have <b>Authorize.NET CIM</b> payment gateway setup and configured</li>
                <li style="list-style: square inside none;font-weight:bold;">Your credit-card payment methods are assigned to Authorize.NET CIM gateway</li>                
                </ul>
                </p>
                <p><b>Note:</b> PayPal, Amazon, and GiftCertificate payment methods will not be available for recurring subscription purchases.</p>
                <p>
                Please note that if some of your payment methods enabled for subscription payments are 
                not setup to be processed via Authorize.NET CIM gateway, you may still be able to make use of 
                of the recurring orders feature but in this case payments will not be automatically processed 
                for recurring orders. You will have to process the payments manually.
                </p>                
                <p>
                <b>I Understand and I have taken necessary steps : </b>
                <asp:Button ID="EnableROConfirm" runat="server" Text="Confirm Enable" onclick="EnableROConfirm_Click" />
                <br />
                <b>I am not ready yet : </b>
                <asp:Button ID="CancelROConfirm" runat="server" Text="Cancel" onclick="CancelROConfirm_Click" />
                </p>
            </asp:Panel>
        </div>
    </asp:Panel>
    <asp:Panel ID="ROEnabledPanel" runat="server">
    <asp:Panel ID="SettingsAjax" runat="server">        
            <div class="content aboveGrid">
                <asp:Button Id="SaveButton" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="SaveButton_Click" ValidationGroup="RecurringOrderSettings" />
                <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="RecurringOrderSettings" />
                <cb:Notification ID="SavedMessage" runat="server" Text="The Subscription settings have been saved." Visible="false" SkinID="GoodCondition"></cb:Notification>
            </div>
            <div class="section">
                <div class="header">
                    <h2 class="commonicon"><asp:Localize ID="SettingsCaption" runat="server" Text="Subscription Settings"></asp:Localize></h2>
                </div>
                <div class="content">
                    <table class="inputForm" id="SettingsPanel" runat="server">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="roEnabledLbl" runat="Server" Text="Automatic Recurring Orders:" ToolTip="Automatic creation and processing of new orders for subscriptions"></cb:ToolTipLabel>
                            </th>
                           <td>
                            <strong>ENABLED</strong><asp:Button ID="DisableROFeature" runat="server" Text="Disable" onclick="DisableROFeature_Click"  OnClientClick="return confirm('Are you sure you want to disable automatic recurring orders feature?')" />
                           </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="CreatNextOrderLabel" runat="Server" Text="Create Next Order:" ToolTip="You can configure the number of days to create the next order before payment will be due. If 0 is entered, then the order will be created on the same day the payment is due."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="CreateNextOrderDays" runat="server" Width="40px" MaxLength="4" Text="7"></asp:TextBox> days before next payment is due.
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AllowSubscriptionChangesLabel" runat="Server" Text="Allow Subscription Changes:" ToolTip="Number of days allowed to change subscription. This value needs to be greater than the time it will take the merchant to process the next order. Specify a zero value to disable the change subscription option."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="SubscriptionChangesDays" runat="server" Width="40px" MaxLength="4" Text="8"></asp:TextBox> days before next renewal.
                                <asp:CustomValidator runat="server" ID="SubscriptionChangeValidator" ClientValidationFunction="ValidateChangeDays" ErrorMessage="Allow subscription change days should be greater than create next order days." Text="*" ValidationGroup="RecurringOrderSettings"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <th class="subscriptionHeading">
                                <cb:ToolTipLabel ID="AllowSubscriptionsCancellationLabel" runat="Server" Text="Allow Cancellation of Subscriptions:" ToolTip="Number of days allowed to cancel subscription needs to be set to a value that is greater than the time it will take the merchant to process the next order. Specify a zero value to disable the cancellation."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="SubscriptionsCancellationDays" runat="server" Width="40px" MaxLength="4" Text="8"></asp:TextBox> days before next renewal.
                                <asp:CustomValidator runat="server" ID="SubscriptionsCancellationValidator" ClientValidationFunction="ValidateCancellationDays" ErrorMessage="Allow subscription cancellation days should be greater than create next order days." Text="*" ValidationGroup="RecurringOrderSettings"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="EnrollmentEmailLabel" runat="Server" Text="Select Enrollment Email:" ToolTip="Email will be sent only once, but for each subscription that is activated."></cb:ToolTipLabel>
                            </th>
                            <td>                                    
                                <asp:DropDownList ID="EnrollmentEmail" runat="server" >
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="PaymentReminderDaysLabel" runat="Server" Text="Send Payment Reminder:" ToolTip="Email will be sent when the next payment is coming due. You can configure the number of days prior to the payment coming due. If 0 is entered, then no payment reminder email will be sent."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="PaymentReminderDays" runat="server" Width="40px" MaxLength="4" Text="7"></asp:TextBox> days before next payment is due.
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="PaymentRemindersEmailLabel" runat="Server" Text="Select Payment Reminder Email:" ToolTip="Select the payment reminder email template, email will be sent when the next order is created, or when the next payment is coming due."></cb:ToolTipLabel>
                            </th>
                            <td>                                    
                                <asp:DropDownList ID="PaymentRemindersEmail" runat="server" >
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                             <th>
                                 <cb:ToolTipLabel ID="SubscriptionChangedEmailLabel" runat="Server" Text="Select Subscription Updated Email:" ToolTip="Select the subscription updated email template, sent when a scubscription is changed/updated either by admin or customer, every time when a subscription is updated."></cb:ToolTipLabel>
                             </th>
                             <td>                                    
                                <asp:DropDownList ID="SubscriptionChangedEmail" runat="server" >
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                         </tr>
                        <%--<tr>
                            <th>
                                <cb:ToolTipLabel ID="PaymnetFailureEmailLabel" runat="Server" Text="Select Payment Failure Email:" ToolTip="Select the payment failure email template, sent if the payment for the new order fails.  This could happen if the credit card expires, or is no longer valid."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:DropDownList ID="PaymnetFailureEmail" runat="server" >
                                    <asp:ListItem Text="Subscription Payment Failed"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>--%>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ExpirationReminderEmailLabel" runat="Server" Text="Send Expiration Reminder Email:" ToolTip="Set the number of days before expiration when subscription expiration email notices are sent."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="ExpirationReminderEmailIntervalDays" runat="server" Width="80px" MaxLength="80" Text="30,14,7,1"></asp:TextBox> days before expiration.
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="SubscriptionExpirationEmailLabel" runat="Server" Text="Select Expiration Reminder Email:" ToolTip="Select subscription expiration notice email template, will be sent one or more times depending on the merchant settings for number of days before expiration."></cb:ToolTipLabel>
                            </th>
                            <td>                                    
                                <asp:DropDownList ID="SubscriptionExpirationEmailTemplate" runat="server" >
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="CancellationEmailLabel" runat="Server" Text="Select Cancellation Email:" ToolTip="Select the subscription cancellation email template, sent only once, but for each subscription that has been canceled."></cb:ToolTipLabel>
                            </th>
                            <td>                                    
                                <asp:DropDownList ID="CancellationEmail" runat="server" >
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="SubscriptionExpirationTemplateLabel" runat="Server" Text="Select Subscription Expired Email:" ToolTip="Select the subscription expired email template, sent only once, but for each subscription that has been expired."></cb:ToolTipLabel>
                            </th>
                            <td>                                    
                                <asp:DropDownList ID="ExpiredEmail" runat="server" >
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr id="trIgnoreGatewayForPartialRecurSupport" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="IgnoreGatewayForPartialRecurSupportLabel" runat="Server" Text="Ignore gateway recurring payments if recurring feature is partially supported:" ToolTip="Ignore gateway recurring payments if recurring feature is partially supported."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:CheckBox ID="IgnoreGatewayForPartialRecurSupport" runat="server" AutoPostBack="true" OnCheckedChanged="IgnoreGatewayForPartialRecurSupport_CheckedChanged" />
                            </td>
                        </tr>
                        <tr id="trCreateOrdersForDetachedPayments" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="CreateOrdersForDetachedPaymentsLabel" runat="Server" Text="Create recurring orders for recurring payments created via partially supporting gateway:" ToolTip="Create recurring orders for recurring payments created via partially supporting gateway."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:CheckBox ID="CreateOrdersForDetachedPayments" runat="server" />
                            </td>
                        </tr>
                        <tr id="trRecurringPaymentsWithoutCVVAllowed" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="RecurringPaymentsWithoutCVVAllowedLabel" runat="Server" Text="For self managed subscriptions recurring payments can be performed without CVV:" ToolTip="For self managed subscriptions recurring payments can be performed without CVV."></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:CheckBox ID="RecurringPaymentsWithoutCVVAllowed" runat="server" />
                            </td>
                        </tr>
                    </table>                                                    
                </div>
            </div>        
    </asp:Panel>
    </asp:Panel> 
</asp:Content>