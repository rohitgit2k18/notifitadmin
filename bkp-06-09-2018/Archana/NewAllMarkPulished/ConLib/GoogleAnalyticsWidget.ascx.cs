namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Text;
    using System.Web.Caching;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    [Description("Widget for Google Analytics Tracking.")]
    public partial class GoogleAnalyticsWidget : System.Web.UI.UserControl
    {
        private StoreSettingsManager _Settings;
        private StringBuilder _GoogleAnalyticsJs;

        private bool IsReceiptPage()
        {
            return (Request.FilePath.IndexOf("Checkout/Receipt.aspx", StringComparison.InvariantCultureIgnoreCase) >= 0);
        }

        private bool IsMyOrderPage()
        {
            return (Request.FilePath.IndexOf("Members/MyOrder.aspx", StringComparison.InvariantCultureIgnoreCase) >= 0);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // DETERMINE IF GA IS ENABLED AND CONFIGURED
            _Settings = AbleContext.Current.Store.Settings;
            if (_Settings.EnableGoogleAnalyticsPageTracking && !string.IsNullOrEmpty(_Settings.GoogleUrchinId))
            {
                // CHECK TO SEE IF WE'VE ALREADY REGISTERED ANALYTICS SCRIPT
                // THIS IS A SAFETY PRECAUTION IN CASE THE CONTROL GETS ADDED 
                // TO THE PAGE MORE THAN ONCE
                if (!Context.Items.Contains("GoogleAnalytics"))
                {
                    // SHOW THE PANEL AND COMPILE THE TRACKING SCRIPT
                    GA.Visible = true;
                    BeginPageTrackerJs();

                    // SEE IF WE NEED TO ADD THE TRANSACCTION SCRIPT FOR RECEIPT PAGE
                    if (_Settings.EnableGoogleAnalyticsEcommerceTracking && (this.IsReceiptPage() || this.IsMyOrderPage()))
                    {
                        Order order = AbleCommerce.Code.OrderHelper.GetOrderFromContext();
                        if (order != null && order.Items.Count > 0)
                        {
                            // TRY TO LIMIT REFRESHES FROM MESSING UP THE TRACKING DATA
                            if (order.OrderDate.AddMinutes(20) > LocaleHelper.LocalNow)
                            {
                                // KEEP A LIST OF THE ORDERS WE PROCESS
                                List<int> googleOrders = Context.Cache.Get("GoogleAnalyticsOrderList") as List<int>;
                                if (googleOrders == null)
                                {
                                    googleOrders = new List<int>();
                                    Cache.Add("GoogleAnalyticsOrderList", googleOrders, null, Cache.NoAbsoluteExpiration, new TimeSpan(0, 1, 0), CacheItemPriority.Normal, null);
                                }

                                // IF WE DON'T HAVE THE ORDER IN OUR LIST, OUTPUT ANALYTICS
                                if (!googleOrders.Contains(order.Id))
                                {
                                    AddEcommerceJs(order);
                                    googleOrders.Add(order.Id);
                                }
                            }
                        }
                    }

                    // FINALIZE GA SCRIPT, REGISTER, AND PREVENT REPEAT PROCESSING
                    ClosePageTrackerJs();
                    this.Page.Header.Controls.Add(new LiteralControl(_GoogleAnalyticsJs.ToString()));
                    this.Context.Items.Add("GoogleAnalytics", true);
                }
            }
        }

        private void BeginPageTrackerJs()
        {
            _GoogleAnalyticsJs = new StringBuilder();
            _GoogleAnalyticsJs.AppendLine("<script type=\"text/javascript\">");
            _GoogleAnalyticsJs.AppendLine("var _gaq = _gaq || [];");
            _GoogleAnalyticsJs.AppendLine("_gaq.push(['_setAccount', '" + _Settings.GoogleUrchinId + "']);");
            _GoogleAnalyticsJs.AppendLine("_gaq.push(['_trackPageview']);");
        }

        private void AddEcommerceJs(Order order)
        {
            // CALCULATE THE TRANSACTION TOTALS
            decimal shippingTotal = 0;
            decimal taxTotal = 0;
            decimal orderTotal = 0;
            foreach (OrderItem item in order.Items)
            {
                decimal extendedPrice = item.ExtendedPrice;
                switch (item.OrderItemType)
                {
                    case OrderItemType.Shipping:
                    case OrderItemType.Handling:
                        shippingTotal += extendedPrice;
                        break;
                    case OrderItemType.Tax:
                        taxTotal += extendedPrice;
                        break;
                    default:
                        break;
                }
                orderTotal += extendedPrice;
            }

            // REGISTER THE TRANSACTION TOTALS
            _GoogleAnalyticsJs.Append("_gaq.push(['_addTrans',");
            _GoogleAnalyticsJs.Append(string.Format("'{0}',", order.OrderNumber)); // order ID - required
            _GoogleAnalyticsJs.Append(string.Format("'{0}',", AbleContext.Current.Store.Name.Replace("'", string.Empty))); // affiliation or store name
            _GoogleAnalyticsJs.Append(string.Format("'{0:F2}',", orderTotal)); // total - required
            _GoogleAnalyticsJs.Append(string.Format("'{0:F2}',", taxTotal)); // tax
            _GoogleAnalyticsJs.Append(string.Format("'{0:F2}',", shippingTotal)); // shipping
            _GoogleAnalyticsJs.Append(string.Format("'{0}',", order.BillToCity.Replace("'", string.Empty))); // city
            _GoogleAnalyticsJs.Append(string.Format("'{0}',", order.BillToProvince.Replace("'", string.Empty))); // state or province
            _GoogleAnalyticsJs.Append(string.Format("'{0}'", order.BillToCountryCode)); // country
            _GoogleAnalyticsJs.AppendLine("]);");

            // REGISTER EACH ITEM
            foreach (OrderItem item in order.Items)
            {
                if (item.OrderItemType == OrderItemType.Product)
                {
                    // REGISTER THIS ITEM
                    _GoogleAnalyticsJs.Append("_gaq.push(['_addItem',");
                    _GoogleAnalyticsJs.Append(string.Format("'{0}',", order.OrderNumber)); // order ID - required
                    _GoogleAnalyticsJs.Append(string.Format("'{0}',", GetItemSku(item))); // SKU/code
                    _GoogleAnalyticsJs.Append(string.Format("'{0:F2}',", GetItemName(item))); // productName
                    _GoogleAnalyticsJs.Append(string.Format("'{0:F2}',", GetCategoryName(item))); // category or variation
                    _GoogleAnalyticsJs.Append(string.Format("'{0:F2}',", GetItemPrice(order, item))); // unit price - required
                    _GoogleAnalyticsJs.Append(string.Format("'{0}'", item.Quantity)); // quantity - required
                    _GoogleAnalyticsJs.AppendLine("]);");
                }
            }

            // COMMIT THE TRANSACTION
            _GoogleAnalyticsJs.Append("_gaq.push(['_trackTrans']);");
        }

        private void ClosePageTrackerJs()
        {
            _GoogleAnalyticsJs.AppendLine("(function() {");
            _GoogleAnalyticsJs.AppendLine("var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;");
            _GoogleAnalyticsJs.AppendLine("ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';");
            _GoogleAnalyticsJs.AppendLine("(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);");
            _GoogleAnalyticsJs.AppendLine("})();");
            _GoogleAnalyticsJs.AppendLine("</script>");
        }

        private string GetItemSku(OrderItem item)
        {
            if (string.IsNullOrEmpty(item.Sku)) return item.ProductId.ToString();
            return SanitizeInput(item.Sku);
        }

        private string GetItemName(OrderItem item)
        {
            return SanitizeInput(item.Name);
        }

        private string GetCategoryName(OrderItem item)
        {
            if (item.Product != null && item.Product.Categories.Count > 0)
            {
                int categoryId = item.Product.Categories[0];
                Category category = CategoryDataSource.Load(categoryId);
                if (category != null) return SanitizeInput(category.Name);
            }
            return string.Empty;
        }

        private decimal GetItemPrice(Order order, OrderItem parentItem)
        {
            OrderItemType[] includedChildTypes = { OrderItemType.Charge, OrderItemType.Coupon, OrderItemType.Credit, OrderItemType.Discount };
            decimal totalPrice = parentItem.ExtendedPrice;
            foreach (OrderItem childItem in order.Items)
            {
                if (childItem.ParentItemId == parentItem.Id
                    && childItem.Id != parentItem.Id
                    && Array.IndexOf(includedChildTypes, childItem.OrderItemType) > -1)
                {
                    totalPrice += childItem.ExtendedPrice;
                }
            }
            return ((decimal)totalPrice / (decimal)parentItem.Quantity);
        }

        private string SanitizeInput(string value)
        {
            return value.Replace("'", string.Empty);
        }
    }
}