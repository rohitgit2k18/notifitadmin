namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Reporting;
    using System.Collections.Generic;
    using CommerceBuilder.DataExchange;
    using CommerceBuilder.Common;

    public partial class SalesByReferrer : CommerceBuilder.UI.AbleCommerceAdminPage
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
            if (!Page.IsPostBack)
            {
                DateTime localNow = LocaleHelper.LocalNow;
                int currentYear = localNow.Year;
                for (int i = -10; i < 11; i++)
                {
                    string thisYear = ((int)(currentYear + i)).ToString();
                    YearList.Items.Add(new ListItem(thisYear, thisYear));
                }
                string tempDate = Request.QueryString["ReportDate"];
                DateTime reportDate = localNow;
                if ((!string.IsNullOrEmpty(tempDate)) && (tempDate.Length == 8))
                {
                    try
                    {
                        int month = AlwaysConvert.ToInt(tempDate.Substring(0, 2));
                        int day = AlwaysConvert.ToInt(tempDate.Substring(2, 2));
                        int year = AlwaysConvert.ToInt(tempDate.Substring(4, 4));
                        reportDate = new DateTime(year, month, day);
                    }
                    catch { }
                }
                ViewState["ReportDate"] = reportDate;
                UpdateDateFilter();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ExportButton.Visible = ReferrerSalesGrid.Rows.Count > 0;
        }

        protected void UpdateDateFilter()
        {
            DateTime reportDate = (DateTime)ViewState["ReportDate"];
            YearList.SelectedIndex = -1;
            ListItem yearItem = YearList.Items.FindByValue(reportDate.Year.ToString());
            if (yearItem != null) yearItem.Selected = true;
            MonthList.SelectedIndex = -1;
            ListItem monthItem = MonthList.Items.FindByValue(reportDate.Month.ToString());
            if (monthItem != null) monthItem.Selected = true;
            GenerateReport();
        }

        protected void DateFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState["ReportDate"] = new DateTime(AlwaysConvert.ToInt(YearList.SelectedValue), AlwaysConvert.ToInt(MonthList.SelectedValue), 1);
            GenerateReport();
        }

        protected void ReferrerSalesGrid_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (e.SortExpression != ReferrerSalesGrid.SortExpression) e.SortDirection = System.Web.UI.WebControls.SortDirection.Descending;
        }

        protected void NextButton_Click(object sender, EventArgs e)
        {
            DateTime newReportDate = (new DateTime(Convert.ToInt32(YearList.SelectedValue), Convert.ToInt32(MonthList.SelectedValue), 1)).AddMonths(1);
            ViewState["ReportDate"] = newReportDate;
            UpdateDateFilter();
        }

        protected void PreviousButton_Click(object sender, EventArgs e)
        {
            DateTime newReportDate = (new DateTime(Convert.ToInt32(YearList.SelectedValue), Convert.ToInt32(MonthList.SelectedValue), 1)).AddMonths(-1);
            ViewState["ReportDate"] = newReportDate;
            UpdateDateFilter();
        }

        private void GenerateReport()
        {
            //GET THE REPORT DATE
            DateTime reportDate = (DateTime)ViewState["ReportDate"];
            DateTime startOfMonth = new DateTime(reportDate.Year, reportDate.Month, 1);
            DateTime endOfMonth = startOfMonth.AddMonths(1).AddSeconds(-1);
            Misc.AdjustDatesForMinMaxTime(startOfMonth, endOfMonth);
            HiddenStartDate.Value = startOfMonth.ToString();
            HiddenEndDate.Value = endOfMonth.ToString();
            //GET SUMMARIES
            ReferrerSalesGrid.Visible = true;
            ReferrerSalesGrid.DataBind();
        }

        protected void ExportButton_Click(Object sender, EventArgs e)
        {
            GenericExportManager<ReferrerSalesSummary> exportManager = GenericExportManager<ReferrerSalesSummary>.Instance;
            GenericExportOptions<ReferrerSalesSummary> options = new GenericExportOptions<ReferrerSalesSummary>();
            options.CsvFields = new string[] { "Referrer", "OrderCount", "ProductSubtotal", "SalesTotal"};

            DateTime fromDate = AlwaysConvert.ToDateTime(HiddenStartDate.Value);
            DateTime toDate = AlwaysConvert.ToDateTime(HiddenEndDate.Value);
            IList<ReferrerSalesSummary> reportData = ReportDataSource.GetSalesByReferrer(fromDate, toDate, "OrderCount DESC");

            options.ExportData = reportData;
            options.FileTag = string.Format("SALES_BY_REFERRER(from_{0}_to_{1})", fromDate.ToShortDateString(), toDate.ToShortDateString());
            exportManager.BeginExport(options);
        }
    }
}