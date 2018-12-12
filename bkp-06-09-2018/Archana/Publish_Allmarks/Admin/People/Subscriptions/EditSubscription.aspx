<%@ Page Language="C#" MasterPageFile="../../Admin.master" Inherits="AbleCommerce.Admin.People.Subscriptions.EditSubscription"
    Title="Edit Subscription" CodeFile="EditSubscription.aspx.cs" %>

<%@ Register src="BillingAddress.ascx" tagname="BillingAddress" tagprefix="uc1" %>

<%@ Register src="ShippingAddress.ascx" tagname="ShippingAddress" tagprefix="uc2" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="Edit Subscription for {0}"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="PageAjax" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <cb:Notification ID="SavedMessage" runat="server" Text="Subscription saved at {0:t}"
                    SkinID="GoodCondition" Visible="false">
                </cb:Notification>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <ajaxToolkit:TabContainer ID="SubscriptionTabs" runat="server">
                    <ajaxToolkit:TabPanel ID="GeneralTab" runat="server">
                        <HeaderTemplate>General</HeaderTemplate>
                        <ContentTemplate>
                            <div class="content">
                                <table cellspacing="0" class="inputForm">
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="SubscriptionNameLabel" runat="server" Text="Subscription Name: "
                                                ToolTip="Name of subscription" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:TextBox ID="SubscriptionName" runat="server" />
                                        </td>
                                        <th>
                                            <cb:ToolTipLabel ID="UserNameLabel" runat="server" Text="User Name: " ToolTip="Name of the user who placed the order."
                                                EnableViewState="False" ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:HyperLink ID="UserName" runat="server" NavigateUrl="~/Admin/People/Users/EditUser.aspx?UserId={0}" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="SubscriptionQuantityLabel" runat="server" Text="Quantity: "
                                                ToolTip="Quantity of subscribed items" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="SubscriptionQuantity" runat="server" EnableViewState="false"></asp:Label>
                                        </td>
                                        <th>
                                            <cb:ToolTipLabel ID="OrderNumberLabel" runat="server" Text="Original Order #: " ToolTip="The original order number where this subscription was purchased/ordered."
                                                EnableViewState="False" ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:HyperLink ID="OrderNumber" runat="server" NavigateUrl="~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="SubscriptionTypeLabel" runat="server" Text="Subscription Type: "
                                                ToolTip="Type of the subscription." EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="SubscriptionType" runat="server" />
                                        </td>
                                        <th>
                                            <cb:ToolTipLabel ID="OrderDateLabel" runat="server" Text="Original Order Date: " ToolTip="Original order date"
                                                EnableViewState="False" ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="OrderDate" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="SubscriptionGroupLabel" runat="server" Text="Subscription Group: "
                                                ToolTip="Select or change subscripton group." EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:DropDownList ID="SubscriptionGroup" runat="server" AppendDataBoundItems="True"
                                                DataTextField="Name" DataValueField="GroupId">
                                            </asp:DropDownList>
                                        </td>
                                        <th>
                                            <cb:ToolTipLabel ID="LastOrderDateLabel" runat="server" Text="Last Order Date: "
                                                ToolTip="Last order create date" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Literal ID="LastOrderDate" runat="server" Text="{0:d} (<a href='../../Orders/ViewOrder.aspx?OrderNumber={1}'>{1}</a>)" EnableViewState="False"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="ActiveLabel" runat="server" Text="Active: " ToolTip="Indicates if the subscription is active nor not."
                                                EnableViewState="False" ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:CheckBox ID="Active" runat="server" />
                                        </td>
                                        <th>
                                            <cb:ToolTipLabel ID="NextPaymentDateLabel" runat="server" Text="Next Payment Date: "
                                                ToolTip="Calculated next payment date" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="NextOrderDate" runat="server" />
                                        </td>       
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="BasePriceLabel" runat="server" Text="Base Price: "
                                                ToolTip="Subscription base price" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="BasePrice" runat="server"></asp:Label>
                                        </td>
                                        <th>
                                            <cb:ToolTipLabel ID="ExpirationLabel" runat="server" Text="Expiration: " ToolTip="The expiration date for this subsription."
                                                EnableViewState="False" ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="Expiration" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="BaseTaxCodeLabel" runat="server" Text="Base Price TaxCode: "
                                                ToolTip="Subscription base tax code" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="BaseTaxCode" runat="server"></asp:Label>
                                        </td>
                                        <td></td>
                                        <td></td>

                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="RecurringChargeModeLabel" runat="server" Text="Recurring Charge Mode: "
                                                ToolTip="Recurring charge mode" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Localize ID="RecurringChargeMode" runat="server" EnableViewState="false"></asp:Localize>
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="RecurringChargeLabel" runat="server" Text="Recurring Charge: "
                                                ToolTip="Recurring charge amount" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="RecurringCharge" runat="server" Width="50px" />
                                        </td>
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <th>
                                           <cb:ToolTipLabel ID="RecurringChargeTaxCodeLabel" runat="server" Text="Recurring Charge TaxCode: "
                                            ToolTip="Recurring charge tax code" EnableViewState="False" ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="RecurringTaxCode" runat="server"></asp:Label>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <asp:PlaceHolder ID="trFrequency" runat="server">
                                    <tr>
                                        
                                        <th>
                                            <cb:ToolTipLabel ID="FrequencyLabel" runat="server" Text="Payment / Delivery Frequency: "
                                                ToolTip="Specify the payment and delivery frequency interval." 
                                                EnableViewState="False" ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Localize ID="EveryLabel" runat="server" Text="Every " 
                                                EnableViewState="False"></asp:Localize>
                                            <asp:DropDownList ID="Frequency" runat="server" />
                                            <asp:Localize ID="FixedFrequency" runat="server" Text="Every " 
                                                EnableViewState="False"></asp:Localize>
                                        </td>                                        
                                    </tr>
                                    </asp:PlaceHolder>
                                    <tr>
                                         <th>
                                            <cb:ToolTipLabel ID="NumberOfPaymentsLabel" runat="server" Text="Number Of Payments: "
                                                    ToolTip="Total Number of payments" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:TextBox ID="NumberOfPayments" runat="server" Width="50px" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="PaymentLabel" runat="server" Text="Payment Data : "
                                                ToolTip="Credit card used for subscription payment" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="PaymentInfo" runat="server"></asp:Label>
                                        </td>

                                        <td></td>
                                        <td></td>                                       
                                    </tr>
                                    <!--
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="BillingAddressLabel" runat="server" Text="Billing Address: "
                                                    ToolTip="User billing address" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Literal ID="BillingAddressLiteral" runat="server"></asp:Literal>
                                            <asp:HyperLink ID="BillingAddressLink" runat="server" Text="Edit" NavigateUrl="~/Admin/People/Users/EditUser.aspx?UserId={0}&SubscriptionId={1}&Tab=2" />
                                        </td>
                                        <th>
                                            <cb:ToolTipLabel ID="ShipAddressLabel" runat="server" Text="Shipping Address: " ToolTip="Order Shipping Address"
                                                EnableViewState="False" ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Literal ID="ShippingAddressLiteral" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                    -->
                                    <tr>
                                    <td colspan="4"><hr /></td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <cb:ToolTipLabel ID="lblProcessingStatus" runat="server" Text="Processing Status: "
                                                ToolTip="The payment processing status" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td>
                                            <asp:Label ID="ProcessingStatusLabel" runat="server"></asp:Label> 
                                            &nbsp; <asp:LinkButton runat="server" ID="ClearStatusBtn" OnClick="ClearStatusBtn_Click" Text="Clear Status" ></asp:LinkButton>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr id="trProcessingMessage" runat="server">
                                        <th runat="server">
                                            <cb:ToolTipLabel ID="lblProcessingMessage" runat="server" Text="Processing Message: "
                                                ToolTip="The payment processing status message" EnableViewState="False" 
                                                ToolTipClass="toolTip" />
                                        </th>
                                        <td colspan="3" runat="server">                            
                                            <asp:Label ID="ProcessingMessage" runat="server" Text="OK"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <div class="links">
                                                <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click">
                                                </asp:Button>
                                                <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton"
                                                    OnClick="SaveAndCloseButton_Click"></asp:Button>
                                                <asp:HyperLink ID="CancelButton" runat="server" SkinID="CancelButton" Text="Cancel"
                                                    NavigateUrl="Default.aspx" ViewStateMode="Enabled" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </ajaxToolkit:TabPanel>
                    <ajaxToolkit:TabPanel ID="ShippingTab" runat="server">
                        <HeaderTemplate>Addresses</HeaderTemplate>
                        <ContentTemplate>
                        <uc1:BillingAddress ID="BillingAddress1" runat="server" />
                        <uc2:ShippingAddress ID="ShippingAddress1" runat="server" />
                        </ContentTemplate>
                    </ajaxToolkit:TabPanel>
                    <ajaxToolkit:TabPanel ID="OrdersTab" runat="server">
                        <HeaderTemplate>Orders</HeaderTemplate>
                        <ContentTemplate>
                            <div class="section">
                                <div class="contents">
                                    <cb:SortedGridView ID="SubscriptionOrdersGrid" runat="server" AllowPaging="True" AutoGenerateColumns="False" DataSourceID="SubscriptionOrdersDS"
                                            SkinID="PagedList" AllowSorting="true" DefaultSortExpression="Id Desc">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("Order.OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("Order.OrderNumber"))%>'></asp:HyperLink>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Status" SortExpression="OrderStatusId">
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="OrderStatus" runat="server" Text='<%# GetOrderStatus(Eval("Order.OrderStatusId")) %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Due Date">
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <%#GetOrderDueDate(Container.DataItem)%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </cb:SortedGridView>
                                        <asp:ObjectDataSource ID="SubscriptionOrdersDS" runat="server"  OldValuesParameterFormatString="original_{0}" SelectMethod="LoadForSubscription" 
                                            SelectCountMethod="CountForSubscription" TypeName="CommerceBuilder.Orders.SubscriptionOrderDataSource" SortParameterName="sortExpression">
                                            <SelectParameters>
                                                <asp:QueryStringParameter DefaultValue="0" Name="subscriptionId" 
                                                    QueryStringField="SubscriptionId" Type="Int32" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                </div>
                            </div>
                        </ContentTemplate>
                    </ajaxToolkit:TabPanel>
                </ajaxToolkit:TabContainer>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
