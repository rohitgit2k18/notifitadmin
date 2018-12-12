<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Website.ContentPages._Default" Title="Manage Webpages" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:UpdatePanel ID="ContentAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Manage Webpages"></asp:Localize></h1>
	            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="website" />
                </div>
            </div>
            <div class="searchPanel">
                <table class="inputForm">
                    <tr>
                        <th>
                            <asp:Label ID="AlphabetRepeaterLabel" AssociatedControlID="AlphabetRepeater" runat="server"
                                Text="Quick Search:" SkinID="FieldHeader"></asp:Label>
                        </th>
                        <td>
                            <asp:Repeater runat="server" ID="AlphabetRepeater" OnItemCommand="AlphabetRepeater_ItemCommand">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" ID="LinkButton1" CommandName="Display" CommandArgument="<%#Container.DataItem%>"
                                        Text="<%#Container.DataItem%>" ValidationGroup="Search" />
                                </ItemTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content">
                <asp:Button ID="NewPageButton" runat="server" Text="Add Webpage" OnClick="NewPageButton_Click" SkinID="AddButton" />
                <cb:AbleGridView ID="WebpagesGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="WebpageId"
                    DataSourceID="WebpagesDs" AllowPaging="true" AllowSorting="True" PageSize="20"
                    TotalMatchedFormatString=" {0} webpages matched" SkinID="PagedList" Width="100%"
                    PagerSettings-Position="Top" OnRowCommand="WebpagesGrid_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="NameLink" runat="server" NavigateUrl='<%# string.Format("EditContentPage.aspx?WebpageId={0}", Eval("WebpageId")) %>'>
                                <%# Eval("Name") %>
                                </asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="URL">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%# Eval("NavigateUrl") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Layout">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#GetLayout(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Theme">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#GetTheme(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Categories">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#GetCategories(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemStyle HorizontalAlign="Center" Width="100px" Wrap="false" />
                            <ItemTemplate>
                                <asp:HyperLink ID="PreviewIconLink" runat="server" NavigateUrl='<%# Eval("NavigateUrl") %>'
                                    Target="_blank">
                                    <asp:Image ID="PreviewIcon" runat="server" SkinID="PreviewIcon" AlternateText="Preview" />
                                </asp:HyperLink>
                                <asp:ImageButton ID="CopyButton" runat="server" SkinID="CopyIcon" CommandName="DoCopy"
                                    CommandArgument='<%#Eval("WebpageId")%>' AlternateText="Copy" />
                                <asp:LinkButton ID="V" runat="server" ToolTip='<%#string.Format("Visibility : {0}",Eval("Visibility"))%>' CommandName="Do_Pub" CommandArgument='<%#Eval("Id")%>'>
                                    <img src="<%# GetVisibilityIconUrl(Container.DataItem) %>" border="0" alt="<%#Eval("Visibility")%>" />
                                </asp:LinkButton>
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%# string.Format("EditContentPage.aspx?WebpageId={0}", Eval("WebpageId")) %>'>
                                    <asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></asp:HyperLink>
                                <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="DoDelete"
                                    CommandArgument='<%#Eval("WebpageId")%>' OnClientClick='return confirm("Are you sure you want to delete")'
                                    AlternateText="Delete" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        There are no webpages to list.
                    </EmptyDataTemplate>
                </cb:AbleGridView>                
                <asp:ObjectDataSource ID="WebpagesDs" runat="server" SelectMethod="Search" SelectCountMethod="SearchCount"
                    TypeName="CommerceBuilder.Catalog.CatalogDataSource" SortParameterName="sortExpression">
                    <SelectParameters>
                        <asp:Parameter Name="categoryId" DefaultValue="0" Type="Int32" />
                        <asp:Parameter Name="searchPhrase" DefaultValue="" Type="String" />
                        <asp:Parameter Name="titlesOnly" DefaultValue="true" Type="Boolean" />
                        <asp:Parameter Name="publicOnly" DefaultValue="false" Type="Boolean" />
                        <asp:Parameter Name="recursive" DefaultValue="true" Type="Boolean" />
                        <asp:Parameter Name="catalogNodeTypes" DefaultValue="4" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
