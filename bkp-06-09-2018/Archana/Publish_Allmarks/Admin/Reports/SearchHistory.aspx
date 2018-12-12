<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.SearchHistory" Title="Customer Search History" CodeFile="SearchHistory.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Customer Search History"></asp:Localize><asp:Localize ID="ReportCaption" runat="server" Text="Popular Search Keywords" Visible="false" EnableViewState="false"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/customers" />
        </div>
    </div>
    <div class="content">
        <cb:SortedGridView ID="SearchHistoryGrid" runat="server" AutoGenerateColumns="False"
            PageSize="20" AllowSorting="True" AllowPaging="True" DataSourceID="SearchHistoryDs"
            DefaultSortExpression="TotalCount" DefaultSortDirection="Descending" SkinID="PagedList"
            Width="100%">
            <Columns>       
                <asp:TemplateField HeaderText="Search Term" SortExpression="SearchTerm">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%#Eval("SearchTerm")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Count" SortExpression="TotalCount">
                    <ItemStyle HorizontalAlign="center" width="30%" />
                    <ItemTemplate>                    
                        <%#Eval("TotalCount")%>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no results to display."></asp:Label>
            </EmptyDataTemplate>
        </cb:SortedGridView>
        <asp:Button ID="ExportButton" runat="server" Text="Export Results" OnClick="ExportButton_Click" />
    </div>
    <asp:ObjectDataSource ID="SearchHistoryDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}"
        SelectCountMethod="SearchTermsSummaryCount" SelectMethod="LoadSearchTermsSummary"
        SortParameterName="sortExpression" TypeName="CommerceBuilder.Reporting.ReportDataSource">
    </asp:ObjectDataSource>
</asp:Content>