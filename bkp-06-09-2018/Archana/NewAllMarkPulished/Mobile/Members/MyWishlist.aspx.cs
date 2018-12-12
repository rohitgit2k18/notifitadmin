namespace AbleCommerce.Mobile.Members
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
    using AbleCommerce.Code;

    public partial class MyWishlist : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // CHECK IF WISHLISTS ARE ENABLED
            if (!AbleContext.Current.Store.Settings.WishlistsEnabled) Response.Redirect("MyAccount.aspx");

            User user = AbleContext.Current.User;
            AnonymousPanel.Visible = user.IsAnonymous;
            BindWishlist();
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
            WishlistUpdatedMessage.Visible = true;
        }

        protected void KeepShoppingButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl());
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
                            Response.Redirect(NavigationHelper.GetBasketUrl());
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
            }
            else
            {
                ClearWishlistButton.Visible = false;
                UpdateButton.Visible = false;
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

            decimal shopPrice = TaxHelper.GetShopPrice(price, item.Product.TaxCode != null ? item.Product.TaxCode.Id : 0);
            return shopPrice.LSCurrencyFormat("ulc");
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

            RegisterLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Login.aspx");
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
    }
}