namespace AbleCommerce.Admin.UserControls {
    using System;
    using System.Data;
    using System.Configuration;
    using System.Collections;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;

    public partial class HeaderNavigation : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (AbleContext.Current.User == null || AbleContext.Current.User.IsAdmin == false)
            {
                AdminNavigationHeaderPanel.Visible = false;
            }
            else
            {
                OrdersLink.Visible = (AbleContext.Current.User.IsInRole(Role.OrderAdminRoles));
                CatalogLink.Visible = (AbleContext.Current.User.IsInRole(Role.CatalogAdminRoles));
            }
        }
    }
}