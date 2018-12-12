using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Text;
using System.Web.UI;
using System.Web.UI.DataVisualization.Charting;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Reporting;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;
using CommerceBuilder.DomainModel;
using CommerceBuilder.Orders;
using CommerceBuilder.Shipping;
using CommerceBuilder.Stores;
using NHibernate;
using NHibernate.Criterion;
using NHibernate.Transform;

namespace AbleCommerce.Admin.Reports
{
    public partial class NewExistingCustomersReport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DateTime localNow = LocaleHelper.LocalNow;
                StartDate.SelectedDate = new DateTime(localNow.Year, localNow.Month, 1);
                EndDate.SelectedDate = localNow;
                ProcessButton_Click(null, null);
            }
        }

        protected void ProcessButton_Click(object sender, EventArgs e)
        {
            // set up dates
            DateTime startDate = new DateTime(StartDate.SelectedDate.Year, StartDate.SelectedDate.Month, StartDate.SelectedDate.Day, 0, 0, 0);
            DateTime endDate = new DateTime(EndDate.SelectedDate.Year, EndDate.SelectedDate.Month, EndDate.SelectedDate.Day, 23, 59, 59);

            // build raw data
            IList<NewExistingRawData> rawData = ReportDataSource.GetNewExistingRawData(startDate, endDate);

            // process raw data into chart points by day
            IList<NewExistingSalesData> dataPoints = new List<NewExistingSalesData>();

            // determine number of days between start and finish date
            TimeSpan daysBetween = endDate - startDate;

            // compute total days, always add 1 to include last day
            int totalDays = 1 + (int)daysBetween.TotalDays;

            // loop each day to crate data points
            for (int currentDay = 0; currentDay < totalDays; currentDay++)
            {
                DateTime findDate = startDate.AddDays(currentDay);
                int year = findDate.Year;
                int month = findDate.Month;
                int day = findDate.Day;

                IList<NewExistingRawData> findRows = rawData.Where(x => x.OrderDate.Year == year && x.OrderDate.Month == month && x.OrderDate.Day == day).ToList();

                // now we have list of rowdata for just this date
                int newCount = findRows.Count(x => x.PreviousOrders == 0);
                int existingCount = findRows.Count(x => x.PreviousOrders > 0);

                // make a new data point
                NewExistingSalesData rptData = new NewExistingSalesData();
                rptData.NewCustomers = newCount;
                rptData.ExistingCustomers = existingCount;
                rptData.OrderDate = new DateTime(year, month, day);

                dataPoints.Add(rptData);
            }

            // create our chart
            BuildCharts(dataPoints);
        }

        private void BuildCharts(IList<NewExistingSalesData> data)
        {
            // reset chart points
            Chart1.Series.Clear();

            Chart1.Legends.Add("NewCustomers");
            Chart1.Series.Add("NewCustomers");
            Chart1.Series["NewCustomers"].ChartType = SeriesChartType.StackedColumn;
            Chart1.Series["NewCustomers"].Points.DataBindXY(data, "OrderDate", data, "NewCustomers");

            Chart1.Series["NewCustomers"].IsVisibleInLegend = true;
            Chart1.Series["NewCustomers"].IsValueShownAsLabel = true;
            Chart1.Series["NewCustomers"].ToolTip = "#VALY{G} New Customers";
            Chart1.Series["NewCustomers"].LegendText = "New Customers";

            Chart1.Legends.Add("ExistingCustomers");
            Chart1.Series.Add("ExistingCustomers");
            Chart1.Series["ExistingCustomers"].ChartType = SeriesChartType.StackedColumn;
            Chart1.Series["ExistingCustomers"].Points.DataBindXY(data, "OrderDate", data, "ExistingCustomers");

            Chart1.Series["ExistingCustomers"].IsVisibleInLegend = true;
            Chart1.Series["ExistingCustomers"].IsValueShownAsLabel = true;
            Chart1.Series["ExistingCustomers"].ToolTip = "#VALY{G} Existing Customers";
            Chart1.Series["ExistingCustomers"].LegendText = "Existing Customers";

            Chart1.ChartAreas["ChartArea1"].Area3DStyle.Enable3D = true;
            Chart1.ChartAreas["ChartArea1"].AxisX.Title = "Order Date";
            Chart1.ChartAreas["ChartArea1"].AxisX.TitleFont = new Font("Trebuchet MS", 15.25F, System.Drawing.FontStyle.Bold);
            Chart1.ChartAreas["ChartArea1"].AxisX.TextOrientation = TextOrientation.Horizontal;

            Chart1.ChartAreas["ChartArea1"].AxisY.Title = "Total Customers";
            Chart1.ChartAreas["ChartArea1"].AxisY.TitleFont = new Font("Trebuchet MS", 15.25F, System.Drawing.FontStyle.Bold);
            Chart1.ChartAreas["ChartArea1"].AxisY.TextOrientation = TextOrientation.Auto;

            Chart1.Legends[0].LegendStyle = LegendStyle.Row;
            Chart1.Legends[0].Docking = Docking.Bottom;
            Chart1.Legends[0].Alignment = StringAlignment.Center;

            // bind the data to the grid control
            grd_RawData.DataSource = data;
            grd_RawData.DataBind();

        }

        protected void grd_RawData_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[0].Text = "Order Date";
                e.Row.Cells[1].Text = "New Customers";
                e.Row.Cells[2].Text = "Existing Customers";
            }
            else if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text = string.Format("{0:d}", DataBinder.Eval(e.Row.DataItem, "OrderDate"));
            }
        }
    }
}