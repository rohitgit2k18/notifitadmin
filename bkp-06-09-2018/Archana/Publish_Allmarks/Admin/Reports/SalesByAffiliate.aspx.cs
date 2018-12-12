namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DataExchange;
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    
    public partial class SalesByAffiliate : CommerceBuilder.UI.AbleCommerceAdminPage
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
            else
            {
                DateTime newReportDate = (new DateTime(Convert.ToInt32(YearList.SelectedValue), Convert.ToInt32(MonthList.SelectedValue), 1));
                ViewState["ReportDate"] = newReportDate;
                UpdateDateFilter();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ExportButton.Visible = AffiliateSalesGrid.Rows.Count > 0;
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

        protected void AffiliateSalesGrid_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (e.SortExpression != AffiliateSalesGrid.SortExpression) e.SortDirection = System.Web.UI.WebControls.SortDirection.Descending;
        }

        protected string GetDetailUrl(object dataItem)
        {
            AffiliateSalesSummary a = (AffiliateSalesSummary)dataItem;
            StringBuilder url = new StringBuilder();
            url.Append("SalesByAffiliateDetail.aspx?AffiliateId=" + a.AffiliateId.ToString());
            url.Append(string.Format("&ReportDate={0}", LocaleHelper.ToLocalTime(a.StartDate).ToShortDateString()));
            return url.ToString();
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
            //UPDATE REPORT CAPTION
            ReportDateCaption.Visible = true;
            ReportDateCaption.Text = string.Format(ReportDateCaption.Text, startOfMonth);
            //GET SUMMARIES
            AffiliateSalesGrid.Visible = true;
            AffiliateSalesGrid.DataBind();
        }

        protected string GetOrderTotal(object dataItem)
        {
            AffiliateSalesSummary summary = (AffiliateSalesSummary)dataItem;
            Affiliate affiliate = summary.Affiliate;
            if (affiliate.CommissionIsPercent)
            {
                if (affiliate.CommissionOnTotal) return summary.OrderTotal.LSCurrencyFormat("lc");
                return summary.ProductSubtotal.LSCurrencyFormat("lc");
            }
            return summary.OrderTotal.LSCurrencyFormat("lc");
        }

        protected void ExportButton_Click(Object sender, EventArgs e)
        {
            GenericExportManager<AffiliateSalesSummary> exportManager = GenericExportManager<AffiliateSalesSummary>.Instance;
            GenericExportOptions<AffiliateSalesSummary> options = new GenericExportOptions<AffiliateSalesSummary>();
            options.CsvFields = new string[] { "AffiliateName", "ReferralCount", "FormattedConversionRate", "OrderCount", "ProductSubtotal", "OrderTotal", "FormattedCommission" };

            DateTime fromDate = AlwaysConvert.ToDateTime(HiddenStartDate.Value);
            DateTime toDate = AlwaysConvert.ToDateTime(HiddenEndDate.Value);
            IList<AffiliateSalesSummary> reportData = ReportDataSource.GetSalesByAffiliate(fromDate, toDate, 0);

            options.ExportData = reportData;
            options.FileTag = string.Format("SALES_BY_AFFILIATE(from_{0}_to_{1})", fromDate.ToShortDateString(), toDate.ToShortDateString());
            exportManager.BeginExport(options);
        }
    }
}