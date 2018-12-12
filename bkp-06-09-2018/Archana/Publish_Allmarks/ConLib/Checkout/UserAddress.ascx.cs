namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    [Description("Form for getting user address")]
    public partial class UserAddress : System.Web.UI.UserControl
    {
        private int _AddressId;
        private int _ShipmentId;
        private Address _Address;
        private BasketShipment _Shipment;
        private string _ValidationGroup = "UserAddress";        

        # region properties
        
        /// <summary>
        /// Address Id
        /// </summary>
        public int AddressId
        {
            get 
            {
                // LOOK INTO VIEW STATE
                if (_AddressId == 0)
                {                    
                    _AddressId = AlwaysConvert.ToInt(this.ViewState["USER_ADDRESS_ADDRESS_ID"]);
                }
                // OTHERWISE LOOK INTO SHIPMENT
                if (_AddressId == 0 && Shipment != null)
                {
                    // check shipment for address
                    _AddressId = Shipment.AddressId;
                    
                }
                return _AddressId; 
            }
            set { 
                _AddressId = value;
                this.ViewState["USER_ADDRESS_ADDRESS_ID"] = value.ToString();
            }
        }

        protected Address Address
        {
            get 
            {
                if (_Address == null && AddressId != 0)
                {
                    _Address = EntityLoader.Load<Address>(_AddressId);
                }
                return _Address;
            }
        }

        public int ShipmentId
        {
            get
            {
                if (_ShipmentId == 0)
                {
                    // LOOK INTO VIEW STATE
                    _ShipmentId = AlwaysConvert.ToInt(this.ViewState["USER_ADDRESS_SHIPMENT_ID"]);
                }
                return _ShipmentId;
            }
            set
            {
                _ShipmentId = value;
                this.ViewState["USER_ADDRESS_SHIPMENT_ID"] = value.ToString();
            }
        }

        protected BasketShipment Shipment
        {
            get {
                if (_Shipment == null && this.ShipmentId != 0)
                {
                    _Shipment = EntityLoader.Load<BasketShipment>(this.ShipmentId);
                }

                return _Shipment;
            }
        }

        /// <summary>
        /// A unique validation group need to be specified for each instance of the control on single page.
        /// </summary>
        [Browsable(true), DefaultValue("UserAddress")]
        [Description("If you need to use multiple controls on same page, a unique validation group need to be specified for each instance of the control.")]
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set
            {
                _ValidationGroup = value;

                // UPDATE VALIDATION GROUP
                EditValidationSummary.ValidationGroup = _ValidationGroup;
                FirstNameRequired.ValidationGroup = _ValidationGroup;
                LastNameRequired.ValidationGroup = _ValidationGroup;
                Address1Required.ValidationGroup = _ValidationGroup;
                CityRequired.ValidationGroup = _ValidationGroup;
                ProvinceRequired.ValidationGroup = _ValidationGroup;
                Province2Required.ValidationGroup = _ValidationGroup;
                PostalCodeRequired.ValidationGroup = _ValidationGroup;
                USPostalCodeRequired.ValidationGroup = _ValidationGroup;
                CAPostalCodeRequired.ValidationGroup = _ValidationGroup;
                PhoneRequired.ValidationGroup = _ValidationGroup;
                SaveButton.ValidationGroup = _ValidationGroup;
            }
        }

        protected bool IsBillingAddress
        {
            get
            {
                return this.Address != null && this.Shipment == null;
            }
        }

        protected bool IsShippingAddress
        {
            get
            {
                return this.Shipment != null;
            }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {                
                if (Address != null)
                    AddressData.Text = Address.ToString(true);

                Header.Visible = IsBillingAddress;
                EditLink.Visible = !IsBillingAddress;
            }
        }

        protected void EditLink_Click(object sender, EventArgs e)
        {
            ShowEditPanel();
        }

        # region Edit addresses

        //ADDRESS BOOK
        private void InitializeAddressBook()
        {
            //ONLY SHOW THE ADDRESES THAT ARE NOT THE PRIMARY (BILLING)
            IList<Address> addresses = new List<Address>();
            addresses.AddRange(AbleContext.Current.User.Addresses);
            addresses.Sort("LastName");
            //int defaultIndex = addresses.IndexOf(AbleContext.Current.User.PrimaryAddressId);
            //if (defaultIndex > -1) addresses.RemoveAt(defaultIndex);
            if (addresses.Count > 0)
            {
                List<DictionaryEntry> formattedAddresses = new List<DictionaryEntry>();
                foreach (Address address in addresses)
                    formattedAddresses.Add(new DictionaryEntry(address.Id, address.FullName + " " + address.Address1 + " " + address.City));
                //BIND THE ADDRESSES TO THE DATALIST
                AddressBook.DataSource = formattedAddresses;
                AddressBook.DataBind();
            }
            if (addresses.Count == AddressBook.Items.Count)
            {
                // PREVENT FROM ADDING TWICE
                AddressBook.Items.Add(new ListItem("new address", "0"));
            }

            // SELECT THE LAST ADDRESs
            Address lastShippingAddress = GetSelectedShippingAddress();
            if (lastShippingAddress != null)
            {
                ListItem selected = AddressBook.Items.FindByValue(lastShippingAddress.Id.ToString());
                if (selected != null) AddressBook.SelectedIndex = AddressBook.Items.IndexOf(selected);
                InitAddressForm(lastShippingAddress);
            }
        }

        protected Address GetSelectedShippingAddress()
        {
            if (Page.IsPostBack)
            {
                // CHECK THE LAST ADDRESs
                if (!string.IsNullOrEmpty(Request.Form[AddressBook.UniqueID]))
                {
                    int tempAddressId = AlwaysConvert.ToInt(Request.Form[AddressBook.UniqueID]);
                    if (tempAddressId == 0) return new Address();

                    return EntityLoader.Load<Address>(tempAddressId);
                }
            }
            return this.Address;
        }

        protected void ShowEditPanel()
        {
            Country.DataSource = CountryDataSource.LoadAll("Name");
            Country.DataBind();
            if (IsShippingAddress)
            {
                InitializeAddressBook();
            }
            else
            {
                InitAddressForm(this.Address);
            }
            trAddressBook.Visible = IsShippingAddress;
            EditPanelPopup.Show();
        }

        protected void InitAddressForm(Address address)
        {
            string newCountryCode;
            if (address != null)
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

                ListItem defaultCountry = Country.Items.FindByValue(newCountryCode);
                if (defaultCountry != null) Country.SelectedIndex = Country.Items.IndexOf(defaultCountry);
                CountryChanged(null, null);
            }
            
        }

        protected void AddressChanged(object sender, EventArgs e)
        {
            InitializeAddressBook();
            EditPanelPopup.Show();
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

            EditPanelPopup.Show();
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
                string formattedProvinceName;
                if (ValidateProvince(Country, Province, Province2, out formattedProvinceName))
                {
                    // check if its billing address
                    if (IsBillingAddress)
                    {
                        UpdateAndSaveAddress(this.Address,  formattedProvinceName);

                        // update address display
                        AddressData.Text = this.Address.ToString(true);
                    }
                    else
                    {
                        // check if an address change has occurred.
                        Address selectedAddress = GetSelectedShippingAddress();

                        if (selectedAddress.Id == 0)
                        {
                            // its new address, add it to user address book
                            selectedAddress.User = AbleContext.Current.User;
                            UpdateAndSaveAddress(selectedAddress, formattedProvinceName);
                            AbleContext.Current.User.Addresses.Add(selectedAddress);
                            AbleContext.Current.User.Addresses.Save();
                        }
                        else UpdateAndSaveAddress(selectedAddress, formattedProvinceName);

                        // update the shipment
                        this.Shipment.Address = selectedAddress;
                        this.Shipment.Save();

                        // update address display
                        AddressData.Text = selectedAddress.ToString(true);
                    }

                    // We need to reload the page
                    Response.Redirect(Request.RawUrl); 
                }
                else
                {
                    Province2Required.IsValid = false;
                    CountryChanged(null, null);
                }
            }
            else EditPanelPopup.Show();
        }

        private void UpdateAndSaveAddress(Address address, string formattedProvinceName)
        {
            address.FirstName = StringHelper.StripHtml(FirstName.Text);
            address.LastName = StringHelper.StripHtml(LastName.Text);
            address.Address1 = StringHelper.StripHtml(Address1.Text);
            address.Address2 = StringHelper.StripHtml(Address2.Text);
            address.Company = StringHelper.StripHtml(Company.Text);
            address.City = StringHelper.StripHtml(City.Text);
            address.Province = formattedProvinceName;
            address.PostalCode = StringHelper.StripHtml(PostalCode.Text);
            address.CountryCode = Country.SelectedValue;
            address.Phone = StringHelper.StripHtml(Phone.Text);
            address.Fax = StringHelper.StripHtml(Fax.Text);
            address.Residence = !IsBusiness.Checked;
            address.Save();
        }

        private bool IsAddressValid()
        {
            if (string.IsNullOrEmpty(this.Address.FirstName)) return false;
            if (string.IsNullOrEmpty(this.Address.LastName)) return false;
            if (string.IsNullOrEmpty(this.Address.Address1)) return false;
            if (string.IsNullOrEmpty(this.Address.City)) return false;
            if (string.IsNullOrEmpty(this.Address.CountryCode)) return false;
            //SEE WHETHER POSTAL CODE IS REQUIRED
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            bool requirePostalCode = (Array.IndexOf(countries, this.Address.CountryCode) > -1);
            if (requirePostalCode)
            {
                if (string.IsNullOrEmpty(this.Address.PostalCode)) return false;
                if ((this.Address.CountryCode == "US") && (!Regex.IsMatch(this.Address.PostalCode, "^\\d{5}(-\\d{4})?$"))) return false;
                if ((this.Address.CountryCode == "CA") && (!Regex.IsMatch(this.Address.PostalCode, "^[A-Za-z][0-9][A-Za-z] ?[0-9][A-Za-z][0-9]$"))) return false;
            }
            //SEE WHETHER PROVINCE IS VALID
            if (ProvinceDataSource.CountForCountry(this.Address.CountryCode) > 0)
            {
                int provinceId = ProvinceDataSource.GetProvinceIdByName(this.Address.CountryCode, this.Address.Province);
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
            EditPanelPopup.Hide();
        }
        # endregion
    }
}