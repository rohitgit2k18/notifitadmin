namespace AbleCommerce.ConLib.Checkout.Google
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Xml;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments.Providers.GoogleCheckout.AC;
    using CommerceBuilder.Payments.Providers.GoogleCheckout.Checkout;
    using CommerceBuilder.Payments.Providers.GoogleCheckout.Util;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    [Description("Implements GoogleCheckout button")]
    [System.Obsolete("Google Checkout is retired - effective November 20th 2013")]
    public partial class GoogleCheckoutButton : System.Web.UI.UserControl
    {
        private GridView _BasketGrid = null;
        private DataList _WarningMessageList = null;

        private bool HasProhibitedItems()
        {
            foreach (BasketItem item in AbleContext.Current.User.Basket.Items)
            {
                if (item.OrderItemType == OrderItemType.Product)
                    if ((item.Product != null) && (item.Product.IsProhibited)) return true;
            }
            return false;
        }

        private bool HasAllowedOrderAmounts()
        {
            // IF THE ORDER AMOUNT DOES NOT FALL IN VALID RANGE SPECIFIED BY THE MERCHENT
            decimal orderTotal = AbleContext.Current.User.Basket.Items.TotalPrice();
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            decimal minOrderAmount = settings.OrderMinimumAmount;
            decimal maxOrderAmount = settings.OrderMaximumAmount;

            if ((minOrderAmount > orderTotal) || (maxOrderAmount > 0 && maxOrderAmount < orderTotal))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            User user = AbleContext.Current.User;
            Basket basket = user.Basket;
            GCheckoutButton.Enabled = !HasProhibitedItems() && HasAllowedOrderAmounts() && !(user.IsAnonymous && (basket.Items.HasDigitalGoods() || basket.Items.HasSubscriptions()));
            GCheckoutButton.Size = ButtonSize.Small;
            GCheckoutButton.Background = BackgroundType.Transparent;
            GCheckoutButton.AlternateText = "Fast checkout through Google";
            GCheckoutButton.ToolTip = "Fast checkout through Google";
            GCheckoutButton.Visible = false;
            if (GCheckoutButton.IsConfigured)
            {
                if (basket.Items.Count > 0)
                {
                    GCheckoutButton.Visible = true;
                }
            }
        }

        protected void GCheckoutButton_Click(object sender, ImageClickEventArgs e)
        {
            if (_BasketGrid != null)
            {
                //First Save the updated Basket		
                AbleCommerce.Code.BasketHelper.SaveBasket(_BasketGrid);
            }

            GCheckoutButton.Currency = AbleContext.Current.Store.BaseCurrency.ISOCode;
            CheckoutShoppingCartRequest Req = GCheckoutButton.CreateRequest();

            System.Xml.XmlDocument tempDoc = new System.Xml.XmlDocument();

            Basket basket = AbleContext.Current.User.Basket;
            // Add a "BasketId" node.
            System.Xml.XmlNode tempNode2 = tempDoc.CreateElement("BasketId");
            tempNode2.InnerText = basket.Id.ToString();
            Req.AddMerchantPrivateDataNode(tempNode2);

            tempNode2 = tempDoc.CreateElement("BasketContentHash");
            tempNode2.InnerText = GetBasketContentHash(basket);
            Req.AddMerchantPrivateDataNode(tempNode2);

            // We just created this structure on the order level:
            // <merchant-private-data>
            //   <BasketId xmlns="">xxxxxx</BasketId>
            // </merchant-private-data>

            // Now we are going to add the basket items.        
            XmlNode[] itemPrivateData;
            foreach (BasketItem item in basket.Items)
            {
                switch (item.OrderItemType)
                {
                    case OrderItemType.Product:
                        itemPrivateData = BuildPrivateData(item);
                        bool isDigitalContent = item.Product == null ? false : item.Product.IsDigitalGood;
                        if (isDigitalContent)
                        {
                            Req.AddItem(AcHelper.SanitizeText(item.Name), AcHelper.SanitizeText(item.Product.Description), (Decimal)item.Price, item.Quantity, isDigitalContent, AcHelper.SanitizeText(string.Format("The download will be available from your {0} order receipt once payment is processed.", AbleContext.Current.Store.Name)), itemPrivateData);
                        }
                        else
                        {
                            Req.AddItem(AcHelper.SanitizeText(item.Name), AcHelper.SanitizeText(item.Product.Description), (Decimal)item.Price, item.Quantity, itemPrivateData);
                        }
                        break;
                    case OrderItemType.Charge:
                        itemPrivateData = BuildPrivateData(item);
                        Req.AddItem(AcHelper.SanitizeText(item.Name), "Charge", (Decimal)item.Price, item.Quantity, itemPrivateData);
                        break;
                    case OrderItemType.Credit:
                        itemPrivateData = BuildPrivateData(item);
                        Req.AddItem(AcHelper.SanitizeText(item.Name), "Credit", (Decimal)item.Price, item.Quantity, itemPrivateData);
                        break;
                    case OrderItemType.GiftWrap:
                        itemPrivateData = BuildPrivateData(item);
                        Req.AddItem(AcHelper.SanitizeText(item.Name), "Gift Wrapping", (Decimal)item.Price, item.Quantity, itemPrivateData);
                        break;
                    case OrderItemType.Coupon: //on callback as well
                        itemPrivateData = BuildPrivateData(item);
                        Req.AddItem(AcHelper.SanitizeText(item.Name), "Your coupon has been applied.", (Decimal)item.Price, item.Quantity, itemPrivateData);
                        break;
                    case OrderItemType.Discount:
                        itemPrivateData = BuildPrivateData(item);
                        Req.AddItem(AcHelper.SanitizeText(item.Name), "Discount", (Decimal)item.Price, item.Quantity, itemPrivateData);
                        break;
                    case OrderItemType.GiftCertificate: //on callback
                        break;
                    case OrderItemType.Handling: //on callback
                        break;
                    case OrderItemType.Shipping: //on callback
                        break;
                    case OrderItemType.Tax: //on callback
                        break;
                }
            }

            //setup other settings
            Req.AcceptMerchantCoupons = GCheckoutButton.GatewayInstance.CouponsEnabled;
            Req.AcceptMerchantGiftCertificates = GCheckoutButton.GatewayInstance.GiftCertificatesEnabled;
            //Req.CartExpiration = expirationDate;
            string storeDomain = UrlHelper.GetDomainFromUrl(AbleContext.Current.Store.StoreUrl);
            string storeBaseUrl = "http://" + storeDomain;
            Req.ContinueShoppingUrl = storeBaseUrl + this.ResolveUrl("~/Default.aspx");
            Req.EditCartUrl = storeBaseUrl + this.ResolveUrl("~/Basket.aspx");
            Req.MerchantCalculatedTax = true;
            //add at least one tax rule
            Req.AddZipTaxRule("99999", 0F, false);
            string storeBaseSecureUrl = AbleContext.Current.Store.Settings.SSLEnabled ? storeBaseUrl.Replace("http://", "https://") : storeBaseUrl;
            Req.MerchantCalculationsUrl = storeBaseSecureUrl + this.ResolveUrl("~/Checkout/Google/MerchantCalc.ashx");
            Req.PlatformID = 769150108975916;
            Req.RequestBuyerPhoneNumber = true;
            Req.SetExpirationMinutesFromNow(GCheckoutButton.GatewayInstance.ExpirationMinutes);

            //add ship methods
            IList<ShipMethod> shipMethods = ShipMethodDataSource.LoadAll();
            List<string> shipMethodsAdded = new List<string>();
            string shipMethName;
            decimal basketTotal = basket.Items.TotalPrice();
            decimal defaultRate = GCheckoutButton.GatewayInstance.DefaultShipRate;
            ShippingRestrictions shipRestrictions = new ShippingRestrictions();
            shipRestrictions.AddAllowedWorldArea();

            foreach (ShipMethod shipMethod in shipMethods)
            {
                if (!shipMethod.Name.Equals("Unknown(GoogleCheckout)") &&
                     (shipMethod.MinPurchase <= 0 || shipMethod.MinPurchase <= basketTotal))
                {
                    //add all other shipmethods as merchant calculated irrespective of whether they
                    //are applicable or not. It will be determined on call-back
                    //GoogleCheckout does not allow to mix merchant calculated shipping methods with other methods
                    if (shipMethod.ShipMethodType == ShipMethodType.FlatRate)
                    {
                        defaultRate = GetFlatShipRate(shipMethod);
                    }
                    else
                    {
                        defaultRate = GCheckoutButton.GatewayInstance.DefaultShipRate;
                    }
                    shipMethName = BuildShipMethodName(shipMethod, shipMethodsAdded);
                    Req.AddMerchantCalculatedShippingMethod(shipMethName, defaultRate, shipRestrictions, shipRestrictions);
                    shipMethodsAdded.Add(shipMethName.ToLowerInvariant());
                }
            }

            GCheckoutResponse Resp = Req.Send();
            if (Resp.IsGood)
            {
                Response.Redirect(Resp.RedirectUrl, true);
            }
            else
            {
                DataList msgList;
                if (_WarningMessageList != null)
                {
                    msgList = _WarningMessageList;
                }
                else
                {
                    msgList = GCWarningMessageList;
                    phWarnings.Visible = true;
                }
                if (msgList != null)
                {
                    List<string> googleMessages = new List<string>();
                    googleMessages.Add("Google Checkout Failed.");
                    googleMessages.Add("Google Checkout Response.IsGood = " + Resp.IsGood);
                    googleMessages.Add("Google Checkout Error Message = " + Resp.ErrorMessage);
                    msgList.DataSource = googleMessages;
                    msgList.DataBind();
                }
            }
        }

        private XmlNode[] BuildPrivateData(BasketItem item)
        {
            List<XmlNode> privateData = new List<XmlNode>();

            XmlDocument tempDoc = new XmlDocument();

            XmlNode tempNode1 = tempDoc.CreateElement("basketItemId");
            tempNode1.InnerText = item.Id.ToString();
            privateData.Add(tempNode1);

            tempNode1 = tempDoc.CreateElement("productId");
            tempNode1.InnerText = item.ProductId.ToString();
            privateData.Add(tempNode1);

            tempNode1 = tempDoc.CreateElement("orderItemType");
            tempNode1.InnerText = item.OrderItemType.ToString();
            privateData.Add(tempNode1);

            if (item.OrderItemType == OrderItemType.Product)
            {
                tempNode1 = tempDoc.CreateElement("shippable");
                tempNode1.InnerText = item.Shippable.ToString();
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("taxCodeId");
                tempNode1.InnerText = item.TaxCodeId.ToString();
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("weight");
                tempNode1.InnerText = item.Weight.ToString();
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("wrapStyleId");
                tempNode1.InnerText = item.WrapStyleId.ToString();
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("optionList");
                tempNode1.InnerText = item.OptionList;
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("kitList");
                tempNode1.InnerText = item.KitList;
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("giftMessage");
                tempNode1.InnerText = item.GiftMessage;
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("lineMessage");
                tempNode1.InnerText = item.LineMessage;
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("lastModifiedDate");
                tempNode1.InnerText = item.LastModifiedDate.ToString();
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("orderBy");
                tempNode1.InnerText = item.OrderBy.ToString();
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("parentItemId");
                tempNode1.InnerText = item.ParentItemId.ToString();
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("sku");
                tempNode1.InnerText = item.Sku.ToString();
                privateData.Add(tempNode1);
                tempNode1 = tempDoc.CreateElement("wishlistItemId");
                tempNode1.InnerText = item.WishlistItemId.ToString();
                privateData.Add(tempNode1);

                if (item.Inputs.Count > 0)
                {
                    XmlNode tempNode = tempDoc.CreateElement("inputs");
                    foreach (BasketItemInput inputItem in item.Inputs)
                    {
                        tempNode1 = tempDoc.CreateElement("itemInput");
                        tempNode1.InnerText = inputItem.InputValue.ToString();
                        XmlAttribute fieldId = tempDoc.CreateAttribute("inputFieldId");
                        fieldId.InnerText = inputItem.InputFieldId.ToString();
                        tempNode1.Attributes.Append(fieldId);
                        tempNode.AppendChild(tempNode1);
                    }
                    privateData.Add(tempNode);
                }
            }
            else if (item.OrderItemType == OrderItemType.Coupon)
            {
                tempNode1 = tempDoc.CreateElement("couponCode");
                tempNode1.InnerText = item.Sku;
                privateData.Add(tempNode1);
            }

            return privateData.ToArray();
        }

        private string GetBasketContentHash(Basket basket)
        {
            return basket.GetContentHash(false, false, true, OrderItemType.Charge, OrderItemType.Credit,
                    OrderItemType.Discount, OrderItemType.GiftWrap, OrderItemType.Product);
        }

        private string BuildShipMethodName(ShipMethod shipMethod, List<string> shipMethodsAdded)
        {
            string methName = AcHelper.SanitizeText(shipMethod.Name);
            if (shipMethodsAdded.Contains(methName.ToLowerInvariant()))
            {
                methName = string.Format("[{0}]{1}", shipMethod.Id, methName);
            }
            return methName;
        }

        private decimal GetFlatShipRate(ShipMethod shipMethod)
        {
            decimal rate = 0;
            if (shipMethod.ShipRateMatrices.Count > 0)
            {
                rate = shipMethod.ShipRateMatrices[0].Rate;
            }

            Basket basket = AbleContext.Current.User.Basket;

            //ADD ADDITIONAL SURCHARGE DEFINED FOR THIS SHIP METHOD
            decimal surchargeAmount;
            if (shipMethod.SurchargeModeId == (byte)SurchargeMode.PercentofShippingCharge)
            {
                surchargeAmount = Math.Round(((Decimal)rate / 100) * (Decimal)shipMethod.Surcharge, 2);
            }
            else if (shipMethod.SurchargeModeId == (byte)SurchargeMode.PercentofShippingTotal)
            {
                surchargeAmount = Math.Round((basket.Items.TotalPrice() / 100) * (Decimal)shipMethod.Surcharge, 2);
            }
            else
            {
                surchargeAmount = shipMethod.Surcharge;
            }

            rate += surchargeAmount;
            return rate;
        }

        private ShipRateQuote GetShipRateQuote(Basket basket, ShipMethod shipMethod)
        {
            GoogleBasketShipment shipment = new GoogleBasketShipment(basket, shipMethod);
            return shipMethod.GetShipRateQuote(shipment);
        }

        public bool Enabled
        {
            get { return GCheckoutButton.Enabled; }
            set { GCheckoutButton.Enabled = value; }
        }

        public bool IsConfigured
        {
            get { return GCheckoutButton.IsConfigured; }
        }

        public new bool Visible
        {
            get { return GCheckoutButton.Visible; }
            set { GCheckoutButton.Visible = value; }
        }

        public GridView BasketGrid
        {
            get { return _BasketGrid; }
            set { _BasketGrid = value; }
        }

        public DataList WarningMessageList
        {
            get { return _WarningMessageList; }
            set { _WarningMessageList = value; }
        }
    }
}