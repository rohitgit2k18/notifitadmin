namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.DataVisualization.Charting;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;

    public partial class MonthlyAbandonedBaskets : CommerceBuilder.UI.AbleCommerceAdminPage
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

        protected void UpdateDateControls()
        {
            DateTime reportDate = (DateTime)ViewState["ReportDate"];
            YearList.SelectedIndex = -1;
            ListItem yearItem = YearList.Items.FindByValue(reportDate.Year.ToString());
            if (yearItem != null) yearItem.Selected = true;
            MonthList.SelectedIndex = -1;
            ListItem monthItem = MonthList.Items.FindByValue(reportDate.Month.ToString());
            if (monthItem != null) monthItem.Selected = true;
            BindReport();
        }

        protected void BindReport()
        {
            //GET THE REPORT DATE
            DateTime reportDate = (DateTime)ViewState["ReportDate"];
            //UPDATE CHART
            IList<AbandonedBasketsSummary> abandonedBaskets = ReportDataSource.GetMonthlyAbandonedBaskets(reportDate.Year, reportDate.Month);
            UpdateChart(abandonedBaskets);
            //REMOVE EMPTY RECORDS
            List<AbandonedBasketsSummary> nonEmptyRecords = abandonedBaskets.Where(x => x.BasketCount > 0).ToList();
            AbandonedBasketGrid.DataSource = nonEmptyRecords;
            AbandonedBasketGrid.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DateTime localNow = LocaleHelper.LocalNow;
                int currentYear = localNow.Year;
                for (int i = -10; i < 11; i++)
                {
                    string thisYear = ((int)(currentYear + i)).ToString();
                    YearList.Items.Add(new ListItem(thisYear, thisYear));
                }
                ViewState["ReportDate"] = localNow;
                UpdateDateControls();
            }
            else
            {
                DateTime newReportDate = (new DateTime(Convert.ToInt32(YearList.SelectedValue), Convert.ToInt32(MonthList.SelectedValue), 1));
                ViewState["ReportDate"] = newReportDate;
                UpdateDateControls();
            }
        }

        protected void UpdateChart(IList<AbandonedBasketsSummary> abandonedBaskets)
        {
            //BUILD CHART
            BasketChart.Series["Baskets"].Points.Clear();
            for (int i = 0; i < abandonedBaskets.Count; i++)
            {
                DataPoint point = new DataPoint(BasketChart.Series["Baskets"]);
                point.SetValueXY(((int)(i + 1)).ToString(), new object[] { abandonedBaskets[i].BasketCount });
                BasketChart.Series["Baskets"].Points.Add(point);
            }
            BasketChart.DataBind();
            BasketChart.Width = 900;
            BasketChart.Height = 270;
            BasketChart.ChartAreas[0].AxisY.Interval = 10;
            BasketChart.ChartAreas[0].AxisY.Minimum = 0;
            BasketChart.ChartAreas[0].AxisX.Interval = 1;
        }

        protected void NextButton_Click(object sender, EventArgs e)
        {
            DateTime newReportDate = (new DateTime(Convert.ToInt32(YearList.SelectedValue), Convert.ToInt32(MonthList.SelectedValue), 1)).AddMonths(1);
            ViewState["ReportDate"] = newReportDate;
            UpdateDateControls();
        }

        protected void PreviousButton_Click(object sender, EventArgs e)
        {
            DateTime newReportDate = (new DateTime(Convert.ToInt32(YearList.SelectedValue), Convert.ToInt32(MonthList.SelectedValue), 1)).AddMonths(-1);
            ViewState["ReportDate"] = newReportDate;
            UpdateDateControls();
        }
    }
}