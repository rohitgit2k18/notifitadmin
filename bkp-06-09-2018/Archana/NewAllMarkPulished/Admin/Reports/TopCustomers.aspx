<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.TopCustomers" Title="Top Customers"  CodeFile="TopCustomers.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:PostBackTrigger ControlID="ExportButton" />
        </Triggers>
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                     <h1>
                        <asp:Localize ID="Caption" runat="server" Text="Sales by Customer"></asp:Localize>
                     </h1>
                     <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/customers" />
                </div>
            </div>
            <div class="searchPanel">
                <div class="reportNav">
                    <asp:Label ID="StartDateLabel" runat="server" Text="Show report from:" SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                    <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                    <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
                    <asp:Button ID="ExportButton" runat="server" Text="Export Results" OnClick="ExportButton_Click" />
                </div>
            </div>
            <div class="content">
                <cb:SortedGridView ID="TopCustomerGrid" runat="server" AutoGenerateColumns="False" DataSourceID="TopCustomerDs"
                    DefaultSortExpression="OrderTotal" DefaultSortDirection="Descending" AllowPaging="True" AllowSorting="true"
                    PageSize="40" OnSorting="TopCustomerGrid_Sorting" Width="100%" SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="User">
                            <ItemTemplate>
                                <asp:HyperLink ID="UserLink" runat="server" Text='<%# Eval("UserName") %>' NavigateUrl='<%#Eval("UserId", "../People/Users/EditUser.aspx?UserId={0}")%>'></asp:HyperLink>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Order Count" SortExpression="OrderCount">
                            <ItemStyle HorizontalAlign="Center" Width="30%" />
                            <ItemTemplate>
                                <%# Eval("OrderCount") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Order Total" SortExpression="OrderTotal">
                            <ItemStyle HorizontalAlign="Center" Width="30%" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("OrderTotal")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no results for the selected time period."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
            </div>
            <asp:HiddenField ID="HiddenStartDate" runat="server" />
            <asp:HiddenField ID="HiddenEndDate" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="TopCustomerDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSalesByUser" 
        TypeName="CommerceBuilder.Reporting.ReportDataSource" SortParameterName="sortExpression" EnablePaging="true" 
        SelectCountMethod="GetSalesByUserCount">
        <SelectParameters>
            <asp:ControlParameter ControlID="HiddenStartDate" Name="startDate" PropertyName="Value" Type="DateTime" />
            <asp:ControlParameter ControlID="HiddenEndDate" Name="endDate" PropertyName="Value" Type="DateTime" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>