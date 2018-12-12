<%@ Page Language="C#" MasterPageFile="Product.master" Inherits="AbleCommerce.Admin.Products.EditSimilarProducts" Title="Similar Products"  CodeFile="EditSimilarProducts.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<asp:UpdatePanel ID="MainContentAjax" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <div class="pageHeader">
            <div class="caption">
                <h1><asp:Localize ID="Caption" runat="server" Text="Similar Products for {0}"></asp:Localize></h1>
            </div>
        </div>
        <asp:Panel ID="SearchFormPanel" runat="server" CssClass="searchPanel" DefaultButton="SearchButton">
            <p><asp:Localize ID="InstructionText" runat="server" Text="Similar products be presented as alternative buying choices when customers view this product.  Search for products that are similar to this one and adjust the links as needed.  Be sure to save after making your adjustments.  " EnableViewState="false" /></p>
            <table class="inputForm">
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="SearchNameLabel" runat="server" Text="Product Name:" ToolTip="Enter all or part of a product name.  Wildcard characters * and ? are accepted." />
                    </th>
                    <td>
                        <asp:TextBox ID="SearchName" runat="server" Text=""></asp:TextBox>
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="CategoryLabel" runat="server" Text="Category:" ToolTip="You can select a category to list only products meeting the critera from that category." />
                    </th>
                    <td>
                        <asp:DropDownList ID="CategoryList" runat="server" AppendDataBoundItems="True" 
                            DataTextField="Name" DataValueField="CategoryId">
                            <asp:ListItem Text="- Any Category -" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox ID="CategoryAutoComplete" runat="server" ClientIDMode="Static" Visible="false" AutoCompleteType="Disabled"/>
                        <asp:HiddenField ID="HiddenSelectedCategoryId" runat="server" ClientIDMode="Static" />
                    </td>
                </tr>
                <tr>
                    <th>
                    <cb:ToolTipLabel ID="CrossSellFilterLabel" runat="server" Text="Filter:" ToolTip="Helps you filter cross sell products" />
                    </th>
                    <td>
                        <asp:DropDownList ID="Filter" runat="server">
                            <asp:ListItem Text="Show All" Value="5"></asp:ListItem>
                            <asp:ListItem Text="Linked" Value="0" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Unlinked" Value="4"></asp:ListItem>
                            <asp:ListItem Text="Cross Linked" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Linked To" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Linked From" Value="3"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="ShowImagesLabel" runat="server" Text="Show Thumbnails:" ToolTip="When checked, product images will be displayed in the search results." />
                    </th>
                    <td>
                        <asp:CheckBox ID="ShowImages" runat="server" />
                    </td>
                </tr>
                <tr>
                    <th><cb:ToolTipLabel ID="GroupLabel" runat="server" Text="Group:" ToolTip="Search products with the selected group." /></th>
                    <td>
                        <asp:DropDownList ID="ProductGroups" runat="server" AppendDataBoundItems="true" DataTextField="Name" DataValueField="GroupId" DataSourceID="ProductGroupsDS" Width="216px">
                            <asp:ListItem Text="- Any -" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:ObjectDataSource ID="ProductGroupsDS" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="LoadNonAdminGroups" TypeName="CommerceBuilder.Users.GroupDataSource">
                        </asp:ObjectDataSource>
                    </td>
                </tr>
                <tr>
                <td></td>
                    <td>
                        <asp:Button ID="SearchButton" runat="server" Text="Search" OnClick="SearchButton_Click" />
                        <asp:Button ID="ResetButton" runat="server" Text="Reset" SkinID="CancelButton" OnClick="ResetButton_Click" />
                        <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" />                                       
                    </td>
                    <td colspan="2"></td>
                </tr>
            </table>
        </asp:Panel>
        <div class="content">
            <cb:Notification ID="SavedMessage" runat="server" Text="Similar product relationships have been saved." SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
            <cb:AbleGridView ID="SearchResultsGrid" runat="server" 
                AutoGenerateColumns="False" DataKeyNames="ProductId" GridLines="None" 
                SkinId="PagedList" DataSourceId="ProductSearchDs"
                Width="100%" Visible="False" AllowPaging="True" PageSize="20" 
                AllowSorting="True" DefaultSortExpression="Name" 
                DefaultSortDirection="Ascending" ShowWhenEmpty="False" 
                OnRowCreated="SearchResultsGrid_RowCreated"
                PagerSettings-Position="Top">
                <Columns>
                    <asp:TemplateField HeaderText="Link">
                        <ItemStyle Width="32"/>
                        <ItemTemplate>
                            <asp:DropDownList ID="CrossSellState" runat="server">
                                <asp:ListItem Text="" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Cross Linked" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Linked to" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Linked from" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Item" SortExpression="Name">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:HyperLink ID="ProductName" runat="server" Text='<%#Eval("Name")%>' SkinID="FieldHeader" /><br />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Thumbnail">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:HyperLink ID="NodeImageLink" runat="server" NavigateUrl='<%# UrlGenerator.GetBrowseUrl((int)Eval("ProductId"), CatalogNodeType.Product, (string)Eval("Name")) %>'>
                                <asp:Image ID="NodeImage" runat="server" ImageUrl='<%# Eval("ThumbnailUrl") %>' Visible='<%# !string.IsNullOrEmpty((string)Eval("ThumbnailUrl")) %>' AlternateText='<%# Eval("Name") %>' />
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Visibility">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#Eval("Visibility")%>
                            </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Groups">
                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                        <ItemTemplate>
                            <asp:Label ID="GroupLabel" runat="server" Text='<%#GetGroups(Container.DataItem) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:HyperLink ID="EmptyMessage" runat="server" Text="There are no products that match the search criteria."></asp:HyperLink>
                </EmptyDataTemplate>
            </cb:AbleGridView>
            <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" OnClientClick="this.value = 'Saving...'; this.enabled= false;" EnableViewState="false" />
            <asp:ObjectDataSource ID="ProductSearchDs" runat="server"
                OldValuesParameterFormatString="original_{0}" SelectMethod="SearchRelatedProducts" SelectCountMethod="SearchRelatedProductsCount" SortParameterName="sortExpression"
                TypeName="CommerceBuilder.Products.ProductDataSource" OnSelecting="ProductSearchDs_Selecting" EnablePaging="true" >
                <SelectParameters>
                    <asp:ControlParameter Name="productName" ControlID="SearchName" DefaultValue="" DbType="String" />
                    <asp:ControlParameter Name="categoryId" ControlID="CategoryList" DefaultValue="0" DbType="Int32" />
                    <asp:Parameter Name="crossSellFilter" Type="Object" />
                    <asp:QueryStringParameter Name="productId" QueryStringField="ProductId" Type="Int32" />
                    <asp:ControlParameter ControlID="ProductGroups" DefaultValue="0" Name="groupId" PropertyName="SelectedValue" Type="Int32" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>