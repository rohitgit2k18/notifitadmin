namespace AbleCommerce.Admin
{
    using System;
    using System.Collections.Generic;
    using System.Web;
    using System.Web.Security;
    using CommerceBuilder.Common;

    public partial class Logout : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private string _LastPasswordValue = string.Empty;

        protected void Page_Init(object sender, EventArgs e)
        {
            CommerceBuilder.Users.User.Logout();
        }
    }
}