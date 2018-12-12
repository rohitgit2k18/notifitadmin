using System;
using System.Collections.Generic;
using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Utility;
using CommerceBuilder.UI;
using System.Web.UI.WebControls;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile.Members
{
    public partial class MyAccount : AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IList<Order> orders = AbleContext.Current.User.Orders;
            orders.Sort("OrderDate", CommerceBuilder.Common.SortDirection.DESC);
            OrderGrid.DataSource = orders;
            OrderGrid.DataBind();

            if (AbleContext.Current.Store.EmailLists.Count > 0)
            {
                EmailPreferences.Visible = true;
            }

            UpdateEmailLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/MyCredentials.aspx");
            EmailPreferencesLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/EmailPreferences.aspx");
            ChangePassLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/ChangePassword.aspx");
            AddressBookLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/MyAddressBook.aspx");
            PaymentTypesLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/PaymentTypes.aspx");
            MyReviewsLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/MyProductReviews.aspx");
            WishlistLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/MyWishlist.aspx");

            PhPaymentTypes.Visible = AbleContext.Current.Store.Settings.EnablePaymentProfilesStorage && !AbleContext.Current.User.IsAnonymousOrGuest;
            PhMyReviews.Visible = AbleContext.Current.Store.Settings.ProductReviewEnabled != CommerceBuilder.Users.UserAuthFilter.None;
        }

        protected string GetOrderStatus(object dataItem)
        {
            Order order = (Order)dataItem;
            OrderStatus status = order.OrderStatus;
            if (status == null) return string.Empty;
            return StringHelper.SpaceName(status.DisplayName);
        }

        protected string GetOrderItemName(object dataItem)
        {
            OrderItem orderItem = (OrderItem)dataItem;
            if (orderItem != null)
            {
                if (!string.IsNullOrEmpty(orderItem.VariantName))
                {
                    return orderItem.Name + " (" + orderItem.VariantName + ")";
                }
                return orderItem.Name;
            }
            return string.Empty;
        }

        protected void OrderGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            OrderGrid.PageIndex = e.NewPageIndex;
            OrderGrid.DataBind();
        }
    }
}