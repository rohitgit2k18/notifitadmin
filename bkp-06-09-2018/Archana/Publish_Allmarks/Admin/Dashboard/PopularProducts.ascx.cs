namespace AbleCommerce.Admin.Dashboard
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.DataVisualization.Charting;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Types;
    using CommerceBuilder.Utility;

    public partial class PopularProducts : System.Web.UI.UserControl
    {
        protected void PopularProductsTimer_Tick(object sender, EventArgs e)
        {
            // Initialize the chart data            
            PopularProductsAjax.Update();
            initSalesChart();
            initViewsChart();
            PopularProductsTimer.Enabled = false;
            PopularProductsPanel.Visible = true;
            ProgressImage.Visible = false;
        }

        private void initSalesChart()
        {
            string cacheKey = "0AD3A3DA-15F1-4f43-82A3-C0AC3262399D";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            Dictionary<string, object> salesData;
            if (cacheWrapper == null)
            {
                //GET SALES
                DateTime localNow = LocaleHelper.LocalNow;
                DateTime last60Days = (new DateTime(localNow.Year, localNow.Month, localNow.Day, 0, 0, 0)).AddDays(-60);
                IList<ProductSummary> productSales = ReportDataSource.GetSalesByProduct(last60Days, DateTime.MaxValue, 8, 0, "TotalPrice DESC");
                if (productSales.Count > 0)
                {
                    SalesChart1.Series["Sales"].Points.Clear();
                    for (int i = 0; i < productSales.Count; i++)
                    {
                        int roundedTotal = (int)Math.Round((double)productSales[i].TotalPrice, 0);
                        DataPoint point = new DataPoint(SalesChart1.Series["Sales"]);
                        point.SetValueXY(productSales[i].Name, new object[] { roundedTotal });
                        SalesChart1.Series["Sales"].Points.Add(point);
                    }
                    SalesChart1.DataBind();

                    //BIND THE DATA GRID
                    SalesGrid.DataSource = productSales;
                    SalesGrid.DataBind();

                    //CACHE THE DATA
                    salesData = new Dictionary<string, object>();
                    salesData["DataSource"] = productSales;
                    cacheWrapper = new CacheWrapper(salesData);
                    Cache.Remove(cacheKey);
                    Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                }
                else
                {
                    //NO PRODUCTS HAVE BEEN SOLD YET
                    Control container = SalesChart1.Parent;
                    container.Controls.Clear();
                    Panel noViewsPanel = new Panel();
                    noViewsPanel.CssClass = "emptyData";
                    Label noViewsMessage = new Label();
                    noViewsMessage.Text = "No products have been sold yet.";
                    noViewsPanel.Controls.Add(noViewsMessage);
                    container.Controls.Add(noViewsPanel);

                    // REMOVE SALES DATA TAB
                    Tabs.Tabs[1].Visible = false;
                }
            }
            else
            {
                //USE CACHED VALUES
                salesData = (Dictionary<string, object>)cacheWrapper.CacheValue;
                IList<ProductSummary> productSales = (List<ProductSummary>)salesData["DataSource"];
                SalesChart1.Series["Sales"].Points.Clear();
                for (int i = 0; i < productSales.Count; i++)
                {
                    int roundedTotal = (int)Math.Round((double)productSales[i].TotalPrice, 0);
                    DataPoint point = new DataPoint(SalesChart1.Series["Sales"]);
                    point.SetValueXY(productSales[i].Name, new object[] { roundedTotal });
                    SalesChart1.Series["Sales"].Points.Add(point);
                }
                SalesChart1.DataBind();
                SalesGrid.DataSource = productSales;
                SalesGrid.DataBind();
            }
        }

        private void initViewsChart()
        {
            string cacheKey = "242003F5-5A58-44e9-BFB0-C077C6BEDBF2";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            Dictionary<string, object> viewsData;
            if (cacheWrapper == null)
            {
                //GET VIEWS
                SortableCollection<KeyValuePair<ICatalogable, int>> productViews = PageViewDataSource.GetViewsByProduct(8, 0, "ViewCount DESC");
                if (productViews.Count > 0)
                {
                    //BUILD BAR CHART
                    ViewsChart1.Series["Views"].Points.Clear();
                    for (int i = 0; i < productViews.Count; i++)
                    {
                        DataPoint point = new DataPoint(ViewsChart1.Series["Views"]);
                        point.SetValueXY(((ICatalogable)productViews[i].Key).Name, new object[] { productViews[i].Value });
                        ViewsChart1.Series["Views"].Points.Add(point);
                    }
                    ViewsChart1.DataBind();

                    //BIND THE DATA GRID
                    ViewsGrid.DataSource = productViews;
                    ViewsGrid.DataBind();
                    //CACHE THE DATA
                    viewsData = new Dictionary<string, object>();
                    viewsData["DataSource"] = productViews;
                    cacheWrapper = new CacheWrapper(viewsData);
                    Cache.Remove(cacheKey);
                    Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.NotRemovable, null);
                }
                else
                {
                    //NO PRODUCTS HAVE BEEN VIEWED YET OR PAGE TRACKING IS DISABLED
                    Control container = ViewsChart1.Parent;
                    container.Controls.Clear();
                    Panel noViewsPanel = new Panel();
                    noViewsPanel.CssClass = "emptyData";
                    Label noViewsMessage = new Label();
                    noViewsMessage.Text = "No products have been viewed yet or page tracking is disabled.";
                    noViewsPanel.Controls.Add(noViewsMessage);
                    container.Controls.Add(noViewsPanel);

                    // REMOVE VIEWS DATA TAB
                    Tabs.Tabs[3].Visible = false;
                }
            }
            else
            {
                //USE CACHED VALUES
                viewsData = (Dictionary<string, object>)cacheWrapper.CacheValue;
                SortableCollection<KeyValuePair<ICatalogable, int>> productViews = (SortableCollection<KeyValuePair<ICatalogable, int>>)viewsData["DataSource"];
                //BUILD BAR CHART
                ViewsChart1.Series["Views"].Points.Clear();
                for (int i = 0; i < productViews.Count; i++)
                {
                    DataPoint point = new DataPoint(ViewsChart1.Series["Views"]);
                    point.SetValueXY(((ICatalogable)productViews[i].Key).Name, new object[] { productViews[i].Value });
                    ViewsChart1.Series["Views"].Points.Add(point);
                }
                ViewsChart1.DataBind();

                ViewsGrid.DataSource = productViews;
                ViewsGrid.DataBind();
            }
        }
    }
}