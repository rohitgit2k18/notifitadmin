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
using CommerceBuilder.Extensions;
using CommerceBuilder.DataExchange;

namespace AbleCommerce.Admin.Reports
{
public partial class DailySales : CommerceBuilder.UI.AbleCommerceAdminPage
{

    //CONTAINS THE REPORT
    IList<CommerceBuilder.Reporting.OrderSummary> _DailySales;
    //TRACKS TOTALS FOR FOOTER
    bool _TotalsCalculated;
    decimal _ProductTotal;
    decimal _ShippingTotal;
    decimal _TaxTotal;
    decimal _DiscountTotal;
    decimal _CouponTotal;
    decimal _OtherTotal;
    decimal _GrandTotal;
    decimal _ProfitTotal;
    decimal _CostTotal;
    
    protected void BindReport()
    {
        //GET THE REPORT DATE
        DateTime reportDate = (DateTime)ViewState["ReportDate"];
        //UPDATE REPORT CAPTION
        ReportCaption.Visible = true;
        ReportCaption.Text = string.Format(ReportCaption.Text, reportDate);
        //RESET THE TOTALS
        _TotalsCalculated = false;
        //GET NEW DATA
        _DailySales = ReportDataSource.GetDailySales(reportDate);
        //BIND GRID
        DailySalesGrid.DataSource = _DailySales;
        DailySalesGrid.DataBind();
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
            DateTime tempDate = AlwaysConvert.ToDateTime(Request.QueryString["Date"], System.DateTime.MinValue);
            if (tempDate == System.DateTime.MinValue) tempDate = LocaleHelper.LocalNow;
            ViewState["ReportDate"] = tempDate;
            ReportDate.SelectedDate = tempDate;
            BindReport();
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        ExportButton.Visible = DailySalesGrid.Rows.Count > 0;
    }

    protected void ProcessButton_Click(Object sender, EventArgs e)
    {
        DateTime newReportDate = ReportDate.SelectedDate;
        ViewState["ReportDate"] = newReportDate;
        BindReport();
    }

    protected string GetTotal(string itemType)
    {
        if (!_TotalsCalculated)
        {
            _ProductTotal = 0;
            _ShippingTotal = 0;
            _TaxTotal = 0;
            _DiscountTotal = 0;
            _CouponTotal = 0;
            _OtherTotal = 0;
            _ProfitTotal = 0;
            _GrandTotal = 0;
            _CostTotal = 0;
            foreach (CommerceBuilder.Reporting.OrderSummary os in _DailySales)
            {
                _ProductTotal += os.ProductTotal;
                _ShippingTotal += os.ShippingTotal;
                _TaxTotal += os.TaxTotal;
                _DiscountTotal += os.DiscountTotal;
                _CouponTotal += os.CouponTotal;
                _OtherTotal += os.OtherTotal;
                _ProfitTotal += os.ProfitTotal;
                _CostTotal += os.CostOfGoodTotal;
                _GrandTotal += os.GrandTotal;
            }
            _TotalsCalculated = true;
        }
        switch (itemType.ToLowerInvariant())
        {
            case "product": return _ProductTotal.LSCurrencyFormat("lc");
            case "shipping": return _ShippingTotal.LSCurrencyFormat("lc");
            case "tax": return _TaxTotal.LSCurrencyFormat("lc");
            case "discount": return _DiscountTotal.LSCurrencyFormat("lc");
            case "coupon": return _CouponTotal.LSCurrencyFormat("lc");
            case "other": return _OtherTotal.LSCurrencyFormat("lc");
            case "grand": return _GrandTotal.LSCurrencyFormat("lc");
            case "profit": return _ProfitTotal.LSCurrencyFormat("lc");
            case "cost": return _CostTotal.LSCurrencyFormat("lc");
        }
        return itemType;
    }

    protected void ExportButton_Click(Object sender, EventArgs e)
    {
        GenericExportManager<CommerceBuilder.Reporting.OrderSummary> exportManager = GenericExportManager<CommerceBuilder.Reporting.OrderSummary>.Instance;
        GenericExportOptions<CommerceBuilder.Reporting.OrderSummary> options = new GenericExportOptions<CommerceBuilder.Reporting.OrderSummary>();
        options.CsvFields = new string[] { "OrderNumber", "ProductTotal", "CostOfGoodTotal", "ShippingTotal", "TaxTotal", "DiscountTotal", "CouponTotal", "OtherTotal", "ProfitTotal", "GrandTotal" };

        DateTime reportDate = (DateTime)ViewState["ReportDate"];
        if (_DailySales == null)
        {   
            _DailySales = ReportDataSource.GetDailySales(reportDate);
        }

        options.ExportData = _DailySales;
        options.FileTag = string.Format("DAILY_SALES({0})", reportDate.ToShortDateString());
        exportManager.BeginExport(options);
    }
}
}
