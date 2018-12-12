using System;
using System.Web.UI.WebControls;
using AbleCommerce.Code;
using CommerceBuilder.Common;

namespace AbleCommerce.Mobile.UserControls
{
    public partial class StoreFooter : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ftrFullSiteLink.NavigateUrl = AbleContext.Current.Store.StoreUrl + "Default.aspx?FSIntent=true";
            ftrHomeLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Default.aspx");
            ftrAccLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/MyAccount.aspx");
            ftrCartLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Basket.aspx");
            ftrWishlistLInk.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/MyWishlist.aspx");

            HyperLink loginLink = PageHelper.RecursiveFindControl(HeadLoginView, "ftrLoginLink") as HyperLink;
            if(loginLink != null)
                loginLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Login.aspx");

            HyperLink logoutLink = PageHelper.RecursiveFindControl(HeadLoginView, "ftrLogoutLink") as HyperLink;
            if(logoutLink != null)
                logoutLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Logout.aspx");
        }
    }
}