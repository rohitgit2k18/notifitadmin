using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile.UserControls
{
    public partial class StoreHeader : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LogoLink.Text = AbleContext.Current.Store.Name;
            LogoLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Default.aspx");

            HyperLink loginLink = PageHelper.RecursiveFindControl(HeadLoginView, "LoginLink") as HyperLink;
            if (loginLink != null)
                loginLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Login.aspx");

            HyperLink logoutLink = PageHelper.RecursiveFindControl(HeadLoginView, "LogoutLink") as HyperLink;
            if (logoutLink != null)
                logoutLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Logout.aspx");

            HyperLink accountLink = PageHelper.RecursiveFindControl(HeadLoginView, "AccountLink") as HyperLink;
            if (accountLink != null)
                accountLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Members/MyAccount.aspx");
        }
    }
}