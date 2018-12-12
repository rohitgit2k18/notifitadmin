namespace AbleCommerce
{
    using System;

    public partial class Logout : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CommerceBuilder.Users.User.Logout();
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl(), false);
        }
    }
}