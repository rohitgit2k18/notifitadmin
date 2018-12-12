using System;
using System.Collections.Generic;
using System.Web.UI;
using CommerceBuilder.Extensions;
using CommerceBuilder.Orders;
using CommerceBuilder.Utility;
using CommerceBuilder.Taxes;
using CommerceBuilder.Common;

namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class OrderTotalSummary : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                // construct the totals table
                decimal subtotal = 0;
                decimal shipping = 0;
                Dictionary<string, decimal> taxes = new Dictionary<string, decimal>();
                decimal totalTaxAmount = 0;
                decimal coupons = 0;
                decimal total = 0;
                decimal giftwrap = 0;
                decimal adjustments = 0;
                foreach (OrderItem item in this.Order.Items)
                {
                    decimal extendedPrice = AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice(item);
                    switch (item.OrderItemType)
                    {
                        case OrderItemType.Shipping:
                        case OrderItemType.Handling:
                            shipping += extendedPrice;
                            break;
                        case OrderItemType.Tax:
                            if (taxes.ContainsKey(item.Name)) taxes[item.Name] += extendedPrice;
                            else taxes[item.Name] = extendedPrice;
                            totalTaxAmount += extendedPrice;
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
                    total += extendedPrice;
                }
                Subtotal.Text = subtotal.LSCurrencyFormat("ulc");
                if (giftwrap != 0)
                {
                    trGiftWrap.Visible = true;
                    GiftWrap.Text = giftwrap.LSCurrencyFormat("ulc");
                }
                else trGiftWrap.Visible = false;
                Shipping.Text = shipping.LSCurrencyFormat("ulc");

                string taxRow = "<div class='inlineField'><span class='fieldHeader'>{0}: </span><span class='fieldValue price'>{1}</span></div>";

                if (TaxHelper.GetEffectiveInvoiceDisplay(AbleContext.Current.User) != TaxInvoiceDisplay.Included)
                {
                    // TAXES ARE DISPLAYED, ITEMIZE BY TAX NAME
                    foreach (string taxName in taxes.Keys)
                    {
                        phTaxes.Controls.Add(new LiteralControl(string.Format(taxRow, taxName, taxes[taxName].LSCurrencyFormat("ulc"))));
                    }
                }
                else
                {
                    // TAXES ARE NOT DISPLAYED, REMOVE ANY TAX FROM THE TOTAL
                    total -= totalTaxAmount;
                }

                if (coupons != 0)
                {
                    trCoupon.Visible = true;
                    Coupons.Text = coupons.LSCurrencyFormat("ulc");
                }
                else trCoupon.Visible = false;

                if (adjustments != 0)
                {
                    trAdjustments.Visible = true;
                    Adjustments.Text = adjustments.LSCurrencyFormat("ulc");
                }
                else trAdjustments.Visible = false;

                Total.Text = total.LSCurrencyFormat("ulc");
            }
            else
            {
                OrderTotalSummaryPanel.Visible = false;
            }
        }
    }
}