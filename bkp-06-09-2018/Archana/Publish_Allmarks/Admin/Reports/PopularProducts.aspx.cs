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
using CommerceBuilder.DataExchange;
using CommerceBuilder.Products;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Reports
{
    public partial class PopularProducts : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        string _SalesCacheKey = "0AD3A3DA-15F1-4f43-82A3-C0AC3262399D";
        string _ViewsCacheKey = "242003F5-5A58-44e9-BFB0-C077C6BEDBF2";
        
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

        protected void Page_Load(Object sender, EventArgs e)
        {
            initSalesChart();
            initViewsChart();
            PopularProductsPanel.Visible = true;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ExportBySalesButton.Visible = SalesGrid.Rows.Count > 0;
            ExportByViewsButton.Visible = ViewsGrid.Rows.Count > 0;
        }

        private void initSalesChart()
        {
            CacheWrapper cacheWrapper = Cache[_SalesCacheKey] as CacheWrapper;
            Dictionary<string, object> salesData;
            if (cacheWrapper == null)
            {
                //GET SALES
                DateTime localNow = LocaleHelper.LocalNow;
                DateTime last60Days = (new DateTime(localNow.Year, localNow.Month, localNow.Day, 0, 0, 0)).AddDays(-60);
                IList<CommerceBuilder.Reporting.ProductSummary> productSales = ReportDataSource.GetSalesByProduct(last60Days, DateTime.MaxValue, 8, 0, "TotalPrice DESC");
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
                    Cache.Remove(_SalesCacheKey);
                    Cache.Add(_SalesCacheKey, cacheWrapper, null, DateTime.UtcNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
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
                IList<CommerceBuilder.Reporting.ProductSummary> productSales = (List<CommerceBuilder.Reporting.ProductSummary>)salesData["DataSource"];
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
            CacheWrapper cacheWrapper = Cache[_ViewsCacheKey] as CacheWrapper;
            Dictionary<string, object> viewsData;
            if (cacheWrapper == null)
            {
                //GET VIEWS
                SortableCollection<KeyValuePair<ICatalogable, int>> productViews = PageViewDataSource.GetViewsByProduct(8, 0, "ViewCount DESC");
                if (productViews.Count > 0)
                {
                    //BUILD BAR CHART
                    ViewsChart1.Series["Views"].Points.Clear();
                    for (int i = productViews.Count - 1; i >= 0; i--)
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
                    Cache.Remove(_ViewsCacheKey);
                    Cache.Add(_ViewsCacheKey, cacheWrapper, null, DateTime.UtcNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.NotRemovable, null);
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
                for (int i = productViews.Count - 1; i >= 0; i--)
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

        protected void ExportByViewsButton_Click(Object sender, EventArgs e)
        {
            GenericExportManager<ProductViewSummary> exportManager = GenericExportManager<ProductViewSummary>.Instance;
            GenericExportOptions<ProductViewSummary> options = new GenericExportOptions<ProductViewSummary>();
            options.CsvFields = new string[] { "ProductName", "Views" };

            CacheWrapper cacheWrapper = Cache[_ViewsCacheKey] as CacheWrapper;
            SortableCollection<KeyValuePair<ICatalogable, int>> productViews;
            Dictionary<string, object> viewsDataWrapper = null;
            IList<ProductViewSummary> viewsSummay = new List<ProductViewSummary>();
            if (cacheWrapper == null)
            {
                //GET VIEWS
                productViews = PageViewDataSource.GetViewsByProduct(50, 0, "ViewCount DESC");
                //CACHE THE DATA
                viewsDataWrapper = new Dictionary<string, object>();
                viewsDataWrapper["DataSource"] = productViews;
                cacheWrapper = new CacheWrapper(viewsDataWrapper);
                Cache.Remove(_ViewsCacheKey);
                Cache.Add(_ViewsCacheKey, cacheWrapper, null, DateTime.UtcNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.NotRemovable, null);
            }
            else
            {
                //USE CACHED VALUES
                viewsDataWrapper = (Dictionary<string, object>)cacheWrapper.CacheValue;
                productViews = (SortableCollection<KeyValuePair<ICatalogable, int>>)viewsDataWrapper["DataSource"];
            }

            // CONVERT TO SUMMARY LIST TO GENERATE CSV
            foreach (KeyValuePair<ICatalogable, int> dataRow in productViews) viewsSummay.Add(new ProductViewSummary(dataRow.Key.Name, dataRow.Value));

            options.ExportData = viewsSummay;
            options.FileTag = "POPULAR_PRODUCTS_BY_VIEWS";
            exportManager.BeginExport(options);
        }

        protected void ExportBySalesButton_Click(Object sender, EventArgs e)
        {
            GenericExportManager<CommerceBuilder.Reporting.ProductSummary> exportManager = GenericExportManager<CommerceBuilder.Reporting.ProductSummary>.Instance;
            GenericExportOptions<CommerceBuilder.Reporting.ProductSummary> options = new GenericExportOptions<CommerceBuilder.Reporting.ProductSummary>();
            options.CsvFields = new string[] { "ProductId", "Name", "TotalPrice", "TotalQuantity" };

            CacheWrapper cacheWrapper = Cache[_SalesCacheKey] as CacheWrapper;
            Dictionary<string, object> salesData;
            IList<CommerceBuilder.Reporting.ProductSummary> productSales = null;
            DateTime localNow = LocaleHelper.LocalNow;
            DateTime last60Days = (new DateTime(localNow.Year, localNow.Month, localNow.Day, 0, 0, 0)).AddDays(-60);
            if (cacheWrapper == null)
            {
                productSales = ReportDataSource.GetSalesByProduct(last60Days, DateTime.MaxValue, 8, 0, "TotalPrice DESC");

                //CACHE THE DATA
                salesData = new Dictionary<string, object>();
                salesData["DataSource"] = productSales;
                cacheWrapper = new CacheWrapper(salesData);
                Cache.Remove(_SalesCacheKey);
                Cache.Add(_SalesCacheKey, cacheWrapper, null, DateTime.UtcNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                //USE CACHED VALUES
                salesData = (Dictionary<string, object>)cacheWrapper.CacheValue;
                productSales = (List<CommerceBuilder.Reporting.ProductSummary>)salesData["DataSource"];
            }

            options.ExportData = productSales;
            options.FileTag = string.Format("POPULAR_PRODUCTS_BY_SALES((from_{0}_to_{1})", localNow.ToShortDateString(), last60Days.ToShortDateString());
            exportManager.BeginExport(options);
        }

        private class ProductViewSummary
        {
            public string ProductName { get; set; }
            public int Views { get; set; }

            public ProductViewSummary(string productName, int views)
            {
                this.ProductName = productName;
                this.Views = views;
            }
        }

        protected string GetGroups(Object dataItem)
        {
            CommerceBuilder.Reporting.ProductSummary summary = (CommerceBuilder.Reporting.ProductSummary)dataItem;
            Product product = summary.Product;
            List<string> groupNames = new List<string>();
            foreach (var pg in product.ProductGroups)
            {
                groupNames.Add(pg.Group.Name);
            }

            return string.Join(",", groupNames.ToArray());
        }

        protected string GetViewsGroups(Object dataItem)
        {
            Product product = dataItem as Product;
            if (product == null) return string.Empty;
            List<string> groupNames = new List<string>();
            foreach (var pg in product.ProductGroups)
            {
                groupNames.Add(pg.Group.Name);
            }

            return string.Join(",", groupNames.ToArray());
        }

    }
}
