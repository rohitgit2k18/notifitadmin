<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Kits.AttachComponent" Title="Attach or Copy Component"  CodeFile="AttachComponent.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Attach or Copy Component"></asp:Localize></h1>
        </div>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="searchPanel">
                <p><asp:Label ID="InstructionText" runat="server" Text="Enter all or part of the name(s) to locate the desired component to attach or copy for this product."></asp:Label></p>
                <table class="inputForm compact">
                    <tr>
                        <th>
                            <asp:Label ID="KitComponentNameLabel" runat="server" Text="Existing Component:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="KitComponentName" runat="server" Text=""></asp:TextBox>
                        </td>
                        <th>
                            <asp:Label ID="ProductNameLabel" runat="server" Text="Product within Component:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="ProductName" runat="server" Text=""></asp:TextBox>
                        </td>
                        
                        <td>
                            <asp:Button ID="SearchButton" runat="server" Text="Search" SkinID="SaveButton" OnClick="SearchButton_Click" />
                            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content">
                <cb:AbleGridView ID="SearchResultsGrid" runat="server" AutoGenerateColumns="false" DataSourceID="ComponentDs" ShowHeader="true" ShowFooter="false"
                    DataKeyNames="KitComponentId" OnRowCommand="SearchResultsGrid_RowCommand" SkinID="PagedList" AllowSorting="true"
                    AllowPaging="true" PageSize="20" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle VerticalAlign="Top" Width="200px" />
                            <ItemTemplate>
                                <asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type">
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Width="120px" />
                            <ItemTemplate>
                                <asp:Label ID="InputType" runat="server" Text='<%#FixInputTypeName(Eval("InputType").ToString())%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Contains" ItemStyle-VerticalAlign="Top">
                            <ItemTemplate>
                                <asp:DataList ID="ProductList" runat="server" DataSource='<%#Eval("KitProducts")%>'>
                                    <ItemTemplate>
                                        <asp:Label ID="Quantity" runat="server" Text='<%#Eval("Quantity", "[{0}]")%>' /> 
                                        <asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>' /> @ 
                                        <asp:Label ID="CalculatedPrice" runat="server" Text='<%#((decimal)Eval("CalculatedPrice")).LSCurrencyFormat("lc")%>' />
                                        <asp:Label ID="EachLabel" runat="server" Text="ea." />
                                    </ItemTemplate>
                                </asp:DataList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" Width="80px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="AttachComponent" runat="server" CommandName="Attach" CommandArgument='<%#Container.DataItemIndex%>' SkinID="LinkIcon" AlternateText="Attach" ToolTip="Attach" Visible='<%#!((KitComponent)Container.DataItem).IsAttached(_ProductId)%>' />
                                <asp:ImageButton ID="CopyComponent" runat="server" CommandName="Copy" CommandArgument='<%#Container.DataItemIndex%>' SkinID="CopyIcon" AlternateText="Copy" ToolTip="Copy" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyMessage" runat="server" Text="There are no components that match the search parameters."></asp:Label>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="ComponentDs" runat="server" DataObjectTypeName="CommerceBuilder.Products.KitComponent"
        OldValuesParameterFormatString="original_{0}" SelectMethod="Search" SortParameterName="sortExpression"
        TypeName="CommerceBuilder.Products.KitComponentDataSource" SelectCountMethod="SearchCount" EnablePaging="true">
        <SelectParameters>
            <asp:ControlParameter Name="productName" Type="String" ControlID="ProductName" PropertyName="Text" />
            <asp:ControlParameter Name="componentName" Type="String" ControlID="KitComponentName" PropertyName="Text" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>