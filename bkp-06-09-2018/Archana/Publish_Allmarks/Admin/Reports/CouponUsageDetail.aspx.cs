namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;

    public partial class CouponUsageDetail : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _CouponCount = -1;

        protected int CouponCount
        {
            get
            {
                if (_CouponCount < 0)
                {
                    _CouponCount = CouponDataSource.CountAll();
                }
                return _CouponCount;
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
                string tempDateFilter = Request.QueryString["DateFilter"];
                if (string.IsNullOrEmpty(tempDateFilter)) tempDateFilter = "THISMONTH";
                UpdateDateFilter(tempDateFilter);

                DateTime startDate = AlwaysConvert.ToDateTime(Request.QueryString["StartDate"], DateTime.MinValue);
                DateTime endDate = AlwaysConvert.ToDateTime(Request.QueryString["EndDate"], DateTime.MaxValue);
                if (startDate != DateTime.MinValue)
                    StartDate.SelectedDate = startDate;
                if (endDate != DateTime.MaxValue)
                    EndDate.SelectedDate = endDate;

                //BIND THE COUPON LIST
                CouponList.DataSource = OrderDataSource.GetCouponCodes();
                CouponList.DataBind();
                //INITIALIZE COUPON LIST
                string couponCode = Request.QueryString["CouponCode"];
                ListItem listItem = CouponList.Items.FindByValue(couponCode);
                if (listItem != null) CouponList.SelectedIndex = CouponList.Items.IndexOf(listItem);
                //GENERATE REPORT ON FIRST VISIT
                ReportButton_Click(sender, e);
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // update captions
            DateTime fromDate = StartDate.SelectedStartDate;
            DateTime toDate = EndDate.SelectedEndDate;
            if (fromDate > DateTime.MinValue)
            {
                FromCaption.Text = string.Format(FromCaption.Text, fromDate.ToShortDateString());
            }
            else
            {
                FromCaption.Visible = false;
            }
            if (toDate > DateTime.MinValue)
            {
                ToCaption.Text = string.Format(ToCaption.Text, toDate.ToShortDateString());
            }
            else
            {
                ToCaption.Text = string.Format(ToCaption.Text, "present");
            }
        }

        private void UpdateDateFilter(string filter)
        {
            DateTime startDate, endDate;
            AbleCommerce.Code.StoreDataHelper.SetDateFilter(filter, out startDate, out endDate);
            StartDate.SelectedDate = startDate;
            EndDate.SelectedDate = endDate;
        }

        protected void DateFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateDateFilter(DateFilter.SelectedValue);
            DateFilter.SelectedIndex = 0;
        }

        protected void ReportButton_Click(object sender, EventArgs e)
        {
            CouponSalesRepeater.Visible = true;
            CouponSalesRepeater.DataBind();
        }

        protected IList<Order> GetCouponOrders(object dataItem)
        {
            CouponSummary summary = (CouponSummary)dataItem;
            return OrderDataSource.LoadForCouponCode(summary.CouponCode, summary.StartDate, summary.EndDate, "O.Id ASC");
        }
    }
}