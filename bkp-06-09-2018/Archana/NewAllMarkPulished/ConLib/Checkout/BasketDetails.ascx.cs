using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Orders;
using CommerceBuilder.Common;
using CommerceBuilder.Taxes;
using CommerceBuilder.Extensions;
using System.ComponentModel;
using CommerceBuilder.Services.Checkout;
using AbleCommerce.Code;
using CommerceBuilder.Shipping;
using CommerceBuilder.Utility;
using CommerceBuilder.Products;
using CommerceBuilder.Taxes.Providers.TaxCloud;

namespace AbleCommerce.ConLib.Checkout
{
    public partial class BasketDetails : System.Web.UI.UserControl
    {
        Basket _basket = null;
        IList<BasketItem> _DisplayedBasketItems;
        
        private bool _ShowShipping = true;
        private bool _ShowMessage = false;
        private bool _ShowTaxBreakdown = true;
        private bool _Recalculated = false;

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

        protected void Page_Load(object sender, EventArgs e)
        {
            _basket = AbleContext.Current.User.Basket;
            TaxColumnHeaderText.Text = TaxHelper.TaxColumnHeader;
            TaxColumnHeaderText.Visible = TaxHelper.ShowTaxColumn;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // UPDATE CART DISPLAY JUST BEFORE PAGE RENDER, TO ENSUER ALL CHANGES ARE REFLECTED
            CartSummary.DataSource = GetBasketItems();
            CartSummary.DataBind();

            InitializeBasketContents();
            GiftOptionsPopup.CancelControlID = phGiftOptions.Visible ? CancelGiftOptionsButton.ClientID : DummyCancelLink.ClientID;
        }

        private IList<BasketItem> GetBasketItems()
        {
            Basket basket = AbleContext.Current.User.Basket;
            if (!_Recalculated)
            {
                IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                preCheckoutService.Recalculate(basket);
                preCheckoutService.Combine(basket);
                _Recalculated = true;
            }
            _DisplayedBasketItems = BasketHelper.GetDisplayItemsForInvoice(basket, false);
            return _DisplayedBasketItems;
        }

        private void InitializeBasketContents()
        {
            decimal productsTotal = 0;
            decimal subtotal = 0;
            decimal shipping = 0;
            decimal handling = 0;
            Dictionary<string, decimal> taxes = new Dictionary<string, decimal>();
            decimal totalTaxAmount = 0;
            decimal total = 0;
            int numberOfProducts = 0;
            decimal giftCodes = 0;
            Basket basket = AbleContext.Current.User.Basket;
            if (!_Recalculated)
            {
                IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                preCheckoutService.Recalculate(basket);
                preCheckoutService.Combine(basket);
                _Recalculated = true;
            }
            foreach (BasketItem item in basket.Items)
            {
                decimal extendedPrice = AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice(item);
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
                        TaxInvoiceDisplay taxDisplay = TaxHelper.GetEffectiveInvoiceDisplay(AbleContext.Current.User);
                        if (taxDisplay == TaxInvoiceDisplay.Summary)
                        {
                            if (taxes.ContainsKey(item.Name)) taxes[item.Name] += extendedPrice;
                            else taxes[item.Name] = extendedPrice;
                        }
                        else if (taxDisplay != TaxInvoiceDisplay.Included) subtotal += extendedPrice;
                        totalTaxAmount += extendedPrice;
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

            Subtotal.Text = subtotal.LSCurrencyFormat("ulc");            
            
            TaxInvoiceDisplay taxInvoiceDisplay = TaxHelper.GetEffectiveInvoiceDisplay(AbleContext.Current.User);
            if (AbleContext.Current.User.PrimaryAddress.IsValid &&
                 taxInvoiceDisplay == TaxInvoiceDisplay.Summary)
            {
                TaxesBreakdownRepeater.DataSource = taxes;
                TaxesBreakdownRepeater.DataBind();
                if (ShowTaxBreakdown)
                {
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
                if (taxInvoiceDisplay == TaxInvoiceDisplay.Included) total -= totalTaxAmount;
                TaxesBreakdownRepeater.Visible = false;
                trTax.Visible = false;
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
            
            if (handling > 0)
            {
                trHandling.Visible = trShipping.Visible;
                Handling.Text = handling.LSCurrencyFormat("ulc");
            }
            else trHandling.Visible = false;
                        
            if (giftCodes != 0)
            {
                trGifCodes.Visible = true;
                GifCodes.Text = giftCodes.LSCurrencyFormat("ulc");
            }
            else trGifCodes.Visible = false;

            trCouponsDivider.Visible = trGifCodes.Visible;
                        
            Total.Text = total.LSCurrencyFormat("ulc");
            TotalPendingMessagePanel.Visible = this.ShowMessage;


            // ENABLE THE TAXCLOUD Exemption link only if taxcloud is configured and there are tax line items
            TaxGateway taxGateway = null;
            TaxCloudProvider taxProvider = null;
            int taxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(TaxCloudProvider)));
            if (taxGatewayId > 0) taxGateway = TaxGatewayDataSource.Load(taxGatewayId);
            if (taxGateway != null) taxProvider = taxGateway.GetProviderInstance() as TaxCloudProvider;

            if (taxProvider == null || !taxProvider.EnableTaxCloud || taxes.Count == 0) TaxCloudTaxExemptionCert1.Visible = false;
        }

        #region Gift Options

        protected bool ShowGiftOptionsLink(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            if (item.OrderItemType == OrderItemType.Product && !item.IsChildItem && item.Shippable != Shippable.No)
            {
                return item.Product.WrapGroup != null;
            }
            return false;
        }

        protected void CartSummary_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ShowGiftOptions")
            {
                int itemId = AlwaysConvert.ToInt(e.CommandArgument);
                BasketItem basketItem = BasketItemDataSource.Load(itemId);
                ShowGiftOptionsDialog(basketItem);
            }
        }

        // bind list
        protected void ShowGiftOptionsDialog(BasketItem basketItem)
        {
            GiftDialogCaption.Text = string.Format(GiftDialogCaption.Text, basketItem.Name);
            GiftOptionsBasketItemId.Value = basketItem.Id.ToString();
            GiftItemsGrid.DataSource = GetGiftItemsList(basketItem);
            GiftItemsGrid.DataBind();
            phGiftOptions.Visible = true;
            GiftOptionsPopup.Show();
        }

        private IList<BasketItemGiftOption> GetGiftItemsList(BasketItem basketItem)
        {
            // create the list of items
            List<BasketItemGiftOption> giftItems = new List<BasketItemGiftOption>();
            for (int i = 0; i < basketItem.Quantity; i++)
            {
                giftItems.Add(new BasketItemGiftOption(basketItem));
            }
            return giftItems;
        }

        protected void ContinueButton_Click(object sender, EventArgs e)
        {
            BasketItem basketItem = BasketItemDataSource.Load(AlwaysConvert.ToInt(GiftOptionsBasketItemId.Value));
            // LOOP EACH ITEM ROW TO DETERMINE GIFT OPTIONS
            List<BasketItemGiftOption> giftOptions = new List<BasketItemGiftOption>();
            foreach (GridViewRow row in GiftItemsGrid.Rows)
            {
                GiftWrapChoices wrapOptions = (GiftWrapChoices)row.FindControl("GiftWrapChoices");
                wrapOptions.BasketItemId = basketItem.Id;
                int wrapStyleId = wrapOptions.WrapStyleId;
                string giftMessage = wrapOptions.GiftMessage;
                BasketItemGiftOption optionItem = new BasketItemGiftOption(basketItem, wrapStyleId, giftMessage);
                int existingIndex = giftOptions.IndexOf(optionItem);
                if (existingIndex > -1) giftOptions[existingIndex].Quantity++;
                else giftOptions.Add(optionItem);
            }

            // LOOP THROUGH GIFT OPTIONS AND UPDATE BASKET ITEMS
            Basket basket = AbleContext.Current.User.Basket;
            for (int i = 0; i < giftOptions.Count; i++)
            {
                BasketItemGiftOption giftOptionItem = giftOptions[i];
                if (i == 0)
                {
                    // FOR FIRST GIFT OPTION, UPDATE THE ORIGINAL BASKET ITEM
                    basketItem.Quantity = giftOptionItem.Quantity;
                    basketItem.WrapStyleId = giftOptionItem.WrapStyleId;
                    basketItem.GiftMessage = giftOptionItem.GiftMessage;
                }
                else
                {
                    // FOR ADDTIONAL GIFT OPTIONS, CREATE COPIES OF THE ORIGINAL BASKET ITEM
                    BasketItem newItem = basketItem.Copy();
                    newItem.Quantity = giftOptionItem.Quantity;
                    newItem.GiftMessage = giftOptionItem.GiftMessage;
                    newItem.WrapStyleId = giftOptionItem.WrapStyleId;
                    basket.Items.Add(newItem);
                }
            }

            // SAVE, COMBINE
            basket.Save();
            IBasketService basketService = AbleContext.Resolve<IBasketService>();
            basketService.Combine(basket);

            CartSummary.DataSource = GetBasketItems();
            CartSummary.DataBind();

            // NOW HIDE THE POPUP
            phGiftOptions.Visible = false;
            GiftOptionsPopup.Hide();
        }

        /// <summary>
        /// Used to divide up the basket items with differing gift options.
        /// </summary>
        private class BasketItemGiftOption
        {
            public BasketItem BasketItem { get; private set; }
            public int WrapStyleId { get; private set; }
            public string GiftMessage { get; private set; }
            public short Quantity { get; set; }
            public Product Product { get { return this.BasketItem.Product; } }

            public BasketItemGiftOption(BasketItem basketItem)
                : this(basketItem, basketItem.WrapStyleId, basketItem.GiftMessage)
            { }

            public BasketItemGiftOption(BasketItem basketItem, int wrapStyleId, string giftMessage)
            {
                this.BasketItem = basketItem;
                this.WrapStyleId = wrapStyleId;
                this.GiftMessage = giftMessage;
                this.Quantity = 1;
            }

            public override bool Equals(object obj)
            {
                BasketItemGiftOption other = (BasketItemGiftOption)obj;
                return this.WrapStyleId.Equals(other.WrapStyleId) && this.GiftMessage.Equals(other.GiftMessage);
            }

            public override int GetHashCode()
            {
                string hashable = this.WrapStyleId.ToString() + "_" + this.GiftMessage;
                return hashable.GetHashCode();
            }
        }

        #endregion

        
    }
}