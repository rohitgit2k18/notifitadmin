<%@ Page Language="C#" MasterPageFile="Product.master" Inherits="AbleCommerce.Admin.Products.ProductDiscounts" Title="Manage Product Discounts"  CodeFile="ProductDiscounts.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Discounts for {0}"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" OnClientClick="this.value = 'Saving...'; this.enabled= false;" />
                <p><asp:Label ID="InstructionText" runat="server" Text="Check the discounts that should be attached to this product. If you need to add or change a discount, <a href='../Marketing/Discounts/Default.aspx'>click here</a>."></asp:Label></p>
                <cb:Notification ID="SavedMessage" runat="server" Text="Associated discounts have been updated." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <asp:GridView ID="DiscountGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="VolumeDiscountId" DataSourceID="DiscountDs" SkinID="PagedList" AllowPaging="False"
                    AllowSorting="false" EnableViewState="false" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="Attached">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:CheckBox ID="Attached" runat="server" Checked='<%# IsAttached((int)Eval("VolumeDiscountId")) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CheckBoxField DataField="IsGlobal" HeaderText="Global" ReadOnly="True" SortExpression="IsGlobal" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" HeaderStyle-HorizontalAlign="Left" />
                        <asp:TemplateField HeaderText="Discount" SortExpression="IsValueBased" HeaderStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <asp:Label ID="QuantityLabel" runat="server" Visible='<%# !((bool)Eval("IsValueBased")) %>' Text="Quantity" SkinID="fieldheader"></asp:Label>
                                <asp:Label ID="ValueLabel" runat="server" Visible='<%# (bool)Eval("IsValueBased") %>' Text="Value" SkinID="fieldheader"></asp:Label><br />
                                <asp:Label ID="Levels" runat="server" Text='<%# GetLevels((VolumeDiscount)Container.DataItem) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Groups">
                            <ItemTemplate>
                                <asp:Label ID="Groups" runat="server" Text='<%# GetNames((VolumeDiscount)Container.DataItem) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyMessage" runat="server" Text="There are no discounts defined for your store."></asp:Label>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="DiscountDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Marketing.VolumeDiscountDataSource"
        SortParameterName="sortExpression">
    </asp:ObjectDataSource>
</asp:Content>