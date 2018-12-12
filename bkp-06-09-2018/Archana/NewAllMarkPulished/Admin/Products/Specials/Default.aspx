<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Specials._Default" Title="Pricing Rules"  CodeFile="Default.aspx.cs" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Special Pricing for {0}"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <asp:HyperLink ID="AddLink" runat="server" Text="Add Special Price" NavigateUrl="AddSpecial.aspx" SkinID="AddButton"></asp:HyperLink>
        <p><asp:Localize ID="InstructionText" runat="server" Text="You can set multiple price points for this product based on a date or member group.  Special pricing must be lower than the base price of the product."></asp:Localize></p>
        <asp:GridView ID="SpecialGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="SpecialId" DataSourceID="SpecialDs" 
            AllowSorting="True" SkinID="PagedList" AllowPaging="False" EnableViewState="false" Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Price" SortExpression="Price">
                    <ItemTemplate>
                        <asp:Label ID="Price" runat="server" Text='<%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Starts" SortExpression="StartDate">
                    <ItemTemplate>
                        <asp:Label ID="StartDate" runat="server" Text='<%# GetDate(Eval("StartDate")) %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Ends" SortExpression="EndDate">
                    <ItemTemplate>
                        <asp:Label ID="EndDate" runat="server" Text='<%# GetDate(Eval("EndDate")) %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Groups">
                    <ItemTemplate>
                        <asp:Label ID="Groups" runat="server" Text='<%# GetNames(Container.DataItem) %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%# GetEditLink(Container.DataItem) %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit"></asp:Image></asp:HyperLink>
                        <asp:ImageButton ID="DeleteButton" runat="server" AlternateText="Delete" SkinID="DeleteIcon" CommandName="Delete" OnClientClick="return confirm('Are you sure you want to delete this rule?')" />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyDataMessage" runat="server" Text="There are no special prices defined for this product."></asp:Label>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
    <asp:ObjectDataSource ID="SpecialDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadForProduct" TypeName="CommerceBuilder.Products.SpecialDataSource" DataObjectTypeName="CommerceBuilder.Products.Special" DeleteMethod="Delete" SortParameterName="sortExpression">
        <SelectParameters>
            <asp:QueryStringParameter Name="productId" QueryStringField="ProductId" Type="Object" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>

