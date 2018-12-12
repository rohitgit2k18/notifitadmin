<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.People.Users.CurrentBasketDialog" CodeFile="CurrentBasketDialog.ascx.cs" %>
<div class="section">
    <div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Current Basket"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:GridView ID="BasketItemsGrid" runat="server" AutoGenerateColumns="False"
            DataKeyNames="BasketItemId" AllowPaging="False" SkinID="PagedList" Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Quantity" ItemStyle-HorizontalAlign="center">
                    <ItemTemplate>
                        <asp:Label ID="Quantity" runat="server" Text='<%#Eval("Quantity")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Item">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:Label ID="Name" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="SKU">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:Label ID="SKU" runat="server" Text='<%# Eval("SKU") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Price">
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <asp:Label ID="Price" runat="server" Text='<%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="NoBasketItemsText" runat="server" Text="There are no items in the current user basket."></asp:Label>
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:HyperLink ID="EditBasketLink" runat="server" NavigateUrl="~/Admin/Orders/Create/CreateOrder2.aspx?UID=" SkinID="AddButton" Text="Create Order"></asp:HyperLink>
    </div>
</div>