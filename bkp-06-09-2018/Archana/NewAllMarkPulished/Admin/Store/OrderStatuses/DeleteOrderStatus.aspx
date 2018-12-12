<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.OrderStatuses.DeleteOrderStatus" Title="Delete Order Status"  CodeFile="DeleteOrderStatus.aspx.cs" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Delete {0}" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <div class="grid_6 alpha">
        <div class="leftColumn">
            <asp:UpdatePanel ID="EditAjax" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                    <p><asp:Label ID="InstructionText" runat="server" Text="This order status has one or more associated orders.  Indicate what order status these orders should be changed to when {0} is deleted." EnableViewState="false"></asp:Label></p>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Label ID="NameLabel" runat="server" Text="Move to OrderStatus:" AssociatedControlID="OrderStatusList" ToolTip="New OrderStatus for associated Orders"></asp:Label><br />
                            </th>
                            <td>
                                <asp:DropDownList ID="OrderStatusList" runat="server" DataTextField="Name" DataValueField="OrderStatusId" AppendDataBoundItems="True">
                                    <asp:ListItem Value="" Text="-- none --"></asp:ListItem>
                                </asp:DropDownList><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="OrderStatusRequired" runat="server" ControlToValidate="OrderStatusList"
                                        Display="Static" ErrorMessage="You must select an OrderStatus to assign the Orders to." Text="*"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="DeleteButton" runat="server" Text="Delete" OnClick="DeleteButton_Click" />
								<asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="grid_6 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="OrdersCaption" runat="server" Text="Associated Orders"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:UpdatePanel ID="PagingAjax" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <cb:SortedGridView ID="OrdersGrid" runat="server" DataSourceID="OrdersDs" AllowPaging="True" 
                                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="OrderId" PageSize="20" 
                                SkinID="PagedList" DefaultSortExpression="OrderNumber" Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="Order" SortExpression="OrderNumber">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' NavigateUrl='<%#String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemTemplate>
                                            <%# Eval("OrderDate") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total" SortExpression="TotalCharges">
                                        <HeaderStyle HorizontalAlign="Right" />
                                        <ItemStyle HorizontalAlign="Right" />
                                        <ItemTemplate>
                                            <%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <asp:Label ID="EmptyMessage" runat="server" Text="There are no orders associated with this order status."></asp:Label>
                                </EmptyDataTemplate>
                            </cb:SortedGridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <asp:ObjectDataSource ID="OrdersDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}" 
                SelectCountMethod="CountForOrderStatus" SelectMethod="LoadForOrderStatus" 
                SortParameterName="sortExpression" TypeName="CommerceBuilder.Orders.OrderDataSource">
                <SelectParameters>
                    <asp:QueryStringParameter Name="orderStatusId" QueryStringField="OrderStatusId"
                        Type="Object" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </div>
    </div>
</asp:Content>