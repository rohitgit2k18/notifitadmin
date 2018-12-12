namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DataExchange;
    using CommerceBuilder.Common;

    public partial class ProductBreakdown : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        public long TotalQuantity { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal CostOfGoods { get; set; }
        public decimal CouponsTotal { get; set; }
        public decimal DiscountsTotal { get; set; }

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
                UpdateVendorList(VendorList);
                DateTime localNow = LocaleHelper.LocalNow;
                DateTime startDate = AlwaysConvert.ToDateTime(Request.QueryString["StartDate"], new DateTime(localNow.Year, localNow.Month, 1));
                DateTime endDate = AlwaysConvert.ToDateTime(Request.QueryString["EndDate"], localNow);
                StartDate.SelectedDate = startDate;
                EndDate.SelectedDate = endDate;
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

            ExportButton.Visible = ProductBreakdownGrid.Rows.Count > 0;
        }

        private void UpdateVendorList(DropDownList VendorListCtrl)
        {
            IList<Vendor> vendors = VendorDataSource.LoadAll();
            VendorListCtrl.Items.Add(new ListItem("ANY", "0"));
            foreach (Vendor vendor in vendors)
            {
                VendorListCtrl.Items.Add(new ListItem(vendor.Name, vendor.Id.ToString()));
            }
            VendorListCtrl.SelectedIndex = 0;
            VendorListCtrl.DataBind();
        }

        protected void ProcessButton_Click(object sender, EventArgs e)
        {
            ProductBreakdownGrid.DataSourceID = "ProductBreakdownDS";
            ProductBreakdownGrid.DataBind();
        }

        protected void ExportButton_Click(Object sender, EventArgs e)
        {
            GenericExportManager<ProductBreakdownSummary> exportManager = GenericExportManager<ProductBreakdownSummary>.Instance;
            GenericExportOptions<ProductBreakdownSummary> options = new GenericExportOptions<ProductBreakdownSummary>();
            options.CsvFields = new string[] {"Name", "Sku", "Vendor", "Quantity", "CostOfGoods", "Amount"};

            DateTime fromDate = StartDate.SelectedStartDate;
            DateTime toDate = EndDate.SelectedEndDate;
            IList<ProductBreakdownSummary> reportData = ReportDataSource.GetProductBreakdownSummary(fromDate, toDate, AlwaysConvert.ToInt(VendorList.SelectedValue), "Amount DESC");

            options.ExportData = reportData;
            options.FileTag = string.Format("SALES_BY_PRODUCT(from_{0}_to_{1})", fromDate.ToShortDateString(), toDate.ToShortDateString());
            exportManager.BeginExport(options);
        }

        protected void ProductBreakdownDS_Selected(object sender, ObjectDataSourceStatusEventArgs e)
        {
            IList<ProductBreakdownSummary> breakdownReport = (IList<ProductBreakdownSummary>)e.ReturnValue;
            if (breakdownReport != null && breakdownReport.Count > 0)
            {
                this.TotalAmount = breakdownReport.Sum(x => x.Amount);
                this.TotalQuantity = breakdownReport.Sum(x => (long)x.Quantity);
                this.CostOfGoods = breakdownReport.Sum(x => x.CostOfGoods);
                this.CouponsTotal = breakdownReport.Sum(x => x.Coupons);
                this.DiscountsTotal = breakdownReport.Sum(x => x.Discounts);
            }
            else
            {
                this.TotalAmount = 0;
                this.TotalQuantity = 0;
                this.CostOfGoods = 0;
            }            
        }
    }
}