<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Edit.EditOrderItems" Title="Edit Order Items" CodeFile="EditOrderItems.aspx.cs" ViewStateMode="Disabled" %>
<%@ Register Src="../../UserControls/OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="OrderItemsAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Edit Order Items"></asp:Localize></h1>
                </div>
            </div>
            <div class="content aboveGrid">
                <asp:HyperLink ID="AddProductLink" runat="server" Text="Add Product" NavigateUrl="FindProduct.aspx" SkinID="AddButton"></asp:HyperLink>
                <asp:HyperLink ID="AddOtherItemLink" runat="server" Text="Add Other Item" NavigateUrl="AddOther.aspx" SkinID="AddButton"></asp:HyperLink>
                <asp:Button ID="RecalculateTaxesButton" runat="server" Text="Recalculate Taxes" OnClick="RecalculateTaxesButton_OnClick" OnClientClick="if(confirm('If supported by your tax provider, taxes will be recalculated based on the current order configuration. Continue?')){this.value = 'Recalculating...'; this.enabled= false;}else{return false;}" />
                <p>
                    <asp:Literal ID="EditInstructions" runat="server" Text="If you modify the items in the order, you may need to recalculate taxes or shipping charges."></asp:Literal>
                </p>
                <asp:PlaceHolder ID="TaxCloudWarningMessagePanel" runat="server" Visible="false">
                    <p class="errorCondition"><asp:Literal ID="TaxCloudReclaculationMessage" runat="server" Text="Order tax recalculation is not supported by the Tax Cloud tax gateway. If recalculation is required, then verify the calculated tax amounts for order #{0} and adjust."></asp:Literal></p>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="TaxExemptionMessagePanel" runat="server" Visible="false">
                    <asp:Literal ID="TaxExemptionMessage" runat="server" Text="NOTE: Customer used a tax exemption certificate (id: {0}) for this order."></asp:Literal>
                </asp:PlaceHolder>
                <cb:Notification ID="TaxesRecalculatedMessage" runat="server" Text="Tax recalculation request was successfully submitted." Visible="false" SkinID="GoodCondition"></cb:Notification>
                <cb:Notification ID="ShippingRecalculatedMessage" runat="server" Text="Shipping recalculation request was successfully submitted." Visible="false" SkinID="GoodCondition"></cb:Notification>
            </div>
            <asp:Repeater ID="EditShipmentsGrid" runat="server" OnItemCommand="ShipmentCommand">
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
                            </table>
                            <p><asp:Button ID="RecalculateShippingButton" runat="server" Text="Recalculate Shipping" CommandName="Recalc" CommandArgument='<%#Eval("Id") %>' OnClientClick="this.value = 'Recalculating...'; this.enabled= false;" /></p>
                            <asp:GridView ID="ShipmentItems" runat="server" ShowHeader="true" DataSource='<%#GetShipmentItems((int)Eval("Id"))%>'
                                OnRowCommand="ItemsGrid_RowCommand" OnDataBound="ItemsGrid_DataBound" AutoGenerateColumns="false" Width="100%" SkinID="PagedList" ViewStateMode="Enabled">
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
                                            <%# AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem) %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price" SortExpression="Price">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="EditPrice" runat="server" Text='<%# Bind("Price", "{0:F2}") %>' Width="60px" MaxLength="10"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Quantity" SortExpression="Quantity" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="Quantity" runat="server" Text='<%# Bind("Quantity") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="EditQuantity" runat="server" Text='<%# Bind("Quantity") %>' Width="40px" MaxLength="8"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tax Rate" SortExpression="TaxRate" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="TaxRate" runat="server" Text='<%# Bind("TaxRate", "{0:0.####}") %>'></asp:Label>%
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="EditTaxRate" runat="server" Text='<%# Bind("TaxRate", "{0:0.00##}") %>' width="40px" MaxLength="8"></asp:TextBox>%
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total" SortExpression="ExtendedPrice">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <%# ((decimal)Eval("ExtendedPrice")).LSCurrencyFormat("lc") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemStyle HorizontalAlign="Right" Wrap="false" />
                                        <ItemTemplate>
                                            <asp:ImageButton ID="EditButton" runat="server" CommandName="EditItem" CommandArgument='<%#Eval("Id")%>' ToolTip="Edit" SkinID="EditIcon" />
                                            <asp:ImageButton ID="DeleteButton" runat="server" CommandName="DeleteItem" CommandArgument='<%#Eval("Id")%>' ToolTip="Delete" SkinID="DeleteIcon" OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="SaveButton" runat="server" CausesValidation="True" ToolTip="Save" CommandName="Update"><asp:Image ID="SaveIcon" runat="server" SkinID="SaveIcon" /></asp:LinkButton>
                                            <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" ToolTip="Cancel" CommandName="Cancel"><asp:Image ID="CancelIcon" runat="server" SkinID="CancelIcon" /></asp:LinkButton>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:PlaceHolder ID="NonShippingItemsPanel" runat="server">
                <div class="section">
                    <div class="header">
                        <h2><asp:Literal ID="Literal1" runat="server" Text='Non Shipping Items'></asp:Literal></h2>
                    </div>
                    <div class="content">
                        <asp:GridView ID="NonShippingItemsGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" AllowSorting="False"
                            OnRowCommand="ItemsGrid_RowCommand" OnDataBound="ItemsGrid_DataBound" SkinID="PagedList" Width="100%">
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
                                        <%# AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Price" SortExpression="Price">
                                    <itemstyle horizontalalign="Right" />
                                    <ItemTemplate>
                                        <%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Quantity" SortExpression="Quantity" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <%# Eval("Quantity") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tax Rate" SortExpression="TaxRate" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <%# Eval("TaxRate", "{0:0.####}") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Total" SortExpression="ExtendedPrice">
                                    <itemstyle horizontalalign="Right" />
                                    <ItemTemplate>
                                        <%# ((decimal)Eval("ExtendedPrice")).LSCurrencyFormat("lc") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemStyle HorizontalAlign="Right" Wrap="false" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="EditButton" runat="server" CommandName="EditItem" CommandArgument='<%#Eval("Id")%>' ToolTip="Edit" SkinID="EditIcon" />
                                        <asp:ImageButton ID="DeleteButton" runat="server" CommandName="DeleteItem" CommandArgument='<%#Eval("Id")%>' ToolTip="Delete" SkinID="DeleteIcon" OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Localize ID="EmptyMessage" runat="server" Text="There are no items in the order."></asp:Localize>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </asp:PlaceHolder>
            <asp:Panel ID="EditItemDialog" runat="server" Style="display:none;width:500px" CssClass="modalPopup">
                <asp:Panel ID="EditItemDialogHeader" runat="server" CssClass="modalPopupHeader">
                    <asp:Localize ID="EditItemDialogCaption" runat="server" Text="Edit {0}"></asp:Localize>
                </asp:Panel>
                <div style="padding-top:5px;">
                    <asp:Localize ID="GiftCertMessage" runat="server" Text="<p>You are editing a gift certificate product.  After you make changes you must make manual adjustments to either the value or quantity of the related gift certificates from the Gift Certificates tab.</p>" Visible="false"></asp:Localize>
                    <table class="inputForm" cellpadding="3">
                        <tr>
                            <th>
                                Item:
                            </th>
                            <td>
                                <asp:Literal ID="EditItemName" runat="server"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Quantity:
                            </th>
                            <td>
                                <asp:TextBox ID="EditItemQuantity" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Price:
                            </th>
                            <td>
                                <asp:TextBox ID="EditItemPrice" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <br />
                                <asp:HiddenField ID="EditItemId" runat="server" />
                                <asp:Button ID="SaveEditButton" runat="server" Text="Save" OnClick="SaveEditButton_Click" ValidationGroup="SaveEdit" />
                                <asp:Button ID="CancelEditButton" runat="server" Text="Cancel" SkinId="CancelButton" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
            <asp:HiddenField ID="DummyEditTarget" runat="server" />
            <ajaxToolkit:ModalPopupExtender ID="EditItemPopup" runat="server" 
                TargetControlID="DummyEditTarget"
                PopupControlID="EditItemDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="CancelEditButton" 
                DropShadow="true"
                PopupDragHandleControlID="RenameDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>