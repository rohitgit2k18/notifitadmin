<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.LowInventory" Title="Low Inventory" CodeFile="LowInventory.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<%--<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc" %>--%>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function (evt, args) { $.datepicker.setDefaults($.datepicker.regional['<%=(System.Threading.Thread.CurrentThread.CurrentCulture.Name == "en-US" ? "" : System.Threading.Thread.CurrentThread.CurrentCulture.Name) %>']); $(".pickerAndCalendar").datepicker(); });
</script>
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Products with Low Inventory"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/products" />
        </div>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:PostBackTrigger ControlID="ExportButton" />
            </Triggers>
            <ContentTemplate> 
                <cb:Notification ID="SavedMessage" runat="server" Text="Data saved at {0:g}" EnableViewState="false" Visible="false" SkinID="GoodCondition"></cb:Notification>
                <asp:Panel ID="SearchPanel" runat="server"  CssClass="searchPanel" DefaultButton="SearchButton">
                    <table cellspacing="0" class="inputForm">
                        <tr>
                            <th>
                                <asp:Label ID="InventoryLevelLabel" runat="server" Text="Inventory Level:"></asp:Label>
                            </th>
                            <td>
                                <asp:DropDownList ID="InventoryLevel" runat="server" Width="200px">
                                    <asp:ListItem Text="Any" Value="0" />
                                    <asp:ListItem Text="Low Stock" Value="1" Selected="True" />
                                    <asp:ListItem Text="Out of Stock" Value="2" />
                                </asp:DropDownList>
                            </td>
                            <th>
                                <asp:Label ID="ManufacturersLabel" runat="server" Text="Manufacturer:"></asp:Label>
                            </th>
                            <td>
                                <asp:DropDownList ID="Manufacturers" runat="server" DataTextField="Name" DataValueField="Id" AppendDataBoundItems="true" >
                                    <asp:ListItem Text="Any" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <th>
                                <asp:Label ID="VendorLabel" runat="server" Text="Vendor:"></asp:Label>
                            </th>
                            <td>
                                <asp:DropDownList ID="Vendors" runat="server" DataTextField="Name" DataValueField="Id" AppendDataBoundItems="true" >
                                    <asp:ListItem Text="Any" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:Button ID="SearchButton" runat="server" Text="Search" SkinID="Button" onclick="SearchButton_Click" ValidationGroup="SearchGroup" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <cb:AbleGridView ID="InventoryGrid" runat="server" AutoGenerateColumns="False" DataSourceID="InventoryDs" DataKeyNames="ProductId,ProductVariantId"
                    DefaultSortExpression="Name" AllowPaging="True" AllowSorting="true" PageSize="10" 
                    CellPadding="3" RowStyle-CssClass="odd" AlternatingRowStyle-CssClass="even" 
                    BorderColor="white" OnDataBound="InventoryGrid_DataBound" SkinID="PagedList" Width="100%"
		            TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching results" 
		            AllowMultipleSelections="False"
                    OnRowCommand="InventoryGrid_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <ItemTemplate>
                                <asp:HyperLink ID="ProductLink" runat="server" Text='<%# GetName(Container.DataItem) %>' NavigateUrl='<%#Eval("ProductId", "../Products/EditProduct.aspx?ProductId={0}")%>'></asp:HyperLink>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Notifications">
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                            <ItemTemplate>
                                <asp:Label ID="CountLabel" runat="server" Text="0" Visible="<%#GetNotificationsCount(Container.DataItem) == 0 %>"></asp:Label>
                                <asp:HyperLink ID="NotificationLink" runat="server" Text='<%# GetNotificationsCount(Container.DataItem) %>' NavigateUrl='<%# GetSendEmailLink(Container.DataItem) %>' Visible='<%#GetNotificationsCount(Container.DataItem) > 0 %>'></asp:HyperLink>&nbsp;
                                <asp:HyperLink ID="NotificationLink2" runat="server" NavigateUrl='<%# GetSendEmailLink(Container.DataItem) %>' ToolTip="Send Email" Visible='<%#GetNotificationsCount(Container.DataItem) > 0 %>'><asp:Image ID="EmailIcon" SkinID="EmailIcon" runat="server" /></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Last Sent">
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                            <ItemTemplate>
                                <asp:Label ID="LastSentDate" runat="server" Text='<%# GetLastSent(Container.DataItem) %>' ></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="In Stock" SortExpression="InStock">
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                            <ItemTemplate>
                                <asp:TextBox ID="InStock" runat="server" Text='<%# Eval("InStock") %>' Columns="4"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Low Stock" SortExpression="InStockWarningLevel">
                            <ItemStyle HorizontalAlign="Center" Width="10%" />
                            <ItemTemplate>
                                <asp:TextBox ID="LowStock" runat="server" Text='<%# Eval("InStockWarningLevel") %>' Columns="4"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Availability Date" SortExpression="AvailabilityDate">
                            <ItemStyle HorizontalAlign="Center" Width="12%" />
                            <ItemTemplate>
                                <asp:TextBox ID="AvailabilityDate" runat="server" Text='<%# GetDate(Eval("AvailabilityDate")) %>' CssClass="pickerAndCalendar" Width="80"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Visibility" SortExpression="VisibilityId">
                            <ItemStyle HorizontalAlign="Center" Width="80px" />
                            <ItemTemplate>
                                <asp:LinkButton ID="V" runat="server" ToolTip='<%#string.Format("Visibility : {0}",Eval("Visibility"))%>' CommandName="Do_Pub" CommandArgument='<%#Eval("ProductId")%>' Visible='<%#((int)Eval("ProductVariantId") != 0) %>' OnClientClick="return confirm('Visibility of a variant can not be changed. Do you want to change the main product visibility instead?')">
                                    <img src="<%# GetVisibilityIconUrl(Container.DataItem) %>" border="0" alt="<%#Eval("Visibility")%>" />
                                </asp:LinkButton>
                                <asp:LinkButton ID="P" runat="server" ToolTip='<%#string.Format("Visibility : {0}",Eval("Visibility"))%>' CommandName="Do_Pub" CommandArgument='<%#Eval("ProductId")%>' Visible='<%#((int)Eval("ProductVariantId") == 0) %>'>
                                    <img src="<%# GetVisibilityIconUrl(Container.DataItem) %>" border="0" alt="<%#Eval("Visibility")%>" />
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="paging" HorizontalAlign="right" />
                    <PagerSettings NextPageText="" PreviousPageText="" />
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no items currently at or below the low stock level."></asp:Label>
                    </EmptyDataTemplate>
                </cb:AbleGridView>
                <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                <asp:Button ID="SaveAndNotifyButton" runat="server" Text="Save and Notify Users" OnClick="SaveAndNotifyButton_Click" />
                <asp:Button ID="ExportButton" runat="server" Text="Export Results" OnClick="ExportButton_Click" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <asp:ObjectDataSource ID="InventoryDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetLowProductInventory" 
        TypeName="CommerceBuilder.Reporting.ProductInventoryDataSource" SortParameterName="sortExpression" EnablePaging="true" 
        SelectCountMethod="GetLowProductInventoryCount">
        <SelectParameters>
            <asp:ControlParameter Name="inventoryLevel" Type="Byte" ControlID="InventoryLevel" PropertyName="SelectedValue" DefaultValue="0" />
            <asp:ControlParameter Name="manufacturerId" Type="Int32" ControlID="Manufacturers" PropertyName="SelectedValue" DefaultValue="0" />
            <asp:ControlParameter Name="vendorId" Type="Int32" ControlID="Vendors" PropertyName="SelectedValue" DefaultValue="0" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>

