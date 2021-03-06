<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.People.Users.PurchaseHistoryDialog" CodeFile="PurchaseHistoryDialog.ascx.cs" %>
<div class="content">
    <table cellspacing="0" class="pagedList" border="1">
        <tr>
            <th><asp:Label ID="FirstOrderLabel" runat="server" SkinID="FieldHeader" Text="First Order" EnableViewState="false"/></th>
            <th><asp:Label ID="PaidOrdersLabel" runat="server" SkinID="FieldHeader" Text="Paid Orders" EnableViewState="false"></asp:Label></th>
            <th><asp:Label ID="PendingOrdersLabel" runat="server" SkinID="FieldHeader" Text="Pending Orders" EnableViewState="false"></asp:Label></th>
        </tr>
        <tr>
            <td align="center"><asp:Label ID="FirstOrder" runat="server" Text="-"></asp:Label></td>
            <td align="center"><asp:Label ID="PaidOrders" runat="server"  Text="-"></asp:Label></td>
            <td align="center"><asp:Label ID="PendingOrders" runat="server" Text="-"></asp:Label></td>
        </tr>
    </table>
</div>
<div class="section" id="PaidOrdersPanel" runat="server">
    <div class="header">
        <h2 class="orderhistory"><asp:Localize ID="Caption" runat="server" Text="Paid Orders"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="PaidOrdersAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <cb:SortedGridView ID="PaidOrderGrid" runat="server" DataSourceID="PaidOrdersDs" SkinID="PagedList" Width="100%" AllowPaging="false"  
                    AutoGenerateColumns="False" DataKeyNames="OrderId" EnableViewState="True" AllowSorting="true" OnSorting="PaidOrderGrid_Sorting" DefaultSortDirection="Descending" DefaultSortExpression="OrderNumber">
                    <Columns>                
                        <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                            <ItemStyle HorizontalAlign="center" />
                            <ItemTemplate>                            
                                <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                            <ItemStyle HorizontalAlign="center" />
                            <ItemTemplate>
                                <asp:Label ID="OrderDate" runat="server" Text='<%# Eval("OrderDate", "{0:g}") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" SortExpression="ProductName">
                            <HeaderStyle HorizontalAlign="left" />
                            <ItemStyle HorizontalAlign="left" />
                            <ItemTemplate>
                                <asp:Label ID="ProductName" runat="server" Text='<%# Eval("ProductName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Price" SortExpression="PurchasePrice">
                            <ItemStyle HorizontalAlign="right" />
                            <ItemTemplate>
                                <asp:Label ID="PurchasePrice" runat="server" Text='<%# ((decimal)Eval("PurchasePrice")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity" SortExpression="Quantity">
                            <ItemStyle HorizontalAlign="center" />
                            <ItemTemplate>
                                <asp:Label ID="Quantity" runat="server" Text='<%# Eval("Quantity") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total" SortExpression="Total" >
                            <ItemStyle HorizontalAlign="right" />
                            <ItemTemplate>
                                <asp:Label ID="Total" runat="server" Text='<%# ((decimal)Eval("Total")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyMessage" runat="server" Text="No recent orders."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
                <asp:ObjectDataSource ID="PaidOrdersDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetUserPurchaseHistory" 
                    TypeName="CommerceBuilder.Reporting.ReportDataSource" SortParameterName="sortExpression" EnablePaging="false">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="userId" DefaultValue="0" QueryStringField="UserId" Type="Int32" />
                        <asp:Parameter Name="forPaidOrders" Type="boolean" DefaultValue="true" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <table class="report">
                    <tr>
                        <td>
                            <asp:Label ID="GrossProductLabel" runat="server" SkinID="FieldHeader" Text="Gross Product" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="DiscountLabel" runat="server" SkinID="FieldHeader" Text="Discounts" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="CouponLabel" runat="server" SkinID="FieldHeader" Text="Coupons" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="NetProductLabel" runat="server" SkinID="FieldHeader" Text="Net Product" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="ProfitLabel" runat="server" SkinID="FieldHeader" Text="Profit" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="TaxesLabel" runat="server" SkinID="FieldHeader" Text="Taxes" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="ShippingLabel" runat="server" SkinID="FieldHeader" Text="Shipping" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="OtherLabel" runat="server" SkinID="FieldHeader" Text="Other" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="PurchasesToDateLabel" runat="server" SkinID="FieldHeader" Text="Total Charges" EnableViewState="false"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="TotalPaymentsLabel" runat="server" SkinID="FieldHeader" Text="Total Payments" EnableViewState="false"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="GrossProduct" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Discount" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Coupon" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="NetProduct" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Profit" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Taxes" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Shipping" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="Other" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="PurchasesToDate" runat="server" Text="-"></asp:Label>
                        </td>
                        <td>
                            <asp:Label ID="TotalPayments" runat="server" Text="-"></asp:Label>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>
<div class="section" id="UnpaidOrdersPanel" runat="server">
    <div class="header">
        <h2 class="orderhistory"><asp:Localize ID="Caption2" runat="server" Text="Unpaid Orders"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="UnPaidOrdersAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <cb:SortedGridView ID="UnPaidOrderGrid" runat="server" DataSourceID="UnpaidOrdersDs" SkinID="PagedList" Width="100%" AllowPaging="false"  
                    AutoGenerateColumns="False" DataKeyNames="OrderId" EnableViewState="True" AllowSorting="true" OnSorting="UnPaidOrderGrid_Sorting"  DefaultSortDirection="Descending" DefaultSortExpression="OrderNumber">
                    <Columns>                
                        <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                            <ItemStyle HorizontalAlign="center" />
                            <ItemTemplate>                            
                                <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                            <ItemStyle HorizontalAlign="center" />
                            <ItemTemplate>
                                <asp:Label ID="OrderDate" runat="server" Text='<%# Eval("OrderDate", "{0:g}") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" SortExpression="ProductName">
                            <HeaderStyle HorizontalAlign="left" />
                            <ItemStyle HorizontalAlign="left" />
                            <ItemTemplate>
                                <asp:Label ID="ProductName" runat="server" Text='<%# Eval("ProductName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Price" SortExpression="PurchasePrice">
                            <ItemStyle HorizontalAlign="right" />
                            <ItemTemplate>
                                <asp:Label ID="PurchasePrice" runat="server" Text='<%# ((decimal)Eval("PurchasePrice")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity" SortExpression="Quantity">
                            <ItemStyle HorizontalAlign="center" />
                            <ItemTemplate>
                                <asp:Label ID="Quantity" runat="server" Text='<%# Eval("Quantity") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total" SortExpression="Total" >
                            <ItemStyle HorizontalAlign="right" />
                            <ItemTemplate>
                                <asp:Label ID="Total" runat="server" Text='<%# ((decimal)Eval("Total")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                <EmptyDataTemplate>
                    <asp:Label ID="EmptyMessage" runat="server" Text="No recent orders."></asp:Label>
                </EmptyDataTemplate>
            </cb:SortedGridView>
            <asp:ObjectDataSource ID="UnpaidOrdersDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetUserPurchaseHistory" 
                TypeName="CommerceBuilder.Reporting.ReportDataSource" SortParameterName="sortExpression" EnablePaging="false">
                <SelectParameters>
                    <asp:QueryStringParameter Name="userId" DefaultValue="0" QueryStringField="UserId" Type="Int32" />
                    <asp:Parameter Name="forPaidOrders" Type="boolean" DefaultValue="false" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <table class="report">
                <tr>
                    <td>
                        <asp:Label ID="UnpaidGrossProductLabel" runat="server" SkinID="FieldHeader" Text="Gross Product" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidDiscountLabel" runat="server" SkinID="FieldHeader" Text="Discounts" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidCouponLabel" runat="server" SkinID="FieldHeader" Text="Coupons" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidNetProductLabel" runat="server" SkinID="FieldHeader" Text="Net Product" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidProfitLabel" runat="server" SkinID="FieldHeader" Text="Profit" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidTaxesLabel" runat="server" SkinID="FieldHeader" Text="Taxes" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidShippingLabel" runat="server" SkinID="FieldHeader" Text="Shipping" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidOtherLabel" runat="server" SkinID="FieldHeader" Text="Other" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidPurchasedToDateLabel" runat="server" SkinID="FieldHeader" Text="Total Charges" EnableViewState="false"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="UnpaidTotalPaymentsLabel" runat="server" SkinID="FieldHeader" Text="Pending Payments" EnableViewState="false"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>    
                        <asp:Label ID="UnpaidGrossProduct" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidDiscount" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidCoupon" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidNetProduct" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidProfit" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidTaxes" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidShipping" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidOther" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidPurchasedToDate" runat="server" Text="-"></asp:Label>
                    </td>
                    <td>    
                        <asp:Label ID="UnpaidTotalPayments" runat="server" Text="-"></asp:Label>
                    </td>
                </tr>
            </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>    
</div>