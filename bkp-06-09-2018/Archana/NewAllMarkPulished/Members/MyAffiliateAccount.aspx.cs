using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Extensions;
using CommerceBuilder.Marketing;
using CommerceBuilder.Orders;
using CommerceBuilder.Reporting;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce.Members
{
    public partial class MyAffiliateAccount : CommerceBuilder.UI.AbleCommercePage
    {
        IList<Affiliate> _AffiliateAccounts;
        Affiliate _Affiliate;
        protected void Page_Load(object sender, EventArgs e)
        {
            _AffiliateAccounts = UserDataSource.LoadUserAffiliateAccounts(AbleContext.Current.User.Id);

            //IF SELEF SIGNUP IS NOT ALLOWED AND AFFILIATE IS NOT REGISTERED THEN NO ACCESS TO THIS PAGE
            if (!AbleContext.Current.Store.Settings.AffiliateAllowSelfSignup && _AffiliateAccounts.Count == 0)
                Response.Redirect("MyAccount.aspx");

            //IF NO EXISTING AFFILIATE ACCOUNT THEN ENABLE SIGNUP
            if (_AffiliateAccounts.Count == 0)
            {
                AffiliateForm1.Visible = true;
                AffiliateInfoPanel.Visible = false;
            }
            //IF HAVE REGISTED AFFILIATE ACCOUNTS THEN SHOW THEM IN DROPDOWN
            else
            {

                AffiliateForm1.Visible = false;
                AffiliateInfoPanel.Visible = true;
                trAffiliateReport.Visible = true;

                int affiliateId = 0;
                if (!Page.IsPostBack && _AffiliateAccounts.Count > 1)
                {
                    AffiliateAccountList.DataSource = _AffiliateAccounts;
                    AffiliateAccountList.DataBind();
                    trMultiAccounts.Visible = true;
                }
                else
                    if (!Page.IsPostBack && _AffiliateAccounts.Count == 1)
                    {
                        _Affiliate = _AffiliateAccounts[0];
                        trMultiAccounts.Visible = false;
                    }
                if (_AffiliateAccounts.Count > 1)
                {
                    affiliateId = AlwaysConvert.ToInt(AffiliateAccountList.SelectedValue);
                    _Affiliate = AffiliateDataSource.Load(affiliateId);
                }
                else
                    if (_AffiliateAccounts.Count == 1)
                        _Affiliate = _AffiliateAccounts[0];

                if (!Page.IsPostBack && _Affiliate != null)
                {
                    BindAffiliateReport();
                }
                HiddenAffiliateId.Value = _Affiliate.Id.ToString();
            }
        }

        private string GetHomeUrl()
        {
            return string.Format("http://{0}{1}", Request.Url.Authority, this.ResolveUrl(AbleCommerce.Code.NavigationHelper.GetHomeUrl()));
        }

        protected void BindAffiliateReport()
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
            //UPDATE DATE FILTER AND GENERATE REPORT
            UpdateDateFilter();
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
            Caption.Text = string.Format(Caption.Text, _Affiliate.Name, startOfMonth);
            ReportTimestamp.Text = string.Format(ReportTimestamp.Text, LocaleHelper.LocalNow);
            //GET SUMMARIES
            AffiliateSalesRepeater.Visible = true;
            AffiliateSalesRepeater.DataBind();
            ShowAffiliateDetails();
        }

        protected string GetCommissionRate(object dataItem)
        {
            AffiliateSalesSummary summary = (AffiliateSalesSummary)dataItem;
            Affiliate affiliate = summary.Affiliate;
            if (affiliate.CommissionIsPercent)
            {
                string format = "{0:0.##}% of {1}";
                if (affiliate.CommissionOnTotal) return string.Format(format, affiliate.CommissionRate, summary.OrderTotal.LSCurrencyFormat("ulc"));
                return string.Format(format, affiliate.CommissionRate, summary.ProductSubtotal.LSCurrencyFormat("ulc"));
            }
            return string.Format("{0} x {1}", summary.OrderCount, affiliate.CommissionRate.LSCurrencyFormat("ulc"));
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

        protected void ShowAffiliateDetails()
        {
            InstructionText.Text = string.Format(InstructionText.Text, _Affiliate.Id, GetHomeUrl(), AbleContext.Current.Store.Settings.AffiliateParameterName);
            EditAffiliateLink.NavigateUrl = string.Format(EditAffiliateLink.NavigateUrl, _Affiliate.Id);
        }
        protected void AffiliateAccountList_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowAffiliateDetails();
            GenerateReport();
        }
    }
}