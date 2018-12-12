namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.DataExchange;
    using System.Collections.Generic;

    public partial class Taxes : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private decimal _TaxesTotal = 0;

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
            ExportButton.Visible = TaxesGrid.Rows.Count > 0;
            Comments.Visible = ExportButton.Visible;
        }

        protected void ProcessButton_Click(Object sender, EventArgs e)
        {
            BindReport();
        }

        protected void BindReport()
        {
            HiddenStartDate.Value = StartDate.SelectedStartDate.ToString();
            HiddenEndDate.Value = EndDate.SelectedEndDate.ToString();
            _TaxesTotal = 0;
            TaxesGrid.DataBind();
        }

        protected void TaxesGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label SubTotals = (Label)e.Row.FindControl("SubTotals");
                if (SubTotals != null)
                {
                    _TaxesTotal += (e.Row.DataItem as TaxReportSummaryItem).TaxAmount;
                }
            }

            Label Totals = (Label)e.Row.FindControl("Totals");
            if (Totals != null)
            {
                Totals.Text = _TaxesTotal.LSCurrencyFormat("lc");
            }
        }

        protected void TaxesGrid_DataBinding(object sender, EventArgs e)
        {
            _TaxesTotal = 0;
        }   

        protected void TaxesGrid_PreRender(object sender, EventArgs e)
        {
            bool locCodeSpecified = false;
            foreach (GridViewRow row in TaxesGrid.Rows)
            {
                Label LocCodeLabel = (Label)row.FindControl("LocCode");
                if (LocCodeLabel != null && !String.IsNullOrEmpty(LocCodeLabel.Text))
                {
                    locCodeSpecified = true;
                }
            }
            TaxesGrid.Columns[1].Visible = locCodeSpecified;
        }

        protected string GetTaxLink(object dataItem)
        {
            TaxReportSummaryItem summary = (TaxReportSummaryItem)dataItem;
            string province = Province.Text;
            if(!Province.Visible) province = Province2.SelectedValue;
            return string.Format("TaxDetail.aspx?T={0}&L={1}&StartDate={2}&EndDate={3}&C={4}&P={5}&Z={6}", summary.TaxName, summary.LocCode, StartDate.SelectedDate.ToShortDateString(), EndDate.SelectedDate.ToShortDateString(), CountryFilter.SelectedValue, province, ZoneFilter.SelectedValue);
        }

        protected void CountryChanged(object sender, EventArgs e)
        {
            //LOAD PROVINCES FOR SELECTED COUNTRY
            int provincesCount = ProvinceDataSource.CountForCountry(CountryFilter.SelectedValue);
            //WE WANT TO SHOW THE DROP DOWN IF THE COUNTRY HAS BEEN CHANGED BY THE CLIENT
            //AND ALSO IF PROVINCES ARE AVAILABLE FOR THIS COUNTRY
            if (provincesCount > 0)
            {
                Province.Visible = false;
                Province2.Visible = true;
                Country county = CountryDataSource.Load(CountryFilter.SelectedValue);
                if (county != null)
                {
                    Province2.Items.Clear();
                    Province2.Items.Add(new ListItem("All Provinces",""));
                    Province2.DataSource = county.Provinces;
                    Province2.DataBind();
                }
            }
            else
            {
                //WE ONLY WANT A TEXTBOX TO SHOW
                //REQUIRE THE TEXTBOX IF THERE ARE PROVINCES
                Province.Visible = true;
                Province2.Visible = false;
            }
        }

        protected void TaxesDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["province"] = Province2.Visible ? Province2.SelectedValue : Province.Text.Trim();
        }

        protected void ZoneDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["storeId"] = AbleContext.Current.StoreId.ToString();
        }

        protected void OnCountryDataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string warehouseCountry = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                ListItem defaultCountry = CountryFilter.Items.FindByValue(warehouseCountry);
                if (defaultCountry != null) CountryFilter.SelectedIndex = CountryFilter.Items.IndexOf(defaultCountry);
            }

            Country county = CountryDataSource.Load(CountryFilter.SelectedValue);
            if (county != null)
            {
                Province2.Visible = county.Provinces.Count > 0;
                if (Province2.Visible)
                {
					Province2.Items.Clear();
                    Province2.Items.Add(new ListItem("All Provinces",""));
                    Province2.DataSource = county.Provinces;
                    Province2.DataBind();
                }

                Province.Visible = !Province2.Visible;

            }

            if (!Page.IsPostBack)
            {
                string warehouseProvince = AbleContext.Current.Store.DefaultWarehouse.Province;
                if (county.Provinces.Count > 0)
                {
                    ListItem defaultProvince = Province2.Items.FindByValue(warehouseProvince);
                    if (defaultProvince != null) Province2.SelectedIndex = Province2.Items.IndexOf(defaultProvince);
                }
                else Province.Text = warehouseProvince;
            }
        }

        protected void ExportButton_Click(Object sender, EventArgs e)
        {
            GenericExportManager<TaxReportSummaryItem> exportManager = GenericExportManager<TaxReportSummaryItem>.Instance;
            GenericExportOptions<TaxReportSummaryItem> options = new GenericExportOptions<TaxReportSummaryItem>();
            options.CsvFields = new string[] { "TaxName", "LocCode", "TaxAmount"};

            DateTime fromDate = StartDate.SelectedStartDate;
            DateTime toDate = EndDate.SelectedEndDate;
            string provinceCode = Province2.Visible ? Province2.SelectedValue : Province.Text.Trim();
            IList<TaxReportSummaryItem> taxes = TaxReportDataSource.LoadSummaries(CountryFilter.SelectedValue, provinceCode, AlwaysConvert.ToInt(ZoneFilter.SelectedValue), fromDate, toDate, "TaxName ASC");

            options.ExportData = taxes;
            options.FileTag = string.Format("TAX_REPORT(from_{0}_to_{1})", fromDate.ToShortDateString(), toDate.ToShortDateString());
            exportManager.BeginExport(options);
        }
    }
}