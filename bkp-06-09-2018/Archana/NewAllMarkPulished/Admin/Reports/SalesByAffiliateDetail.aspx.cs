namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;
    using CommerceBuilder.Services;

    public partial class SalesByAffiliateDetail : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _AffiliateCount = -1;

        protected int AffiliateCount
        {
            get
            {
                if (_AffiliateCount < 0)
                {
                    _AffiliateCount = AffiliateDataSource.CountAll();
                }
                return _AffiliateCount;
            }
        }

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
                //BIND THE AFFILAITE LIST
                AffiliateList.DataSource = AffiliateDataSource.LoadAll("Name");
                AffiliateList.DataBind();
                //INITIALIZE AFFILIATE LIST
                int affiliateId = AlwaysConvert.ToInt(Request.QueryString["AffiliateId"]);
                ListItem listItem = AffiliateList.Items.FindByValue(affiliateId.ToString());
                if (listItem != null) AffiliateList.SelectedIndex = AffiliateList.Items.IndexOf(listItem);
                //UPDATE DATE FILTER AND GENERATE REPORT
                UpdateDateFilter();
            }
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
            HiddenStartDate.Value = startOfMonth.ToString();
            HiddenEndDate.Value = endOfMonth.ToString();
            //UPDATE REPORT CAPTION
            ReportDateCaption.Visible = true;
            ReportDateCaption.Text = string.Format(ReportDateCaption.Text, startOfMonth);
            //GET SUMMARIES
            AffiliateSalesRepeater.Visible = true;
            AffiliateSalesRepeater.DataBind();
        }

        protected string GetCommissionRate(object dataItem)
        {
            AffiliateSalesSummary summary = (AffiliateSalesSummary)dataItem;
            Affiliate affiliate = summary.Affiliate;
            if (affiliate.CommissionIsPercent)
            {
                string format = "{0:0.##}% of {1}";
                if (affiliate.CommissionOnTotal) return string.Format(format, affiliate.CommissionRate, summary.OrderTotal.LSCurrencyFormat("lc"));
                return string.Format(format, affiliate.CommissionRate, summary.ProductSubtotal.LSCurrencyFormat("lc"));
            }
            return string.Format("{0} x {1}", summary.OrderCount, affiliate.CommissionRate.LSCurrencyFormat("lc"));
        }

        protected string GetConversionRate(object dataItem)
        {
            AffiliateSalesSummary summary = (AffiliateSalesSummary)dataItem;
            if (summary.ReferralCount == 0) return "-";
            return string.Format("{0:0.##}%", summary.ConversionRate);
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

        protected IList<Order> GetAffiliateOrders(object dataItem)
        {
            AffiliateSalesSummary summary = (AffiliateSalesSummary)dataItem;
            return OrderDataSource.LoadForAffiliate(summary.AffiliateId, summary.StartDate, summary.EndDate, "OrderId ASC");
        }

        protected decimal GetCommissionForOrder(object dataItem)
        {
            decimal commissionTotal = 0;
            Order order = dataItem as Order;
            Affiliate affilate = order.Affiliate;
            decimal productSubtotal = order.Items.TotalPrice(OrderItemType.Product);

            if(affilate != null) commissionTotal = AbleContext.Resolve<IAffiliateCalculator>().CalculateCommission(affilate, 1, productSubtotal, order.TotalCharges);

            return commissionTotal;
        }
    }
}