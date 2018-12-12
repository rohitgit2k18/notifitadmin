<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.SEO.CustomURLs" Title="Custom URLs" CodeFile="CustomURLs.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Custom URLs"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/seo" />
        </div>
    </div>
    <div class="content">
        <p>The Custom URL report shows any catalog object using a custom URL that you've entered.  To change the page name or custom URL value, click on the linked name.</p>
        <asp:UpdatePanel ID="RedirectGridAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <cb:SortedGridView ID="CustomUrlGrid" runat="server" AutoGenerateColumns="False"
                    AllowSorting="true" DefaultSortExpression="Id" DefaultSortDirection="Ascending"
                    AllowPaging="True" PagerStyle-CssClass="paging" PageSize="40" PagerSettings-Position="Bottom"
                    SkinID="PagedList" DataSourceID="CustomUrlDS" DataKeyNames="CustomUrlId" ShowWhenEmpty="False"
                    Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="Type" SortExpression="CatalogNodeTypeId">
                            <HeaderStyle HorizontalAlign="center" Width="54px" />
                            <ItemStyle Width="78px" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <img src="<%# GetCatalogIconUrl(Container.DataItem) %>" border="0" alt="<%#Eval("CatalogNodeType")%>" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" Width="200" />
                            <ItemTemplate>
                                <a href='<%#GetEditUrl(Container.DataItem) %>'>
                                <%#GetCatalogItemName(Container.DataItem)%>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Custom Url" SortExpression="Url">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" Width="400" />
                            <ItemTemplate>
                                <%#Eval("Url")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="paging" />
                    <EmptyDataTemplate>
                        You do not have any custom URLs configured. To create one, edit the item in your catalog and set the Custom URL field. 
                    </EmptyDataTemplate>
                </cb:SortedGridView>
                <asp:ObjectDataSource ID="CustomUrlDS" runat="server" OldValuesParameterFormatString="original_{0}"
                    SelectMethod="LoadAll" SelectCountMethod="CountAll" TypeName="CommerceBuilder.Catalog.CustomUrlDataSource"
                    EnablePaging="true" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Catalog.CustomUrl">
                </asp:ObjectDataSource>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>