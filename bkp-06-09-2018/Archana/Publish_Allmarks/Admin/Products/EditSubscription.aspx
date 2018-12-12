<%@ Page Language="C#" MasterPageFile="Product.master" Inherits="AbleCommerce.Admin.Products.EditSubscription" Title="Edit Subscription"  CodeFile="EditSubscription.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<asp:UpdatePanel ID="PageAjax" runat="server" UpdateMode="conditional">
    <ContentTemplate>
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Subscription Plan for {0}"></asp:Localize></h1>
            <div class="links">
                <cb:NavigationLink ID="SubscriptionsLink" runat="server" Text="Manage Subscriptions" SkinID="Button" NavigateUrl="#" EnableViewState="false"></cb:NavigationLink>
            </div>
        </div>
    </div>
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="A subscription will use the base price set for the product.  After a subscription product is paid, it will automatically activate.  If group membership and/or expiration are used, they will automatically deactivate accordingly.  Go to the Configure > Store > Subscriptions page to create and configure subscription orders automatically."></asp:Localize></p>
                <asp:Panel ID="NoSubscriptionPlanPanel" runat="server">
                    <p><asp:Localize ID="NoSubscriptionPlanDescription" runat="server" Text="This product does not have any associated subscription plan." EnableViewState="false"></asp:Localize></p>
                    <asp:Button ID="ShowAddForm" runat="server" text="Add Subscription Plan" SkinID="AddButton" OnClick="ShowAddForm_Click"  EnableViewState="false" />
                </asp:Panel>
                <asp:Panel ID="SubscriptionPlanForm" runat="server" Visible="false">
                    <cb:Notification ID="SavedMessage" runat="server" Text="Subscription plan saved at {0}." EnableViewState="false" Visible="false" SkinID="GoodCondition"></cb:Notification>
                    <cb:Notification ID="ErrorMessage" runat="server" Text="" EnableViewState="false" Visible="false" SkinID="ErrorCondition"></cb:Notification>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                    <div class="sectionHeader">
                        <h2>One Time Purchase</h2>
                    </div>
                    <table cellspacing="0" class="inputForm">
                        <tr>
                            <th style="width:30%">
                                <cb:ToolTipLabel ID="AllowOneTimePurchaseLabel" runat="server" Text="Allow One Time Purchase: "  ToolTip="If checked, the product can either be purchased as a regular product, or as a subscription plan. Only when checked, will the next line appear so that the One Time Charge and Tax Code setting can be used as the base subscription price (initial charge), allowing for a different based subscription price than the product price." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:CheckBox ID="AllowOneTimePurchase" runat="server" AutoPostBack="true" OnCheckedChanged="AllowOneTimePurchase_Changed"  /> (Check to make subscription plan optional)
                            </td>
                        </tr>
                        <tr id="trSalePitch" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="SalePitchLabel" runat="server" Text="Sales Pitch:" ToolTip="You can provide your sales pitch for subscription purchase." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="SalePitch" runat="server" Width="300" ></asp:TextBox> 
                            </td>
                        </tr>
                        <tr id="trOneTimePrice" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="OneTimePriceLabel" runat="server" Text="One Time Purchase Price:" ToolTip="Specify a price if you want to offer a different price from subscription product base price." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:DropDownList ID="OneTimePriceMode" runat="server">
                                    <asp:ListItem Value="1" Text="Modify" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Override"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:Literal ID="OneTimePriceLabel2" runat="server" Text=" Subscription Base Price ({0}) With " ></asp:Literal>
                                <asp:TextBox ID="OneTimePrice" runat="server" Width="60" ></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="trOneTimeTaxCode" runat="server" visible="false">
                            <th>
                                <cb:ToolTipLabel ID="OneTimePriceTaxCodeLabel" runat="server" Text="Tax Code:" SkinID="FieldHeader" ToolTip="The tax code applicable for one time charges. If no one time charge is specified product base price will be used along with the product tax code." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:DropDownList ID="OneTimePriceTaxCode" runat="server" DataTextField="Name" DataValueField="TaxCodeId" 
                                    AppendDataBoundItems="True" EnableViewState="false">
                                    <asp:ListItem Value="" Text=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    <div class="sectionHeader">
                        <h2>Subscription Purchase</h2>
                    </div>
                    <table cellspacing="0" cellpadding="0" class="inputForm">
                        <tr>
                            <th style="width:30%">
                                <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Subscription Name:" ToolTip="The name used for this subscription plan, as would show on your reports." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="Name" runat="server" MaxLength="100" EnableViewState="false" TabIndex="1" Width="200px"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="NameRequired" runat="server" Text="*" Display="Static" 
                                    ErrorMessage="You must enter a name for the subscription plan." ControlToValidate="Name" EnableViewState="false"></asp:RequiredFieldValidator><br />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="SubscriptionGroupLabel" runat="server" Text="Subscriber Group:" ToolTip="If desired, select the group that users will be added to while their subscription is in effect." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:UpdatePanel ID="SubscriptionGroupAjax" runat="server" UpdateMode="conditional" EnableViewState="false">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="SubscriptionGroup" runat="server" AppendDataBoundItems="true"
                                            DataTextField="Name" DataValueField="GroupId" EnableViewState="false" TabIndex="2">
                                        </asp:DropDownList>
                                        <asp:LinkButton ID="NewGroupButton" runat="server" OnClientClick="return addGroup()" SkinID="Link" Text="new" CausesValidation="false" EnableViewState="false" OnClick="NewGroupButton_Click" TabIndex="3"></asp:LinkButton>
                                        <asp:HiddenField ID="NewName" runat="server" EnableViewState="false" />
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <th valign="top">
                                <cb:ToolTipLabel ID="BillingOptionLabel" runat="server" Text="Billing Option:" ToolTip="Select the type of billing that will be used when this product is purchased." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td valign="top">
                                <asp:RadioButtonList ID="BillingOption" runat="server" EnableViewState="true" TabIndex="4" AutoPostBack="true" OnSelectedIndexChanged="BillingOption_SelectedIndexChanged">
                                    <asp:ListItem Text="One-time charge of {0}"></asp:ListItem>
                                    <asp:ListItem Text="Recurring charge of {0}"></asp:ListItem>
                                    <asp:ListItem Text="Initial charge of {0} with recurring charge"></asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                        </tr>
                        <tr id="trRecurringCharge" runat="server">
                            <th>
                                <cb:ToolTipLabel ID="RecurringChargeLabel" runat="server" Text="Recurring Charge: " ToolTip="The amount that is charged for all recurring payments following the initial payment." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:DropDownList ID="RecurringChargeMode" runat="server">
                                    <asp:ListItem Value="1" Text="Modify" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Override"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:Literal ID="RecurringChargeLabel2" runat="server" Text=" Subscription Base Price ({0}) With " ></asp:Literal>
                                <asp:TextBox ID="RecurringCharge" runat="server" MaxLength="8" EnableViewState="true" Width="60px" TabIndex="8"></asp:TextBox>
                                <cb:ToolTipLabel ID="RecurringTaxCodeLabel" runat="server" Text=" Tax Code:" SkinID="FieldHeader" ToolTip="The initial charge uses the tax code assigned to the product.  The amount specified for the recurring charge will use this tax code." EnableViewState="false"></cb:ToolTipLabel>
                                <asp:DropDownList ID="RecurringTaxCode" runat="server" DataTextField="Name" DataValueField="TaxCodeId" 
                                    AppendDataBoundItems="True" EnableViewState="false">
                                    <asp:ListItem Value="" Text=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr id="trFrequency" runat="server">
                            <th valign="top">
                                <cb:ToolTipLabel ID="FrequencyLabel" runat="server" Text="Payment Frequency:" ToolTip="Indicate how often the recurring charge should be processed." EnableViewState="true"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:RadioButton ID="FixedFrequencyCheck" runat="server" Text="Fixed Interval of Every " GroupName="FrequencyType" AutoPostBack="true" OnCheckedChanged="PaymentFrequencyType_Changed" />
                                <asp:TextBox ID="FixedPaymentFrequency" runat="server" MaxLength="3" EnableViewState="false" Width="40px" TabIndex="5"></asp:TextBox>
                                <asp:DropDownList ID="FixedPaymentFrequencyUnits" runat="server" EnableViewState="false" TabIndex="6">
                                    <asp:ListItem Text="day(s)"></asp:ListItem>
                                    <asp:ListItem Text="month(s)" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="FixedFrequencyRequiredField" runat="server" Text="*" Display="Dynamic" 
                                    ErrorMessage="You must specify payment frequency fixed interval" ControlToValidate="FixedPaymentFrequency" EnableViewState="false" Enabled="false"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="FixedPaymentFrequencyRange" runat="server" Text="*" Display="Static" 
                                    ErrorMessage="The interval value must be at least 1." ControlToValidate="FixedPaymentFrequency" 
                                    MinimumValue="1" MaximumValue="1000" Type="Integer" EnableViewState="false" Enabled="false"></asp:RangeValidator>
                                <br />
                                <asp:RadioButton ID="CustomFrequencyCheck" runat="server" GroupName="FrequencyType" AutoPostBack="true" OnCheckedChanged="PaymentFrequencyType_Changed" />
                                <cb:ToolTipLabel ID="CustomFrequencyLabel" runat="server" Text="Allow customer to choose a delivery schedule of" ToolTip="Provide comma separated intervals (e.g. 7,14,21)." EnableViewState="false"></cb:ToolTipLabel>
                                <asp:TextBox ID="CustomPaymentFrequency" runat="server" MaxLength="30" EnableViewState="false" Width="100px" TabIndex="8"></asp:TextBox>
                                <asp:DropDownList ID="CustomPaymentFrequencyUnit" runat="server" EnableViewState="false" TabIndex="6">
                                    <asp:ListItem Text="day(s)"></asp:ListItem>
                                    <asp:ListItem Text="month(s)" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="CustomFrequencyCheckRequiredField" runat="server" Text="*" Display="Dynamic" 
                                    ErrorMessage="You must specify payment frequency custom interval" ControlToValidate="CustomPaymentFrequency" EnableViewState="false" Enabled="false"></asp:RequiredFieldValidator>
                                <span>(e.g. 7,14,21 Days)</span>
                            </td>
                        </tr>
                        <!-- <tr id="trInitialChargeDisplay" runat="server" runat="server">
                            <th>
                                <cb:ToolTipLabel ID="InitialChargeDisplayLabel" runat="server" Text="Initial Charge:" ToolTip="The amount that is charged for the first payment of the subscription plan." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:Label ID="InitialChargeDisplay" runat="server"></asp:Label>
                            </td>
                        </tr> -->
                        <tr id="trNumberOfPayments" runat="server">
                            <th>
                                <cb:ToolTipLabel ID="NumberOfPaymentsLabel" runat="server" Text="Total Payments:" ToolTip="Indicate the total number of payments (including the initial payment) that are made over the life of the subscription." EnableViewState="false"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="NumberOfPayments" runat="server" MaxLength="3" EnableViewState="false" Width="40px" TabIndex="9"></asp:TextBox>
                                <asp:RangeValidator ID="NumberOfPaymentsRange" runat="server" Text="*" Display="Static" 
                                    ErrorMessage="The total number of payments must be at least 1." ControlToValidate="NumberOfPayments" 
                                    MinimumValue="1" MaximumValue="1000" Type="Integer" EnableViewState="false"></asp:RangeValidator>
                            </td>
                        </tr>
                        <tr id="trExpiration" runat="server">
                            <th>
                                <cb:ToolTipLabel ID="ExpirationLabel" runat="server" Text="Expiration:" ToolTip="Indicate how long after purchase this subscription will remain valid before it is expired.  If the subscription should not expire, leave the field blank." EnableViewState="true"></cb:ToolTipLabel>
                            </th>
                            <td>
                                <asp:TextBox ID="Expiration" runat="server" MaxLength="3" EnableViewState="false" Width="40px" TabIndex="5"></asp:TextBox>
                                <asp:DropDownList ID="ExpirationUnit" runat="server" EnableViewState="false" TabIndex="6">
                                    <asp:ListItem Text="day(s)"></asp:ListItem>
                                    <asp:ListItem Text="month(s)" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:PlaceHolder ID="AddSubscriptionPlanButtons" runat="server" Visible="false">                               
                                    <asp:Button ID="AddButton" runat="server" text="Add" SkinID="AddButton" OnClick="AddButton_Click" EnableViewState="false" TabIndex="11"/>
								    <asp:Button ID="CancelButton" runat="server" text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" EnableViewState="false" TabIndex="10" />
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="EditSubscriptionPlanButtons" runat="server" Visible="false">
                                    <asp:Button ID="UpdateButton" runat="server" text="Save" SkinID="SaveButton" OnClick="UpdateButton_Click" EnableViewState="false" TabIndex="11" />
                                    <asp:Button ID="DeleteButton" runat="server" text="Delete" SkinID="CancelButton" OnClick="DeleteButton_Click" CausesValidation="false" EnableViewState="false" TabIndex="10" OnClientClick="return confirm('Are you sure you want to delete this subscription plan?')" />
                                </asp:PlaceHolder>            
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
    </div>
    </ContentTemplate>
</asp:UpdatePanel>
    <script type="text/javascript">
        function addGroup() {
            var name = prompt("New group name?");
            if ((name == null) || (name.length == 0)) return false;
            var c = document.getElementById('<%= NewName.ClientID %>');
            if (c == null) return false;
            c.value = name;
            return true;
        }
    </script>
</asp:Content>