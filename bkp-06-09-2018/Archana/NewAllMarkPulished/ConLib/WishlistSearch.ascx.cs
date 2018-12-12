namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.UI;

    [Description("A search form to find wishlists of other customers.")]
    public partial class WishlistSearch : System.Web.UI.UserControl, ISidebarControl
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // CHECK IF THE WISHLIST SEARCH IS ENABLED
            // CHECK IF THE WISHLIST SEARCH ENABLED
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            if (!settings.WishlistSearchEnabled)
                WishListSearchPanel.Visible = false;
            else
            {
                AbleCommerce.Code.PageHelper.SetDefaultButton(Name, FindButton);
            }
        }

        protected void FindButton_Click(object sender, System.EventArgs e)
        {
            if (!string.IsNullOrEmpty(Name.Text))
            {
                Response.Redirect("~/FindWishlist.aspx?name=" + Server.UrlEncode(Name.Text));
            }
        }
    }
}