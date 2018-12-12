<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Reports.TaxDetail" Title="Tax Detail Report" CodeFile="TaxDetail.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1>
                        <asp:Localize ID="Caption" runat="server" Text="Detail Report for {0}" EnableViewState="false"></asp:Localize>
                        <asp:Localize ID="FromCaption" runat="server" Text=" from {0}" EnableViewState="false"></asp:Localize>
                        <asp:Localize ID="ToCaption" runat="server" Text=" to {0}" EnableViewState="false"></asp:Localize>
                    </h1>
                </div>
            </div>
            <div class="searchPanel">
                <asp:Label ID="StartDateLabel" runat="server" Text="Show detail from:" SkinID="FieldHeader"></asp:Label>
                <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
                <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
            </div>
            <div class="content">
                <cb:SortedGridView ID="TaxesGrid" runat="server" AutoGenerateColumns="False" Width="100%"
                    AllowPaging="True" PageSize="20" AllowSorting="true" DefaultSortDirection="Ascending" 
                    DefaultSortExpression="O.Id" SkinID="PagedList" DataSourceId="TaxesDs" ShowFooter="true" 
                    OnRowDataBound="TaxesGrid_RowDataBound"
                    OnDataBinding="TaxesGrid_DataBinding">
                    <Columns>
                        <asp:TemplateField HeaderText="Order" SortExpression="OrderNumber">
                            <headerstyle horizontalalign="Center" />
                            <itemstyle horizontalalign="Center" />
                            <FooterStyle HorizontalAlign="Left" />
                            <itemtemplate>
                                <asp:HyperLink ID="OrderLink" runat="server" Text='<%# Eval("OrderNumber") %>' NavigateUrl='<%# GetOrderLink(Container.DataItem) %>'></asp:HyperLink>
                            </itemtemplate>
                            <FooterTemplate>
                                <asp:Label ID="TotalsLabel" runat="server" Text="Totals:" CssClass="fieldHeader" ></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Order Date" SortExpression="OrderDate">
                            <headerstyle horizontalalign="Left" />
                            <itemtemplate>
                                <%# Eval("OrderDate") %>
                            </itemtemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Order Total Charges" SortExpression="OrderTotalCharges">
                            <headerstyle horizontalalign="right" />
                            <itemstyle horizontalalign="Right" />
                            <itemtemplate>
                                <asp:Label ID="OrderTotalCharges" runat="server" Text='<%# ((decimal)Eval("OrderTotalCharges")).LSCurrencyFormat("lc") %>' ></asp:Label>
                            </itemtemplate>
                            <FooterStyle HorizontalAlign="Right" Width="200" />
                            <FooterTemplate>
	                            <asp:Label ID="OrderTotals" runat="server" Text="0.0"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Product Subtotal" SortExpression="ProductSubtotal">
                            <headerstyle horizontalalign="right" />
                            <ItemStyle HorizontalAlign="Right" Width="200" />
                            <itemtemplate>
                                <asp:Label ID="ProductSubtotal" runat="server" Text='<%# ((decimal)Eval("ProductSubtotal")).LSCurrencyFormat("lc") %>' ></asp:Label>
                            </itemtemplate>
                            <FooterStyle HorizontalAlign="Right" Width="200" />
                            <FooterTemplate>
	                            <asp:Label ID="ProductTotals" runat="server" Text="0.0"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Tax Collected" SortExpression="TaxAmount">
                            <headerstyle horizontalalign="right" />
                            <itemstyle horizontalalign="Right" />
                            <itemtemplate>
                                <asp:Label ID="SubTotals" runat="server" Text='<%# ((decimal)Eval("TaxAmount")).LSCurrencyFormat("lc") %>' EnableViewState="false"></asp:Label>
                            </itemtemplate>
                            <FooterStyle HorizontalAlign="Right" Width="200" />
                            <FooterTemplate>
	                            <asp:Label ID="TaxTotals" runat="server" Text="0.0"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no results for the selected time period."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
            </div>
            <asp:HiddenField ID="HiddenTaxName" runat="server" Value="" />
            <asp:HiddenField ID="HiddenLocCode" runat="server" Value="" />
            <asp:ObjectDataSource ID="TaxesDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadDetail" 
                SortParameterName="sortExpression" EnablePaging="true" TypeName="CommerceBuilder.Reporting.TaxReportDataSource"
                SelectCountMethod="CountDetail" DataObjectTypeName="CommerceBuilder.Reporting.TaxReportDetailItem" EnableViewState="false">
                <SelectParameters>
                    <asp:ControlParameter ControlID="HiddenTaxName" Name="taxName" PropertyName="Value" Type="String" />
                    <asp:ControlParameter ControlID="HiddenLocCode" Name="locCode" PropertyName="Value" Type="String" />
                    <asp:QueryStringParameter Name="countryCode" Type="String" QueryStringField="C" DefaultValue=""  />
                    <asp:QueryStringParameter Name="province" Type="String" QueryStringField="P" DefaultValue="" />
                    <asp:QueryStringParameter Name="zoneId" Type="Int32" QueryStringField="Z" DefaultValue="0" />
                    <asp:ControlParameter ControlID="StartDate" Name="startDate" PropertyName="SelectedStartDate" Type="DateTime" />
                    <asp:ControlParameter ControlID="EndDate" Name="endDate" PropertyName="SelectedEndDate" Type="DateTime" />
                </SelectParameters>                
            </asp:ObjectDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>