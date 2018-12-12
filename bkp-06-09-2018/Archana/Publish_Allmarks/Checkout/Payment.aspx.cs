namespace AbleCommerce.Checkout
{
    using System;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.DomainModel;

    public partial class PaymentPage : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            if (user.IsAnonymous)
            {
                Response.Redirect("~/Checkout/Default.aspx");
                return;
            }
            
            AbleCommerce.Code.PageHelper.DisableValidationScrolling(this.Page);            
            Basket basket = user.Basket;

            // PERFORM VALIDATIONS TO ENSURE PAYMENT STAGE IS VALID
            // MAKE SURE THERE ARE ITEMS IN THE BASKET            
            int productCount = basket.Items.Count(i => i.OrderItemType == OrderItemType.Product);
            if (productCount == 0) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
            
            // VERIFY A VALID BILLING ADDRESS IS AVAILABLE
            if (!user.PrimaryAddress.IsValid)
            {
                if (Request.UrlReferrer != null) Response.Redirect(Request.UrlReferrer.AbsoluteUri);
                else Response.Redirect("EditBillAddress.aspx");
            }

            // VERIFY ANY SHIPPABLE ITEMS ARE IN PROPERLY CONFIGURED SHIPMENTS
            int unpackagedItems = basket.Items.Count(i => i.Shippable != CommerceBuilder.Shipping.Shippable.No && i.Shipment == null);
            if (unpackagedItems > 0) Response.Redirect("ShipAddress.aspx");
            int missingShippingAddress = basket.Shipments.Count(s => s.Address == null || !s.Address.IsValid);
            if (missingShippingAddress > 0) Response.Redirect("ShipAddress.aspx");
            int missingShippingMethod = basket.Shipments.Count(s => s.ShipMethod == null);
            if (missingShippingMethod > 0) Response.Redirect("ShipMethod.aspx");
            
            if (!Page.IsPostBack)
            {
                IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                preCheckoutService.Recalculate(basket);
                foreach (var rec in basket.Items) {
                    rec.Price = Math.Abs(rec.Price);
                }
                decimal orderTotal = GetBasketTotal();
                StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                decimal minOrderAmount = settings.OrderMinimumAmount;
                decimal maxOrderAmount = settings.OrderMaximumAmount;
                TermsAndConditions.Text = settings.CheckoutTermsAndConditions;

                // IF THE ORDER AMOUNT DOES NOT FALL IN VALID RANGE SPECIFIED BY THE MERCHENT
                if (/*(minOrderAmount > orderTotal) ||*/ ValidateVolumeOrder(basket.Items) || (maxOrderAmount > 0 && maxOrderAmount < orderTotal))
                {
                    // REDIRECT TO BASKET PAGE
                    Response.Redirect("~/Basket.aspx");
                }
                else if (TermsAndConditions.Text.Length > 0)
                {
                    //SHOW TERMS AND CONDITIONS IF PRESENT
                    TermsAndConditionsSection.Visible = true;

                    //ADD SCRIPTS FOR TERMS AND CONDITIONS
                    string TCScript = "function toggleTC(c) { document.getElementById(\"" + AcceptTC.ClientID + "\").checked = c; }\r\n" +
                        "function validateTC(source, args) { args.IsValid = document.getElementById(\"" + AcceptTC.ClientID + "\").checked; }";
                    this.Page.ClientScript.RegisterStartupScript(this.GetType(), "TCScript", TCScript, true);
                }
            }

            //SEE WHETHER WE HAVE MULTIPLE SHIPMENTS
            if (HasMultipleShipments()) _EditShipToLink = "~/Checkout/ShipAddresses.aspx";
            else _EditShipToLink = "~/Checkout/ShipAddress.aspx";

            // INITIALIZE THE PAYMENT CONTROL
            PaymentWidget.Basket = basket;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (CheckQuoteBasketItems())
            {
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetQuotePageUrl());
            }
        }

        private bool ValidateVolumeOrder(IPersistableList<BasketItem> items)
        {
            foreach (var rec in items)
            {
                if (rec.OrderItemType == OrderItemType.Product)
                {
                    decimal MinQuantity = 0;

                    if (rec.Product.VolumeDiscounts.Any() && rec.Product.VolumeDiscounts[0].Levels.Any())
                    {
                        VolumeDiscount VolumeDiscount = rec.Product.VolumeDiscounts[0];
                        MinQuantity = VolumeDiscount.Levels.First().MinValue;
                    }
                    else
                    {
                        MinQuantity = rec.Product.MinQuantity;
                    }

                    if (rec.Quantity < MinQuantity)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // DISPLAY THE SHIPMENT REPEATER ON PRERENDER TO ACCOUNT FOR 
            // POSSIBLE IMPACTS OF APPLIED COUPONS
            Basket basket = AbleContext.Current.User.Basket;
            ShipmentRepeater.DataSource = basket.Shipments;
            ShipmentRepeater.DataBind();
        }

        protected void ShipmentRepeater_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            GridView ShipmentItemsGrid = (GridView)e.Item.FindControl("ShipmentItemsGrid");
            if (ShipmentItemsGrid != null)
            {
                ShipmentItemsGrid.Columns[3].HeaderText = TaxHelper.TaxColumnHeader;
                ShipmentItemsGrid.Columns[3].Visible = TaxHelper.ShowTaxColumn;
            }
        }

        protected string GetTaxHeader()
        {
            return TaxHelper.TaxColumnHeader;
        }

        protected decimal GetBasketTotal()
        {
            OrderItemType[] args = new OrderItemType[] { OrderItemType.Charge, 
                                                    OrderItemType.Coupon, OrderItemType.Credit, OrderItemType.Discount, 
                                                    OrderItemType.GiftCertificate, OrderItemType.GiftWrap, OrderItemType.Handling, 
                                                    OrderItemType.Product, OrderItemType.Shipping, OrderItemType.Tax };
            return AbleContext.Current.User.Basket.Items.TotalPrice(args);
        }

        private bool HasMultipleShipments()
        {
            Basket basket = AbleContext.Current.User.Basket;
            if (basket.Shipments.Count < 2) return false;
            int firstAddressId = basket.Shipments[0].AddressId;
            for (int i = 1; i < basket.Shipments.Count; i++)
            {
                if (firstAddressId != basket.Shipments[i].AddressId) return true;
            }
            return false;
        }

        private string _EditShipToLink;
        protected string GetEditShipToLink()
        {
            return _EditShipToLink;
        }

        protected bool ShowProductImagePanel(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return ((item.OrderItemType == OrderItemType.Product));
        }

        protected void ValidateTC(object source, ServerValidateEventArgs args)
        {
            args.IsValid = AcceptTC.Checked;
        }

        public Boolean CheckQuoteBasketItems()
        {
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);
            return basket.Items.Any(item => item.OrderItemType == OrderItemType.Product && (item.Price <= 0 || !(item.Product.VolumeDiscounts.Any() && item.Product.VolumeDiscounts[0].Levels.Any())));
        }
    }
}