<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Products.AddProduct" Title="Add Product" CodeFile="AddProduct.aspx.cs" EnableViewState="true" ViewStateMode="Disabled" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Add Product to {0}"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="SaveButton" runat="server" Text="Save and Edit" SkinID="SaveButton" OnClick="SaveButton_Click"></asp:Button>
                <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveButton_Click"></asp:Button>
                <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" ViewStateMode="Enabled"></asp:HyperLink>
            </div>
        </div>
    </div>
    <div class="content">
        <cb:Notification ID="SavedMessage" runat="server" Text="Product saved at {0:t}" SkinID="GoodCondition" Visible="false"></cb:Notification>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
        <div class="sectionHeader">
            <h2>Basic Product Information</h2>
        </div>
        <table cellspacing="0" class="inputForm">
            <tr>
                <th width="100px">
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" ToolTip="Name of the product"></cb:ToolTipLabel>
                </th>
                <td width="350px">
                    <asp:TextBox ID="Name" runat="server" Text="" width="250px" MaxLength="255"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="NameRequired" runat="server" Text="*" Display="Dynamic" ErrorMessage="Name is required." ControlToValidate="Name"></asp:RequiredFieldValidator><br />
                </td>
                <th width="100px">
                    <cb:ToolTipLabel ID="SkuLabel" runat="server" Text="Base SKU:" ToolTip="Stock keeping unit, or a unique identifier for the product."></cb:ToolTipLabel><br />
                </th>
                <td>
                    <asp:TextBox ID="Sku" runat="server" Width="150px" MaxLength="40"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="PriceLabel" runat="server" Text="Price:" ToolTip="Price of the product, prior to any modifications or adjustments."></cb:ToolTipLabel><br />
                </th>
                <td>
                    <asp:TextBox ID="Price" runat="server" width="100px" MaxLength="10"></asp:TextBox>
                    <asp:RangeValidator ID="PriceValidator" runat="server" ControlToValidate="Price"
                        ErrorMessage="Price should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                        MinimumValue="0" Type="Currency">*</asp:RangeValidator>
                </td>
                <th>
                    <cb:ToolTipLabel ID="ManufacturerLabel" runat="server" Text="Manufacturer:" ToolTip="Manufacturer of the product."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:UpdatePanel ID="ManufacturerAjax" runat="server" UpdateMode="conditional" ViewStateMode="Enabled">
                        <ContentTemplate>
                            <asp:DropDownList ID="ManufacturerList" runat="server" DataSourceID="ManufacturerDs" DataTextField="Name" DataValueField="ManufacturerId" AppendDataBoundItems="True" Width="175px">
                                <asp:ListItem Value="" Text=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:LinkButton ID="NewManufacturerLink" runat="server" Text="new" OnClick="NewManufacturerLink_Click" CausesValidation="false" SkinID="Link" OnClientClick="return addManufacturer()"></asp:LinkButton>
                            <asp:HiddenField ID="NewManufacturerName" runat="server" />                    
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:ObjectDataSource ID="ManufacturerDs" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="LoadAll" TypeName="CommerceBuilder.Products.ManufacturerDataSource">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="Name" Name="sortExpression" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="MsrpLabel" runat="server" Text="Retail:" ToolTip="Manufacturer suggested retail price of the product."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="Msrp" runat="server" width="100px" MaxLength="10"></asp:TextBox>
                    <asp:RangeValidator ID="MSRPValidator" runat="server" ControlToValidate="Msrp" ErrorMessage="MSRP should fall between 0.00 and 99999999.99"
                        MaximumValue="99999999.99" MinimumValue="0" Type="Currency">*</asp:RangeValidator>
                </td>
                <th>
                    <cb:ToolTipLabel ID="ModelNumberLabel" runat="server" Text="Model #:" ToolTip="Manufacturer's model or part number for this product."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="ModelNumber" runat="server" Width="150px" MaxLength="40"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="CostOfGoodsLabel" runat="server" Text="Cost:" ToolTip="Your cost for this product, used to calculate profit on a sale."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="CostOfGoods" runat="server" width="100px" MaxLength="10"></asp:TextBox>
                    <asp:RangeValidator ID="CostOfGoodValidator" runat="server" ControlToValidate="CostOfGoods"
                        ErrorMessage="Cost of Goods should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                        MinimumValue="0" Type="Currency">*</asp:RangeValidator>
                </td>
                <th>
                    <cb:ToolTipLabel ID="GtinLabel" runat="server" Text="GTIN:" ToolTip="Provide the UPC, ISBN, or GTIN of the product." AssociatedControlID="Gtin" />
                </th>
                <td>
                    <asp:TextBox ID="Gtin" runat="server" Width="150px"></asp:TextBox>
                </td>
            </tr>
        </table>
        <div class="sectionHeader">
            <h2>Shipping, Tax, and Inventory</h2>
        </div>
        <asp:UpdatePanel ID="InventoryAjax" runat="server" UpdateMode="conditional">
            <ContentTemplate>
                <table cellspacing="0" class="inputForm">
                    <tr>
                        <th width="100px">
                            <cb:ToolTipLabel ID="IsShippableLabel" runat="server" Text="Shippable:" ToolTip="Indicates whether this product is shippable. Yes means it can be shipped in a package with other items. Separately means it has to be shipped in its own package and its shipping charges are calculated separately."></cb:ToolTipLabel>
                        </th>
                        <td width="350px">
                            <asp:DropDownList ID="IsShippable" runat="server">
                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                                <asp:ListItem Value="2">Calculate separately</asp:ListItem>
                            </asp:DropDownList>
                        </td> 
                        <th width="150px">
                            <cb:ToolTipLabel ID="WarehouseLabel" runat="server" Text="Warehouse:" ToolTip="The warehouse where this product ships from."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="Warehouse" runat="server" DataSourceID="WarehouseDs" DataTextField="Name" DataValueField="WarehouseId" OnDataBound="Warehouse_DataBound" Width="175px">
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="WarehouseDs" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="LoadAll" TypeName="CommerceBuilder.Shipping.WarehouseDataSource">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="Name" Name="sortExpression" Type="String" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="WeightLabel" runat="server" Text="Weight:" ToolTip="The shipping weight of the product."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="Weight" runat="server" width="50px" MaxLength="10"></asp:TextBox>
                            <asp:RangeValidator ID="WeightValidator1" runat="server" ControlToValidate="Weight"
                                ErrorMessage="Weight should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                                MinimumValue="0" Type="Double">*</asp:RangeValidator>
			                <asp:Label ID="WeightUnit" runat="server" Text=""></asp:Label>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="VendorLabel" runat="server" Text="Vendor:" ToolTip="The vendor that you acquire this product from."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="Vendor" runat="server" DataSourceID="VendorDs" DataTextField="Name"
                                DataValueField="VendorId" AppendDataBoundItems="True" Width="175px">
                                <asp:ListItem Value="" Text=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="VendorDs" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="LoadAll" TypeName="CommerceBuilder.Products.VendorDataSource">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="Name" Name="sortExpression" Type="String" />
                                </SelectParameters> 
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="DimensionsLabel" runat="server" Text="Dimensions:" ToolTip="The shipping dimensions of the product."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="Length" runat="server" width="50px" MaxLength="10"></asp:TextBox>
                            <asp:RangeValidator ID="LengthValidator" runat="server" ControlToValidate="Length"
                                ErrorMessage="Length should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                                MinimumValue="0" Type="Double" Display="Dynamic">*</asp:RangeValidator>
                            L 
                            <asp:TextBox ID="Width" runat="server" width="50px" MaxLength="10"></asp:TextBox>
                            <asp:RangeValidator ID="WidthValidator1" runat="server" ControlToValidate="Width"
                                ErrorMessage="Width should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                                MinimumValue="0" Type="Double" Display="Dynamic">*</asp:RangeValidator>
                            W 
                            <asp:TextBox ID="Height" runat="server" width="50px" MaxLength="10"></asp:TextBox>
                            <asp:RangeValidator ID="HeightValidator2" runat="server" ControlToValidate="Height"
                                ErrorMessage="Height should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                                MinimumValue="0" Type="Double" Display="Dynamic">*</asp:RangeValidator>
                            H
			                <asp:Label ID="MeasurementUnit" runat="server" Text=""></asp:Label>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="TaxCodeLabel" runat="server" Text="Tax Code:" ToolTip="The tax code that links this product to your custom tax rules."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="TaxCode" runat="server" DataSourceID="TaxCodeDs" DataTextField="Name"
                                DataValueField="TaxCodeId" AppendDataBoundItems="true" OnDataBound="TaxCode_DataBound" Width="175px">
                                <asp:ListItem Value="" Text=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="TaxCodeDs" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="LoadAll" TypeName="CommerceBuilder.Taxes.TaxCodeDataSource">
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                        <th class="HandlingCharges">
                            <cb:ToolTipLabel ID="HandlingChargesLabel" runat="server" Text="Handling Charges:" ToolTip="Special shipping/handling charge for this product (if applicable)."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="HandlingCharges" runat="server" width="100px" MaxLength="10"></asp:TextBox>
                        </td>
                        <asp:PlaceHolder ID="trTIC" runat="server" enableviewstate="true">
                        <th>
                            <cb:ToolTipLabel ID="TICLabel" runat="server" Text="TIC:" ToolTip="The TaxCloud Taxability Information Code, you need to specify this if the TIC of this product differs from default TIC."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="TIC" runat="server" width="75px" MaxLength="10"></asp:TextBox>
                            <a href="#" onclick=" this.style='display:none;';intTICSelect();">select</a>
                            <asp:HiddenField ID="HiddenTIC" runat="server"></asp:HiddenField>
                        </td>
                        </asp:PlaceHolder>                       
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="CurrentInventoryModeLabel" runat="server" Text="Inventory:" ToolTip="Indicate whether to track inventory at the product level, or for individual variants (if applicable)."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="CurrentInventoryMode" runat="server" AutoPostBack="true" OnSelectedIndexChanged="CurrentInventoryMode_SelectedIndexChanged">
                                <asp:ListItem Value="0" Text="Disabled"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Track Product"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Track Variants"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Localize ID="InventoryDisabledMessage" runat="server" Text="Disabled" Visible="false"></asp:Localize>
                        </td>
                        <asp:PlaceHolder ID="BackOrdersHolder" runat="server" visible="false" enableviewstate="true">
                        <th class="Backorder">
                            <cb:ToolTipLabel ID="BackOrderLabel" runat="server" Text="Allow Backorders" ToolTip="When backorder is allowed, this product can continue to be purchased.  When backorder is not allowed, customers cannot purchase the product once it is out of stock."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBox ID="BackOrder" runat="server" />
                        </td>
                        </asp:PlaceHolder>
                    </tr>
                    <tr id="trVariantInventory" runat="server" visible="false" enableviewstate="true">
                        <td>&nbsp;</td>
                        <td colspan="3">
                            <asp:Localize ID="VariantInventoryMessage" runat="server" Text="To manage inventory for variants, click the OPTIONS tab above."></asp:Localize>
                        </td>
                    </tr>
                    <tr id="trProductInventory" runat="server" visible="false" enableviewstate="true">
                        <th>
                            <cb:ToolTipLabel ID="InStockLabel" runat="server" Text="In Stock:" ToolTip="The current quantity in stock."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="InStock" runat="server" width="75px"></asp:TextBox>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="StartDateLabel" runat="server" Text="Availability Date:" ToolTip="The Availability Date will only be displayed when Stock Levels are at 0 and the Allow Backorder setting is disabled."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <uc:PickerAndCalendar ID="AvailabilityDate" runat="server" Visible="false" />
                        </td>
                    </tr>
                    <tr>
                        <asp:PlaceHolder ID="LowStockHolder" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="LowStockLabel" runat="server" Text="Low Stock:" ToolTip="The quantity level at which you will start receiving alerts that the product is low in stock."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="LowStock" runat="server" width="75px"></asp:TextBox>
                        </td>                            
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="RestockNotificationHolder" runat="server" visible="false">
                        <th>
                            <cb:ToolTipLabel ID="EnableRestockNotificationLabel" runat="server" Text="Enable Notifications:" ToolTip="An email subscription option for restock notification will be displayed when product will be out of stock."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBox ID="EnableRestockNotifications" runat="server" />
                        </td>
                        </asp:PlaceHolder>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
        <div class="sectionHeader">
            <h2>Product Descriptions</h2>
        </div>
        <table cellspacing="0" class="inputForm">
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="SummaryLabel" runat="server" Text="Summary:" ToolTip="A brief description of the product that can be used for the category listings or featured products."></cb:ToolTipLabel>
                    <br />
                    <asp:ImageButton ID="SummaryHtmlButton" runat="server" SkinID="HtmlIcon" AlternateText="Edit HTML" />
                </th>
                <td>
                    <cb:HtmlEditor ID="Summary" runat="server" Width="780" Height="200px" ToolbarSet="Inline" MaxLength="1000" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="DescriptionLabel" runat="server" Text="Description:" ToolTip="The description of this product."></cb:ToolTipLabel>
                    <br />
                    <asp:ImageButton ID="DescriptionHtmlButton" runat="server" SkinID="HtmlIcon" AlternateText="Edit HTML" />
                </th>
                <td>
                    <cb:HtmlEditor ID="Description" runat="server" Width="780" Height="200px" ToolbarSet="Inline" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="ExtendedDescriptionLabel" runat="server" Text="More&nbsp;Details:" ToolTip="More details or additional description for this product."></cb:ToolTipLabel>
                    <br />
                    <asp:ImageButton ID="ExtendedDescriptionHtmlButton" runat="server" SkinID="HtmlIcon" AlternateText="Edit HTML" />
                </th>
		        <td>
                    <cb:HtmlEditor ID="ExtendedDescription" runat="server" Width="780" Height="200px" ToolbarSet="Inline" />
		        </td>
            </tr>
        </table>
        <div class="sectionHeader">
            <h2>Advanced Settings</h2>
        </div>
        <table cellspacing="0" class="inputForm">
            <tr>
                <th>
                    <cb:ToolTipLabel ID="VisibilityLabel" runat="server" Text="Visibility:" AssociatedControlID="Visibility" ToolTip="Visibility setting indicates how this product is accessed from the retail side. Public: Published, Hidden: Unpublished (available through direct link), Private: Access Prevented"></cb:ToolTipLabel>
                </th>
                <td width="350px">
                    <asp:DropDownList ID="Visibility" runat="server">
                        <asp:ListItem Value="0" Text="Public"></asp:ListItem>
                        <asp:ListItem Value="1" Text="Hidden"></asp:ListItem>
                        <asp:ListItem Value="2" Text="Private"></asp:ListItem>
                    </asp:DropDownList>
                </td>
		        <td>
                    <asp:CheckBox ID="IsFeatured" runat="server" />
                    <cb:ToolTipLabel ID="IsFeaturedLabel" runat="server" Text="Include Item in Featured List" ToolTip="Indicates whether or not this is a featured product." AssociatedControlID="IsFeatured"></cb:ToolTipLabel>
			    </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="DisplayPageLabel" runat="server" Text="Display Page:" ToolTip="The display page used for this product."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:DropDownList ID="DisplayPage" runat="server" DataSourceID="DisplayPageDs" DataTextField="Name" 
                        DataValueField="Id" AppendDataBoundItems="true">
                        <asp:ListItem Text="Use store default" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:ObjectDataSource ID="DisplayPageDs" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="LoadForWebpageType" TypeName="CommerceBuilder.Catalog.WebpageDataSource">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="ProductDisplay" Name="webpageType" Type="Object" />
                            <asp:Parameter DefaultValue="Name" Name="sortExpression" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </td>
		        <td>
			        <asp:CheckBox ID="HidePrice" runat="server" />
		            <cb:ToolTipLabel ID="HidePriceLabel" runat="server" Text="Require user to click link to view price" ToolTip="When checked, the price of this item is not shown when browsing categories or products.  The customer must click a link (or add to basket) to see the price." AssociatedControlID="HidePrice"></cb:ToolTipLabel>
			    </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="GiftWrapLabel" runat="server" Text="Gift Wrap:" ToolTip="The gift wrap group that specifies which wrapping options are available for this product."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:DropDownList ID="WrapGroup" runat="server" DataSourceID="GiftWrapDs" DataTextField="Name"
                        DataValueField="WrapGroupId" AppendDataBoundItems="true">
                        <asp:ListItem Value="" Text=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:ObjectDataSource ID="GiftWrapDs" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="LoadAll" TypeName="CommerceBuilder.Products.WrapGroupDataSource">
                    </asp:ObjectDataSource>
                </td>
		        <td>
			        <asp:CheckBox ID="IsProhibited" runat="server" />
                    <cb:ToolTipLabel ID="IsProhibitedLabel" runat="server" Text="Item is prohibited by PayPal Express Checkout" ToolTip="When checked, the purchase of this item is prohibited with PayPal Express Checkout."></cb:ToolTipLabel>
		        </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="GroupRestrictionsLabel" runat="server" Text="Group Restrictions:" ToolTip="Groups that have access to this product."></cb:ToolTipLabel>
                </th>
                <td rowspan="4">
                    <asp:DropDownList ID="EnableGroups" runat="server">
                        <asp:ListItem Text="Enabled" Value="true"></asp:ListItem>
                        <asp:ListItem Text="Disabled" Value="false" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                    <p><asp:ListBox ID="ProductGroups" runat="server" SelectionMode="Multiple" Height="100px" Width="250px" DataSourceID="ProductGroupsDS" DataTextField="Name" DataValueField="GroupId"></asp:ListBox></p>
                    <asp:ObjectDataSource ID="ProductGroupsDS" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="LoadNonAdminGroups" TypeName="CommerceBuilder.Users.GroupDataSource">
                    </asp:ObjectDataSource>
                </td>
                <td>
                    <asp:CheckBox ID="DisablePurchase" runat="server" />
                    <cb:ToolTipLabel ID="DisablePurchaseLabel" runat="server" Text="Disable item from all purchases" ToolTip="When purchase is disabled for a product, the display pages will not show a buy button for that product and it cannot be added to the basket." AssociatedControlID="DisablePurchase"></cb:ToolTipLabel>
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
                <td>
                    <asp:CheckBox ID="GiftCertificate" runat="server" />
                    <cb:ToolTipLabel ID="GiftCertificateLabel" runat="server" Text="Create a gift certificate with purchase" ToolTip="When checked, the purchase of this item creates a gift certificate for the purchase amount of the product." AssociatedControlID="GiftCertificate"></cb:ToolTipLabel>
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
                <td>
                    <asp:PlaceHolder ID="AllowReviewsPanel" runat="server">
			            <asp:CheckBox ID="AllowReviews" runat="server" Checked="true" />
                        <cb:ToolTipLabel ID="AllowReviewsLabel" runat="server" Text="Allow customers to review this product" ToolTip="When checked, customer reviews will be allowed for this product. If you don't want to allow customers to place reviews for this product simply uncheck it."></cb:ToolTipLabel>
                    </asp:PlaceHolder>
		        </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
                <td>
                    <asp:UpdatePanel ID="VariablePriceAjax" runat="server">
                        <ContentTemplate>
                            <asp:CheckBox ID="UseVariablePrice" runat="server" AutoPostBack="true" />
                            <asp:Localize ID="UseVariablePriceLabel" runat="server" Text="Allow user to enter a price between "></asp:Localize>
                            <asp:TextBox ID="MinPrice" runat="server" Width="40px" MaxLength="10" ></asp:TextBox>
                            <asp:RangeValidator ID="MinPriceValidator" runat="server" ControlToValidate="MinPrice"
                                ErrorMessage="Minimum Price should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                                MinimumValue="0" Type="Currency" Display="Dynamic">*</asp:RangeValidator>
                            &nbsp;and&nbsp;
                            <asp:TextBox ID="MaxPrice" runat="server" Width="40px" MaxLength="10"></asp:TextBox>
                            <asp:RangeValidator ID="MaxPriceValidator" runat="server" ControlToValidate="MaxPrice"
                                ErrorMessage="Maximum Price should fall between 0.00 and 99999999.99" MaximumValue="99999999.99"
                                MinimumValue="0" Type="Currency" Display="Dynamic">*</asp:RangeValidator>
                            <cb:ToolTipLabel ID="UseVariablePriceToolTip" runat="server" Text="." ToolTip="When this option is checked you can allow the customer to specify the price of the product within the given range."></cb:ToolTipLabel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
                <td>
                    <asp:Localize ID="MinQuantityLabel" runat="server" Text="Require purchase quantity between "></asp:Localize>
                    <asp:TextBox ID="MinQuantity" runat="server" Columns="4" MaxLength="10"></asp:TextBox>
                    &nbsp;and&nbsp;
                    <asp:TextBox ID="MaxQuantity" runat="server" Columns="4" MaxLength="10"></asp:TextBox>
                    <cb:ToolTipLabel ID="QuantityRangeToolTip" runat="server" Text="." ToolTip="You can specify the minimum and maximum quantity of this product that must/can be purchased."></cb:ToolTipLabel>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="SearchKeywordsLabel" runat="server" Text="Search Keywords:" ToolTip="Enter the data like keywords and frequent misspellings. It will always be searched on the retail site."></cb:ToolTipLabel>
                </th>
                <td colspan="3">
                    <asp:TextBox ID="SearchKeywords" runat="server" Text="" TextMode="multiLine" Rows="5" Width="750"></asp:TextBox><br />
                </td>
            </tr>
        </table>
        <div class="sectionHeader">
            <h2>Search Engines</h2>
        </div>
        <asp:UpdatePanel ID="PublishOptionsAjax" runat="server">
        <ContentTemplate>
        <table cellspacing="0" class="inputForm">
	        <tr>
		        <th valign="top">
		            <cb:ToolTipLabel ID="CustomUrlLabel" runat="server" Text="Custom Url:" ToolTip="You can provide a custom URL to access your product. This URL will override the default one generated by system. The value provided should be a URL relative to the store directory. Absolute URLs are not supported. "></cb:ToolTipLabel>
	            </th>
		        <td valign="top" colspan="3">
		            <asp:TextBox ID="CustomUrl" runat="server" Width="500" MaxLength="150"></asp:TextBox>
                    <cb:CustomUrlValidator ID="CustomUrlValidator" runat="server" ControlToValidate="CustomUrl" 
                        Text="*" FormatErrorMessage="The custom url has an invalid format."
                        DuplicateErrorMessage="This custom url is already used, please choose a unique value." ViewStateMode="Enabled"></cb:CustomUrlValidator><br />
                    <asp:Localize ID="CustomUrlExample" runat="server" Text="e.g. Fiction/Mystery/The-Confession.aspx"></asp:Localize>
		        </td>
	        </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="TitleLabel" runat="server" Text="Page Title:" CssClass="toolTip" ToolTip="Page title of the product. If not provided name will be used as page title."></cb:ToolTipLabel>
                </th>
                <td colspan="3">
                    <asp:TextBox ID="ProductTitle" runat="server" Text="" Width="500" MaxLength="100"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="MetaDescriptionLabel" runat="server" Text="Meta Description:" ToolTip="Enter a description for this page for the META tag.  Some search engines will use this as the summary for your page. You do not need to enter any HTML meta tags - only enter the content you want to set in them.">
                    </cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="MetaDescriptionValue" runat="server" Text="" TextMode="multiLine"
                        Rows="3" Columns="50" Width="300" MaxLength="300"></asp:TextBox><br />
                    <asp:Label ID="MetaDescriptionCharCount" runat="server" Text="150"></asp:Label>
                    <asp:Label ID="MetaDescriptionCharCountLabel" runat="server" Text="characters remaining"></asp:Label>
                </td>
                <th valign="top">
                    <cb:ToolTipLabel ID="MetaKeywordsLabel" runat="server" Text="Meta Keywords:" ToolTip="Enter the keywords that describe your page for the META tag.  Enter single words separated by a comma, with a maxium of 1000 characters. You do not need to enter any HTML meta tags - only enter the content you want to set in them.">
                    </cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="MetaKeywordsValue" runat="server" Text="" TextMode="multiLine" Rows="3"
                        Columns="50" Width="300" MaxLength="1000"></asp:TextBox><br />
                    <asp:Label ID="MetaKeywordsCharCount" runat="server" Text="1000"></asp:Label>
                    <asp:Label ID="MetaKeywordsCharCountLabel" runat="server" Text="characters remaining"></asp:Label>
                </td>
            </tr>
            <tr>
				<th valign="top">
                    <cb:ToolTipLabel ID="HtmlHeadLabel" runat="server" Text="HTML Head:" ToolTip="Use this field for entring your custom data for HTML HEAD portion."></cb:ToolTipLabel>
                </th>
                <td colspan="3">
                    <asp:TextBox ID="HtmlHead" runat="server" Text="" TextMode="multiLine" Rows="5" Columns="120" Width="750"></asp:TextBox>
                </td>
            </tr>
        </table>
        <div class="sectionHeader">
            <h2>Product Feeds</h2>
        </div>
        <table cellspacing="0" class="inputForm">
            <tr>
                <th>
                    <cb:ToolTipLabel ID="IncludeInFeedLabel" runat="server" Text="Include in Feed:" ToolTip="Indicates that this product should be included in any generated shopping feeds.  Uncheck this box to exclude this product from feeds." AssociatedControlID="IncludeInFeed"></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:CheckBox ID="IncludeInFeed" runat="server" Checked="true" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="GoogleCategoryLabel" runat="server" Text="Google Category:" ToolTip="If using Google Feed, select the appropriate category for this product." />
                </th>
                <td valign="top" colspan="3">
                    <asp:TextBox ID="GoogleCategory" runat="server" Text="" Width="700" MaxLength="150"></asp:TextBox>
                    <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" 
                                TargetControlID="GoogleCategory" ServicePath="~/Admin/Products/EditProduct.aspx" ServiceMethod="GetGoogleCategories" MinimumPrefixLength="3"
                                UseContextKey="True" CompletionListCssClass="autoCompleteList" ></ajaxToolkit:AutoCompleteExtender>
                    <br />
                    <asp:HyperLink ID="GoogleTaxonomy" runat="server" Text="product taxonomy" Target="_blank" NavigateUrl="http://support.google.com/merchants/bin/answer.py?hl=en&answer=1705911"></asp:HyperLink>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="PublishAsVariantsLabel" runat="server" Text="Publish Feed as Variants:" ToolTip="Indicates that this product should be published in google feed as a single product or as multiple variants. Google define variants as a group of identical products that only differ by the attributes ‘color’, ‘material’, ‘pattern’, or ‘size’. You can specify these attributes as options/variants and mark this checkbox to generate feed accordingly." AssociatedControlID="PublishAsVariants"></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:CheckBox ID="PublishAsVariants" runat="server" Checked="false" AutoPostBack="true" OnCheckedChanged="PublishAsVariants_CheckChanged" />
                </td>
                <th valign="top">
                    <cb:ToolTipLabel ID="ConditionLabel" runat="server" Text="Condition:" ToolTip="Describe the condition of the product." AssociatedControlID="Condition" />
                </th>
                <td valign="top">
                    <asp:DropDownList ID="Condition" runat="server">
                        <asp:ListItem Text="New"></asp:ListItem>
                        <asp:ListItem Text="Used"></asp:ListItem>
                        <asp:ListItem Text="Refurbished"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr id="GoogleFeedOptionsRow" runat="server">
                <th>
                    <cb:ToolTipLabel ID="ColorLabel" runat="server" Text="Color:" ToolTip="Provide the color description of the item - this is required for Google Feed to list apparel items." AssociatedControlID="Color" />
                </th>
                <td>
                    <asp:TextBox ID="Color" runat="server"></asp:TextBox>
                </td>
                <th>
                    <cb:ToolTipLabel ID="SizeLabel" runat="server" Text="Size:" ToolTip="Provide the size description of the item - this is required for Google Feed to list clothing or shoes." AssociatedControlID="Size" />
                </th>
                <td>
                    <asp:TextBox ID="Size" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="GenderLabel" runat="server" Text="Gender:" ToolTip="If the product has a specific gender associated you can specify it here.  This usually applies only to clothing items." AssociatedControlID="Gender" />
                </th>
                <td>
                    <asp:DropDownList ID="Gender" runat="server">
                        <asp:ListItem Text="Unisex"></asp:ListItem>
                        <asp:ListItem Text="Male"></asp:ListItem>
                        <asp:ListItem Text="Female"></asp:ListItem>
                    </asp:DropDownList>
                </td>
                <th>
                    <cb:ToolTipLabel ID="AgeGroupLabel" runat="server" Text="Age Group:" ToolTip="If the product is associated with a specific age group you can specify it here.  This usually applies only to clothing items." AssociatedControlID="AgeGroup" />
                </th>
                <td>
                    <asp:DropDownList ID="AgeGroup" runat="server">
                        <asp:ListItem Text=""></asp:ListItem>
                        <asp:ListItem Text="Adult"></asp:ListItem>
                        <asp:ListItem Text="Kids"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="AdwordsGroupingLabel" runat="server" Text="Adwords Grouping:" ToolTip="Used to group products in an arbitrary way. It can be used for Product Filters to limit a campaign to a group of products, or Product Targets to bid differently for a group of products. This is a required field if the advertiser wants to bid differently to different subsets of products in the CPC or CPA % version. It can only hold one value." AssociatedControlID="AdwordsGrouping" />
                </th>
                <td>
                    <asp:TextBox ID="AdwordsGrouping" runat="server"></asp:TextBox>
                </td>
                <th>
                    <cb:ToolTipLabel ID="AdwordsLabelsLabel" runat="server" Text="Adwords Labels:" ToolTip="Very similar to adwords_grouping, but it will only only work on CPC. It can hold multiple values, allowing a product to be tagged with multiple labels." AssociatedControlID="AdwordsLabels" />
                </th>
                <td>
                    <asp:TextBox ID="AdwordsLabels" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="ExcludedDestinationLabel" runat="server" Text="Excluded Destination:" ToolTip="Specify a value if you are using either Google Shopping or Commerce Search and you would like to exclude the item from either of these destinations." AssociatedControlID="ExcludedDestination" />
                </th>
                <td>
                    <asp:DropDownList ID="ExcludedDestination" runat="server" >
                        <asp:ListItem Text="" Value="" Selected="True" />
                        <asp:ListItem Text="Shopping" Value="Shopping" />
                        <asp:ListItem Text="Commerce Search" Value="Commerce Search" />
                    </asp:DropDownList>
                </td>
                <th>
                    <cb:ToolTipLabel ID="AdwordsRedirectLabel" runat="server" Text="Adwords Redirect:" ToolTip="Allows advertisers to override the product URL when the product is shown within the context of Product Ads. This allows advertisers to track different sources of traffic separately from Google Shopping." AssociatedControlID="AdwordsRedirect" />
                </th>
                <td>
                    <asp:TextBox ID="AdwordsRedirect" runat="server"></asp:TextBox>
                </td>
            </tr>
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>
        <br />
         <div class="links">
            <asp:Button ID="SaveButton2" runat="server" Text="Save and Edit" SkinID="SaveButton" OnClick="SaveButton_Click"></asp:Button>
            <asp:Button ID="SaveAndCloseButton2" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveButton_Click"></asp:Button>
            <asp:HyperLink ID="CancelButton2" runat="server" Text="Cancel" SkinID="CancelButton" ViewStateMode="Enabled"></asp:HyperLink>
         </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=EnableGroups.ClientID %>').change(function () {
                var selectedVal = $(this).val();
                if (selectedVal === 'false') {
                    $('#<%=ProductGroups.ClientID %>').attr('disabled', 'true');
                } else {
                    $('#<%=ProductGroups.ClientID %>').removeAttr('disabled');
                }
            });

            // update the TIC field value
            $(document).submit(function (event) {
                $('#<%=HiddenTIC.ClientID %>').val($('#<%=TIC.ClientID %>').val());
            });
        });

        function addManufacturer() {
            var name = prompt("New manufacturer name?", "");
            if ((name == null) || (name.length == 0)) return false;
            var c = document.getElementById('<%= NewManufacturerName.ClientID %>');
            if (c == null) return false;
            c.value = name;
            return true;
        }

        //currentTic must be declared/set, even if TIC has not already been specified.
        var currentTic = "<%=HiddenTIC.Value %>";

        //the ID of the HTML form field to be replaced
        var fieldID = "<%=TIC.ClientID %>";

        function intTICSelect() {
            (function () {
                var tcJsHost = (("https:" == document.location.protocol) ? "https:" : "http:");
                var ts = document.createElement('script');
                ts.type = 'text/javascript';
                ts.async = true;
                ts.src = tcJsHost + '//taxcloud.net/jquery.tic2.public.js';
                var t = document.getElementsByTagName('script')[0];
                t.parentNode.insertBefore(ts, t);
            })();
        }

    </script>
</asp:Content>