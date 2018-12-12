namespace AbleCommerce.Code
{
    using System;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using System.Collections.Generic;
    using System.Linq;

    public class InvoiceHelper
    {

        public static IList<OrderItem> RemoveDiscountItems(IList<OrderItem> shipments)
        {
            List<OrderItem> newShipments = (List<OrderItem>)shipments;
            newShipments = newShipments.FindAll(x => x.OrderItemType != OrderItemType.Discount);
            return newShipments;
        }

        public static IList<BasketItem> RemoveDiscountItems(IList<BasketItem> basketItems)
        {
            List<BasketItem> newBasketItems = (List<BasketItem>)basketItems;
            newBasketItems = newBasketItems.FindAll(x => x.OrderItemType != OrderItemType.Discount);
            return newBasketItems;
        }

        public static decimal GetShopPrice(BasketItem item)
        {
            if (item.OrderItemType == OrderItemType.Discount) {
                return 0;
            }

            if (item.Product == null || !item.Product.VolumeDiscounts.Any() || !item.Product.VolumeDiscounts[0].Levels.Any()) {
                return Math.Abs(item.Price);
            }

            VolumeDiscount volumeDiscount = item.Product.VolumeDiscounts[0];
            VolumeDiscountLevel lastLevel = volumeDiscount.Levels.Last();
            decimal discountAmount = 0;
            foreach (var rec in volumeDiscount.Levels)
            {
                if (item.Quantity >= rec.MinValue && item.Quantity <= rec.MaxValue) {
                    discountAmount = rec.DiscountAmount;
                    break;
                }
            }

            if (item.Quantity >= lastLevel.MinValue) {
                discountAmount = lastLevel.DiscountAmount;
            }

            return discountAmount;
        }

        public static decimal GetShopPrice(OrderItem item)
        {
            if (item.OrderItemType == OrderItemType.Discount)
            {
                return 0;
            }

            if (item.Product == null || !item.Product.VolumeDiscounts.Any() || !item.Product.VolumeDiscounts[0].Levels.Any())
            {
                return Math.Abs(item.Price);
            }

            VolumeDiscount volumeDiscount = item.Product.VolumeDiscounts[0];
            VolumeDiscountLevel lastLevel = volumeDiscount.Levels.Last();
            decimal discountAmount = 0;
            foreach (var rec in volumeDiscount.Levels)
            {
                if (item.Quantity >= rec.MinValue && item.Quantity <= rec.MaxValue)
                {
                    discountAmount = rec.DiscountAmount;
                    break;
                }
            }

            if (item.Quantity >= lastLevel.MinValue)
            {
                discountAmount = lastLevel.DiscountAmount;
            }

            return discountAmount;
        }

        public static decimal GetInvoiceExtendedPrice(BasketItem item)
        {
            if (item.OrderItemType == OrderItemType.Discount) {
                return 0;
            }
            if (item.Product == null || !item.Product.VolumeDiscounts.Any() || !item.Product.VolumeDiscounts[0].Levels.Any()) {
                return Math.Abs(item.Price * item.Quantity);
            }

            VolumeDiscount volumeDiscount = item.Product.VolumeDiscounts[0];
            if (volumeDiscount.Levels.Count < 1){
                return item.Price * item.Quantity;
            }


            decimal lastMinValue = volumeDiscount.Levels.Last().MinValue;
            decimal discountAmount = 0;
            foreach (var rec in volumeDiscount.Levels) {
                if (item.Quantity >= rec.MinValue && item.Quantity <= rec.MaxValue) {
                    discountAmount = rec.DiscountAmount;
                    break;
                } else if (item.Quantity >= lastMinValue) {
                    discountAmount = rec.DiscountAmount;
                    break;
                }
            }
            return (discountAmount * item.Quantity);
        }

        public static decimal GetInvoiceExtendedPrice(OrderItem item)
        {
            if (item.OrderItemType == OrderItemType.Discount)
            {
                return 0;
            }
            if (item.Product == null || !item.Product.VolumeDiscounts.Any() || !item.Product.VolumeDiscounts[0].Levels.Any())
            {
                return Math.Abs(item.Price * item.Quantity);
            }

            VolumeDiscount volumeDiscount = item.Product.VolumeDiscounts[0];
            if (volumeDiscount.Levels.Count < 1)
            {
                return item.Price * item.Quantity;
            }


            decimal lastMinValue = volumeDiscount.Levels.Last().MinValue;
            decimal discountAmount = 0;
            foreach (var rec in volumeDiscount.Levels)
            {
                if (item.Quantity >= rec.MinValue && item.Quantity <= rec.MaxValue)
                {
                    discountAmount = rec.DiscountAmount;
                    break;
                }
                else if (item.Quantity >= lastMinValue)
                {
                    discountAmount = rec.DiscountAmount;
                    break;
                }
            }
            return (discountAmount * item.Quantity);
        }

        public static decimal GetGSTPrice (OrderItem item)
        {
            decimal amount = GetInvoiceExtendedPrice(item);
            return (amount * (decimal)1.1) - amount;
        }

        public static decimal GetGSTPrice(BasketItem item)
        {
            decimal amount = GetInvoiceExtendedPrice(item);
            return (amount * (decimal)1.1) - amount;
        }
    }
}