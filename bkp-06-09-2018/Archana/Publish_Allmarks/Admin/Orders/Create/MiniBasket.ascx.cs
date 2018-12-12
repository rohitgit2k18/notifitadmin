namespace AbleCommerce.Admin.Orders.Create
{
    using System.Collections;
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;

    public partial class MiniBasket : System.Web.UI.UserControl
    {
        private int _BasketId = 0;

        public int BasketId
        {
            get { return _BasketId; }
            set { _BasketId = value; }
        }

        //BUILD THE BASKET ON PRERENDER SO THAT WE CAN ACCOUNT
        //FOR ANY PRODUCTS ADDED DURING THE POSTBACK CYCLE
        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            //PREPARE BASKET FOR DISPLAY
            Basket basket = BasketDataSource.Load(_BasketId);
            if (basket != null) BindBasket(basket);
        }

        private void BindBasket(Basket basket)
        {
            //GET LIST OF PRODUCTS
            IList<BasketItem> _Products = new List<BasketItem>();
            decimal _ProductTotal = 0;
            decimal _DiscountTotal = 0;
            decimal _ShippingTotal = 0;
            decimal _TaxesTotal = 0;
            decimal _CouponsTotal = 0;
            decimal _OtherTotal = 0;
            decimal _GrandTotal = 0;

            // MAKE SURE ITEMS ARE PROPERTY SORTED BEFORE DISPLAY
            basket.Items.Sort(new BasketItemComparer());
            foreach (BasketItem item in basket.Items)
            {
                switch (item.OrderItemType)
                {
                    case OrderItemType.Product:
                        if (!item.IsChildItem)
                        {
                            // ROOT LEVEL ITEMS GET ADDED
                            _Products.Add(item);
                            _ProductTotal += GetItemShopPrice(item);
                        }
                        else
                        {
                            BasketItem rootItem = item.GetParentItem(true);
                            if (rootItem != null && rootItem.Product != null && rootItem.Product.Kit != null && rootItem.Product.Kit.ItemizeDisplay)
                            {
                                // ITEMIZED DISPLAY ENABLED, SHOW THIS CHILD ITEM
                                _Products.Add(item);
                                _ProductTotal += GetItemShopPrice(item);
                            }
                        }
                        break;
                    case OrderItemType.Discount:
                        _DiscountTotal += GetItemShopPrice(item);
                        break;
                    case OrderItemType.Shipping:
                    case OrderItemType.Handling:
                        _ShippingTotal += GetItemShopPrice(item);
                        break;
                    case OrderItemType.Tax:
                        _TaxesTotal += item.ExtendedPrice;
                        break;
                    case OrderItemType.Coupon:
                        _CouponsTotal += item.ExtendedPrice;
                        break;
                    default:
                        _OtherTotal += item.ExtendedPrice;
                        break;
                }
                _GrandTotal += item.ExtendedPrice;
            }

            //BIND BASKET ITEMS 
            BasketRepeater.DataSource = _Products;
            BasketRepeater.DataBind();
            if (_DiscountTotal != 0)
            {
                trDiscounts.Visible = true;
                Discounts.Text = _DiscountTotal.LSCurrencyFormat("ulc");
            }
            if (_ShippingTotal != 0)
            {
                trShipping.Visible = true;
                Shipping.Text = _ShippingTotal.LSCurrencyFormat("ulc");
            }
            if (_TaxesTotal != 0)
            {
                trTaxes.Visible = true;
                Taxes.Text = _TaxesTotal.LSCurrencyFormat("lc");
            }
            if (_CouponsTotal != 0)
            {
                trCoupons.Visible = true;
                Coupons.Text = _CouponsTotal.LSCurrencyFormat("lc");
            }
            if (_OtherTotal != 0)
            {
                trOther.Visible = true;
                Other.Text = _OtherTotal.LSCurrencyFormat("lc");
            }
            Total.Text = _GrandTotal.LSCurrencyFormat("lc");
            EditOrderLink.NavigateUrl += "?UID=" + basket.UserId;
        }

        protected decimal GetItemShopPrice(BasketItem item)
        {
            return TaxHelper.GetShopExtendedPrice(item.Basket, item);
        }
    }
}