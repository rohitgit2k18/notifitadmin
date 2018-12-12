namespace AbleCommerce.Admin._Store.PageTracking
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        StoreSettingsManager _Settings;

        private void SaveData()
        {
            _Settings.PageViewTrackingEnabled = TrackPageViews.Checked;
            _Settings.PageViewTrackingSaveArchive = (SaveArchive.SelectedIndex == 1);
            int tempDays = AlwaysConvert.ToInt(HistoryLength.Text);
            if (tempDays < 0) tempDays = 0;
            _Settings.PageViewTrackingDays = tempDays;
            _Settings.Save();
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            SaveData();
            ResponseMessage.Visible = true;
        }

        protected void SaveButtonGA_Click(object sender, System.EventArgs e)
        {
            _Settings.GoogleUrchinId = GoogleUrchinId.Text;
            _Settings.EnableGoogleAnalyticsPageTracking = EnablePageTracking.Checked;
            _Settings.EnableGoogleAnalyticsEcommerceTracking = EnableEcommerceTracking.Checked;
            _Settings.Save();
            ResponseMessageGA.Visible = true;
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("~/Admin/Default.aspx");
        }

        protected void SaveAndCloseButton_Click(object sender, System.EventArgs e)
        {
            SaveData();
            Response.Redirect("~/Admin/Default.aspx");
        }

        protected void SaveAndCloseButtonGA_Click(object sender, System.EventArgs e)
        {
            _Settings.GoogleUrchinId = GoogleUrchinId.Text;
            _Settings.EnableGoogleAnalyticsPageTracking = EnablePageTracking.Checked;
            _Settings.EnableGoogleAnalyticsEcommerceTracking = EnableEcommerceTracking.Checked;
            _Settings.Save();
            Response.Redirect("~/Admin/Default.aspx");
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            _Settings = AbleContext.Current.Store.Settings;
            if (!Page.IsPostBack)
            {
                TrackPageViews.Checked = _Settings.PageViewTrackingEnabled;
                HistoryLength.Text = _Settings.PageViewTrackingDays.ToString();
                CurrentRecords.Text = PageViewDataSource.CountAll().ToString();
                SaveArchive.SelectedIndex = (_Settings.PageViewTrackingSaveArchive ? 1 : 0);
                SaveArchiveWarningPanel.Visible = (SaveArchive.SelectedIndex == 1);
                GoogleUrchinId.Text = _Settings.GoogleUrchinId;
                EnablePageTracking.Checked = _Settings.EnableGoogleAnalyticsPageTracking;
                EnableEcommerceTracking.Checked = _Settings.EnableGoogleAnalyticsEcommerceTracking;
                ActivityDateUpdateInterval.Text = _Settings.ActivityDateUpdateInterval.ToString();
            }
            ResponseMessageGA.Visible = false;
            ResponseMessage.Visible = false;
        }

        protected void ClearButton_Click(object sender, EventArgs e)
        {
            PageViewDataSource.DeleteAll();
            CurrentRecords.Text = PageViewDataSource.CountAll().ToString();
        }

        protected void ViewButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewLog.aspx");
        }

        protected void SaveArchive_SelectedIndexChanged(object sender, EventArgs e)
        {
            SaveArchiveWarningPanel.Visible = (SaveArchive.SelectedIndex == 1);
        }

        protected void SaveUserSettingsButton_Click(object sender, EventArgs e)
        {
            _Settings.ActivityDateUpdateInterval = AlwaysConvert.ToInt(ActivityDateUpdateInterval.Text);
            _Settings.Save();
            ResponseMessageUserSettings.Visible = true;
        }
    }
}