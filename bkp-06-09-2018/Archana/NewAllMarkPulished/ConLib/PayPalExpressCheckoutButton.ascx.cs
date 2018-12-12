namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments.Providers.PayPal;
    using CommerceBuilder.Stores;

    [Description("Displays Paypal Exress Checkout Button")]
    public partial class PayPalExpressCheckoutButton : System.Web.UI.UserControl
    {
        private bool _ShowHeader = true;
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates whether header will be shown or not.")]
        public bool ShowHeader
        {
            get { return this._ShowHeader; }
            set { this._ShowHeader = value; }
        }

        private bool _ShowDescription = true;
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates whether description will be shown or not.")]
        public bool ShowDescription
        {
            get { return this._ShowDescription; }
            set { this._ShowDescription = value; }
        }

        private bool BasketHasProducts()
        {
            Basket basket = AbleContext.Current.User.Basket;
            foreach (BasketItem item in basket.Items)
            {
                if (item.OrderItemType == OrderItemType.Product) return true;
            }
            return false;
        }

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            // EXPRESS CHECKOUT BUTTON IS NOT VISIBLE BY DEFAULT
            // DETERMINE WHETHER THE PAYPAL GATEWAY IS DEFINED, AND WHETHER IT HAS API SERVICES ENABLED
            // BUTTON ONLY SHOWS IF PRODUCTS ARE IN THE BASKET AND MIN/MAX ORER LIMITS ARE MET
            if (BasketHasProducts())
            {
                bool hasSubscriptions = BasketHelper.HasRecurringSubscriptions(AbleContext.Current.User.Basket);
                bool newSubFeatureEnabled = AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled;
                if (!hasSubscriptions || !newSubFeatureEnabled)
                {
                    Basket basket = AbleContext.Current.User.Basket;
                    foreach (BasketItem item in basket.Items)
                    {
                        if (item.OrderItemType == OrderItemType.Product)
                        {
                            if (item.Product.IsProhibited)
                            {
                                this.Visible = false;
                                return;
                            }
                        }
                    }

                    // FIND THE PAYPAL GATEWAY
                    PayPalProvider provider = AbleCommerce.Code.StoreDataHelper.GetPayPalProvider();
                    if (provider != null && provider.ApiEnabled && ValidateOrderMinMaxAmounts())
                    {
                        //SHOW PANEL IF API ENABLED
                        ExpressCheckoutPanel.Visible = !AbleContext.Current.Store.Settings.ProductPurchasingDisabled;
                        if (ShowHeader) phHeader.Visible = true;
                        else phHeader.Visible = false;
                        if (ShowDescription) phDescription.Visible = true;
                        else phDescription.Visible = false;

                        phBillMeLaterBtn.Visible = provider.IsPayPalCreditEnabled;
                    }
                }
            }
        }

        protected bool ValidateOrderMinMaxAmounts()
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
                return false;
            }
            else
            {
                return true;
            }
        }

        protected void ExpressCheckoutLink_Click(object sender, EventArgs e)
        {
            ProcessExpressCheckoutClick("SET");
        }

        protected void BMLCheckoutLink_Click(object sender, EventArgs e)
        {
            ProcessExpressCheckoutClick("SETBML");
        }

        private void ProcessExpressCheckoutClick(string action)
        {
            GridView basketGrid = AbleCommerce.Code.PageHelper.RecursiveFindControl(this.Page, "BasketGrid") as GridView;
            if (basketGrid != null)
            {
                AbleCommerce.Code.BasketHelper.SaveBasket(basketGrid);
            }
            if (ValidateOrderMinMaxAmounts())
            {
                Response.Redirect("~/PayPalExpressCheckout.aspx?Action=" + action);
            }
            else
            {
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
            }
        }
    }
}