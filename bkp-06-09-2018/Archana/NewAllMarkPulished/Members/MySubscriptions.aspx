<%@ Page Title="My Subscriptions" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MySubscriptions.aspx.cs" Inherits="AbleCommerce.Members.MySubscriptions" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<style type="text/css">

.popupContainer 
{
 width:0;
 height:0;
 margin:0 auto; 
 position:fixed;
 left:50%;
 top:50%;
 margin-left:-250px;
 margin-top:-250px; 
}
.popupContainer .modalPopup  
{
    top:0 !important;
    left:0 !important;
    position:relative !important;
    z-index : 100001;
}
</style> 
<div id="accountPage"> 
    <div id="account_subscriptionsPage" class="mainContentWrapper">
	    <div class="section">
            <div class="content">
                <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                <div class="tabpane">
                    <asp:UpdatePanel ID="SubAjax" runat="server">
                        <ContentTemplate>                        
                            <cb:ExGridView ID="SubscriptionGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="SubscriptionId"
                                DataSourceID="SubscriptionsDs"
                                AllowSorting="True" AllowPaging="true" PageSize="20" Width="100%" SkinID="PagedList"
                                EnableViewState="True" 
                                OnRowDataBound="SubscriptionGrid_OnRowDataBound"
                                OnRowCommand="SubscriptionGrid_RowCommand"
                                OnRowEditing="SubscriptionGrid_RowEditing"
                                OnRowCancelingEdit="SubscriptionGrid_RowCancelingEdit" 
                                OnRowUpdating="SubscriptionGrid_RowUpdating" FixedColIndexes="0,2">
                                <Columns>
                                    <asp:TemplateField HeaderText="Order #" SortExpression="OrderItem.Id">
                                        <HeaderStyle CssClass="orderNumber" />
                                        <ItemStyle CssClass="orderNumber" Width="40px" />
                                        <ItemTemplate> 
                                            <asp:HyperLink ID="ViewOrderLink" runat="server" Text='<%#Eval("OrderItem.Order.OrderNumber")%>' NavigateUrl='<%#String.Format("~/Members/MyOrder.aspx?OrderNumber={0}", Eval("OrderItem.Order.OrderNumber"))%>'></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Thumbnail">
                                        <HeaderStyle CssClass="thumbnail" />
                                        <ItemStyle CssClass="thumbnail" />
                                        <ItemTemplate>
                                            <asp:Image ID="Thumbnail" runat="server" AlternateText='<%# Eval("OrderItem.Name") %>' ImageUrl='<%#AbleCommerce.Code.ProductHelper.GetThumbnailUrl(Eval("OrderItem"))%>' EnableViewState="false" Visible='<%#!string.IsNullOrEmpty((string)Eval("OrderItem.Product.ThumbnailUrl")) %>' />
                                            <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible='<%#string.IsNullOrEmpty((string)Eval("OrderItem.Product.ThumbnailUrl")) %>' EnableViewState="false" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Subscription Item" SortExpression="Name">
                                        <HeaderStyle CssClass="orderItems" />
                                        <ItemStyle CssClass="orderItems" />
                                        <ItemTemplate>
                                            <%#Eval("Quantity")%> of:
                                            <%#Eval("Name")%>
                                            <br />
                                            <asp:Label ID="ItemPriceLabel" runat="server" Text="Price:"></asp:Label>
                                            <asp:Label ID="ItemPrice" runat="server" Text='<%#((decimal)Eval("OrderItem.Price")).LSCurrencyFormat("ulc")%>' CssClass="price"></asp:Label>
                                            <br />
                                            <asp:Label ID="AutoDeliveryDescription" runat="server"> </asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Delivery Frequency" SortExpression="PaymentFrequency">
                                        <HeaderStyle CssClass="delivery" />
                                        <ItemStyle CssClass="delivery" />
                                        <ItemTemplate>
                                            <asp:Label ID="DeliveryFrequencyLabel" runat="server" Text=""></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="AutoDeliveryInterval" runat="server" />
                                            <asp:Label ID="NoFrequency" runat="server" Text="N/A" Visible="false"></asp:Label>
                                            <asp:LinkButton ID="SaveButton" runat="server" Text="Save" SkinID="button" CommandArgument='<%#Eval("SubscriptionId")%>' CommandName="Update"/>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Expiration" SortExpression="ExpirationDate">
                                        <HeaderStyle CssClass="subscriptionExpiration" />
                                        <ItemStyle CssClass="subscriptionExpiration" />
                                        <ItemTemplate>
                                            <asp:Label ID="Expiration" runat="server" text='<%#GetExpirationDate(Container.DataItem)%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Active" SortExpression="IsActive">
                                        <HeaderStyle CssClass="subscriptionActive" />
                                        <ItemStyle CssClass="subscriptionActive" />
                                        <ItemTemplate>
                                            <asp:Label ID="Active" runat="server" Text='<%# GetIsActive(Container.DataItem) %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Next Payment Due" SortExpression="NextOrderDueDate">
                                        <HeaderStyle CssClass="subscriptionNextPayment" />
                                        <ItemStyle CssClass="subscriptionNextPayment" />
                                        <ItemTemplate>
                                            <asp:Label ID="NextPayment" runat="server" Text='<%#GetNextOrderDate(Container.DataItem)%>' EnableViewState="false"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemStyle Width="80px" />
                                        <ItemTemplate>
                                            <asp:LinkButton ID="ChangeButton" runat="server" Text="Change" SkinID="button" CommandArgument='<%#Eval("SubscriptionId")%>' CommandName="Edit" Visible='<%#CanChangeSubscription(Container.DataItem) %>' />
                                            <asp:LinkButton ID="CancelButton" runat="server" Text="Cancel" CommandName="CancelSubscription" SkinID="button" CommandArgument='<%#Eval("SubscriptionId")%>' Visible='<%#CanCancelSubscription(Container.DataItem) %>' OnClientClick="return confirm('Are you sure you want to cancel this subscription?')"></asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="CancelButton" runat="server" Text="Back  " SkinID="button" OnClick="CancelButton_Click"></asp:LinkButton>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <asp:localize ID="NoSubscriptions" runat="server" Text="You do not have any active subscriptions."></asp:localize>
                                </EmptyDataTemplate>
                            </cb:ExGridView>
                            <asp:HiddenField ID="HiddenSubscriptionId" runat="server" />
                            <asp:HiddenField ID="HiddenIsShipping" runat="server" />
                            <asp:Panel ID="ChangeAddressPanel" runat="server" DefaultButton="SaveAddressButton" ViewStateMode="Enabled" CssClass="popupContainer">
                                <asp:Panel ID="ChangeAddressDialog" runat="server" Style="width:550px" CssClass="modalPopup" ViewStateMode="Enabled">
                                    <asp:Panel ID="DialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                                        <asp:Localize ID="EditCaption" runat="server" Text="Edit Shipping Address" Visible="false"/>
                                        <asp:Localize ID="EditBillingCaption" runat="server" Text="Edit Billing Address" Visible="false" />
                                    </asp:Panel>
                                    <div class="modalPopupContent">
                                        <p class="text">
                                            <asp:Literal ID="AddressInstructionsText" runat="server" Text="Enter the address in the form below. * denotes a required field."></asp:Literal>
                                        </p>
                                        <asp:ValidationSummary ID="AddValidationSummary" runat="server" ShowSummary="true" ValidationGroup="AddrBook" />
                                        <table class="inputForm">
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="FirstName" runat="server" MaxLength="30" Width="200"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                                        ErrorMessage="First name is required." Display="Static" ControlToValidate="FirstName" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="LastName" runat="server" MaxLength="50" Width="200"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                                        ErrorMessage="Last name is required." Display="Static" ControlToValidate="LastName" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="CompanyLabel" runat="server" Text="Company:" AssociatedControlID="Company"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Company" runat="server" MaxLength="50" Width="200"></asp:TextBox><br />
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" AssociatedControlID="Address1"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Address1" runat="server" MaxLength="100" Width="200"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                                        ErrorMessage="Address is required." Display="Static" ControlToValidate="Address1" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" AssociatedControlID="Address2"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Address2" runat="server" MaxLength="100" Width="200"></asp:TextBox> 
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="City" runat="server" MaxLength="50" Width="200"></asp:TextBox><span class="requiredField">*</span> 
                                                    <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                                        ErrorMessage="City is required." Display="Static" ControlToValidate="City" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                             <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="CountryLabel" runat="server" Text="Country:" AssociatedControlID="Country"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:DropDownList ID="Country" DataSourceID="CountryDs" runat="server" DataTextField="Name" DataValueField="CountryCode" AutoPostBack="true" OnSelectedIndexChanged="CountryChanged" Width="250" AppendDataBoundItems="false" ViewStateMode="Enabled">
                                                        <%-- provide a default to prevent validation errors on initial load --%>
                                                        <asp:ListItem Value=""></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource ID="CountryDs" runat="server" OldValuesParameterFormatString="original_{0}"
                                                        SelectMethod="LoadAll" TypeName="CommerceBuilder.Shipping.CountryDataSource" SortParameterName="sortExpression" 
                                                        DataObjectTypeName="CommerceBuilder.Shipping.Country">
                                                    </asp:ObjectDataSource>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="Province"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Province" runat="server" MaxLength="50" Width="250"></asp:TextBox> 
                                                    <asp:DropDownList ID="Province2" runat="server" Width="250" Visible="false"></asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="ProvinceRequired" runat="server" Text="*"
                                                        ErrorMessage="State or province is required." Display="Dynamic" ControlToValidate="Province" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
                                                        ErrorMessage="State or province is required." Display="Static" ControlToValidate="Province2" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" AssociatedControlID="PostalCode"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="PostalCode" runat="server" MaxLength="10" Width="100"></asp:TextBox><span class="requiredField">*</span> 
                                                    <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*"
                                                        ErrorMessage="ZIP or Postal Code is required." Display="Static" ControlToValidate="PostalCode" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="USPostalCodeRequired" runat="server" Text="*" ValidationExpression="^\d{5}(-?\d{4})?$"
                                                        ErrorMessage="ZIP code should be in the format of ######(-####)." Display="Static" ControlToValidate="PostalCode" ValidationGroup="AddrBook"></asp:RegularExpressionValidator>
                                                    <asp:RegularExpressionValidator ID="CAPostalCodeRequired" runat="server" Text="*" ValidationExpression="^[A-Za-z][0-9][A-Za-z] ?[0-9][A-Za-z][0-9]$"
                                                        ErrorMessage="Postal code should be in the format of A#A #A#." Display="Static" ControlToValidate="PostalCode" ValidationGroup="AddrBook"></asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="PhoneLabel" runat="server" Text="Telephone:" AssociatedControlID="Phone"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Phone" runat="server" MaxLength="30" Width="100"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Text="*"
                                                        ErrorMessage="Phone number is required." Display="Static" ControlToValidate="Phone" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="rowHeader">
                                                    <asp:Label ID="FaxLabel" runat="server" Text="Fax:" AssociatedControlID="Fax"></asp:Label>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="Fax" runat="server" MaxLength="30" Width="100"></asp:TextBox> 
                                                </td>
                                            </tr>
                                            <tr id="trIsBusiness" runat="server">
                                                <td>&nbsp;</td>
                                                <td><asp:CheckBox ID="IsBusiness" runat="server" Text="Check box if this is a business address." /></td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td>
                                                    <asp:Button ID="SaveAddressButton" runat="server" Text="Save Address" ValidationGroup="AddrBook" CssClass="button" OnClick="SaveAddressButton_Click"></asp:Button>
											        <asp:LinkButton ID="CancelAddressButton" runat="server" Text="Cancel" CausesValidation="false" CssClass="button"></asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </asp:Panel>
                                <asp:LinkButton ID="DummyLink" runat="server" EnableViewState="false" />
                                <ajaxToolkit:ModalPopupExtender ID="EditAddressPopup" runat="server"
                                    TargetControlID="DummyLink"
                                    PopupControlID="ChangeAddressDialog" 
                                    BackgroundCssClass="modalBackground"                         
                                    CancelControlID="CancelAddressButton" 
                                    DropShadow="false"
                                    PopupDragHandleControlID="DialogHeader"                                    
                                     />
                            </asp:Panel>
                            <asp:HiddenField ID="HiddenProfileId" runat="server" />  
                            <asp:Panel ID="EditCardContainer" runat="server" DefaultButton="SaveCardButton" ViewStateMode="Enabled" CssClass="popupContainer">
                                <asp:Panel ID="EditCardInfoDialog" runat="server" Style="width:400px" CssClass="modalPopup" ViewStateMode="Enabled">
                                    <asp:Panel ID="EditCardPanel" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                                        <asp:Localize ID="EditCardLabel" runat="server" Text="Edit Card"/>
                                    </asp:Panel>
                                    <div class="modalPopupContent">
                                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowSummary="true" ValidationGroup="EditCard" />
                                        <table class="inputForm">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="NameOnCardLabel" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="reference">
                                                    <asp:Label ID="ReferenceLabel" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                             <tr>
                                                 <td>
                                                    <b><asp:Label ID="ExpiryLabel" runat="server" Text="Expiration:"></asp:Label></b>
                                                    <asp:Panel ID="DatePanel" runat="server" CssClass="expiryDateSelection">
                                                        <div class="inputFiedExp">
                                                            <asp:dropdownlist ID="ExpirationMonth" runat="server" ValidationGroup="EditCard">
                                                                <asp:ListItem Text="Month" Value=""></asp:ListItem>
                                                                <asp:ListItem Value="01">01</asp:ListItem>
                                                                <asp:ListItem Value="02">02</asp:ListItem>
                                                                <asp:ListItem Value="03">03</asp:ListItem>
                                                                <asp:ListItem Value="04">04</asp:ListItem>
                                                                <asp:ListItem Value="05">05</asp:ListItem>
                                                                <asp:ListItem Value="06">06</asp:ListItem>
                                                                <asp:ListItem Value="07">07</asp:ListItem>
                                                                <asp:ListItem Value="08">08</asp:ListItem>
                                                                <asp:ListItem Value="09">09</asp:ListItem>
                                                                <asp:ListItem Value="10">10</asp:ListItem>
                                                                <asp:ListItem Value="11">11</asp:ListItem>
                                                                <asp:ListItem Value="12">12</asp:ListItem>
                                                            </asp:dropdownlist>
                                                            <asp:RequiredFieldValidator ID="MonthValidator" runat="server" ErrorMessage="You must select the expiration month." 
                                                                ControlToValidate="ExpirationMonth" Display="Static" Text="*" ValidationGroup="EditCard"></asp:RequiredFieldValidator>
                                                            <asp:dropdownlist ID="ExpirationYear" Runat="server" ValidationGroup="EditCard">
                                                                <asp:ListItem Text="Year" Value=""></asp:ListItem>
                                                            </asp:dropdownlist>
                                                            <cb:expirationdropdownvalidator ID="ExpirationDropDownValidator1" runat="server"
                                                                Display="Dynamic" errormessage="You must enter an expiration date in the future."
                                                                monthcontroltovalidate="ExpirationMonth" yearcontroltovalidate="ExpirationYear"
                                                                Text="*" ValidationGroup="EditCard"></cb:expirationdropdownvalidator>
                                                            <asp:RequiredFieldValidator ID="YearValidator" runat="server" ErrorMessage="You must select the expiration year." 
                                                                ControlToValidate="ExpirationYear" Display="Static" Text="*" ValidationGroup="EditCard"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </asp:Panel>
                                                     </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b><asp:Label ID="SecurityCodeLabel" runat="server" Text="Verification Code:"></asp:Label></b>
                                                    <asp:TextBox ID="SecurityCode" runat="server" Width="80" ValidationGroup="EditCard"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:LinkButton ID="SaveCardButton" runat="server" Text="Save" ValidationGroup="EditCard" CssClass="button" OnClick="SaveCardButton_Click"></asp:LinkButton>
											        <asp:LinkButton ID="CancelCardButton" runat="server" Text="Cancel" CausesValidation="false" CssClass="button"></asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </asp:Panel>
                                <asp:LinkButton ID="EditCardInfoButton" runat="server" EnableViewState="false" />
                                <ajaxToolkit:ModalPopupExtender ID="EditCardInfoPopUp" runat="server"
                                    TargetControlID="EditCardInfoButton"
                                    PopupControlID="EditCardInfoDialog" 
                                    BackgroundCssClass="modalBackground"                         
                                    CancelControlID="CancelCardButton" 
                                    DropShadow="false"
                                    PopupDragHandleControlID="EditCardPanel"                                    
                                     />
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:ObjectDataSource ID="SubscriptionsDs" runat="server" SelectMethod="LoadForUser" UpdateMethod="Update" OldValuesParameterFormatString="original_{0}"
                        TypeName="CommerceBuilder.Orders.SubscriptionDataSource" 
                        DataObjectTypeName="CommerceBuilder.Orders.Subscription" 
                        onselecting="SubscriptionDs_Selecting" SortParameterName="sortExpression" EnablePaging="true" >
                        <SelectParameters>
                            <asp:Parameter Name="userId" DefaultValue="0" Type="Int32" />
                            <asp:Parameter Name="sortExpression" DefaultValue="Id DESC" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>
            </div>
	    </div>
    </div>
</div>
</asp:Content>