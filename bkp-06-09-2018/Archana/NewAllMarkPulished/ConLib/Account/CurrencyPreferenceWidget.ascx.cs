namespace AbleCommerce.ConLib.Account
{
    using System;
    using System.ComponentModel;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    [Description("User's currency preferences widget")]
    public partial class CurrencyPreferenceWidget : System.Web.UI.UserControl
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (AbleContext.Current.Store.Currencies.Count > 1)
            {
                Store store = AbleContext.Current.Store;
                HelpText.Text = string.Format(HelpText.Text, store.Name, store.BaseCurrency.Name);
                UserCurrency.DataSource = store.Currencies;
                UserCurrency.DataBind();
            }
            else
            {
                WidgetPanel.Visible = false;
            }
        }

        protected void UserCurrency_SelectedIndexChanged(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            user.UserCurrencyId = AlwaysConvert.ToInt(UserCurrency.SelectedValue);
            user.Save();
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