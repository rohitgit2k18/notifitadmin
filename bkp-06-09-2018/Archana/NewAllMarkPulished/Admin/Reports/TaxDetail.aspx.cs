namespace AbleCommerce.Admin.Reports
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Common;

    public partial class TaxDetail : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private decimal _TaxesTotal = 0;
        private decimal _ProductsTotal = 0;
        private decimal _OrdersTotal = 0;

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
            // VALIDATE THE SPECIFIED TAX NAME
            string taxName = Request.QueryString["T"];
            string locCode = Request.QueryString["L"];
            string country = Request.QueryString["C"];
            string province = Request.QueryString["P"];
            int zoneId = AlwaysConvert.ToInt(Request.QueryString["Z"]);
            if (!TaxReportDataSource.IsTaxNameValid(taxName)) Response.Redirect("Taxes.aspx");
            HiddenTaxName.Value = taxName;
            HiddenLocCode.Value = locCode;

            if (!Page.IsPostBack)
            {
                // SET THE DEFAULT DATE FILTER
                DateTime localNow = LocaleHelper.LocalNow;
                StartDate.SelectedDate = AlwaysConvert.ToDateTime(Request.QueryString["StartDate"], new DateTime(localNow.Year, 1, 1));
                EndDate.SelectedDate = AlwaysConvert.ToDateTime(Request.QueryString["EndDate"], localNow);
                BindReport();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // update captions
            Caption.Text = string.Format(Caption.Text, GetSafeTaxName());
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

        private string GetSafeTaxName()
        {
            if (!string.IsNullOrEmpty(HiddenLocCode.Value))
            {
                return Server.HtmlEncode(HiddenTaxName.Value + " (" + HiddenLocCode.Value + ")");
            }
            else
            {
                return Server.HtmlEncode(HiddenTaxName.Value);
            }
        }

        protected void BindReport()
        {
            _TaxesTotal = 0;
            _ProductsTotal = 0;
            _OrdersTotal = 0;

            TaxesGrid.DataBind();
        }

        protected void TaxesGrid_DataBinding(object sender, EventArgs e)
        {
            _TaxesTotal = 0;
            _ProductsTotal = 0;
            _OrdersTotal = 0;
        }

        protected void TaxesGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label SubTotals = (Label)e.Row.FindControl("SubTotals");
                if (SubTotals != null)
                {
                    _TaxesTotal += (e.Row.DataItem as TaxReportDetailItem).TaxAmount;
                }

                Label OrderTotalCharges = (Label)e.Row.FindControl("OrderTotalCharges");
                if (OrderTotalCharges != null)
                {
                    _OrdersTotal += (e.Row.DataItem as TaxReportDetailItem).OrderTotalCharges;
                }

                Label ProductSubtotal = (Label)e.Row.FindControl("ProductSubtotal");
                if (ProductSubtotal != null)
                {
                    _ProductsTotal += (e.Row.DataItem as TaxReportDetailItem).ProductSubtotal;
                }
            }

            Label TaxTotals = (Label)e.Row.FindControl("TaxTotals");
            if (TaxTotals != null)
            {
                TaxTotals.Text = _TaxesTotal.LSCurrencyFormat("lc");
            }

            Label OrderTotals = (Label)e.Row.FindControl("OrderTotals");
            if (OrderTotals != null)
            {
                OrderTotals.Text = _OrdersTotal.LSCurrencyFormat("lc");
            }

            Label ProductTotals = (Label)e.Row.FindControl("ProductTotals");
            if (ProductTotals != null)
            {
                ProductTotals.Text = _ProductsTotal.LSCurrencyFormat("lc");
            }
        }

        protected string GetOrderLink(object dataItem)
        {
            TaxReportDetailItem detail = (TaxReportDetailItem)dataItem;
            return string.Format("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}", detail.OrderNumber);
        }

        protected void ProcessButton_Click(Object sender, EventArgs e)
        {
            BindReport();
        }
    }
}