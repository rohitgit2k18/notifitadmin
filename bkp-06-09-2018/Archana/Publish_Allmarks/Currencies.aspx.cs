using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce
{
    public partial class Currencies : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Store store = AbleContext.Current.Store;
            StoreName.Text = store.Name;
            StoreBaseCurrency.Text = store.BaseCurrency.Name;
        }

        protected void UserCurrency_SelectedIndexChanged(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            user.UserCurrencyId = AlwaysConvert.ToInt(UserCurrency.SelectedValue);
            user.Save();
            if (!string.IsNullOrEmpty(UserCurrency.SelectedItem.Text))
            {
                UpdateMessage.Text = string.Format("Currency Updated to {0}.", UserCurrency.SelectedItem.Text);
            }
            else
            {
                UpdateMessage.Text = "Currency Set To Default.";
            }
            UpdateMessage.Visible = true;
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
                UpdateMessage.Visible = false;
            }
        }
    }
}