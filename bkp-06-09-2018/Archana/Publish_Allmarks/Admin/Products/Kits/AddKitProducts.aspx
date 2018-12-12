<%@ Page Language="C#" MasterPageFile="../Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Kits.AddKitProducts" Title="Add Products to Kit" CodeFile="AddKitProducts.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Add Products to '{0}'" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
    <asp:UpdatePanel id="PageAjax" runat="server">
        <ContentTemplate>
            <asp:Panel ID="SearchForm" runat="Server" DefaultButton="SearchButton" CssClass="searchPanel">
                <p><asp:Localize ID="InstructionText" runat="server" Text="Search for the products to add to the component <b>{0}</b> in {1}:" EnableViewState="false"></asp:Localize></p>
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="NameFilterLabel" runat="server" Text="Name:" AssociatedControlID="NameFilter" ToolTip="Enter all or part of a product name to search for.  You can use the * and ? wildcards."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="NameFilter" runat="server" MaxLength="50" Width="100px"></asp:TextBox>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="SkuFilterLabel" runat="server" Text="Sku:" AssociatedControlID="SkuFilter" ToolTip="Enter all or part of a product SKU to search for.  You can use the * and ? wildcards."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="SkuFilter" runat="server" MaxLength="50" Width="100px"></asp:TextBox>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="ManufacturerFilterLabel" runat="server" Text="Manufacturer:" AssociatedControlID="ManufacturerFilter" ToolTip="Select the manufacturer to limit your search."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="ManufacturerFilter" runat="server" AppendDataBoundItems="True" DataTextField="Name" DataValueField="ManufacturerId" EnableViewState="false" Width="160px">
                                <asp:ListItem Text="- Any Manufacturer -" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="VendorFilterLabel" runat="server" Text="Vendor:" AssociatedControlID="VendorFilter" ToolTip="Select the vendor to limit your search."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="VendorFilter" runat="server" AppendDataBoundItems="True" DataTextField="Name" DataValueField="VendorId" EnableViewState="false" Width="160px">
                                <asp:ListItem Text="- Any Vendor -" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr> 
                        <th>
                            <cb:ToolTipLabel ID="CategoryFilterLabel" runat="server" Text="Category:" AssociatedControlID="CategoryFilter" ToolTip="Select the category to limit your search."></cb:ToolTipLabel>
                        </th>
                        <td colspan="3">
                            <asp:DropDownList ID="CategoryFilter" runat="server" AppendDataBoundItems="True" DataTextField="Name" DataValueField="CategoryId" EnableViewState="false">
                                <asp:ListItem Text="- Any Category -" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="CategoryAutoComplete" runat="server" ClientIDMode="Static" Visible="false" AutoCompleteType="Disabled"/>
                            <asp:HiddenField ID="HiddenSelectedCategoryId" runat="server" ClientIDMode="Static" />
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="GroupLabel" runat="server" Text="Group:" ToolTip="Search products with the selected group." />
                        </th>
                        <td colspan="5">
                            <asp:DropDownList ID="ProductGroups" runat="server" AppendDataBoundItems="true" DataTextField="Name" DataValueField="GroupId" DataSourceID="ProductGroupsDS" Width="216px">
                                <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="ProductGroupsDS" runat="server" OldValuesParameterFormatString="original_{0}"
                                SelectMethod="LoadNonAdminGroups" TypeName="CommerceBuilder.Users.GroupDataSource">
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td colspan="7">
                            <asp:Button ID="SearchButton" runat="server" Text="Search" SkinID="Button" OnClick="SearchButton_Click" OnClientClick="this.value='searching'" Width="70px" />&nbsp;
                            <asp:Button ID="ResetButton" runat="server" Text="Reset" SkinID="CancelButton" OnClick="ResetButton_Click" />
                            <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="EditKit.aspx" SkinID="CancelButton"></asp:HyperLink>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="SearchPanel" runat="server" CssClass="content">
                <cb:AbleGridView ID="ProductSearchResults" runat="server" AutoGenerateColumns="False" DataSourceId="ProductDs" DataKeyNames="ProductId" 
                    Width="100%" SkinID="PagedList" AllowPaging="true" PageSize="10" AllowSorting="true" Visible="false">
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="SelectAll" runat="server" onclick="ToggleCheckboxes(this)" />
                            </HeaderTemplate>
                            <ItemStyle HorizontalAlign="center" Width="60px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="Selected" runat="server" Visible='<%# IsNotKit(Container.DataItem) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Sku" HeaderText="Sku" SortExpression="Sku">
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Visibility">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#Eval("Visibility")%>
                            </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Groups">
                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                        <ItemTemplate>
                            <asp:Label ID="GroupLabel" runat="server" Text='<%#GetGroups(Container.DataItem) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Localize ID="EmptyMessage" runat="server" Text="- no matching products -"></asp:Localize>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
                <asp:Button ID="AddProductsButton" runat="server" Text="Add Selected Products" SkinID="SaveButton" Visible="false" OnClick="AddProductsButton_Click" />
                <asp:ObjectDataSource ID="ProductDs" runat="server"  DataObjectTypeName="CommerceBuilder.Products.Product"  
                    OldValuesParameterFormatString="original_{0}" SelectMethod="FindProducts" SelectCountMethod="FindProductsCount"
                    TypeName="CommerceBuilder.Products.ProductDataSource" SortParameterName="sortExpression" EnablePaging="true" OnSelecting="ProductDs_Selecting">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="NameFilter" Name="name" PropertyName="Text" Type="String" />
                        <asp:Parameter DefaultValue="False" Name="searchDescription" Type="Boolean" />
                        <asp:ControlParameter Name="sku" Type="String" ControlID="SkuFilter" PropertyName="Text" />
                        <asp:ControlParameter Name="categoryId" Type="Int32" ControlID="CategoryFilter" PropertyName="SelectedValue" />
                        <asp:ControlParameter Name="manufacturerId" Type="Int32" ControlID="ManufacturerFilter" PropertyName="SelectedValue" />
                        <asp:ControlParameter Name="vendorId" Type="Int32" ControlID="VendorFilter" PropertyName="SelectedValue" />
                        <asp:Parameter Name="featured" Type="Object" />
                        <asp:Parameter DefaultValue="0" Name="taxCodeId" Type="Int32" />
                        <asp:Parameter Name="lowPrice" Type="Decimal" />
                        <asp:Parameter Name="highPrice" Type="Decimal" />
                        <asp:Parameter DefaultValue="False" Name="digitalGoodsOnly" Type="Boolean" />
                        <asp:Parameter DefaultValue="False" Name="giftCertificatesOnly" Type="Boolean" />
                        <asp:Parameter DefaultValue="False" Name="kitsOnly" Type="Boolean" />
                        <asp:Parameter DefaultValue="False" Name="subscriptionsOnly" Type="Boolean" />
                        <asp:ControlParameter ControlID="ProductGroups" DefaultValue="0" Name="groupId" PropertyName="SelectedValue" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </asp:Panel>
            <asp:Panel ID="ConfigurePanel" runat="server" CssClass="section" Visible="false">
                <div class="header">
                    <h2>Add Selected Product(s)</h2>
                </div>
                <div class="content">
                    <p>You may override the default product settings for name, price, weight, or quantity.  Any changes made here will apply to this kit component only.</p>
                    <asp:Repeater ID="SelectedProductRepeater" runat="server" OnItemDataBound="SelectedProductRepeater_ItemDataBound">
                        <ItemTemplate>
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <asp:Label ID="SelectedProductNameLabel" runat="server" Text="Product:"></asp:Label>
                                    </th>
                                    <td>
                                        <%# Eval("Name") %>
                                        <asp:HiddenField ID="PID" runat="server" value='<%#Eval("ProductId")%>' />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="NameFormatLabel" runat="server" Text="Display Name:" AssociatedControlID="NameFormat" ToolTip="Enter the display name for the kit product.  This is how the item will be shown on the customer invoice.  You can use the following string tokens: $name, $options, $quantity, $price."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="NameFormat" runat="server" Width="300px" MaxLength="255" Text='<%# GetNameFormat(Container.DataItem) %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="KitQuantityLabel" runat="server" Text="Quantity:" AssociatedControlID="KitQuantity" ToolTip="The quantity of this product to include in the kit."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="KitQuantity" runat="server" Columns="2" MaxLength="3" Text="1"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ProductPriceLabel" runat="server" Text="Product Price:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:Literal ID="ProductPrice" runat="server" Text='<%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>'></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="PriceLabel" runat="server" Text="Kit Price:"></asp:Label>
                                    </th>
                                    <td valign="top">
                                        <asp:DropDownList ID="PriceMode" runat="server" AutoPostBack="true" OnSelectedIndexChanged="PriceMode_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Use Product Price" Selected="true"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Modify Product Price"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Fixed Price"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="trPrice" runat="server" visible="false">
                                    <th>
                                        <asp:Label ID="ModifyPriceLabel" runat="server" text="Price Modifier: " SkinID="FieldHeader" Visible="false"></asp:Label>
                                        <asp:Label ID="FixedPriceLabel" runat="server" text="Fixed Price: " SkinID="FieldHeader" Visible="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Price" runat="server" Columns="4" MaxLength="8" /><br />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ProductWeightLabel" runat="server" Text="Product Weight:"></asp:Label>
                                    </th>
                                    <td>
                                        <%# Eval("Weight", "{0:F2}") %>
						                <%# AbleContext.Current.Store.WeightUnit.ToString() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="WeightLabel" runat="server" Text="Kit Weight:"></asp:Label>
                                    </th>
                                    <td valign="top">
                                        <asp:DropDownList ID="WeightMode" runat="server" AutoPostBack="true" OnSelectedIndexChanged="WeightMode_SelectedIndexChanged">
                                            <asp:ListItem Value="0" Text="Use Product Weight" Selected="true"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Modify Product Weight"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Fixed Weight"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="trWeight" runat="server" visible="false">
                                    <th>
                                        <asp:Label ID="ModifyWeightLabel" runat="server" text="Weight Modifier: " SkinID="FieldHeader" Visible="false"></asp:Label>
                                        <asp:Label ID="FixedWeightLabel" runat="server" text="Fixed Weight: " SkinID="FieldHeader" Visible="false"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Weight" runat="server" Columns="4" MaxLength="8" /><br />
                                    </td>
                                </tr>
                                <tr id="trOptionWarning" runat="server" visible="false">
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Label ID="OptionWarning" runat="server" SkinID="ErrorCondition" Text="You must select the options:" EnableViewState="false"></asp:Label>
                                    </td>
                                </tr>
                                <asp:PlaceHolder ID="phOptions" runat="server"></asp:PlaceHolder>
                                <tr id="trInvalidVariant" runat="server" visible="false" enableviewstate="false">
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Localize ID="InvalidVariantWarning" runat="server" Text="<i>NOTE: The variant you have selected is marked as unavailable.</i>" EnableViewState="false"></asp:Localize>
                                    </td>
                                </tr>
                                <tr id="trSelected" runat="server" visible='<%# IsNotHiddenPart(Container.DataItem) %>'>
                                    <th>
                                        <asp:Label ID="IsSelectedLabel" runat="server" Text="Selected:"></asp:Label>
                                    </th>
                                    <td valign="top">
                                        <asp:CheckBox ID="IsSelected" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <SeparatorTemplate>
                            <hr />
                        </SeparatorTemplate>
                    </asp:Repeater><hr />
                    <asp:Button ID="FinishButton" runat="server" Text="Save and Add Product(s)" OnClick="FinishButton_Click" />
                </div>
            </asp:Panel>
            <asp:HiddenField ID="VS" runat="server" EnableViewState="false" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript">
        function ToggleCheckbox(id, checkState) {
            var cb = document.getElementById(id);
            if (cb != null) cb.checked = checkState;
        }

        function ToggleCheckboxes(sender) {
            if (CheckBoxIDs != null) {
                for (var i = 0; i < CheckBoxIDs.length; i++)
                    ToggleCheckbox(CheckBoxIDs[i], sender.checked);
            }
            return true;
        }
    </script>
</asp:Content>