using System;
using System.Collections;
using CommerceBuilder.DataExchange;
using CommerceBuilder.Reporting;
using System.Collections.Generic;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Reports
{
    public partial class SearchHistory : CommerceBuilder.UI.AbleCommerceAdminPage
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

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ExportButton.Visible = SearchHistoryGrid.Rows.Count > 0;
        }

        protected void ExportButton_Click(Object sender, EventArgs e)
        {
            GenericExportManager<SearchTermsSummary> exportManager = GenericExportManager<SearchTermsSummary>.Instance;
            GenericExportOptions<SearchTermsSummary> options = new GenericExportOptions<SearchTermsSummary>();
            options.CsvFields = new string[] { "SearchTerm", "TotalCount"};

            IList<SearchTermsSummary> reportData = ReportDataSource.LoadSearchTermsSummary("TotalCount DESC");

            options.ExportData = reportData;
            options.FileTag = "Customer_Search_History";
            exportManager.BeginExport(options);
        }
    }
}
