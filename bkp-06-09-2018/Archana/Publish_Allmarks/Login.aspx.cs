using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AbleCommerce.Code;
using CommerceBuilder.Common;
using CommerceBuilder.Stores;

namespace AbleCommerce
{
    public partial class Login : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            string returnUrl = AbleCommerce.Code.NavigationHelper.GetReturnUrl(string.Empty);
            if (!string.IsNullOrEmpty(returnUrl))
            {
                if (returnUrl.ToLowerInvariant().Contains("/admin/"))
                {

                    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Login.aspx?ReturnUrl=" + Server.UrlEncode(returnUrl)));
                }
                else if (returnUrl.ToLowerInvariant().Contains("/mobile/"))
                {

                    Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Login.aspx?ReturnUrl=") + Server.UrlEncode(returnUrl));
                }
            }

            RestrictedLoginPanel.Visible = AbleContext.Current.Store.Settings.RestrictStoreAccess != AccessRestrictionType.None;
            NormalLoginPanel.Visible = !RestrictedLoginPanel.Visible;
        }
    }
}