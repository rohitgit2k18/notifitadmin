<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Create.CreateOrder2" Title="Place Order" CodeFile="CreateOrder2.aspx.cs" %>
<%@ Register Src="~/Admin/Orders/Create/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/Admin/UserControls/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:HiddenField ID="AnonymousUserId" Value="0" runat="server" />
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="Create Order for {0} (Step 2 of 4)"></asp:Localize>
            </h1>
        </div>
    </div>
    <asp:UpdatePanel ID="BasketAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>                                        
            <div class="content">
	            <asp:DataList ID="WarningMessageList" runat="server" EnableViewState="False">
	                <HeaderTemplate><ul></HeaderTemplate>
	                <ItemTemplate>
	                    <li><asp:Label ID="WarningMessage" runat="server" text="<%# Container.DataItem %>"></asp:Label></li>
	                </ItemTemplate>
	                <FooterTemplate></ul></FooterTemplate>
	            </asp:DataList>
                <asp:GridView ID="BasketGrid" runat="server" AutoGenerateColumns="False"
                    ShowFooter="True" DataKeyNames="BasketItemId" OnRowCommand="BasketGrid_RowCommand"
                    OnDataBound="BasketGrid_DataBound" Width="100%" OnRowDataBound="BasketGrid_RowDataBound"
                    SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField>
                            <ItemStyle Width="50px" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="DeleteItem" CommandArgument='<%# Eval("BasketItemId") %>' OnClientClick='<%# GetConfirmDelete(Container.DataItem) %>' Visible='<%# CanDeleteBasketItem(Container.DataItem) %>' EnableViewState="true"><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" EnableViewState="false" /></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SKU">
                            <ItemStyle HorizontalAlign="center" Width="120px" />
                            <ItemTemplate>
                                <%# AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item">
						    <HeaderStyle CssClass="columnHeader" HorizontalAlign="left" VerticalAlign="top" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <uc:BasketItemDetail ID="BasketItemDetail1" runat="server" BasketItem="<%# Container.DataItem %>" LinkProducts="true" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Price">
                            <ItemStyle HorizontalAlign="right" Width="100px" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("KitPrice")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="In Stock">
                            <ItemStyle HorizontalAlign="center" Width="80px" />
                            <ItemTemplate>
                                <%#GetAvailableQuantity(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Qty">
                            <ItemStyle HorizontalAlign="center" Width="100px" />
                            <ItemTemplate>
                                <asp:PlaceHolder ID="ProductQuantityPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") == OrderItemType.Product)%>'>
                                    <asp:TextBox ID="Quantity" runat="server" Text='<%# Eval("Quantity") %>' MaxLength="3" Width="40px" onfocus="this.select()"></asp:TextBox>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="OtherQuantityPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") != OrderItemType.Product)%>'>
                                    <%#Eval("Quantity")%>
                                </asp:PlaceHolder>
                            </ItemTemplate>
                            <FooterStyle HorizontalAlign="right" VerticalAlign="top" />
                            <FooterTemplate>
                                <asp:Label ID="SubtotalLabel" runat="server" Text="Subtotal" SkinID="FieldHeader"></asp:Label><br />
                                <asp:Label ID="SubtotalHelpText" runat="server" Text="(subtotal does not include tax or shipping)" Font-Bold="false"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total">
                            <ItemStyle HorizontalAlign="right" Width="100px" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("KitExtendedPrice")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                            <FooterStyle HorizontalAlign="right" VerticalAlign="top" />
                            <FooterTemplate>
                                <asp:Label ID="Subtotal" runat="server" Text='<%# GetBasketSubtotal().LSCurrencyFormat("lc") %>' SkinID="FieldHeader"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>                      
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Localize ID="EmptyMessage" runat="server" Text="Add one or more products to create the new order."></asp:Localize>
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:Panel ID="OrderButtonPanel" runat="server">
                    <asp:Button ID="ClearBasketButton" runat="server" OnClientClick="return confirm('Are you sure you want to clear the order contents?')" Text="Clear Order" OnClick="ClearBasketButton_Click"></asp:Button>
                    <asp:Button ID="UpdateButton" runat="server" OnClick="UpdateButton_Click" Text="Recalculate"></asp:Button>
                    <asp:Button ID="CheckoutButton" runat="server" OnClick="CheckoutButton_Click" Text="Place Order >>"></asp:Button>
                </asp:Panel>
            </div>
            <div class="grid_4 alpha">
                <div class="leftColumn">
                    <asp:Panel ID="FindProductPanel" runat="server" DefaultButton="FindProductSearchButton" CssClass="section">
                        <div class="header">
                            <h2 class="product"><asp:localize ID="Localize1" runat="server" Text=" Search for a product to add"></asp:localize></h2>
                        </div>
                        <div class="content">
                            <table class="inputForm" cellpadding="2"  width="100%">
                                <tr>
                                    <th>
                                        <asp:Localize ID="FindProductNameLabel" runat="server" text="Name:"></asp:Localize>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="FindProductName" runat="server" Width="150px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <asp:Localize ID="FindProductSkuLabel" runat="server" text="SKU:"></asp:Localize>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="FindProductSku" runat="server" Width="150px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Button ID="FindProductSearchButton" runat="server" Text="Search" OnClick="FindProductSearchButton_Click" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </asp:Panel>
                </div>
            </div>
            <div class="grid_8 omega">
                <div class="mainColumn">
                    <div class="content">
                        <asp:GridView ID="FindProductSearchResults" runat="server" AutoGenerateColumns="false" 
                            DataSourceID="AddProductDs" AllowPaging="true" PageSize="10" AllowSorting="true" 
                            Visible="false" OnRowCommand="FindProductSearchResults_RowCommand" SkinID="PagedList" Width="100%">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemStyle Width="50px" HorizontalAlign="center" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="AddButton" runat="server" CommandName="Add" CommandArgument='<%#Eval("ProductId")%>' SkinID="AddIcon" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Sku" HeaderText="SKU" SortExpression="Sku" />
                                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                                <asp:TemplateField HeaderText="Price" SortExpression="Price">
                                    <ItemStyle HorizontalAlign="right" Width="80px" />
                                    <ItemTemplate>
                                        <uc:ProductPrice ID="ProductPrice1" runat="server" Product='<%#Container.DataItem%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="FindProductEmptyResultsMessage" runat="server" Text="No products match the search criteria."></asp:Label>
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="AddProductDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="FindProducts" TypeName="CommerceBuilder.Products.ProductDataSource"
                         EnablePaging="true" SelectCountMethod="FindProductsCount" SortParameterName="sortExpression">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="FindProductName" Name="name" PropertyName="Text" Type="String" />
                                <asp:ControlParameter ControlID="FindProductSku" Name="sku" PropertyName="Text" Type="String" />
                                <asp:Parameter DefaultValue="0" Name="categoryId" Type="Object" />
                                <asp:Parameter DefaultValue="0" Name="manufacturerId" Type="Object" />
                                <asp:Parameter DefaultValue="0" Name="vendorId" Type="Object" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </div>
                </div>
            </div>
            <asp:Panel ID="InventoryDialog" runat="server" Style="display:none;width:600px" CssClass="modalPopup">
                <asp:Panel ID="InventoryDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                    <asp:Localize ID="InventoryDialogCaption" runat="server" Text="Inventory Issue" EnableViewState="false"></asp:Localize>
                </asp:Panel>
                <div class="content">
                    <asp:DataList ID="InventoryMessages" runat="server" EnableViewState="false" CssClass="errorCondition" >
				        <HeaderTemplate><ul></HeaderTemplate>
				        <ItemTemplate><li><%# Container.DataItem %></li></ItemTemplate>
				        <FooterTemplate></ul></FooterTemplate>
			        </asp:DataList>
                    <p>
                        <asp:RadioButtonList ID="InventoryAction" runat="server" EnableViewState="false">
                            <asp:ListItem Text="Continue placing this order using the specified quantities." Value="NoAction" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Change the product(s) to the currently available stock." Value="Update"></asp:ListItem>
                        </asp:RadioButtonList>
                    </p>
                    <div class="buttons">
                        <asp:Button ID="InventoryActionButton" runat="server" Text="Proceed" OnClick="InventoryActionButton_Click" />
                        <asp:Button ID="InventoryCancelButton" runat="server" Text="Cancel"/>
                    </div>
                </div>
            </asp:Panel>
            <asp:HiddenField ID="DummyInventoryAction" runat="server" />
            <ajaxToolkit:ModalPopupExtender ID="InventoryPopup" runat="server" 
                TargetControlID="DummyInventoryAction"
                PopupControlID="InventoryDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="InventoryCancelButton" 
                DropShadow="false"
                PopupDragHandleControlID="InventoryDialogHeader" />
            <asp:HiddenField ID="AddProductId" runat="server" />
            <asp:Panel ID="AddDialog" runat="server" Style="display:none;width:600px" CssClass="modalPopup">
                <asp:Panel ID="AddDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                    <asp:Localize ID="AddDialogCaption" runat="server" Text="Add Product to Order" EnableViewState="false"></asp:Localize>
                </asp:Panel>
                <asp:PlaceHolder ID="AddProductPanel" runat="server" EnableViewState="false">
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Label ID="AddProductNameLabel" runat="server" Text="Product:"></asp:Label>        
                            </th>
                            <td>
                                <asp:Label ID="AddProductName" runat="server" EnableViewState="false"></asp:Label>
                            </td>
                        </tr>
                        <asp:PlaceHolder runat="server" id="phOptions" EnableViewState="false"></asp:PlaceHolder>
                        <tr>
                            <th>
                                <asp:Label ID="AddProductPriceLabel" runat="server" Text="Price:"></asp:Label>        
                            </th>
                            <td>
                                <asp:TextBox ID="AddProductPrice" runat="server" OnPreRender="AddProductPrice_PreRender" Width="50px" MaxLength="8" EnableViewState="false"></asp:TextBox>
                                <asp:TextBox ID="AddProductVariablePrice" runat="server" EnableViewState="false" Width="50px" MaxLength="8" Visible="false"></asp:TextBox>
                                <asp:PlaceHolder ID="phVariablePrice" runat="server" EnableViewState="false"></asp:PlaceHolder>
                            </td>
                        </tr>
                        <tr id="trSubscriptionRow" runat="server">
                            <th>
                            </th>
                            <td>
                                <asp:RadioButtonList ID="OptionalSubscription" runat="server" AutoPostBack="true" CausesValidation="false">
                                    <asp:ListItem Text="one-time" Value="True"></asp:ListItem>
                                    <asp:ListItem Text="subscription" Value="False" Selected="True"></asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:Label ID="SubscriptionMessage" runat="server"></asp:Label>
                                <asp:PlaceHolder ID="AutoDeliveryPH" runat="server">
                                    <div style="padding:10px 5px 10px 5px;">
                                        <asp:Literal ID="AutoDeliveryIntervalLabel" runat="server" EnableViewState="false" Text="Delivery every " />
                                        <asp:DropDownList ID="AutoDeliveryInterval" runat="server" AutoPostBack="true" EnableViewState="true"></asp:DropDownList>
                                    </div>
                                </asp:PlaceHolder>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Label ID="AddProductQuantityLabel" runat="server" Text="Quantity:"></asp:Label>        
                            </th>
                            <td>
                                <cb:updowncontrol id="AddProductQuantity" runat="server" CssClass="quantityUpDown"></cb:updowncontrol>
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
                                <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="AddToBasket" />					
                                <asp:Button ID="AddProductSaveButton" runat="server" Visible="False" Text="Add To Order" OnClick="AddProductSaveButton_Click" ValidationGroup="AddToBasket"/>&nbsp;
							    <asp:Button ID="AddProductCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="AddProductCancelButton_Click" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
            </asp:Panel>
            <asp:HiddenField ID="DummyCancel" runat="server" />
            <ajaxToolkit:ModalPopupExtender ID="AddPopup" runat="server" 
                TargetControlID="AddProductId"
                PopupControlID="AddDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="DummyCancel" 
                DropShadow="false"
                PopupDragHandleControlID="AddDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>