namespace AbleCommerce.Mobile
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Web.UI;
    using System.Collections.Specialized;

    public partial class BasketPage : CommerceBuilder.UI.AbleCommercePage
    {
        private OrderItemType[] displayItemTypes = { OrderItemType.Product, OrderItemType.Discount, OrderItemType.Coupon, OrderItemType.GiftWrap };
        IList<BasketItem> _DisplayedBasketItems;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private void BindBasketGrid()
        {
            //BIND THE GRID
            IList<BasketItem> items = GetBasketItems();
            BasketGrid.DataSource = items;
            BasketGrid.DataBind();
            bool showShippingEstimate = items.Count > 0;
        }

        private IList<BasketItem> GetBasketItems()
        {
            User user = AbleContext.Current.User;
            Basket basket = user.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Combine(basket);
            _DisplayedBasketItems = new List<BasketItem>();
            foreach (BasketItem item in basket.Items)
            {
                if (Array.IndexOf(displayItemTypes, item.OrderItemType) > -1)
                {
                    if (item.OrderItemType == OrderItemType.Product && item.IsChildItem)
                    {
                        // WHETHER THE CHILD ITEM DISPLAYS DEPENDS ON THE ROOT
                        BasketItem rootItem = item.GetParentItem(true);
                        if (rootItem != null && rootItem.Product != null && rootItem.Product.Kit != null && rootItem.Product.Kit.ItemizeDisplay)
                        {
                            // ITEMIZED DISPLAY ENABLED, SHOW THIS CHILD ITEM
                            _DisplayedBasketItems.Add(item);
                        }
                    }
                    else
                    {
                        // NO ADDITIONAL CHECK REQUIRED TO INCLUDE ROOT PRODUCTS OR NON-PRODUCTS
                        _DisplayedBasketItems.Add(item);
                    }
                }
            }
            // ADD IN ANY CHILD ITEMS

            //ADD IN TAX ITEMS IF SPECIFIED FOR DISPLAY
            if (TaxHelper.GetEffectiveShoppingDisplay(user) == TaxShoppingDisplay.LineItem)
            {
                foreach (BasketItem item in basket.Items)
                {
                    //IS THIS A TAX ITEM?
                    if (item.OrderItemType == OrderItemType.Tax)
                    {
                        ////IS THE TAX ITEM A PARENT ITEM OR A CHILD OF A DISPLAYED ITEM?
                        //if (!item.IsChildItem || (_DisplayedBasketItems.IndexOf(item.ParentItemId) > -1))
                        //{
                        //TAX SHOULD BE SHOWN
                        _DisplayedBasketItems.Add(item);
                        //}
                    }
                }
            }

            // COMBINE ORDER COUPON ITEMS
            _DisplayedBasketItems = _DisplayedBasketItems.CombineOrderCoupons();

            //SORT ITEMS TO COMPLETE INTITIALIZATION
            _DisplayedBasketItems.Sort(new BasketItemComparer());
            return _DisplayedBasketItems;
        }

        protected void BasketGrid_DataBound(object sender, EventArgs e)
        {
            if (BasketGrid.Rows.Count > 0)
            {
                CheckoutButton.Visible = !AbleContext.Current.Store.Settings.ProductPurchasingDisabled;
                ClearBasketButton.Visible = true;
                UpdateButton.Visible = true;
                EmptyBasketPanel.Visible = false;
                ValidateOrderMinMaxAmounts();
            }
            else
            {
                CheckoutButton.Visible = false;
                ClearBasketButton.Visible = false;
                UpdateButton.Visible = false;
                OrderAboveMaximumAmountMessage.Visible = false;
                OrderBelowMinimumAmountMessage.Visible = false;
                EmptyBasketPanel.Visible = true;
            }
        }

        private void ValidateOrderMinMaxAmounts()
        {
            // IF THE ORDER AMOUNT DOES NOT FALL IN VALID RANGE SPECIFIED BY THE MERCHENT
            OrderItemType[] args = new OrderItemType[] { OrderItemType.Charge, 
                                                    OrderItemType.Coupon, OrderItemType.Credit, OrderItemType.Discount, 
                                                    OrderItemType.GiftCertificate, OrderItemType.GiftWrap, OrderItemType.Handling, 
                                                    OrderItemType.Product, OrderItemType.Shipping, OrderItemType.Tax };
            decimal orderTotal = AbleContext.Current.User.Basket.Items.TotalPrice(args);
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            decimal minOrderAmount = settings.OrderMinimumAmount;
            decimal maxOrderAmount = settings.OrderMaximumAmount;

            if ((minOrderAmount > orderTotal) || (maxOrderAmount > 0 && maxOrderAmount < orderTotal))
            {
                CheckoutButton.Enabled = false;
                OrderBelowMinimumAmountMessage.Visible = (minOrderAmount > orderTotal);
                if (OrderBelowMinimumAmountMessage.Visible) OrderBelowMinimumAmountMessage.Text = string.Format(OrderBelowMinimumAmountMessage.Text, minOrderAmount.LSCurrencyFormat("ulc"));
                OrderAboveMaximumAmountMessage.Visible = !OrderBelowMinimumAmountMessage.Visible;
                if (OrderAboveMaximumAmountMessage.Visible) OrderAboveMaximumAmountMessage.Text = string.Format(OrderAboveMaximumAmountMessage.Text, maxOrderAmount.LSCurrencyFormat("ulc"));
            }
            else
            {
                CheckoutButton.Enabled = true;
                OrderAboveMaximumAmountMessage.Visible = false;
                OrderBelowMinimumAmountMessage.Visible = false;
            }
        }

        protected void BasketGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            Basket basket;
            int index;
            switch (e.CommandName)
            {   
                case "DeleteItem":
                    basket = AbleContext.Current.User.Basket;
                    index = basket.Items.IndexOf(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
                    if ((index > -1))
                    {
                        basket.Items.DeleteAt(index);
                    }
                    break;
                case "DeleteCouponItem":
                    basket = AbleContext.Current.User.Basket;
                    index = basket.Items.IndexOf(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
                    if ((index > -1))
                    {
                        BasketItem bitem = basket.Items[index];
                        if (bitem.OrderItemType == OrderItemType.Coupon)
                        {
                            basket.Items.DeleteAt(index);
                            foreach (BasketCoupon cpn in basket.BasketCoupons)
                            {
                                if (cpn.Coupon.CouponCode == bitem.Sku)
                                {
                                    basket.BasketCoupons.Remove(cpn);
                                    cpn.Delete();
                                    basket.BasketCoupons.Save();
                                    break;
                                }
                            }
                        }
                    }
                    break;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            //GET ANY MESSAGES FROM SESSION
            IList<string> sessionMessages = Session["BasketMessage"] as IList<string>;
            //GET THE BASKET AND RECALCULATE
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);
            //VALIDATE THE BASKET
            ValidationResponse response = preCheckoutService.Validate(basket);
            //DISPLAY ANY WARNING MESSAGES
            if ((!response.Success) || (sessionMessages != null))
            {
                if (sessionMessages != null)
                {
                    Session.Remove("BasketMessage");
                    sessionMessages.AddRange(response.WarningMessages);
                    WarningMessageList.DataSource = sessionMessages;
                }
                else
                {
                    WarningMessageList.DataSource = response.WarningMessages;
                }
                WarningMessageList.DataBind();
            }
            BindBasketGrid();
        }

        protected void ClearBasketButton_Click(object sender, EventArgs e)
        {
            IBasketService basketService = AbleContext.Resolve<IBasketService>();
            basketService.Clear(AbleContext.Current.User.Basket);
            BindBasketGrid();
        }

        protected void KeepShoppingButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl());
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            AbleCommerce.Code.BasketHelper.SaveBasket(BasketGrid);
            BindBasketGrid();
        }

        protected void CheckoutButton_Click(object sender, EventArgs e)
        {
            AbleCommerce.Code.BasketHelper.SaveBasket(BasketGrid);
            IBasketService service = AbleContext.Resolve<IBasketService>();
            ValidationResponse response = service.Validate(AbleContext.Current.User.Basket);
            if (response.Success) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetCheckoutUrl());
            else Session["BasketMessage"] = response.WarningMessages;
        }

        protected decimal GetBasketSubtotal()
        {
            decimal basketTotal = 0;
            foreach (BasketItem bi in _DisplayedBasketItems)
            {
                basketTotal += TaxHelper.GetShopExtendedPrice(AbleContext.Current.User.Basket, bi);
            }

            return basketTotal;
        }

        protected bool ShowProductImagePanel(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return ((item.OrderItemType == OrderItemType.Product));
        }

        protected bool IsProduct(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return item.OrderItemType == OrderItemType.Product;
        }

        protected string GetProductUrl(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            if (item.OrderItemType == OrderItemType.Product && item.Product != null)
            {
                NameValueCollection nvc = new NameValueCollection();
                nvc.Add("ItemId", item.Id.ToString());
                if (!string.IsNullOrEmpty(item.OptionList) && !string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Kits", item.KitList);
                    nvc.Add("Options", item.OptionList.Replace(",0", string.Empty));
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }
                else if (!string.IsNullOrEmpty(item.OptionList) && string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Options", item.OptionList.Replace(",0", string.Empty));
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }
                else if (string.IsNullOrEmpty(item.OptionList) && !string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Kits", item.KitList);
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }

                return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
            }
            else return string.Empty;
        }

        protected bool IsParentProduct(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return (item.OrderItemType == OrderItemType.Product && !item.IsChildItem);
        }
    }
}