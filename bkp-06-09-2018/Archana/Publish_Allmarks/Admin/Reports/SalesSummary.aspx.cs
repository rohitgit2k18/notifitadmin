namespace AbleCommerce.Admin.Reports
{
    using System;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;

    public partial class _SalesSummary : CommerceBuilder.UI.AbleCommerceAdminPage
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

        protected void ProcessButton_Click(object sender, EventArgs e)
        {
            BindReport();
        }

        private void BindReport()
        {
            ToCaption.Visible = true;
            FromCaption.Visible = false;
            DateTime fromDate = StartDate.SelectedStartDate;
            DateTime toDate = EndDate.SelectedEndDate;
            SalesSummary salesSummary = ReportDataSource.GetSalesSummary(fromDate, toDate, true);
            if (salesSummary != null)
            {
                ProductSales.Text = salesSummary.ProductTotal.LSCurrencyFormat("lc");
                ProductDiscounts.Text = salesSummary.DiscountTotal.LSCurrencyFormat("lc");
                ProductSalesLessDiscounts.Text = String.Format("{0}", (salesSummary.ProductTotal + salesSummary.DiscountTotal).LSCurrencyFormat("lc"));
                GiftWrapCharges.Text = salesSummary.GiftWrapTotal.LSCurrencyFormat("lc");
                CouponsRedeemed.Text = salesSummary.CouponTotal.LSCurrencyFormat("lc");
                TaxesCollected.Text = salesSummary.TaxTotal.LSCurrencyFormat("lc");
                ShippingCharges.Text = salesSummary.ShippingTotal.LSCurrencyFormat("lc");
                TotalCharges.Text = salesSummary.TotalReceivables.LSCurrencyFormat("lc");
                TotalOrders.Text = salesSummary.OrderCount.ToString();
                TotalItemsSold.Text = salesSummary.ProductCount.ToString();
                NumberOfCustomers.Text = salesSummary.UserCount.ToString();
                CostOfGoods.Text = salesSummary.CostOfGoodTotal.LSCurrencyFormat("lc");

                decimal avgOrderAmount = 0;
                if (salesSummary.OrderCount > 0)
                {
                    avgOrderAmount = salesSummary.GrandTotal / salesSummary.OrderCount;
                }
                AverageOrderAmount.Text = avgOrderAmount.LSCurrencyFormat("lc");
                ReportPanel.Visible = true;

                // update captions
                if (fromDate > DateTime.MinValue)
                {
                    FromCaption.Visible = true;
                    FromCaption.Text = string.Format(FromCaption.Text, fromDate.ToShortDateString());
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
            else
            {
                ReportPanel.Visible = false;
            }
        }
    }
}