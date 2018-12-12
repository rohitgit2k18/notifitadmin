<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.Taxes" Title="Tax Summary Report" CodeFile="Taxes.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:PostBackTrigger ControlID="ExportButton" />
        </Triggers>
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1>
                        <asp:Localize ID="Caption" runat="server" Text="Tax Summary Report"></asp:Localize>
                        <asp:Localize ID="FromCaption" runat="server" Text=" from {0}" EnableViewState="false"></asp:Localize>
                        <asp:Localize ID="ToCaption" runat="server" Text=" to {0}" EnableViewState="false"></asp:Localize>
                    </h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/sales" />
                </div>
            </div>
            <div class="searchPanel">
                    <table cellspacing="0" class="inputForm">
                        <tr>
                            <th style="width:40%">
                                <cb:ToolTipLabel ID="CountryLabel" runat="server" Text="Country: " ToolTip="Filter taxes by order country." EnableViewState="false" />
                            </th>
                            <td>
                                <asp:DropDownList ID="CountryFilter" runat="server" DataSourceID="CountryDs" DataTextField="Name" DataValueField="CountryCode" AutoPostBack="true" OnSelectedIndexChanged="CountryChanged" OnDataBound="OnCountryDataBound" AppendDataBoundItems="true">
                                    <asp:ListItem Text="All Countries" Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ProvinceLabel" runat="server" Text="Province: " ToolTip="Filter taxes by province." EnableViewState="false" />
                            </th>
                            <td>
                                <asp:TextBox ID="Province" runat="server" MaxLength="50"></asp:TextBox> 
                                <asp:DropDownList ID="Province2" runat="server" DataTextField="Name" DataValueField="ProvinceCode" AppendDataBoundItems="true">
                                    <asp:ListItem Text="All Provinces" Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="ZoneLabel" runat="server" Text="Zone: " ToolTip="Filter taxes by order zone." EnableViewState="false" />
                            </th>
                            <td>
                                <asp:DropDownList ID="ZoneFilter" runat="server" DataSourceID="ZoneDs" DataTextField="Name" DataValueField="Id" AppendDataBoundItems="true"  >
                                    <asp:ListItem Text="All Zones" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <asp:Label ID="StartDateLabel" runat="server" Text="Show summary from:" SkinID="FieldHeader"></asp:Label>
                                <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                                <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
                                <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                                <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
                                <asp:Button ID="ExportButton" runat="server" Text="Export Results" OnClick="ExportButton_Click" />
                            </td>
                        </tr>
                    </table>
            </div>
            <div class="content">
                <cb:SortedGridView ID="TaxesGrid" runat="server" AutoGenerateColumns="False" Width="100%"
                    AllowPaging="True" PageSize="20" AllowSorting="true" DefaultSortDirection="ascending" 
                    DefaultSortExpression="TaxName" SkinID="PagedList" DataSourceId="TaxesDs" 
                    OnRowDataBound="TaxesGrid_RowDataBound" OnPreRender="TaxesGrid_PreRender" 
                    OnDataBinding="TaxesGrid_DataBinding" ShowFooter="true">
                    <Columns>
                        <asp:TemplateField HeaderText="Tax Name" SortExpression="TaxName">
                            <headerstyle horizontalalign="Left" />
                            <FooterStyle horizontalalign="Left" />
                            <itemtemplate>
                                <asp:HyperLink ID="TaxName" runat="server" Text='<%# Eval("TaxName") %>' NavigateUrl='<%#GetTaxLink(Container.DataItem)%>'></asp:HyperLink>
                            </itemtemplate>
                            <FooterTemplate>
                                <asp:Label ID="TotalsLabel" runat="server" Text="Totals:" CssClass="fieldHeader" ></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Loc Code" SortExpression="LocCode">
                            <headerstyle horizontalalign="Left" />
                            <ItemStyle Width="150" />
                            <itemtemplate>
                                <asp:Label ID="LocCode" runat="server" Text='<%# Eval("LocCode") %>' ></asp:Label>
                            </itemtemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Orders Total" SortExpression="OrderTotalCharges">
                            <headerstyle horizontalalign="right" />
                            <ItemStyle HorizontalAlign="Right" Width="200" />
                            <FooterStyle HorizontalAlign="Right" Width="200" />
                            <itemtemplate>
                                <asp:Label ID="OrderTotalCharges" runat="server" Text='<%# ((decimal)Eval("OrderTotalCharges")).LSCurrencyFormat("lc") %>' ></asp:Label>
                            </itemtemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Product Subtotal" SortExpression="ProductSubtotal">
                            <headerstyle horizontalalign="right" />
                            <ItemStyle HorizontalAlign="Right" Width="200" />
                            <FooterStyle HorizontalAlign="Right" Width="200" />
                            <itemtemplate>
                                <asp:Label ID="ProductSubtotal" runat="server" Text='<%# ((decimal)Eval("ProductSubtotal")).LSCurrencyFormat("lc") %>' ></asp:Label>
                            </itemtemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Collected" SortExpression="TaxAmount">
                            <headerstyle horizontalalign="right" />
                            <ItemStyle HorizontalAlign="Right" Width="200" />
                            <FooterStyle HorizontalAlign="Right" Width="200" />
                            <itemtemplate>
                                <asp:Label ID="SubTotals" runat="server" Text='<%# ((decimal)Eval("TaxAmount")).LSCurrencyFormat("lc") %>' EnableViewState="false"></asp:Label>
                            </itemtemplate>
                            <FooterTemplate>
                                <asp:Label ID="Totals" runat="server" Text="0.0"></asp:Label>
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no results for the selected time period."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
                <div ID="Comments" runat="server">
                    <p><b>Note:</b> The Order Total and Product Subtotal columns may need to be adjusted if there are two or more tax rules being applied to the same order.</p>
                </div>
            </div>
            <asp:HiddenField ID="HiddenStartDate" runat="server" />
            <asp:HiddenField ID="HiddenEndDate" runat="server" />
            <asp:ObjectDataSource ID="TaxesDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadSummaries" 
                SortParameterName="sortExpression" EnablePaging="true" TypeName="CommerceBuilder.Reporting.TaxReportDataSource"
                SelectCountMethod="CountSummaries" DataObjectTypeName="CommerceBuilder.Reporting.TaxReportSummaryItem" EnableViewState="false" OnSelecting="TaxesDs_Selecting">
                <SelectParameters>
                    <asp:ControlParameter ControlID="CountryFilter" Name="countryCode" PropertyName="SelectedValue" Type="String" />
                    <asp:Parameter Name="province" DefaultValue="" Type="String" />
                    <asp:ControlParameter ControlID="ZoneFilter" Name="zoneId" PropertyName="SelectedValue" Type="Int32" />
                    <asp:ControlParameter ControlID="HiddenStartDate" Name="startDate" PropertyName="Value" Type="DateTime" />
                    <asp:ControlParameter ControlID="HiddenEndDate" Name="endDate" PropertyName="Value" Type="DateTime" />
                </SelectParameters>                
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="CountryDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadAll" 
                SortParameterName="sortExpression" EnablePaging="false" TypeName="CommerceBuilder.Shipping.CountryDataSource"
                DataObjectTypeName="CommerceBuilder.Shipping.Country" EnableViewState="false">
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="ZoneDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadForStore" 
                SortParameterName="sortExpression" EnablePaging="false" TypeName="CommerceBuilder.Shipping.ShipZoneDataSource"
                DataObjectTypeName="CommerceBuilder.Shipping.ShipZone" EnableViewState="false" OnSelecting="ZoneDs_Selecting">
                <SelectParameters>
                    <asp:Parameter Name="storeId" Type="Int32" DefaultValue="1" />
                </SelectParameters>                
            </asp:ObjectDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>