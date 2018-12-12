<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.PopularCategories" Title="Category Popularity by Views" CodeFile="PopularCategories.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Category Popularity by Views"></asp:Localize><asp:Localize ID="ReportCaption" runat="server" Text=" for {0:d}" Visible="false" EnableViewState="false"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/products" />
        </div>
    </div>
    <div class="content">
        <cb:SortedGridView ID="PopularCategoriesGrid" runat="server" AutoGenerateColumns="False"
            PageSize="40" AllowSorting="True" AllowPaging="True" DataSourceID="CategoryViewsDs"
            DefaultSortExpression="ViewCount" DefaultSortDirection="Descending" SkinID="PagedList"
            Width="100%">
            <Columns>       
                <asp:TemplateField HeaderText="Category" SortExpression="Name">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:HyperLink ID="CategoryLink" runat="server" Text='<%#Eval("Key.Name")%>' NavigateUrl='<%#Eval("Key.NavigateUrl")%>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Views" SortExpression="ViewCount">
                    <ItemStyle HorizontalAlign="Center" Width="30%" />
                    <ItemTemplate>                    
                        <asp:Label ID="CountLabel" runat="server" Text='<%#Eval("Value")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no results to display."></asp:Label>
            </EmptyDataTemplate>
        </cb:SortedGridView>
        <asp:Button ID="ExportByViewsButton" runat="server" Text="Export Results" OnClick="ExportByViewsButton_Click" />
    </div>
    <asp:ObjectDataSource ID="CategoryViewsDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}"
        SelectCountMethod="GetViewsByCategoryCount" SelectMethod="GetViewsByCategory"
        SortParameterName="sortExpression" TypeName="CommerceBuilder.Reporting.PageViewDataSource">
    </asp:ObjectDataSource>
</asp:Content>