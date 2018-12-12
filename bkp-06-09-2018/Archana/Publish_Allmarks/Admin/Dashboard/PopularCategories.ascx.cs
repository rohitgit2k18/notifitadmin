namespace AbleCommerce.Admin.Dashboard {
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.Reporting;
using CommerceBuilder.Utility;
using CommerceBuilder.Types;
using System.Web.UI.DataVisualization.Charting;

    public partial class PopularCategories : System.Web.UI.UserControl
    {
        private bool _ForceRefresh = false;
        private int _Size = 5;

        [Personalizable(), WebBrowsable()]
        public int Size
        {
            get { return _Size; }
            set { _Size = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Controls.Add(new LiteralControl("<script>Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function(evt, args){$(\"#" + tabs.ClientID + "\").tabs();});</script>"));
            string tabName = tab1.InnerText;
            tab1.Controls.Clear();
            tab1.Controls.Add(new LiteralControl("<a href=\"#" + tabpage1.ClientID + "\">" + tabName + "</a>"));
            tabName = tab2.InnerText;
            tab2.Controls.Clear();
            tab2.Controls.Add(new LiteralControl("<a href=\"#" + tabpage2.ClientID + "\">" + tabName + "</a>"));
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (AbleContext.Current.User.IsInRole(CommerceBuilder.Users.Role.ReportAdminRoles))
            {
                if (_Size < 1) _Size = 5;
                initViewChart(_ForceRefresh);
            }
            else this.Controls.Clear();
        }

        private void initViewChart(bool forceRefresh)
        {
            string cacheKey = "3C26BAC7-1D53-40ef-920B-5BDB705F363B";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            if (forceRefresh || (cacheWrapper == null))
            {
                SortableCollection<KeyValuePair<ICatalogable, int>> categoryViews = PageViewDataSource.GetViewsByCategory(_Size, 0, "ViewCount DESC");
                if (categoryViews.Count > 0)
                {
                    //BUILD BAR CHART
                    ViewsChart.Series["Views"].Points.Clear();
                    for (int i = 0; i < categoryViews.Count; i++)
                    {
                        DataPoint point = new DataPoint(ViewsChart.Series["Views"]);
                        point.SetValueXY(categoryViews[i].Key.Name, new object[] { categoryViews[i].Value });
                        ViewsChart.Series["Views"].Points.Add(point);
                    }
                    ViewsChart.DataBind();

                    //CACHE THE DATA
                    cacheWrapper = new CacheWrapper(categoryViews);
                    Cache.Remove(cacheKey);
                    Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
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
            else
            {
                //USE CACHED VALUES
                SortableCollection<KeyValuePair<ICatalogable, int>> categoryViews = (SortableCollection<KeyValuePair<ICatalogable, int>>)cacheWrapper.CacheValue;
                //BUILD BAR CHART
                ViewsChart.Series["Views"].Points.Clear();
                for (int i = 0; i < categoryViews.Count; i++)
                {
                    DataPoint point = new DataPoint(ViewsChart.Series["Views"]);
                    point.SetValueXY(categoryViews[i].Key.Name, new object[] { categoryViews[i].Value });
                    ViewsChart.Series["Views"].Points.Add(point);
                }
                ViewsChart.DataBind();

                ViewsGrid.DataSource = categoryViews;
                ViewsGrid.DataBind();
            }
            DateTime cacheDate = (cacheWrapper != null) ? cacheWrapper.CacheDate : LocaleHelper.LocalNow;
            CacheDate1.Text = string.Format(CacheDate1.Text, cacheDate);
            CacheDate2.Text = string.Format(CacheDate2.Text, cacheDate);
        }

        protected void RefreshLink_Click(object sender, EventArgs e)
        {
            _ForceRefresh = true;
        }
    }
}
