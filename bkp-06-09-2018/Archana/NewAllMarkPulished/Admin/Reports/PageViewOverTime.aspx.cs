namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.DataVisualization.Charting;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Types;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;

    public partial class PageViewOverTime : CommerceBuilder.UI.AbleCommerceAdminPage
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
            ActivityByHourAjax.Update();
            initLast24HourChart();
            initHourChart();
            initDayChart();
            initMonthChart();
            ActivityByHourPanel.Visible = true;
        }

        private void initLast24HourChart()
        {
            string cacheKey = "15B642D6-FB16-4027-989C-6F40FA821A73";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            if (cacheWrapper == null)
            {
                //LOAD VIEWS
                SortableCollection<KeyValuePair<int, int>> viewsByHour = PageViewDataSource.GetViewsByHour(true, DateTime.UtcNow.AddHours(-24));
                //RESULTS ARE SORTED FROM 0 (MIDNIGHT) TO 23 (11PM)
                int thisHour = LocaleHelper.LocalNow.Hour;
                //SHIFT SO IT GOES FOR PAST 24 HOURS
                for (int i = 0; i <= thisHour; i++)
                {
                    KeyValuePair<int, int> tempCount = viewsByHour[0];
                    viewsByHour.RemoveAt(0);
                    viewsByHour.Add(tempCount);
                }
                //CREATE CHART
                Last24HoursChart.Series["Views"].Points.Clear();
                for (int i = 0; i < viewsByHour.Count; i++)
                {
                    string dayName;
                    int hour = viewsByHour[i].Key;
                    if (hour == 0)
                    {
                        dayName = "12a";
                    }
                    else if (hour == 12)
                    {
                        dayName = "12p";
                    }
                    else if (hour > 12)
                    {
                        hour -= 12;
                        dayName = hour.ToString() + "p";
                    }
                    else dayName = hour.ToString() + "a";
                    DataPoint point = new DataPoint(Last24HoursChart.Series["Views"]);
                    point.SetValueXY(dayName, new object[] { viewsByHour[i].Value });
                    Last24HoursChart.Series["Views"].Points.Add(point);
                }
                Last24HoursChart.DataBind();

                //CACHE THE DATA
                cacheWrapper = new CacheWrapper(viewsByHour);
                Cache.Remove(cacheKey);
                Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                SortableCollection<KeyValuePair<int, int>> viewsByHour = (SortableCollection<KeyValuePair<int, int>>)cacheWrapper.CacheValue;
                //CREATE CHART
                Last24HoursChart.Series["Views"].Points.Clear();
                for (int i = 0; i < viewsByHour.Count; i++)
                {
                    string dayName;
                    int hour = viewsByHour[i].Key;
                    if (hour == 0)
                    {
                        dayName = "12a";
                    }
                    else if (hour == 12)
                    {
                        dayName = "12p";
                    }
                    else if (hour > 12)
                    {
                        hour -= 12;
                        dayName = hour.ToString() + "p";
                    }
                    else dayName = hour.ToString() + "a";
                    DataPoint point = new DataPoint(Last24HoursChart.Series["Views"]);
                    point.SetValueXY(dayName, new object[] { viewsByHour[i].Value });
                    Last24HoursChart.Series["Views"].Points.Add(point);
                }
                Last24HoursChart.DataBind();
            }
            Last24HoursChart.ChartAreas[0].AxisX.Interval = 1;
        }

        private void initHourChart()
        {
            string cacheKey = "59A0ABAC-9204-49ab-A333-85340024E802";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            if (cacheWrapper == null)
            {
                //LOAD VIEWS
                SortableCollection<KeyValuePair<int, int>> viewsByHour = PageViewDataSource.GetViewsByHour(true);
                //RESULTS ARE SORTED FROM 0 (MIDNIGHT) TO 23 (11PM)
                //SHIFT SO IT GOES FROM 6AM TO 5AM INSTEAD
                for (int i = 0; i < 6; i++)
                {
                    KeyValuePair<int, int> tempCount = viewsByHour[0];
                    viewsByHour.RemoveAt(0);
                    viewsByHour.Add(tempCount);
                }
                //CREATE CHART
                ViewsByHourChart.Series["Views"].Points.Clear();
                for (int i = 0; i < viewsByHour.Count; i++)
                {
                    string dayName;
                    int hour = viewsByHour[i].Key;
                    if (hour == 0)
                    {
                        dayName = "12a";
                    }
                    else if (hour == 12)
                    {
                        dayName = "12p";
                    }
                    else if (hour > 12)
                    {
                        hour -= 12;
                        dayName = hour.ToString() + "p";
                    }
                    else dayName = hour.ToString() + "a";
                    DataPoint point = new DataPoint(ViewsByHourChart.Series["Views"]);
                    point.SetValueXY(dayName, new object[] { viewsByHour[i].Value });
                    ViewsByHourChart.Series["Views"].Points.Add(point);
                }
                ViewsByHourChart.DataBind();

                //CACHE THE DATA
                cacheWrapper = new CacheWrapper(viewsByHour);
                Cache.Remove(cacheKey);
                Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                //USE CACHED VALUES
                SortableCollection<KeyValuePair<int, int>> viewsByHour = (SortableCollection<KeyValuePair<int, int>>)cacheWrapper.CacheValue;
                
                //CREATE CHART
                ViewsByHourChart.Series["Views"].Points.Clear();
                for (int i = 0; i < viewsByHour.Count; i++)
                {
                    string dayName;
                    int hour = viewsByHour[i].Key;
                    if (hour == 0)
                    {
                        dayName = "12a";
                    }
                    else if (hour == 12)
                    {
                        dayName = "12p";
                    }
                    else if (hour > 12)
                    {
                        hour -= 12;
                        dayName = hour.ToString() + "p";
                    }
                    else dayName = hour.ToString() + "a";
                    DataPoint point = new DataPoint(ViewsByHourChart.Series["Views"]);
                    point.SetValueXY(dayName, new object[] { viewsByHour[i].Value });
                    ViewsByHourChart.Series["Views"].Points.Add(point);
                }
                ViewsByHourChart.DataBind();
            }
            ViewsByHourChart.ChartAreas[0].AxisX.Interval = 1;
        }

        private void initDayChart()
        {
            string cacheKey = "D7A9D943-D24B-47ad-9E43-559390C14156";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            if (cacheWrapper == null)
            {
                //LOAD VIEWS
                SortableCollection<KeyValuePair<int, int>> viewsByDay = PageViewDataSource.GetViewsByDay(true);
                //CREATE CHART
                ViewsByDayChart.Series["Views"].Points.Clear();
                for (int i = 0; i < viewsByDay.Count; i++)
                {
                    DataPoint point = new DataPoint(ViewsByDayChart.Series["Views"]);
                    point.SetValueXY(viewsByDay[i].Key.ToString(), new object[] { viewsByDay[i].Value });
                    ViewsByDayChart.Series["Views"].Points.Add(point);
                }
                ViewsByDayChart.DataBind();

                //CACHE THE DATA
                cacheWrapper = new CacheWrapper(viewsByDay);
                Cache.Remove(cacheKey);
                Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                //USE CACHED VALUES
                SortableCollection<KeyValuePair<int, int>> viewsByDay = (SortableCollection<KeyValuePair<int, int>>)cacheWrapper.CacheValue;
                //CREATE CHART
                ViewsByDayChart.Series["Views"].Points.Clear();
                for (int i = 0; i < viewsByDay.Count; i++)
                {
                    DataPoint point = new DataPoint(ViewsByDayChart.Series["Views"]);
                    point.SetValueXY(viewsByDay[i].Key.ToString(), new object[] { viewsByDay[i].Value });
                    ViewsByDayChart.Series["Views"].Points.Add(point);
                }
                ViewsByDayChart.DataBind();
            }
            ViewsByDayChart.ChartAreas[0].AxisX.Interval = 1;
        }

        private void initMonthChart()
        {
            string cacheKey = "69F41EE8-327B-401c-BE1A-A2F9208BC257";
            CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
            if (cacheWrapper == null)
            {
                //LOAD VIEWS
                SortableCollection<KeyValuePair<int, int>> viewsByMonth = PageViewDataSource.GetViewsByMonth(true);
                //CREATE CHART
                ViewsByMonthChart.Series["Views"].Points.Clear();
                for (int i = 0; i < viewsByMonth.Count; i++)
                {
                    DataPoint point = new DataPoint(ViewsByMonthChart.Series["Views"]);
                    point.SetValueXY(viewsByMonth[i].Key.ToString(), new object[] { viewsByMonth[i].Value });
                    ViewsByMonthChart.Series["Views"].Points.Add(point);
                }
                ViewsByMonthChart.DataBind();

                //CACHE THE DATA
                cacheWrapper = new CacheWrapper(viewsByMonth);
                Cache.Remove(cacheKey);
                Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
            }
            else
            {
                //USE CACHED VALUES
                SortableCollection<KeyValuePair<int, int>> viewsByMonth = (SortableCollection<KeyValuePair<int, int>>)cacheWrapper.CacheValue;
                //CREATE CHART
                ViewsByMonthChart.Series["Views"].Points.Clear();
                for (int i = 0; i < viewsByMonth.Count; i++)
                {
                    DataPoint point = new DataPoint(ViewsByMonthChart.Series["Views"]);
                    point.SetValueXY(viewsByMonth[i].Key.ToString(), new object[] { viewsByMonth[i].Value });
                    ViewsByMonthChart.Series["Views"].Points.Add(point);
                }
                ViewsByMonthChart.DataBind();
            }
            ViewsByMonthChart.ChartAreas[0].AxisX.Interval = 1;
        }
    }
}