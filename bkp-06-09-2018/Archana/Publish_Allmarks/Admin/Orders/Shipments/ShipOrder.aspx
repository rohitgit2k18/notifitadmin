<%@ Page Language="C#" MasterPageFile="../Order.master" Inherits="AbleCommerce.Admin.Orders.Shipments.ShipOrder" Title="Ship Order" EnableViewState="false" CodeFile="ShipOrder.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Ship for Order #{0}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="section">
        <asp:Panel ID="ShipmentNumberPanel" runat="server" CssClass="header">
            <h2><asp:Localize ID="ShipmentNumber" runat="server" Text="Shipment {0} of {1}"></asp:Localize></h2>
        </asp:Panel>
        <div class="content">
            <table class="summary">
                <tr>
                    <th valign="top">
                        <asp:Label ID="ShipToLabel" runat="server" Text="Ship To:"></asp:Label>
                    </th>
                    <td>
                        <asp:Literal ID="ShipTo" runat="server"></asp:Literal>
                    </td>
                    <th valign="top">
                        <asp:Label ID="ShipFromLabel" runat="server" Text="Ship From:"></asp:Label>
                    </th>
                    <td>
                        <asp:Literal ID="ShipFrom" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="ShippingMethodLabel" runat="server" Text="Shipping Method:"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:Literal ID="ShippingMethod" runat="server"></asp:Literal>
                    </td>                                
                </tr>
                <tr id="trShipMessage" runat="server" Visible="False">
                    <th valign="top">
                        <asp:Label ID="ShipMessageLabel" runat="server" Text="Customer Comment:"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:Literal ID="ShipMessage" runat="server"></asp:Literal>
                    </td>
                </tr>
            </table>
            <asp:ValidationSummary ID="ValidationSummary" runat="server" />
            <asp:Localize ID="SplitShipmentHelpText" runat="server" Text="If needed, change the quantity of items to ship.  Remaining item(s) will be moved to create a new shipment."></asp:Localize>
            <asp:GridView ID="ShipmentItems" runat="server" ShowHeader="true"
                AutoGenerateColumns="false" SkinID="PagedList" Width="100%">
                <Columns>
                    <asp:TemplateField HeaderText="Item">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                            <asp:Label ID="VariantName" runat="Server" Text='<%#Eval("VariantName", " ({0})")%>' Visible='<%#!String.IsNullOrEmpty((string)Eval("VariantName"))%>'></asp:Label><br />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Sku" HeaderText="Sku">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Price">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Quantity" HeaderText="Quantity">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Shipping">
                        <ItemStyle HorizontalAlign="center" />
                        <ItemTemplate>
                            <asp:HiddenField ID="Id" runat="server" Value='<%#Eval("OrderItemId")%>' />
                            <asp:TextBox ID="Quantity" runat="server" Text='<%#Eval("Quantity")%>' Width="40px" MaxLength="4"></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <table class="inputForm" id="autoTrackingInputPanel" runat="server">
                <tr>
                    <td>
                        <asp:Localize ID="ProviderInstructionText" runat="server" Visible="false" Text="To request a tracking number from {0}, click the Request Shipment button below. For each valid shipment, a shipping label will be available to print."></asp:Localize>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="RequestShipmentButton" runat="server" Text="Request Shipment" SkinID="SaveButton" OnClick="RequestShipmentButton_Click" />
                        &nbsp;<asp:HyperLink ID="CancelButton2" runat="server" Text="Cancel" NavigateUrl="Default.aspx" SkinID="CancelButton" />
                    </td>
                </tr>
            </table>
            <table class="inputForm">
                <tr>
                    <td colspan="2">
                        <asp:Localize ID="InstructionTextNoProvider" runat="server" Text="To send a shipping notification email to the customer, click the Ship button, and enter a tracking number if one is available."></asp:Localize>
                        <asp:PlaceHolder ID="phValidation" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="AddTrackingNumberLabel" runat="server" Text="Tracking Number:"></asp:Label>
                    </th>
                    <td>
                        <asp:DropDownList ID="ShipGateway" runat="server" DataTextField="Name" DataValueField="ShipGatewayId" AppendDataBoundItems="true">
                            <asp:ListItem Value="" Text=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox ID="AddTrackingNumber" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                        <asp:Button ID="ShipButton" runat="server" Text="Ship" SkinID="SaveButton" OnClick="ShipButton_Click" />
                        &nbsp;<asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" NavigateUrl="Default.aspx" SkinID="CancelButton" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>