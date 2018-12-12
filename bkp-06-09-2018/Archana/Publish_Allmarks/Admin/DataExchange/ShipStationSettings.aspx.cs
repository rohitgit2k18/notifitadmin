using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.DataExchange;
using CommerceBuilder.Utility;
using System.IO;
using CommerceBuilder.Common;
using CommerceBuilder.Search;
using CommerceBuilder.Users;
using System.Web.Script.Serialization;
using CommerceBuilder.Orders;
using CommerceBuilder.Stores;

namespace AbleCommerce.Admin.DataExchange
{
    public partial class ShipStationSettings : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private string _baseUrl = "https://ssapi.shipstation.com/";
        private StoreSettingsManager _settings = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            _settings = AbleContext.Current.Store.Settings;
            if (!Page.IsPostBack)
            {
                APIKey.Text = _settings.ShipStationAPIKey;
                APISecret.Text = _settings.ShipStationAPISecret;

                if (string.IsNullOrEmpty(_settings.ShipStationAPIBaseURL))
                    APIBaseUrl.Text = _baseUrl;
                else
                    APIBaseUrl.Text = _settings.ShipStationAPIBaseURL;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                _settings.ShipStationAPIKey = APIKey.Text.Trim();
                _settings.ShipStationAPISecret = APISecret.Text.Trim();
                _settings.ShipStationAPIBaseURL = APIBaseUrl.Text.Trim();
                _settings.Save();
                SavedMessage.Visible = true;
            }
        }
    }
}