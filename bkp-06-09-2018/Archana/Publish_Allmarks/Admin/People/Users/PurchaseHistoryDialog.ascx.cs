namespace AbleCommerce.Admin.People.Users
{
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
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using System.Collections.Generic;
    using CommerceBuilder.Extensions;

    public partial class PurchaseHistoryDialog : System.Web.UI.UserControl
    {
        private int _UserId;
        protected void Page_Load(object sender, EventArgs e)
        {
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
            List<PurchaseSummary> paidItems = (List<PurchaseSummary>)PaidOrdersDs.Select();
            paidItems.Sort(new PurchaseSummaryComparer(SortDirection.Ascending));

            List<PurchaseSummary> unpaidItems = (List<PurchaseSummary>)UnpaidOrdersDs.Select();
            unpaidItems.Sort(new PurchaseSummaryComparer(SortDirection.Ascending));

            DateTime firstOrderDate = DateTime.MinValue;
            if (paidItems.Count > 0)
                firstOrderDate = paidItems[0].OrderDate;
            if (unpaidItems.Count > 0)
            {
                if (firstOrderDate == DateTime.MinValue || unpaidItems[0].OrderDate < firstOrderDate)
                    firstOrderDate = unpaidItems[0].OrderDate;
            }

            if (firstOrderDate != DateTime.MinValue)
                FirstOrder.Text = string.Format("{0:d}", firstOrderDate);


            PurchaseTotalSummary paidSummary = ReportDataSource.CalculatePurchaseHistoryTotals(paidItems);

            GrossProduct.Text = paidSummary.GrossProductsTotal.LSCurrencyFormat("lc");
            Discount.Text = String.Format("{0}", (paidSummary.DiscountsTotal * -1).LSCurrencyFormat("lc"));
            Coupon.Text = String.Format("{0}", (paidSummary.CouponsTotal * -1).LSCurrencyFormat("lc"));
            NetProduct.Text = paidSummary.NetProductTotal.LSCurrencyFormat("lc");

            ProfitLabel.Visible = paidSummary.CostOfGoodsSoldTotal > 0;
            Profit.Visible = paidSummary.CostOfGoodsSoldTotal > 0;

            Profit.Text = paidSummary.ProfitTotal.LSCurrencyFormat("lc");
            Taxes.Text = paidSummary.TaxesTotal.LSCurrencyFormat("lc");
            Shipping.Text = paidSummary.ShippingTotal.LSCurrencyFormat("lc");
            Other.Text = paidSummary.OtherTotal.LSCurrencyFormat("lc");
            TotalPayments.Text = paidSummary.TotalCharges.LSCurrencyFormat("lc");
            PurchasesToDate.Text = paidSummary.TotalCharges.LSCurrencyFormat("lc");

            PaidOrders.Text = paidSummary.OrderIds.Count.ToString();
            if (paidSummary.OrderIds.Count == 0) PaidOrdersPanel.Visible = false;


            PurchaseTotalSummary unpaidSummary = ReportDataSource.CalculatePurchaseHistoryTotals(unpaidItems);

            UnpaidGrossProduct.Text = unpaidSummary.GrossProductsTotal.LSCurrencyFormat("lc");
            UnpaidDiscount.Text = String.Format("{0}", (unpaidSummary.DiscountsTotal * -1).LSCurrencyFormat("lc"));
            UnpaidCoupon.Text = String.Format("{0}", (unpaidSummary.CouponsTotal * -1).LSCurrencyFormat("lc"));
            UnpaidNetProduct.Text = unpaidSummary.NetProductTotal.LSCurrencyFormat("lc");

            UnpaidProfitLabel.Visible = unpaidSummary.CostOfGoodsSoldTotal > 0;
            UnpaidProfit.Visible = unpaidSummary.CostOfGoodsSoldTotal > 0;

            UnpaidProfit.Text = unpaidSummary.ProfitTotal.LSCurrencyFormat("lc");
            UnpaidTaxes.Text = unpaidSummary.TaxesTotal.LSCurrencyFormat("lc");
            UnpaidShipping.Text = unpaidSummary.ShippingTotal.LSCurrencyFormat("lc");
            UnpaidOther.Text = unpaidSummary.OtherTotal.LSCurrencyFormat("lc");
            UnpaidTotalPayments.Text = unpaidSummary.UnpaidTotal.LSCurrencyFormat("lc");
            UnpaidPurchasedToDate.Text = unpaidSummary.TotalCharges.LSCurrencyFormat("lc");

            PendingOrders.Text = unpaidSummary.OrderIds.Count.ToString();
            if (unpaidSummary.OrderIds.Count == 0) UnpaidOrdersPanel.Visible = false;


        }

        protected void PaidOrderGrid_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (e.SortExpression != PaidOrderGrid.SortExpression) e.SortDirection = SortDirection.Descending;
        }

        protected void UnPaidOrderGrid_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (e.SortExpression != UnPaidOrderGrid.SortExpression) e.SortDirection = SortDirection.Descending;
        }

        public class PurchaseSummaryComparer : IComparer<PurchaseSummary>
        {

            SortDirection _SortDirection;
            public PurchaseSummaryComparer(SortDirection sortDirection)
            {
                _SortDirection = sortDirection;
            }

            #region IComparer Members
            public int Compare(PurchaseSummary x, PurchaseSummary y)
            {
                if (_SortDirection == SortDirection.Ascending)
                    return x.OrderDate.CompareTo(y.OrderDate);
                return y.OrderDate.CompareTo(x.OrderDate);
            }
            #endregion
        }
    }
}
