<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.StoreSettings" Title="Global Settings"  CodeFile="StoreSettings.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Configure Store"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
        </div>
    </div>
    <asp:UpdatePanel ID="SettingsPanel" runat="server">
        <ContentTemplate>
            <div id="stickyActions" class="content aboveGrid stickyActions">
                <asp:Button Id="SaveButton" runat="server" Text="Save Settings" SkinID="SaveButton" OnClick="SaveButton_Click" />
            </div>
            <div class="content aboveGrid">
                <asp:ValidationSummary ID="ValidationSummary2" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="The store settings have been saved." Visible="false" SkinID="GoodCondition"></cb:Notification>
            </div>
            <div class="grid_6 alpha">
                <div class="leftColumn">
			        <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="GeneralCaption" runat="server" Text="General"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="StoreNameLabel" runat="Server" Text="Store Name:" AssociatedControlID="StoreName" ToolTip="The name of your store." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="StoreName" runat="server" width="180px" MaxLength="100"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="StoreUrlLabel" runat="Server" Text="Store URL:" AssociatedControlID="StoreUrl" ToolTip="The current URL to your store home page.  URL and SSL settings can be altered by system administrators from the Configure > Security > System Settings page." />
                                    </th>
                                    <td>
                                        <asp:HyperLink ID="StoreUrl" runat="server" NavigateUrl="~/Admin/Store/Security/Default.aspx"></asp:HyperLink>
                                        <asp:Literal ID="StoreUrlLiteral" runat="server"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <asp:Label ID="SiteDisclaimerLabel" runat="server" Text="Site Disclaimer:"></asp:Label><br />                        
                                        <asp:Label ID="SiteDisclaimerHelpLabel" CssClass="helpText" runat="server" Text="Enter a site disclaimer message, if you require a user to agree to your terms before viewing the store."></asp:Label>
                                        <br />
                                        <asp:ImageButton ID="SiteDisclaimerHtml" runat="server" SkinID="HtmlIcon" />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="SiteDisclaimerMessage" runat="server" Rows="7" TextMode="MultiLine" Width="270px"  Columns="50"></asp:TextBox><br />
                                        <asp:Label ID="SiteDisclaimerInstText" CssClass="helpText" runat="server" Text="If you do not want to enforce a disclaimer message, then leave this field empty."></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="RestrictStoreAccessLabel" runat="Server" Text="Access Restriction:" AssociatedControlID="RestrictStoreAccessOptions" ToolTip="Restrict access to your store. 'None' means no restriction. 'RegisteredUsersOnly' will prevent anonymous users from accessing the store. 'AuthorizedGroupsOnly' will allow you to configure selected groups that can access the store." />
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="RestrictStoreAccessOptions" runat="server" OnSelectedIndexChanged="RestrictStoreAccess_Changed" AutoPostBack="true">
                                            <asp:ListItem Text="None" Value="None"></asp:ListItem>
                                            <asp:ListItem Text="Registered Users Only" Value="RegisteredUsersOnly"></asp:ListItem>
                                            <asp:ListItem Text="Authorized Groups Only" Value="AuthorizedGroupsOnly"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="AuthorizedGroupsLabel" runat="Server" Text="Authorized Groups:" AssociatedControlID="AuthorizedGroups" ToolTip="When the store front access is restricted for authorized groups, only the admin users or users belonging to selected groups will be able to access the store front." />
                                    </th>
                                    <td>
                                        <asp:ListBox ID="AuthorizedGroups" runat="server" DataTextField="Name" DataValueField="GroupId" SelectionMode="Multiple" Width="150" ></asp:ListBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="OrderSettingCaption" runat="server" Text="Order Settings"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Label ID="OrderSettingsHelpText" runat="server" Text="Customize your order number settings, or the minimum and maximum purchase requirements."></asp:Label>
                            <asp:Label ID="NextOrderNumberWarning" runat="server" SkinId="ErrorCondition" Text="The next order number of {0} is less than the highest assigned order number of {1}.  It is recommended that you increase your next order number to at least {2} to prevent errors." EnableViewState="false"></asp:Label>
                            <table class="inputForm compact">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="NextOrderNumberLabel" runat="server" Text="Next Order Number:" ToolTip="The number that will be assigned to the next order placed in the store. It must be greater than the highest assigned order number."></cb:ToolTipLabel><br />
                                    </th>
                                    <td>
                                        <asp:HiddenField ID="OrigNextOrderNumber" runat="server" />
                                        <asp:TextBox ID="NextOrderId" runat="server" Columns="8" MaxLength="8"></asp:TextBox>
                                        <asp:Label ID="NextOrderIdLabel" runat="server" Visible="false" EnableViewState="false"></asp:Label>
                                        <asp:RangeValidator ID="NextOrderNumberRangeValidator1" runat="server" Type="Integer" MinimumValue="0" MaximumValue="99999999" ControlToValidate="NextOrderId" ErrorMessage="Next order number must be a numeric value between '{0}' and '99,999,999'." Text="*" EnableViewState="false"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="OrderNumberIncrementLabel" runat="server" Text="Increment:" ToolTip="The number to add to the next order number for each order that is placed.  Use 1 for sequential order numbers."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="OrderIdIncrement" runat="server" Columns="8" MaxLength="4"></asp:TextBox>
                                        <asp:RangeValidator ID="OrderNumberIncrementValidator1" runat="server" Type="Integer" MinimumValue="0"  MaximumValue="9999" ControlToValidate="OrderIdIncrement" ErrorMessage="Order number increment must be a numeric value." Text="*"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="OrderMinAmountLabel" runat="server" Text="Order Minimum Amount:" ToolTip="If the order amount will be less then the minimum then it will not allowed to checkout"></cb:ToolTipLabel><br />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="OrderMinAmount" runat="server" Columns="8"></asp:TextBox>
                                        <asp:RangeValidator ID="OrderMinAmountValidator1" runat="server" Type="Double" MinimumValue="0" MaximumValue="999999999" ControlToValidate="OrderMinAmount" ErrorMessage="Order minimum amount must be a numeric value." Text="*"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="OrderMaxAmountLabel" runat="server" Text="Order Maximum Amount:" ToolTip="If the order amount will be more then the maximum then it will not allowed to checkout"></cb:ToolTipLabel><br />                                                                          
                                    </th>
                                    <td>
                                        <asp:TextBox ID="OrderMaxAmount" runat="server" Columns="8" ></asp:TextBox>
                                        <asp:RangeValidator ID="OrderMaxAmountValidator1" runat="server" Type="Double" MinimumValue="0" MaximumValue="999999999" ControlToValidate="OrderMaxAmount" ErrorMessage="Order maximum amount must be a numeric value.<br/>" Text="*"></asp:RangeValidator>
                                        <asp:CompareValidator ID="OrderMinMaxAmountValidator1" runat="server" Type="Double" Operator="GreaterThanEqual" ControlToValidate="OrderMaxAmount" ControlToCompare="OrderMinAmount" ErrorMessage="Order maximum amount should be greater then minimum amount." Text="*" ></asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="EnableOrderNotesLabel" runat="server" Text="Allow Order Notes:" ToolTip="Check this box to allow customers to add order notes from their receipt page. If unchecked, customers will only be able to see notes that added by the merchant."></cb:ToolTipLabel><br />                                                                          
                                    </th>
                                    <td>
                                        <asp:CheckBox ID="EnableOrderNotes" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="ProductPurchasingDisabledLabel" runat="server" Text="Enable Catalog Mode:" AssociatedControlID="ProductPurchasingDisabled" EnableViewState="false" ToolTip="Hide the purchase buttons and prevent customers from placing orders.  In catalog mode your products can only be previewed." />
                                    </th>
                                    <td>
                                        <asp:CheckBox ID="ProductPurchasingDisabled" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="EnableWishlists" runat="server" Text="Enable Wishlists:" AssociatedControlID="WishListsEnabled" EnableViewState="false" ToolTip="Hide the wishlist options and prevent customers from adding items to wishlists." />
                                    </th>
                                    <td>
                                        <asp:CheckBox ID="WishlistsEnabled" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="Localize1" runat="server" Text="Checkout Settings"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Label ID="CheckoutsettingHelpText" runat="server" Text="Select the criteria for a user's checkout and registration requirements."></asp:Label></p>
                            <table class="inputForm">
                                <tr>
                                    <td valign="top">
                                        <asp:CheckBox ID="EnableOnePageCheckout" runat="server" Text="One Page Checkout" CssClass="fieldHeader" />
                                        <asp:Label ID="EnableOnePageCheckoutHelpText" runat="server" Text=" - allow users to checkout from a single page." CssClass="helpText" EnableViewState="false" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="EnableShipToMultipleAddresses" runat="server" Text="Multiple Addresses" CssClass="fieldHeader" />
                                        <asp:Label ID="EnableShipToMultipleAddressesHelpLabel" runat="server" Text=" - allow users to have different shipping addresses." CssClass="helpText" EnableViewState="false" ></asp:Label><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="EnableShipMessage" runat="server" Text="Delivery Instructions" CssClass="fieldHeader" />
                                        <asp:Label ID="EnableShipMessageHelpLabel" runat="server" Text=" - allow users to enter special shipping information." CssClass="helpText" EnableViewState="false"  /><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td id="tdPaymentStorage" runat="server">
                                        <asp:CheckBox ID="PaymentStorage" runat="server" Text="Payment Storage" CssClass="fieldHeader" />
                                        <asp:Label ID="PaymentStorageLabel" runat="server" Text=" - allow registered users to save credit card information." CssClass="helpText" EnableViewState="false"  /><br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="GuestCheckoutTitle" runat="server" Text="Guest Checkout" CssClass="fieldHeader"></asp:Label>
                                        <asp:Label ID="GuestCheckoutHelpText" runat="server" Text=" - Offer customers the option to checkout using a Guest Account. Guests will not be able to login to the store and check order status, or gain access to the My Account pages for digital goods, profile updates and more." CssClass="helpText" EnableViewState="false" />
                                        <br />
                                        <ul>
                                            <li><asp:RadioButton ID="AllowGuestCheckout" runat="server" CssClass="fieldHeader" Text="Enable for all users and order types." GroupName="GuestCheckout"/></li>
                                            <li><asp:RadioButton ID="LimitedGuestCheckout" runat="server" CssClass="fieldHeader" Text="Limit to users that are not ordering digital goods or subscriptions." GroupName="GuestCheckout"/></li>
                                            <li><asp:RadioButton ID="DisableGuestCheckout" runat="server" CssClass="fieldHeader" Text="Disable for all users." GroupName="GuestCheckout"/></li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="PaymentsLabel" runat="server" Text="Order Payments" CssClass="fieldHeader"></asp:Label>
                                        <asp:Label ID="PaymentsHelpText" runat="server" CssClass="helpText" EnableViewState="false"  Text=" - When a payment fails, you can require the customer to keep retrying, or you can create the order with a balance due. The customer can retry making payments with a valid order in the system, other the order will not be created unless it is paid in full at time of checkout." />
                                        <br />
                                        <ul>
                                            <li><asp:RadioButton ID="AllowOnlyFullPayments" runat="server" CssClass="fieldHeader" Text="Do not create order unless it has a successful payment." GroupName="CheckoutPayment"/></li>
                                            <li><asp:RadioButton ID="IgnoreFailedPayments" runat="server" CssClass="fieldHeader" Text="Always create order even if payment fails." GroupName="CheckoutPayment"/></li>
                                            <li><asp:RadioButton ID="AllowPartialPaymnets" runat="server" CssClass="fieldHeader" Text="Create order and allow partial payments or multiple payments" GroupName="CheckoutPayment"/><br /><asp:Label ID="PartialPaymentsHelpText" runat="server" Text="(Not available for recurring subscription payments)" CssClass="helpText" EnableViewState="false"/></li>
                                        </ul>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="Localize2" runat="server" Text="WYSIWYG HTML Editor"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Label ID="HtmlEditorDetails" runat="server" Text="Enable or disable the inline WYSIWYG HTML Editor."></asp:Label></p>
                            <table class="inputForm">
                                <tr>
                                    <td valign="top">
                                        <asp:CheckBox ID="EnableHtmlEditor" runat="server" Text="Enable WYSIWYG Editor" CssClass="fieldHeader" />
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
                            <h2 class="localesettings"><asp:Localize ID="UnitsCaption" runat="server" Text="Locale Settings"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Label ID="UnitsHelpText" runat="server" Text="Specify the default timezone and units of weight and measuresurement.  The units chosen here apply to all products, and take effect immediately on update."></asp:Label></p>
                            <table class="inputForm">
                                <tr>
                                    <th valign="top" >
                                        <cb:ToolTipLabel ID="WeightUnitLabel" runat="server" Text="Unit of Weight:" ToolTip="If you enter weights for your products, select the units that will be used." AssociatedControlID="WeightUnit"></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="WeightUnit" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top" >
                                        <cb:ToolTipLabel ID="MeasurementUnitLabel" runat="server" Text="Unit of Measurement:" ToolTip="If you enter dimensions for your products, select the units that will be used." AssociatedControlID="MeasurementUnit"></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="MeasurementUnit" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top" >
                                        <cb:ToolTipLabel ID="TimeZoneOffsetLabel" runat="server" Text="Timezone Offset:" ToolTip="Select the timezone that is currently in effect for this store.  All times displayed will be converted into the time zone you select." AssociatedControlID="TimeZoneOffset"></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="TimeZoneOffset" runat="server">
                                            <asp:ListItem Text="" Value=""></asp:ListItem>
                                            <asp:ListItem Text="Atlantic Standard Time" Value="AST"></asp:ListItem>
                                            <asp:ListItem Text="Atlantic Daylight Time" Value="ADT"></asp:ListItem>
                                            <asp:ListItem Text="Alaska Standard Time" Value="AKST"></asp:ListItem>
                                            <asp:ListItem Text="Alaska Daylight Time" Value="AKDT"></asp:ListItem>
                                            <asp:ListItem Text="Central Standard Time" Value="CST"></asp:ListItem>
                                            <asp:ListItem Text="Central Daylight Time" Value="CDT"></asp:ListItem>
                                            <asp:ListItem Text="Eastern Standard Time" Value="EST"></asp:ListItem>
                                            <asp:ListItem Text="Eastern Daylight Time" Value="EDT"></asp:ListItem>
                                            <asp:ListItem Text="Hawaii Standard Time" Value="HAST"></asp:ListItem>
                                            <asp:ListItem Text="Hawaii Daylight Time" Value="HADT"></asp:ListItem>
                                            <asp:ListItem Text="Mountain Standard Time" Value="MST"></asp:ListItem>
                                            <asp:ListItem Text="Mountain Daylight Time" Value="MDT"></asp:ListItem>
                                            <asp:ListItem Text="Newfoundland Standard Time" Value="NST"></asp:ListItem>
                                            <asp:ListItem Text="Newfoundland Daylight Time" Value="NDT"></asp:ListItem>
                                            <asp:ListItem Text="Pacific Standard Time" Value="PST"></asp:ListItem>
                                            <asp:ListItem Text="Pacific Daylight Time" Value="PDT"></asp:ListItem>
                                            <asp:ListItem Text="-----------------" Value=""></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top" >
                                        <cb:ToolTipLabel ID="PostalCodeCountriesLabel" runat="server" Text="Postal Code Countries:" ToolTip="Comma delimited list of two letter country codes that should require a postal code on address entry forms."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="PostalCodeCountries" runat="server" Rows="7" TextMode="MultiLine" width="270px" MaxLength="1000"></asp:TextBox><br />
                                        <asp:Label ID="PostalCodeInstText" CssClass="helpText" runat="server" Text="Countries that require a postal code."></asp:Label><br />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
			        <div class="section">			        
                        <div class="header">
                            <h2 class="inventory"><asp:Localize ID="InventoryCaption" runat="server" Text="Inventory Control"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Localize ID="InventoryHelpText" runat="server" Text="Use the inventory management features to track and control stock, and display to users details about each product's inventory levels."></asp:Localize></p>
                            <asp:UpdatePanel ID="InventoryAjax" runat="server">
                                <ContentTemplate>
                                    <p><asp:CheckBox ID="EnableInventory" runat="server" Text="Enable Inventory Management" AutoPostBack="true" OnCheckedChanged="EnableInventory_CheckChanged"></asp:CheckBox></p>
                                    <asp:PlaceHolder ID="InventoryPanel" runat="server">
                                        <table class="inputForm">
                                            <tr>
                                                <th>
                                                    <cb:ToolTipLabel ID="CurrentInventoryDisplayModeLabel" runat="server" Text="Display Inventory:" ToolTip="Display the inventory details of the products on store."></cb:ToolTipLabel>
                                                </th>
                                                <td >                                    
                                                    <asp:DropDownList ID="CurrentInventoryDisplayMode" runat="server">
                                                        <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Yes"></asp:ListItem>                                                
                                                    </asp:DropDownList>                                                                                                                            
                                                </td>
                                            </tr>       
                                            <tr>
                                                <th>
                                                    <cb:ToolTipLabel ID="InStockMessageLabel" runat="server" Text="In-Stock Message:" ToolTip="The message that will be displayed when the product is in stock."></cb:ToolTipLabel>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="InStockMessage"  runat="server" Columns="40" MaxLength="200" Text="{0} units available"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>
                                                    <cb:ToolTipLabel ID="OutOfStockMessageLabel" runat="server" Text="Out-of-Stock Message:" ToolTip="The message that will be displayed when the product will be out of stock."></cb:ToolTipLabel>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="OutOfStockMessage" runat="server" Columns="40" MaxLength="200" Text="The product is currently out of stock, current quantity is {0}. "></asp:TextBox>
                                                </td>                                                    
                                            </tr>
                                            <tr>
                                                <th>
                                                    <cb:ToolTipLabel ID="InventoryAvailabilityMessageLabel" runat="server" Text="Availability Date Message:" ToolTip="The message that will be displayed when the product have expected availability date specified."></cb:ToolTipLabel>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="InventoryAvailabilityMessage" runat="server" Columns="40" MaxLength="200" Text="More stock is expected on {0}."></asp:TextBox>
                                                </td>                                                    
                                            </tr>
                                            <tr>
                                                <th>
                                                    <cb:ToolTipLabel ID="RestockNotificationLinkLabel" runat="server" Text="Restock Notification Link:" ToolTip="The notification subscription message that will be displayed when the product is out of stock."></cb:ToolTipLabel>
                                                </th>
                                                <td>
                                                    <asp:TextBox ID="RestockNotificationLink" runat="server" Columns="40" MaxLength="200"></asp:TextBox>
                                                </td>                                                    
                                            </tr>
                                            <tr>
                                                <th>
                                                    <cb:ToolTipLabel ID="RestockNotificationEmailLabel" runat="server" Text="Restock Notification Email:" ToolTip="The message that will be displayed when the product have expected availability date specified."></cb:ToolTipLabel>
                                                </th>
                                                <td>
                                                    <asp:DropDownList ID="RestockNotificationEmail" runat="server" >
                                                        <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>                                                    
                                            </tr>
                                        </table>          
                                    </asp:PlaceHolder>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>                
			        <div class="section">
                        <div class="header">
                            <h2 class="volumediscounts"><asp:Localize ID="VolumeDiscountsCaption" runat="server" Text="Discount Setting"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <p><asp:Label ID="DiscountModeHelpText" runat="server" Text="Use the Discount Mode setting to determine how global discounts and category level discounts are treated when different qualifying items are purchased. This setting does not impact discounts set to a specific product."></asp:Label></p>
                            <p><asp:Label ID="DiscountModeHelpText1a" runat="server" Text="&quot;Line Item&quot; mode - Each product is checked individually to see whether it is eligible to receive a discount. Items that are part of a Kit are treated separately as well."></asp:Label></p>
                            <p><asp:Label ID="DiscountModeHelpText1b" runat="server" Text="&quot;Group by Category&quot; mode - When a discount is applied to a Category, then all of the products in that Category and it's sub-categories are eligible to receive the discount. These items are totaled to determine the discounted amount. When a Global discount is active, then all items are totaled to determine the discount."></asp:Label></p>
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="DiscountModeLabel" runat="Server" SkinID="FieldHeader" Text="Discount Mode: "></asp:Label>
                                    </td>
                                    <td>
                                        <asp:RadioButtonList ID="DiscountMode" runat="server" RepeatDirection="horizontal">
                                            <asp:ListItem Value="0" Text="Line Item"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Group By Category"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                            </table>
                            <asp:Label ID="DiscountModeHelpText2" runat="server" CssClass="helpText" Text="Products using Options, that are eligible for discount, will always be combined regardless of the discount mode setting."></asp:Label>
                        </div>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="SearchSettingsCaption" runat="server" Text="Search Settings"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <table class="inputForm compact">
                                <tr id="trReindexingMessage" runat="server" visible="false">
                                    <td colspan="2">
                                        <asp:Label ID="lblMessage" runat="server" Text="This change will initiate re-indexing of Lucene indexes which may take some time to complete."></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="SearchProviderLabel" runat="server" Text="Search Provider:" ToolTip="Select the search provider you wish to use.  Lucene is preferred but may not work in all environments.  SQL is not as fast as Lucene but is guaranteed to work for all installations." AssociatedControlID="SearchProvider" />
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="SearchProvider" runat="server" OnSelectedIndexChanged="SearchProvider_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Text="Lucene" Value="LuceneSearchProvider"></asp:ListItem>
                                            <asp:ListItem Text="SQL" Value="SqlSearchProvider"></asp:ListItem>
                                            <asp:ListItem Text="Full-Text Search (SQL Server)" Value="SqlFtsSearchProvider"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="MinimumSearchLengthLabel" runat="server" Text="Minimum Search Length:" ToolTip="The minimum search phrase length for searches on the retail side."></cb:ToolTipLabel><br />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="MinimumSearchLength" runat="server" Columns="3" MaxLength="2"></asp:TextBox>
                                        <asp:RangeValidator ID="MinimumSearchLengthValidator" runat="server" Type="Integer" MinimumValue="1" MaximumValue="99" ControlToValidate="MinimumSearchLength" ErrorMessage="Minimum search length must be a numeric value between '1' and '99'." Text="*" EnableViewState="false"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="PopularSearchThresholdLabel" runat="server" Text="Popular Search Count:" ToolTip="The minimum number of instances for a search to be considered popular and be suggested with autocomplete."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="PopularSearchThreshold" runat="server" Columns="3" MaxLength="5"></asp:TextBox>
                                        <asp:RangeValidator ID="PopularSearchThresholdValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="99999" ControlToValidate="PopularSearchThreshold" ErrorMessage="Popular search threshold must be a positive number." Text="*" EnableViewState="false"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="EnableWishlistSearchLabel" runat="server" Text="Enable Wishlist Search:" ToolTip="Check here to allow customers to search for other customer wishlists using a name or email address. If this is enabled customers will still have to opt in by sharing their wishlist from their profile if they desire. If this is disabled the find wishlist tools will be inaccessible to everyone." AssociatedControlID="EnableWishlistSearch" EnableViewState="false" />
                                    </th>
                                    <td>
                                        <asp:CheckBox ID="EnableWishlistSearch" runat="server" Checked="false"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="CategorySearchDisplayLabel" runat="server" Text="Use Category Search when more than:" ToolTip="When activated, instead listing all categories in drop-down lists, a category search field will be displayed for all search forms. Category search will be activated when the total number of categories exceeds the value entered into the field. A Zero '0' value indicates ignore this setting and always list all categories."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="CategorySearchDisplayLimit" runat="server" Columns="3" MaxLength="5"></asp:TextBox> categories exist.
                                        <asp:RangeValidator ID="CategorySearchDisplayValidator" runat="server" Type="Integer" MinimumValue="0" MaximumValue="99999" ControlToValidate="CategorySearchDisplayLimit" ErrorMessage="Category search limit must be a positive number." Text="*" EnableViewState="false"></asp:RangeValidator>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="Localize3" runat="server" Text="Checkout Terms and Conditions"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="CheckoutTermsLabel" runat="server" Text="Checkout Terms:" CssClass="fieldHeader"></asp:Label>
                                        <asp:Label ID="CheckoutTermsHelpLabel" CssClass="helpText" EnableViewState="false" runat="server" Text="The user must agree to your Terms and Conditions before placing an order." />
                                        <asp:ImageButton ID="CheckoutTermsHtml" runat="server" SkinID="HtmlIcon" />
                                        <br />
                                        <asp:TextBox ID="CheckoutTerms" runat="server" Rows="7" TextMode="MultiLine" Columns="70"></asp:TextBox><br />
                                        <asp:Label ID="CheckoutTermsInstText" CssClass="helpText" EnableViewState="false"  runat="server" Text="(If you do not want to enforce checkout terms, then leave this field empty.)"></asp:Label><br />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel> 
</asp:Content>