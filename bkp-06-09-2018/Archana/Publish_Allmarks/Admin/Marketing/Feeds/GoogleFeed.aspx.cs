using System;
using System.Web.UI;
using CommerceBuilder.Common;
using CommerceBuilder.Stores;
using CommerceBuilder.Utility;
using CommerceBuilder.UI;
using CommerceBuilder.Configuration;
using AbleCommerce.Code;
using System.Text;

namespace AbleCommerce.Admin.Marketing.Feeds
{
    public partial class _GoogleFeed : AbleCommerceAdminPage
    {
        StoreSettingsManager _settings;
        ApplicationSettings _appSettings;

        protected void Page_Load(object sender, EventArgs e)
        {
            _settings = AbleContext.Current.Store.Settings;
            _appSettings = ApplicationSettings.Instance;
            if (!Page.IsPostBack)
            {
                if (_appSettings.GoogleFeedInterval > 0) EnableFeed.Checked = true;
                TimeInterval.Text = _appSettings.GoogleFeedInterval.ToString();
                if (_settings.GoogleFeedIncludeAllProducts)
                {
                    AllProducts.Checked = true;
                    MarkedProducts.Checked = false;
                }
                else                
                {
                    AllProducts.Checked = false;
                    MarkedProducts.Checked = true;
                }
                DefaultBrand.Text = _settings.GoogleFeedDefaultBrand;
                DefaultCategory.Text = _settings.GoogleFeedDefaultCategory;
                string storeUrl = AbleContext.Current.Store.StoreUrl;
                if (!storeUrl.EndsWith("/"))
                    storeUrl += "/";
                FeedURL.Text = storeUrl + "Feeds/GoogleFeedData.txt";
            }

            RegisterJs();
        }

        protected void RegisterJs()
        {
            StringBuilder js = new StringBuilder();
            js.AppendLine("function toggleTime(show) {");
            js.AppendLine("if (show) {");
            js.AppendLine("$(\"#" + trTimeInterval.ClientID + "\").show();");
            js.AppendLine("tb = $(\"#" + TimeInterval.ClientID + "\");");
            js.AppendLine("if (tb.val() == \"\" || tb.val() == \"0\") {");
            js.AppendLine("$(\"#" + TimeInterval.ClientID + "\").val(\"360\");");
            js.AppendLine("}");
            js.AppendLine("}");
            js.AppendLine("else $(\"#" + trTimeInterval.ClientID + "\").hide();");
            js.AppendLine("}");

            js.AppendLine("$(document).ready(function () {");

            js.AppendLine("var cb = $(\"#" + EnableFeed.ClientID + "\");");
            js.AppendLine("cb.click(function () { toggleTime(this.checked) });");
            js.AppendLine("toggleTime(cb.is(\":checked\"));");
            js.AppendLine("});");

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "GFToggleTime", js.ToString(), true);
        }

        protected void BtnSaveSettings_Click(object sender, EventArgs e)
        {
            int timeInterval = EnableFeed.Checked ? AlwaysConvert.ToInt(TimeInterval.Text) : 0;
            if (timeInterval == 0) EnableFeed.Checked = false;
            _appSettings.GoogleFeedInterval = timeInterval;
            _appSettings.Save();

            _settings.GoogleFeedIncludeAllProducts = AllProducts.Checked;
            _settings.GoogleFeedDefaultBrand = DefaultBrand.Text.Trim();
            _settings.GoogleFeedDefaultCategory = DefaultCategory.Text.Trim();
            _settings.Save();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            //redirect to dashboard?
            Response.Redirect("~/Admin/Default.aspx");
        }

        protected void GenerateFeedButton_Click(object sender, EventArgs e)
        {
            GenerateFeed gf = new GenerateFeed(GoogleFeed.CreateFeed);
            gf.BeginInvoke(true, null, null);
            FeedMessage.Visible = true;
        }

        delegate void GenerateFeed(bool manualFeedGeneration);
    }
}
