<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Methods.EditShipMethodProvider" Title="Edit Shipping Method"  CodeFile="EditShipMethodProvider.aspx.cs" AutoEventWireup="True" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
	            <div class="caption">
		            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Provider Method '{0}'" EnableViewState="false"></asp:Localize></h1>
	            </div>
            </div>
            <div class="grid_6 alpha">
                <div class="mainColumn">
                    <div class="content">
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
                                    <asp:TextBox ID="Name" runat="server" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
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
                                    <cb:ToolTipLabel ID="SurchargeLabel" runat="server" Text="Handling Fee:" ToolTip="Specify a surcharge or handling fee that is associated with this method.  You can set surcharges as a fixed amount or a percentage of the shipping chage.  You can also choose to include the surcharge in the total shipping rate or display as a separate line item in the order." />
                                </th>
                                <td valign="top">
                                    <asp:TextBox ID="Surcharge" runat="server" Columns="8"></asp:TextBox>
                                    <asp:DropDownList ID="SurchargeMode" runat="server">
                                        <asp:ListItem Value="0" Text="Fixed Amount"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="Percent (%) of Shipping Charge"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="Percent (%) of Shipment Total"></asp:ListItem>
                                    </asp:DropDownList>
                                    <br />
                                    <asp:RadioButtonList ID="SurchargeIsVisible" runat="server" AutoPostBack="true" OnSelectedIndexChanged="SurchargeIsVisible_SelectedIndexChanged">
                                        <asp:ListItem Text="Include in shipping cost"></asp:ListItem>
                                        <asp:ListItem Text="Show separately"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr id="trSurchargeTaxCode" runat="server" visible="false">
                                <th>
                                    <cb:ToolTipLabel ID="SurchargeTaxCodeLabel" runat="server" Text="Handling Tax Code:" ToolTip="If you wish to create tax rules for surcharge or handling fee of this shipping method, choose the tax code that should be assigned to calculated surcharge/handling fee charges.  You can then configure the tax rules for this code." AssociatedControlID="SurchargeTaxCode" EnableViewState="false" />
                                </th>
                                <td>
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
                                    <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
					                <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" OnClick="CancelButton_Click" />
                                </td>
                            </tr>
                        </table>
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
                            <p><asp:Label ID="ProviderMethodHelpText" runat="Server" Text="This shipping method calculates shipping cost for a third party carrier.  The shipipng cost is calculated for the <b>service</b> selected below." EnableViewState="false"></asp:Label></p>
                            <asp:Label ID="ServiceCodeLabel" runat="server" Text="Service: " SkinId="FieldHeader" AssociatedControlID="ServiceCode" EnableViewState="false" />
                            <asp:DropDownList ID="ServiceCode" runat="server" Width="300px"></asp:DropDownList><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="ServiceCodeRequired" runat="server" ControlToValidate="ServiceCode"
                                    Display="Static" ErrorMessage="Service is required." Text="*"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>