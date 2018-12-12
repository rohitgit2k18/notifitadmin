namespace AbleCommerce.Checkout
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Shipping.Providers;
    using System.Linq;

    public partial class EditAddress : CommerceBuilder.UI.AbleCommercePage
    {
        private int _addressId;
        private IAddressValidatorService _addressValidator = null;

        public List<ValidAddress> ValidAddresses
        {
            get
            {
                return Session["VALID_ADDRESSES"] as List<ValidAddress>;
            }

            set
            {
                Session["VALID_ADDRESSES"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            if (user.IsAnonymous)
            {
                Response.Redirect("~/Checkout/Default.aspx");
                return;
            }

            GetAddressId();
            _addressValidator = AddressValidatorServiceLocator.Locate();
            AddressValidationPanel.Visible = _addressValidator != null;
            if (!Page.IsPostBack)
            {
                ShowEditShipToPanel(_addressId);
            }
        }

        private void GetAddressId()
        {
            _addressId = AlwaysConvert.ToInt(Request.QueryString["AddressId"]);

            // CHECK FOR HIDDEN FIELD IF NOT FOUND IN QUERY STRING
            if (_addressId == 0) _addressId = AlwaysConvert.ToInt(HiddenAddressId.Value);
        }

        # region Add/Edit addresses

        protected void ShowEditShipToPanel(int addressId)
        {
            Country.DataSource = CountryDataSource.LoadAll("Name");
            Country.DataBind();
            Address address = AddressDataSource.Load(addressId);
            InitAddressForm(address);
            if (address == null)
            {
                // ADD NEW ADDRESS
                AddCaption.Visible = true;
                EditCaption.Visible = false;
            }
            else
            {
                // EDIT ADDRESS
                AddCaption.Visible = false;
                EditCaption.Visible = true;
            }
        }

        protected void InitAddressForm(Address address)
        {
            ValidAddressesPanel.Visible = false;
            ValidAddressesList.Items.Clear();
            string newCountryCode;
            if (address == null)
            {
                FirstName.Text = string.Empty;
                LastName.Text = string.Empty;
                Company.Text = string.Empty;
                Address1.Text = string.Empty;
                Address2.Text = string.Empty;
                City.Text = string.Empty;
                Province.Text = string.Empty;
                PostalCode.Text = string.Empty;
                Phone.Text = string.Empty;
                Fax.Text = string.Empty;
                IsBusiness.Checked = false;
                newCountryCode = GetDefaultCountryCode();
            }
            else
            {
                FirstName.Text = address.FirstName;
                LastName.Text = address.LastName;
                Company.Text = address.Company;
                Address1.Text = address.Address1;
                Address2.Text = address.Address2;
                City.Text = address.City;
                Province.Text = address.Province;
                PostalCode.Text = address.PostalCode;
                Phone.Text = address.Phone;
                Fax.Text = address.Fax;
                IsBusiness.Checked = !address.Residence;
                if (string.IsNullOrEmpty(address.CountryCode))
                    address.CountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                newCountryCode = address.CountryCode;
            }
            ListItem defaultCountry = Country.Items.FindByValue(newCountryCode);
            if (defaultCountry != null) Country.SelectedIndex = Country.Items.IndexOf(defaultCountry);
            CountryChanged(null, null);            
        }

        protected void CountryChanged(object sender, EventArgs e)
        {
            //SEE WHETHER POSTAL CODE IS REQUIRED
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            PostalCodeRequired.Enabled = (Array.IndexOf(countries, Country.SelectedValue) > -1);
            USPostalCodeRequired.Enabled = (Country.SelectedValue == "US");
            CAPostalCodeRequired.Enabled = (Country.SelectedValue == "CA");
            //LOAD PROVINCES FOR SELECTED COUNTRY
            IList<Province> provinces = ProvinceDataSource.LoadForCountry(Country.SelectedValue, "Name");
            //WE WANT TO SHOW THE DROP DOWN IF THE COUNTRY HAS BEEN CHANGED BY THE CLIENT
            //AND ALSO IF PROVINCES ARE AVAILABLE FOR THIS COUNTRY
            if (provinces.Count > 0)
            {
                Province.Visible = false;
                ProvinceRequired.Enabled = false;
                Province2.Visible = true;
                Province2.Items.Clear();
                Province2.Items.Add(string.Empty);
                foreach (Province province in provinces)
                {
                    string provinceValue = (!string.IsNullOrEmpty(province.ProvinceCode) ? province.ProvinceCode : province.Name);
                    Province2.Items.Add(new ListItem(province.Name, provinceValue));
                }
                ListItem selectedProvince = Province2.Items.FindByValue(Province.Text);
                if (selectedProvince != null) selectedProvince.Selected = true;
                Province2Required.Enabled = true;
            }
            else
            {
                //WE ONLY WANT A TEXTBOX TO SHOW
                //REQUIRE THE TEXTBOX IF THERE ARE PROVINCES
                Province.Visible = true;
                ProvinceRequired.Enabled = (provinces.Count > 0);
                Province.Visible = true;
                Province2.Visible = false;
                Province2.Items.Clear();
                Province2Required.Enabled = false;
                //NOW THAT A TEXTBOX IS SHOWN, RESET THE FLAG TO DISPLAY DROPDOWN
                // _ShowProvinceList = false;
            }
            
            //UPDATE THE LAST SELECTED COUNTRY
            //_SelectedCountryCode = Country.SelectedValue;
        }

        private string GetDefaultCountryCode()
        {
            string defaultCountry = AbleContext.Current.User.PrimaryAddress.CountryCode;
            if (!string.IsNullOrEmpty(defaultCountry)) return defaultCountry;
            return AbleContext.Current.Store.DefaultWarehouse.CountryCode;
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string buttonId = ((Button)sender).ID;
                string formattedProvinceName;
                if (ValidateProvince(Country, Province, Province2, out formattedProvinceName))
                {
                    Address address = GetAddressToEdit();
                    string address1 = StringHelper.StripHtml(Address1.Text);
                    string address2 = StringHelper.StripHtml(Address2.Text);
                    string city = StringHelper.StripHtml(City.Text);
                    string postalCode = StringHelper.StripHtml(PostalCode.Text);
                    if (address.Address1 != address1 || address.Address2 != address2 || address.City != city || address.Province != formattedProvinceName || address.PostalCode != postalCode)
                        address.Validated = false;

                    if (buttonId == "UseValidAddressButton")
                    {
                        int id = AlwaysConvert.ToInt(ValidAddressesList.SelectedValue);
                        address.Validated = true;

                        if (id > 0)
                        {
                            if (ValidAddresses != null && buttonId == "UseValidAddressButton")
                            {
                                ValidAddress validAddress = (from va in ValidAddresses where va.Id == id select va).SingleOrDefault();
                                if (validAddress != null)
                                {
                                    address1 = validAddress.Address1;
                                    address2 = validAddress.Address2;
                                    city = validAddress.City;
                                    formattedProvinceName = validAddress.Province;
                                    postalCode = validAddress.PostalCode;
                                }
                            }
                        }

                        ValidAddresses = null;
                    }

                    address.FirstName = StringHelper.StripHtml(FirstName.Text);
                    address.LastName = StringHelper.StripHtml(LastName.Text);
                    address.Address1 = address1;
                    address.Address2 = address2;
                    address.Company = StringHelper.StripHtml(Company.Text);
                    address.City = city;
                    address.Province = formattedProvinceName;
                    address.PostalCode = postalCode;
                    address.CountryCode = Country.SelectedValue;
                    address.Phone = StringHelper.StripHtml(Phone.Text);
                    address.Fax = StringHelper.StripHtml(Fax.Text);
                    address.Residence = !IsBusiness.Checked;
                    
                    if(_addressId == 0)
                    {
                        User user = AbleContext.Current.User;
                        address.User = user;
                        user.Addresses.Add(address);
                    }
                    address.Save();

                    // cache for future requests
                    _addressId = address.Id;
                    HiddenAddressId.Value = _addressId.ToString();

                    if (!address.Validated && _addressValidator != null)
                    {
                        AddressValidationResponse avr = _addressValidator.ValidateAddress(address);
                        if (avr != null)
                        {
                            if (!avr.IsValid.HasValue || !avr.IsValid.Value)
                            {
                                ValidAddresses = avr.Addresses;
                                if (ValidAddresses != null)
                                {
                                    int index = 0;
                                    foreach (ValidAddress validAddress in ValidAddresses)
                                    {
                                        validAddress.Id = ++index;
                                    }

                                    // ShowEditShipToPanel(address.Id);

                                    ValidAddressesList.DataSource = ValidAddresses;
                                    ValidAddressesList.DataBind();
                                    ValidAddressesPanel.Visible = true;
                                    ValidAddressesList.Items.Add(new ListItem("Use the address exactly as I entered it", "0"));
                                    ValidAddressesList.Items[0].Selected = true;
                                    if (ValidAddressesList.Items.Count > 1)
                                    {
                                        PHAddressFound.Visible = true;
                                        PHNoAddress.Visible = false;
                                    }
                                    else
                                    {
                                        PHAddressFound.Visible = false;
                                        PHNoAddress.Visible = true;
                                    }

                                    return;
                                }
                            }
                        }
                    }

                    // GET REDIRECTION OPTION
                    string option = Request.QueryString["R"];
                    if (!string.IsNullOrEmpty(option))
                    {
                        // REDIRECT TO SHIP METHOD PAGE
                        if (option.ToUpper() == "SM")
                        {
                            User user = AbleContext.Current.User;
                            
                            // RESET BASKET PACKAGING
                            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                            preCheckoutService.Package(user.Basket, true);
                            
                            // UPDATE DESTINATION TO SELECTED ADDRESS AND REDIRECT
                            foreach (BasketShipment shipment in user.Basket.Shipments)
                            {
                                shipment.Address = address;
                            }

                            user.Basket.Save();
                            Response.Redirect("ShipMethod.aspx");
                        }
                        else if (option.ToUpper() == "MS")
                        {
                            // REDIRECT TO MULTIPLE SHIPMENTS
                            Response.Redirect(Page.ResolveUrl("~/Checkout/ShipAddresses.aspx"));
                        }
                    }

                    //REBUILD ADDRESS BOOK
                    Response.Redirect("ShipAddress.aspx");
                }
                else
                {
                    Province2Required.IsValid = false;
                    CountryChanged(null, null);
                }
            }
        }

        protected void CancelValidAddressButton_Click(Object sender, EventArgs e)
        {
            ValidAddresses = null;
            ValidAddressesList.Items.Clear();
            ValidAddressesPanel.Visible = false;
        }

        private Address GetAddressToEdit()
        {
            Address address = AddressDataSource.Load(_addressId);
            if (address == null)
            {
                address = new Address();
            }

            return address;
        }

        private bool IsAddressValid(Address address)
        {
            if (string.IsNullOrEmpty(address.FirstName)) return false;
            if (string.IsNullOrEmpty(address.LastName)) return false;
            if (string.IsNullOrEmpty(address.Address1)) return false;
            if (string.IsNullOrEmpty(address.City)) return false;
            if (string.IsNullOrEmpty(address.CountryCode)) return false;
            //SEE WHETHER POSTAL CODE IS REQUIRED
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            bool requirePostalCode = (Array.IndexOf(countries, address.CountryCode) > -1);
            if (requirePostalCode)
            {
                if (string.IsNullOrEmpty(address.PostalCode)) return false;
                if ((address.CountryCode == "US") && (!Regex.IsMatch(address.PostalCode, "^\\d{5}(-\\d{4})?$"))) return false;
                if ((address.CountryCode == "CA") && (!Regex.IsMatch(address.PostalCode, "^[A-Za-z][0-9][A-Za-z] ?[0-9][A-Za-z][0-9]$"))) return false;
            }
            //SEE WHETHER PROVINCE IS VALID
            if (ProvinceDataSource.CountForCountry(address.CountryCode) > 0)
            {
                int provinceId = ProvinceDataSource.GetProvinceIdByName(address.CountryCode, address.Province);
                if (provinceId == 0) return false;
            }
            return true;
        }

        /// <summary>
        /// Validates the current province value
        /// </summary>
        /// <returns></returns>
        private bool ValidateProvince(DropDownList CountryList, TextBox ProvinceText, DropDownList ProvinceList, out string provinceName)
        {
            provinceName = StringHelper.StripHtml(Request.Form[ProvinceText.UniqueID]);
            if (string.IsNullOrEmpty(provinceName)) provinceName = Request.Form[ProvinceList.UniqueID];
            string countryCode = CountryList.SelectedValue;
            if (ProvinceDataSource.CountForCountry(countryCode) == 0) return true;
            //CHECK THE VALUE
            int provinceId = ProvinceDataSource.GetProvinceIdByName(countryCode, provinceName);
            if (provinceId > 0)
            {
                //UPDATE VALUE
                Province p = ProvinceDataSource.Load(provinceId);
                if (p.ProvinceCode.Length > 0) provinceName = p.ProvinceCode;
                else provinceName = p.Name;
            }
            return (provinceId > 0);
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("ShipAddress.aspx");
        }

        # endregion
    }
}