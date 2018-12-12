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
using CommerceBuilder.DataExchange;
using CommerceBuilder.Types;
using System.Collections.Generic;

namespace AbleCommerce.Admin.Reports
{
    public partial class PopularCategories : CommerceBuilder.UI.AbleCommerceAdminPage
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
            ExportByViewsButton.Visible = PopularCategoriesGrid.Rows.Count > 0;
        }

        protected void ExportByViewsButton_Click(Object sender, EventArgs e)
        {
            GenericExportManager<CategoryViewSummary> exportManager = GenericExportManager<CategoryViewSummary>.Instance;
            GenericExportOptions<CategoryViewSummary> options = new GenericExportOptions<CategoryViewSummary>();
            options.CsvFields = new string[] { "CategoryName", "Views" };

            SortableCollection<KeyValuePair<ICatalogable, int>> categoryViews = PageViewDataSource.GetViewsByCategory("ViewCount DESC");

            // CONVERT TO SUMMARY LIST TO GENERATE CSV
            IList<CategoryViewSummary> viewsSummay = new List<CategoryViewSummary>();
            foreach (KeyValuePair<ICatalogable, int> dataRow in categoryViews) viewsSummay.Add(new CategoryViewSummary(dataRow.Key.Name, dataRow.Value));

            options.ExportData = viewsSummay;
            options.FileTag = "POPULAR_CATEGORIES_BY_VIEWS";
            exportManager.BeginExport(options);
        }


        private class CategoryViewSummary
        {
            public string CategoryName { get; set; }
            public int Views { get; set; }

            public CategoryViewSummary(string categoryName, int views)
            {
                this.CategoryName = categoryName;
                this.Views = views;
            }
        }
    }
}
