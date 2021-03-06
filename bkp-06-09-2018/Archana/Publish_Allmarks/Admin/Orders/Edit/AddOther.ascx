<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Edit.AddOtherControl" CodeFile="AddOther.ascx.cs" %>
<asp:ValidationSummary ID="ValidationSummary" runat="server"  />
<table class="inputForm">
    <tr>
        <th>
            <asp:Label ID="ItemTypeLabel" runat="server" Text="Item Type:"></asp:Label>
        </th>
        <td>
            <asp:DropDownList ID="ItemType" runat="server">
                <asp:ListItem Text="" Value=""></asp:ListItem>
            </asp:DropDownList><span class="requiredField">*</span>
            <asp:RequiredFieldValidator ID="ItemTypeRequired" runat="server" ControlToValidate="ItemType"  ErrorMessage="Item type is required." Text="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="NameLabel" runat="server" Text="Name:"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="Name" runat="server" width="200px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
            <asp:RequiredFieldValidator ID="NameRequired" runat="server" ControlToValidate="Name" ErrorMessage="Item name is required." Text="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="SkuLabel" runat="server" Text="SKU:"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="Sku" runat="server" Width="100px" MaxLength="50"></asp:TextBox>
            <asp:PlaceHolder ID="phSkuValidators" runat="server"></asp:PlaceHolder>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="PriceLabel" runat="server" Text="Price:"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="Price" runat="server" Width="60px" MaxLength="10"></asp:TextBox><span class="requiredField">*</span>
            <asp:RequiredFieldValidator ID="PriceRequired" runat="server" ControlToValidate="Price"  ErrorMessage="Item price is required." Text="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th>
            <asp:Label ID="QuantityLabel" runat="server" Text="Quantity:"></asp:Label>
        </th>
        <td>
            <asp:TextBox ID="Quantity" runat="server" Width="40px" MaxLength="4" Text="1"></asp:TextBox><span class="requiredField">*</span>
            <asp:RequiredFieldValidator ID="QuantityValidator1" runat="server" ControlToValidate="Quantity"  ErrorMessage="Item quantity is required." Text="*"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr id="trShipmentList" runat="server" visible="false">
        <th>
            <asp:Label ID="ShipmentsListLabel" runat="server" Text="Shipment:"></asp:Label>
        </th>
        <td>
            <asp:DropDownList ID="ShipmentsList" runat="server">
                <asp:ListItem Text="Unshippable / No Shipment" Value=""></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>
            <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click"  />
	        <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" SkinID="CancelButton" />&nbsp;
        </td>
    </tr>
</table>