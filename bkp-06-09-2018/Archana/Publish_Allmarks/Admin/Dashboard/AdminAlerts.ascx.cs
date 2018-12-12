namespace AbleCommerce.Admin.Dashboard
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.Caching;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Configuration;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;

    public partial class AdminAlerts : System.Web.UI.UserControl
    {
        protected void RefreshButton_Click(object sender, EventArgs e)
        {
            Cache.Remove("AdminAlerts");
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            List<string> alertList;
            DateTime cacheDate;
            CacheWrapper alertWrapper = Cache.Get("AdminAlerts") as CacheWrapper;
            if (alertWrapper == null)
            {
                alertList = new List<string>();

                //Check if installation directory still exists
                if (System.IO.Directory.Exists(Request.MapPath("~/Install")))
                {
                    string alertText = "The 'Install' directory still exists in your store. It should be removed immediately after the Installation is complete.";
                    alertList.Add(alertText);
                }

                // CHECK IF EMAIL TEMPLATES ARE CONFIGURED, WITHOUT EMAIL SERVER SETTINGS
                Store store = AbleContext.Current.Store;
                if ((store.EmailTemplates.Count > 0))
                {
                    if (string.IsNullOrEmpty(store.Settings.SmtpServer))
                    {
                        string alertText = "You have email templates configured, but you have not provided an SMTP (mail) server.  Without a serv" +
                        "er, email notifications cannot be sent.  <a href=\'Store/EmailTemplates/Settings.aspx\'>Click here</a> to configure " +
                        "email now.";
                        alertList.Add(alertText);
                    }
                }
                //VALIDATE ORDER STATUSES
                //CHECK FOR A STATUS ATTACHED TO THE ORDER PLACED EVENT
                OrderStatus status = OrderStatusTriggerDataSource.LoadForStoreEvent(StoreEvent.OrderPlaced);
                if (status == null)
                {
                    status = new OrderStatus();
                    status.Name = "Payment Pending";
                    status.DisplayName = "Payment Pending";
                    status.IsActive = false;
                    status.IsValid = true;
                    status.Triggers.Add(new OrderStatusTrigger(StoreEvent.OrderPlaced, status));
                    status.Save();
                    alertList.Add("You did not have an order status assigned to the 'Order Placed' event, so one was created for you.  <a href=\"Store/OrderStatuses/Default.aspx\">Click here</a> to check the order status configuration for your store.");
                }
                //CHECK FOR A STATUS ATTACHED TO THE ORDER CANCELLED EVENT
                status = OrderStatusTriggerDataSource.LoadForStoreEvent(StoreEvent.OrderCancelled);
                if (status == null)
                {
                    status = new OrderStatus();
                    status.Name = "Cancelled";
                    status.DisplayName = "Cancelled";
                    status.IsActive = false;
                    status.IsValid = false;
                    status.Triggers.Add(new OrderStatusTrigger(StoreEvent.OrderCancelled, status));
                    status.Save();
                    alertList.Add("You did not have an order status assigned to the 'Order Cancelled' event, so one was created for you.  <a href=\"Store/OrderStatuses/Default.aspx\">Click here</a> to check the order status configuration for your store.");
                }

                //MAKE SURE AT LEAST ONE PRODUCT EXISTS
                int productCount = ProductDataSource.CountAll();
                if (productCount == 0)
                {
                    alertList.Add("You have not yet added any products in your store.  <a href=\"Catalog/Browse.aspx\">Click here</a> to manage your catalog now.");
                }

                //MAKE SURE AT LEAST ONE SHIPPING METHOD EXISTS
                int shipMethodCount = ShipMethodDataSource.CountAll();
                if (shipMethodCount == 0)
                {
                    alertList.Add("You do not have any shipping methods configured.  Your customers will not be able to complete checkout if the order contains any shippable products.  <a href=\"Shipping/Methods/Default.aspx\">Click here</a> to manage shipping methods now.");
                }

                //CHECK FOR LOW INVENTORY PRODUCTS
                int lowInventoryProducts = ProductInventoryDataSource.GetLowProductInventoryCount();
                if (lowInventoryProducts > 0)
                {
                    alertList.Add("One or more products are at or below their low inventory warning level.  You can view these products <a href=\"Reports/LowInventory.aspx\">here</a>.");
                }

                //CHECK FOR PRESENCE OF ERRORS
                int errorCount = ErrorMessageDataSource.CountAll();
                if (errorCount > 0)
                {
                    string errorAlert = string.Format("There are {0} messages in your <a href=\"Help/ErrorLog.aspx\">error log</a>.  You should review these messages and take corrective action if necessary.", errorCount);
                    alertList.Add(errorAlert);
                }

                //Check of SSL is not enabled
                StoreSettingsManager storeSettings = AbleContext.Current.Store.Settings;
                if (!storeSettings.SSLEnabled)
                {
                    string alertText = "SSL is not enabled. Your store is currently being accessed over an insecure connection. <a href=\"Store/Security/Default.aspx\">Click Here</a> to change SSL settings.";
                    alertList.Add(alertText);
                }

                //MAKE SURE ORDER NUMBER INCREMENT IS VALID
                if (store.OrderIdIncrement < 1)
                {
                    string alertText = "The order number increment for your store was " + store.OrderIdIncrement + " (invalid).  The increment has been updated to 1.  <a href=\"Store/StoreSettings.aspx\">Click Here</a> to review this setting.";
                    alertList.Add(alertText);
                    store.OrderIdIncrement = 1;
                    store.Save();
                }

                //ALERT FOR ORDER NUMBER PROBLEM
                int maxOrderNumber = StoreDataSource.GetMaxOrderNumber();
                int nextOrderNumber = StoreDataSource.GetNextOrderNumber(false);
                if (maxOrderNumber >= nextOrderNumber)
                {
                    int newOrderNumber = maxOrderNumber + store.OrderIdIncrement;
                    StoreDataSource.SetNextOrderNumber(newOrderNumber);
                    string alertText = "The next order number of {0} is less than the highest assigned order number of {1}.  We have automatically increased your next order number to {2} to prevent errors.  <a href=\"Store/StoreSettings.aspx\">Click Here</a> to review this setting.";
                    alertList.Add(string.Format(alertText, nextOrderNumber, maxOrderNumber, newOrderNumber));
                }

                //MAKE SURE A VALID ENCRYPTION KEY IS PRESENT
                bool encryptionKeyValid;
                try
                {
                    encryptionKeyValid = EncryptionKeyManager.IsKeyValid(EncryptionKeyManager.Instance.CurrentKey.KeyData);
                }
                catch
                {
                    encryptionKeyValid = false;
                }
                if (!encryptionKeyValid)
                {
                    //ENCRYPTION KEY IS MISSING OR INVALID, SEE WHETHER WE ARE STORING CARD DATA
                    if (storeSettings.EnableCreditCardStorage)
                    {
                        string alertText = "Your store encryption key is missing or invalid, and you have not disabled storage of card data.  You should either <a href=\"Store/Security/EncryptionKey.aspx\">set the encryption key</a> or <a href=\"Store/Security/Default.aspx\">disable credit card storage</a>.";
                        alertList.Add(alertText);
                    }
                }

                // ALERT FOR PRODUCT IMAGE LOOKUP BY SKU
                if (storeSettings.ImageSkuLookupEnabled)
                {
                    // SEARCH FOR PRODUCTS MISSING SKU AND MISSING IMAGE URLs
                    ICriteria productCriteria = NHibernateHelper.CreateCriteria<Product>()
                        .Add(new Disjunction()
                        .Add(Restrictions.IsNull("Sku"))
                        .Add(Restrictions.Eq("Sku", string.Empty)))
                        .Add(new Disjunction()
                        .Add(Restrictions.IsNull("ImageUrl"))
                        .Add(Restrictions.IsNull("IconUrl"))
                        .Add(Restrictions.IsNull("ThumbnailUrl")))
                        .Add(Restrictions.Eq("VisibilityId", (byte)CatalogVisibility.Public));

                    IList<Product> products = ProductDataSource.LoadForCriteria(productCriteria);
                    if (products != null && products.Count > 0)
                    {
                        StringBuilder textBuilder = new StringBuilder();
                        textBuilder.Append("Following product(s) are missing SKU, and also do not have image paths provided:<br/>");
                        textBuilder.Append("<ul>");

                        int counter = 0; // PRODUCT COUNTER, SHOW ONLY FIRST FIVE PRODUCTS
                        foreach (Product product in products)
                        {
                            counter++;
                            textBuilder.Append("<li><a href=\"products/EditProduct.aspx?ProductId=" + product.Id + "\">" + product.Name + "</a>.</li>");
                            if (counter >= 5) break;
                        }
                        textBuilder.Append("<ul>");
                        alertList.Add(textBuilder.ToString());
                    }
                }

                // LOOK FOR UNREAD NOTES
                ICriteria orderNoteCriteria = NHibernateHelper.CreateCriteria<OrderNote>()
                    .Add(Restrictions.Eq("IsRead", false))
                    .Add(Restrictions.Not(Restrictions.Eq("NoteTypeId", (byte)NoteType.SystemPublic)))
                    .Add(Restrictions.Not(Restrictions.Eq("NoteTypeId", (byte)NoteType.SystemPrivate)));
                int unreadNoteCount = OrderNoteDataSource.CountForCriteria(orderNoteCriteria);
                if (unreadNoteCount > 0)
                {
                    string alertText = "There are {0} unread order note(s).  <a href=\"Orders/OrderNotesManager.aspx\">review now</a>";
                    alertList.Add(string.Format(alertText, unreadNoteCount));
                }

                // CHECK ANON USER MAINTENANCE SETTINGS
                if (store.Settings.AnonymousUserLifespan < 1 || store.Settings.AnonymousAffiliateUserLifespan < 1)
                {
                    alertList.Add("You have not configured the number of days to save anonymous user records.  You should visit the <a href=\"Store/Maintenance.aspx\">Configure > Maintenance</a> menu, view the status of the anonymous user database, and update your anonymous user maintenance settings.");
                }

                // ALERT FOR DUPLICATE COUPON CODES
                IList<Coupon> duplicateCoupons = NHibernateHelper.CreateSQLQuery("SELECT * FROM ac_Coupons WHERE CouponCode IN (SELECT LOWER(CouponCode) FROM ac_Coupons GROUP BY CouponCode HAVING COUNT(*) > 1)").AddEntity(typeof(Coupon)).List<Coupon>();
                if (duplicateCoupons.Count > 0)
                {
                    Dictionary<string, List<Coupon>> codeCounts = new Dictionary<string, List<Coupon>>();
                    foreach (Coupon coupon in duplicateCoupons)
                    {
                        string normalizedKey = coupon.CouponCode.ToUpperInvariant();
                        if (!codeCounts.ContainsKey(normalizedKey)) codeCounts[normalizedKey] = new List<Coupon>();
                        codeCounts[normalizedKey].Add(coupon);
                    }
                    StringBuilder alertText = new StringBuilder();
                    alertText.Append("<p>You have coupons that have duplicate codes.  Duplicates should be eliminated as a unique constraint will be applied in a future release:</p>");
                    foreach (string couponCode in codeCounts.Keys)
                    {
                        alertText.Append("<p><b>" + couponCode + ":</b> ");
                        string delimiter = string.Empty;
                        foreach (Coupon coupon in codeCounts[couponCode])
                        {
                            alertText.Append(delimiter);
                            alertText.Append("<a href=\"Marketing/Coupons/EditCoupon.aspx?CouponId=" +coupon.Id + "\">" + coupon.Name + "</a>");
                            delimiter = ", ";
                        }
                        alertText.Append("</p>");
                    }
                    alertList.Add(alertText.ToString());
                }

                //UPDATE CACHE
                alertWrapper = new CacheWrapper(alertList);
                Cache.Remove("AdminAlerts");
                Cache.Add("AdminAlerts", alertWrapper, null, DateTime.UtcNow.AddMinutes(15), Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
            }
            else
            {
                alertList = (List<string>)alertWrapper.CacheValue;
            }
            cacheDate = alertWrapper.CacheDate;

            if (alertList.Count == 0) alertList.Add("no action items available");
            AlertList.DataSource = alertList;
            AlertList.DataBind();
            CachedAt.Text = string.Format("{0:g}", cacheDate);
        }
    }
}