namespace AbleCommerce.Members
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Stores;
    using System.Collections.Specialized;
    using CommerceBuilder.DomainModel;

    public partial class MyWishlist : CommerceBuilder.UI.AbleCommercePage
    {
        DataControlField _ItemPrice = null;
        protected void Page_Init(object sender, EventArgs e)
        {
            // CHECK IF WISHLISTS ARE ENABLED
            if (!AbleContext.Current.Store.Settings.WishlistsEnabled) Response.Redirect("MyAccount.aspx");

            User user = AbleContext.Current.User;
            AnonymousPanel.Visible = user.IsAnonymous;
            LoggedInPanel.Visible = !AnonymousPanel.Visible;
            BindWishlist();

            // WISHLIST SHARING AND SEARCHING
            trWishlistIsPublic.Visible = AbleContext.Current.Store.Settings.WishlistSearchEnabled;
            WishlistIsPublic.Checked = user.PrimaryWishlist.IsPublic;

            string wishlistUrl = AbleContext.Current.Store.StoreUrl + "ViewWishlist.aspx?ViewCode=" + user.PrimaryWishlist.ViewCode;
            WishlistLink.NavigateUrl = wishlistUrl;
            WishlistLink.Text = wishlistUrl;
        }

        protected void ClearWishlistButton_Click(object sender, EventArgs e)
        {
            Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
            wishlist.WishlistItems.DeleteAll();
            BindWishlist();
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            SaveWishlist();
            BindWishlist();
            if (WishlistGrid.Rows.Count > 0)
                WishlistUpdatedMessage.Visible = true;
        }

        protected void KeepShoppingButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl());
        }

        protected void EmailWishlistButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Members/SendMyWishList.aspx");
        }

        protected void WishlistGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (!string.IsNullOrEmpty(e.CommandArgument.ToString()))
            {
                int rowIndex = AlwaysConvert.ToInt(e.CommandArgument);
                int wishlistItemId = (int)WishlistGrid.DataKeys[rowIndex].Value;
                Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
                int index = wishlist.WishlistItems.IndexOf(wishlistItemId);
                switch (e.CommandName)
                {
                    case "Basket":
                        if (index > -1)
                        {
                            wishlist.WishlistItems.MoveToBasket(index, AbleContext.Current.User.Basket);
                            Response.Redirect("~/Basket.aspx");
                        }
                        WishlistGrid.DataBind();
                        break;
                    case "DeleteItem":
                        if (index > -1)
                        {
                            wishlist.WishlistItems.DeleteAt(index);
                        }
                        WishlistGrid.DataBind();
                        break;
                }
            }
        }

        protected void WishlistGrid_DataBound(object sender, System.EventArgs e)
        {
            if ((WishlistGrid.Rows.Count > 0))
            {
                ClearWishlistButton.Visible = true;
                UpdateButton.Visible = true;
                //ONLY SHOW THE SEND LINK IF SMTP SERVER IS UNAVAILABLE
                EmailWishlistButton.Visible = (!String.IsNullOrEmpty(AbleContext.Current.Store.Settings.SmtpServer));
                if (EmailWishlistButton.Visible && AbleContext.Current.User.IsAnonymous)
                    EmailWishlistButton.OnClientClick = "return confirm('Only registered users can email a wishlist.  You will be asked to login or register if you continue.')";
            }
            else
            {
                ClearWishlistButton.Visible = false;
                UpdateButton.Visible = false;
                EmailWishlistButton.Visible = false;
            }
        }

        protected bool HasKitProducts(object dataItem)
        {
            return !string.IsNullOrEmpty(((WishlistItem)dataItem).KitList);
        }

        protected bool ShowProductImagePanel(object dataItem)
        {
            WishlistItem item = (WishlistItem)dataItem;
            return item.Product != null;
        }

        protected string GetProductUrl(object dataItem)
        {
            WishlistItem item = (WishlistItem)dataItem;
            if (item.Product != null)
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

        protected IList<KitProduct> GetKitProducts(object dataItem)
        {
            return ((WishlistItem)dataItem).GetKitProducts(false);
        }

        protected string GetPrice(object dataItem)
        {
            //DETERMINE THE BASE PRICE OF THE ITEM
            WishlistItem item = (WishlistItem)dataItem;
            decimal price;

            if (item.Product.IsSubscription && item.Product.SubscriptionPlan.IsOptional)
            {
                ProductCalculator c = ProductCalculator.LoadForProduct(item.Product.Id, 1, item.OptionList, item.KitList, AbleContext.Current.UserId, false, !item.IsSubscription);
                price = c.Price;
            }
            else
            {
                if (item.Product.UseVariablePrice)
                {
                    price = AlwaysConvert.ToDecimal(item.Price);
                    if (price < item.Product.MinimumPrice) price = AlwaysConvert.ToDecimal(item.Product.MinimumPrice);
                    if (price > item.Product.MaximumPrice) price = AlwaysConvert.ToDecimal(item.Product.MaximumPrice);
                    item.Price = price;
                }
                else
                {
                    // ADD PRICE OF KIT PRODUCTS AS WELL
                    ProductCalculator c = ProductCalculator.LoadForProduct(item.Product.Id, 1, item.OptionList, item.KitList);
                    price = c.Price;
                }
            }

            if (item.Product.VolumeDiscounts.Count > 0)
            {
                foreach (var rec in item.Product.VolumeDiscounts[0].Levels)
                {
                    if (item.Desired >= rec.MinValue && item.Desired <= rec.MaxValue)
                    {
                        return (rec.DiscountAmount).LSCurrencyFormat("ulc") + " ea.";
                    }
                }
            }

            decimal shopPrice = TaxHelper.GetShopPrice(price, item.Product.TaxCode != null ? item.Product.TaxCode.Id : 0);
            return shopPrice > 0 ? shopPrice.LSCurrencyFormat("ulc") + " ea." : "";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // VALIDATE THE WISHLIST
            Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
            List<string> warnMessages;
            bool isValid = wishlist.Validate(out warnMessages);

            // DISPLAY ANY WARNING MESSAGES
            if (!isValid)
            {
                WarningMessageList.DataSource = warnMessages;
                WarningMessageList.DataBind();
            }

            // INITIALIZE PASSWORD ON FIRST VISIT
            if (!Page.IsPostBack)
            {
                WishlistPasswordValue.Text = wishlist.ViewPassword;
            }

            //TOGGLE PRICE COLUMNS
            _ItemPrice = WishlistGrid.Columns[2];
            _ItemPrice.Visible = !AnyWishlistItemsZero();
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            WishlistPasswordValue.Text = StringHelper.StripHtml(WishlistPasswordValue.Text);
            Wishlist w = AbleContext.Current.User.PrimaryWishlist;
            w.ViewPassword = WishlistPasswordValue.Text;
            w.IsPublic = WishlistIsPublic.Checked;
            w.Save();
            WishlistPasswordUpdatedMessage.Visible = true;
        }

        private void BindWishlist()
        {
            WishlistGrid.DataSource = AbleContext.Current.User.PrimaryWishlist.WishlistItems;
            WishlistGrid.DataBind();
        }

        private void SaveWishlist()
        {
            Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
            int rowIndex = 0;
            foreach (GridViewRow saverow in WishlistGrid.Rows)
            {
                int wishlistItemId = (int)WishlistGrid.DataKeys[rowIndex].Value;
                int itemIndex = wishlist.WishlistItems.IndexOf(wishlistItemId);
                if (itemIndex > -1)
                {
                    WishlistItem item = wishlist.WishlistItems[itemIndex];
                    TextBox desired = saverow.FindControl("Desired") as TextBox;
                    if (desired != null)
                    {
                        item.Desired = AlwaysConvert.ToInt16(desired.Text, item.Desired);
                        if (item.Desired <= 0) item.Delete();
                    }
                    DropDownList priority = saverow.FindControl("Priority") as DropDownList;
                    if (priority != null)
                    {
                        item.Priority = AlwaysConvert.ToByte(priority.SelectedValue);
                        if (item.Priority < 0) item.Priority = 0;
                        if (item.Priority > 4) item.Priority = 4;
                    }
                    TextBox comment = saverow.FindControl("Comment") as TextBox;
                    if (comment != null)
                    {
                        item.Comment = StringHelper.StripHtml(comment.Text);
                    }
                    rowIndex++;
                }
            }
            wishlist.Save();
        }

        protected string GetThumbnailUrl(object dataItem)
        {
            WishlistItem item = (WishlistItem)dataItem;
            if (item.Product != null)
            {
                if (item.ProductVariant != null && !string.IsNullOrEmpty(item.ProductVariant.ThumbnailUrl))
                    return item.ProductVariant.ThumbnailUrl;
                else return item.Product.ThumbnailUrl;
            }
            else return string.Empty;
        }

        protected void WishlistGrid_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                PlaceHolder subscriptionPanel = e.Row.FindControl("SubscriptionPanel") as PlaceHolder;
                if (subscriptionPanel != null)
                {
                    WishlistItem wishlistItem = (WishlistItem)e.Row.DataItem;
                    Literal recurringPaymentMessage = subscriptionPanel.FindControl("RecurringPaymentMessage") as Literal;
                    SubscriptionPlan sp = wishlistItem.Product.SubscriptionPlan;
                    if (sp != null && wishlistItem.IsSubscription && wishlistItem.Frequency > 0)
                    {
                        // GET THE RECURRING PAYMENT MESSAGE FOR THIS PRODUCT
                        recurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(wishlistItem);
                        subscriptionPanel.Visible = true;
                    }
                }
            }
        }

        public Boolean AnyWishlistItemsZero()
        {
            Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
            var wishListItems = wishlist.WishlistItems;

            foreach(var item in wishListItems)
            {
                if (String.IsNullOrEmpty(GetPrice(item))) {
                    return true;
                }
            }

            return false;
        }
    }
}