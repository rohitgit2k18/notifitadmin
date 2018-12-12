namespace AbleCommerce.Admin.Dashboard
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.DataVisualization.Charting;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Types;
    using CommerceBuilder.Utility;
    using System.IO;

    public partial class SalesOverTime : System.Web.UI.UserControl
    {
        protected void SalesOverTimeTimer_Tick(object sender, EventArgs e)
        {
            SalesOverTimeAjax.Update();
            //Initialize the chart data            
            initDayChart();
            initMonthChart();

            // init current month chart
            DateTime localNow = LocaleHelper.LocalNow;
            DateTime fromDate = new DateTime(localNow.Year, localNow.Month, 1);
            DateTime toDate = new DateTime(localNow.Year, localNow.Month, DateTime.DaysInMonth(localNow.Year, localNow.Month));
            initMonthChart(CurrentMonthChart, fromDate, toDate);

            SalesOverTimeTimer.Enabled = false;
            SalesOverTimePanel.Visible = true;
            ProgressImage.Visible = false;
        }

        private void initDayChart()
        {
            string cacheKey = "E38012C3-C1A0-45a2-A0FF-F32D8DDE043F";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            if (cacheWrapper == null)
            {
                //LOAD VIEWS
                SortableCollection<KeyValuePair<DateTime, decimal>> salesByDay = ReportDataSource.GetSalesForPastDays(7, true);
                //BUILD BAR CHART
                SalesByDayChart.Series["Sales"].Points.Clear();
                for (int i = 0; i < salesByDay.Count; i++)
                {
                    int roundedTotal = (int)Math.Round(salesByDay[i].Value, 0);
                    DataPoint point = new DataPoint(SalesByDayChart.Series["Sales"]);
                    point.SetValueXY(salesByDay[i].Key.ToString("MMM d"), new object[] { roundedTotal });
                    SalesByDayChart.Series["Sales"].Points.Add(point);
                }
                SalesByDayChart.DataBind();

                //CACHE THE DATA
                cacheWrapper = new CacheWrapper(salesByDay);
                Cache.Remove(cacheKey);
                Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                //USE CACHED VALUES
                SortableCollection<KeyValuePair<DateTime, decimal>> salesByDay = (SortableCollection<KeyValuePair<DateTime, decimal>>)cacheWrapper.CacheValue;

                SalesByDayChart.Series["Sales"].Points.Clear();
                for (int i = 0; i < salesByDay.Count; i++)
                {
                    int roundedTotal = (int)Math.Round(salesByDay[i].Value, 0);
                    DataPoint point = new DataPoint(SalesByDayChart.Series["Sales"]);
                    point.SetValueXY(salesByDay[i].Key.ToString("MMM d"), new object[] { roundedTotal });
                    SalesByDayChart.Series["Sales"].Points.Add(point);
                }
                SalesByDayChart.DataBind();
            }

            //using (StringWriter writer = new StringWriter())
            //{
            //    SalesByDayChart.Serializer.Content = SerializationContents.Default;
            //    SalesByDayChart.Serializer.Save(writer);
            //    //Dump the contents to a string
            //    string serializedChartContent = writer.ToString();

            //    // GET THE PATH
            //    string theme = Page.Theme;
            //    if (string.IsNullOrEmpty(theme)) theme = Page.StyleSheetTheme;
            //    if (string.IsNullOrEmpty(theme)) theme = "AbleCommerceAdmin";
            //    string path = Server.MapPath("~/App_Themes/" + theme + "/chartstyles.xml");
            //    File.WriteAllText(path, serializedChartContent);
            //}
        }

        private IList<SalesSummary> initMonthChart(Chart monthChart, DateTime fromDate, DateTime toDate)
        {
            string cacheKey = "E38012C3-C1A0-45a2-A0FF-F32D8DDE043G" + monthChart.ID;
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            if (cacheWrapper == null)
            {
                //LOAD DATA
                IList<SalesSummary> sales = ReportDataSource.GetMonthlySales(fromDate, toDate);

                //BUILD BAR CHART
                monthChart.Series["Sales"].Points.Clear();
                for (int i = 0; i < sales.Count; i++)
                {
                    int roundedTotal = (int)Math.Round(sales[i].GrandTotal, 0);
                    DataPoint point = new DataPoint(monthChart.Series["Sales"]);
                    point.SetValueXY(sales[i].StartDate.ToString("MMM d"), new object[] { roundedTotal });
                    monthChart.Series["Sales"].Points.Add(point);
                }
                monthChart.DataBind();

                //CACHE THE DATA
                cacheWrapper = new CacheWrapper(sales);
                Cache.Remove(cacheKey);
                Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
                return sales;
            }
            else
            {
                //USE CACHED VALUES
                IList<SalesSummary> salesByDay = (IList<SalesSummary>)cacheWrapper.CacheValue;
                monthChart.Series["Sales"].Points.Clear();
                for (int i = 0; i < salesByDay.Count; i++)
                {
                    int roundedTotal = (int)Math.Round(salesByDay[i].GrandTotal, 0);
                    DataPoint point = new DataPoint(monthChart.Series["Sales"]);
                    point.SetValueXY(salesByDay[i].StartDate.ToString("MMM d"), new object[] { roundedTotal });
                    monthChart.Series["Sales"].Points.Add(point);
                }
                monthChart.DataBind();
                return salesByDay;
            }
        }

        private void initMonthChart()
        {
            string cacheKey = "39C69D16-CD5A-4287-8DD4-E21019A78B8E";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            if (cacheWrapper == null)
            {
                //LOAD VIEWS
                SortableCollection<KeyValuePair<DateTime, decimal>> salesByMonth = ReportDataSource.GetSalesForPastMonths(6, true);
                //BUILD BAR CHART
                SalesByMonthChart.Series["Sales"].Points.Clear();
                for (int i = 0; i < salesByMonth.Count; i++)
                {
                    int roundedTotal = (int)Math.Round(salesByMonth[i].Value, 0);
                    DataPoint point = new DataPoint(SalesByMonthChart.Series["Sales"]);
                    point.SetValueXY(salesByMonth[i].Key.ToString("MMM yy"), new object[] { roundedTotal });
                    SalesByMonthChart.Series["Sales"].Points.Add(point);
                }
                SalesByMonthChart.DataBind();

                //CACHE THE DATA
                cacheWrapper = new CacheWrapper(salesByMonth);
                Cache.Remove(cacheKey);
                Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                //USE CACHED VALUES
                SortableCollection<KeyValuePair<DateTime, decimal>> salesByMonth = (SortableCollection<KeyValuePair<DateTime, decimal>>)cacheWrapper.CacheValue;
                SalesByMonthChart.Series["Sales"].Points.Clear();
                for (int i = 0; i < salesByMonth.Count; i++)
                {
                    int roundedTotal = (int)Math.Round(salesByMonth[i].Value, 0);
                    DataPoint point = new DataPoint(SalesByMonthChart.Series["Sales"]);
                    point.SetValueXY(salesByMonth[i].Key.ToString("MMM yy"), new object[] { roundedTotal });
                    SalesByMonthChart.Series["Sales"].Points.Add(point);
                }
                SalesByMonthChart.DataBind();
            }
        }
    }
}