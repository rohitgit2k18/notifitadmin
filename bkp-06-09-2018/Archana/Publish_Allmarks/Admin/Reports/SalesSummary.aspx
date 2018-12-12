<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Reports._SalesSummary" Title="Sales Summary Report" CodeFile="SalesSummary.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1>
                        <asp:Localize ID="Caption" runat="server" Text="Sales Summary Report"></asp:Localize>
                        <asp:Localize ID="FromCaption" runat="server" Text=" from {0}" Visible="false" EnableViewState="false"></asp:Localize>
                        <asp:Localize ID="ToCaption" runat="server" Text=" to {0}" Visible="false" EnableViewState="false"></asp:Localize>
                   </h1>
                   <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/sales" />
                </div>
            </div>
            <div class="searchPanel">
                <div class="reportNav">
                    <asp:Label ID="StartDateLabel" runat="server" Text="Show summary from:" SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="StartDate" runat="server" />
                    <asp:Label ID="EndDateLabel" runat="server" Text="to" SkinID="FieldHeader"></asp:Label>
                    <uc1:PickerAndCalendar ID="EndDate" runat="server" />
                    <asp:Button ID="ProcessButton" runat="server" Text="Report" OnClick="ProcessButton_Click" />
                </div>
            </div>
            <asp:Panel ID="ReportPanel" runat="server" CssClass="content" Visible="false">
                <table class="report" width="500">                   
                    <tr class="oddRow">
                        <th width="50%">Product Sales:</th>
                        <td class="amount"><asp:Label ID="ProductSales" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="evenRow">
                        <th>Cost of Goods:</th>
                        <td class="amount"><asp:Label ID="CostOfGoods" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="oddRow">
                        <th>Less Discounts:</th>
                        <td class="amount"><asp:Label ID="ProductDiscounts" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="evenRow">
                        <th>Total Product Sales:</th>
                        <td class="amount"><asp:Label ID="ProductSalesLessDiscounts" runat="server" EnableViewState="false" /></td>
                    </tr>
                </table><br />
                <table class="report" width="500">
                    <tr class="evenRow">
                        <th width="50%">Gift Wrap Charges:</th>
                        <td class="amount"><asp:Label ID="GiftWrapCharges" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="oddRow">
                        <th>Coupons Redeemed:</th>
                        <td class="amount"><asp:Label ID="CouponsRedeemed" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="evenRow">
                        <th>Tax Charges:</th>
                        <td class="amount"><asp:Label ID="TaxesCollected" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="oddRow">
                        <th>Shipping Charges:</th>
                        <td class="amount"><asp:Label ID="ShippingCharges" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="evenRow">
                        <th>Total Charges:</th>
                        <td class="amount"><asp:Label ID="TotalCharges" runat="server" EnableViewState="false" /></td>
                    </tr>
                </table><br />
                <table class="report" width="500">
                    <tr class="oddRow">
                        <th width="50%">Total Number of Orders:</th>
                        <td class="amount"><asp:Label ID="TotalOrders" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="evenRow">
                        <th>Total Items Sold:</th>
                        <td class="amount"><asp:Label ID="TotalItemsSold" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="oddRow">
                        <th>Number of Customers:</th>
                        <td class="amount"><asp:Label ID="NumberOfCustomers" runat="server" EnableViewState="false" /></td>
                    </tr>
                    <tr class="evenRow">
                        <th>Average Order Amount:</th>
                        <td class="amount"><asp:Label ID="AverageOrderAmount" runat="server" EnableViewState="false" /></td>
                    </tr>
                </table>                            
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

