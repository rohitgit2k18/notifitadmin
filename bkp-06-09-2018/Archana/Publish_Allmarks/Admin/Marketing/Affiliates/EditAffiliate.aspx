<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Marketing.Affiliates.EditAffiliate" Title="Edit Affiliate" CodeFile="EditAffiliate.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Affiliate {0}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="To associate a link with this affiliate, add <b>{0}={1}</b> to the url. For example: {2}?{0}={1}"></asp:Localize></p>
        <asp:UpdatePanel ID="EditAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Saved at {0:t}" Visible="false"
                    SkinID="GoodCondition" EnableViewState="False"></cb:Notification>
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Affiliate Name:" ToolTip="The name of the affiliate as it will appear on reports and in the merchant admin." />
                        </th>
                        <td>
                            <asp:TextBox ID="Name" runat="server" Width="200px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="NameRequired" runat="server" ControlToValidate="Name"
                                Display="Static" ErrorMessage="Affiliate name is required." Text="*"></asp:RequiredFieldValidator>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="CommissionRateLabel" runat="server" Text="Commission Rate:"
                                ToolTip="The rate used for the calculation of commission - either a dollar amount or a percentage." />
                        </th>
                        <td>
                            <asp:TextBox ID="CommissionRate" runat="server" Width="60px" MaxLength="8"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="CommissionRateValidator" runat="server" Display="Static"
                                ErrorMessage="Commission rate is invalid." Text="*" ControlToValidate="CommissionRate"
                                ValidationExpression="\d{0,4}(\.\d{0,3})?"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email" 
                                Text="Email:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Email" runat="server" Width="200px" MaxLength="255"></asp:TextBox>
                            <cb:EmailAddressValidator ID="FromEmailAddressValidator" runat="server" 
                                ControlToValidate="Email" EnableViewState="False" 
                                ErrorMessage="Email address should be in the format of name@domain.tld." 
                                Required="true" Text="*">
                            &nbsp;&nbsp;
                            </cb:EmailAddressValidator>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="CommissionTypeLabel" runat="server" Text="Commission Type:"
                                ToolTip="Indicates the way the commission should be calculated.  Flat rate pays a fixed amount for each order.  Percentage of products subtotal calculates on the order total less taxes, shipping, etc.  Percentage of order total calculates on the order total including taxes and shipping." />
                        </th>
                        <td>
                            <asp:DropDownList ID="CommissionType" runat="server">
                                <asp:ListItem Text="Flat rate"></asp:ListItem>
                                <asp:ListItem Text="% of product subtotal"></asp:ListItem>
                                <asp:ListItem Text="% of order total"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="AffiliateGroupLabel" runat="server" Text="Owner Group:"
                                ToolTip="Any member of the selected group has the ability to view sales reports for this affiliate from their member account page." />
                        </th>
                        <td>
                            <asp:DropDownList ID="AffiliateGroup" runat="server" DataSourceID="GroupDs" DataValueField="GroupId" DataTextField="Name" AppendDataBoundItems="true">
                                <asp:ListItem Text="" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="GroupDs" runat="server" 
                                DataObjectTypeName="CommerceBuilder.Users.Group" 
                                OldValuesParameterFormatString="original_{0}" SelectMethod="LoadAll" 
                                SortParameterName="sortExpression" 
                                TypeName="CommerceBuilder.Users.GroupDataSource"></asp:ObjectDataSource>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="PersistenceLabel" runat="server" Text="Persistence:"
                                ToolTip="Indicate how long orders will count for commissions after an affiliate refers a customer." />
                        </th>
                        <td>
                            <asp:DropDownList ID="ReferralPeriod" runat="server" 
                                onselectedindexchanged="ReferralPeriod_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Text="Persistent" Value="3"></asp:ListItem>
                                <asp:ListItem Text="First Order" Value="1"></asp:ListItem>
                                <asp:ListItem Text="First X Days" Value="0"></asp:ListItem>
                                <asp:ListItem Text="First Order Within X Days" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="WebsiteUrlLabel" runat="server" Text="Website Url:" AssociatedControlID="WebsiteUrl"
                                ToolTip="Enter the Affiliate's website URL.  This information is for your reference only." />
                        </th>
                        <td>
                            <asp:TextBox ID="WebsiteUrl" runat="server"  Width="200px" MaxLength="255"></asp:TextBox>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="TaxIdLabel" runat="server" Text="Tax ID:" AssociatedControlID="TaxId" ToolTip="Enter the 9 digit tax Id." />
                        </th>
                        <td>
                            <asp:TextBox ID="TaxId" runat="server" MaxLength="20" Width="100"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="TaxIDRequired" runat="server" Text="*"
                                ErrorMessage="Tax Id is required." ControlToValidate="TaxId"
                                EnableViewState="False" SetFocusOnError="false" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="TaxIdNumberValidator" runat="server" 
                                ErrorMessage="Tax Id must be a 9 digit number (without hyphen)." 
                                ControlToValidate="TaxId" Display="Dynamic" CssClass="requiredField" Text="*" 
                                ValidationExpression="^[0-9]{9}$"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ReferralDaysLabel" runat="server" Text="Referral Period:" 
                                ToolTip="Time length of time (in days) that the affiliate will get credit for a sale made by a referred customer." Visible="false" />
                        </th>
                        <td>
                            <asp:TextBox ID="ReferralDays" runat="server" MaxLength="4" Width="60px" Visible="false"></asp:TextBox>
                            <asp:Localize ID="ReferralDaysLabel2" runat="server" Text="days" Visible="false"></asp:Localize>
                            <asp:RequiredFieldValidator ID="ReferralPeriodRequiredValidator" runat="server" ControlToValidate="ReferralDays" Text="*" ErrorMessage="You must specify number of days for referral."></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="ReferralPeriodValidator" runat="server" Type="Integer" MinimumValue="1"  MaximumValue="9999" ControlToValidate="ReferralDays" ErrorMessage="Referral period must be a numeric value greater than 0." Text="*" ></asp:RangeValidator>
                        </td>
                    </tr>
                    <tr class="sectionHeader">
                        <th colspan="4">
                            <asp:Label ID="AddressCaption" runat="server" Text="Address Information"></asp:Label>
                        </th>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="FirstName" runat="server" Width="200px" MaxLength="30"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="LastName" runat="server" Width="200px" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="CompanyLabel" runat="server" Text="Company:" AssociatedControlID="Company"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Company" runat="server" Width="200px" MaxLength="50"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Label ID="PhoneNumberLabel" runat="server" Text="Phone:" AssociatedControlID="PhoneNumber"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="PhoneNumber" runat="server" Width="200px" MaxLength="50"></asp:TextBox><br />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" AssociatedControlID="Address1"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Address1" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" AssociatedControlID="Address2"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Address2" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="City" runat="server" Width="200px" MaxLength="50"></asp:TextBox>
                        </td>

                        <th>
                            <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="Province"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Province" runat="server" Width="200px" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" AssociatedControlID="PostalCode"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="PostalCode" runat="server" Width="200px" MaxLength="15"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Label ID="CountryCodeLabel" runat="server" Text="Country:" AssociatedControlID="CountryCode"></asp:Label>
                        </th>
                        <td>
                            <asp:DropDownList ID="CountryCode" runat="server" DataTextField="Name" DataValueField="CountryCode">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="FaxNumberLabel" runat="server" Text="Fax Number:" AssociatedControlID="FaxNumber"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="FaxNumber" runat="server" Width="200px" MaxLength="20"></asp:TextBox>
                        </td>
                        <th>
                            <asp:Label ID="MobileNumberLabel" runat="server" Text="Mobile Number:" AssociatedControlID="MobileNumber"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="MobileNumber" runat="server" Width="200px" MaxLength="20"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="3">                                    
                            <asp:Button ID="SaveButton" runat="server" SkinID="SaveButton" Text="Save" OnClick="SaveButton_Click" />
							<asp:Button ID="CancelButton" runat="server" SkinID="CancelButton" Text="Cancel" OnClick="CancelButton_Click" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="section">
        <div class="header">
            <h2><asp:Localize ID="OrdersCaption" runat="server" Text="Associated Orders"></asp:Localize></h2>
        </div>
        <div class="content">
            <asp:UpdatePanel ID="PagingAjax" runat="server" UpdateMode="conditional">
                <ContentTemplate>
                    <cb:SortedGridView ID="OrdersGrid" runat="server" DataSourceID="OrdersDs" AllowPaging="True"
                        AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="Id" PageSize="20"
                        SkinID="PagedList" DefaultSortExpression="OrderDate" DefaultSortDirection="Descending"
                        Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="Order #" SortExpression="Id">
                                <headerstyle horizontalalign="Center" />
                                <itemstyle horizontalalign="Center" />
                                <itemtemplate>
                                    <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' NavigateUrl='<%#String.Format("../../Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber")) %>' SkinId="Link"></asp:HyperLink>
                                </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                                <headerstyle horizontalalign="Center" />
                                <itemstyle horizontalalign="Center" />
                                <itemtemplate>
                                    <asp:Label ID="OrderDate" runat="server" Text='<%# Eval("OrderDate", "{0:d}") %>'></asp:Label>
                                </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Products Subtotal" SortExpression="ProductSubtotal">
                                <headerstyle horizontalalign="Center" />
                                <itemstyle horizontalalign="Center" />
                                <itemtemplate>
                                    <asp:Label ID="Subtotal" runat="server" Text='<%# ((decimal)Eval("ProductSubtotal")).LSCurrencyFormat("lc") %>'></asp:Label>
                                </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Order Total" SortExpression="TotalCharges">
                                <headerstyle horizontalalign="Center" />
                                <itemstyle horizontalalign="Center" />
                                <itemtemplate>
                                    <asp:Label ID="Total" runat="server" Text='<%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc") %>'></asp:Label>
                                </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Commission">
                                <ItemStyle HorizontalAlign="Center" Width="25%" />
                                <ItemTemplate>
                                    <asp:Label ID="Commission" runat="server" Text='<%# ((decimal)GetCommissionForOrder(Container.DataItem)).LSCurrencyFormat("lc") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="EmptyMessage" runat="server" Text="There are no orders associated with this affiliate."></asp:Label>
                        </EmptyDataTemplate>
                    </cb:SortedGridView>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <asp:ObjectDataSource ID="OrdersDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}"
        SelectCountMethod="CountForAffiliate" SelectMethod="LoadForAffiliate" SortParameterName="sortExpression"
        TypeName="CommerceBuilder.Orders.OrderDataSource">
        <SelectParameters>
            <asp:QueryStringParameter Name="affiliateId" QueryStringField="AffiliateId" Type="Object" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
