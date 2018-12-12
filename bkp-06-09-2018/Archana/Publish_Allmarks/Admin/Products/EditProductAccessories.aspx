<%@ Page Language="C#" MasterPageFile="Product.master" Inherits="AbleCommerce.Admin.Products.EditProductAccessories"
    Title="Product Accessories" CodeFile="EditProductAccessories.aspx.cs" AutoEventWireup="True" %>

<%@ Register Src="../UserControls/FindAssignProducts.ascx" TagName="FindAssignProducts"
    TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="Upsell Products for '{0}'"></asp:Localize></h1>
        </div>
    </div>
    <asp:Panel ID="FindAssignPanel" runat="server" Visible="false">
        <uc1:FindAssignProducts ID="FindAssignProducts1" runat="server" AssignmentTable="ac_UpsellProducts" AssignmentStatus="AssignedProducts" />
    </asp:Panel>
    <asp:Panel ID="UpsellProductsPanel" runat="server">
        <div class="content aboveGrid">
            <p><asp:Literal ID="InstructionText" runat="server" Text="Use the Find And Assign option to locate and assign products to be marked as upsell for {0}.  Upsell products will be highlighted when this product is added to the basket."></asp:Literal></p>
            <asp:Button ID="FindAssignButton" runat="server" Text="Find and Assign" OnClick="FindAssignButton_Click" />
        </div>
        <div class="content">
            <asp:UpdatePanel ID="PageAjax" runat="server">
                <ContentTemplate>
                    <cb:AbleGridView ID="UpsellProductGrid" runat="server" AutoGenerateColumns="False"
                        DataSourceID="UpsellProductsDs" DataKeyNames="ChildProductId" Width="100%" SkinID="PagedList"
                        OnRowCommand="UpsellProductGrid_RowCommand" OnRowDeleting="UpsellProductGrid_RowDeleting"
                        ShowWhenEmpty="False" AllowMultipleSelections="False" TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching products"
                        AllowPaging="True" PageSize="20">
                        <Columns>
                            <asp:TemplateField HeaderText="Order">
                                <ItemStyle HorizontalAlign="center" Width="60px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="UpButton" runat="server" SkinID="UpIcon" CommandName="MoveUp"
                                        CommandArgument='<%#Container.DataItemIndex%>' AlternateText="Up" />
                                    <asp:ImageButton ID="DownButton" runat="server" SkinID="DownIcon" CommandName="MoveDown"
                                        CommandArgument='<%#Container.DataItemIndex%>' AlternateText="Down" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate>
                                    <asp:HyperLink ID="ProductName2" runat="server" Text='<%#Eval("ChildProduct.Name")%>'
                                        NavigateUrl='<%#Eval("ChildProductId", "EditProduct.aspx?ProductId={0}")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Groups">
                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                                <ItemTemplate>
                                    <asp:Label ID="GroupLabel" runat="server" Text='<%#GetGroups(Eval("ChildProduct")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Visibility" SortExpression="VisibilityId">
                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                                <ItemTemplate>
                                    <asp:LinkButton ID="V" runat="server" ToolTip='<%#string.Format("Visibility : {0}",Eval("ChildProduct.Visibility"))%>'
                                        CommandName="Do_Pub" CommandArgument='<%#Eval("Id")%>'>
                                    <img src="<%# GetVisibilityIconUrl(Eval("ChildProduct")) %>" border="0" alt="<%#Eval("ChildProduct.Visibility")%>" />
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="RemoveButton2" runat="server" SkinID="DeleteIcon" CommandName="Delete"
                                        AlternateText="Remove" ToolTip="Remove" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Literal ID="EmptyMessage" runat="server" Text="This product does not have any upsell products."></asp:Literal>
                        </EmptyDataTemplate>
                    </cb:AbleGridView>
                    <asp:ObjectDataSource ID="UpsellProductsDs" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="LoadForProduct" TypeName="CommerceBuilder.Products.UpsellProductDataSource">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="productId" QueryStringField="ProductId" Type="Object" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </asp:Panel>
</asp:Content>
