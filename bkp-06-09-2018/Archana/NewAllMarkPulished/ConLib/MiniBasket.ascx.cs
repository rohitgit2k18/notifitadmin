namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.UI;
    using CommerceBuilder.Utility;
    using System.Collections.Specialized;
    using System.ComponentModel;

    [Description("Displays contents of the basket in concise format that can be used to display basket in side bars.")]
    public partial class MiniBasket : System.Web.UI.UserControl, ISidebarControl
    {
        private string _AlternateControl = "PopularProductsDialog.ascx";
        private bool _ShowAlternateControl = false;

        [Browsable(true), DefaultValue(false)]
        [Description("If true an alternate control is displayed in place if the basket is empty")]
        public bool ShowAlternateControl
        {
            get { return _ShowAlternateControl; }
            set { _ShowAlternateControl = value; }
        }

        [Browsable(true), DefaultValue("PopularProductsDialog.ascx")]
        [Description("A control that will be displayed when the cart is empty")]
        public string AlternateControl
        {
            set { _AlternateControl = value; }
            get { return _AlternateControl; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.RegisterBasketControl(this.Page);
            if (!string.IsNullOrEmpty(_AlternateControl))
            {
                Control altControl = LoadControl(_AlternateControl);
                AlternateControlPanel.Controls.Add(altControl);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            CheckoutButton.Visible = !AbleContext.Current.Store.Settings.ProductPurchasingDisabled;
            PayPalExpressCheckoutButton.Visible = !AbleContext.Current.Store.Settings.ProductPurchasingDisabled;            
        }

        //BUILD THE BASKET ON PRERENDER SO THAT WE CAN ACCOUNT
        //FOR ANY PRODUCTS ADDED DURING THE POSTBACK CYCLE
        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            //PREPARE BASKET FOR DISPLAY
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService service = AbleContext.Resolve<IBasketService>();
            service.Combine(basket);
            service.Recalculate(basket);
            // VALIDATE THE BASKET
            ValidationResponse response = service.Validate(basket);
            //DISPLAY ANY WARNING MESSAGES
            if (!response.Success)
            {
                Session["BasketMessage"] = response.WarningMessages;
                //Redirect to basket page where these error messages will be displayed
                Response.Redirect("~/Basket.aspx");
            }

            BindBasket(basket);
        }

        private void BindBasket(Basket basket)
        {
            //GET LIST OF PRODUCTS
            IList<BasketItem> _Products = new List<BasketItem>();
            decimal _ProductTotal = 0;
            decimal _DiscountTotal = 0;
            bool showTaxLineItems = GetShowTaxLineItems();

            // MAKE SURE ITEMS ARE PROPERTY SORTED BEFORE DISPLAY
            basket.Items.Sort(new BasketItemComparer());
            foreach (BasketItem item in basket.Items)
            {
                if (item.OrderItemType == OrderItemType.Product)
                {
                    if (!item.IsChildItem)
                    {
                        // ROOT LEVEL ITEMS GET ADDED
                        _Products.Add(item);
                        _ProductTotal += TaxHelper.GetShopExtendedPrice(basket, item);
                    }
                    else
                    {
                        BasketItem rootItem = item.GetParentItem(true);
                        if (rootItem != null && rootItem.Product != null && rootItem.Product.Kit != null && rootItem.Product.Kit.ItemizeDisplay)
                        {
                            // ITEMIZED DISPLAY ENABLED, SHOW THIS CHILD ITEM
                            _Products.Add(item);
                            _ProductTotal += TaxHelper.GetShopExtendedPrice(basket, item);
                        }
                    }
                }
                else if (item.OrderItemType == OrderItemType.Discount)
                {
                    _DiscountTotal += TaxHelper.GetShopExtendedPrice(basket, item);
                }
                else if (item.OrderItemType == OrderItemType.Tax && showTaxLineItems && AbleContext.Current.User.IsAnonymous && !AbleContext.Current.User.PrimaryAddress.IsValid)
                {
                    _Products.Add(item);
                    item.Name = "<span class=\"label\">" + item.Name + " (estimated)</span>";
                }
                else if (item.OrderItemType == OrderItemType.Tax && showTaxLineItems)
                {
                    _Products.Add(item);
                }
            }
            if (_Products.Count > 0)
            {
                //BIND BASKET ITEMS 
                BasketRepeater.DataSource = _Products;
                BasketRepeater.DataBind();
                if (_DiscountTotal != 0)
                {
                    Discounts.Text = _DiscountTotal.LSCurrencyFormat("ulc");
                    DiscountsPanel.Visible = true;
                }
                else
                {
                    DiscountsPanel.Visible = false;
                }
                Discounts.Text = _DiscountTotal.LSCurrencyFormat("ulc");
                SubTotal.Text = (_ProductTotal + _DiscountTotal).LSCurrencyFormat("ulc");
                //UPDATE CHECKOUT LINK
                //CheckoutLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetCheckoutUrl();
                ShowBasket(true);
            }
            else
            {
                ShowBasket(false);
            }
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

        private bool GetShowTaxLineItems()
        {
            TaxShoppingDisplay displaySetting = TaxHelper.GetEffectiveShoppingDisplay(AbleContext.Current.User);
            return displaySetting == TaxShoppingDisplay.LineItem;
        }

        protected decimal GetItemShopPrice(BasketItem item)
        {
            return TaxHelper.GetShopPrice(item.Basket, item);
        }

        private void ShowBasket(bool basketVisible)
        {
            MiniBasketHolder.Visible = basketVisible;
            AlternateControlPanel.Visible = !basketVisible && ShowAlternateControl;
            if (!basketVisible) ContentPanel.CssClass += " nofooter";
        }

        protected string GetIconUrl(Object obj)
        {
            BasketItem bitem = obj as BasketItem;
            if (bitem != null && bitem.OrderItemType == OrderItemType.Product && bitem.Product != null)
            {
                if (bitem.ProductVariant != null && !string.IsNullOrEmpty(bitem.ProductVariant.IconUrl))
                {
                    return bitem.ProductVariant.IconUrl;
                }
                else if (!string.IsNullOrEmpty(bitem.Product.IconUrl))
                {
                    return bitem.Product.IconUrl;
                }
                else if (!string.IsNullOrEmpty(bitem.Product.ThumbnailUrl))
                {
                    return bitem.Product.ThumbnailUrl;
                }
                else
                {
                    return bitem.Product.ImageUrl;
                }
            }
            return string.Empty;
        }

        protected bool HasImage(Object obj)
        {
            BasketItem bitem = obj as BasketItem;
            if (bitem != null && bitem.OrderItemType == OrderItemType.Product && bitem.Product != null && !string.IsNullOrEmpty(bitem.Product.IconUrl))
            {
                if (bitem.ProductVariant != null && !string.IsNullOrEmpty(bitem.ProductVariant.IconUrl))
                {
                    return true;
                }
                else if (!string.IsNullOrEmpty(bitem.Product.IconUrl))
                {
                    return true;
                }
                else if (!string.IsNullOrEmpty(bitem.Product.ThumbnailUrl))
                {
                    return true;
                }
                else if (!string.IsNullOrEmpty(bitem.Product.ImageUrl))
                {
                    return true;
                }
            }
            return false;
        }

        protected void BasketRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Basket basket;
            int index;
            switch (e.CommandName)
            {
                case "UpdateItem":
                    basket = AbleContext.Current.User.Basket;
                    int basketItemId = AlwaysConvert.ToInt(e.CommandArgument.ToString());
                    UpdateBasketItem(BasketRepeater, basketItemId);
                    break;
                case "DeleteItem":
                    basket = AbleContext.Current.User.Basket;
                    index = basket.Items.IndexOf(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
                    if ((index > -1))
                    {
                        basket.Items.DeleteAt(index);
                    }
                    break;
            }
        }

        public static void UpdateBasketItem(Repeater BasketRepeater, int itemId)
        {
            if (itemId <= 0) return;
            Basket basket = AbleContext.Current.User.Basket;
            foreach (RepeaterItem saveItem in BasketRepeater.Items)
            {
                int basketItemId = 0;
                HiddenField basketItemIdField = (HiddenField)saveItem.FindControl("BasketItemId");
                if (basketItemIdField != null)
                {
                    basketItemId = AlwaysConvert.ToInt(basketItemIdField.Value);
                }

                if (basketItemId > 0 && basketItemId == itemId)
                {
                    int itemIndex = basket.Items.IndexOf(basketItemId);
                    if ((itemIndex > -1))
                    {
                        BasketItem item = basket.Items[itemIndex];
                        TextBox quantity = (TextBox)saveItem.FindControl("Quantity");
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
                            item.Save();
                        }
                    }
                }
            }
        }

        protected void CheckoutButton_Click(object sender, EventArgs e)
        {
            Basket basket = AbleContext.Current.User.Basket;
            foreach (RepeaterItem saveItem in BasketRepeater.Items)
            {
                int basketItemId = 0;
                HiddenField basketItemIdField = (HiddenField)saveItem.FindControl("BasketItemId");
                if (basketItemIdField != null)
                {
                    basketItemId = AlwaysConvert.ToInt(basketItemIdField.Value);
                }

                if (basketItemId > 0)
                {
                    int itemIndex = basket.Items.IndexOf(basketItemId);
                    if ((itemIndex > -1))
                    {
                        BasketItem item = basket.Items[itemIndex];
                        TextBox quantity = (TextBox)saveItem.FindControl("Quantity");
                        if (!item.IsChildItem && item.OrderItemType == OrderItemType.Product && quantity != null)
                        {
                            item.Quantity = AlwaysConvert.ToInt16(quantity.Text);
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
                            item.Save();
                        }
                    }
                }
            }

            // IF THE ORDER AMOUNT DOES NOT FALL IN VALID RANGE SPECIFIED BY THE MERCHENT
            OrderItemType[] args = new OrderItemType[] { OrderItemType.Charge, 
                                                    OrderItemType.Coupon, OrderItemType.Credit, OrderItemType.Discount, 
                                                    OrderItemType.GiftCertificate, OrderItemType.GiftWrap, OrderItemType.Handling, 
                                                    OrderItemType.Product, OrderItemType.Shipping, OrderItemType.Tax };
            decimal orderTotal = AbleContext.Current.User.Basket.Items.TotalPrice(args);
            var settings = AbleContext.Current.Store.Settings;
            decimal minOrderAmount = settings.OrderMinimumAmount;
            decimal maxOrderAmount = settings.OrderMaximumAmount;

            if ((minOrderAmount > orderTotal) || (maxOrderAmount > 0 && maxOrderAmount < orderTotal))
            {
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
            }

            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetCheckoutUrl());
        }

        protected bool IsParentProduct(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return (item.OrderItemType == OrderItemType.Product && !item.IsChildItem);
        }
    }
}