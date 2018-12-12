namespace AbleCommerce.ConLib.Account
{
    using System;
    using System.Collections.Specialized;
    using System.ComponentModel;
    using System.Text;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DigitalDelivery;

    [Description("Implements tab menu in My Account section")]
    public partial class AccountTabMenu : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // get settings that impact menu tabs
            User user = AbleContext.Current.User;
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            bool isRegistered = !user.IsAnonymous;

            // construct links
            NameValueCollection menuLinks = new NameValueCollection();
            if (isRegistered)
            {
                menuLinks.Add("Orders", "MyAccount.aspx");
                if (SubscriptionDataSource.CountForUser(user.Id) > 0)
                {
                    menuLinks.Add("Subscriptions", "MySubscriptions.aspx");
                }

                if (OrderItemDigitalGoodDataSource.CountForUser(user.Id) > 0 || DigitalGoodDataSource.FindByUserGroupsCount(user.Id) > 0)
                {
                    menuLinks.Add("Digital Goods", "MyDigitalGoods.aspx");
                }
            }

            if(settings.WishlistsEnabled) menuLinks.Add("Wishlist", "MyWishlist.aspx");
            
            if (isRegistered)
            {
                menuLinks.Add("Profile", "MyCredentials.aspx");
                if(settings.EnablePaymentProfilesStorage && !AbleContext.Current.User.IsAnonymousOrGuest)
                    menuLinks.Add("Payment Types", "PaymentTypes.aspx");
                menuLinks.Add("Address Book", "MyAddressBook.aspx");

                if (settings.ProductReviewEnabled != CommerceBuilder.Users.UserAuthFilter.None)
                {
                    menuLinks.Add("Product Reviews", "MyProductReviews.aspx");
                }
            }

            int affiliateCount = UserDataSource.LoadUserAffiliateAccounts(user.Id).Count;
            if (affiliateCount > 0 || settings.AffiliateAllowSelfSignup)
            {
                menuLinks.Add("Affiliate Program", "MyAffiliateAccount.aspx");
            }

            // determine active page
            string activePage = Request.Url.Segments[Request.Url.Segments.Length - 1].ToLowerInvariant();

            // build menu
            StringBuilder menu = new StringBuilder();
            menu.AppendLine("<div class=\"tabstrip\">");
            menu.AppendLine("<ul>");
            foreach (string key in menuLinks.AllKeys)
            {
                if (IsActive(activePage, menuLinks[key].ToLowerInvariant()))
                {
                    menu.Append("<li class=\"active\">");
                }
                else
                {
                    menu.Append("<li>");
                }
                menu.AppendLine("<a href=\"" + Page.ResolveUrl("~/Members/" + menuLinks[key]) + "\">" + key + "</a></li>");
            }
            menu.AppendLine("</ul>");
            menu.AppendLine("</div>");
            MenuContent.Text = menu.ToString();
        }

        private bool IsActive(string activePage, string menuTarget)
        {
            if (activePage == menuTarget) return true;
            if (activePage == "editaffiliateaccount.aspx" && menuTarget == "myaffiliateaccount.aspx") return true;
            if (activePage == "editmyaddress.aspx" && menuTarget == "myaddressbook.aspx") return true;
            if (activePage == "editmyreview.aspx" && menuTarget == "myproductreviews.aspx") return true;
            if (activePage == "sendmywishlist.aspx" && menuTarget == "mywishlist.aspx") return true;
            if (activePage == "editpaymenttype.aspx" && menuTarget == "paymenttypes.aspx") return true;
            return false;
        }
    }
}