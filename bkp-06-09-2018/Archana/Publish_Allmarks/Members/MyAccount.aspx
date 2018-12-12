<%@ Page Title="My Account" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MyAccount.aspx.cs" Inherits="AbleCommerce.Members.MyAccount" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_mainPage" class="mainContentWrapper"> 
        <div class="section">
            <div class="content">
                <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                <div class="tabpane">
                    <cb:ExGridView ID="OrderGrid" runat="server" AutoGenerateColumns="False" Width="100%" SkinID="PagedList" AllowPaging="true" PageSize="20" OnPageIndexChanging="OrderGrid_PageIndexChanging">
                        <Columns>
                            <asp:TemplateField HeaderText="Order #">
                                <ItemStyle CssClass="orderNumber" />
                                <HeaderStyle CssClass="orderNumber" />
                                <ItemTemplate>
                                    <%# Eval("OrderNumber") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemStyle CssClass="orderItems" />
                                <HeaderStyle CssClass="orderDate" />
                                <ItemTemplate>
                                    <%# Eval("OrderDate", "{0:g}") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Ship To">
                                <ItemStyle CssClass="orderItems" />
                                <HeaderStyle CssClass="ordershipto" />
                                <ItemTemplate>
                                    <%#GetShipTo(Container.DataItem)%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemStyle CssClass="orderStatus" />
                                <HeaderStyle CssClass="orderStatus" />
                                <ItemTemplate>
                                    <%#GetOrderStatus(Container.DataItem)%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Items">
                                <ItemStyle CssClass="orderItems" />
                                <HeaderStyle CssClass="orderItems" />
                                <ItemTemplate>
                                    <asp:Repeater ID="ItemsRepeater" runat="server" DataSource='<%#AbleCommerce.Code.OrderHelper.GetVisibleProducts(Container.DataItem)%>'>
                                        <HeaderTemplate><ul class="orderItemsList"></HeaderTemplate>
                                        <ItemTemplate><li><%#Eval("Quantity")%> of: <%#GetOrderItemName(Container.DataItem)%></li></ItemTemplate>
                                        <FooterTemplate></ul></FooterTemplate>
                                    </asp:Repeater>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemStyle CssClass="orderActions" />
                                <HeaderStyle CssClass="orderActions" />
                                <ItemTemplate>
                                    <asp:HyperLink ID="ViewOrderLink" runat="server" Text="View Order" NavigateUrl='<%#Eval("OrderNumber", "~/Members/MyOrder.aspx?OrderNumber={0}")%>' CssClass="button"></asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:localize ID="EmptyOrderHistory" runat="server" Text="You have not placed any orders."></asp:localize>
                        </EmptyDataTemplate>
                    </cb:ExGridView>
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>