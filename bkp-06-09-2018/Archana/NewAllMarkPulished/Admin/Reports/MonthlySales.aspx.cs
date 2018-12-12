using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web; 
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using System.Collections.Generic;
using CommerceBuilder.Extensions;
using System.Web.UI.DataVisualization.Charting;
using CommerceBuilder.Types;

namespace AbleCommerce.Admin.Reports
{
public partial class MonthlySales : CommerceBuilder.UI.AbleCommerceAdminPage
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
        Response.AppendHeader("pragma", "no-store,no-cache");
        Response.AppendHeader("cache-control", "no-cache, no-store,must-revalidate, max-age=-1");
        Response.AppendHeader("expires", "-1");

        //Initialize the chart data
        DateTime localNow = LocaleHelper.LocalNow;
        DateTime fromDate = new DateTime(localNow.Year, localNow.Month, 1);
        DateTime toDate = new DateTime(localNow.Year, localNow.Month, DateTime.DaysInMonth(localNow.Year, localNow.Month));
        CurrentMonthSales.Sales = initMonthChart(CurrentMonthChart, fromDate, toDate);

        fromDate = fromDate.AddMonths(-1);
        toDate = new DateTime(fromDate.Year, fromDate.Month, DateTime.DaysInMonth(localNow.Year, fromDate.Month));
        LastMonthSales.Sales = initMonthChart(LastMonthChart, fromDate, toDate);

        initPastMonthsChart(PastThreeMonthChart, 3);
        initPastMonthsChart(PastSixMonthChart, 6);
        initPastMonthsChart(PastTwelveMonthChart, 12);

        PastThreeMonthSales.Sales = ReportDataSource.GetMonthlySales(localNow.AddMonths(-3), localNow);
        PastSixMonthSales.Sales = ReportDataSource.GetMonthlySales(localNow.AddMonths(-6), localNow);
        Past12MonthSales.Sales = ReportDataSource.GetMonthlySales(localNow.AddMonths(-12), localNow);

        SalesOverTimePanel.Visible = true;
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

    private void initPastMonthsChart(Chart chart, int numberOfPastMonths)
    {
        string cacheKey = "39C69D16-CD5A-4287-8DD4-E21019A78B8E" + chart.ID;
        CacheWrapper cacheWrapper = Cache[cacheKey] as CacheWrapper;
        if (cacheWrapper == null)
        {
            //LOAD VIEWS
            SortableCollection<KeyValuePair<DateTime, decimal>> salesByMonth = ReportDataSource.GetSalesForPastMonths(numberOfPastMonths, true);
            //BUILD BAR CHART
            chart.Series["Sales"].Points.Clear();
            for (int i = 0; i < salesByMonth.Count; i++)
            {
                int roundedTotal = (int)Math.Round(salesByMonth[i].Value, 0);
                DataPoint point = new DataPoint(chart.Series["Sales"]);
                point.SetValueXY(salesByMonth[i].Key.ToString("MMM yy"), new object[] { roundedTotal });
                chart.Series["Sales"].Points.Add(point);
            }
            chart.DataBind();

            //CACHE THE DATA
            cacheWrapper = new CacheWrapper(salesByMonth);
            Cache.Remove(cacheKey);
            Cache.Add(cacheKey, cacheWrapper, null, LocaleHelper.LocalNow.AddMinutes(5).AddSeconds(-1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.High, null);
        }
        else
        {
            //USE CACHED VALUES
            SortableCollection<KeyValuePair<DateTime, decimal>> salesByMonth = (SortableCollection<KeyValuePair<DateTime, decimal>>)cacheWrapper.CacheValue;
            chart.Series["Sales"].Points.Clear();
            for (int i = 0; i < salesByMonth.Count; i++)
            {
                int roundedTotal = (int)Math.Round(salesByMonth[i].Value, 0);
                DataPoint point = new DataPoint(chart.Series["Sales"]);
                point.SetValueXY(salesByMonth[i].Key.ToString("MMM yy"), new object[] { roundedTotal });
                chart.Series["Sales"].Points.Add(point);
            }
            chart.DataBind();
        }
    }
}
}
