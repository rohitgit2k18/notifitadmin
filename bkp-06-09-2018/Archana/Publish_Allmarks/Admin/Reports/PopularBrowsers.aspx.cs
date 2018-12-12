namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.DataVisualization.Charting;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Types;
    using CommerceBuilder.Common;

    public partial class PopularBrowsers : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            // READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = true;
        }

        protected void Page_SaveStateComplete(object sender, EventArgs e)
        {
            // END READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            drawChart();
        }

        private void drawChart()
        {
            //GET THE TOP 4 BROWSERS BY VIEW
            SortableCollection<KeyValuePair<string, int>> topBrowsers = PageViewDataSource.GetViewsByBrowser(4, 0, "ViewCount DESC, Browser ASC");
            if (topBrowsers.Count > 0)
            {
                //FIND OUT HOW MANY VIEWS TOTAL
                int totalPageViews = PageViewDataSource.CountAll();
                int pageViewsCharted = 0;
                //List<double> viewCounts = new double[topBrowsers.Count];
                //string[] browserNames = new string[topBrowsers.Count];
                List<int> viewCounts = new List<int>();
                List<string> browserNames = new List<string>();
                foreach (KeyValuePair<string, int> browserView in topBrowsers)
                {
                    browserNames.Add(browserView.Key);
                    viewCounts.Add(browserView.Value);
                    pageViewsCharted += browserView.Value;
                }
                if (pageViewsCharted < totalPageViews)
                {
                    //NEED TO ADD AN "OTHER" PIE SLICE
                    browserNames.Add("Other");
                    viewCounts.Add(totalPageViews - pageViewsCharted);
                }
                //BUILD BAR CHART
                BrowserChart.Series["Browsers"].Points.Clear();
                for (int i = 0; i < topBrowsers.Count; i++)
                {
                    DataPoint point = new DataPoint(BrowserChart.Series["Browsers"]);
                    point.SetValueXY(browserNames[i], new object[] { viewCounts[i] });
                    BrowserChart.Series["Browsers"].Points.Add(point);
                }
                BrowserChart.DataBind();
            }
            else
            {
                //NO CATEGORIES HAVE BEEN VIEWED YET OR PAGE TRACKING IS NOT AVAIALBEL
                this.Controls.Clear();
                Panel noViewsPanel = new Panel();
                noViewsPanel.CssClass = "emptyData";
                Label noViewsMessage = new Label();
                noViewsMessage.Text = "No categories have been viewed or page tracking is disabled.";
                noViewsPanel.Controls.Add(noViewsMessage);
                this.Controls.Add(noViewsPanel);
            }
        }
    }
}