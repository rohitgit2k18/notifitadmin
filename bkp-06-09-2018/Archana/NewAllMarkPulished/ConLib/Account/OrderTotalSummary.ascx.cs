namespace AbleCommerce.ConLib.Account
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;

    [Description("Displays totals summary for an order")]
    public partial class OrderTotalSummary : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                // construct the totals table
                decimal subtotal = 0;
                decimal gstTotal = 0;
                decimal shipping = 0;
                decimal handling = 0;
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
                        case OrderItemType.Product:
                            bool countItem = !item.IsChildItem;
                            if (!countItem)
                            {
                                OrderItem parentItem = item.GetParentItem(false);
                                if (parentItem != null)
                                {
                                    countItem = parentItem.ItemizeChildProducts;
                                }
                            }
                            if (countItem)
                            {
                                subtotal += extendedPrice;
                                gstTotal += ((extendedPrice*(decimal)1.1) - extendedPrice);

                            }
                            else
                            {
                                // zero out the ext price - it is included with the parent
                                extendedPrice = 0;
                            }
                            break;
                        case OrderItemType.Shipping:
                            shipping += extendedPrice;
                            break;
                        case OrderItemType.Handling:
                            handling += extendedPrice;
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
                    total += (extendedPrice * (decimal)1.1);
                }
                Subtotal.Text = subtotal.LSCurrencyFormat("ulc");
                Gst.Text = gstTotal.LSCurrencyFormat("ulc");
                if (giftwrap != 0)
                {
                    trGiftWrap.Visible = true;
                    GiftWrap.Text = giftwrap.LSCurrencyFormat("ulc");
                }
                else trGiftWrap.Visible = false;
                Shipping.Text = shipping.LSCurrencyFormat("ulc");

                if (handling > 0)
                {
                    trHandling.Visible = true;
                    Handling.Text = handling.LSCurrencyFormat("ulc");
                }
                else trHandling.Visible = false;

                string taxRow = "<tr><th>{0}: </th><td>{1}</td></tr>";

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