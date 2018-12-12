namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Taxes.Providers.TaxCloud;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;

    [Description("Shows a summary of basket totals")]
    public partial class BasketTotalSummary : System.Web.UI.UserControl
    {
        private bool _ShowTaxes = true;
        private bool _ShowTaxBreakdown = true;
        private bool _ShowShipping = false;
        private bool _ShowMessage = false;

        /// <summary>
        /// Gets or sets a flag that indicates whether taxes should be shown 
        /// </summary>
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true taxes are shown")]
        public bool ShowTaxes
        {
            get { return _ShowTaxes; }
            set { _ShowTaxes = value; }
        }

        /// <summary>
        /// Gets or sets a flag that indicates whether taxes should be shown as a summary or breakdown
        /// </summary>
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true tax-breakdown is shown")]
        public bool ShowTaxBreakdown
        {
            get { return _ShowTaxBreakdown; }
            set { _ShowTaxBreakdown = value; }
        }

        /// <summary>
        /// Gets or sets a flag that indicates whether shipping should be shown or not
        /// </summary>
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true shipping is shown")]
        public bool ShowShipping
        {
            get { return _ShowShipping; }
            set { _ShowShipping = value; }
        }

        /// <summary>
        /// Gets or sets a flag that indicates whether to show the total pending message.
        /// </summary>
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true a message about pending calculations later is shown")]
        public bool ShowMessage
        {
            get { return _ShowMessage; }
            set { _ShowMessage = value; }
        }

        //USE PRERENDER TO ALLOW FOR CALCULATIONS TO BASKET CONTENTS
        protected void Page_PreRender(object sender, EventArgs e)
        {
            decimal productsTotal = 0;
            decimal subtotal = 0;
            decimal gstTotal = 0;
            decimal shipping = 0;
            decimal handling = 0;
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
                decimal extendedPrice = InvoiceHelper.GetInvoiceExtendedPrice(item); /*TaxHelper.GetInvoiceExtendedPrice(AbleContext.Current.User.Basket, item);*/

                switch (item.OrderItemType)
                {
                    case OrderItemType.Product:
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
                            productsTotal += extendedPrice;
                            subtotal += extendedPrice;
                            gstTotal += ((extendedPrice * (decimal)1.1) - extendedPrice);
                            numberOfProducts += item.Quantity;
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
 	 	 	 	        BasketShipment shipment = item.Shipment;
 	 	 	 	        if (shipment != null && shipment.ShipMethod != null && shipment.ShipMethod.SurchargeIsVisible) handling += extendedPrice;
 	 	 	 	        else shipping += extendedPrice;
 	 	 	 	        break;
                    case OrderItemType.Tax:
                        if (taxes.ContainsKey(item.Name + ":")) taxes[item.Name + ":"] += extendedPrice;
                        else taxes[item.Name + ":"] = extendedPrice;
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
                total += (extendedPrice * (decimal)1.1);
            }
            ProductTotalLabel.Text = string.Format(ProductTotalLabel.Text, numberOfProducts);
            ProductTotal.Text = productsTotal.LSCurrencyFormat("ulc");
            Subtotal.Text = subtotal.LSCurrencyFormat("ulc");
            GstTotal.Text = gstTotal.LSCurrencyFormat("ulc");
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

            if (this.ShowTaxes && 
                AbleContext.Current.User.PrimaryAddress.IsValid &&
                TaxHelper.GetEffectiveInvoiceDisplay(AbleContext.Current.User) != TaxInvoiceDisplay.Included)
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
                trTaxCloudTaxExemption.Visible = false;
            }

            // SHIPPING SHOULD NOT BE VISIBLE WHEN USER BILLING ADDRESS IS NOT SELECTED
            Shipping.Text = shipping.LSCurrencyFormat("ulc");
            if (!basket.User.PrimaryAddress.IsValid)
            {
                trShipping.Visible = false;
            }
            else if (shipping > 0)
            {
                trShipping.Visible = true;
            }
            else
            {
                trShipping.Visible = ShowShipping;
            }

            if (handling > 0 && trShipping.Visible)
 	 	 	{
 	 	 	 	trHandling.Visible = true;
 	 	 	 	Handling.Text = handling.LSCurrencyFormat("ulc");
 	 	 	}
 	 	 	else trHandling.Visible = false;

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

            TaxCloudProvider taxProvider = ProviderHelper.LoadTaxProvider<TaxCloudProvider>();
            if (taxProvider != null && taxProvider.EnableTaxCloud && ShowTaxes && taxes.Count > 0 && taxProvider.UseTaxExemption)
            {
                trTaxCloudTaxExemption.Visible = true;
            }
        }
    }
}