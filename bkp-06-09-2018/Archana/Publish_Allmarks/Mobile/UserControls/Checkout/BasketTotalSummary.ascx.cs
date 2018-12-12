namespace AbleCommerce.Mobile.UserControls.Checkout
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;

    public partial class BasketTotalSummary : System.Web.UI.UserControl
    {
        private bool _ShowTaxes = true;
        private bool _ShowTaxBreakdown = true;
        private bool _ShowShipping = true;
        private bool _ShowMessage = false;
        private bool _ShowHeader = true;

        /// <summary>
        /// Gets or sets a flag that indicates whether taxes should be shown 
        /// </summary>
        public bool ShowTaxes
        {
            get { return _ShowTaxes; }
            set { _ShowTaxes = value; }
        }

        /// <summary>
        /// Gets or sets a flag that indicates whether taxes should be shown as a summary or breakdown
        /// </summary>
        public bool ShowTaxBreakdown
        {
            get { return _ShowTaxBreakdown; }
            set { _ShowTaxBreakdown = value; }
        }

        /// <summary>
        /// Gets or sets a flag that indicates whether shipping should be shown or not
        /// </summary>
        public bool ShowShipping
        {
            get { return _ShowShipping; }
            set { _ShowShipping = value; }
        }

        /// <summary>
        /// Gets or sets a flag that indicates whether to show the total pending message.
        /// </summary>
        public bool ShowMessage
        {
            get { return _ShowMessage; }
            set { _ShowMessage = value; }
        }

        public bool ShowHeader
        {
            get { return _ShowHeader; }
            set { _ShowHeader = value; }
        }

        //USE PRERENDER TO ALLOW FOR CALCULATIONS TO BASKET CONTENTS
        protected void Page_PreRender(object sender, EventArgs e)
        {
            decimal productsTotal = 0;
            decimal subtotal = 0;
            decimal shipping = 0;
            Dictionary<string, decimal> taxes = new Dictionary<string, decimal>();
            decimal totalTaxAmount = 0;
            decimal coupons = 0;
            decimal discounts = 0;
            decimal total = 0;
            decimal giftwrap = 0;
            int numberOfProducts = 0;
            decimal giftCodes = 0;
            Basket basket = AbleContext.Current.User.Basket;
            foreach (BasketItem item in basket.Items)
            {
                decimal extendedPrice = AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice(item);
                switch (item.OrderItemType)
                {
                    case OrderItemType.Product:
                        productsTotal += extendedPrice;
                        subtotal += extendedPrice;

                        bool countItem = !item.IsChildItem;
                        if (!countItem)
                        {
                            BasketItem parentItem = item.GetParentItem(false);
                            if (parentItem != null)
                            {
                                countItem = parentItem.Product.IsKit && parentItem.Product.Kit.ItemizeDisplay;
                            }
                        }

                        if (countItem)
                        {
                            numberOfProducts += item.Quantity;
                        }
                                                
                        break;
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
                    case OrderItemType.Discount:
                        discounts += extendedPrice;
                        subtotal += extendedPrice;
                        break;
                    case OrderItemType.GiftCertificatePayment:
                        giftCodes += extendedPrice;
                        break;
                    default:
                        subtotal += extendedPrice;
                        break;
                }
                total += extendedPrice;
            }
            ProductTotalLabel.Text = string.Format(ProductTotalLabel.Text, numberOfProducts);
            ProductTotal.Text = productsTotal.LSCurrencyFormat("ulc");
            Subtotal.Text = subtotal.LSCurrencyFormat("ulc");
            // DISCOUNT ROW VISIBILITY
            if (discounts != 0)
            {
                trDiscounts.Visible = true;
                Discounts.Text = discounts.LSCurrencyFormat("ulc");
            }
            else trDiscounts.Visible = false;
            
            if (giftwrap != 0)
            {
                trGiftWrap.Visible = true;
                GiftWrap.Text = giftwrap.LSCurrencyFormat("ulc");
            }
            else trGiftWrap.Visible = false;
            Shipping.Text = shipping.LSCurrencyFormat("ulc");

            if (this.ShowTaxes && TaxHelper.GetEffectiveInvoiceDisplay(AbleContext.Current.User) != TaxInvoiceDisplay.Included)
            {
                if (ShowTaxBreakdown)
                {
                    TaxesBreakdownRepeater.DataSource = taxes;
                    TaxesBreakdownRepeater.DataBind();
                    TaxesBreakdownRepeater.Visible = true;
                    trTax.Visible = false;
                }
                else
                {
                    TaxesLabel.Text = totalTaxAmount.LSCurrencyFormat("ulc");
                    TaxesBreakdownRepeater.Visible = false;
                    trTax.Visible = true;
                }
            }
            else
            {
                // TAXES ARE NOT DISPLAYED, REMOVE ANY TAX FROM THE TOTAL
                total -= totalTaxAmount;
                TaxesBreakdownRepeater.Visible = false;
                trTax.Visible = false;
            }

            // SHIPPING SHOULD NOT BE VISIBLE WHEN USER BILLING ADDRESS IS NOT SELECTED
            if (!basket.User.PrimaryAddress.IsValid)
            {
                trShipping.Visible = false;
            }
            else
                trShipping.Visible = ShowShipping;

            if (giftCodes != 0)
            {
                trGifCodes.Visible = true;
                GifCodes.Text = giftCodes.LSCurrencyFormat("ulc");
            }
            else trGifCodes.Visible = false;

            // COUPON ROW VISIBILITY
            if (coupons != 0)
            {
                trCoupon.Visible = true;
                Coupons.Text = coupons.LSCurrencyFormat("ulc");
            }
            else trCoupon.Visible = false;

            trCouponsDivider.Visible = trCoupon.Visible || trGifCodes.Visible;

            Total.Text = total.LSCurrencyFormat("ulc");
            TotalPendingMessagePanel.Visible = this.ShowMessage;
            HeaderPanel.Visible = this.ShowHeader;
        }
    }
}