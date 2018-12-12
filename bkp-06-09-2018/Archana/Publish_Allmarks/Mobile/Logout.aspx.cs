using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AbleCommerce.Mobile
{
    public partial class Logout : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CommerceBuilder.Users.User.Logout();
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl(), false);
        }
    }
}