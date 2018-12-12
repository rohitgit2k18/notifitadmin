namespace AbleCommerce.Admin._Store
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using CommerceBuilder.UI;

    public partial class Images : AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // INITIALIZE FORM
                StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                IconWidth.Text = settings.IconImageWidth.ToString();
                IconHeight.Text = settings.IconImageHeight.ToString();
                ThumbnailWidth.Text = settings.ThumbnailImageWidth.ToString();
                ThumbnailHeight.Text = settings.ThumbnailImageHeight.ToString();
                StandardWidth.Text = settings.StandardImageWidth.ToString();
                StandardHeight.Text = settings.StandardImageHeight.ToString();
                ImageSkuLookupEnabled.Checked = settings.ImageSkuLookupEnabled;
                OptionThumbnailHeight.Text = settings.OptionThumbnailHeight.ToString();
                OptionThumbnailWidth.Text = settings.OptionThumbnailWidth.ToString();
                OptionThumbnailColumns.Text = settings.OptionThumbnailColumns.ToString();
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            settings.IconImageWidth = AlwaysConvert.ToInt(IconWidth.Text);
            settings.IconImageHeight = AlwaysConvert.ToInt(IconHeight.Text);
            settings.ThumbnailImageWidth = AlwaysConvert.ToInt(ThumbnailWidth.Text);
            settings.ThumbnailImageHeight = AlwaysConvert.ToInt(ThumbnailHeight.Text);
            settings.StandardImageWidth = AlwaysConvert.ToInt(StandardWidth.Text);
            settings.StandardImageHeight = AlwaysConvert.ToInt(StandardHeight.Text);
            settings.ImageSkuLookupEnabled = ImageSkuLookupEnabled.Checked;
            settings.OptionThumbnailHeight = AlwaysConvert.ToInt(OptionThumbnailHeight.Text);
            settings.OptionThumbnailWidth = AlwaysConvert.ToInt(OptionThumbnailWidth.Text);
            settings.OptionThumbnailColumns = AlwaysConvert.ToInt(OptionThumbnailColumns.Text);
            settings.Save();
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            SavedMessage.Visible = true;
        }
    }
}