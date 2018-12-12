using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Stores;
using CommerceBuilder.Common;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin._Store
{
    public partial class MobileStoreSettings : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;
            if (!Page.IsPostBack)
            {
                PageSize.Text = settings.MobileStoreCatalogPageSize.ToString();
                DisplayType.SelectedIndex = settings.MobileStoreCatalogRowDisplay ? 1 : 0;
                ProductUseSummary.Checked = settings.MobileStoreProductUseSummary;
                EnableMobileBrowsing.Checked = !settings.MobileStoreClosed;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Store store = AbleContext.Current.Store;
                StoreSettingsManager settings = store.Settings;
                settings.MobileStoreCatalogPageSize = AlwaysConvert.ToInt(PageSize.Text);
                settings.MobileStoreCatalogRowDisplay = DisplayType.SelectedValue == "1";
                settings.MobileStoreProductUseSummary = ProductUseSummary.Checked;
                settings.MobileStoreClosed = !EnableMobileBrowsing.Checked;
                settings.Save();
                SavedMessage.Visible = true;
            }
        }

        protected Dictionary<string, int> EnumToDictionary(Type enumType)
        {
            // get the names from the enumeration
            string[] names = Enum.GetNames(enumType);
            // get the values from the enumeration
            Array values = Enum.GetValues(enumType);
            // turn it into a dictionary
            Dictionary<string, int> ht = new Dictionary<string, int>();
            for (int i = 0; i < names.Length; i++)
                // note the cast to integer here is important
                // otherwise we'll just get the enum string back again
                ht.Add(StringHelper.SpaceName(names[i]), (int)values.GetValue(i));
            // return the dictionary to be bound to
            return ht;
        }
    }
}