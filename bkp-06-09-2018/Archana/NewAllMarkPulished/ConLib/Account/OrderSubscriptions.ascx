<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderSubscriptions.ascx.cs" Inherits="AbleCommerce.ConLib.Account.OrderSubscriptions" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays subscriptions for a given order</summary>
</conlib>
--%>
<asp:Panel ID="SubscriptionsPanel" runat="server" CssClass="widget orderSubscriptions" Visible="false">
	<div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Subscriptions"></asp:Localize></h2>
    </div>
	<div class="content">
        <cb:ExGridView ID="SubscriptionsGrid" runat="server" AutoGenerateColumns="False" SkinID="ItemList">
            <Columns>
                <asp:TemplateField HeaderText="Subscription Plan">
                    <HeaderStyle CssClass="subscription" />
                    <ItemStyle CssClass="subscription" />
                    <ItemTemplate>
                        <asp:Label ID="SubscriptionPlan" runat="server" text='<%#Eval("SubscriptionPlan.Name")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Active">
                    <HeaderStyle CssClass="subscriptionStatus" />
                    <ItemStyle CssClass="subscriptionStatus" />
                    <ItemTemplate>
                        <asp:CheckBox ID="Active" runat="server" Checked='<%#Eval("IsActive")%>' Enabled="False" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Expiration">
                    <HeaderStyle CssClass="subscriptionExpiration" />
                    <ItemStyle CssClass="subscriptionExpiration" />
                    <ItemTemplate>
                        <asp:Literal ID="Expiration" runat="server" text='<%#GetExpirationDate(Container.DataItem) %>'></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </cb:ExGridView>
	</div>
</asp:Panel>