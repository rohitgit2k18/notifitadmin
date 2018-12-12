<%@ Page Title="Merchant Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="AbleCommerce.Admin.Default" EnableViewState="false" %>
<%@ Register src="Dashboard/OrderSummary.ascx" tagname="OrderSummary" tagprefix="uc" %>
<%@ Register src="Dashboard/RecentOrders.ascx" tagname="RecentOrders" tagprefix="uc" %>
<%@ Register src="Dashboard/AdminAlerts.ascx" tagname="AdminAlerts" tagprefix="uc" %>
<%@ Register src="Dashboard/NewsReader.ascx" tagname="NewsReader" tagprefix="uc" %>
<%@ Register src="Dashboard/SalesOverTime.ascx" tagname="SalesOverTime" tagprefix="uc" %>
<%@ Register src="Dashboard/PopularProducts.ascx" tagname="PopularProducts" tagprefix="uc" %>
<%@ Register src="Dashboard/ActivityByHour.ascx" tagname="ActivityByHour" tagprefix="uc" %>
<%@ Register src="Dashboard/HelpAbout.ascx" tagname="HelpAbout" tagprefix="uc" %>
<%@ Register src="~/Admin/Dashboard/Navigate.ascx" tagname="Navigate" tagprefix="uc" %>
<%@ Register src="~/Admin/Dashboard/Configure.ascx" tagname="Configure" tagprefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
<p class="dashboardWelcome"><asp:Localize ID="WelcomeMessage" runat="server" Text="Welcome {0}. Today is {1:D}."></asp:Localize></p>
<ajaxToolkit:TabContainer ID="Tabs" runat="server" OnDemand="true">
    <ajaxToolkit:TabPanel ID="DailyTasksPanel" runat="server" OnDemandMode="Once" HeaderText="Daily Tasks">
        <ContentTemplate>
            <div class="grid_6 alpha">
                <div class="leftColumn">
                    <uc:RecentOrders ID="RecentOrders1" runat="server" />
                    <uc:AdminAlerts ID="AdminAlerts1" runat="server" />
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <uc:OrderSummary ID="OrderSummary1" runat="server" />
                    <uc:NewsReader ID="NewsReader1" runat="server" />
                </div>
            </div>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="NavigatePanel" runat="server" OnDemandMode="Once" HeaderText="Navigate">
        <ContentTemplate>
            <uc:Navigate ID="NavigateTab" runat="server" />
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="ConfigurePanel" runat="server" OnDemandMode="Once" HeaderText="Configure">
        <ContentTemplate>
            <uc:Configure ID="ConfigureTab" runat="server" />
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="ReportsPanel" runat="server" OnDemandMode="Once" HeaderText="Reports">
        <ContentTemplate>
            <div class="grid_6 alpha">
                <div class="leftColumn">
                    <uc:SalesOverTime ID="SalesOverTime1" runat="server" />
                    <uc:PopularProducts ID="PopularProducts1" runat="server" />
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <uc:ActivityByHour ID="ActivityByHour1" runat="server" />
                    <div class="section">
                        <div class="header">
                            <h2>More Reports</h2>
                        </div>
                        <div class="content">
                            <ul>
                                <li><a href="Reports/MonthlySales.aspx">Monthly Sales</a></li>
                                <li><a href="Reports/SalesOverTime.aspx">Sales over Time</a></li>
                                <li><a href="Reports/DailySales.aspx">Daily Sales</a></li>
                                <li><a href="Reports/SalesSummary.aspx">Sales Summary</a></li>
                                <li><a href="Reports/Taxes.aspx">Taxes</a></li>
                                <li><a href="Reports/SalesByProduct.aspx">Sales by Product</a></li>
                                <li><a href="Reports/PopularProducts.aspx">Popular Products</a></li>
                                <li><a href="Reports/PopularCategories.aspx">Popular Categories</a></li>
                                <li><a href="Reports/LowInventory.aspx">Low Inventory</a></li>
                                <li><a href="Reports/TopCustomers.aspx">Sales by Customer</a></li>
                                <li><a href="Reports/MonthlyAbandonedBaskets.aspx">Abandoned Baskets</a></li>
                                <li><a href="Reports/PopularBrowsers.aspx">Browser Popularity</a></li>
                                <li><a href="Reports/SalesByAffiliate.aspx">Sales by Affiliate</a></li>
                                <li><a href="Reports/SalesByReferrer.aspx">Sales by Referrer</a></li>
                                <li><a href="Reports/CouponUsage.aspx">Coupon Usage</a></li>
                                <li><a href="Reports/WhoIsOnline.aspx">Who Is Online?</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
    <ajaxToolkit:TabPanel ID="HelpPanel" runat="server" OnDemandMode="Once" HeaderText="Help">
        <ContentTemplate>
            <div class="grid_6 alpha">
                <div class="leftColumn">
                    <uc:HelpAbout ID="HelpAbout1" runat="server" />
                    <div class="section">
                        <div class="header">
                            <h2>Support and Services</h2>
                        </div>
                        <div class="content">
                            <p>
                                <a href="http://www.ablecommerce.com" target="_blank">www.ablecommerce.com</a> - Sales, subscriptions, and upgrades for AbleCommerce<br />
                                <a href="http://help.ablecommerce.com" target="_blank">help.ablecommerce.com</a> - Software support, news and updates<br />
                                <a href="http://forums.ablecommerce.com" target="_blank">forums.ablecommerce.com</a> - Community and team support<br />
                                <a href="http://wiki.ablecommerce.com" target="_blank">wiki.ablecommerce.com</a> - Development and customization<br />
                                <a href="http://help.ablecommerce.com/acgold/guide" target="_blank">Merchant Guide</a> - Online documentation for AbleCommerce software
                            </p>
                            <p>Call toll free within USA: 1-800-292-7192</p>
                            <p>Outside USA: 1-360-571-5839, Pacific Time</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2>Getting Started</h2>
                        </div>
                        <div class="content">
                            <ol>
                                <li>Configure basic <a href="Store/StoreSettings.aspx">store settings</a> like a timezone, units, inventory messages, and order settings.</li>
                                <li>Make sure your store's <a href="Shipping/Warehouses/Default.aspx">warehouse</a> address and contact information are correct.</li>
                                <li>Decide which <a href="Shipping/Countries/Default.aspx">countries</a> you would like to do business with.</li>
                                <li>If you plan to ship, you can use one of the built-in <a href="Shipping/Providers/Default.aspx">shipping services</a> or <a href="Shipping/Methods/Default.aspx">create your own</a>.</li>
                                <li>Taxes may be applicable. You can create [taxable] areas or use one of the integrated <a href="Taxes/Providers/Default.aspx">tax services</a>.</li>
                                <li>Setup your <a href="Payment/Methods.aspx">payment methods</a> and a <a href="Payment/Gateways.aspx">gateway</a> if you want to accept credit card payments.</li>
                                <li>Before you can enter new products, you'll need to <a href="Catalog/Browse.aspx">create a category</a> first.</li>
                                <li>Let's add new products by clicking the Add Product icon.</li>
                                <li>Preview [your store] and place a test order to make sure everything's working!</li>
                                <li>Now that you have a new order, take a look at the <a href="Orders/Default.aspx">order management</a> features.</li>
                                <li>Customize your <a href="Website/ContentPages/Default.aspx">website</a> or add new webpages.</li>
                                <li>Before taking real orders, make sure the store has a <a href="Store/Security/Licensing.aspx">live license</a> key.</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </ajaxToolkit:TabPanel>
</ajaxToolkit:TabContainer>
    <script type="text/javascript">
        var uvOptions = {};
        (function () {
            var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
            uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/x83J1s25E1SuYEiGtc8byQ.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
        })();
    </script>
</asp:Content>