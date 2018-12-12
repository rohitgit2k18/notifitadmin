<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.People.Users.OrderHistoryDialog" EnableViewState="False" CodeFile="OrderHistoryDialog.ascx.cs" %>
<div class="content">   
    <asp:UpdatePanel ID="OrderHistoryAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>        
        <cb:SortedGridView ID="OrderGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="True" PageSize="10" 
            AutoGenerateColumns="False" DataKeyNames="OrderId"             
            OnRowDataBound="OrderGrid_RowDataBound"  EnableViewState="True"  OnPageIndexChanging="OrderGrid_PageIndexChanging">
            <Columns>                
                <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status" SortExpression="OrderStatusId">
                    <ItemStyle HorizontalAlign="center" Height="30px" />
                    <ItemTemplate>
                        <asp:Label ID="OrderStatus" runat="server" Text='<%# GetOrderStatus(Eval("OrderStatusId")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>                
                <asp:TemplateField HeaderText="Amount" SortExpression="TotalCharges">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="Label5" runat="server" Text='<%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("OrderDate", "{0:d}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Payment">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phPaymentStatus" runat="server"></asp:PlaceHolder>
                        <asp:Label ID="PaymentStatus" runat="server" Text='<%# GetPaymentStatus(Container.DataItem) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Shipment">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phShipmentStatus" runat="server"></asp:PlaceHolder>
                        <asp:Label ID="ShipmentStatus" runat="server" Text='<%# Eval("ShipmentStatus") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:HyperLink ID="DetailsLink" runat="server" Text="details" SkinID="Link" NavigateUrl='<%# String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber")) %>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyMessage" runat="server" Text="No recent orders."></asp:Label>
            </EmptyDataTemplate>
        </cb:SortedGridView>   
        </ContentTemplate>
    </asp:UpdatePanel>   
</div>