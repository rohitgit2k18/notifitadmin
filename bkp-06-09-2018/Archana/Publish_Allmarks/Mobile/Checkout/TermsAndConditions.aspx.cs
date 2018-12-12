using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Stores;
using CommerceBuilder.Common;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile.Checkout
{
    public partial class TermsAndConditions : CommerceBuilder.UI.AbleCommercePage
    {
        StoreSettingsManager _settings;

        protected void Page_Load(object sender, EventArgs e)
        {
            _settings = AbleContext.Current.Store.Settings;
            if (string.IsNullOrEmpty(_settings.CheckoutTermsAndConditions))
                Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Default.aspx"));

            PHContents.Controls.Add(new LiteralControl(_settings.CheckoutTermsAndConditions));
        }
    }
}