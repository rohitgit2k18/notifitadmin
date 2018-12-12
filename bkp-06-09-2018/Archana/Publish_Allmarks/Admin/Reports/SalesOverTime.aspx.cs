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
using System.Web.UI.DataVisualization.Charting;
using CommerceBuilder.DataExchange;

namespace AbleCommerce.Admin.Reports
{
public partial class SalesOverTime : CommerceBuilder.UI.AbleCommerceAdminPage
{

    //CONTAINS THE REPORT
    IList<SalesSummary> _MonthlySales;
    //TRACKS TOTALS FOR FOOTER
    bool _TotalsCalculated;
    int _OrderCount;
    decimal _ProductTotal;
    decimal _ShippingTotal;
    decimal _TaxTotal;
    decimal _DiscountTotal;
    decimal _CouponTotal;
    decimal _GiftWrapTotal;
    decimal _OtherTotal;
    decimal _GrandTotal;
    decimal _ProfitTotal;
    decimal _CostTotal;

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

    protected void UpdateDateControls()
    {
        DateTime localNow = LocaleHelper.LocalNow;
        StartDate.SelectedDate = new DateTime(localNow.Year, localNow.Month, 1);
        EndDate.SelectedDate = new DateTime(localNow.Year, localNow.Month, DateTime.DaysInMonth(localNow.Year, localNow.Month));
        BindReport();
    }

    protected void BindReport()
    {
        //GET THE REPORT DATE
        DateTime fromDate = StartDate.SelectedStartDate;
        DateTime toDate = EndDate.SelectedEndDate;
        //RESET THE TOTALS
        _TotalsCalculated = false;

        //GET SUMMARIES
        _MonthlySales = ReportDataSource.GetMonthlySales(fromDate, toDate);

        //UPDATE CHART
        UpdateChart();

        // FILTER OUT RESULTS FOR GRID DISPLAY
        for (int i = (_MonthlySales.Count - 1); i >= 0; i--)
        {
            if (_MonthlySales[i].OrderCount == 0) _MonthlySales.RemoveAt(i);
        }
        MonthlySalesGrid.DataSource = _MonthlySales;
        MonthlySalesGrid.DataBind();        
    }

    protected void ProcessButton_Click(object sender, EventArgs e)
    {
        BindReport();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.AppendHeader("pragma", "no-store,no-cache");
        Response.AppendHeader("cache-control", "no-cache, no-store,must-revalidate, max-age=-1");
        Response.AppendHeader("expires", "-1");
        if (!Page.IsPostBack)
        {
            UpdateDateControls();
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        ExportButton.Visible = MonthlySalesGrid.Rows.Count > 0;
    }

    protected void UpdateChart()
    {
        //BUILD BAR CHART
        SalesChart.Series["Sales"].Points.Clear();
        for (int i = 0; i < _MonthlySales.Count; i++)
        {
            DataPoint point = new DataPoint(SalesChart.Series["Sales"]);
            point.SetValueXY(((int)(i + 1)).ToString(), new object[] { (float)((decimal)_MonthlySales[i].GrandTotal) });
            SalesChart.Series["Sales"].Points.Add(point);
        }
        SalesChart.DataBind();
    }

    protected string GetTotal(string itemType)
    {
        if (!_TotalsCalculated)
        {
            _OrderCount = 0;
            _ProductTotal = 0;
            _ShippingTotal = 0;
            _TaxTotal = 0;
            _DiscountTotal = 0;
            _CouponTotal = 0;
            _OtherTotal = 0;
            _ProfitTotal = 0;
            _GiftWrapTotal = 0;
            _GrandTotal = 0;
            _CostTotal = 0;

            foreach (SalesSummary ss in _MonthlySales)
            {
                _OrderCount += ss.OrderCount;
                _ProductTotal += ss.ProductTotal;
                _ShippingTotal += ss.ShippingTotal;
                _TaxTotal += ss.TaxTotal;
                _DiscountTotal += ss.DiscountTotal;
                _CouponTotal += ss.CouponTotal;
                _OtherTotal += ss.OtherTotal;
                _ProfitTotal += ss.ProfitTotal;
                _GiftWrapTotal += ss.GiftWrapTotal;
                _CostTotal += ss.CostOfGoodTotal;
                _GrandTotal += ss.GrandTotal;
            }
            _TotalsCalculated = true;
        }
        switch (itemType.ToLowerInvariant())
        {
            case "count": return _OrderCount.ToString();
            case "product": return _ProductTotal.LSCurrencyFormat("lc");
            case "shipping": return _ShippingTotal.LSCurrencyFormat("lc");
            case "tax": return _TaxTotal.LSCurrencyFormat("lc");
            case "discount": return _DiscountTotal.LSCurrencyFormat("lc");
            case "coupon": return _CouponTotal.LSCurrencyFormat("lc");
            case "giftwrap": return _GiftWrapTotal.LSCurrencyFormat("lc");
            case "other": return _OtherTotal.LSCurrencyFormat("lc");
            case "grand": return _GrandTotal.LSCurrencyFormat("lc");
            case "profit": return _ProfitTotal.LSCurrencyFormat("lc");
            case "cost": return _CostTotal.LSCurrencyFormat("lc");
        }
        return itemType;
    }

    protected void ExportButton_Click(Object sender, EventArgs e)
    {
        GenericExportManager<SalesSummary> exportManager = GenericExportManager<SalesSummary>.Instance;
        GenericExportOptions<SalesSummary> options = new GenericExportOptions<SalesSummary>();
        options.CsvFields = new string[] { "StartDate", "OrderCount", "ProductTotal", "CostOfGoodTotal", "ShippingTotal", "TaxTotal", "DiscountTotal", "CouponTotal", "GiftWrapTotal", "OtherTotal", "ProfitTotal", "GrandTotal" };

        DateTime fromDate = StartDate.SelectedStartDate;
        DateTime toDate = EndDate.SelectedEndDate;
        if (_MonthlySales == null)
        {   
            _MonthlySales = ReportDataSource.GetMonthlySales(fromDate, toDate);

            // FILTER OUT RESULTS FOR GRID DISPLAY
            for (int i = (_MonthlySales.Count - 1); i >= 0; i--)
            {
                if (_MonthlySales[i].OrderCount == 0) _MonthlySales.RemoveAt(i);
            }
        }

        options.ExportData = _MonthlySales;
        options.FileTag = string.Format("SALES_OVER_TIME(from_{0}_to_{1})", fromDate.ToShortDateString(), toDate.ToShortDateString());
        exportManager.BeginExport(options);
    }
}
}
