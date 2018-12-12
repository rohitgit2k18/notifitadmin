<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Orders.Print.PackSlips" Title="Packing Slip" CodeFile="PackSlips.aspx.cs" %>
<%@ Register Src="OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/Admin/UserControls/PrintableLogo.ascx" TagName="PrintableLogo" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader noPrint">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Packing Slips"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="Print" runat="server" Text="Print" OnClick="Print_Click" />
                <asp:HyperLink ID="Back" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="~/Admin/Orders/Default.aspx" />
            </div>
        </div>
    </div>
    <div class="content noPrint">
        <p><asp:Label ID="OrderListLabel" runat="server" Text="Order Number(s): " SkinID="FieldHeader"></asp:Label><asp:Label ID="OrderList" runat="server" Text=""></asp:Label></p>
        <p><asp:Localize ID="PrintInstructions" runat="server" Text="This page contains a printable stylesheet. Your browser will print with appropriate styles and page breaks if needed. Website headers and footers (along with this message) will not be printed."></asp:Localize></p>
    </div>
    <div class="content">
        <asp:Repeater ID="ShipmentRepeater" runat="server">
            <ItemTemplate>
                <div class="packingSlip<%# Container.ItemIndex > 0 ? " breakBefore" : string.Empty %>">
                    <div class="logo">  
                        <uc:PrintableLogo ID="Logo" runat="server" />
                    </div>
                    <h2><asp:Label ID="PrintCaption" runat="server" Text="Packing Slip"></asp:Label></h2>
                    <div class="orderSummary">
                        <div class="row">
                            <asp:Label ID="OrderNumberLabel" runat="server" Text="Order Number:" SkinID="FieldHeader"></asp:Label> 
                            <%# Eval("Order.OrderNumber") %>
                        </div>
                        <div class="row">
                            <asp:Label ID="OrderDateLabel" runat="server" Text="Order Date:" SkinID="FieldHeader"></asp:Label>
                            <%#Eval("Order.OrderDate", "{0:g}") %>
                        </div>
                        <div class="row">
                            <asp:Label ID="ShipmentNumberLabel" runat="server" Text="Shipment Number:" SkinID="FieldHeader"></asp:Label>
                            <%#Eval("ShipmentNumber") %> of <%#Eval("Order.Shipments.Count") %>
                        </div>
                        <div class="row">
                            <asp:Label ID="ShipmentWeightLabel" runat="server" Text="Shipment Weight:" SkinID="FieldHeader"></asp:Label>
                            <%# Eval("Weight") %> <%# Eval("Order.Store.WeightUnit") %>
                        </div>
                        <div class="row">
                            <asp:Label ID="ShippingMethodLabel" runat="server" Text="Shipping Method:" SkinID="FieldHeader"></asp:Label>
                            <%#Eval("ShipMethodName") %>
                        </div>
                        <div class="row">
                            <asp:Label ID="AddressTypeLabel" runat="server" Text="Address Type:" SkinID="FieldHeader"></asp:Label>
                            <asp:Localize ID="IsResidenceText" runat="server" Text="Residential" Visible='<%# AlwaysConvert.ToBool(Eval("ShipToResidence"), false) %>'></asp:Localize>
                            <asp:Localize ID="IsBusinessText" runat="server" Text="Commercial" Visible='<%# !(AlwaysConvert.ToBool(Eval("ShipToResidence"), false)) %>'></asp:Localize>
                        </div>
                        <asp:PlaceHolder ID="trShipMessage" runat="server" Visible='<%# ((string)Eval("ShipMessage")).Length > 0 %>'>
                            <div class="row shipMessage">
                                <asp:Label ID="ShipMessageLabel" runat="server" Text="Customer Comment:" SkinID="FieldHeader"></asp:Label>
                                <%#Eval("ShipMessage")%>
                            </div>
                        </asp:PlaceHolder>
                    </div>
                    <table class="shippingAddresses">
                        <tr>
                            <th class="shipFrom">
                                <asp:Label ID="ShipFromCaption" runat="server" Text="Ship From:"></asp:Label>
                            </th>
                            <th class="shipTo">
                                <asp:Label ID="ShipToCaption" runat="server" Text="Ship To:"></asp:Label>
                            </th>
                        </tr>
                        <tr>
                            <td class="shipFrom">
                                <asp:Label ID="ShipFrom" runat="server" Text='<%# GetShipFromAddress(Container.DataItem) %>'></asp:Label>
                            </td>
                            <td class="shipTo">
                                <asp:Label ID="ShipTo" runat="server" Text='<%# GetShipToAddress(Container.DataItem) %>'></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <asp:GridView ID="ShipmentItems" runat="server" ShowHeader="true" 
                        AutoGenerateColumns="false" CellSpacing="0" GridLines="none" 
                        Width="100%" SkinID="PrintableList" DataSource='<%#GetProducts(Container.DataItem)%>'>
                        <Columns>
                            <asp:BoundField DataField="Quantity" HeaderText="Quantity" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80" />
                            <asp:BoundField DataField="Sku" HeaderText="Sku" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="140" />
                            <asp:TemplateField HeaderText="Item">
                                <ItemTemplate>
                                    <uc:OrderItemDetail ID="OrderItemDetail1" runat="server" OrderItem='<%#(OrderItem)Container.DataItem%>' ShowAssets="False" LinkProducts="False" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>