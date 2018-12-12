namespace AbleCommerce.Mobile.UserControls.Account
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;
    using AbleCommerce.Code;

    public partial class OrderItemDetail : System.Web.UI.UserControl
    {
        OrderItem _OrderItem;
        public OrderItem OrderItem
        {
            get { return _OrderItem; }
            set { _OrderItem = value; }
        }

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

        public bool _EnableFriendlyFormat = false;
        public bool EnableFriendlyFormat
        {
            get { return _EnableFriendlyFormat; }
            set { _EnableFriendlyFormat = value; }
        }

        private bool _ShowSubscription = true;
        public bool ShowSubscription
        {
            get { return _ShowSubscription; }
            set { _ShowSubscription = value; }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (_OrderItem != null)
            {
                Product product = _OrderItem.Product;
                if (product != null)
                {
                    string productName = _OrderItem.Name;
                    if (!string.IsNullOrEmpty(_OrderItem.VariantName))
                    {
                        string variantName = string.Format(" ({0})", _OrderItem.VariantName);
                        if (!productName.Contains(variantName)) productName += variantName;
                    }
                    if (this.LinkProducts)
                    {
                        ProductLink.NavigateUrl = UrlGenerator.GetBrowseUrl(product.Id, CatalogNodeType.Product, productName);
                        if(EnableFriendlyFormat)
                            ProductLink.Text = string.Format("{0} of {1}(<span class='price'>{2}</span>)", _OrderItem.Quantity, productName, _OrderItem.Price.LSCurrencyFormat("ulc"));
                        else
                            ProductLink.Text = productName;
                        ProductName.Visible = false;
                    }
                    else
                    {
                        if (EnableFriendlyFormat)
                            ProductName.Text = string.Format("{0} of {1}(<span class='price'>{2}</span>)", _OrderItem.Quantity, productName, _OrderItem.Price.LSCurrencyFormat("ulc"));
                        else
                            ProductName.Text = productName;
                        ProductLink.Visible = false;
                    }
                    //SHOW INPUTS
                    if (_OrderItem.Inputs.Count > 0)
                    {
                        InputList.DataSource = _OrderItem.Inputs;
                        InputList.DataBind();
                    }
                    else
                    {
                        InputList.Visible = false;
                    }
                    //SHOW KIT PRODUCTS IF AVAILABLE, AND THE PRODUCT DOES NOT USE ITEMIZED DISPLAY
                    if (!string.IsNullOrEmpty(_OrderItem.KitList) && !_OrderItem.ItemizeChildProducts)
                    {
                        IList<OrderItem> kitProductList = GetKitProducts(_OrderItem);
                        if (kitProductList.Count > 0)
                        {
                            KitProductPanel.Visible = true;
                            KitProductRepeater.DataSource = kitProductList;
                            KitProductRepeater.DataBind();
                        }
                    }
                    //SET THE KIT MEMBER LABEL
                    if (_OrderItem.OrderItemType == OrderItemType.Product && _OrderItem.IsChildItem)
                    {
                        OrderItem parentItem = _OrderItem.GetParentItem(true);
                        if (parentItem.ItemizeChildProducts
                            || _OrderItem.Id != parentItem.Id)
                        {
                            //SET THE WISHLIST NAME
                            KitMemberLabel.Visible = true;
                            KitMemberLabel.Text = string.Format(KitMemberLabel.Text, parentItem.Name);
                        }
                    }
                    //SET THE WISHLIST LABEL
                    WishlistLabel.Visible = (_OrderItem.WishlistItem != null);
                    if (WishlistLabel.Visible)
                    {
                        //SET THE WISHLIST NAME
                        WishlistLabel.Text = string.Format(WishlistLabel.Text, GetWishlistName(_OrderItem.WishlistItem.Wishlist));
                    }
                    //SET THE SHIPS TO PANEL
                    Order basket = _OrderItem.Order;
                    OrderShipment shipment = _OrderItem.OrderShipment;
                    ShipsToPanel.Visible = this.ShowShipTo;
                    if (ShipsToPanel.Visible)
                    {
                        ShipsTo.Text = shipment.ShipToFullName;
                    }
                    //SHOW GIFT WRAP
                    GiftWrapPanel.Visible = (_OrderItem.WrapStyle != null);
                    if (GiftWrapPanel.Visible)
                    {
                        GiftWrap.Text = _OrderItem.WrapStyle.Name;
                        GiftWrapPrice.Visible = (_OrderItem.WrapStyle.Price != 0);
                        GiftWrapPrice.Text = string.Format("&nbsp;({0})", _OrderItem.WrapStyle.Price.LSCurrencyFormat("ulc"));
                    }
                    //SHOW GIFT MESSAGE
                    GiftMessagePanel.Visible = (!string.IsNullOrEmpty(_OrderItem.GiftMessage));
                    if (GiftMessagePanel.Visible)
                    {
                        GiftMessage.Text = _OrderItem.GiftMessage;
                    }
                    //SHOW ASSETS
                    List<AbleCommerce.Code.ProductAssetWrapper> assets = AbleCommerce.Code.ProductHelper.GetAssets(this.Page, _OrderItem.Product, _OrderItem.OptionList, _OrderItem.KitList, "~/Members/MyOrder.aspx?OrderNumber=" + _OrderItem.Order.OrderNumber.ToString());
                    AssetsPanel.Visible = (this.ShowAssets && assets.Count > 0);
                    if (AssetsPanel.Visible)
                    {
                        AssetLinkList.DataSource = assets;
                        AssetLinkList.DataBind();
                    }

                    //SHOW SUBSCRIPTIONS
                    if (this.ShowSubscription)
                    {
                        SubscriptionPlan sp = _OrderItem.Product.SubscriptionPlan;
                        if (sp != null && _OrderItem.IsSubscription && _OrderItem.Frequency > 0)
                        {
                            // GET THE RECURRING PAYMENT MESSAGE FOR THIS PRODUCT
                            RecurringPaymentMessage.Text = ProductHelper.GetRecurringPaymentMessage(_OrderItem);
                            SubscriptionPanel.Visible = true;
                        }
                    }
                }
                else
                {
                    ProductLink.Visible = false;
                    ProductName.Text = _OrderItem.Name;
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

        private static IList<OrderItem> GetKitProducts(OrderItem orderItem)
        {
            IList<OrderItem> orderItemKitProducts = new List<OrderItem>();
            foreach (OrderItem item in orderItem.Order.Items)
            {
                if (item.Id != orderItem.Id
                    && item.ParentItemId == orderItem.Id
                    && item.OrderItemType == OrderItemType.Product
                    && !item.IsHidden
                    && item.OrderShipmentId == orderItem.OrderShipmentId)
                {
                    orderItemKitProducts.Add(item);
                }
            }
            orderItemKitProducts.Sort(new OrderItemComparer());
            return orderItemKitProducts;
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