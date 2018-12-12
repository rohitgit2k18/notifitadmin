using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using System.Linq;

namespace AbleCommerce.Admin.Dashboard
{
    public partial class OrderSummary : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime localNow = LocaleHelper.LocalNow;
            DateTime todayStart = new DateTime(localNow.Year, localNow.Month, localNow.Day, 0, 0, 0);
            BindOrderSummaryGrid(todayStart);
        }

        private void BindOrderSummaryGrid(DateTime lastDayStart)
        {
            OrderSummaryGrid.DataSource = OrderDataSource.LoadOrderStatusSummaries(lastDayStart);
            OrderSummaryGrid.DataBind();
        }

        protected void DateRageList_SelectedIndexChanged(object sender, EventArgs e)
        {
            DateTime localNow = LocaleHelper.LocalNow;
            int days = AlwaysConvert.ToInt(DateRageList.SelectedValue);
            DateTime lastDayStart = LocaleHelper.FromLocalTime(localNow.AddDays(-1 * days));
            lastDayStart = new DateTime(lastDayStart.Year, lastDayStart.Month, lastDayStart.Day, 0, 0, 0);
            BindOrderSummaryGrid(lastDayStart);
        }

        protected int GetSelectedDateFilter()
        {
            int selectedRange = AlwaysConvert.ToInt(DateRageList.SelectedValue);
            switch (selectedRange)
            {
                case 0:
                    return 1;
                case 7:
                    return 2;
                case 14:
                    return 3;
                case 30:
                    return 5;
                case 60:
                    return 6;
                case 90:
                    return 7;
                case 120:
                    return 8;
                default:
                    return 1;
            }
        }
    }
}