<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Orders.Print.Invoices" Title="Invoices" CodeFile="Invoices.aspx.cs" %>
<%@ Register Src="OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/Admin/UserControls/PrintableLogo.ascx" TagName="PrintableLogo" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader noPrint">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Invoices"></asp:Localize></h1>
        </div>
    </div>
    <div class="content noPrint">
        <p><asp:Label ID="OrderListLabel" runat="server" Text="Includes Order Numbers:" SkinID="FieldHeader"></asp:Label><asp:Label ID="OrderList" runat="server" Text=""></asp:Label></p>
        <p><asp:Localize ID="PrintInstructions" runat="server" Text="This document includes a printable stylesheet. Your browser will print with appropriate styles and page breaks if needed. Website headers, footers, and this message will not be printed."></asp:Localize></p>
        <asp:Button ID="Print" runat="server" Text="Print" OnClick="Print_Click" />
        <asp:HyperLink ID="Back" runat="server" CssClass="button" Text="Back" NavigateUrl="~/Admin/Orders/Default.aspx" />
    </div>
    <div class="content invoice">
        <asp:Repeater ID="OrderRepeater" runat="server">
            <ItemTemplate>
                <table align="center" class="form<%# (Container.ItemIndex < (OrderCount - 1)) ? " breakAfter" : string.Empty %>" cellpadding="6" cellspacing="0" border="1">
                    <tr>
                        <td colspan="4" valign="middle">
                            <div style="float:left">
                                <div class="logo">  
                                    <uc:PrintableLogo ID="Logo" runat="server" />
                                </div>
							    <span class="inlineCaption"><%#AbleContext.Current.Store.Name%></span>
							    <br />
                                <%# AbleContext.Current.Store.DefaultWarehouse.FormatAddress(true) %>
                            </div>
                            <div style="float:right">
                                <h1 class="invoice">INVOICE</h1>
                                <asp:Label ID="OrderNumberLabel" runat="server" Text="Order Number:" SkinID="FieldHeader"></asp:Label>
                                <asp:Label ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>'></asp:Label><br />
                                <asp:Label ID="OrderDateLabel" runat="server" Text="Order Date:" SkinID="FieldHeader"></asp:Label>
                                <asp:Label ID="OrderDate" runat="server" Text='<%# Eval("OrderDate", "{0:g}") %>'></asp:Label><br />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:10px;text-align:center;font-weight:bold" valign="top">
                            S O L D &nbsp; T O
                        </td>
                        <td valign="middle" width="50%">
                            <%# GetBillToAddress(Container.DataItem) %>
                        </td>
                        <td style="width:10px;text-align:center;font-weight:bold" valign="top">
                            S H I P &nbsp; T O
                        </td>
                        <td valign="middle" width="50%">
                            <%# GetShipToAddress(Container.DataItem) %>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" class="dataSheet">
                            <asp:GridView ID="OrderItems" runat="server" ShowHeader="true"
                                AutoGenerateColumns="false" CellPadding="0" CellSpacing="0" GridLines="none" 
                                Width="100%" DataSource='<%#GetItems(Container.DataItem)%>' SkinID="PrintableList" OnDataBinding="OrderItems_DataBinding">
                                <Columns>
                                    <asp:BoundField DataField="Quantity" HeaderText="Quantity" ItemStyle-HorizontalAlign="Center" />
                                    <asp:TemplateField HeaderText="SKU">                                    
                                        <ItemStyle HorizontalAlign="Center"/>
                                        <ItemTemplate>
                                            <%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Tax">                                    
                                        <ItemStyle HorizontalAlign="Center" Width="40px" />
                                        <ItemTemplate>
                                            <%#TaxHelper.GetTaxRate(((OrderItem)Container.DataItem).Order, (OrderItem)Container.DataItem).ToString("0.####")%>%
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item">
                                        <ItemTemplate>
                                            <uc:OrderItemDetail ID="OrderItemDetail1" runat="server" OrderItem='<%#(OrderItem)Container.DataItem%>' ShowAssets="False" LinkProducts="False"  />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price">
                                        <ItemStyle HorizontalAlign="right" width="80px" />
                                        <ItemTemplate>
                                            <asp:Label ID="Price" runat="server" Text='<%#AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice((OrderItem)Container.DataItem).LSCurrencyFormat("lc")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <br />                        
                            <table width="100%" cellpadding="0" cellspacing="0" class="dataSheet">
                                <tr>
                                    <th align="right">
                                        <asp:Label ID="SubtotalLabel" runat="server" Text="Product Subtotal:" />
                                    </th>
                                    <td align="right" width="80px">
                                        <%# GetProductTotal(Container.DataItem).LSCurrencyFormat("lc") %>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">
                                        <asp:Label ID="ShippingTotalLabel" runat="server" Text="Shipping & Handling:" />
                                    </th>
                                    <td align="right" width="80px">
                                        <%# GetShippingTotal(Container.DataItem).LSCurrencyFormat("lc") %>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">
                                        <asp:Label ID="TaxTotalLabel" runat="server" Text="Taxes:" />
                                    </th>
                                    <td align="right" width="80px">
                                        <%# GetTotal(Container.DataItem, OrderItemType.Tax).LSCurrencyFormat("lc") %>
                                    </td>
                                </tr>
                                <tr id="trAdjustments" runat="server" visible='<%# ShowAdjustmentsRow(Container.DataItem) %>'>
                                    <th align="right">
                                        <asp:Label ID="AdjustmetnsLabel" runat="server" Text="Adjustments:" />
                                    </th>
                                    <td align="right" width="80px">
                                        <%# GetAdjustmentsTotal(Container.DataItem).LSCurrencyFormat("lc")%>
                                    </td>
                                </tr>
                                <tr class="totalRow">
                                    <th align="right">
                                        <asp:Label ID="TotalLabel" runat="server" Text="Total:" />
                                    </th>
                                    <td align="right" width="80px">
                                        <%# GetTotal(Container.DataItem).LSCurrencyFormat("lc") %>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>