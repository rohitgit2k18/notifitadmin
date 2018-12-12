namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Collections.Specialized;
    using System.ComponentModel;
    using System.Linq;
    using System.Text;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.UI.WebControls;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Web.UI.HtmlControls;

    [Description("Displays product basic details and add-to-cart button to allow the produt to be added to cart.")]
    public partial class BuyProductDialog : System.Web.UI.UserControl
    {
        int _ProductId = 0;
        Product _Product = null;
        //Dictionary<int, int> _SelectedOptions = new Dictionary<int, int>();
        List<int> _SelectedKitProducts = new List<int>();
        Hashtable _OptionDropDownIds = new Hashtable();
        Hashtable _OptionPickerIds = new Hashtable();
        bool _isOptionalSubscription = false;
        protected Dictionary<int, int> _SelectedOptionChoices = new Dictionary<int, int>();

        // keep track if NotifySubscribeButton is clicked.
        bool notifySubscribeButtonClicked = false;

        private bool _ShowSku = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true SKU is displayed")]
        public bool ShowSku
        {
            get { return _ShowSku; }
            set { _ShowSku = value; }
        }

        private bool _ShowPrice = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true price is displayed")]
        public bool ShowPrice
        {
            get { return _ShowPrice; }
            set { _ShowPrice = value; }
        }

        private bool _ShowSubscription = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true subscription details are displayed")]
        public bool ShowSubscription
        {
            get { return _ShowSubscription; }
            set { _ShowSubscription = value; }
        }

        private bool _ShowMSRP = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true MRSP is displayed")]
        public bool ShowMSRP
        {
            get { return _ShowMSRP; }
            set { _ShowMSRP = value; }
        }

        private bool _ShowPartNumber = false;
        [Personalizable, WebBrowsable]
        [Browsable(true), DefaultValue(false)]
        [Description("If true Part/Model number is displayed")]
        public bool ShowPartNumber
        {
            get { return _ShowPartNumber; }
            set { _ShowPartNumber = value; }
        }

        private string _GTINName = "GTIN";
        [Personalizable, WebBrowsable]
        [Browsable(true), DefaultValue("GTIN")]
        [Description("Indicates the display name. Possible values are 'GTIN', 'UPC' and 'ISBN'")]
        public string GTINName
        {
            get { return _GTINName; }
            set { _GTINName = value; }
        }

        private bool _ShowGTIN = false;
        [Personalizable, WebBrowsable]
        [Browsable(true), DefaultValue(false)]
        [Description("If true GTIN number is displayed")]
        public bool ShowGTIN
        {
            get { return _ShowGTIN; }
            set { _ShowGTIN = value; }
        }

        private bool _ShowAllOptions = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true all product options are displayed")]
        public bool ShowAllOptions
        {
            get { return _ShowAllOptions; }
            set { _ShowAllOptions = value; }
        }

        private bool _IgnoreInventory = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true inventory is ignored")]
        public bool IgnoreInventory
        {
            get { return _IgnoreInventory; }
            set { _IgnoreInventory = value; }
        }

        private bool _ShowAddAndUpdateButtons = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true inventory is add button will be shown while editing basket items")]
        public bool ShowAddAndUpdateButtons
        {
            get { return _ShowAddAndUpdateButtons; }
            set { _ShowAddAndUpdateButtons = value; }
        }

        protected string ProductAvailabilityStatus
        {
            get 
            { 
                string inStockValue = "http://schema.org/InStock";
                string outStockValue = "http://schema.org/OutOfStock";
                if (!AbleContext.Current.Store.Settings.EnableInventory || _Product.InventoryMode == InventoryMode.None 
                    || _Product.AllowBackorder)
                    return inStockValue;

                bool allProductOptionsSelected = (_SelectedOptionChoices.Count == _Product.ProductOptions.Count);
                bool requiredKitOptionsSelected = AbleCommerce.Code.ProductHelper.RequiredKitOptionsSelected(_Product, _SelectedKitProducts);

                if (allProductOptionsSelected && requiredKitOptionsSelected)
                {
                    string optionList = ProductVariantDataSource.GetOptionList(_ProductId, _SelectedOptionChoices, true);

                    IInventoryManager inventoryManager = AbleContext.Resolve<IInventoryManager>();
                    InventoryManagerData inv = inventoryManager.CheckStock(_ProductId, optionList, _SelectedKitProducts);

                    if (inv.InStock > 0)
                    {
                        return inStockValue;
                    }
                    else
                    {
                        return outStockValue;
                    }
                }

                return inStockValue;
            }
        }

        protected void Page_Init(object sender, System.EventArgs e)
        {
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product != null)
            {
                //DISABLE PURCHASE CONTROLS BY DEFAULT
                AddToBasketButton.Visible = false;
                rowQuantity.Visible = false;

                //HANDLE SKU ROW
                trSku.Visible = (ShowSku && (_Product.Sku != string.Empty));
                if (trSku.Visible)
                {
                    Sku.Text = _Product.Sku;
                }

                _isOptionalSubscription = _Product.IsSubscription && _Product.SubscriptionPlan.IsOptional;

                if (!_isOptionalSubscription)
                {
                    //HANDLE REGPRICE ROW
                    if (ShowMSRP)
                    {
                        decimal msrpWithVAT = TaxHelper.GetShopPrice(_Product.MSRP, _Product.TaxCode != null ? _Product.TaxCode.Id : 0);                   
                        if (msrpWithVAT > 0)
                        {
                            trRegPrice.Visible = true;
                            RegPrice.Text = msrpWithVAT.LSCurrencyFormat("ulc");
                        }
                        else trRegPrice.Visible = false;
                    }
                    else trRegPrice.Visible = false;

                    // HANDLE PRICES VISIBILITY
                    if (ShowPrice)
                    {
                        if (!_Product.UseVariablePrice || _Product.IsSubscription)
                        {
                            trOurPrice.Visible = (!_Product.VolumeDiscounts.Any() || !_Product.VolumeDiscounts[0].Levels.Any());
                            trVariablePrice.Visible = false;
                        }
                        else
                        {
                            trOurPrice.Visible = false;
                            trVariablePrice.Visible = true;
                            VariablePrice.Text = _Product.Price.ToString("F2");
                            string varPriceText = string.Empty;
                            Currency userCurrency = AbleContext.Current.User.UserCurrency;
                            decimal userLocalMinimum = userCurrency.ConvertFromBase(_Product.MinimumPrice.HasValue ? _Product.MinimumPrice.Value : 0);
                            decimal userLocalMaximum = userCurrency.ConvertFromBase(_Product.MaximumPrice.HasValue ? _Product.MaximumPrice.Value : 0);
                            if (userLocalMinimum > 0)
                            {
                                if (userLocalMaximum > 0)
                                {
                                    varPriceText = string.Format("(between {0} and {1})", userLocalMinimum.LSCurrencyFormat("ulcf"), userLocalMaximum.LSCurrencyFormat("ulcf"));
                                }
                                else
                                {
                                    varPriceText = string.Format("(at least {0})", userLocalMinimum.LSCurrencyFormat("ulcf"));
                                }
                            }
                            else if (userLocalMaximum > 0)
                            {
                                varPriceText = string.Format("({0} maximum)", userLocalMaximum.LSCurrencyFormat("ulcf"));
                            }
                            phVariablePrice.Controls.Add(new LiteralControl(varPriceText));
                        }
                    }
                }
                else
                {
                    trRegPrice.Visible = false;
                    trOurPrice.Visible = (!_Product.VolumeDiscounts.Any() || !_Product.VolumeDiscounts[0].Levels.Any());
                    trVariablePrice.Visible = false;
                }

                //UPDATE QUANTITY LIMITS
                if ((_Product.MinQuantity > 0) && (_Product.MaxQuantity > 0))
                {
                    string format = " (min {0}, max {1})";
                    QuantityLimitsPanel.Controls.Add(new LiteralControl(string.Format(format, _Product.MinQuantity, _Product.MaxQuantity)));
                    Quantity.MinValue = _Product.MinQuantity;
                    Quantity.MaxValue = _Product.MaxQuantity;
                }
                else if (_Product.MinQuantity > 0)
                {
                    string format = " (min {0})";
                    QuantityLimitsPanel.Controls.Add(new LiteralControl(string.Format(format, _Product.MinQuantity)));
                    Quantity.MinValue = _Product.MinQuantity;
                }
                else if (_Product.MaxQuantity > 0)
                {
                    string format = " (max {0})";
                    QuantityLimitsPanel.Controls.Add(new LiteralControl(string.Format(format, _Product.MaxQuantity)));
                    Quantity.MaxValue = _Product.MaxQuantity;
                }

                if (Quantity.MinValue > 0) Quantity.Text = Quantity.MinValue.ToString();

                //BUILD PRODUCT ATTRIBUTES
                //_SelectedOptionChoices = AbleCommerce.Code.ProductHelper.BuildProductOptions(_Product, phOptions);
                //BUILD PRODUCT CHOICES
                //AbleCommerce.Code.ProductHelper.BuildProductChoices(_Product, phOptions);
                //BUILD KIT OPTIONS
                //_SelectedKitProducts = AbleCommerce.Code.ProductHelper.BuildKitOptions(_Product, phKitOptions);
                AddToWishlistButton.Visible = AbleContext.Current.StoreMode == StoreMode.Standard;
                BindAutoDelieveryOptions();
            }
            else
            {
                this.Controls.Clear();
            }
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (_Product != null)
            {
                if (ViewState["OptionDropDownIds"] != null)
                {
                    _OptionDropDownIds = (Hashtable)ViewState["OptionDropDownIds"];
                }
                else
                {
                    _OptionDropDownIds = new Hashtable();
                }

                if (ViewState["OptionPickerIds"] != null)
                {
                    _OptionPickerIds = (Hashtable)ViewState["OptionPickerIds"];
                }
                else
                {
                    _OptionPickerIds = new Hashtable();
                }

                AddToBasketButton.CssClass += " cart-btn" ;

                _SelectedOptionChoices = GetSelectedOptionChoices();
                //_SelectedOptions = _SelectedOptionChoices;

                OptionsList.DataSource = GetProductOptions();
                OptionsList.DataBind();

                TemplatesList.DataSource = GetProductTemplateFields();
                TemplatesList.DataBind();

                KitsList.DataSource = GetProductKitComponents();
                KitsList.DataBind();
            }

            AddToWishlistButton.CssClass += " wish-list-btn";
            AddToWishlistButton.Visible = AbleContext.Current.Store.Settings.WishlistsEnabled;
        }

        private void UpdateInventoryDetails(InventoryManagerData inv)
        {
            if ((inv.InventoryMode == InventoryMode.None) || (inv.AllowBackorder)) return;
            if (inv.InStock > 0)
            {
                string inStockformat = AbleContext.Current.Store.Settings.InventoryInStockMessage;
                string inStockMessage = string.Format(inStockformat, inv.InStock);
                InventoryDetailsPanel.Controls.Clear();
                InventoryDetailsPanel.Controls.Add(new LiteralControl(inStockMessage));

                // CALCULATE MAX VALUE FOR QUANTITY
                if (_Product.MaxQuantity > 0 && _Product.MaxQuantity < inv.InStock)
                {
                    Quantity.MaxValue = _Product.MaxQuantity;
                }
                else Quantity.MaxValue = inv.InStock;

                InventoryRestockNotificationsPanel.Visible = false;
            }
            else
            {
                bool showRestockNotification = false;
                string outOfStockformat = AbleContext.Current.Store.Settings.InventoryOutOfStockMessage;
                string outOfStockMessage = string.Format(outOfStockformat, inv.InStock);
                InventoryDetailsPanel.Controls.Clear();
                InventoryDetailsPanel.Controls.Add(new LiteralControl(outOfStockMessage));

                if(inv.InventoryMode == InventoryMode.Product 
                    && _Product.AvailabilityDate.HasValue 
                    && _Product.AvailabilityDate >= LocaleHelper.LocalNow)
                {
                    string availabilityMessageFormat = AbleContext.Current.Store.Settings.InventoryAvailabilityMessage;
                    string availabilityMessage = string.Format(availabilityMessageFormat, _Product.AvailabilityDate.Value.ToShortDateString());
                    InventoryDetailsPanel.Controls.Add(new LiteralControl(string.Format("{0}", availabilityMessage)));
                }
                else if(inv.InventoryMode == InventoryMode.Variant)
                {
                    string optionList = ProductVariantDataSource.GetOptionList(_ProductId, _SelectedOptionChoices, true);
                    if (!string.IsNullOrEmpty(optionList))
                    {
                        ProductVariant variant = ProductVariantDataSource.LoadForOptionList(_ProductId, optionList);
                        if(variant != null
                            && variant.AvailabilityDate.HasValue
                            && variant.AvailabilityDate >= LocaleHelper.LocalNow)
                        {
                            string availabilityMessageFormat = AbleContext.Current.Store.Settings.InventoryAvailabilityMessage;
                            string availabilityMessage = string.Format(availabilityMessageFormat, variant.AvailabilityDate.Value.ToShortDateString());
                            InventoryDetailsPanel.Controls.Add(new LiteralControl(string.Format("{0}", availabilityMessage)));

                            // show restock notification subscription link for this variant
                            showRestockNotification = _Product.EnableRestockNotifications;
                        }
                    }
                }

                if (_Product.InventoryMode == InventoryMode.Product)
                {
                    // enable restock notification subscription link only if page is not post back.
                    showRestockNotification = _Product.EnableRestockNotifications && !inv.AllowBackorder;
                }

                // CHECK EVENT TARGET
                string eventTarget = Request["__EVENTTARGET"];
                bool restockNotificationEventTarget = false;
                restockNotificationEventTarget = notifySubscribeButtonClicked || (!string.IsNullOrEmpty(eventTarget) && eventTarget.EndsWith("NotificationsLink"));

                if (showRestockNotification && !restockNotificationEventTarget)
                {
                    InventoryRestockNotificationsPanel.Visible = true;

                    NotificationsLink.Text = AbleContext.Current.Store.Settings.InventoryRestockNotificationLink;
                    NotificationsLink.Visible = true;
                    UserEmailLabel.Visible = false;
                    UserEmail.Visible = false;
                    UserEmailValidator.Visible = false;
                    NotifySubscribeButton.Visible = false;
                    RestockNotificationSubscribedMessagePanel.Visible = false;
                }
                else if (!Page.IsPostBack)
                {
                    InventoryRestockNotificationsPanel.Visible = false;                    
                }
            }

            if (InventoryDetailsPanel.Controls.Count > 0)
            {
                InventoryDetailsPanel.Controls.AddAt(0, new LiteralControl("<span class='inventoryDetails'>"));
                InventoryDetailsPanel.Controls.Add(new LiteralControl("</span>"));
            }
        }

        private void HideAddToBasket()
        {
            AddToBasketButton.Visible = false;
            rowQuantity.Visible = false;
        }

        private void ShowAddToBasket()
        {
            AddToBasketButton.Visible = true;
            rowQuantity.Visible = true;
        }

        protected BasketItem GetBasketItem(bool alwaysCreateNew = false)
        {
            //GET THE QUANTITY
            short tempQuantity = AlwaysConvert.ToInt16(Quantity.Text, 1);
            if (tempQuantity < 1) return null;

            //RECALCULATE SELECTED KIT OPTIONS
            GetSelectedKitOptions();
            // DETERMINE THE OPTION LIST
            string optionList = ProductVariantDataSource.GetOptionList(_ProductId, _SelectedOptionChoices, false);
            //CREATE THE BASKET ITEM WITH GIVEN OPTIONS
            
            bool calculateOneTimePrice = false;
            if (_isOptionalSubscription)
            {
                calculateOneTimePrice = !AutoDeliveryRadio.Checked;
            }
            
            Basket basket = AbleContext.Current.User.Basket;
            BasketItem basketItem = null;

            if(!alwaysCreateNew)
                basketItem = GetExistingBasketItem();

            if (basketItem != null)
            {
                // update existing basket item
                basketItem.Quantity = (short)tempQuantity;
                basketItem.KitList = AlwaysConvert.ToList(",", _SelectedKitProducts);
                basketItem.OptionList = optionList;

                // verify quantity is within bounds
                Product product = basketItem.Product;
                if (product != null && (product.MinQuantity > 0 || product.MaxQuantity > 0))
                {
                    int existingQuantity = basket.Items.Where(bi => bi.ProductId == product.Id && bi.Id != basketItem.Id).Sum(bi => bi.Quantity);
                    if (product.MinQuantity > 0 && basketItem.Quantity + existingQuantity < product.MinQuantity)
                        basketItem.Quantity = (short)(product.MinQuantity - existingQuantity);
                    if (product.MaxQuantity > 0 && basketItem.Quantity + existingQuantity > product.MaxQuantity)
                        basketItem.Quantity = (short)(product.MaxQuantity - existingQuantity);
                }

                // update calculated price of product
                ProductCalculator pcalc = ProductCalculator.LoadForProduct(basketItem.ProductId, basketItem.Quantity, basketItem.OptionList, basketItem.KitList, basket.UserId, false, calculateOneTimePrice);
                basketItem.Sku = pcalc.Sku;
                basketItem.Price = pcalc.Price;
                basketItem.Weight = pcalc.Weight;
            }
            else
            {
                // create new basket item
                basketItem = BasketItemDataSource.CreateForProduct(_ProductId, (short)tempQuantity, optionList, AlwaysConvert.ToList(",", _SelectedKitProducts), basket.UserId, calculateOneTimePrice);
            }

            if (basketItem != null)
            {
                basketItem.Basket = basket;
                //ADD IN VARIABLE PRICE
                if (_Product.UseVariablePrice && !_Product.IsSubscription)
                {
                    Currency userCurrency = AbleContext.Current.User.UserCurrency;
                    decimal userLocalPrice = AlwaysConvert.ToDecimal(VariablePrice.Text);
                    basketItem.Price = userCurrency.ConvertToBase(userLocalPrice);
                }
                AbleCommerce.Code.ProductHelper.CollectProductTemplateInput(basketItem, this);

                // UPDATE SUBSCRIPTION DETAILS
                if (_Product.IsSubscription)
                {
                    if (_isOptionalSubscription)
                    {
                        basketItem.IsSubscription = AutoDeliveryRadio.Checked;
                    }
                    else
                        basketItem.IsSubscription = true;

                    if (basketItem.IsSubscription && _Product.SubscriptionPlan.IsRecurring)
                    {
                        basketItem.Frequency = _Product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional ? AlwaysConvert.ToInt16(AutoDeliveryInterval.SelectedValue) : _Product.SubscriptionPlan.PaymentFrequency;
                        basketItem.FrequencyUnit = _Product.SubscriptionPlan.PaymentFrequencyUnit;
                    }
                    else if (basketItem.IsSubscription)
                    {
                        basketItem.Frequency = _Product.SubscriptionPlan.PaymentFrequency;
                        basketItem.FrequencyUnit = _Product.SubscriptionPlan.PaymentFrequencyUnit;
                    }
                }
            }


            return basketItem;
        }

        private bool ValidateVariablePrice()
        {
            if (!_Product.UseVariablePrice || _Product.IsSubscription) return true;
            Currency userCurrency = AbleContext.Current.User.UserCurrency;
            decimal userLocalPrice = AlwaysConvert.ToDecimal(VariablePrice.Text);
            decimal price = userCurrency.ConvertToBase(userLocalPrice);
            bool priceValid = ((price >= _Product.MinimumPrice) && ((_Product.MaximumPrice == 0) || (price <= _Product.MaximumPrice)));
            if (!priceValid)
            {
                CustomValidator invalidPrice = new CustomValidator();
                invalidPrice.IsValid = false;
                invalidPrice.Text = "*";
                invalidPrice.ErrorMessage = "Price does not fall within the accepted range.";
                invalidPrice.ControlToValidate = "VariablePrice";
                invalidPrice.ValidationGroup = "AddToBasket";
                phVariablePrice.Controls.Add(invalidPrice);
            }
            return priceValid;
        }

        private bool AllProductOptionsSelected()
        {
            if (_SelectedOptionChoices.Count != _Product.ProductOptions.Count)
            {
                phAddToBasketWarningOpt.Visible = true;
                return false;
            }
            else
            {
                phAddToBasketWarningOpt.Visible = false;
                return true;
            }
        }

        private int AvailableProductOptionsCount()
        {
            int count = 0;
            for (int i = 0; i < _Product.ProductOptions.Count; i++)
            {
                Option option = _Product.ProductOptions[i].Option;
                // GET THE COLLECTION OF OPTIONS THAT ARE AVAILABLE FOR THE CURRENT SELECTIONS
                IList<OptionChoice> availableChoices = OptionChoiceDataSource.GetAvailableChoices(_Product.Id, option.Id, _SelectedOptionChoices);
                if (availableChoices.Count > 0) count++;
            }
            return count;
        }

        private bool RequiredKitOptionsSelected()
        {
            bool requiredKitOptionsSelected = AbleCommerce.Code.ProductHelper.RequiredKitOptionsSelected(_Product, _SelectedKitProducts);
            if (requiredKitOptionsSelected)
            {
                phAddToBasketWarningKit.Visible = false;
                return true;
            }
            else
            {
                phAddToBasketWarningKit.Visible = true;
                return false;
            }
        }

        protected bool ValidateQuantity()
        {
            string optionList = ProductVariantDataSource.GetOptionList(_ProductId, _SelectedOptionChoices, true);
            if (!string.IsNullOrEmpty(optionList))
            {
                int currentQuanity = AlwaysConvert.ToInt(Quantity.Text);
                if (currentQuanity == 0)
                {
                    QuantityValidaor.ErrorMessage = "Please enter a valid quantity.";
                    QuantityValidaor.IsValid = false;
                    return false;
                }

                IInventoryManager inventoryManager = AbleContext.Resolve<IInventoryManager>();
                InventoryManagerData inv = inventoryManager.CheckStock(_ProductId, optionList, _SelectedKitProducts);
                if (inv.InventoryMode != InventoryMode.None && !inv.AllowBackorder && inv.InStock > 0 && currentQuanity > inv.InStock)
                {
                    //Quantity.Text = inv.InStock.ToString();
                    QuantityValidaor.ErrorMessage = String.Format(QuantityValidaor.ErrorMessage, inv.InStock);
                    QuantityValidaor.IsValid = false;
                    return false;
                }
            }
            return true;
        }

        protected void UpdateBasketButton_Click(object sender, System.EventArgs e)
        {
            Basket basket = AbleContext.Current.User.Basket;
            BasketItem basketItem = GetBasketItem();
            if (basketItem != null)
            {
                int qty = AlwaysConvert.ToInt(Quantity.Text, basketItem.Quantity);
                if (qty > System.Int16.MaxValue)
                {
                    basketItem.Quantity = System.Int16.MaxValue;
                }
                else
                {
                    basketItem.Quantity = (System.Int16)qty;
                }

                // Update for Minimum Maximum quantity of product
                if (basketItem.Quantity < basketItem.Product.MinQuantity)
                {
                    basketItem.Quantity = basketItem.Product.MinQuantity;
                    Quantity.Text = basketItem.Quantity.ToString();
                }
                else if ((basketItem.Product.MaxQuantity > 0) && (basketItem.Quantity > basketItem.Product.MaxQuantity))
                {
                    basketItem.Quantity = basketItem.Product.MaxQuantity;
                    Quantity.Text = basketItem.Quantity.ToString();
                }
                
                basketItem.Save();
            }
            
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
        }

        protected void AddToBasketButton_Click(object sender, System.EventArgs e)
        {
            if (Page.IsValid && ValidateVariablePrice() && ValidateQuantity()
                && AllProductOptionsSelected() && RequiredKitOptionsSelected())
            {
                bool alwaysCreateNew = GetExistingBasketItem() != null && ShowAddAndUpdateButtons;
                BasketItem basketItem = GetBasketItem(alwaysCreateNew);
                if (basketItem != null)
                {
                    if (_Product.IsSubscription)
                    {
                        if (_isOptionalSubscription)
                        {
                            basketItem.IsSubscription = AutoDeliveryRadio.Checked;
                        }
                        else
                            basketItem.IsSubscription = true;

                        if (basketItem.IsSubscription && _Product.SubscriptionPlan.IsRecurring)
                        {
                            basketItem.Frequency = _Product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional ? AlwaysConvert.ToInt16(AutoDeliveryInterval.SelectedValue) : _Product.SubscriptionPlan.PaymentFrequency;
                            basketItem.FrequencyUnit = _Product.SubscriptionPlan.PaymentFrequencyUnit;
                        }
                        else
                        {
                            basketItem.Frequency = _Product.SubscriptionPlan.PaymentFrequency;
                            basketItem.FrequencyUnit = _Product.SubscriptionPlan.PaymentFrequencyUnit;
                        }
                    }

                    // DETERMINE IF THE LICENSE AGREEMENT MUST BE REQUESTED
                    IList<LicenseAgreement> basketItemLicenseAgreements = new List<LicenseAgreement>();
                    basketItemLicenseAgreements.BuildCollection(basketItem, LicenseAgreementMode.OnAddToBasket);
                    if ((basketItemLicenseAgreements.Count > 0))
                    {
                        // THESE AGREEMENTS MUST BE ACCEPTED TO ADD TO CART
                        List<BasketItem> basketItems = new List<BasketItem>();
                        basketItems.Add(basketItem);
                        string guidKey = Guid.NewGuid().ToString("N");
                        Cache.Add(guidKey, basketItems, null, System.Web.Caching.Cache.NoAbsoluteExpiration, new TimeSpan(0, 10, 0), System.Web.Caching.CacheItemPriority.NotRemovable, null);
                        string acceptUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Basket.aspx"));
                        string declineUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Page.ResolveUrl(_Product.NavigateUrl)));
                        Response.Redirect("~/BuyWithAgreement.aspx?Items=" + guidKey + "&AcceptUrl=" + acceptUrl + "&DeclineUrl=" + declineUrl);
                    }

                    // THERE ARE NO AGREEMENTS, SO SAVE THIS ITEM INTO THE BASKET
                    Basket basket = AbleContext.Current.User.Basket;
                    basketItem.Price = InvoiceHelper.GetInvoiceExtendedPrice(basketItem);
                    basket.Items.Add(basketItem);
                    basket.Save();

                    // SHOW TOAST MESSAGE OF ITEM BEING ADDED TO CART
                    ToastMessage.Visible = true;
                    ToastMessage.Text = "Added Item to Cart";
                    ScriptManager.RegisterStartupScript(Page, this.GetType(), "CallMyFunction", "DisplayToastMessage()", true);

                    ////Determine if there are associated Upsell products
                    //if (basketItem.Product.GetUpsellProducts(basket).Count > 0)
                    //{
                    //    //redirect to upsell page
                    //    string returnUrl = AbleCommerce.Code.NavigationHelper.GetEncodedReturnUrl();
                    //    if(AbleContext.Current.StoreMode == StoreMode.Standard)
                    //        Response.Redirect("~/ProductAccessories.aspx?ProductId=" + basketItem.Product.Id + "&ReturnUrl=" + returnUrl);
                    //    else
                    //        Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Basket.aspx"));
                    //}

                    //// IF BASKET HAVE SOME VALIDATION PROBLEMS MOVE TO BASKET PAGE
                    //IBasketService service = AbleContext.Resolve<IBasketService>();
                    //ValidationResponse response = service.Validate(basket);
                    //if (!response.Success)
                    //{
                    //    Session["BasketMessage"] = response.WarningMessages;
                    //    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
                    //}

                    ////IF THERE IS NO REGISTERED BASKET CONTROL, WE MUST GO TO BASKET PAGE
                    //if (!AbleCommerce.Code.PageHelper.HasBasketControl(this.Page)) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
                }
            }
        }

        protected void AddToWishlistButton_Click(object sender, System.EventArgs e)
        {
            if (Page.IsValid && ValidateVariablePrice() && ValidateQuantity()
                && AllProductOptionsSelected() && RequiredKitOptionsSelected())
            {
                BasketItem wishlistItem = GetBasketItem(true);
                if (wishlistItem != null)
                {
                    if (_Product.IsSubscription)
                    {
                        if (_isOptionalSubscription)
                        {
                            wishlistItem.IsSubscription = AutoDeliveryRadio.Checked;
                        }
                        else
                            wishlistItem.IsSubscription = true;

                        if (wishlistItem.IsSubscription && _Product.SubscriptionPlan.IsRecurring)
                        {
                            wishlistItem.Frequency = _Product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional ? AlwaysConvert.ToInt16(AutoDeliveryInterval.SelectedValue) : _Product.SubscriptionPlan.PaymentFrequency;
                            wishlistItem.FrequencyUnit = _Product.SubscriptionPlan.PaymentFrequencyUnit;
                        }
                        else
                        {
                            wishlistItem.Frequency = _Product.SubscriptionPlan.PaymentFrequency;
                            wishlistItem.FrequencyUnit = _Product.SubscriptionPlan.PaymentFrequencyUnit;
                        }
                    }

                    // DETERMINE IF THE LICENSE AGREEMENT MUST BE REQUESTED
                    IList<LicenseAgreement> basketItemLicenseAgreements = new List<LicenseAgreement>();
                    basketItemLicenseAgreements.BuildCollection(wishlistItem, LicenseAgreementMode.OnAddToBasket);
                    if ((basketItemLicenseAgreements.Count > 0))
                    {
                        // THESE AGREEMENTS MUST BE ACCEPTED TO ADD TO CART
                        List<BasketItem> basketItems = new List<BasketItem>();
                        basketItems.Add(wishlistItem);
                        string guidKey = Guid.NewGuid().ToString("N");
                        Cache.Add(guidKey, basketItems, null, System.Web.Caching.Cache.NoAbsoluteExpiration, new TimeSpan(0, 10, 0), System.Web.Caching.CacheItemPriority.NotRemovable, null);
                        string acceptUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Members/MyWishlist.aspx"));
                        string declineUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Page.ResolveUrl(_Product.NavigateUrl)));
                        Response.Redirect("~/BuyWithAgreement.aspx?Items=" + guidKey + "&AcceptUrl=" + acceptUrl + "&DeclineUrl=" + declineUrl + "&ToWishlist=True");
                    }

                    Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
                    wishlist.WishlistItems.Add(wishlistItem);

                    //SET THE REQUIRED PARENT REFERENCE FOR ITEMS. WE ARE USING EXTENSIONS FOR ABOVE ADD METHOD WHICH CAN'T SET PARENT REFERENCE BY ITSELF
                    foreach (WishlistItem item in wishlist.WishlistItems)
                    {
                        item.Wishlist = wishlist;
                    }

                    wishlist.Save();

                    // SHOW TOAST MESSAGE OF ITEM BEING ADDED TO CART
                    ToastMessage.Visible = true;
                    ToastMessage.Text = "Added Item to Wishlist";
                    ScriptManager.RegisterStartupScript(Page, this.GetType(), "CallMyFunction", "DisplayToastMessage()", true);

                    // Response.Redirect("~/Members/MyWishlist.aspx");
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            //GET THE SELECTED KIT OPTIONS
            GetSelectedKitOptions();
            BasketItem existingItem = GetExistingBasketItem();
            WishlistItem wishlistItem = GetExistingWishlistItem();
            if (_Product != null)
            {
                //HANDLE PART/MODEL NUMBER ROW
                trPartNumber.Visible = (ShowPartNumber && (_Product.ModelNumber != string.Empty));
                if (trPartNumber.Visible)
                {
                    PartNumber.Text = _Product.ModelNumber;
                }

                //HANDLE GTIN NUMBER ROW
                trGTINNumber.Visible = (ShowGTIN && (_Product.GTIN != string.Empty));
                if (trGTINNumber.Visible)
                {
                    string gtinType = string.Empty;
                    switch (_Product.GTIN.Length)
                    {
                        case 8:
                            gtinType = "gtin8";
                            break;
                        case 13:
                            gtinType = "gtin13";
                            break;
                        case 14:
                            gtinType = "gtin14";
                            break;
                        default:
                            gtinType = "gtin13";
                            break;
                    }
                    GTINNumberLocalize.Text = string.Format(GTINNumberLocalize.Text, GTINName);
                    GTINNumber.Controls.Add(new LiteralControl(string.Format("<span itemprop='{0}'>{1}</span>", gtinType, _Product.GTIN)));
                }

                string optionList = ProductVariantDataSource.GetOptionList(_ProductId, _SelectedOptionChoices, true);
                //SET THE CURRENT CALCULATED PRICE
                OurPrice.Product = _Product;
                OurPrice.OptionList = optionList;
                OurPrice.SelectedKitProducts = _SelectedKitProducts;
                OneTimePrice.Product = _Product;
                OneTimePrice.OptionList = optionList;
                OneTimePrice.SelectedKitProducts = _SelectedKitProducts;
                SubscriptionPrice.Product = _Product;
                SubscriptionPrice.OptionList = optionList;
                SubscriptionPrice.SelectedKitProducts = _SelectedKitProducts;
                bool allProductOptionsSelected = (_SelectedOptionChoices.Count == _Product.ProductOptions.Count);
                bool requiredKitOptionsSelected = AbleCommerce.Code.ProductHelper.RequiredKitOptionsSelected(_Product, _SelectedKitProducts);
                InventoryManagerData inv = null;

                //UPDATE THE SKU AND RETAIL PRICE FOR THE SELECTED PRODUCT VARIANT
                if (_Product.ProductOptions.Count > 0 && _SelectedOptionChoices.Count > 0)
                {
                    ProductVariant variant = ProductVariantDataSource.LoadForOptionList(_ProductId, optionList);
                    ProductCalculator pcalc = ProductCalculator.LoadForProduct(_Product.Id, 1, optionList, AlwaysConvert.ToList(",", _SelectedKitProducts), AbleContext.Current.UserId, true, false);
                    if (variant != null)
                    {
                        Sku.Text = variant.Sku;
                        RegPrice.Text = pcalc.MSRP.LSCurrencyFormat("ulc");
                        trRegPrice.Visible = pcalc.MSRP > 0;
                        PartNumber.Text = variant.ModelNumber;
                        string gtinType = string.Empty;
                        switch (variant.GTIN.Length)
                        {
                            case 8:
                                gtinType = "gtin8";
                                break;
                            case 13:
                                gtinType = "gtin13";
                                break;
                            case 14:
                                gtinType = "gtin14";
                                break;
                            default:
                                gtinType = "gtin13";
                                break;
                        }
                        GTINNumber.Controls.Clear();
                        GTINNumber.Controls.Add(new LiteralControl(string.Format("<span itemprop='{0}'>{1}</span>", gtinType, variant.GTIN)));
                    }
                }

            if (_Product.SubscriptionPlan != null)
                AutoDeliveryOptionPH.Visible = _Product.SubscriptionPlan.IsRecurring && _Product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional && (!_isOptionalSubscription || (AutoDeliveryRadio.Checked));

            if (!_isOptionalSubscription)
            {
                //SHOW SUBSCRIPTIONS
                if (this.ShowPrice && this.ShowSubscription)
                {
                    SubscriptionPlan sp = _Product.SubscriptionPlan;
                    if (sp != null && sp.IsRecurring)
                    {
                        short frequency = _Product.SubscriptionPlan.PaymentFrequency;
                        if (_Product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional)
                            frequency = AlwaysConvert.ToInt16(AutoDeliveryInterval.SelectedValue);

                        // GET THE RECURRING PAYMENT MESSAGE FOR THIS PRODUCT
                        RecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(_Product.Price, _Product.TaxCode != null ? _Product.TaxCode.Id : 0, sp, frequency);
                        rowSubscription.Visible = true;
                    }

                    if (!Page.IsPostBack && existingItem != null && existingItem.IsSubscription)
                    {
                        BindAutoDelieveryOptions();
                        ListItem interval = AutoDeliveryInterval.Items.FindByValue(existingItem.Frequency.ToString());
                        if (interval != null)
                            interval.Selected = true;

                        // GET THE RECURRING PAYMENT MESSAGE FOR THIS PRODUCT
                        RecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(existingItem.Price, existingItem.TaxCode != null ? existingItem.TaxCode.Id : 0, sp, existingItem.Frequency);
                        rowSubscription.Visible = true;
                    }

                    if (!Page.IsPostBack && existingItem == null && wishlistItem != null && wishlistItem.IsSubscription)
                    {
                        if (_Product.SubscriptionPlan.IsRecurring)
                        {
                            BindAutoDelieveryOptions();
                            ListItem interval = AutoDeliveryInterval.Items.FindByValue(wishlistItem.Frequency.ToString());
                            if (interval != null)
                                interval.Selected = true;

                            // GET THE RECURRING PAYMENT MESSAGE FOR THIS PRODUCT
                            RecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(wishlistItem);
                            rowSubscription.Visible = true;
                        }
                        else
                        {
                            RecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(wishlistItem);
                            rowSubscription.Visible = true; 
                        }
                    }
                }

                OptionalSubscriptionPanel.Visible = false;
                OurSubscriptionPriceLabel.Visible = false;
            }
            else
            {
                if (AutoDeliveryRadio.Checked && _Product.SubscriptionPlan.IsRecurring)
                {
                    short frequency = _Product.SubscriptionPlan.PaymentFrequency;
                    if (_Product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional)
                        frequency = AlwaysConvert.ToInt16(AutoDeliveryInterval.SelectedValue);
                    OptionalRecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(_Product.Price, _Product.TaxCode != null ? _Product.TaxCode.Id : 0, _Product.SubscriptionPlan, frequency);
                }

                    OurSubscriptionPriceLabel.Visible = true;
                    rowSubscription.Visible = true;
                    OptionalSubscriptionPanel.Visible = true;
                    string description = _Product.SubscriptionPlan.Description;
                    if (!string.IsNullOrEmpty(description))
                        AutoDeliveryRadio.Text = description;
                    RecurringPaymentMessage.Visible = false;

                if (!Page.IsPostBack && existingItem != null && existingItem.IsSubscription)
                {
                    AutoDeliveryRadio.Checked = true;
                    BindAutoDelieveryOptions();
                    ListItem interval = AutoDeliveryInterval.Items.FindByValue(existingItem.Frequency.ToString());
                    if (interval != null)
                        interval.Selected = true;
                    OptionalRecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(existingItem.Price, existingItem.TaxCode != null ? existingItem.TaxCode.Id : 0, _Product.SubscriptionPlan, existingItem.Frequency);
                }
                else if (!Page.IsPostBack && existingItem != null)
                {
                    OneTimeDeliveryRadio.Checked = true;
                    AutoDeliveryRadio.Checked = false;
                    RecurringPaymentMessage.Visible = false;
                    OptionalRecurringPaymentMessage.Visible = false;
                    AutoDeliveryOptionPH.Visible = false;
                }

                if (!Page.IsPostBack && _Product.IsSubscription && existingItem == null)
                {
                    if (wishlistItem != null)
                    {
                        if (wishlistItem.IsSubscription)
                        {
                            if (_Product.SubscriptionPlan.IsRecurring)
                            {
                                AutoDeliveryRadio.Checked = true;
                                BindAutoDelieveryOptions();
                                ListItem interval = AutoDeliveryInterval.Items.FindByValue(wishlistItem.Frequency.ToString());
                                if (interval != null)
                                    interval.Selected = true;
                                OptionalRecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(wishlistItem);
                            }
                            else
                            {
                                AutoDeliveryRadio.Checked = true;
                                OptionalRecurringPaymentMessage.Text = AbleCommerce.Code.ProductHelper.GetRecurringPaymentMessage(wishlistItem);
                                OptionalRecurringPaymentMessage.Visible = true;
                                AutoDeliveryOptionPH.Visible = false;
                            }
                        }
                        else
                        {
                            OneTimeDeliveryRadio.Checked = true;
                            AutoDeliveryRadio.Checked = false;
                            RecurringPaymentMessage.Visible = false;
                            OptionalRecurringPaymentMessage.Visible = false;
                            AutoDeliveryOptionPH.Visible = false;
                        }
                    }
                }
            }

                CommerceBuilder.Stores.Store store = AbleContext.Current.Store;

                if (store.Settings.EnableInventory && store.Settings.InventoryDisplayDetails
                    && (_Product.InventoryMode != InventoryMode.None) && (!_Product.AllowBackorder))
                {
                    if (allProductOptionsSelected && requiredKitOptionsSelected)
                    {
                        IInventoryManager inventoryManager = AbleContext.Resolve<IInventoryManager>();
                        inv = inventoryManager.CheckStock(_ProductId, optionList, _SelectedKitProducts);
                        UpdateInventoryDetails(inv);
                    }
                    else
                    {
                        InventoryDetailsPanel.Controls.Clear();
                    }
                }

                HideAddToBasket();
                if (!_Product.DisablePurchase && !AbleContext.Current.Store.Settings.ProductPurchasingDisabled)
                {
                    if (requiredKitOptionsSelected)
                    {
                        if (inv != null)
                        {
                            if (inv.InventoryMode == InventoryMode.None || inv.InStock > 0 || inv.AllowBackorder)
                            {
                                ShowAddToBasket();
                            }
                        }
                        // IF NO VARIANT ARE AVAILABLE IN STOCK
                        else if (_Product.InventoryMode == InventoryMode.Variant && AvailableProductOptionsCount() == 0)
                        {
                            string outOfStockformat = AbleContext.Current.Store.Settings.InventoryOutOfStockMessage;
                            string outOfStockMessage = string.Format(outOfStockformat, 0);
                            InventoryDetailsPanel.Controls.Add(new LiteralControl(outOfStockMessage));

                            if (!string.IsNullOrEmpty(optionList))
                            {
                                ProductVariant variant = ProductVariantDataSource.LoadForOptionList(_ProductId, optionList);
                                if (variant != null
                                    && variant.AvailabilityDate.HasValue
                                    && variant.AvailabilityDate >= LocaleHelper.LocalNow)
                                {
                                    string availabilityMessageFormat = AbleContext.Current.Store.Settings.InventoryAvailabilityMessage;
                                    string availabilityMessage = string.Format(availabilityMessageFormat, variant.AvailabilityDate.Value.ToShortDateString());
                                    InventoryDetailsPanel.Controls.Add(new LiteralControl(string.Format("{0}", availabilityMessage)));
                                }
                            }
                        }
                        else
                        {
                            ShowAddToBasket();
                        }
                    }
                }
                AbleCommerce.Code.PageHelper.SetDefaultButton(Quantity, AddToBasketButton.ClientID);

                ViewState.Add("OptionDropDownIds", _OptionDropDownIds);
                ViewState.Add("OptionPickerIds", _OptionPickerIds);

                // check if we need to initialize dialog from existing item
                if (existingItem != null)
                {
                    AddToBasketButton.Visible = ShowAddAndUpdateButtons;
                    UpdateBasketButton.Visible = true;
                    Quantity.Text = existingItem.Quantity.ToString();
                    if (_Product.UseVariablePrice && !_Product.IsSubscription) VariablePrice.Text = existingItem.Price.ToString("F2");
                }

                // INCREASE PRODUCT DETIALS PANEL WIDTH WHEN BOTH ADD TO CART AND ADD TO WISHLIST BUTTONS ARE ENABLED
                if(AddToBasketButton.Visible && UpdateBasketButton.Visible && AddToWishlistButton.Visible)
                {
                    var control = PageHelper.RecursiveFindControl(this.Page, "productDetailsArea");
                    if(control != null)
                    {
                        HtmlGenericControl detailsPanel = (HtmlGenericControl)control;
                        detailsPanel.Attributes.Add("style", "width:310px;");
                    }
                }

                // UPDATE THE PRODUCT IMAGE
                if (Page.IsPostBack)
                {
                    // UPDATE THE PRODUCT VARIANT IMAGE IF AVAILABLE
                    if (!string.IsNullOrEmpty(optionList))
                    {
                        ProductVariant variant = ProductVariantDataSource.LoadForOptionList(_ProductId, optionList);
                        if (variant != null && !string.IsNullOrEmpty(variant.ImageUrl))
                        {
                            string originalImageUrl = variant.ImageUrl;
                            string imageUrl = string.Format("~/GetImage.ashx?Path={0}&maintainAspectRatio=true&maxHeight={1}&maxWidth={1}", Server.UrlEncode(originalImageUrl), 300);
                            ScriptManager.RegisterStartupScript(BuyProductPanel, typeof(string), "UpdateVariantImage", "{ var productImage = document.getElementById('ProductImage'); if(productImage != undefined) productImage.src = '" + Page.ResolveClientUrl(imageUrl) + "'; var productImageUrl = document.getElementById('ProductImageUrl'); if (productImageUrl != undefined) productImageUrl.href = '" + Page.ResolveClientUrl(originalImageUrl) + "'; }", true);
                        }
                    }
                }
                else
                {
                    // CHECK FOR DEFAULT OPTION CHOICE SELECTION AND UPDATE IMAGE IF NEEDED
                    if (_SelectedOptionChoices != null && _SelectedOptionChoices.Count > 0)
                    {
                        string originalImageUrl = string.Empty;
                        foreach (var key in _SelectedOptionChoices.Keys)
                        {
                            // update image for last choice
                            int choiceId = _SelectedOptionChoices[key];
                            OptionChoice choice = OptionChoiceDataSource.Load(choiceId);
                            if (choice != null && !string.IsNullOrEmpty(choice.ImageUrl)) originalImageUrl = choice.ImageUrl;
                        }

                        if (!string.IsNullOrEmpty(originalImageUrl))
                        {
                            string imageUrl = string.Format("~/GetImage.ashx?Path={0}&maintainAspectRatio=true&maxHeight={1}&maxWidth={1}", Server.UrlEncode(originalImageUrl), 300);
                            ScriptManager.RegisterStartupScript(BuyProductPanel, typeof(string), "UpdateChoiceImage", "{ var productImage = document.getElementById('ProductImage'); if(productImage != undefined) productImage.src = '" + Page.ResolveClientUrl(imageUrl) + "'; var productImageUrl = document.getElementById('ProductImageUrl'); if (productImageUrl != undefined) productImageUrl.href = '" + Page.ResolveClientUrl(originalImageUrl) + "'; }", true);
                        }
                    }
                }
            }
        }

        private BasketItem GetExistingBasketItem()
        {
            int basketItemId = AlwaysConvert.ToInt(Request.QueryString["ItemId"]);
            if (basketItemId <= 0) return null;
            Basket basket = AbleContext.Current.User.Basket;
            return basket.Items.FirstOrDefault(bi => bi.Id == basketItemId);
        }

        private WishlistItem GetExistingWishlistItem()
        {
            int wishlistItemId = AlwaysConvert.ToInt(Request.QueryString["ItemId"]);
            if (wishlistItemId <= 0) return null;
            Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
            if (wishlist == null) return null;
            return wishlist.WishlistItems.FirstOrDefault(wi => wi.Id == wishlistItemId);
        }

        protected void GetSelectedKitOptions()
        {
            if (Page.IsPostBack)
            {
                _SelectedKitProducts = new List<int>();
                //COLLECT ANY KIT VALUES
                foreach (ProductKitComponent pkc in _Product.ProductKitComponents)
                {
                    // FIND THE CONTROL
                    KitComponent component = pkc.KitComponent;
                    if (component.InputType == KitInputType.IncludedHidden)
                    {
                        foreach (KitProduct choice in component.KitProducts)
                        {
                            _SelectedKitProducts.Add(choice.Id);
                        }
                    }
                    else
                    {
                        WebControl inputControl = (WebControl)AbleCommerce.Code.PageHelper.RecursiveFindControl(this, component.UniqueId);
                        if (inputControl != null)
                        {
                            IList<int> kitProducts = component.GetControlValue(inputControl);
                            foreach (int selectedKitProductId in kitProducts)
                            {
                                _SelectedKitProducts.Add(selectedKitProductId);
                            }
                        }
                    }
                }
            }
            else
            {
                foreach (ProductKitComponent pkc in _Product.ProductKitComponents)
                {
                    // FIND THE CONTROL
                    KitComponent component = pkc.KitComponent;
                    if (component.InputType == KitInputType.IncludedHidden)
                    {
                        foreach (KitProduct choice in component.KitProducts)
                        {
                            _SelectedKitProducts.Add(choice.Id);
                        }
                    }
                }
                string kitList = Request.QueryString["Kits"];
                if (!string.IsNullOrEmpty(kitList))
                {
                    string[] kitOptions = kitList.Split(',');
                    if (kitOptions != null)
                    {
                        foreach (string kitOption in kitOptions)
                        {
                            KitProduct choice = KitProductDataSource.Load(AlwaysConvert.ToInt(kitOption)); 
                            if (choice != null && !_SelectedKitProducts.Contains(choice.Id))
                            {
                                _SelectedKitProducts.Add(choice.Id);
                            }
                        }
                    }
                }
            }
        }

        protected void OptionPicker_Load(object sender, EventArgs e)
        {
            OptionPicker op = (OptionPicker)sender;
            if (op != null)
            {
                int optionId = op.OptionId;
                Option opt = OptionDataSource.Load(optionId);
                if (opt != null && opt.ShowThumbnails)
                {
                    if (!_OptionPickerIds.Contains(optionId))
                    {
                        _OptionPickerIds.Add(optionId, op.UniqueID);
                    }
                    //Trace.Write(string.Format("OptionId:{0}   PickerId:{1}", optionId, op.UniqueID));
                    if (_SelectedOptionChoices.ContainsKey(optionId))
                    {
                        op.SelectedChoiceId = _SelectedOptionChoices[optionId];
                    }
                }
            }
        }

        protected void OptionChoices_DataBinding(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            if (ddl != null)
            {
                List<OptionChoiceItem> ds = (List<OptionChoiceItem>)ddl.DataSource;
                if (ds != null && ds.Count > 0)
                {
                    // ADD FIRST CHOICE EITHER EMPTY OR WITH THE SPECIFIED HEADER TEXT
                    int optionId = ds[0].OptionId;
                    Option opt = OptionDataSource.Load(optionId);
                    ddl.Items.Add(new ListItem(opt.HeaderText, string.Empty));
                }
            }
        }

        protected void OptionChoices_DataBound(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            if (ddl != null)
            {
                List<OptionChoiceItem> ds = (List<OptionChoiceItem>)ddl.DataSource;
                if (ds != null && ds.Count > 0)
                {
                    int optionId = ds[0].OptionId;
                    Option opt = OptionDataSource.Load(optionId); 

                    OptionChoiceItem oci = ds.FirstOrDefault<OptionChoiceItem>(c => c.Selected);
                    if (oci != null)
                    {
                        ListItem item = ddl.Items.FindByValue(oci.ChoiceId.ToString());
                        if (item != null)
                        {
                            ddl.ClearSelection();
                            item.Selected = true;
                        }
                    }


                    if (opt != null && !opt.ShowThumbnails)
                    {
                        if (!_OptionDropDownIds.Contains(optionId))
                        {
                            _OptionDropDownIds.Add(optionId, ddl.UniqueID);
                        }
                        if (_SelectedOptionChoices.ContainsKey(optionId))
                        {
                            ListItem selectedItem = ddl.Items.FindByValue(_SelectedOptionChoices[optionId].ToString());
                            if (selectedItem != null)
                            {
                                ddl.ClearSelection();
                                selectedItem.Selected = true;                                
                            }
                        }

                        StringBuilder imageScript = new StringBuilder();
                        imageScript.Append("<script type=\"text/javascript\">\n");
                        imageScript.Append("    var " + ddl.ClientID + "_Images = {};\n");
                        string imageUrl = string.Format("~/GetImage.ashx?Path={0}&maintainAspectRatio=true&maxHeight={1}&maxWidth={1}", Server.UrlEncode(_Product.ImageUrl), 300);
                        imageScript.Append("    var _DefaultImageUrl = '" + this.Page.ResolveUrl(imageUrl) + "';\n");

                        string tempUrl = string.Empty;
                        foreach (OptionChoice choice in opt.Choices)
                        {
                            if (!string.IsNullOrEmpty(choice.ImageUrl))
                            {
                                tempUrl = string.Format("~/GetImage.ashx?Path={0}&maintainAspectRatio=true&maxHeight={1}&maxWidth={1}", HttpUtility.UrlEncode(choice.ImageUrl), 300);
                                imageScript.Append("    " + ddl.ClientID + "_Images[" + choice.Id.ToString() + "] = '" + this.Page.ResolveUrl(tempUrl) + "';\n");
                            }
                        }
                        imageScript.Append("</script>\n");

                        ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
                        if (scriptManager != null)
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), ddl.ClientID, imageScript.ToString(), false);
                        }
                        else
                        {
                            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), ddl.ClientID, imageScript.ToString());
                        }
                    }
                }

                ddl.Attributes.Add("onChange", "OptionSelectionChanged('" + ddl.ClientID + "');");
            }
        }

        protected void TemplatesList_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            PlaceHolder phControl = e.Item.FindControl("phControl") as PlaceHolder;
            if (phControl != null)
            {
                InputField input = e.Item.DataItem as InputField;
                if (input != null)
                {
                    WebControl o = input.GetControl();
                    if (o != null)
                    {
                        BasketItem existingItem = GetExistingBasketItem();
                        if (existingItem != null)
                        {
                            BasketItemInput existingInput = existingItem.Inputs.FirstOrDefault(bi => bi.InputFieldId == input.Id);
                            if (existingInput != null)
                            {
                                switch (input.InputType)
                                {
                                    case InputType.TextBox:
                                        ((TextBox)o).Text = existingInput.InputValue;
                                        break;
                                    case InputType.TextArea:
                                        ((TextBox)o).Text = existingInput.InputValue;
                                        break;
                                    case InputType.Label:
                                        ((Label)o).Text = existingInput.InputValue;
                                        break;

                                    case InputType.DropDownListBox:
                                    case InputType.ListBox:
                                    case InputType.RadioButtonList:
                                        ListItem li = ((ListControl)o).Items.FindByValue(existingInput.InputValue);
                                        if (li != null)
                                        {
                                            ((ListControl)o).ClearSelection();
                                            li.Selected = true;
                                        }
                                        break;
                                    case InputType.MultipleListBox:
                                    case InputType.CheckBoxList:
                                        string[] values = existingInput.InputValue.Split(',');
                                        if (values != null)
                                        {
                                            ((ListControl)o).ClearSelection();
                                            foreach (string value in values)
                                            {
                                                li = ((ListControl)o).Items.FindByValue(value);
                                                if (li != null)
                                                    li.Selected = true;
                                            }
                                        }
                                        break;
                                }
                            }
                        }

                        phControl.Controls.Add(o);
                        if (input.IsRequired && input.InputType != InputType.Label)
                        {
                            if (input.InputType == InputType.CheckBoxList)
                            {
                                CheckboxListValidator validator = GetCheckboxValidatorControl(o, input.UserPrompt);
                                phControl.Controls.Add(validator);
                            }
                            else
                            {
                                RequiredFieldValidator validator = GetValidatorControl(o, input.UserPrompt);
                                phControl.Controls.Add(validator);
                            }
                        }
                    }
                }
            }
        }

        private CheckboxListValidator GetCheckboxValidatorControl(WebControl o, string prompt)
        {
            CheckboxListValidator validator = new CheckboxListValidator();
            validator.ControlToValidate = o.ID;
            validator.ErrorMessage = string.Format("Value is required for '{0}'.", prompt);
            validator.Text = "*";
            validator.ValidationGroup = "AddToBasket";
            return validator;
        }

        private RequiredFieldValidator GetValidatorControl(WebControl o, string prompt)
        {
            RequiredFieldValidator validator = new RequiredFieldValidator();
            validator.ControlToValidate = o.ID;
            validator.ErrorMessage = string.Format("Value is required for '{0}'.", prompt);
            validator.Text = "*";
            validator.ValidationGroup = "AddToBasket";
            return validator;
        }

        protected void KitsList_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            PlaceHolder phControl = e.Item.FindControl("phControl") as PlaceHolder;
            if (phControl != null)
            {
                ProductKitComponent pkc = e.Item.DataItem as ProductKitComponent;
                if (pkc != null)
                {
                    KitComponent component = pkc.KitComponent;
                    WebControl o = component.GetControl(IgnoreInventory);
                    if (o != null)
                    {
                        Type oType = o.GetType();
                        if (oType.Equals(typeof(RadioButtonList)))
                        {
                            ((RadioButtonList)o).AutoPostBack = true;
                        }
                        else if (oType.Equals(typeof(DropDownList)))
                        {
                            ((DropDownList)o).AutoPostBack = true;
                        }
                        else if (oType.Equals(typeof(CheckBoxList)))
                        {
                            ((CheckBoxList)o).AutoPostBack = true;
                        }
                        phControl.Controls.Add(o);
                        // SEE WHETHER A VALID VALUE FOR THIS FIELD IS PRESENT IN FORM POST
                        IList<int> theseOptions = component.GetControlValue(o);
                        _SelectedKitProducts.AddRange(theseOptions);

                        if (!Page.IsPostBack)
                        {
                            string kitList = Request.QueryString["Kits"];
                            if (!string.IsNullOrEmpty(kitList))
                            {
                                string[] _kitOptionChoices = kitList.Split(',');
                                if (_kitOptionChoices != null)
                                {
                                    ListControl list = o as ListControl;
                                    if (list != null)
                                    {
                                        list.ClearSelection();
                                    }
                                    foreach (string kitOptionChoice in _kitOptionChoices)
                                    {
                                        KitProduct choice = KitProductDataSource.Load(AlwaysConvert.ToInt(kitOptionChoice));
                                        if (choice != null)
                                        {
                                            if (choice.KitComponent == component)
                                            {
                                                if (list != null)
                                                {
                                                    ListItem item = list.Items.FindByValue(choice.Id.ToString());
                                                    if (item != null)
                                                    {  
                                                        item.Selected = true;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        protected string GetKitComponentName(Object obj)
        {
            ProductKitComponent component = obj as ProductKitComponent;
            if (component != null)
            {
                return component.KitComponent.Name;
            } 
            return string.Empty;
        }

        protected Dictionary<int, int> GetSelectedOptionChoices()
        {
            HttpRequest request = HttpContext.Current.Request;
            Dictionary<int, int> selectedChoices = new Dictionary<int, int>();
            if (Page.IsPostBack)
            {
                foreach (int key in _OptionDropDownIds.Keys)
                {
                    string value = (string)_OptionDropDownIds[key];
                    Trace.Write(string.Format("Checking For - OptionId:{0}  DropDownId:{1}", key, value));
                    string selectedChoice = request.Form[value];
                    if (!string.IsNullOrEmpty(selectedChoice))
                    {
                        int choiceId = AlwaysConvert.ToInt(selectedChoice);
                        if (choiceId != 0)
                        {
                            Trace.Write(string.Format("Found Selected Choice : {0}  -  {1}", key, choiceId));
                            selectedChoices.Add(key, choiceId);
                        }
                    }
                }

                foreach (int key in _OptionPickerIds.Keys)
                {
                    string value = (string)_OptionPickerIds[key];
                    Trace.Write(string.Format("Checking For - OptionId:{0}  PickerId:{1}", key, value));
                    string selectedChoice = request.Form[value];
                    if (!string.IsNullOrEmpty(selectedChoice))
                    {
                        int choiceId = AlwaysConvert.ToInt(selectedChoice);
                        if (choiceId != 0)
                        {
                            Trace.Write(string.Format("Found Selected Choice : {0}  -  {1}", key, choiceId));
                            selectedChoices.Add(key, choiceId);
                        }
                    }
                }
            }
            else
            {
                string optionList = Request.QueryString["Options"];
                if (!string.IsNullOrEmpty(optionList))
                {
                    string[] optionChoices = optionList.Split(',');
                    if (optionChoices != null)
                    {
                        foreach (string optionChoice in optionChoices)
                        {
                            OptionChoice choice = OptionChoiceDataSource.Load(AlwaysConvert.ToInt(optionChoice));
                            if (choice != null)
                            {
                                _SelectedOptionChoices.Add(choice.OptionId, choice.Id);
                            }
                        }

                        return _SelectedOptionChoices;
                    }
                }
                else
                {
                    // CHECK FOR DEFAULT SELECTED CHOICES
                    IList<ProductOption> productOptions = _Product.ProductOptions;
                    foreach (ProductOption pOption in productOptions)
                    {
                        Option option = pOption.Option;
                        foreach (OptionChoice choice in option.Choices)
                        {
                            if (choice.Selected)
                            {
                                _SelectedOptionChoices.Add(option.Id, choice.Id);
                                break;
                            }
                        }
                    }

                    return _SelectedOptionChoices;
                }
            }

            return selectedChoices;
        }

        protected IList<ProductOption> GetProductOptions()
        {
            if (_Product == null)
                return new List<ProductOption>();
            return _Product.ProductOptions;
        }

        protected IList<InputField> GetProductTemplateFields()
        {
            List<InputField> inputFields = new List<InputField>();
            if (_Product == null) return inputFields;

            foreach (ProductTemplate template in _Product.ProductTemplates)
            {
                if (template != null)
                {
                    foreach (InputField input in template.InputFields)
                    {
                        if (!input.IsMerchantField)
                        {
                            inputFields.Add(input);
                        }
                    }
                }
            }
            return inputFields;
        }

        protected string GetUserPrompt(Object obj)
        {
            InputField input = obj as InputField;
            if (input != null)
            {
                return input.UserPrompt;
            }
            return string.Empty;
        }

        protected IList<ProductKitComponent> GetProductKitComponents()
        {
            if (_Product == null)
                return new List<ProductKitComponent>();
            return _Product.ProductKitComponents;
        }

        protected List<OptionChoiceItem> GetOptionChoices(Object objOption, int index)
        {
            ProductOption productOption = objOption as ProductOption;
            if (productOption == null)
                return GetOptionChoiceValues(new List<OptionChoice>());

            IList<OptionChoice> availableChoices;

            if (!ShowAllOptions && index < ProductVariant.MAXIMUM_ATTRIBUTES)
            {
                availableChoices = OptionChoiceDataSource.GetAvailableChoices(_Product.Id, productOption.OptionId, _SelectedOptionChoices);
            }
            else
            {
                availableChoices = productOption.Option.Choices;
            }

            return GetOptionChoiceValues(availableChoices);
        }

        protected List<OptionChoiceItem> GetOptionChoiceValues(IList<OptionChoice> optCol)
        {
            List<OptionChoiceItem> optChoiceValues = new List<OptionChoiceItem>();
            foreach (OptionChoice oc in optCol)
            {
                string choiceName = GetOptionChoiceName(oc);
                string choiceId = GetOptionChoiceId(oc);
                optChoiceValues.Add(new OptionChoiceItem(oc.OptionId, choiceId, choiceName, oc.Selected));
            }
            return optChoiceValues;
        }

        protected string GetOptionChoiceName(Object obj)
        {
            OptionChoice choice = obj as OptionChoice;
            if (choice == null) return string.Empty;

            string modifierStr = string.Empty;
            if (choice.PriceModifier.HasValue && choice.PriceModifier != 0)
            {
                string plus = choice.PriceModifier > 0 ? "+" : "";                       
                modifierStr = string.Format(" ({0})", plus + choice.PriceModifier.LSCurrencyFormat("ulc"));
            }
            return choice.Name + modifierStr;
        }

        protected string GetOptionChoiceId(Object obj)
        {
            OptionChoice choice = obj as OptionChoice;
            if (choice == null) return string.Empty;
            if (choice.Id == 0) return string.Empty;
            return choice.Id.ToString();
        }

        protected string GetOptionName(Object obj)
        {
            ProductOption productOption = obj as ProductOption;
            if (productOption == null) return string.Empty;
            return productOption.Option.Name;
        }

        protected string GetOptionHeaderText(Object obj)
        {
            ProductOption productOption = obj as ProductOption;
            if (productOption == null) return string.Empty;
            return productOption.Option.HeaderText;
        }

        protected void BindAutoDelieveryOptions()
        {
            if (_Product.SubscriptionPlan != null)
            {
                string[] vals = _Product.SubscriptionPlan.OptionalPaymentFrequencies.Split(',');
                PaymentFrequencyUnit unit = _Product.SubscriptionPlan.PaymentFrequencyUnit;
                AutoDeliveryInterval.Items.Clear();
                if (vals != null && vals.Length > 0)
                {
                    foreach (string val in vals)
                    {
                        var item = AlwaysConvert.ToInt(val);
                        if (item > 0)
                        {
                            string text = string.Format("{0} {1}{2}", item, unit, item > 1 ? "s" : string.Empty);
                            AutoDeliveryInterval.Items.Add(new ListItem(text, item.ToString()));
                        }
                    }
                }
            }
        }

        protected class OptionChoiceItem
        {
            public OptionChoiceItem()
            {
            }

            public OptionChoiceItem(int optionId, string choiceId, string choiceName, bool selected)
            {
                _OptionId = optionId;
                _ChoiceId = choiceId;
                _ChoiceName = choiceName;
                Selected = selected;
            }

            int _OptionId;
            public int OptionId
            {
                get { return _OptionId; }
                set { _OptionId = value; }
            }

            string _ChoiceName = string.Empty;
            public string ChoiceName
            {
                get { return _ChoiceName; }
                set { _ChoiceName = value; }
            }

            string _ChoiceId = string.Empty;
            public string ChoiceId
            {
                get { return _ChoiceId; }
                set { _ChoiceId = value; }
            }

            public bool Selected { get; set; }
        }

        protected void NotificationsLink_Click(object sender, EventArgs e)
        {
            // hide the link and show the input fields            
            NotificationsLink.Visible = false;

            UserEmailLabel.Visible = true;
            if (!AbleContext.Current.User.IsAnonymous) UserEmail.Text = AbleContext.Current.User.Email;
            UserEmail.Visible = true;
            UserEmail.Visible = true;
            UserEmailValidator.Visible = true;
            NotifySubscribeButton.Visible = true;
        }

        protected void NotifySubscribeButton_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string optionList = ProductVariantDataSource.GetOptionList(_ProductId, _SelectedOptionChoices, true);
            ProductVariant productVariant = ProductVariantDataSource.LoadForOptionList(_ProductId, optionList);

            // save the input if not already exists
            
            if ( productVariant != null && !productVariant.IsTransient() && RestockNotifyDataSource.LoadVariantForEmail(productVariant.Id, UserEmail.Text) == null)
            {
                RestockNotify notification = new RestockNotify(_Product, productVariant, UserEmail.Text);
                notification.Save();
            }
            else if ((productVariant == null || productVariant.IsTransient()) && RestockNotifyDataSource.LoadForEmail(_Product.Id, UserEmail.Text) == null)
            {
                RestockNotify notification = new RestockNotify(_Product, null, UserEmail.Text);
                notification.Save();
            }

            // hide the input fields and link and show the message
            NotificationsLink.Visible = false;
            UserEmailLabel.Visible = false;
            UserEmail.Visible = false;
            UserEmailValidator.Visible = false;
            NotifySubscribeButton.Visible = false;

            SubscribedMessage.Text = string.Format(SubscribedMessage.Text, UserEmail.Text);
            RestockNotificationSubscribedMessagePanel.Visible = true;
            InventoryRestockNotificationsPanel.Visible = false;

            notifySubscribeButtonClicked = true;
        }
    }
}