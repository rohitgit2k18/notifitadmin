namespace AbleCommerce
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Users;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Common;

    public partial class FindWishlist : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            // CHECK IF THE WISHLIST SEARCH ENABLED
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            if (!settings.WishlistSearchEnabled)
            {
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl());
                return;
            }
            if (!Page.IsPostBack)
            {
                SearchName.Text = Request.QueryString["name"];
                if (!string.IsNullOrEmpty(SearchName.Text)) SearchButton_Click(sender, e);
            }
        }

        protected string GetUserName(object dataItem)
        {
            User u = (User)dataItem;
            string fullName = u.PrimaryAddress.FullName;
            if (!string.IsNullOrEmpty(fullName))
            {
                return fullName;
            }
            return u.UserName;
        }

        protected string GetLocation(object dataItem)
        {
            Address a = (Address)dataItem;
            List<string> l = new List<string>();
            if (!string.IsNullOrEmpty(a.City))
            {
                l.Add(a.City);
            }
            if (!string.IsNullOrEmpty(a.Province))
            {
                l.Add(a.Province);
            }
            return string.Join(", ", l.ToArray());
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            WishlistGrid.Visible = true;
        }
    }
}