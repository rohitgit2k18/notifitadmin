namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    [Description("A simple dropdown menu control to select a preferred currency.")]
    public partial class UserCurrencyMenuDropDown : System.Web.UI.UserControl
    {
        protected void UserCurrency_SelectedIndexChanged(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            user.UserCurrencyId = AlwaysConvert.ToInt(UserCurrency.SelectedValue);
            user.Save();

            //Redirect After Post. This will ensure currency is update on the current page.
            Response.Redirect(Request.RawUrl);
        }

        protected void UserCurrency_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Store store = AbleContext.Current.Store;
                Currency currency = AbleContext.Current.User.UserCurrency;
                ListItem item = UserCurrency.Items.FindByValue(currency.Id.ToString());
                if (item != null)
                {
                    item.Selected = true;
                }
            }
        }
    }
}