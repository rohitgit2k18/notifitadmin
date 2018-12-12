<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Shipments._Default" Title="Edit Shipment" EnableViewState="false" CodeFile="Default.aspx.cs" %>
<%@ Register Src="../../UserControls/OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<%@ Import Namespace="CommerceBuilder.Shipping.Providers" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Shipments - Order #{0}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content aboveGrid">
        <asp:HyperLink ID="AddShipmentLink" runat="server" Text="Add New Shipment" SkinID="AddButton"></asp:HyperLink>
        <p>Modify a shipment, add new shipments, or merge and split shipments from this page. Use the Items tab to change the order or recalculate tax and shipping.</p>
    </div>
    <asp:UpdatePanel ID="ShipmentAjax" runat="server">
        <ContentTemplate>
            <asp:Repeater ID="EditShipmentsGrid" runat="server" OnItemCommand="EditShipmentsGrid_ItemCommand">
                <ItemTemplate>
                    <div class="section">
                        <div class="header">
                            <h2><asp:Literal ID="Caption" runat="server" Text='<%#string.Format("Shipment #{0}", (Container.ItemIndex + 1))%>'></asp:Literal></h2>
                        </div>
                        <div class="content">
                            <table class="summary" border="0">
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipToLabel" runat="server" Text="Ship To:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:Label ID="ShipTo" runat="server" Text='<%#GetShipToAddress(Container.DataItem)%>'></asp:Label>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShipFromLabel" runat="server" Text="Ship From:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:Label ID="ShipFrom" runat="server" Text='<%#GetShipFromAddress(Container.DataItem)%>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Label ID="ShipDateLabel" runat="server" Text="Ship Date:"></asp:Label>
                                    </th>
                                    <td >
                                        <asp:Label ID="ShipDate" runat="server" Text='<%#Eval("ShipDate")%>' Visible='<%#!System.DateTime.MinValue.Equals(Eval("ShipDate")) %>'></asp:Label>
                                        <asp:HyperLink ID="RecordShipmentLink" runat="server" SkinID="Button" Text="Ship Items" NavigateUrl='<%#Eval("OrderShipmentId", "ShipOrder.aspx?OrderShipmentId={0}")%>' Visible='<%#ShipButtonVisible(Container.DataItem) %>'></asp:HyperLink>
                                    </td>
                                    <th>
                                        <asp:Label ID="ShippingMethodLabel" runat="server" Text="Shipping Method:"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:Label ID="ShippingMethod" runat="server" Text='<%#Eval("ShipMethodName")%>'></asp:Label><br />
                                        <asp:LinkButton ID="ChangeShipMethod" runat="server" Text="Change Method" CommandName="ChangeShipMethod" CommandArgument='<%#Eval("OrderShipmentId")%>'></asp:LinkButton>
                                    </td>
                                </tr>
                                <tr id="trShipMessage" runat="server" Visible='<%#ShowShipMessage(Container.DataItem)%>'>
                                    <th valign="top">
                                        <asp:Label ID="ShipMessageLabel" runat="server" Text="Customer Comment:"></asp:Label>
                                    </th>
                                    <td colspan="3">
                                        <asp:Label ID="ShipMessage" runat="server" Text='<%#Eval("ShipMessage")%>' ></asp:Label>
                                    </td>
                                </tr>
                                <tr id="trTracking" runat="server" Visible='<%#ShowTracking(Container.DataItem)%>'>
                                    <th>
                                        <asp:Label ID="TrackingNumbersLabel" runat="server" Text="Tracking Number:"></asp:Label>
                                    </th>
                                    <td colspan="3">
                                        <div style="overflow:auto;width:290px;height:30px; vertical-align:middle;">
                                            <asp:Repeater ID="TrackingRepeater" runat="server" DataSource='<%#Eval("TrackingNumbers")%>'>
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="TrackingNumberData" runat="server" Target="_blank" Text='<%#Eval("TrackingNumberData")%>' NavigateUrl='<%#GetTrackingUrl(Container.DataItem)%>'></asp:HyperLink>
                                                </ItemTemplate>
                                                <SeparatorTemplate>, </SeparatorTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td colspan="3">
                                        <asp:HyperLink ID="PackingListLink" runat="server"  SkinID="Button" Text="Print Packing Slip" NavigateUrl='<%#string.Format("../Print/PackSlips.aspx?OrderNumber={0}&ShipmentNumber={1}&is=1", OrderNumber, Container.ItemIndex + 1)%>' Visible='<%#Eval("Order.OrderStatus.IsValid") %>'></asp:HyperLink>
                                        <asp:HyperLink ID="PrintLabelLink" runat="server"  SkinID="Button" Text="Print Label" NavigateUrl='<%#string.Format("../Print/ShippingLabels.aspx?OrderNumber={0}&ShipmentNumber={1}&is=1", OrderNumber, Container.ItemIndex + 1)%>' Visible='<%#ShowLabelLink(Container.DataItem)%>'></asp:HyperLink>
                                        <asp:HyperLink ID="EditShipmentLink"  runat="server" SkinID="Button" Text="Edit" NavigateUrl='<%#Eval("OrderShipmentId", "EditShipment.aspx?OrderShipmentId={0}")%>' ></asp:HyperLink>
                                        <asp:PlaceHolder ID="phSplit" runat="server" Visible='<%#ShowSplitLink(Container.DataItem)%>'>
                                            <asp:HyperLink ID="SplitShipmentLink" runat="server" SkinID="Button" Text="Split" NavigateUrl='<%#string.Format("SplitShipment.aspx?OrderNumber={0}&ShipmentId={1}", OrderNumber, Eval("OrderShipmentId"))%>'></asp:HyperLink>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="phMerge" runat="server" Visible='<%#ShowMergeLink(Container.DataItem)%>'>
                                            <asp:HyperLink ID="MergeShipmentLink" runat="server" SkinID="Button" Text="Merge" NavigateUrl='<%#string.Format("MergeShipment.aspx?OrderNumber={0}&ShipmentId={1}", OrderNumber, Eval("OrderShipmentId"))%>'></asp:HyperLink>
                                        </asp:PlaceHolder>
                                        <asp:HyperLink ID="DeleteShipmentLink" runat="server" SkinID="Button" Text="Delete" NavigateUrl='<%#string.Format("DeleteShipment.aspx?OrderNumber={0}&ShipmentId={1}", OrderNumber, Eval("OrderShipmentId"))%>' Visible='<%#ShowDeleteButton(Container.DataItem)%>'></asp:HyperLink>
                                        <asp:Button ID="VoidShipmentButton" runat="server" Text="Void" SkinID="Button" Visible='<%#ShowVoidButton(Container.DataItem)%>' OnClientClick="return confirm('Are you sure you want to void/cancel this shipment?')" CommandName="VoidShp" CommandArgument='<%#Eval("OrderShipmentId")%>'></asp:Button>
                                        <asp:Button ID="DeleteShipmentButton" runat="server" Text="Delete" SkinID="Button" Visible='<%#ShowDeleteLink(Container.DataItem)%>' OnClientClick="return confirm('Are you sure you want to delete this shipment?')" CommandName="DelShp" CommandArgument='<%#Eval("OrderShipmentId")%>'></asp:Button>
                                    </td>
                                </tr>
                            </table>
                            <asp:GridView ID="ShipmentItems" runat="server" ShowHeader="true" DataSource='<%#GetShipmentItems((int)Eval("Id"))%>' AutoGenerateColumns="false" Width="100%" SkinID="PagedList">
                                <Columns>
                                    <asp:TemplateField HeaderText="Item">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemTemplate>
                                            <uc:OrderItemDetail ID="OrderItemDetail1" runat="server" OrderItem='<%#(OrderItem)Container.DataItem%>' ShowAssets="False" LinkProducts="False" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SKU" SortExpression="Sku">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <%# GetSku(Container.DataItem) %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price" SortExpression="Price">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" ItemStyle-HorizontalAlign="Center" />
                                    <asp:TemplateField HeaderText="Total" SortExpression="ExtendedPrice">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <%# ((decimal)Eval("ExtendedPrice")).LSCurrencyFormat("lc") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="ChangeShipMethodDialog" runat="server" Style="display:none;width:500px" CssClass="modalPopup">
                <asp:Panel ID="ChangeShipMethodDialogHeader" runat="server" CssClass="modalPopupHeader">
                    <asp:Localize ID="ChangeShipMethodDialogCaption" runat="server" Text="Shipment #{0}: Change Shipping Method"></asp:Localize>
                </asp:Panel>
                <div style="padding-top:5px;">
                    <table class="inputForm" cellpadding="3">
                        <tr>
                            <th nowrap>
                                <asp:Literal ID="ExistingShipMethodLabel" runat="server" Text="Current Method:"></asp:Literal>
                            </th>
                            <td>
                                <asp:Literal ID="ExistingShipMethod" runat="server" EnableViewState="false"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <th valign="top" nowrap>
                                <asp:Literal ID="NewShipMethodLabel" runat="server" Text="New Method:"></asp:Literal>
                            </th>
                            <td valign="top">
                                <asp:DropDownList ID="NewShipMethod" runat="server">
                                    <asp:ListItem Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:Localize ID="HiddenShipMethodWarning" runat="server" Text="<br />** Unavailable to customer at checkout." Visible="false" EnableViewState="false"></asp:Localize>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:HiddenField ID="ChangeShipMethodShipmentId" runat="server" />
                                <asp:Button ID="ChangeShipMethodOKButton" runat="server" text="Update" OnClick="ChangeShipMethodOKButton_Click" />
                                <asp:Button ID="ChangeShipMethodCancelButton" runat="server" text="Cancel" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
            <asp:HiddenField ID="DummyChangeShipMethod" runat="server" />
            <ajaxToolkit:ModalPopupExtender ID="ChangeShipMethodPopup" runat="server" 
                TargetControlID="DummyChangeShipMethod"
                PopupControlID="ChangeShipMethodDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="ChangeShipMethodCancelButton" 
                DropShadow="true"
                PopupDragHandleControlID="ChangeShipMethodDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>