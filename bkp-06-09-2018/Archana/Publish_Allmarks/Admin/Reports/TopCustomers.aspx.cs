namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Reporting;
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    public partial class TopCustomers : CommerceBuilder.UI.AbleCommerceAdminPage
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
                DateTime startDate = AlwaysConvert.ToDateTime(Request.QueryString["StartDate"], new DateTime(localNow.Year, localNow.Month, 1));
                DateTime endDate = AlwaysConvert.ToDateTime(Request.QueryString["EndDate"], localNow);
                StartDate.SelectedDate = startDate;
                EndDate.SelectedDate = endDate;
                BindReport();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ExportButton.Visible = TopCustomerGrid.Rows.Count > 0;
        }

        protected void BindReport()
        {
            HiddenStartDate.Value = StartDate.SelectedStartDate.ToString();
            HiddenEndDate.Value = EndDate.SelectedEndDate.ToString();
            TopCustomerGrid.DataBind();
        }

        protected void TopCustomerGrid_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (e.SortExpression != TopCustomerGrid.SortExpression) e.SortDirection = System.Web.UI.WebControls.SortDirection.Descending;
        }

        protected void ProcessButton_Click(Object sender, EventArgs e)
        {
            BindReport();
        }

        protected void ExportButton_Click(Object sender, EventArgs e)
        {
            CommerceBuilder.DataExchange.GenericExportManager<UserSummary> exportManager = CommerceBuilder.DataExchange.GenericExportManager<UserSummary>.Instance;
            CommerceBuilder.DataExchange.GenericExportOptions<UserSummary> options = new CommerceBuilder.DataExchange.GenericExportOptions<UserSummary>();
            options.CsvFields = new string[] { "UserName", "OrderCount", "OrderTotal" };

            DateTime fromDate = StartDate.SelectedStartDate;
            DateTime toDate = EndDate.SelectedEndDate;
            IList<UserSummary> reportData = ReportDataSource.GetSalesByUser(fromDate, toDate, "OrderTotal DESC");

            options.ExportData = reportData;
            options.FileTag = string.Format("SALES_BY_CUSTOMERS(from_{0}_to_{1})", fromDate.ToShortDateString(), toDate.ToShortDateString());
            exportManager.BeginExport(options);
        }
    }
}