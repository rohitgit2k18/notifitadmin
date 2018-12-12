namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.UI;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    [Description("Implements the shipping estimate control for a basket.")]
    public partial class BasketShippingEstimate : System.Web.UI.UserControl, ISidebarControl
    {
        private User _User;
        private Basket _Basket;
        private Address _BillingAddress;
        private bool _AssumeCommercialRates = false;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("If true city field is displayed")]
        public bool ShowCity
        {
            get { return phCityField.Visible; }
            set { phCityField.Visible = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Shipping Estimate")]
        [Description("The caption to show for the shipping estimate section")]
        public string Caption
        {
            get { return phCaption.Text; }
            set { phCaption.Text = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("To estimate shipping charges, enter the delivery information below.")]
        [Description("The instruction text to show for the shipping estimate section")]
        public string InstructionText
        {
            get { return phInstructionText.Text; }
            set { phInstructionText.Text = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("If true commercial rates are assumed")]
        public bool AssumeCommercialRates
        {
            get { return _AssumeCommercialRates; }
            set { _AssumeCommercialRates = value; }
        }

        private int _ShipmentCount = 0;
        private bool MultiShipmentDisplay
        {
            get { return _ShipmentCount > 1; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // INTIALIZE GLOBAL POINTERS
            _User = AbleContext.Current.User;
            _Basket = _User.Basket;
            _BillingAddress = _User.PrimaryAddress;
            if (_BillingAddress == null) _BillingAddress = new Address();

            // INITIALIZE FORM
            InitializeCountries();
            bool isnonUSAddress = (Country.SelectedValue != "US");
            InitializeProvinces();
            if (phProvinceField.Visible && isnonUSAddress)
            {
                ProvinceLabel.Text = ProvinceLabel.Text.Replace("State", "Province");
                ProvinceRequired.ErrorMessage = ProvinceRequired.ErrorMessage.Replace("State", "Province");
            }
            phCityField.Visible = this.ShowCity;
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            phPostalCodeField.Visible = (Array.IndexOf(countries, Country.SelectedValue) > -1);
            if (phPostalCodeField.Visible)
            {
                // POPULATE THE POSTAL CODE ON THE FIRST VISIT
                if (!Page.IsPostBack) PostalCode.Text = _BillingAddress.PostalCode;

                // REPLACE US SPECIFIC TEXT TOKENS
                if (isnonUSAddress)
                {
                    PostalCodeLabel.Text = PostalCodeLabel.Text.Replace("ZIP", "Postal Code");
                    PostalCodeRequired.ErrorMessage = PostalCodeRequired.ErrorMessage.Replace("ZIP", "Postal");
                }
            }
            AbleCommerce.Code.PageHelper.DisableValidationScrolling(this.Page);
        }

        #region Form Initialization
        private void InitializeCountries()
        {
            // POPULATE THE COUNTRY DROPDOWN
            Country.DataSource = AbleCommerce.Code.StoreDataHelper.GetCountryList();
            Country.DataBind();

            bool foundCountry = false;
            if (Page.IsPostBack)
            {
                // ON POSTBACK, TRY TO USE THE POSTED COUNTRY VALUE
                foundCountry = SelectCountry(Request.Form[Country.UniqueID]);
            }

            // HANDLE FIRST VISIT OR INVALID POSTBACK
            if (!foundCountry)
            {
                // ON FIRST VISIT TRY TO USE THE USER BILLING COUNTRY
                if (!SelectCountry(_BillingAddress.CountryCode))
                {
                    // IF USER BILLING COUNTRY IS INVALID, TRY TO USE THE STORE COUNTRY
                    SelectCountry(AbleContext.Current.Store.DefaultWarehouse.CountryCode);
                }
            }
        }

        /// <summary>
        /// Attempts to select the specified country in the country list
        /// </summary>
        /// <param name="countryCode">The country code to select</param>
        /// <returns>True if the country is found and selected, false otherwise.</returns>
        private bool SelectCountry(string countryCode)
        {
            ListItem selectedCountry = Country.Items.FindByValue(countryCode);
            if (selectedCountry != null)
            {
                Country.SelectedIndex = Country.Items.IndexOf(selectedCountry);
                return true;
            }
            return false;
        }

        private void InitializeProvinces()
        {
            // LOAD PROVINCES FOR CURRENTLY SELECTED COUNTRY
            IList<Province> provinces = ProvinceDataSource.LoadForCountry(Country.SelectedValue, "Name");
            if (provinces.Count > 0)
            {
                // PROVINCES ARE FOUND, SO SHOW THE SELECTION
                phProvinceField.Visible = true;
                Province.Items.Add(string.Empty);
                foreach (Province province in provinces)
                {
                    string provinceValue = (!string.IsNullOrEmpty(province.ProvinceCode) ? province.ProvinceCode : province.Name);
                    Province.Items.Add(new ListItem(province.Name, provinceValue));
                }

                // ATTEMPT TO SELECT THE CORRECT PROVINCE
                bool foundProvince = false;
                if (Page.IsPostBack)
                {
                    // ON POSTBACK, TRY TO USE THE POSTED COUNTRY VALUE
                    foundProvince = SelectProvince(Request.Form[Province.UniqueID]);
                }

                // ON FIRST VISIT (OR INVALID POSTBACK) TRY TO USE THE USER BILLING COUNTRY
                if (!foundProvince)
                {
                    SelectProvince(_BillingAddress.Province);
                }
            }
        }

        /// <summary>
        /// Attempts to select the specified province in the country list
        /// </summary>
        /// <param name="provinceValue">The province value to select</param>
        /// <returns>True if the province is found and selected, false otherwise.</returns>
        private bool SelectProvince(string provinceValue)
        {
            ListItem selectedProvince = Province.Items.FindByValue(provinceValue);
            if (selectedProvince != null)
            {
                Province.SelectedIndex = Province.Items.IndexOf(selectedProvince);
                return true;
            }
            return false;
        }
        #endregion

        private Address _EstimateAddress;
        protected void SubmitButton_Click(object sender, System.EventArgs e)
        {
            if (Page.IsValid && PostalCodeIsValid())
            {
                // ENSURE THE BASKET IS PACKAGED
                IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                preCheckoutService.Package(_Basket);
                _ShipmentCount = _Basket.Shipments.Count;

                // BUILD THE ADDRESS OBJECT TO USE FOR THE RATE ESTIMATE
                _EstimateAddress = new Address();
                _EstimateAddress.CountryCode = Country.SelectedValue;
                if (phProvinceField.Visible) _EstimateAddress.Province = Province.SelectedValue;
                if (phCityField.Visible) _EstimateAddress.City = StringHelper.StripHtml(City.Text);
                if (phPostalCodeField.Visible)
                {
                    string safePostalCode = StringHelper.StripHtml(PostalCode.Text);
                    safePostalCode = Regex.Replace(safePostalCode.ToUpperInvariant(), "[^-A-Z0-9]", string.Empty);
                    PostalCode.Text = safePostalCode;
                    _EstimateAddress.PostalCode = safePostalCode;
                }
                _EstimateAddress.Residence = _User.IsAnonymous ? !this.AssumeCommercialRates : _BillingAddress.Residence;

                // PREPARE AND DISPLAY THE RATE QUOTE INFORMATION
                phResultPanel.Visible = true;
                MultipleShipmentsMessage.Visible = this.MultiShipmentDisplay;
                ShipmentList.DataSource = _Basket.Shipments;
                ShipmentList.DataBind();
            }
        }

        /// <summary>
        /// Performs server side validation of the postal code format
        /// </summary>
        /// <returns>True if the postal code is valid, false otherwise.</returns>
        private bool PostalCodeIsValid()
        {
            if (phPostalCodeField.Visible)
            {
                // VALIDATE POSTAL CODES FOR US AND CA IF REQUIRED
                String safePostalCode = PostalCode.Text;
                safePostalCode = Regex.Replace(safePostalCode.ToUpperInvariant(), "[^-A-Z0-9]", string.Empty);
                if (Country.Text == "US" && !(Regex.Match(safePostalCode, "^\\d{5}(-\\d{4})?$").Success))
                {
                    CustomValidator postalCodeValidator = new CustomValidator();
                    postalCodeValidator.ControlToValidate = "PostalCode";
                    postalCodeValidator.ErrorMessage = "You must enter a valid US ZIP (#####) or (#####-####)";
                    postalCodeValidator.Text = "*";
                    postalCodeValidator.IsValid = false;
                    postalCodeValidator.ValidationGroup = "Estimate";
                    phPostalCodeValidator.Controls.Add(postalCodeValidator);
                }
                else if (Country.Text == "CA" && !(Regex.Match(safePostalCode, "^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$").Success))
                {
                    CustomValidator postalCodeValidator = new CustomValidator();
                    postalCodeValidator.ControlToValidate = "PostalCode";
                    postalCodeValidator.ErrorMessage = "You must enter a valid CA ZIP (A#A #A#)";
                    postalCodeValidator.Text = "*";
                    postalCodeValidator.IsValid = false;
                    postalCodeValidator.ValidationGroup = "Estimate";
                    phPostalCodeValidator.Controls.Add(postalCodeValidator);
                }
            }
            return (phPostalCodeValidator.Controls.Count == 0);
        }

        protected void ShipmentList_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // IF THERE ARE MULTIPLE SHIPMENTS, SHOW THE MULTI SHIPMENT HEADER
            if (this.MultiShipmentDisplay)
            {
                PlaceHolder MultiShipmentHeader = e.Item.FindControl("MultiShipmentHeader") as PlaceHolder;
                if (MultiShipmentHeader != null) MultiShipmentHeader.Visible = true;
            }

            // PREPARE AND DISPLAY SHIPPING ESTIMATE FOR THIS SHIPMENT
            GridView ShipRateGrid = e.Item.FindControl("ShipRateGrid") as GridView;
            if (ShipRateGrid != null)
            {
                BasketShipment shipment = e.Item.DataItem as BasketShipment;
                if (shipment != null)
                {
                    // CREATE AN ADDRESS INSTANCE TO HOLD ESTIMATE DESTINATION
                    // PRESERVE THE CURRENT SHIPPING ADDRESS
                    Address savedAddress = shipment.Address;
                    // TEMPORARILY ASSIGN THE ESTIMATE ADDRESS TO THIS SHIPMENT
                    shipment.SetAddress(_EstimateAddress);
                    // GET THE RATE QUOTES AND BIND TO THE TABLE
                    ShipRateGrid.DataSource = AbleContext.Resolve<IShipRateQuoteCalculator>().QuoteForShipment(shipment);
                    ShipRateGrid.DataBind();
                    // RESTORE THE SAVED ADDRESS
                    shipment.SetAddress(savedAddress);
                }
            }
        }

        protected List<BasketItem> GetShipmentProducts(object dataItem)
        {
            List<BasketItem> products = new List<BasketItem>();
            BasketShipment shipment = dataItem as BasketShipment;
            if (shipment != null)
            {
                foreach (BasketItem item in _Basket.Items)
                {
                    if (item.ShipmentId == shipment.Id
                        && item.OrderItemType == OrderItemType.Product) products.Add(item);
                }
            }
            return products;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // HIDE THE SHIPPING ESTIMATOR WHEN NO SHIPPING ITEMS IN BASKET
            // THIS IS DONE IN PRERENDER TO ACCOUNT FOR ANY ITEMS ADDED TO THE BASKET ON POSTBACK
            ShippingEstimatePanel.Visible = _Basket.Items.HasShippableProducts();

            // IF THE COUNTRY HAS CHANGED, CLEAR OUT ANY EXISTING POSTAL CODE VALUE
            if (Request.Form["__EVENTTARGET"] == Country.UniqueID) PostalCode.Text = string.Empty;
        }
    }
}