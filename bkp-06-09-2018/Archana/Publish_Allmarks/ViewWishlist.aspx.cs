using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Products;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;

namespace AbleCommerce
{
    public partial class ViewWishlist : CommerceBuilder.UI.AbleCommercePage
    {
        int _WishlistId = 0;
        Wishlist _Wishlist;

        private string _Caption = "{0}'s Wishlist";
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        protected void Page_Init(object sender, System.EventArgs e)
        {
            // CHECK IF WISHLISTS DISABLED
            if (!AbleContext.Current.Store.Settings.WishlistsEnabled)
            {
                WishlistCaption.Visible = false;
                WishlistMultiView.SetActiveView(WishlistDisabledView);
                return;
            } 

            string strViewCode = Request.QueryString["ViewCode"];
            Guid viewCode = new Guid();
            if (Guid.TryParse(strViewCode, out viewCode))
            {
                _Wishlist = WishlistDataSource.LoadForViewCode(viewCode);
            }

            if (_Wishlist == null)
            {                
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl());
                return;
            }

            _WishlistId = _Wishlist.Id;
            _Wishlist.Recalculate();
            IList<WishlistItem> items = _Wishlist.WishlistItems;
            Product product;
            WishlistItem item;
            var user = AbleContext.Current.User;
            List<int> groups = (from ug in AbleContext.Current.User.UserGroups select ug.GroupId).ToList<int>();
            for (int i = items.Count - 1; i >= 0; i--)
            {
                item = items[i];
                product = item.Product;
                if (product == null || product.Visibility == CatalogVisibility.Private || isVariantInvalid(item))
                {
                    items.RemoveAt(i);
                }
                else if (!user.IsAdmin)
                {
                    if (product.EnableGroups)
                    {
                        if (groups.Count > 0)
                        {
                            bool isInGroup = product.ProductGroups.Any<ProductGroup>(pg => groups.Contains(pg.Group.Id));
                            if (!isInGroup)
                            {
                                items.RemoveAt(i);
                            }
                        }
                        else
                        {
                            items.RemoveAt(i);
                        }
                    }
                }
            }

            WishlistGrid.DataSource = items;
            WishlistGrid.DataBind();

            if (!string.IsNullOrEmpty(_Wishlist.ViewPassword))
            {
                string currentPassword = (string)Session["Wishlist" + _WishlistId.ToString() + "_Password"];
                if ((currentPassword == null) || (currentPassword != _Wishlist.ViewPassword))
                {
                    WishlistMultiView.SetActiveView(PasswordView);
                    AbleCommerce.Code.PageHelper.SetDefaultButton(Password, CheckPasswordButton.ClientID);
                }
            }
            if (WishlistMultiView.ActiveViewIndex == 0)
            {
                WishlistCaption.Text = string.Format(_Caption, GetUserName(_Wishlist.User));
            }
            else
            {
                WishlistCaption.Text = "Enter Wishlist Password";
            }
        }

        private bool isVariantInvalid(WishlistItem item)
        {
            if (item.Product.ProductOptions.Count > 0)
            {
                ProductVariant v = ProductVariantDataSource.LoadForOptionList(item.Product.Id, item.OptionList);
                if (v == null || !v.Available) return true;
            }

            return false;
        }

        protected void CheckPasswordButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Password.Text))
            {
                string currentPassword = Password.Text;
                if (_Wishlist.ViewPassword == currentPassword)
                {
                    Session["Wishlist" + _WishlistId.ToString() + "_Password"] = currentPassword;
                    WishlistMultiView.SetActiveView(WishlistView);
                    WishlistCaption.Text = string.Format(_Caption, GetUserName(_Wishlist.User));
                }
                else
                {
                    InvalidPasswordLabel.Visible = true;
                    PasswordLabel.Visible = false;
                }
            }
        }

        protected void WishlistGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Basket")
            {
                int wishlistItemId = AlwaysConvert.ToInt(e.CommandArgument);
                int index = _Wishlist.WishlistItems.IndexOf(wishlistItemId);
                if (index > -1)
                {
                    _Wishlist.WishlistItems.CopyToBasket(index, AbleContext.Current.User.Basket);
                    if (!AbleCommerce.Code.PageHelper.HasBasketControl(this.Page)) Response.Redirect("~/Basket.aspx");
                }
            }
        }

        protected string GetPriorityString(object priority)
        {
            switch ((byte)priority)
            {
                case 0:
                    return "lowest";
                case 1:
                    return "low";
                case 2:
                    return "medium";
                case 3:
                    return "high";
                case 4:
                    return "highest";
            }
            return string.Empty;
        }

        private string GetUserName(User u)
        {
            if (u == null) return string.Empty;
            if (u.IsAnonymous) return "Anonymous";
            string fullName = u.PrimaryAddress.FullName;
            if (!string.IsNullOrEmpty(fullName)) return fullName;
            return u.UserName;
        }

        protected bool HasKitProducts(object dataItem)
        {
            return !string.IsNullOrEmpty(((WishlistItem)dataItem).KitList);
        }

        protected IList<KitProduct> GetKitProducts(object dataItem)
        {
            return ((WishlistItem)dataItem).GetKitProducts(false);
        }

        protected bool AllowPurchase(object dataItem)
        {
            WishlistItem item = (WishlistItem)dataItem;
            return !item.Product.DisablePurchase;
        }

        protected decimal GetPrice(object dataItem)
        {
            WishlistItem item = (WishlistItem)dataItem;
            //DETERMINE THE BASE PRICE OF THE ITEM
            decimal price;
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
            return price;
        }

        protected void WishlistMultiView_RowCreated(object sender, GridViewRowEventArgs e)
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
    }
}