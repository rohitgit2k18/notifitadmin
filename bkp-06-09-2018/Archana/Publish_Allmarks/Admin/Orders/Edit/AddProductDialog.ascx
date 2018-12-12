<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Edit.AddProductDialog"  CodeFile="AddProductDialog.ascx.cs" %>
<asp:UpdatePanel ID="ProductAjax" runat="server">
    <ContentTemplate>
        <asp:Localize ID="GiftCertMessage" runat="server" Text="<p>You are adding a gift certificate product to the order.  You may need to manually activate the generated gift certificate.</p>" Visible="false"></asp:Localize>
        <asp:Localize ID="DigitalGoodsMessage" runat="server" Text="<p>You are adding a product with associated digital goods to the order.  You may need to manually activate the generated digital good(s).</p>" Visible="false"></asp:Localize>
        <asp:Localize ID="SubscriptionMessage" runat="server" Text="<p>You are adding a subscription product to the order.  You may need to manually activate the generated subscription.</p>" Visible="false"></asp:Localize>
        <asp:ValidationSummary ID="ValidationSummary" runat="server" />
        <table class="inputForm">
            <tr>
                <th>
                    <asp:Label ID="NameLabel" runat="server" Text="Product:"></asp:Label>        
                </th>
                <td>
                    <asp:Label ID="Name" runat="server" EnableViewState="false"></asp:Label>
                </td>
            </tr>
            <asp:PlaceHolder runat="server" id="phOptions"></asp:PlaceHolder>
            <tr>
                <th>
                    <asp:Label ID="PriceLabel" runat="server" Text="Price:"></asp:Label>        
                </th>
                <td>
                    <asp:TextBox ID="Price" runat="server" EnableViewState="false" OnPreRender="Price_PreRender" Width="50px" MaxLength="8"></asp:TextBox>
                    <asp:PlaceHolder ID="phVariablePrice" runat="server"></asp:PlaceHolder>
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="QuantityLabel" runat="server" Text="Quantity:"></asp:Label>        
                </th>
                <td>
                    <asp:TextBox Id="Quantity" runat="server" width="60px" Text="1"></asp:TextBox>
                </td>
            </tr>
            <tr id="trShipment" runat="server">
                <th>
                    <asp:Label ID="ShipmentsListLabel" runat="server" Text="Shipment:"></asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="ShipmentsList" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ShipmentsList_SelectedIndexChanged">
                        <asp:ListItem Text="" Value=""></asp:ListItem>
                        <asp:ListItem Text="Add New Shipment" Value="-1"></asp:ListItem>
                    </asp:DropDownList><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="ShipmentRequired" runat="server"
                        Text="*" ErrorMessage="You must select a shipment for this item."
                        ControlToValidate="ShipmentsList"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr id="trNewShipmentFrom" runat="server">
                <th>
                    <asp:Label ID="ShipFromLabel" runat="server" Text="Ship From:" AssociatedControlID="ShipFrom"></asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="ShipFrom" runat="server" DataTextField="Name" DataValueField="Id">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr id="trNewShipmentAddress" runat="server">
                <th>
                    <asp:Label ID="AddressLabel" runat="server" Text="Ship To:"></asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="AddressList" runat="server" EnableViewState="true">
                        <asp:ListItem Text="-- select address --" Value=""></asp:ListItem>
                    </asp:DropDownList><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="AddressValidator" runat="server" ControlToValidate="AddressList"
                        Text="*" ErrorMessage="Ship to address is required."></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr id="trNewShipmentShipMethod" runat="server">
                <th><asp:Label ID="ShipMethodLabel" runat="server" Text="Shipping Method:"></asp:Label></th>
                <td>
                    <asp:DropDownList ID="ShipMethodList" runat="server" DataSourceID="ShipMethodDs" DataTextField="Name" DataValueField="ShipMethodId" AppendDataBoundItems="True" AutoPostBack="true">
                        <asp:ListItem Text=""></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr id="trInventoryWarning" runat="server" visible="false" enableviewstate="false">
                <td>&nbsp;</td>
                <td>
                    <span class="errorCondition">
                        <asp:Literal ID="InventoryWarningMessage" runat="server" EnableViewState="false"></asp:Literal>
                    </span>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="SaveButton" runat="server" Visible="False" Text="Save" OnClick="SaveButton_Click" />
			        <asp:HyperLink ID="BackButton" runat="server" Text="Cancel"  SkinID="CancelButton" />&nbsp;
                    <asp:HiddenField ID="HiddenProductId" runat="server" />
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:ObjectDataSource ID="ShipMethodDs" runat="server" OldValuesParameterFormatString="original_{0}"
    SelectMethod="LoadAll" TypeName="CommerceBuilder.Shipping.ShipMethodDataSource">
</asp:ObjectDataSource>