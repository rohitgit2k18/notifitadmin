namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;

    [Description("Displays details of a basket item in mini-basket display")]
    public partial class MiniBasketItemDetail : System.Web.UI.UserControl
    {
        BasketItem _BasketItem;
        public int BasketItemId { get; set; }
        
        public bool _LinkProducts = false;
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true displayed products will be hyperlinked to their pages")]
        public bool LinkProducts
        {
            get { return _LinkProducts; }
            set { _LinkProducts = value; }
        }

        private bool _ShowShipTo = false;
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true ship-to information is displayed")]
        public bool ShowShipTo
        {
            get { return _ShowShipTo; }
            set { _ShowShipTo = value; }
        }

        private bool _ShowAssets;
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true product assets are displayed")]
        public bool ShowAssets
        {
            get { return _ShowAssets; }
            set { _ShowAssets = value; }
        }

        private bool _ShowSubscription;
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true subscription details are displayed")]
        public bool ShowSubscription
        {
            get { return _ShowSubscription; }
            set { _ShowSubscription = value; }
        }

        private IList<BasketItemInput> GetCustomerInputs()
        {
            IList<BasketItemInput> inputs = new List<BasketItemInput>();
            foreach (BasketItemInput input in _BasketItem.Inputs)
            {
                if ((input.InputField != null) && (!input.InputField.IsMerchantField))
                    inputs.Add(input);
            }
            return inputs;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            _BasketItem = BasketItemDataSource.Load(BasketItemId);
            if (_BasketItem != null)
            {
                Product product = _BasketItem.Product;
                if (product != null)
                {
                    //OUTPUT THE PRODUCT NAME
                    string productName = product.Name;
                    if (_BasketItem.ProductVariant != null)
                    {
                        productName += string.Format(" ({0})", _BasketItem.ProductVariant.VariantName);
                    }
                    if (this.LinkProducts)
                    {
                        //OUTPUT NAME AS LINK
                        string url = UrlGenerator.GetBrowseUrl(product.Id, CatalogNodeType.Product, product.Name);
                        if (!string.IsNullOrEmpty(_BasketItem.KitList) && !string.IsNullOrEmpty(_BasketItem.OptionList))
                        {
                            string link = string.Format("<a href=\"{0}?ItemId={1}&Kits={2}&Options={3} \">{4}</a>", Page.ResolveUrl(url), _BasketItem.Id, _BasketItem.KitList, _BasketItem.OptionList.Replace(",0", string.Empty), productName);
                            phProductName.Controls.Add(new LiteralControl(link));
                        }
                        else if (!string.IsNullOrEmpty(_BasketItem.KitList) && string.IsNullOrEmpty(_BasketItem.OptionList))
                        {
                            string link = string.Format("<a href=\"{0}?ItemId={1}&Kits={2}\">{3}</a>", Page.ResolveUrl(url), _BasketItem.Id, _BasketItem.KitList, productName);
                            phProductName.Controls.Add(new LiteralControl(link));
                        }
                        else if (string.IsNullOrEmpty(_BasketItem.KitList) && !string.IsNullOrEmpty(_BasketItem.OptionList))
                        {
                            string link = string.Format("<a href=\"{0}?ItemId={1}&Options={2}\">{3}</a>", Page.ResolveUrl(url), _BasketItem.Id, _BasketItem.OptionList.Replace(",0", string.Empty), productName);
                            phProductName.Controls.Add(new LiteralControl(link));
                        }
                        else
                        {
                            string link = string.Format("<a href=\"{0}?ItemId={1}\">{2}</a>", Page.ResolveUrl(url), _BasketItem.Id, productName);
                            phProductName.Controls.Add(new LiteralControl(link));
                        }
                    }
                    else
                    {
                        //OUTPUT NAME
                        phProductName.Controls.Add(new LiteralControl(productName));
                    }
                    //SHOW INPUTS
                    IList<BasketItemInput> inputs = GetCustomerInputs();
                    if (inputs.Count > 0)
                    {
                        InputList.DataSource = inputs;
                        InputList.DataBind();
                    }
                    else
                    {
                        InputList.Visible = false;
                    }
                    //SHOW KIT PRODUCTS
                    IList<BasketItem> kitProductList = GetKitProducts(_BasketItem);
                    KitProductPanel.Visible = (kitProductList.Count > 0 && _BasketItem.Product.Kit != null && !_BasketItem.Product.Kit.ItemizeDisplay);
                    if (KitProductPanel.Visible)
                    {
                        KitProductRepeater.DataSource = kitProductList;
                        KitProductRepeater.DataBind();
                    }
                    //SET THE WISHLIST LABEL
                    WishlistLabel.Visible = (_BasketItem.WishlistItem != null);
                    if (WishlistLabel.Visible)
                    {
                        //SET THE WISHLIST NAME
                        WishlistLabel.Text = string.Format(WishlistLabel.Text, GetWishlistName(_BasketItem.WishlistItem.Wishlist));
                    }
                    //SET THE SHIPS TO PANEL
                    Basket basket = _BasketItem.Basket;

                    //SHOW ASSETS
                    List<AbleCommerce.Code.ProductAssetWrapper> assets = AbleCommerce.Code.ProductHelper.GetAssets(this.Page, _BasketItem.Product, _BasketItem.OptionList, _BasketItem.KitList, "javascript:window.close()");
                    AssetsPanel.Visible = (this.ShowAssets && assets.Count > 0);
                    if (AssetsPanel.Visible)
                    {
                        AssetLinkList.DataSource = assets;
                        AssetLinkList.DataBind();
                    }
                    //SHOW SUBSCRIPTIONS
                    SubscriptionPlan sp = _BasketItem.Product.SubscriptionPlan;
                    SubscriptionPanel.Visible = (this.ShowSubscription && _BasketItem.IsSubscription);
                    if (SubscriptionPanel.Visible)
                    {
                        InitialPayment.Visible = (sp.RecurringChargeSpecified);
                        if (InitialPayment.Visible) InitialPayment.Text = string.Format(InitialPayment.Text, _BasketItem.Price.LSCurrencyFormat("ulc"));
                        string period;
                        if (_BasketItem.Frequency > 1) period = _BasketItem.Frequency + " " + _BasketItem.FrequencyUnit.ToString().ToLowerInvariant() + "s";
                        else period = _BasketItem.FrequencyUnit.ToString().ToLowerInvariant();
                        int numPayments = (sp.RecurringChargeSpecified ? sp.NumberOfPayments - 1 : sp.NumberOfPayments);
                        if (sp.NumberOfPayments == 0)
                        {
                            RecurringPayment.Text = string.Format("Recurring Payment: {0}, every {1} until canceled", sp.CalculateRecurringCharge(_BasketItem.Price).LSCurrencyFormat("ulc"), period);
                        }
                        else
                        {
                            RecurringPayment.Text = string.Format(RecurringPayment.Text, numPayments, sp.CalculateRecurringCharge(_BasketItem.Price).LSCurrencyFormat("ulc"), period);
                        }
                    }
                }
                else
                {
                    //OUTPUT NAME
                    phProductName.Controls.Add(new LiteralControl(_BasketItem.Name));
                    InputList.Visible = false;
                    KitProductPanel.Visible = false;
                    WishlistLabel.Visible = false;
                    AssetsPanel.Visible = false;
                    SubscriptionPanel.Visible = false;
                }
            }
            else
            {
                //NO ITEM TO DISPLAY
                this.Controls.Clear();
            }

        }

        private static IList<BasketItem> GetKitProducts(BasketItem basketItem)
        {
            IList<BasketItem> basketItemKitProducts = new List<BasketItem>();
            foreach (BasketItem item in basketItem.Basket.Items)
            {
                if (item.Id != basketItem.Id
                    && item.ParentItemId == basketItem.Id
                    && item.OrderItemType == OrderItemType.Product)
                {
                    basketItemKitProducts.Add(item);
                }
            }
            basketItemKitProducts.Sort(new BasketItemComparer());
            return basketItemKitProducts;
        }

        private string GetWishlistName(Wishlist wishlist)
        {
            if (!String.IsNullOrEmpty(wishlist.Name)) return wishlist.Name;
            else
            {
                User u = wishlist.User;
                if (u == null) return string.Empty;
                if (u.IsAnonymous) return "Anonymous";
                string fullName = u.PrimaryAddress.FullName;
                if (!string.IsNullOrEmpty(fullName)) return fullName;
                return u.UserName;
            }
        }
    }
}