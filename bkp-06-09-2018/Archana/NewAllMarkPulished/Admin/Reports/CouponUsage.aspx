<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.CouponUsage" Title="Sales by Coupon"  CodeFile="CouponUsage.aspx.cs" AutoEventWireup="True" %>
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
                        <asp:Localize ID="Caption" runat="server" Text="Sales by Coupon"></asp:Localize>
                    </h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/marketing" />
                </div>
            </div>
            <div class="searchPanel">
                <div class="reportNav">
                    <asp:Label ID="StartDateLabel" runat="server" Text="Show usage from:" SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                    <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                    <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
                    <asp:Button ID="ExportButton" runat="server" Text="Export Results" OnClick="ExportButton_Click" />
                </div>
            </div>
            <div class="content">
                <cb:SortedGridView ID="CouponSalesGrid" runat="server" AutoGenerateColumns="False" DataSourceID="CouponUsageDs"
                    DefaultSortExpression="OrderTotal" DefaultSortDirection="Descending" AllowPaging="True" AllowSorting="true"
                    PageSize="40" OnSorting="CouponSalesGrid_Sorting" Width="100%" SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="Coupon" SortExpression="CouponCode">
                            <ItemTemplate>
                                <asp:HyperLink ID="CouponLink" runat="server" Text='<%# Eval("CouponCode") %>' NavigateUrl='<%#Eval("Coupon.CouponId", "../Marketing/Coupons/EditCoupon.aspx?CouponId={0}")%>'></asp:HyperLink>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Order Count" SortExpression="OrderCount">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="OrderCount" runat="server" Text='<%# Eval("OrderCount") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Order Total" SortExpression="OrderTotal">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="OrderTotal" runat="server" Text='<%# Eval("OrderTotal", "{0:c}") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:HyperLink ID="UsageDetailLink" runat="server" Text="details" SkinID="Button" NavigateUrl='<%# string.Format("CouponUsageDetail.aspx?CouponCode={0}&StartDate={1}&EndDate={2}", Server.UrlEncode(Eval("CouponCode").ToString()),StartDate.SelectedDate.ToShortDateString(),EndDate.SelectedDate.ToShortDateString()) %>' />
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
    <asp:ObjectDataSource ID="CouponUsageDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSalesByCoupon" 
        TypeName="CommerceBuilder.Reporting.ReportDataSource" SortParameterName="sortExpression" EnablePaging="true" 
        SelectCountMethod="GetSalesByCouponCount">
        <SelectParameters>
            <asp:ControlParameter ControlID="HiddenStartDate" Name="startDate" PropertyName="Value" Type="DateTime" />
            <asp:ControlParameter ControlID="HiddenEndDate" Name="endDate" PropertyName="Value" Type="DateTime" />
            <asp:Parameter Name="couponCode" Type="String" DefaultValue="" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>