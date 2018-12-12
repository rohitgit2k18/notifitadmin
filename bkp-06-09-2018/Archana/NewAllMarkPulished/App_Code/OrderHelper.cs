namespace AbleCommerce.Code
{
    using System;
    using System.Collections.Generic;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Common;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Taxes;

    /// <summary>
    /// Classes that assist in retrieving frequently requested data.
    /// </summary>
    public static class OrderHelper
    {
        public static IList<OrderItem> GetOrderItems(Order order)
        {
            IList<OrderItem> allItems = new List<OrderItem>();
            allItems.AddRange(GetNonShippingItems(order));
            foreach (OrderShipment shipment in order.Shipments)
            {
                allItems.AddRange(GetShipmentItems(shipment));
            }
            allItems.Sort(new OrderItemComparer());
            return allItems;
        }

        public static IList<OrderItem> GetNonShippingItems(Order order)
        {
            IList<OrderItem> nonShippingItems = new List<OrderItem>();
            foreach (OrderItem item in order.Items)
            {
                if (DisplayItemForShipment(item, 0))
                    nonShippingItems.Add(item);
            }

            //SHOW TAXES IF SPECIFIED FOR LINE ITEM DISPLAY
            TaxInvoiceDisplay displayMode = TaxHelper.InvoiceDisplay;
            if (displayMode == TaxInvoiceDisplay.LineItem || displayMode == TaxInvoiceDisplay.LineItemRegistered)
            {
                // LOOP ALL BASKET ITEMS
                foreach (OrderItem item in order.Items)
                {
                    // ONLY EXAMINE TAX ITEMS
                    if (item.OrderItemType == OrderItemType.Tax)
                    {
                        // DETERMINE THE PARENT ITEM
                        OrderItem parentItem = GetTaxParentItemForShipping(item);
                        // DISPLAY TAX IF PARENT IS DISPLAYED OR IF THIS IS NOT A CHILD ITEM AND IS NOT PART OF ANY SHIPMENT
                        if (nonShippingItems.IndexOf(parentItem.Id) > -1
                            || (!item.IsChildItem && item.OrderShipmentId == 0))
                        {
                            nonShippingItems.Add(item);
                        }
                    }
                }
            }
            nonShippingItems.Sort(new OrderItemComparer());
            return nonShippingItems;
        }

        public static IList<OrderItem> GetShipmentItems(object dataItem)
        {
            OrderShipment shipment = dataItem as OrderShipment;
            if (shipment != null) return GetShipmentItems(shipment);
            return null;
        }

        public static IList<OrderItem> GetShipmentItems(OrderShipment shipment)
        {
            Order order = shipment.Order;
            IList<OrderItem> shipmentProducts = new List<OrderItem>();
            foreach (OrderItem item in order.Items)
            {
                if (DisplayItemForShipment(item, shipment.Id))
                    shipmentProducts.Add(item);
            }

            //SHOW TAXES IF SPECIFIED FOR LINE ITEM DISPLAY
            TaxInvoiceDisplay displayMode = TaxHelper.InvoiceDisplay;
            if (displayMode == TaxInvoiceDisplay.LineItem || displayMode == TaxInvoiceDisplay.LineItemRegistered)
            {
                // LOOP ALL BASKET ITEMS
                foreach (OrderItem item in order.Items)
                {
                    // ONLY EXAMINE TAX ITEMS
                    if (item.OrderItemType == OrderItemType.Tax)
                    {
                        // DETERMINE THE PARENT ITEM
                        OrderItem parentItem = GetTaxParentItemForShipping(item);
                        // DISPLAY TAX IF PARENT IS DISPLAYED OR IF THIS IS NOT A CHILD ITEM AND IS PART OF THE SHIPMENT
                        if (shipmentProducts.IndexOf(parentItem.Id) > -1
                            || (!item.IsChildItem && item.OrderShipmentId == shipment.Id))
                        {
                            shipmentProducts.Add(item);
                        }
                    }
                }
            }
            shipmentProducts.Sort(new OrderItemComparer());
            return shipmentProducts;
        }

        private static OrderItem GetTaxParentItemForShipping(OrderItem item)
        {
            // IF THIS IS NOT A CHILD ITEM, USE SELF AS TAX PARENT
            if (!item.IsChildItem) return item;

            // IF THIS IS NOT A PRODUCT, DEFER TO THE IMMEDIATE PARENT ITEM AS TAX PARENT
            if (item.OrderItemType != OrderItemType.Product)
                return GetTaxParentItemForShipping(item.GetParentItem(false));

            // DETERMINE IF THIS ITEM IS A CHILD PRODUCT IN A KIT
            OrderItem kitMasterItem = item.GetParentItem(true);

            // IF THE MASTER ITEM SPECIFIES BUNDLED DISPLAY USE MASTER ITEM AS TAX PARENT
            if (!kitMasterItem.ItemizeChildProducts) return kitMasterItem;

            // THE PARENT ITEMIZES DISPLAY, USE SELF AS TAX PARENT
            return item;
        }

        private static bool DisplayItemForShipment(OrderItem item, int shipmentId)
        {
            // DO NOT INCLUDE ITEMS THAT ARE NOT IN THIS SHIPMENT, GIFT CERTIFICATE PAYMENTS, TAXES OR HIDDEN ITEMS
            if (item.OrderShipmentId != shipmentId
                || item.OrderItemType == OrderItemType.GiftCertificatePayment
                || item.OrderItemType == OrderItemType.Tax
                || item.IsHidden) return false;

            // ALWAYS SHOW ROOT ITEMS AND DISCOUNTS
            if (!item.IsChildItem || item.OrderItemType == OrderItemType.Discount) return true;

            // ONLY NON DISCOUNT CHILD ITEMS REACH HERE.  DO NOT SHOW NON-PRODUCT CHILD ITEMS
            if (item.OrderItemType != OrderItemType.Product) return false;

            // ONLY PRODUCT CHILD ITEMS REACH HERE
            OrderItem parentItem = item.GetParentItem(true);

            // IF THE PARENT ITEM IS ITEMIZED, AND THIS CHILD IS NOT HIDDEN, IT IS VISIBLE
            if (parentItem.ItemizeChildProducts && !item.IsHidden) return true;

            // EITHER THE PARENT IS NOT ITEMIZED OR THE ITEM IS HIDDEN.  IN THIS CASE, WE SHOULD 
            // STILL SHOW THE PRODUCT IF THE PARENT IS IN A DIFFERENT SHIPMENT (OR POSSIBLY NON-SHIPPING)
            // THIS AVOIDS THE POSSIBILITY THAT A SHIPMENT WILL APPEAR TO NOT CONTAIN ANY PRODUCTS
            return (parentItem.OrderShipmentId != shipmentId);
        }

        /// <summary>
        /// Gets the products in the order that are visible to the customer
        /// </summary>
        /// <param name="dataItem">The order object</param>
        /// <returns>A collection of products that are visible to the customer</returns>
        public static IList<OrderItem> GetVisibleProducts(object dataItem)
        {
            IList<OrderItem> products = new List<OrderItem>();
            Order order = dataItem as Order;
            if (order != null)
            {
                foreach (OrderItem item in order.Items)
                {
                    if (DisplayProductForOrder(item)) products.Add(item);
                }
            }
            return products;
        }

        private static bool DisplayProductForOrder(OrderItem item)
        {
            // DO NOT INCLUDE GIFT CERTIFICATE PAYMENT ITEMS
            if (item.OrderItemType != OrderItemType.Product) return false;

            // ALWAYS SHOW ROOT ITEMS
            if (!item.IsChildItem) return true;

            // ONLY PRODUCT CHILD ITEMS REACH HERE
            OrderItem parentItem = item.GetParentItem(true);

            // IF THE PARENT ITEM IS ITEMIZED AND THIS CHILD IS NOT HIDDEN, PRODUCT IS VISIBLE
            return (parentItem.ItemizeChildProducts && !item.IsHidden);
        }

        /// <summary>
        /// Attempts to get the order from the current context
        /// </summary>
        /// <returns></returns>
        public static Order GetOrderFromContext()
        {
            Order order = null;
            HttpRequest request = HttpContextHelper.SafeGetRequest();
            if (request != null)
            {
                int orderNumber = AlwaysConvert.ToInt(request.QueryString["OrderNumber"]);
                if (orderNumber > 0)
                {
                    order = OrderDataSource.Load(OrderDataSource.LookupOrderId(orderNumber));
                }

                if (order == null)
                {
                    int orderId = AlwaysConvert.ToInt(request.QueryString["OrderId"]);
                    order = OrderDataSource.Load(orderId);
                }
            }
            return order;
        }

        public static bool HasRecurringSubscriptions(Order order)
        {
            foreach (OrderItem item in order.Items)
            {
                if (HasRecurringSubscriptions(item)) return true;
            }
            return false;
        }

        public static bool HasRecurringSubscriptions(OrderItem item)
        {
            foreach (Subscription s in item.Subscriptions)
            {
                if (s.SubscriptionPlan != null && s.SubscriptionPlan.IsRecurring)
                    return true;
            }
            return false;
        }
    }
}