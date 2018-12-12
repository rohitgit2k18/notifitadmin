<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RecentOrders.ascx.cs" Inherits="AbleCommerce.Admin.Dashboard.RecentOrders" %>
<div class="section">
    <div class="header">
        <h2>Recent Orders</h2>
    </div>
    <div class="content">
        <asp:GridView ID="RecentOrdersGrid" runat="server" SkinID="PagedList" AutoGenerateColumns="false" Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Order">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <a href="Orders/ViewOrder.aspx?OrderNumber=<%#Eval("OrderNumber")%>"><%#Eval("OrderNumber")%></a>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%#Eval("OrderDate", "{0:g}")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%#Eval("OrderStatus.Name")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Name">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%#Eval("BillToFirstName")%> <%#Eval("BillToLastName")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Amount">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <%#((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc")%>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <p><asp:Localize ID="NoOrdersMessage" runat="server" Text="No orders have been placed."></asp:Localize></p>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</div>