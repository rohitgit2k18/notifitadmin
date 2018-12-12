<%@ Page Title="My Affiliate Account" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MyAffiliateAccount.aspx.cs" Inherits="AbleCommerce.Members.MyAffiliateAccount" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Account/AffiliateForm.ascx" TagName="AffiliateForm" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_affiliateAccountPage" class="mainContentWrapper">
        <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
        <div class="tabpane">
		    <uc:AffiliateForm ID="AffiliateForm1" runat="server" />
            <asp:Panel ID="AffiliateInfoPanel" runat="server" CssClass="section affiliateInfo">
            <table cellspacing="0" cellpadding="0" class="page" width="100%">
                <tr id="trMultiAccounts" runat="server">
                    <td>
                        <asp:Label ID="AffiliateAccountListLabel" runat="server" Text="Your Affiliate Accounts:" CssClass="fieldHeader" EnableViewState="false"></asp:Label>
                        <asp:DropDownList ID="AffiliateAccountList" runat="server" DataTextField="Name" 
                            DataValueField="AffiliateId" AutoPostBack="true" 
                            onselectedindexchanged="AffiliateAccountList_SelectedIndexChanged"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Localize ID="InstructionText" runat="server" Text="Your affiliate ID is {0}. To associate a link with this affiliate, add <b>{2}={0}</b> to the url. For example: <b>{1}?{2}={0}</b>" EnableViewState="false"></asp:Localize>
                        <br />
                        <asp:Label ID="EditRegistrationMessage" runat="server" Text="To edit your affiliate registration information, "></asp:Label><asp:HyperLink ID="EditAffiliateLink" runat="server" Text="click here." NavigateUrl="~/Members/EditAffiliateAccount.aspx?AffiliateId={0}" EnableViewState="false" ></asp:HyperLink>
                    </td>
                </tr>    
                <tr id="trAffiliateReport" visible="false" runat="server">
                    <td>
                        <div class="pageHeader">
                                    <h1><asp:Localize ID="Caption" runat="server" Text="{0} Sales for {1:MMMM yyyy}" EnableViewState="false"></asp:Localize></h1>
                        </div>
                        <br />
                        <table align="center" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td align="center">
                                    <asp:Button ID="PreviousButton" runat="server" Text="&laquo; Prev" OnClick="PreviousButton_Click" />&nbsp;<asp:Label ID="MonthLabel" runat="server" Text="Month: " CssClass="fieldHeader"></asp:Label>
                                    <asp:DropDownList ID="MonthList" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DateFilter_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Text="January"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="February"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="March"></asp:ListItem>
                                        <asp:ListItem Value="4" Text="April"></asp:ListItem>
                                        <asp:ListItem Value="5" Text="May"></asp:ListItem>
                                        <asp:ListItem Value="6" Text="June"></asp:ListItem>
                                        <asp:ListItem Value="7" Text="July"></asp:ListItem>
                                        <asp:ListItem Value="8" Text="August"></asp:ListItem>
                                        <asp:ListItem Value="9" Text="September"></asp:ListItem>
                                        <asp:ListItem Value="10" Text="October"></asp:ListItem>
                                        <asp:ListItem Value="11" Text="November"></asp:ListItem>
                                        <asp:ListItem Value="12" Text="December"></asp:ListItem>
                                    </asp:DropDownList>&nbsp;
                                    <asp:Label ID="YearLabel" runat="server" Text="Year: " CssClass="fieldHeader"></asp:Label>
                                    <asp:DropDownList ID="YearList" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DateFilter_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    &nbsp;
                                    <asp:Button ID="NextButton" runat="server" Text="Next &raquo;" OnClick="NextButton_Click" />
                                </td>
                            </tr>
                        </table>
                        <br />
                        <asp:Repeater ID="AffiliateSalesRepeater" runat="server" DataSourceID="AffiliateSalesDs" Visible="false">
                            <ItemTemplate>
                                <table align="center" cellpadding="0" cellspacing="0" border="0" width="500px">
                                    <tr>
                                        <td valign="top" width="30%">
                                            <asp:Label ID="ReferralCountLabel" runat="server" Text="Referrals:" CssClass="fieldHeader"></asp:Label>
                                            <asp:Label ID="ReferralCount" runat="server" Text='<%#Eval("ReferralCount") %>'></asp:Label><br />
                                            <asp:Label ID="ConversionRateLabel" runat="server" Text="Conversion Rate:" CssClass="fieldHeader"></asp:Label>
                                            <asp:Label ID="ConversionRate" runat="server" Text='<%#GetConversionRate(Container.DataItem)%>'></asp:Label><br />
                                        </td>
                                        <td valign="top" width="30%">
                                            <asp:Label ID="OrderCountLabel" runat="server" Text="Orders:" CssClass="fieldHeader"></asp:Label>
                                            <asp:Label ID="OrderCount" runat="server" Text='<%#Eval("OrderCount") %>'></asp:Label><br />
                                            <asp:Label ID="ProductSubtotalLabel" runat="server" Text="Products:" CssClass="fieldHeader"></asp:Label>
                                            <asp:Label ID="ProductSubtotal" runat="server" Text='<%#((decimal)Eval("ProductSubtotal")).LSCurrencyFormat("ulc") %>'></asp:Label><br />
                                            <asp:Label ID="OrderTotalLabel" runat="server" Text="Total:" CssClass="fieldHeader"></asp:Label>
                                            <asp:Label ID="OrderTotal" runat="server" Text='<%#((decimal)Eval("OrderTotal")).LSCurrencyFormat("ulc") %>'></asp:Label><br />
                                        </td>
                                        <td valign="top" width="40%">
                                            <asp:Label ID="CommissionRateLabel" runat="server" Text="Rate:" CssClass="fieldHeader"></asp:Label>
                                            <asp:Label ID="CommissionRate" runat="server" Text='<%# GetCommissionRate(Container.DataItem) %>'></asp:Label><br />
                                            <asp:Label ID="CommissionLabel" runat="server" Text="Commission:" CssClass="fieldHeader"></asp:Label>
                                            <asp:Label ID="Commission" runat="server" Text='<%# ((decimal)Eval("Commission")).LSCurrencyFormat("ulc") %>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <div class="pageHeader">
                                                <h2><asp:Localize ID="Caption2" runat="server" Text="Associated Orders" EnableViewState="false"></asp:Localize></h2>
                                            </div>
                                            <asp:GridView ID="OrdersGrid" runat="server" AllowPaging="False" AllowSorting="False" 
                                                AutoGenerateColumns="False" DataKeyNames="OrderId" SkinID="PagedList" Width="100%"
                                                DataSource='<%# GetAffiliateOrders(Container.DataItem) %>'>
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Order #" SortExpression="OrderId">
                                                        <HeaderStyle HorizontalAlign="left" />
                                                        <ItemStyle HorizontalAlign="left" />
                                                        <ItemTemplate>
                                                            <asp:Label ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                                                        <HeaderStyle HorizontalAlign="left" />
                                                        <ItemStyle HorizontalAlign="left" />
                                                        <ItemTemplate>
                                                            <asp:Label ID="OrderDate" runat="server" Text='<%# Eval("OrderDate", "{0:d}") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Products" SortExpression="ProductSubtotal">
                                                        <HeaderStyle HorizontalAlign="left" />
                                                        <ItemStyle HorizontalAlign="left" />
                                                        <ItemTemplate>
                                                            <asp:Label ID="Subtotal" runat="server" Text='<%# ((decimal)Eval("ProductSubtotal")).LSCurrencyFormat("ulc") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Total" SortExpression="TotalCharges">
                                                        <HeaderStyle HorizontalAlign="left" />
                                                        <ItemStyle HorizontalAlign="left" />
                                                        <ItemTemplate>
                                                            <asp:Label ID="Total" runat="server" Text='<%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("ulc") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <EmptyDataTemplate>
                                                    <asp:Label ID="EmptyMessage" runat="server" Text="There are no associated orders for this month."></asp:Label>
                                                </EmptyDataTemplate>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:Repeater>
                        <div align="center">
                            <br /><i><asp:Label ID="ReportTimestamp" runat="server" Text="Report generated {0:MMM-dd-yyyy hh:mm tt}" EnableViewState="false"></asp:Label></i>
                        </div>
                        <asp:HiddenField ID="HiddenStartDate" runat="server" Value="" />
                        <asp:HiddenField ID="HiddenEndDate" runat="server" Value="" />
                        <asp:HiddenField ID="HiddenAffiliateId" runat="server" Value="" />
                        <asp:ObjectDataSource ID="AffiliateSalesDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSalesByAffiliate" 
                            TypeName="CommerceBuilder.Reporting.ReportDataSource">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="HiddenStartDate" Name="startDate" PropertyName="Value" Type="DateTime" />
                                <asp:ControlParameter ControlID="HiddenEndDate" Name="endDate" PropertyName="Value" Type="DateTime" />
                                <asp:ControlParameter ControlID="HiddenAffiliateId" Name="affiliateId" PropertyName="Value" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </td>
                </tr>
            </table>
            </asp:Panel>
        </div>
    </div>
</div>
</asp:Content>
