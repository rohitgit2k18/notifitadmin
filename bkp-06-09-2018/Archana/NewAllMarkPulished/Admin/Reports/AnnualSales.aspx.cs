namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Drawing;
    using System.Globalization;
    using System.Linq;
    using System.Text;
    using System.Web.UI.DataVisualization.Charting;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using NHibernate;
    using CommerceBuilder.Reporting;

    public partial class AnnualSales : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // build start/end year
                IList<AnnualSalesData> rawData = GetAnnualSalesData();
                int minYear = 1900;
                int maxYear = LocaleHelper.LocalNow.Year;

                if (rawData.Count > 0)
                {
                    minYear = rawData.Min(x => x.SalesYear);
                    maxYear = rawData.Max(x => x.SalesYear);
                }

                // set up dropdown choices
                for (int year = minYear; year <= maxYear; year++)
                {
                    list_StartYear.Items.Add(new ListItem(year.ToString()));
                    list_EndYear.Items.Add(new ListItem(year.ToString()));
                }

                // default to most recent 3 years
                int startYear = Math.Max(minYear, LocaleHelper.LocalNow.Year - 2);
                list_StartYear.SelectedValue = startYear.ToString();
                list_EndYear.SelectedValue = maxYear.ToString();

                // bind report
                ProcessButton_Click(null, null);
            }
        }

        protected void ProcessButton_Click(object sender, EventArgs e)
        {
            // build raw data
            int startYear = AlwaysConvert.ToInt(list_StartYear.SelectedValue);
            int endYear = AlwaysConvert.ToInt(list_EndYear.SelectedValue);
            IList<AnnualSalesData> rawData = ReportDataSource.GetAnnualSalesData(startYear, endYear);

            // create our chart
            BuildCharts(rawData);
        }

        private void BuildCharts(IList<AnnualSalesData> data)
        {
            // reset chart points
            Chart1.Series.Clear();

            // build list of unique years in the raw data.
            List<int> salesYear = data.Select(x => x.SalesYear).Distinct().ToList();

            if (salesYear.Count > 0)
            {
                // build a chart series for each year
                foreach (int year in salesYear)
                {
                    // give the series a name
                    string series = year.ToString();

                    // start a new series using the name
                    Chart1.Legends.Add(series);
                    Chart1.Series.Add(series);
                    Chart1.Series[series].ChartType = SeriesChartType.Column;

                    Chart1.Series[series].IsVisibleInLegend = true;
                    Chart1.Series[series].IsValueShownAsLabel = true;
                    Chart1.Series[series].ToolTip = "#VALY{C0} Total Sales";
                    Chart1.Series[series].LegendText = series;                    
                    Font font = new Font("Arial", 7.0f, FontStyle.Bold);
                    Chart1.Series[series].Font = font;

                    // build list of months in the year for this series
                    List<int> salesMonths = data.Where(x => x.SalesYear == year).Select(x => x.SalesMonth).ToList();

                    // loop each calendar month in the year
                    foreach (int month in salesMonths)
                    {
                        // get total sales for this year/month
                        AnnualSalesData dataRow = data.FirstOrDefault(x => x.SalesYear == year && x.SalesMonth == month);
                        if (dataRow != null)
                        {
                            Chart1.Series[series].Points.AddXY(dataRow.SalesMonth, dataRow.TotalSales);
                        }
                    }
                }
                
                Chart1.ChartAreas[0].AxisX.Title = "Sales Month";
                Chart1.ChartAreas[0].AxisX.TitleFont = new Font("Trebuchet MS", 15.25F, System.Drawing.FontStyle.Bold);
                Chart1.ChartAreas[0].AxisX.TextOrientation = TextOrientation.Horizontal;
                Chart1.ChartAreas[0].AxisX.MajorGrid.Enabled = false;

                Chart1.ChartAreas[0].AxisY.Title = "Total Sales";
                Chart1.ChartAreas[0].AxisY.TitleFont = new Font("Trebuchet MS", 15.25F, System.Drawing.FontStyle.Bold);
                Chart1.ChartAreas[0].AxisY.TextOrientation = TextOrientation.Auto;
                Chart1.ChartAreas[0].AxisY.LabelStyle.Format = "C0";


                Chart1.Legends[0].LegendStyle = LegendStyle.Row;
                Chart1.Legends[0].Docking = Docking.Bottom;
                Chart1.Legends[0].Alignment = StringAlignment.Center;
            }
            else
            {
                Chart1.Visible = false;
            }

            // bind the data to the grid control
            grd_RawData.DataSource = data;
            grd_RawData.DataBind();
        }

        protected void Chart1_Customize(object sender, EventArgs e)
        {
            foreach (var lbl in Chart1.ChartAreas[0].AxisX.CustomLabels)
            {
                int monthNumber = int.Parse(lbl.Text);
                if (monthNumber >= 1 && monthNumber <= 12)
                    lbl.Text = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(monthNumber);
                else
                    lbl.Text = "";
            }
        }

        private static IList<AnnualSalesData> GetAnnualSalesData()
        {
            return ReportDataSource.GetAnnualSalesData(1900, 2099);
        }

        protected void grd_RawData_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if(e.Row.RowType== DataControlRowType.Header)
            {
                e.Row.Cells[0].Text = "Sales Year";
                e.Row.Cells[1].Text = "Sales Month";
                e.Row.Cells[2].Text = "Total Sales";
            }
        }  
    }
}