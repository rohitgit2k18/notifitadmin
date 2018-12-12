<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Methods.EditShipMethodMatrix" Title="Edit Ship Method"  CodeFile="EditShipMethodMatrix.aspx.cs" AutoEventWireup="True" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
	            <div class="caption">
		            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Variable Method '{0}'" EnableViewState="false"></asp:Localize></h1>
	            </div>
            </div>
            <div class="grid_6 alpha">
                <div class="mainColumn">
                    <div class="section">
                        <div class="header">
                            <h2>Configuration</h2>
                        </div>
                        <div class="content">
                        <cb:Notification ID="SavedMessage" runat="server" Text="Ship Method updated at {0:t}" SkinID="GoodCondition" Visible="false"></cb:Notification>
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipMethodTypeLabel" runat="server" Text="Type:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:Label ID="ShipMethodType" runat="server" Text=""></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" ToolTip="The name of this shipping method as it appears to the merchant and the customer." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="Name" runat="server" Width="175px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:RequiredFieldValidator ID="NameRequired" runat="server" ControlToValidate="Name"
                                                Display="Static" ErrorMessage="Ship method name is required.">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="TaxCodeLabel" runat="server" Text="Shipping Tax Code:" ToolTip="If you wish to create tax rules for this shipping method, choose the tax code that should be assigned to calculated charges.  You can then configure the tax rules for this code." AssociatedControlID="TaxCode" EnableViewState="false" />
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="TaxCode" runat="server" AppendDataBoundItems="true" DataTextField="Name" DataValueField="TaxCodeId" EnableViewState="false">
                                            <asp:ListItem Text=""></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="SurchargeLabel" runat="server" Text="Handling Fee:" ToolTip="Specify a surcharge or handling fee that is associated with this method.  You can set surcharges as a fixed amount or a percentage of the shipping charge.  You can also choose to include the surcharge in the total shipping rate or display as a separate line item in the order." />
                                    </th>
                                    <td valign="top">
                                        <asp:TextBox ID="Surcharge" runat="server" Columns="8" MaxLength="11"></asp:TextBox>
                                        <asp:RangeValidator ID="SurchargeValidator" runat="server" Text="*" Type="currency" ErrorMessage="Handling Fee value should be between 0.00 and 99999999.99" ControlToValidate="Surcharge" MinimumValue="0" MaximumValue="99999999.99" ></asp:RangeValidator>
                                        <asp:DropDownList ID="SurchargeMode" runat="server">
                                            <asp:ListItem Value="0" Text="Fixed Amount"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Percent (%) of Shipping Charge"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Percent (%) of Shipment Total"></asp:ListItem>
                                        </asp:DropDownList>
                                        <br />
                                        <asp:RadioButtonList ID="SurchargeIsVisible" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="SurchargeIsVisible_SelectedIndexChanged">
                                            <asp:ListItem Text="Include in shipping cost"></asp:ListItem>
                                            <asp:ListItem Text="Show separately"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>
                                <tr id="trSurchargeTaxCode" runat="server" visible="false">
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="SurchargeTaxCodeLabel" runat="server" Text="Handling Tax Code:" ToolTip="If you wish to create tax rules for surcharge or handling fee of this shipping method, choose the tax code that should be assigned to calculated surcharge/handling fee charges.  You can then configure the tax rules for this code." AssociatedControlID="SurchargeTaxCode" EnableViewState="false" />
                                    </th>
                                    <td valign="top">
                                        <asp:DropDownList ID="SurchargeTaxCode" runat="server" AppendDataBoundItems="true" DataTextField="Name" DataValueField="TaxCodeId" EnableViewState="false">
                                            <asp:ListItem Text=""></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="WarehousesLabel" runat="server" Text="Warehouses:" ToolTip="Indicate whether this shipping method is available for products in all warehouses, or if it is limited to specific warehouses." />
                                    </th>
                                    <td valign="top">
                                        <asp:UpdatePanel ID="WarehouseRestrictionAjax" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:RadioButtonList ID="UseWarehouseRestriction" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UseWarehouseRestriction_SelectedIndexChanged">
                                                    <asp:ListItem Text="All Warehouses" Selected="true"></asp:ListItem>
                                                    <asp:ListItem Text="Selected Warehouses"></asp:ListItem>
                                                </asp:RadioButtonList>
                                                <asp:Panel ID="WarehouseListPanel" runat="server" Visible="false">
                                                    <div style="padding-left:20px">
                                                        <asp:ListBox ID="WarehouseList" runat="server" SelectionMode="multiple" Rows="4" DataTextField="Name" DataValueField="WarehouseId"></asp:ListBox>
                                                    </div>
                                                </asp:Panel>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="ZonesLabel" runat="server" Text="Zones:" ToolTip="Indicate whether this shipping method is available to all zones, or if it is limited to specific zones." />
                                    </th>
                                    <td valign="top">
                                        <asp:UpdatePanel ID="ZoneRestrictionAjax" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:RadioButtonList ID="UseZoneRestriction" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UseZoneRestriction_SelectedIndexChanged">
                                                    <asp:ListItem Text="All Zones" Selected="true"></asp:ListItem>
                                                    <asp:ListItem Text="Selected Zones"></asp:ListItem>
                                                </asp:RadioButtonList>
                                                <asp:Panel ID="ZoneListPanel" runat="server" Visible="false">
                                                    <div style="padding-left:20px">
                                                        <asp:ListBox ID="ZoneList" runat="server" SelectionMode="multiple" Rows="4" DataTextField="Name" DataValueField="ShipZoneId"></asp:ListBox>
                                                    </div>
                                                </asp:Panel>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="GroupsLabel" runat="server" Text="Groups:" ToolTip="Indicate whether only users that belong to specific groups can use this shipping method." />
                                    </th>
                                    <td>
                                        <asp:UpdatePanel ID="GroupRestrictionAjax" runat="server" UpdateMode="conditional">
                                            <ContentTemplate>
                                                <asp:RadioButtonList ID="UseGroupRestriction" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UseGroupRestriction_SelectedIndexChanged">
                                                    <asp:ListItem Text="All Groups" Selected="true"></asp:ListItem>
                                                    <asp:ListItem Text="Selected Groups"></asp:ListItem>
                                                </asp:RadioButtonList>
                                                <asp:Panel ID="GroupListPanel" runat="server" Visible="false">
                                                    <div style="padding-left:20px">
                                                        <asp:CheckBoxList ID="GroupList" runat="server" DataTextField="Name" DataValueField="GroupId"></asp:CheckBoxList>
                                                    </div>
                                                </asp:Panel>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="MinPurchaseLabel" runat="server" Text="Minimum Purchase:" ToolTip="The minimum purchase value of a shipment required for this method to be valid." />
                                    </th>
                                    <td valign="top">
                                        <asp:TextBox ID="MinPurchase" runat="server" MaxLength="8" Width="60px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top">
                                        <cb:ToolTipLabel ID="MaxPurchaseLabel" runat="server" Text="Maximum Purchase:" ToolTip="Enter the maximum amount of the order for the shipping method to be valid." />
                                    </th>
                                    <td valign="top">
                                        <asp:TextBox ID="MaxPurchase" runat="server" MaxLength="8" Width="60px"></asp:TextBox>
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
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2>Shipping Charge</h2>
                        </div>
                        <div class="content">
                            <p><asp:Label ID="RateMatrixHelpText" runat="Server" Text="Use the table to configure the ship rate by range of <b>{0}</b>.  Enter the minimum and maximum values for the range, and the rate to charge when the value for a shipment falls within the range.  Rates can either be fixed or calculated as a percentage.  Be careful not to overlap your ranges, otherwise you cannot be sure which rate will be applied when calculating charges." EnableViewState="false"></asp:Label></p>
                            <asp:UpdatePanel ID="RateMatrixAjax" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:GridView ID="RateMatrixGrid" runat="server" AutoGenerateColumns="False" 
                                        DataKeyNames="ShipRateMatrixId" OnRowDeleting="RateMatrixGrid_RowDeleting" 
                                        SkinID="PagedList" Width="100%">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Min">
                                                <ItemStyle HorizontalAlign="Center" />
                                                <ItemTemplate>
                                                    <asp:TextBox ID="RangeStart" runat="server" Text='<%# Eval("RangeStart", "{0:#.##;(#.##);}") %>' Columns="4" MaxLength="11"></asp:TextBox>
                                                    <asp:RangeValidator ID="RangeStartValidator" runat="server" Text="*" Type="currency" ErrorMessage="Minimum value should be between 0.00 and 99999999.99" ControlToValidate="RangeStart" MinimumValue="0" MaximumValue="99999999.99" >
                                                    </asp:RangeValidator>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Max">
                                                <ItemStyle HorizontalAlign="Center" />
                                                <ItemTemplate>
                                                    <asp:TextBox ID="RangeEnd" runat="server" Text='<%# Eval("RangeEnd", "{0:#.##;(#.##);}") %>' Columns="4" MaxLength="11"></asp:TextBox>
                                                    <asp:RangeValidator ID="RangeEndValidator" runat="server" Text="*" Type="currency" ErrorMessage="Maximum value should be between 0.00 and 99999999.99" ControlToValidate="RangeEnd" MinimumValue="0" MaximumValue="99999999.99" ></asp:RangeValidator>
                                                    <asp:CompareValidator ID="MinMaxCompareValidator" runat="server" Text="*"  ControlToValidate="RangeEnd" ControlToCompare="RangeStart" 
                                                        ErrorMessage="Maximum value can not be less then minimum value" Operator="GreaterThanEqual" Type="currency"></asp:CompareValidator>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Rate">
                                                <ItemStyle HorizontalAlign="Center" />
                                                <ItemTemplate>
                                                    <asp:TextBox ID="Rate" runat="server" Text='<%# Eval("Rate", "{0:F2}") %>' Columns="4" MaxLength="11"></asp:TextBox>
                                                    <asp:RangeValidator ID="RateValidator" runat="server" Text="*" Type="currency" ErrorMessage="Rate value should be between 0.00 and 99999999.99" ControlToValidate="Rate" MinimumValue="0" MaximumValue="99999999.99" ></asp:RangeValidator>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Percent">
                                                <ItemStyle HorizontalAlign="Center" />
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="IsPercent" runat="server" Checked='<%# Eval("IsPercent") %>'></asp:CheckBox>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="False">
                                                <ItemStyle HorizontalAlign="Center" />
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="DeleteRowButton" runat="server" SkinID="DeleteIcon" CommandName="Delete" CommandArgument='<%#Eval("ShipRateMatrixId")%>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                    <asp:Button ID="AddRowButton" runat="server" Text="Add Row" SkinID="Button" OnClick="AddRowButton_Click"></asp:Button>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>