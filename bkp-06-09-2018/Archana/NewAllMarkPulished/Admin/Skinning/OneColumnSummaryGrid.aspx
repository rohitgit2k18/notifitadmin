<%@ Page Title="One Column Summary Grid" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="OneColumnSummaryGrid.aspx.cs" Inherits="AbleCommerce.Admin.Skinning.OneColumnSummaryGrid" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
	    <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="One Column Summary Grid"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p><asp:Localize ID="IntroText" runat="server" Text="This demonstrates typical summary page with a grid output."></asp:Localize></p>
        <asp:GridView ID="GridWithData" runat="server" AutoGenerateColumns="False" 
            DataSourceID="ThemesDs" SkinId="PagedList" AllowSorting="true" Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Name" SortExpression="Name">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        Item Name
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Price">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        $1.99
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Weight">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        1
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemStyle Width="120px" HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" />
                        <asp:Image ID="DownloadIcon" runat="server" SkinID="DownloadIcon" />
                        <asp:Image ID="PreviewIcon" runat="server" SkinID="PreviewIcon" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Localize ID="EmptyListMessage" runat="server" Text="There is no data in the list."></asp:Localize>
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:ObjectDataSource ID="ThemesDs" runat="server" SelectMethod="LoadAll"
            TypeName="CommerceBuilder.UI.ThemeDataSource" SortParameterName="sortExpression">
        </asp:ObjectDataSource>
    </div>
    <div class="section">
        <div class="header">
            <h2><asp:Localize ID="SampleCaption" runat="server" Text="Sample Subsection"></asp:Localize></h2>
        </div>
        <div class="content">
            <asp:GridView ID="EmptyGrid" runat="server" AutoGenerateColumns="False" 
                DataSourceID="TaxRuleDs" SkinId="PagedList" AllowSorting="true">
                <Columns>
                    <asp:TemplateField HeaderText="Name" SortExpression="Name">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            Item Name
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Localize ID="EmptyListMessage" runat="server" Text="There is no data in the list."></asp:Localize>
                </EmptyDataTemplate>
            </asp:GridView>
            <asp:ObjectDataSource ID="TaxRuleDs" runat="server" SelectMethod="LoadAll"
                TypeName="CommerceBuilder.Taxes.TaxRuleDataSource" SortParameterName="sortExpression">
            </asp:ObjectDataSource>
        </div>
    </div>
</asp:Content>
