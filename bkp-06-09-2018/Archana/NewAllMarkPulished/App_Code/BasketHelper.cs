namespace AbleCommerce.Code
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    /// <summary>
    /// Classes that assist in retrieving frequently requested data.
    /// </summary>
    public static class BasketHelper
    {
        private static OrderItemType[] _displayItemTypes = { OrderItemType.Product, OrderItemType.Discount, OrderItemType.Coupon, OrderItemType.GiftWrap };
        private static OrderItemType[] _displayItemTypesWithShipping = { OrderItemType.Product, OrderItemType.Discount, OrderItemType.Coupon, OrderItemType.GiftWrap, OrderItemType.Shipping, OrderItemType.Handling };

        public static IList<BasketItem> GetNonShippingItems(Basket basket)
        {
            IList<BasketItem> nonShippingItems = new List<BasketItem>();
            foreach (BasketItem item in basket.Items)
            {
                if (DisplayItemForShipment(item, 0))
                    nonShippingItems.Add(item);
            }

            //SHOW TAXES IF SPECIFIED FOR LINE ITEM DISPLAY
            if (TaxHelper.GetEffectiveInvoiceDisplay(basket.User) == TaxInvoiceDisplay.LineItem)
            {
                // LOOP ALL BASKET ITEMS
                foreach (BasketItem item in basket.Items)
                {
                    // ONLY EXAMINE TAX ITEMS
                    if (item.OrderItemType == OrderItemType.Tax)
                    {
                        // DETERMINE THE PARENT ITEM
                        BasketItem parentItem = GetTaxParentItemForShipping(item);
                        // DISPLAY TAX IF PARENT IS DISPLAYED OR IF THIS IS NOT A CHILD ITEM AND IS NOT PART OF ANY SHIPMENT
                        if (nonShippingItems.IndexOf(parentItem.Id) > -1
                            || (!item.IsChildItem && item.ShipmentId == 0))
                        {
                            nonShippingItems.Add(item);
                        }
                    }
                }
            }
            nonShippingItems.Sort(new BasketItemComparer());
            return nonShippingItems;
        }

        public static IList<BasketItem> GetShipmentItems(object dataItem)
        {
            BasketShipment shipment = dataItem as BasketShipment;
            if (shipment != null) return GetShipmentItems(shipment);
            return null;
        }

        public static IList<BasketItem> GetShipmentItems(BasketShipment shipment)
        {
            Basket basket = shipment.Basket;
            IList<BasketItem> shipmentProducts = new List<BasketItem>();
            foreach (BasketItem item in basket.Items)
            {
                if (DisplayItemForShipment(item, shipment.Id))
                    shipmentProducts.Add(item);
            }

            //SHOW TAXES IF SPECIFIED FOR LINE ITEM DISPLAY
            if (TaxHelper.GetEffectiveInvoiceDisplay(basket.User) == TaxInvoiceDisplay.LineItem)
            {
                // LOOP ALL BASKET ITEMS
                foreach (BasketItem item in basket.Items)
                {
                    // ONLY EXAMINE TAX ITEMS
                    if (item.OrderItemType == OrderItemType.Tax)
                    {
                        // DETERMINE THE PARENT ITEM
                        BasketItem parentItem = GetTaxParentItemForShipping(item);
                        // DISPLAY TAX IF PARENT IS DISPLAYED OR IF THIS IS NOT A CHILD ITEM AND IS PART OF THE SHIPMENT
                        if (shipmentProducts.IndexOf(parentItem.Id) > -1
                            || (!item.IsChildItem && item.ShipmentId == shipment.Id))
                        {
                            shipmentProducts.Add(item);
                        }
                    }
                }
            }
            shipmentProducts.Sort(new BasketItemComparer());
            return shipmentProducts;
        }

        private static BasketItem GetTaxParentItemForShipping(BasketItem item)
        {
            // IF THIS IS NOT A CHILD ITEM, USE SELF AS TAX PARENT
            if (!item.IsChildItem) return item;
            
            // CHECK FOR A VALID PARENT
            BasketItem parentItem = item.GetParentItem(false);
            if (parentItem != null)
            {
                // IF THIS IS NOT A PRODUCT, DEFER TO THE IMMEDIATE PARENT ITEM AS TAX PARENT
                if (item.OrderItemType != OrderItemType.Product)
                    return GetTaxParentItemForShipping(parentItem);

                // DETERMINE IF THIS ITEM IS A CHILD PRODUCT IN A KIT
                BasketItem kitMasterItem = item.GetParentItem(true);
                if (kitMasterItem != null)
                {
                    Product kitMasterProduct = kitMasterItem.Product;
                    if (kitMasterProduct != null && kitMasterProduct.KitStatus == KitStatus.Master)
                    {
                        // ITEM IS A CHILD PRODUCT IN A KIT, IF THE KIT IS BUNDLED USE MASTER ITEM AS TAX PARENT
                        if (!kitMasterProduct.Kit.ItemizeDisplay) return kitMasterItem;
                    }
                }
            }

            // ITEM IS NOT PART OF A KIT, OR IS IN AN ITEMIZED KIT, USE SELF AS TAX PARENT
            return item;
        }

        private static bool DisplayItemForShipment(BasketItem item, int shipmentId)
        {
            // DO NOT INCLUDE ITEMS THAT ARE NOT IN THIS SHIPMENT, GIFT CERTIFICATE PAYMENTS, OR TAXES
            if (item.ShipmentId != shipmentId
                || item.OrderItemType == OrderItemType.GiftCertificatePayment
                || item.OrderItemType == OrderItemType.Tax) return false;

            // ALWAYS SHOW ROOT ITEMS AND DISCOUNTS
            if (!item.IsChildItem || item.OrderItemType == OrderItemType.Discount) return true;

            // ONLY NON DISCOUNT CHILD ITEMS REACH HERE.  DO NOT SHOW NON-PRODUCT CHILD ITEMS
            if (item.OrderItemType != OrderItemType.Product) return false;

            // ONLY PRODUCT CHILD ITEMS REACH HERE
            BasketItem parentItem = item.GetParentItem(true);

            // IF THE PARENT ITEM IS ITEMIZED, CHILD PRODUCTS ARE VISIBLE
            if (parentItem != null && parentItem.Product != null && parentItem.Product.Kit != null && parentItem.Product.Kit.ItemizeDisplay) return true;

            // THE PARENT IS NOT ITEMIZED.  IN THIS CASE, WE SHOULD STILL SHOW THE PRODUCT IF THE 
            // PARENT IS IN A DIFFERENT SHIPMENT (OR POSSIBLY NON-SHIPPING) THIS AVOIDS THE 
            // POSSIBILITY THAT A SHIPMENT WILL APPEAR TO NOT CONTAIN ANY PRODUCTS
            return (parentItem.ShipmentId != shipmentId);
        }

        private static bool DisplayBasketItem(BasketItem item, bool includeShipping)
        {
            // DO NOT INCLUDE ITEMS THAT ARE NOT OF A DISPLAYABLE TYPES
            if (includeShipping)
            {
                if (Array.IndexOf(_displayItemTypesWithShipping, item.OrderItemType) < 0) return false;
            }
            else
            {
                if (Array.IndexOf(_displayItemTypes, item.OrderItemType) < 0) return false;
            }

            // ALWAYS SHOW ROOT ITEMS AND NON PRODUCT ITEMS
            if (!item.IsChildItem || item.OrderItemType != OrderItemType.Product) return true;

            // ONLY PRODUCT CHILD ITEMS REACH HERE
            BasketItem parentItem = item.GetParentItem(true);

            // IF THE PARENT ITEM IS ITEMIZED, CHILD PRODUCTS ARE VISIBLE
            if (parentItem != null && parentItem.Product != null && parentItem.Product.Kit != null && parentItem.Product.Kit.ItemizeDisplay) return true;
            else return false;
        }

        /// <summary>
        /// Gets the displayable items for a basket
        /// </summary>
        /// <param name="basket">the basket</param>
        /// <param name="includeShipping">whether or not to include shipping charges in displayed items list</param>
        /// <param name="alwaysIncludeTaxes">if true forces taxes to be included in the displayed items list even if
        /// the shopping display is not configured to display them</param>
        /// <returns>the displayable items for the basket</returns>
        public static IList<BasketItem> GetDisplayItems(Basket basket, bool includeShipping, bool alwaysIncludeTaxes = false)
        {
            // ADD STANDARD DISPLAY ITEMS
            IList<BasketItem> displayedBasketItems = new List<BasketItem>();
            foreach (BasketItem item in basket.Items)
            {
                if (DisplayBasketItem(item, includeShipping)) displayedBasketItems.Add(item);
            }

            // ADD IN TAX ITEMS IF SPECIFIED FOR DISPLAY
            if (alwaysIncludeTaxes || TaxHelper.GetEffectiveShoppingDisplay(basket.User) == TaxShoppingDisplay.LineItem)
            {
                // TAXES SHOULD BE SHOWN
                foreach (BasketItem item in basket.Items.Where(bi=>bi.OrderItemType== OrderItemType.Tax))
                {
                    displayedBasketItems.Add(item);
                    if (AbleContext.Current.User.IsAnonymous && !AbleContext.Current.User.PrimaryAddress.IsValid)
                        item.Name = "<span class=\"item\">" + item.Name + " (estimated)</span>";
                }
            }

            // SORT ITEMS, THEN COMBINE ORDER COUPON ITEMS FOR DISPLAY
            displayedBasketItems.Sort(new BasketItemComparer());
            displayedBasketItems = displayedBasketItems.CombineOrderCoupons();
            return displayedBasketItems;
        }

        /// <summary>
        /// Gets the displayable items for invoice pages
        /// </summary>
        /// <param name="basket">the basket</param>
        /// <param name="includeShipping">whether or not to include shipping charges in displayed items list</param>
        /// <param name="alwaysIncludeTaxes">if true forces taxes to be included in the displayed items list even if
        /// the invoice display is not configured to display them</param>
        /// <returns>the displayable items for the invoice pages</returns>
        public static IList<BasketItem> GetDisplayItemsForInvoice(Basket basket, bool includeShipping, bool alwaysIncludeTaxes = false)
        {
            // ADD STANDARD DISPLAY ITEMS
            IList<BasketItem> displayedBasketItems = new List<BasketItem>();
            foreach (BasketItem item in basket.Items)
            {
                if (DisplayBasketItem(item, includeShipping)) displayedBasketItems.Add(item);
            }

            // ADD IN TAX ITEMS IF SPECIFIED FOR DISPLAY
            if (alwaysIncludeTaxes || TaxHelper.GetEffectiveInvoiceDisplay(basket.User) == TaxInvoiceDisplay.LineItem)
            {
                // TAXES SHOULD BE SHOWN
                foreach (BasketItem item in basket.Items.Where(bi => bi.OrderItemType == OrderItemType.Tax))
                {
                    displayedBasketItems.Add(item);
                    if (AbleContext.Current.User.IsAnonymous && !AbleContext.Current.User.PrimaryAddress.IsValid)
                    item.Name = "<span class=\"item\">" + item.Name + " (estimated)</span>";
                }
            }

            // SORT ITEMS, THEN COMBINE ORDER COUPON ITEMS FOR DISPLAY
            displayedBasketItems.Sort(new BasketItemComparer());
            displayedBasketItems = displayedBasketItems.CombineOrderCoupons();
            return displayedBasketItems;
        }

        public static void SaveBasket(GridView BasketGrid)
        {
            Basket basket = AbleContext.Current.User.Basket;
            int rowIndex = 0;
            foreach (GridViewRow saverow in BasketGrid.Rows)
            {
                int basketItemId = (int)BasketGrid.DataKeys[rowIndex].Value;
                int itemIndex = basket.Items.IndexOf(basketItemId);
                if ((itemIndex > -1))
                {
                    BasketItem item = basket.Items[itemIndex];
                    if (item.OrderItemType == OrderItemType.Product && !item.IsChildItem)
                    {
                        TextBox quantity = (TextBox)saverow.FindControl("Quantity");
                        if (quantity != null)
                        {
                            int qty = AlwaysConvert.ToInt(quantity.Text, item.Quantity);
                            if (qty > System.Int16.MaxValue)
                            {
                                item.Quantity = System.Int16.MaxValue;
                            }
                            else
                            {
                                item.Quantity = (System.Int16)qty;
                            }

                            // Update for Minimum Maximum quantity of product
                            if (item.Quantity < item.Product.MinQuantity)
                            {
                                item.Quantity = item.Product.MinQuantity;
                                quantity.Text = item.Quantity.ToString();
                            }
                            else if ((item.Product.MaxQuantity > 0) && (item.Quantity > item.Product.MaxQuantity))
                            {
                                item.Quantity = item.Product.MaxQuantity;
                                quantity.Text = item.Quantity.ToString();
                            }
                        }
                    }
                    rowIndex++;
                }
            }
            basket.Save();
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);
            foreach (var rec in basket.Items) {
                rec.Price = Math.Abs(rec.Price);
            }
        }

        public static bool ContainsAnItemWithGiftWrap(Basket basket)
        {
            bool hasItemWithGiftWrap = false;
            foreach (BasketItem basketItem in basket.Items)
            {
                if (basketItem.OrderItemType == OrderItemType.Product)
                {
                    if (basketItem.Product.WrapGroup != null && basketItem.Product.WrapGroup.Id > 0)
                    {
                        hasItemWithGiftWrap = true;
                        break;
                    }
                }
            }
            return hasItemWithGiftWrap;
        }

        public static bool HasRecurringSubscriptions(Basket basket)
        {
            foreach (BasketItem item in basket.Items)
            {
                if (HasRecurringSubscriptions(item)) return true;
            }
            return false;
        }

        public static bool HasRecurringSubscriptions(BasketItem item)
        {
            return item.IsSubscription && item.Product.SubscriptionPlan.IsRecurring;
        }
    }
}