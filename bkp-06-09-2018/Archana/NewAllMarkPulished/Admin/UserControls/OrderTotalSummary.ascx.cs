namespace AbleCommerce.Admin.UserControls
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
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class OrderTotalSummary : System.Web.UI.UserControl
    {

        private bool _ShowTitle = true;
        public bool ShowTitle
        {
            get { return _ShowTitle; }
            set { _ShowTitle = value; }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Order order = AbleCommerce.Code.OrderHelper.GetOrderFromContext();
            if (order != null)
            {
                decimal subtotal = 0;
                decimal shipping = 0;
                decimal taxes = 0;
                decimal coupons = 0;
                decimal total = 0;
                decimal giftwrap = 0;
                decimal adjustments = 0;
                foreach (OrderItem item in order.Items)
                {
                    decimal extendedPrice = item.ExtendedPrice;
                    switch (item.OrderItemType)
                    {
                        case OrderItemType.Shipping:
                        case OrderItemType.Handling:
                            shipping += extendedPrice;
                            break;
                        case OrderItemType.Tax:
                            taxes += extendedPrice;
                            break;
                        case OrderItemType.Coupon:
                            coupons += extendedPrice;
                            break;
                        case OrderItemType.GiftWrap:
                            giftwrap += extendedPrice;
                            break;
                        case OrderItemType.Charge:
                        case OrderItemType.Credit:
                            adjustments += extendedPrice;
                            break;
                        default:
                            subtotal += extendedPrice;
                            break;
                    }
                    total += item.ExtendedPrice;
                }

                Subtotal.Text = subtotal.LSCurrencyFormat("lc");
                Shipping.Text = shipping.LSCurrencyFormat("lc");
                Taxes.Text = taxes.LSCurrencyFormat("lc");
                Total.Text = total.LSCurrencyFormat("lc");

                if (giftwrap != 0)
                {
                    trGiftWrap.Visible = true;
                    GiftWrap.Text = giftwrap.LSCurrencyFormat("lc");
                }
                else trGiftWrap.Visible = false;

                if (coupons != 0)
                {
                    trCoupon.Visible = true;
                    Coupons.Text = coupons.LSCurrencyFormat("lc");
                }
                else trCoupon.Visible = false;

                if (adjustments != 0)
                {
                    trAdjustments.Visible = true;
                    Adjustments.Text = adjustments.LSCurrencyFormat("lc");
                }
                else trAdjustments.Visible = false;
                TitlePanel.Visible = this.ShowTitle;
            }
        }
    }
}
