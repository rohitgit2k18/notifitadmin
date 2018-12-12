namespace AbleCommerce.Mobile.UserControls.Utility
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;

    public partial class BasketItemDetail : System.Web.UI.UserControl
    {
        public int BasketItemId { get; set; }

        public bool _LinkProducts = false;
        public bool LinkProducts
        {
            get { return _LinkProducts; }
            set { _LinkProducts = value; }
        }

        private bool _ShowShipTo = false;
        public bool ShowShipTo
        {
            get { return _ShowShipTo; }
            set { _ShowShipTo = value; }
        }

        private bool _ShowAssets;
        public bool ShowAssets
        {
            get { return _ShowAssets; }
            set { _ShowAssets = value; }
        }

        private bool _ShowSubscription = true;
        public bool ShowSubscription
        {
            get { return _ShowSubscription; }
            set { _ShowSubscription = value; }
        }

        private bool _ForceKitDisplay = false;
        public bool ForceKitDisplay
        {
            get { return _ForceKitDisplay; }
            set { _ForceKitDisplay = value; }
        }

        private bool _IgnoreKitShipment = true;
        public bool IgnoreKitShipment
        {
            get { return _IgnoreKitShipment; }
            set { _IgnoreKitShipment = value; }
        }

        public bool _EnableFriendlyFormat = false;
        public bool EnableFriendlyFormat
        {
            get { return _EnableFriendlyFormat; }
            set { _EnableFriendlyFormat = value; }
        }

        private IList<BasketItemInput> GetCustomerInputs(BasketItem basketItem)
        {
            IList<BasketItemInput> inputs = new List<BasketItemInput>();
            foreach (BasketItemInput input in basketItem.Inputs)
            {
                if ((input.InputField != null) && (!input.InputField.IsMerchantField))
                    inputs.Add(input);
            }
            return inputs;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            BasketItem basketItem = BasketItemDataSource.Load(this.BasketItemId);
            if (basketItem != null)
            {
                Product product = basketItem.Product;
                if (product != null)
                {
                    //OUTPUT THE PRODUCT NAME
                    string productName = basketItem.Name;
                    if (basketItem.ProductVariant != null)
                    {
                        string variantName = string.Format(" ({0})", basketItem.ProductVariant.VariantName);
                        if (!productName.EndsWith(variantName)) productName += variantName;
                    }
                    if (this.LinkProducts && product.Visibility != CatalogVisibility.Private)
                    {
                        //OUTPUT NAME AS LINK
                        string url = UrlGenerator.GetBrowseUrl(product.Id, CatalogNodeType.Product, product.Name);
                        if (!string.IsNullOrEmpty(basketItem.KitList) && !string.IsNullOrEmpty(basketItem.OptionList))
                        {
                            string link = string.Format("<a href=\"{0}?ItemId={1}&Kits={2}&Options={3}\">{4}</a>", Page.ResolveUrl(url), basketItem.Id, basketItem.KitList, basketItem.OptionList.Replace(",0", string.Empty), productName);
                            phProductName.Controls.Add(new LiteralControl(link));
                        }
                        else if (!string.IsNullOrEmpty(basketItem.KitList) && string.IsNullOrEmpty(basketItem.OptionList))
                        {
                            string link = string.Format("<a href=\"{0}?ItemId={1}&Kits={2}\">{3}</a>", Page.ResolveUrl(url), basketItem.Id, basketItem.KitList, productName);
                            phProductName.Controls.Add(new LiteralControl(link));
                        }
                        else if (string.IsNullOrEmpty(basketItem.KitList) && !string.IsNullOrEmpty(basketItem.OptionList))
                        {
                            string link = string.Format("<a href=\"{0}?ItemId={1}&Options={2}\">{3}</a>", Page.ResolveUrl(url), basketItem.Id, basketItem.OptionList.Replace(",0", string.Empty), productName);
                            phProductName.Controls.Add(new LiteralControl(link));
                        }
                        else
                        {
                            string link = string.Format("<a href=\"{0}?ItemId={1}\">{2}</a>", Page.ResolveUrl(url), basketItem.Id, productName);
                            phProductName.Controls.Add(new LiteralControl(link));
                        }
                    }
                    else
                    {
                        //OUTPUT NAME
                        phProductName.Controls.Add(new LiteralControl(productName));
                    }

                    if (EnableFriendlyFormat)
                    {
                        phProductName.Controls.AddAt(0, new LiteralControl(string.Format("{0} of ", basketItem.Quantity)));
                        phProductName.Controls.Add(new LiteralControl(string.Format("<span class='price'>({0})</span>", basketItem.Price.LSCurrencyFormat("ulc"))));
                    }

                    //SHOW INPUTS
                    IList<BasketItemInput> inputs = GetCustomerInputs(basketItem);
                    if (inputs.Count > 0)
                    {
                        InputList.DataSource = inputs;
                        InputList.DataBind();
                    }
                    else
                    {
                        InputList.Visible = false;
                    }
                    //SHOW KIT PRODUCTS IF AVAILABLE, AND THE PRODUCT DOES NOT USE ITEMIZED DISPLAY OR FORCE KIT DISPLAY IS ON
                    if (!string.IsNullOrEmpty(basketItem.KitList) && basketItem.Product != null
                        && basketItem.Product.Kit != null && (!basketItem.Product.Kit.ItemizeDisplay || this.ForceKitDisplay))
                    {
                        IList<BasketItem> kitProductList = GetKitProducts(basketItem, this.IgnoreKitShipment);
                        if (kitProductList.Count > 0)
                        {
                            KitProductPanel.Visible = true;
                            KitProductRepeater.DataSource = kitProductList;
                            KitProductRepeater.DataBind();
                        }
                    }
                    //SET THE KIT MEMBER LABEL
                    if (basketItem.OrderItemType == OrderItemType.Product && basketItem.IsChildItem)
                    {
                        BasketItem parentItem = basketItem.GetParentItem(true);
                        if (parentItem != null)
                        {
                            if ((parentItem.Product != null && basketItem.Product.Kit != null && parentItem.Product.Kit.ItemizeDisplay)
                                || basketItem.ShipmentId != parentItem.ShipmentId)
                            {
                                //SET THE WISHLIST NAME
                                KitMemberLabel.Visible = true;
                                KitMemberLabel.Text = string.Format(KitMemberLabel.Text, parentItem.Name);
                            }
                        }
                    }
                    //SET THE WISHLIST LABEL
                    WishlistLabel.Visible = (basketItem.WishlistItem != null);
                    if (WishlistLabel.Visible)
                    {
                        //SET THE WISHLIST NAME
                        WishlistLabel.Text = string.Format(WishlistLabel.Text, GetWishlistName(basketItem.WishlistItem.Wishlist));
                    }
                    //SET THE SHIPS TO PANEL
                    Basket basket = basketItem.Basket;
                    BasketShipment shipment = basketItem.Shipment;
                    Address address = (shipment == null) ? null : shipment.Address;
                    ShipsToPanel.Visible = (this.ShowShipTo && (address != null) && (!string.IsNullOrEmpty(address.FullName)));
                    if (ShipsToPanel.Visible)
                    {
                        ShipsTo.Text = address.FullName;
                    }
                    //SHOW GIFT WRAP
                    GiftWrapPanel.Visible = (basketItem.WrapStyle != null);
                    if (GiftWrapPanel.Visible)
                    {
                        GiftWrap.Text = basketItem.WrapStyle.Name;
                        GiftWrapPrice.Visible = (basketItem.WrapStyle.Price != 0);
                        GiftWrapPrice.Text = string.Format("&nbsp;({0})", basketItem.WrapStyle.Price.LSCurrencyFormat("ulc"));
                    }
                    //SHOW GIFT MESSAGE
                    GiftMessagePanel.Visible = (!string.IsNullOrEmpty(basketItem.GiftMessage));
                    if (GiftMessagePanel.Visible)
                    {
                        GiftMessage.Text = basketItem.GiftMessage;
                    }
                    //SHOW ASSETS
                    List<AbleCommerce.Code.ProductAssetWrapper> assets = AbleCommerce.Code.ProductHelper.GetAssets(this.Page, basketItem.Product, basketItem.OptionList, basketItem.KitList, "javascript:window.close()");
                    AssetsPanel.Visible = (this.ShowAssets && assets.Count > 0);
                    if (AssetsPanel.Visible)
                    {
                        AssetLinkList.DataSource = assets;
                        AssetLinkList.DataBind();
                    }
                    //SHOW SUBSCRIPTIONS
                    if (this.ShowSubscription)
                    {
                        SubscriptionPlan sp = basketItem.Product.SubscriptionPlan;
                        if (sp != null && basketItem.IsSubscription && basketItem.Frequency > 0)
                        {
                            // GET THE RECURRING PAYMENT MESSAGE FOR THIS PRODUCT
                            RecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(basketItem);
                            SubscriptionPanel.Visible = true;
                        }
                    }
                }
                else
                {
                    //OUTPUT NAME
                    phProductName.Controls.Add(new LiteralControl(basketItem.Name));
                    InputList.Visible = false;
                    KitProductPanel.Visible = false;
                    WishlistLabel.Visible = false;
                    ShipsToPanel.Visible = false;
                    GiftWrapPanel.Visible = false;
                    GiftMessagePanel.Visible = false;
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

        private static IList<BasketItem> GetKitProducts(BasketItem basketItem, bool ignoreKitShipments)
        {
            IList<BasketItem> basketItemKitProducts = new List<BasketItem>();
            foreach (BasketItem item in basketItem.Basket.Items)
            {
                if (item.Id != basketItem.Id
                    && item.ParentItemId == basketItem.Id
                    && item.OrderItemType == OrderItemType.Product
                    && (item.ShipmentId == basketItem.ShipmentId
                    || ignoreKitShipments))
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