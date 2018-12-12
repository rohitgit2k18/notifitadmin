namespace AbleCommerce.Mobile.Checkout
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using System.Collections.Generic;
    using System.Linq;
    using AbleCommerce.Code;

    public partial class PaymentPage : CommerceBuilder.UI.AbleCommercePage
    {
        private Basket _Basket;
        protected void Page_Init(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.DisableValidationScrolling(this.Page);
            User user = AbleContext.Current.User;

            _Basket = AbleContext.Current.User.Basket;
            if (_Basket.Items.Count == 0)
            {
                Response.Redirect(NavigationHelper.GetBasketUrl());
            }
            
            //MAKE SURE THERE ARE ITEMS IN THE BASKET            
            bool hasItems = false;
            foreach (BasketItem item in user.Basket.Items)
            {
                if (item.OrderItemType == OrderItemType.Product)
                {
                    hasItems = true;
                    break;
                }
            }
            if (!hasItems)
            {
                //THERE ARE NO PRODUCTS, SEND THEN TO SEE EMPTY BASKET
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
            }

            //VERIFY A VALID BILLING ADDRESS IS AVAILABLE
            if (!user.PrimaryAddress.IsValid) Response.Redirect("EditBillAddress.aspx");

            // VERIFY ANY SHIPPABLE ITEMS ARE IN PROPERLY CONFIGURED SHIPMENTS
            int unpackagedItems = _Basket.Items.Count(i => i.Shippable != CommerceBuilder.Shipping.Shippable.No && i.Shipment == null);
            if (unpackagedItems > 0) Response.Redirect("ShipAddress.aspx");
            int missingShippingAddress = _Basket.Shipments.Count(s => !s.Address.IsValid);
            if (missingShippingAddress > 0) Response.Redirect("ShipAddress.aspx");
            int missingShippingMethod = _Basket.Shipments.Count(s => s.ShipMethod == null);
            if (missingShippingMethod > 0) Response.Redirect("ShipMethod.aspx");

            if (!Page.IsPostBack)
            {
                IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                preCheckoutService.Recalculate(user.Basket);
                decimal orderTotal = GetBasketTotal();
                StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                decimal minOrderAmount = settings.OrderMinimumAmount;
                decimal maxOrderAmount = settings.OrderMaximumAmount;
                
                // IF THE ORDER AMOUNT DOES NOT FALL IN VALID RANGE SPECIFIED BY THE MERCHENT
                if ((minOrderAmount > orderTotal) || (maxOrderAmount > 0 && maxOrderAmount < orderTotal))
                {
                    // REDIRECT TO BASKET PAGE
                    Response.Redirect("~/Basket.aspx");
                }
                else if (!string.IsNullOrEmpty(settings.CheckoutTermsAndConditions))
                {
                    //SHOW TERMS AND CONDITIONS IF PRESENT
                    TermsAndConditionsSection.Visible = true;
                }
            }

            // SEE IF VALID SHIPPING ADDRESSES AND SHIP METHODS ARE SELECTED
            if (this.HasShippableProducts)
            {
                foreach (BasketShipment shipment in user.Basket.Shipments)
                {
                    if (!shipment.Address.IsValid) Response.Redirect("ShipAddress.aspx");
                    if (shipment.ShipMethod == null) Response.Redirect("ShipMethod.aspx");
                }
            }

            //SEE WHETHER WE HAVE MULTIPLE SHIPMENTS
            if (HasMultipleDestinations()) _EditShipToLink = "~/Checkout/ShipAddresses.aspx";
            else _EditShipToLink = NavigationHelper.GetMobileStoreUrl("~/Checkout/ShipAddress.aspx");

            // INITIALIZE THE PAYMENT CONTROL
            Basket basket = AbleContext.Current.User.Basket;
            PaymentWidget.Basket = basket;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            
            // SHOW SHIPPING INFORMATION
            if (user.Basket.Shipments.Count > 0)
            {
                Address shippingAddress = user.Basket.Shipments[0].Address;
                ShippingAddress.Text = shippingAddress.ToString();
                ShippingAddressPanel.Visible = true;
            }
            else
            {
                ShippingAddressPanel.Visible = false;
            }

            // SHOW BILLING INFORMATION
            BillingAddress.Text = AbleContext.Current.User.PrimaryAddress.ToString();
            OrderItemsRepeater.DataSource = GetBasketItems();
            OrderItemsRepeater.DataBind();
        }
        
        protected IList<BasketItem> GetShipmentItems(object dataItem)
        {
            BasketShipment shipment = (BasketShipment)dataItem;
            IList<BasketItem> singleItems = new List<BasketItem>();
            foreach (BasketItem item in shipment.Items)
            {
                if (item.OrderItemType == OrderItemType.Product)
                {
                    if (!item.IsChildItem || item.Product.KitStatus != CommerceBuilder.Products.KitStatus.Member)
                    {
                        singleItems.Add(item);
                    }
                }
            }
            return singleItems;
        }

        protected bool HasMultipleShipments()
        {
            return AbleContext.Current.User.Basket.Shipments.Count > 1;
        }
               
        protected decimal GetBasketTotal()
        {
            OrderItemType[] args = new OrderItemType[] { OrderItemType.Charge, 
                                                    OrderItemType.Coupon, OrderItemType.Credit, OrderItemType.Discount, 
                                                    OrderItemType.GiftCertificate, OrderItemType.GiftWrap, OrderItemType.Handling, 
                                                    OrderItemType.Product, OrderItemType.Shipping, OrderItemType.Tax };
            return AbleContext.Current.User.Basket.Items.TotalPrice(args);
        }

        private bool HasMultipleDestinations()
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

        protected void ValidateTC(object source, ServerValidateEventArgs args)
        {
            //args.IsValid = AcceptTC.Checked;
        }

        private int _HasShippableProducts = -1;
        private bool HasShippableProducts
        {
            get
            {
                if (_HasShippableProducts < 0)
                {
                    _HasShippableProducts = AbleContext.Current.User.Basket.Items.HasShippableProducts() ? 1 : 0;
                }
                return (_HasShippableProducts == 1);
            }
            set { _HasShippableProducts = (value ? 1 : 0); }
        }

        private IList<BasketItem> GetBasketItems()
        {
            User user = AbleContext.Current.User;
            Basket basket = user.Basket;
            List<BasketItem> displayedBasketItems = new List<BasketItem>();
            OrderItemType[] displayItemTypes = { OrderItemType.Product, OrderItemType.GiftWrap };
            foreach (BasketItem item in basket.Items)
            {
                if (Array.IndexOf(displayItemTypes, item.OrderItemType) > -1)
                {
                    if (item.OrderItemType == OrderItemType.Product && item.IsChildItem)
                    {
                        // WHETHER THE CHILD ITEM DISPLAYS DEPENDS ON THE ROOT
                        BasketItem rootItem = item.GetParentItem(true);
                        if (rootItem != null && rootItem.Product != null && rootItem.Product.Kit != null && rootItem.Product.Kit.ItemizeDisplay)
                        {
                            // ITEMIZED DISPLAY ENABLED, SHOW THIS CHILD ITEM
                            displayedBasketItems.Add(item);
                        }
                    }
                    else
                    {
                        // NO ADDITIONAL CHECK REQUIRED TO INCLUDE ROOT PRODUCTS OR NON-PRODUCTS
                        displayedBasketItems.Add(item);
                    }
                }
            }
            
            //SORT ITEMS TO COMPLETE INTITIALIZATION
            displayedBasketItems.Sort(new BasketItemComparer());
            return displayedBasketItems;
        }
    }
}
