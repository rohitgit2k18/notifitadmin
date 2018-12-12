using System;
using System.Collections.Generic;
using CommerceBuilder.Extensions;
using CommerceBuilder.Reporting;
using CommerceBuilder.Types;

namespace AbleCommerce.Admin.ConLib
{
    public partial class MonthlySalesTotals : System.Web.UI.UserControl
    {
        public IList<SalesSummary> Sales { get; set; }

        int _OrderCount;
        decimal _ProductTotal;
        decimal _ShippingTotal;
        decimal _TaxTotal;
        decimal _DiscountTotal;
        decimal _CouponTotal;
        decimal _OtherTotal;
        decimal _ProfitTotal;
        decimal _GiftWrapTotal;
        decimal _CostTotal;
        decimal _GrandTotal;

        protected void Page_PreRender(object sender, EventArgs e)
        {
            foreach (SalesSummary ss in Sales)
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

            OrderCountTotal.Text = _OrderCount.ToString();
            ProductTotal.Text = _ProductTotal.LSCurrencyFormat("lc");
            CostOfGoodsTotal.Text = _CostTotal.LSCurrencyFormat("lc");
            ShippingTotal.Text = _ShippingTotal.LSCurrencyFormat("lc");
            TaxTotal.Text = _TaxTotal.LSCurrencyFormat("lc");
            DiscountTotal.Text = _DiscountTotal.LSCurrencyFormat("lc");
            CouponTotal.Text = _CouponTotal.LSCurrencyFormat("lc");
            OtherTotal.Text = _OtherTotal.LSCurrencyFormat("lc");
            ProfitTotal.Text = _ProfitTotal.LSCurrencyFormat("lc");
            GiftWrapTotal.Text = _GiftWrapTotal.LSCurrencyFormat("lc");
            GrandTotal.Text = _GrandTotal.LSCurrencyFormat("lc");

            TotalsPanel.Visible = _OrderCount > 0;
            MessagePanel.Visible = !TotalsPanel.Visible;
        }
    }
}
