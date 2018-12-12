<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Shipments.MergeShipment" Title="Merge Shipment" CodeFile="MergeShipment.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Merge Shipment for Order #{1}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="content">
    <p><asp:Localize ID="InstructionText" runat="server" Text="When you merge this shipment, it's items will be moved to another available shipment.  After the merge, this shipment will be removed from the order."></asp:Localize></p>
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
                <ItemStyle HorizontalAlign="Right" />
                <ItemTemplate>
                    <%# ((decimal)Eval("ExtendedPrice")).LSCurrencyFormat("lc") %>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <table class="inputForm" cellpadding="3" cellspacing="0">
        <tr>
            <th align="right">
                <asp:Label ID="ShipmentsListLabel" runat="server" Text="Merge items to:" AssociatedControlID="ShipmentsList"></asp:Label>
            </th>
            <td>
                <asp:DropDownList ID="ShipmentsList" runat="server"></asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <asp:Button ID="MergeButton" runat="server" SkinID="SaveButton" Text="Merge" OnClick="MergeButton_Click" />
                <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="Default.aspx" SkinID="CancelButton" />
            </td>
        </tr>
    </table>
</div>
</asp:Content>