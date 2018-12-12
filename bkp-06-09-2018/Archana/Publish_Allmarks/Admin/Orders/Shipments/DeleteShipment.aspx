<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Shipments.DeleteShipment" Title="Delete Shipment" EnableViewState="false" CodeFile="DeleteShipment.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text=" Delete Shipment #{0}"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server"> 
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
    </table>
    <p><asp:Localize ID="InstructionText" runat="server" Text="This shipment contains the following order items:"></asp:Localize></p>
    <asp:GridView ID="ShipmentItems" runat="server" ShowHeader="true" 
        AutoGenerateColumns="false" Width="100%" SkinID="PagedList">
        <Columns>
            <asp:TemplateField HeaderText="Item">
                <HeaderStyle HorizontalAlign="Left" />
                <ItemTemplate>
                    <%#Eval("Name")%>
                    <asp:Literal ID="VariantName" runat="Server" Text='<%#Eval("VariantName", " ({0})")%>' Visible='<%#!String.IsNullOrEmpty((string)Eval("VariantName"))%>'></asp:Literal><br />
                    <asp:Panel ID="InputPanel" runat="server" Visible='<%#(((ICollection)Eval("Inputs")).Count > 0)%>'>
                        <asp:DataList ID="InputList" runat="server" DataSource='<%#Eval("Inputs") %>'>
                            <ItemTemplate>
                                <asp:Label ID="InputName" Runat="server" Text='<%#Eval("Name") + ":"%>' SkinID="fieldheader"></asp:Label>
                                <asp:Label ID="InputValue" Runat="server" Text='<%#Eval("InputValue")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:DataList>
                    </asp:Panel>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Sku">
                <ItemStyle HorizontalAlign="Center" />
                <ItemTemplate>
                    <%#Eval("Sku")%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Quantity">
                <ItemStyle HorizontalAlign="Center" />
                <ItemTemplate>
                    <%#Eval("Quantity")%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Price">
                <ItemStyle HorizontalAlign="Center" />
                <ItemTemplate>
                    <%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Total">
                <ItemStyle HorizontalAlign="Center" />
                <ItemTemplate>
                    <%# ((decimal)Eval("ExtendedPrice")).LSCurrencyFormat("lc") %>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <p>These items will be deleted when you delete this shipment.  If you do not wish to delete these items, move them to another shipment before deleting this one.</p>
    <asp:Button ID="DeleteShipmentButton" runat="server" Text="Delete Shipment" OnClick="DeleteShipmentButton_Click" />
    <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="Default.aspx" SkinID="Button" />
</div>
</asp:Content>