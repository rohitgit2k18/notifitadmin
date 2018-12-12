<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.GiftWrap._Default" Title="Gift Wrap" CodeFile="Default.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Gift Wrap"></asp:Localize></h1>
            <div class="links">
                <cb:NavigationLink ID="ImagesLink" runat="server" Text="Images and Assets" SkinID="Button" NavigateUrl="../Assets/AssetManager.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="ProductTemplates" runat="server" Text="Product Templates" SkinID="Button" NavigateUrl="../ProductTemplates/Default.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="GiftWrap" runat="server" Text="Gift Wrap" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
            </div>
    	</div>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="grid_8 alpha">
                <div class="mainColumn">
                    <div class="content">
                        <cb:SortedGridView ID="WrapGroupGrid" runat="server" AutoGenerateColumns="False" DataSourceID="WrapGroupDs" 
                            DataKeyNames="WrapGroupId" AllowPaging="False" AllowSorting="false" Width="100%" 
                            OnRowCommand="WrapGroupGrid_RowCommand" SkinID="PagedList" DefaultSortExpression="Name">
                            <Columns>
                                <asp:TemplateField HeaderText="Wrap Group" SortExpression="Name">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="Name" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Wrap Styles">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="WrapStyles" runat="server" Text='<%# CountWrapStyles(Container.DataItem) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Products">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="Products" runat="server" Text='<%# CountProducts(Container.DataItem) %>' NavigateUrl='<%#Eval("WrapGroupId", "ViewProducts.aspx?WrapGroupId={0}")%>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-Wrap="false">
                                    <ItemTemplate>
                                        <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#Eval("WrapGroupId", "EditWrapGroup.aspx?WrapGroupId={0}")%>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" ToolTip="Edit" /></asp:HyperLink>
                                        <asp:ImageButton ID="CopyButton" runat="server" AlternateText="Copy" SkinID="CopyIcon" CommandName="Copy" ToolTip="Copy" CommandArgument='<%#Container.DataItemIndex%>' />
                                        <asp:ImageButton ID="DeleteButton" runat="server" AlternateText="Delete" SkinID="DeleteIcon" ToolTip="Delete" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'/>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="NoWrapGroupsText" runat="server" Text="There are no gift wrap groups defined."></asp:Label>
                            </EmptyDataTemplate>
                        </cb:SortedGridView>
                        <p><asp:Localize ID="InstructionText" runat="server" Text="Use Wrap Groups to define gift wrapping options, and assign them to your products."></asp:Localize></p>
                    </div>
                </div>
            </div>
            <div class="grid_4 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="addwrapgroup"><asp:Localize ID="AddCaption" runat="server" Text="Add Wrap Group" /></h2>
                        </div>
                        <div class="content">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Add" />
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <asp:Label ID="AddNameLabel" runat="server" Text="Name:" AssociatedControlID="AddName"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="AddName" runat="server" MaxLength="50"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="AddNameRequired" runat="server" ControlToValidate="AddName" ValidationGroup="Add" Text="*" ErrorMessage="Name is required." Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:Button ID="AddButton" runat="server" Text="Add" OnClick="AddButton_Click" ValidationGroup="Add" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="WrapGroupDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadAll" 
        TypeName="CommerceBuilder.Products.WrapGroupDataSource" DataObjectTypeName="CommerceBuilder.Products.WrapGroup" 
        DeleteMethod="Delete" SortParameterName="sortExpression"></asp:ObjectDataSource>
</asp:Content>