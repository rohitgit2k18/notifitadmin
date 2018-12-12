<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Shipping.Providers.ProviderShipMethods" CodeFile="ProviderShipMethods.ascx.cs" %>
<asp:UpdatePanel runat="server">
    <ContentTemplate>
        <asp:Panel ID="ViewPanel" runat="server" CssClass="section">
            <div class="header">
                <h2><asp:Localize ID="ProviderShipMethodsConfig" runat="server" Text="Configured Shipping Methods"></asp:Localize></h2>
            </div>
            <div class="content">
                <asp:GridView ID="ShipMethodGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="ShipMethodId" width="100%" OnRowDeleting="ShipMethodGrid_RowDeleting" SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="Delete">
                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="DeleteCheckbox" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="NameLink" runat="server" NavigateUrl='<%#GetEditUrl(Container.DataItem)%>' Text='<%# Eval("Name") %>'></asp:HyperLink>
                            </ItemTemplate>        
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Warehouses" ItemStyle-Width="200px">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="WarehouseLabel" runat="server" Text='<%#GetWarehouseNames(Container.DataItem)%>'></asp:Label>
                            </ItemTemplate>        
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Zones" ItemStyle-Width="200px">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="ZoneLabel" runat="server" Text='<%#GetZoneNames(Container.DataItem)%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False" >
                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                            <ItemTemplate>
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#GetEditUrl(Container.DataItem)%>'><asp:Image ID="EditIcon" SkinID="Editicon" runat="server" /></asp:HyperLink>
                                <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" /></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No ship methods are configured for this gateway.
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:Button ID="MultipleRowDelete" runat="server" Text="Delete Selected" OnClick="MultipleRowDelete_Click" OnClientClick="return confirm('Are you sure you want to delete the selected ship methods?')" />
            </div>
        </asp:Panel>
        <asp:Panel ID="AddPanel" runat="server" CssClass="section">
            <div class="header">
                <h2><asp:Localize ID="AddShipMethodCaption" runat="server" Text="Add Shipping Method"></asp:Localize></h2>
            </div>
            <div class="content">
                <asp:CheckBoxList ID="ShipMethodList" runat="server">                    
                </asp:CheckBoxList>
                <asp:Button ID="AddShipMethodButton" runat="server" Text="Add" OnClick="AddShipMethodButton_Click" />
            </div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>