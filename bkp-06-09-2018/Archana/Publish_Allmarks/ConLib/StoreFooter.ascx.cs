using System;
using System.ComponentModel;
using AbleCommerce.Code;
using CommerceBuilder.Common;
using CommerceBuilder.UI;
using CommerceBuilder.Utility;

namespace AbleCommerce.ConLib
{
    [Description("Displays the standard store footer.")]
    public partial class StoreFooter : System.Web.UI.UserControl, IFooterControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AdminLink.Visible = AbleContext.Current.User.IsAdmin;
            MobileLinkPanel.Visible = Request.Browser.IsMobileDevice;
            MobileStoreLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Default.aspx?FSIntent=false");
            WishlistLink.Visible = AbleContext.Current.Store.Settings.WishlistsEnabled;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            bool isAnonymous = AbleContext.Current.User.IsAnonymous;
            AnonymousPH1.Visible = isAnonymous;
            LoggedInPH1.Visible = !isAnonymous;
        }
    }
}