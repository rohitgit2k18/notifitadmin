
namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Web;
    using System.Web.UI.DataVisualization.Charting;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Shipping;
    using NHibernate;
    using NHibernate.Criterion;
    using NHibernate.Transform;

    public partial class SalesByCountryReport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DateTime localNow = LocaleHelper.LocalNow;
                StartDate.SelectedDate = new DateTime(localNow.Year, localNow.Month, 1);
                EndDate.SelectedDate = new DateTime(localNow.Year, localNow.Month, DateTime.DaysInMonth(localNow.Year, localNow.Month));
                ProcessButton_Click(null, null);
            }
        }

        protected void ProcessButton_Click(object sender, EventArgs e)
        {
            // build data
            IList<SalesByCountrySummary> reportData = ReportDataSource.GetSalesByCountry(StartDate.SelectedDate, EndDate.SelectedDate, 10, 0, "TotalSales DESC");
            Chart1.Visible = reportData.Count > 0;
            BuildCharts(reportData, StartDate.SelectedDate, EndDate.SelectedDate);
        }

        private void BuildCharts(IList<SalesByCountrySummary> data, DateTime startDate, DateTime endDate)
        {
            // reset chart points
            Chart1.Series["Default"].Points.Clear();

            // populate data points
            foreach (SalesByCountrySummary summary in data)
            {
                // set point label
                string summaryLabel = summary.Country.Name;

                // set count chart value
                DataPoint dataPoint = new DataPoint();
                dataPoint.SetValueXY(summaryLabel, summary.TotalSales);

                // if sales-by-state report is installed in same path, link up the chart points for drill-down
                string basePath = AppDomain.CurrentDomain.BaseDirectory;
                string currPagePath = Path.GetDirectoryName(HttpContext.Current.Request.Url.AbsolutePath);
                if (currPagePath != null)
                {
                    if (File.Exists(basePath + currPagePath.Substring(1) + "\\SalesByState.aspx"))
                    {
                        string drilldownUrl = string.Format("SalesByState.aspx?CountryCode={0}&SDate={1}&EDate={2}", summary.BillToCountryCode, startDate, endDate);
                        dataPoint.LabelUrl = drilldownUrl;
                        dataPoint.Url = drilldownUrl;
                    }

                    // add the datapoint to the series
                    Chart1.Series["Default"].Points.Add(dataPoint);
                }
            }

            // set chart 1 settings
            Chart1.Series["Default"].ChartType = SeriesChartType.Pie;
            Chart1.Series["Default"].Label = "#VALX";
            //Chart1.Series["Default"].LegendText = "#VALX";

            Chart1.Series["Default"]["PieLabelStyle"] = "Outside";

            Chart1.ChartAreas["ChartArea1"].Area3DStyle.Enable3D = true;

            // bind datagrid
            grd_Sales.DataSource = data;
            grd_Sales.DataBind();
        }
    }
}