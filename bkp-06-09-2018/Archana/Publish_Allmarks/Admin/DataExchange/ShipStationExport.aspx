<%@ Page Title="ShipStation Export" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" CodeFile="ShipStationExport.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.ShipStationExport" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
<div class="pageHeader">
    <div class="caption">
    	<h1><asp:Localize ID="Caption" runat="server" Text="ShipStation Export"></asp:Localize></h1>
        <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="data/shipstation" />
    </div>
</div>
<%--<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>--%>
        <div class="section">
            <asp:Wizard ID="ShipStationWizard" runat="server" Width="100%" OnNextButtonClick="ShipStationWizard_NextButtonClick" FinishCompleteButtonText="Export" OnFinishButtonClick="ShipStationWizard_FinishButtonClick" StartNextButtonStyle-CssClass="button" FinishPreviousButtonStyle-CssClass="button" 
                FinishCompleteButtonStyle-CssClass="button">
                <WizardSteps>
                    <asp:WizardStep StepType="Start">
            <table class="inputForm">
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="DateFilterLabel" runat="server" Text="Date Range:" ToolTip="Filter orders that were placed within the start and end dates." />
                    </th>
                    <td>
                        <uc1:PickerAndCalendar ID="OrderStartDate" runat="server" /> to <uc1:PickerAndCalendar ID="OrderEndDate" runat="server" />
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="StatusFilterLabel" runat="server" Text="Order Status:" AssociatedControlID="StatusFilter" ToolTip="Filter by order status." />
                    </th>
                    <td>
                        <asp:DropDownList ID="StatusFilter" runat="server">
                            <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="OrderNumberFilterLabel" runat="server" Text="Order Number(s):" AssociatedControlID="OrderNumberFilter"
                            ToolTip="You can enter order number(s) to filter the list.  Separate multiple orders with a comma.  You can also enter ranges like 4-10 for all orders numbered 4 through 10."  EnableViewState="false"/>
                    </th>
                    <td>
                        <asp:TextBox ID="OrderNumberFilter" runat="server" Text="" Width="200px" AutoComplete="off"></asp:TextBox>
                        <cb:IdRangeValidator ID="OrderNumberFilterValidator" runat="server" Required="false"
                            ControlToValidate="OrderNumberFilter" Text="*" 
                            ErrorMessage="The range is invalid.  Enter a specific order number or a range of numbers like 4-10.  You can also include mulitple values separated by a comma."></cb:IdRangeValidator>
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="ShipmentStatusFilterLabel" runat="server" Text="Shipment Status:" AssociatedControlID="ShipmentStatusFilter" ToolTip="Filter orders by shipment status." />
                    </th>
                    <td>
                        <asp:DropDownList ID="ShipmentStatusFilter" runat="server">
                            <asp:ListItem Text="All" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Unshipped" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Shipped" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </td>  
                </tr>
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="IncludeExportedLabel" runat="server" Text="Include Orders Already Exported" ToolTip="If checked, already exported orders will be included to search criteria." EnableViewState="false"></cb:ToolTipLabel>
                    </th>
                    <td>
                        <asp:CheckBox ID="IncludeExported" runat="server" Checked="false"  />
                    </td>
                    <th>
                        <cb:ToolTipLabel ID="PaymentStatusFilterLabel" runat="server" Text="Payment Status:" AssociatedControlID="PaymentStatusFilter" ToolTip="Filter orders by payment status." />
                    </th>
                    <td>
                        <asp:DropDownList ID="PaymentStatusFilter" runat="server">
                            <asp:ListItem Text="All" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Unpaid" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Paid" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>  
            </asp:WizardStep>
        <asp:WizardStep StepType="Finish">
            <p><asp:Label ID="OrdersTitleLabel" runat="server" Text="Following orders matching your selection criteria will be exported to ship station."></asp:Label></p>
            <cb:AbleGridView ID="OrderGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="True" PageSize="10" 
                AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="OrderDs" DefaultSortExpression="OrderNumber" DefaultSortDirection="Descending" 
                ShowWhenEmpty="False" TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching orders">
                <Columns>
                    <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:HyperLink ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>' SkinID="Link" NavigateUrl='<%#String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber"))%>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" SortExpression="OrderStatusId">
                        <ItemStyle HorizontalAlign="Left" Height="30px" />
                        <ItemTemplate>
                            <asp:Label ID="OrderStatus" runat="server" Text='<%# GetOrderStatus(Eval("OrderStatusId")) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Customer" SortExpression="BillToLastName">
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:Label ID="CustomerName" runat="server" Text='<%# string.Format("{1}, {0}", Eval("BillToFirstName"), Eval("BillToLastName")) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Amount" SortExpression="TotalCharges">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:Label ID="Label5" runat="server" Text='<%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:Label ID="Label6" runat="server" Text='<%# Eval("OrderDate", "{0:G}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Payment">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:PlaceHolder ID="phPaymentStatus" runat="server"></asp:PlaceHolder>
                            <asp:Label ID="PaymentStatus" runat="server" Text='<%# GetPaymentStatus(Container.DataItem) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Shipment">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:PlaceHolder ID="phShipmentStatus" runat="server"></asp:PlaceHolder>
                            <asp:Label ID="ShipmentStatus" runat="server" Text='<%# Eval("ShipmentStatus") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:HyperLink ID="DetailsLink" runat="server" NavigateUrl='<%#String.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", Eval("OrderNumber")) %>' rel='<%#String.Format("OrderSummary.ashx?OrderId={0}", Eval("OrderId")) %>'><asp:Image ID="PreviewIcon" runat="server" SkinID="PreviewIcon" AlternateText="View Order" ToolTip="View Order" /></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <asp:Label ID="EmptyMessage" runat="server" Text="No orders match criteria."></asp:Label>
                </EmptyDataTemplate>
            </cb:AbleGridView>
            <asp:ObjectDataSource ID="OrderDs" runat="server" OldValuesParameterFormatString="original_{0}"
            SelectMethod="LoadOrders" SelectCountMethod="CountOrders" SortParameterName="sortExpression" TypeName="CommerceBuilder.DataExchange.ShipStationExportManager"
            OnSelecting="OrderDs_Selecting" EnablePaging="true">
            <SelectParameters>
                <asp:Parameter Name="exportOptions" Type="Object" />
            </SelectParameters>
            </asp:ObjectDataSource>
            <br />
            <asp:Panel ID="ExportOptionsPanel" runat="server">
            <p><asp:Label ID="ExportOptionsLabel" runat="server" EnableViewState="false">You may change the order status when exporting orders to ShipStation. Leave as-is if you want the status to be updated automatically when the order is re-synced with AbleCommerce.</asp:Label></p>
            <table cellpadding="0" cellspacing="0" class="inputForm" style="width:auto;">
                <tr>
                    <th>
                        <cb:ToolTipLabel ID="NewOrderStatusLabel" runat="server" Text="Update Order Status:" AssociatedControlID="StatusFilter" ToolTip="Change order status of exported orders to this" />
                    </th>
                    <td>
                        <asp:DropDownList ID="NewOrderStatus" runat="server">
                            <asp:ListItem Text="" Value="-1"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
            </asp:Panel>
        </asp:WizardStep>
        <asp:WizardStep StepType="Complete">
            <asp:PlaceHolder ID="ProgressPanel" runat="server" Visible="false">
                <p>Export operation is in progress, please be patient while the process completes.</p>
                <p><asp:Image ID="ProgressImage" runat="server" SkinID="Progress" />&nbsp;&nbsp;<asp:Button ID="CancelExportLink" runat="server" Text="Cancel" OnClick="CancelExportLink_Click"></asp:Button></p>
                <p><asp:Localize ID="ProgressLabel" runat="server" Text="Total Orders: {0} Exported: {1}" EnableViewState="false"></asp:Localize></p>
                <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="FinishPanel" runat="server" Visible="false">
                <p><asp:Localize ID="FinishedMessage" runat="server" Text="Operation finished at {0}" EnableViewState="false"></asp:Localize> </p>
                <asp:HyperLink ID="FinishButton" runat="server" Text="Finish" CssClass="button" NavigateUrl="~/Admin/DataExchange/ShipStationExport.aspx" />
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="MessagesPanel" runat="server" Visible="false">
                <asp:BulletedList ID="Messages" runat="server" style="color: red">
                </asp:BulletedList>
            </asp:PlaceHolder>
            <cb:Notification ID="ExportCompleteMessage" runat="server" Text="ShipStation export completed at {0:t}" SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
        </asp:WizardStep>
    </WizardSteps>
</asp:Wizard>
        </div>
<%--        </ContentTemplate>
</asp:UpdatePanel>--%>
</asp:Content>
