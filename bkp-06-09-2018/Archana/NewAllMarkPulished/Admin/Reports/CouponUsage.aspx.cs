using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using System.Collections.Generic;
using CommerceBuilder.DataExchange;

namespace AbleCommerce.Admin.Reports
{
public partial class CouponUsage : CommerceBuilder.UI.AbleCommerceAdminPage
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
            StartDate.SelectedDate = new DateTime(localNow.Year, localNow.Month, 1);
            EndDate.SelectedDate = localNow;
            BindReport();
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        ExportButton.Visible = CouponSalesGrid.Rows.Count > 0;
    }

    protected void BindReport() 
    {
        HiddenStartDate.Value = StartDate.SelectedStartDate.ToString();
        HiddenEndDate.Value = EndDate.SelectedEndDate.ToString();
        CouponSalesGrid.DataBind();
    }

    protected void CouponSalesGrid_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (e.SortExpression != CouponSalesGrid.SortExpression) e.SortDirection = System.Web.UI.WebControls.SortDirection.Descending;
    }

    protected void ProcessButton_Click(Object sender, EventArgs e)
    {
        BindReport();
    }

    protected void ExportButton_Click(Object sender, EventArgs e)
    {
        DateTime fromDate = StartDate.SelectedStartDate;
        DateTime toDate = EndDate.SelectedEndDate;
        IList<CouponSummary> couponSummaries = ReportDataSource.GetSalesByCoupon(fromDate, toDate, string.Empty, "OrderTotal DESC");

        GenericExportManager<CouponSummary> exportManager = GenericExportManager<CouponSummary>.Instance;
        GenericExportOptions<CouponSummary> options = new GenericExportOptions<CouponSummary>();
        options.CsvFields = new string[]{"CouponCode", "OrderCount", "OrderTotal"};
        options.ExportData = couponSummaries;
        options.FileTag = string.Format("SALES_BY_COUPON(from:_{0}_to_{1})", fromDate.ToShortDateString(), toDate.ToShortDateString());
        exportManager.BeginExport(options);
    }

}
}
