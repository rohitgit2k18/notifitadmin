namespace AbleCommerce.Checkout
{
    using System;
    using System.Linq;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Shipping.Providers.UPS;

    public partial class ShipMethod : CommerceBuilder.UI.AbleCommercePage
    {
        private string weightFormat;
        private bool _shippingMethodsAvailable = true;

        private bool _ShowWeight = true;
        public bool ShowWeight
        {
            get { return _ShowWeight; }
            set { _ShowWeight = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            CommerceBuilder.Users.User user = AbleContext.Current.User;
            if (user.IsAnonymous)
            {
                Response.Redirect("~/Checkout/Default.aspx");
                return;
            }

            if (CheckQuoteBasketItems())
            {
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetQuotePageUrl());
            }

            // VALIDATE BILLING ADDRESS
            if (!AbleContext.Current.User.PrimaryAddress.IsValid)
            {
                if (Request.UrlReferrer != null)
                    Response.Redirect(Request.UrlReferrer.AbsoluteUri);
                else
                    Response.Redirect("EditBillAddress.aspx");
            }

            Basket basket = AbleContext.Current.User.Basket;

            // VERIFY ANY SHIPPABLE ITEMS ARE IN PROPERLY CONFIGURED SHIPMENTS
            int unpackagedItems = basket.Items.Count(i => i.Shippable != CommerceBuilder.Shipping.Shippable.No && i.Shipment == null);
            if (unpackagedItems > 0) Response.Redirect("ShipAddress.aspx");
            int missingShippingAddress = basket.Shipments.Count(s => s.Address == null || !s.Address.IsValid);
            if (missingShippingAddress > 0) Response.Redirect("ShipAddress.aspx");
            
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);
            if (basket.Items.Count == 0) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
            if (!basket.Items.HasShippableProducts()) Response.Redirect("Payment.aspx");
            weightFormat = "{0:0.##} " + AbleContext.Current.Store.WeightUnit;
            if (!Page.IsPostBack)
            {
                ShipmentRepeater.DataSource = AbleContext.Current.User.Basket.Shipments;
                ShipmentRepeater.DataBind();
            }
            else
            {
                UpdateShipments();
                preCheckoutService.Recalculate(basket);
                BasketTotalsAjax.Update();
            }
            foreach (var rec in basket.Items)
            {
                rec.Price = Math.Abs(rec.Price);
            }
            foreach (RepeaterItem item in ShipmentRepeater.Items)
            {
                if (item.ItemType == ListItemType.AlternatingItem || item.ItemType == ListItemType.Item)
                {
                    Control msgBox = item.FindControl("ShipMessage");
                    Control msgBoxLbl = item.FindControl("ShipMessageCount");
                    if (msgBox != null && msgBoxLbl != null)
                    {
                        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(msgBox as TextBox, msgBoxLbl as Label);
                    }
                }
            }
        }

        //THIS VARIABLE TRACKS SHIPPING INDEX
        //TO HELP BUILD RADIO BUTTONS
        private int _ShipmentIndex;
        protected void ShipmentRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            //CAST DATA ITEM
            BasketShipment shipment = (BasketShipment)e.Item.DataItem;
            
            //UPDATE SHIPPING WEIGHT
            Literal shipWeight = (Literal)e.Item.FindControl("ShipWeight");
            if (shipWeight != null)
            {
                shipWeight.Text = string.Format(weightFormat, shipment.Items.TotalWeight());
            }
            //SHOW SHIPPING METHODS            
            DropDownList ShipMethodsList = (DropDownList)e.Item.FindControl("ShipMethodsList");
            Localize ShipMethodErrorMessage = (Localize)e.Item.FindControl("ShipMethodErrorMessage");
            PlaceHolder phNoShippingMethods = (PlaceHolder)e.Item.FindControl("phNoShippingMethods");
            PlaceHolder phShipMessage = (PlaceHolder)e.Item.FindControl("PHShipMessage");
            if (phShipMessage != null)
            {
                phShipMessage.Visible = AbleContext.Current.Store.Settings.EnableShipMessage;
            }

            if (ShipMethodsList != null)
            {
                _ShipmentIndex = e.Item.ItemIndex;
                IShipRateQuoteCalculator shippingCalculator = AbleContext.Resolve<IShipRateQuoteCalculator>();
                ICollection<ShipRateQuote> rateQuotes = shippingCalculator.QuoteForShipment(shipment);
                foreach (var rec in rateQuotes) {
                    rec.Rate = Math.Abs(rec.Rate);
                }
                ShipMethodsList.DataSource = GetShipMethodListDs(rateQuotes);
                ShipMethodsList.DataBind();
                if (rateQuotes.Count == 0)
                {
                    ShipMethodErrorMessage.Visible = true;
                    phNoShippingMethods.Visible = true;
                    ShipMethodsList.Visible = false;
                    Localize ShipMethodUPSErrorMessage = (Localize)e.Item.FindControl("ShipMethodUPSErrorMessage");
                    // CHECK IF UPS IS ENABLED
                    string classId = Misc.GetClassId(typeof(UPS));
                    IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
                    if (gateways.Count > 0)
                    {
                        // CHECK IF PROVIDED ADDRESS IS A PO-BOX ADDRESS
                        if (ValidationHelper.IsPostOfficeBoxAddress(shipment.Address.Address1))
                        {   
                            ShipMethodUPSErrorMessage.Visible = true;
                        }
                    }

                    _shippingMethodsAvailable = false;
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ContinueButton.Visible = _shippingMethodsAvailable;
        }

        private List<KeyValuePair<int, string>> GetShipMethodListDs(ICollection<ShipRateQuote> rateQuotes)
        {
            List<KeyValuePair<int, string>> ds = new List<KeyValuePair<int, string>>();
            foreach (ShipRateQuote quote in rateQuotes)
            {
                ds.Add(new KeyValuePair<int, string>(quote.ShipMethodId, quote.Name + " " + quote.TotalRate.LSCurrencyFormat("ulc")));
            }
            return ds;
        }

        protected void ContinueButton_Click(object sender, EventArgs e)
        {
            bool allMethodsValid = UpdateShipments();
            if (allMethodsValid)
            {   
                Response.Redirect("Payment.aspx");
            }
            else
            {
                //HANDLE ERROR MESSAGE (UNEXPECTED)
                InvalidShipMethodPanel.Visible = true;
            }
        }

        private bool UpdateShipments()
        {
            //LOOP SHIPMENTS, GET SHIPPING METHODS
            Basket basket = AbleContext.Current.User.Basket;
            IList<BasketShipment> shipments = basket.Shipments;
            _ShipmentIndex = 0;
            bool allMethodsValid = true;
            foreach (BasketShipment shipment in shipments)
            {
                // shipment.ShipMethod = ShipMethodDataSource.Load(AlwaysConvert.ToInt(Request.Form["ShipMethod" + _ShipmentIndex]));
                DropDownList ShipMethodsList = ShipmentRepeater.Items[_ShipmentIndex].FindControl("ShipMethodsList") as DropDownList;
                shipment.ShipMethod = ShipMethodDataSource.Load(AlwaysConvert.ToInt(ShipMethodsList.SelectedValue));
                TextBox shipMessage = ShipmentRepeater.Items[_ShipmentIndex].FindControl("ShipMessage") as TextBox;

                if (shipMessage != null && !string.IsNullOrEmpty(shipMessage.Text))
                {
                    shipMessage.Text = StringHelper.StripHtml(shipMessage.Text.Trim());
                    if (shipMessage.Text.Length > 255)
                    {
                        shipMessage.Text = shipMessage.Text.Substring(0, 255);
                    }
                    shipment.ShipMessage = shipMessage.Text;
                }
                else
                {
                    shipment.ShipMessage = "";
                }
                shipment.Save();
                if (shipment.ShipMethod == null) allMethodsValid = false;
                _ShipmentIndex++;
            }
            return allMethodsValid;
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

        protected bool ShowGiftOptionsLink(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            if (item.OrderItemType == OrderItemType.Product && !item.IsChildItem && item.Shippable != Shippable.No)
            {
                return item.Product.WrapGroup != null;
            }
            return false;
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

        protected bool ShowProductImagePanel(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return ((item.OrderItemType == OrderItemType.Product));
        }
        //TODO: Move Code to Helper Class
        public Boolean CheckQuoteBasketItems()
        {
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);
            return basket.Items.Any(item => item.OrderItemType == OrderItemType.Product && (item.Price <= 0 || !(item.Product.VolumeDiscounts.Any() && item.Product.VolumeDiscounts[0].Levels.Any())));
        }
    }
}