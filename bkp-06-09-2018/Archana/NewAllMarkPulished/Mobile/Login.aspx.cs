using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;

namespace AbleCommerce.Mobile
{
    public partial class Login : AbleCommercePage
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
            }
        }
    }
}