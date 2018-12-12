namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.UI;
    using CommerceBuilder.Users;

    [Description("Displays the standard store header.")]
    public partial class StoreHeader : System.Web.UI.UserControl, IHeaderControl
    {
        public bool IsBootstrap { get; private set; }
        public bool ShowBannerDetails { get; private set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            var currentUrlPath = HttpContext.Current.Request.Url.AbsolutePath;
            ShowBannerDetails = !(currentUrlPath.Contains("product.aspx") || currentUrlPath.Contains("category.aspx"));
            CurrencyLink.Visible = AbleContext.Current.Store.Currencies.Count > 1;
            IsBootstrap = AbleCommerce.Code.PageHelper.IsResponsiveTheme(this.Page);
            BrandIcon.ImageUrl = "~/App_Themes/" + Page.Theme + "/images/logo.png";
        }

        protected void Page_PreRender(object sender, EventArgs e)
        { 
            User user = AbleContext.Current.User;
            Basket basket = user.Basket;
            int itemsCount = 0;

            foreach (BasketItem item in basket.Items)
            {
                if (item.OrderItemType == OrderItemType.Product)
                {
                    bool countItem = !item.IsChildItem;
                    if (!countItem)
                    {
                        BasketItem parentItem = item.GetParentItem(false);
                        if (parentItem != null && parentItem.Product != null)
                        {
                            countItem = parentItem.Product.IsKit && parentItem.Product.Kit != null && parentItem.Product.Kit.ItemizeDisplay;
                        }
                    }

                    if (countItem)
                    {
                        itemsCount += item.Quantity;
                    }
                }         
            }

            if (itemsCount > 0)
            {
                ItemCount.Text = string.Format(ItemCount.Text, itemsCount);
                BootItemCount.Text = string.Format(BootItemCount.Text, itemsCount);
                NavBasketLink.Text = itemsCount.ToString();
            }
            else
            {
                ItemCount.Visible = false;
                BootItemCount.Visible = false;
                NavBasketLink.Text = string.Empty;
            }

            ShowWishListCount();

            bool isAnonymous = user.IsAnonymous;
        }

        protected void ShowWishListCount()
        {
            User user = AbleContext.Current.User;
            Wishlist wishlist = user.PrimaryWishlist;
            int itemsCount = 0;

            foreach (WishlistItem item in wishlist.WishlistItems)
            {
                itemsCount += item.Desired;
            }

            if (itemsCount > 0)
            {
                WishListCount.Text = string.Format(WishListCount.Text, itemsCount);
                BootWishListCount.Text = string.Format(BootWishListCount.Text, itemsCount);
                BootWishListCount2.Text = string.Format(BootWishListCount.Text, itemsCount);
            }
            else
            {
                WishListCount.Visible = false;
                BootWishListCount.Visible = false;
                BootWishListCount2.Visible = false;
            }
        }
    }
}