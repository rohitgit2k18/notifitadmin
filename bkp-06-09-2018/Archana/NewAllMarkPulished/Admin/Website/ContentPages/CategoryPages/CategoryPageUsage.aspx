<%@ Page Title="Category Page Usage" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="CategoryPageUsage.aspx.cs" Inherits="AbleCommerce.Admin.Website.ContentPages.CategoryPages.CategoryPageUsage" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<script language="javascript" type="text/javascript">
    function changePageConfirmation() {
        var selectedRows = $(".selectRow input:checkbox:checked").length;
        if (selectedRows > 0) {

            displayPage = $('#<%=CategoryDisplayPages.ClientID %> option:selected').text();
            return confirm("Are you sure you want to reassign selected items to " + displayPage + " category page?");
        }
        else {
            alert("At least one item must be selected.");
        }

        return false;
    }
</script>
    <div class="pageHeader">
        <div class="caption">
            <h1>Category Page Usage</h1>
        </div>
    </div>
    <asp:UpdatePanel ID="SearchFormAjax" runat="server">
        <ContentTemplate>
            <div class="searchPanel">
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="CategoryPageLabel" runat="server" Text="Category Page:" AssociatedControlID="CategoryPageList" />
                        </th>
                        <td>
                            <asp:DropDownList ID="CategoryPageList" runat="server" DataSourceID="WebpagesDS" DataTextField="Name"
                                DataValueField="Id" AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="CategoryPageList_SelectedIndexChanged">
                                <asp:ListItem Text="- Any -" Value="Any"></asp:ListItem>
                                <asp:ListItem Text="Use store default" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="WebpagesDS" runat="server" 
                                SelectMethod="LoadForWebpageType"
                                SelectCountMethod="CountForWebpageType"
                                TypeName="CommerceBuilder.Catalog.WebpageDataSource" 
                                SortParameterName="sortExpression" onselecting="WebpagesDs_Selecting">
                                <SelectParameters>
                                    <asp:Parameter Name="webpageType" Type="Object"/>
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                    <asp:Panel ID="UpdateSelectedPanel" runat="server" Visible="false">
                    <tr>
                        <th>
                            <asp:Label ID="BulkUpdateLabel" runat="server" SkinID="FieldHeader" Text="Change selected to:"></asp:Label>
                        </th>
                        <td>
                            
                            <asp:DropDownList ID="CategoryDisplayPages" runat="server" DataSourceID="WebpagesDS" 
                                DataTextField="Name" DataValueField="Id" AppendDataBoundItems="true">
                                <asp:ListItem Text="Use store default" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Button ID="Update" runat="server" Text="Update" onclick="Update_Click" OnClientClick="return changePageConfirmation();" />
                            <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Default.aspx" />
                            
                        </td>
                    </tr>
                    </asp:Panel>
                </table>
            </div>
    <div class="content">
                    <cb:AbleGridView ID="CategoriesGrid" DataSourceID="CategoryDS"
                    runat="server" AutoGenerateColumns="False" DataKeyNames="Id"
                    AllowPaging="True" PageSize="20" TotalMatchedFormatString=" {0} items matched"
                    SkinID="PagedList" PagerSettings-Position="TopAndBottom" DefaultSortDirection="Ascending"
                    DefaultSortExpression="" FirstButtonSkinID="FirstIcon" LastButtonSkinID="LastIcon"
                    NextButtonSkinID="NextIcon" PageNumberCssClass="pageNumber" PageNumberSkinID="PageNumber"
                    PagerMode="Custom" PageSizeCssClass="pageSize" PageSizeOptions="Show All:0|10:10|20:20|50:50|100:100"
                    PreviousButtonSkinID="PreviousIcon" ShowWhenEmpty="False" TotalMatchedItemsCssClass="totalMatchedItems"
                    AllowMultipleSelections="True" AllowSorting="True" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="Name" runat="server" NavigateUrl='<%#Eval("Id", "~/Admin/Catalog/EditCategory.aspx?CategoryId={0}") %>' Text='<%#Eval("Name")%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Page">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                            <%#GetDisplayPage(Eval("Webpage"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Visibility">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                            <%#Eval("Visibility")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="NoItemLabel" runat="server" Text="There are no categories to list matching your criteria."></asp:Label>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
                <asp:ObjectDataSource ID="CategoryDS" runat="server" 
                    SelectMethod="LoadForDisplayPage"
                    SelectCountMethod="CountDisplayPage"
                    TypeName="CommerceBuilder.Catalog.CategoryDataSource" 
                    OldValuesParameterFormatString="original_{0}" onselecting="CategoryDS_Selecting" >
                    <SelectParameters>
                        <asp:Parameter Name="webpageId" DbType="Int32" DefaultValue="0" />
                        <asp:Parameter Name="any" DbType="Boolean" DefaultValue="True" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>