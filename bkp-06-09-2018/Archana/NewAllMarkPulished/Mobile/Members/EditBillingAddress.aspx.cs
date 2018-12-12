namespace AbleCommerce.Mobile.Members
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Users;
    using System.Collections.Generic;
    using CommerceBuilder.Shipping;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;
    using CommerceBuilder.UI;

    [Description("Displays the user billing address for a specific order.")]
    public partial class EditBillingAddress : AbleCommercePage
    {
        IList<Country> _Countries;

        private Order _Order;

        /// <summary>
        /// Gets or sets the country collection
        /// </summary>
        private IList<Country> Countries
        {
            get
            {
                if (_Countries == null) InitializeCountries();
                return _Countries;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _Order = OrderDataSource.Load(PageHelper.GetOrderId());
            if (_Order == null) Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Members/MyAccount.aspx"));
            if (_Order.User != null && _Order.User.Id != AbleContext.Current.UserId) Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Members/MyAccount.aspx"));

            //INITIALIZE BILLING ADDRESS
            if (!Page.IsPostBack)
            {
                InitializeBillingAddress();
                EditAddressCaption.Text = string.Format(EditAddressCaption.Text, _Order.OrderNumber.ToString());
            }
        }

        protected void EditSaveButton_Click(object sender, EventArgs e)
        {
            SaveBillingAddress();
            Response.Redirect("PayMyOrder.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }

        protected void EditCancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("PayMyOrder.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }

        protected void BillToCountry_Changed(object sender, EventArgs e)
        {
            SelectCountryAndProvince(BillToCountry, BillToCountry.SelectedValue, false, BillToProvince, BillToProvinceList, BillToPostalCodeRequired, _Order.BillToProvince, false);
        }


        private void InitializeBillingAddress()
        {
            User user = AbleContext.Current.User;
            BillToFirstName.Text = _Order.BillToFirstName;
            BillToLastName.Text = _Order.BillToLastName;
            BillToCompany.Text = _Order.BillToCompany;
            BillToAddress1.Text = _Order.BillToAddress1;
            BillToAddress2.Text = _Order.BillToAddress2;
            BillToCity.Text = _Order.BillToCity;
            BillToPostalCode.Text = _Order.BillToPostalCode;
            //BillToAddressType.SelectedIndex = ( _Order.BillToIsResidence ? 0 : 1);
            BillToPhone.Text = _Order.BillToPhone;
            //INITIALIZE BILLING COUNTRY AND PROVINCE
            BillToCountry.DataSource = this.Countries;
            BillToCountry.DataBind();
            if (_Order.BillToCountryCode.Length == 0) _Order.BillToCountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
            SelectCountryAndProvince(BillToCountry, _Order.BillToCountryCode, false, BillToProvince, BillToProvinceList, BillToPostalCodeRequired, _Order.BillToProvince, false);
        }

        private void SelectCountryAndProvince(DropDownList CountryList, string defaultCountry, bool forceCountry, TextBox ProvinceText, DropDownList ProvinceList, RequiredFieldValidator PostalCodeValidator, string defaultProvince, bool forceProvince)
        {
            SelectCountry(CountryList, defaultCountry, ProvinceText, ProvinceList, PostalCodeValidator, forceCountry);
            SelectProvince(ProvinceText, ProvinceList, defaultProvince, forceProvince);
        }

        private void SelectCountry(DropDownList CountryList, string defaultCountry, TextBox ProvinceText, DropDownList ProvinceList, RequiredFieldValidator PostalCodeValidator, bool forceCountry)
        {
            string countryValue = Request.Form[CountryList.UniqueID];
            if (forceCountry || string.IsNullOrEmpty(countryValue)) countryValue = defaultCountry;
            int index = this.Countries.IndexOf(countryValue);
            if (index > -1)
            {
                CountryList.SelectedIndex = index;
                UpdateProvinces(countryValue, ProvinceText, ProvinceList, PostalCodeValidator);
            }
        }

        private void UpdateProvinces(string countryCode, TextBox ProvinceText, DropDownList ProvinceList, RequiredFieldValidator PostalCodeValidator)
        {
            //SEE WHETHER POSTAL CODE IS REQUIRED
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            PostalCodeValidator.Enabled = (Array.IndexOf(countries, countryCode) > -1);
            //SEE WHETHER PROVINCE LIST IS DEFINED
            IList<Province> provinces = ProvinceDataSource.LoadForCountry(countryCode);
            if (provinces.Count > 0)
            {
                ProvinceText.Visible = false;
                ProvinceList.Visible = true;
                ProvinceList.Items.Clear();
                ProvinceList.Items.Add(String.Empty);
                foreach (Province province in provinces)
                {
                    string provinceValue = (!string.IsNullOrEmpty(province.ProvinceCode) ? province.ProvinceCode : province.Name);
                    ProvinceList.Items.Add(new ListItem(province.Name, provinceValue));
                }
            }
            else
            {
                ProvinceText.Visible = true;
                ProvinceList.Visible = false;
                ProvinceList.Items.Clear();
            }
            BillToProvinceRequired.Enabled = BillToProvinceList.Visible;
        }

        private void SelectProvince(TextBox ProvinceText, DropDownList ProvinceList, string defaultProvince, bool forceProvince)
        {
            if (ProvinceText.Visible)
            {
                ProvinceText.Text = defaultProvince;
            }
            else
            {
                string provinceValue = Request.Form[ProvinceList.UniqueID];
                if (forceProvince || string.IsNullOrEmpty(provinceValue)) provinceValue = defaultProvince;
                ListItem selectedProvince = ProvinceList.Items.FindByValue(provinceValue);
                if (selectedProvince != null) ProvinceList.SelectedIndex = ProvinceList.Items.IndexOf(selectedProvince);
            }
        }

        private void InitializeCountries()
        {
            _Countries = CountryDataSource.LoadForStore(AbleContext.Current.StoreId, "Name");
            //FIND STORE COUNTRY AND COPY TO FIRST POSITION
            string storeCountry = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
            if (storeCountry.Length == 0) storeCountry = "US";
            int index = _Countries.IndexOf(storeCountry);
            if (index > -1)
            {
                Country country = new Country(storeCountry);
                country.Name = "----------";
                _Countries.Insert(0, country);
                _Countries.Insert(0, _Countries[index + 1]);
                if (storeCountry == "US")
                {
                    index = _Countries.IndexOf("CA");
                    if (index > -1) _Countries.Insert(1, _Countries[index]);
                }
                else if (storeCountry == "CA")
                {
                    index = _Countries.IndexOf("US");
                    if (index > -1) _Countries.Insert(1, _Countries[index]);
                }
            }
        }

        private void SaveBillingAddress()
        {
            // LOOK FOR SHIPMENTS THAT SHIP TO BILLING ADDRESSES
            List<OrderShipment> shipments = GetShipToBilling(_Order);

            BillToProvince.Visible = !BillToProvinceList.Visible;

            // UPDATE THE BILLING ADDRESS
            _Order.BillToFirstName = StringHelper.StripHtml(BillToFirstName.Text);
            _Order.BillToLastName = StringHelper.StripHtml(BillToLastName.Text);
            _Order.BillToCountryCode = BillToCountry.SelectedValue;
            _Order.BillToCompany = StringHelper.StripHtml(BillToCompany.Text);
            _Order.BillToAddress1 = StringHelper.StripHtml(BillToAddress1.Text);
            _Order.BillToAddress2 = StringHelper.StripHtml(BillToAddress2.Text);
            _Order.BillToCity = StringHelper.StripHtml(BillToCity.Text);
            _Order.BillToProvince = (BillToProvince.Visible ? StringHelper.StripHtml(BillToProvince.Text) : BillToProvinceList.SelectedValue);
            _Order.BillToPostalCode = StringHelper.StripHtml(BillToPostalCode.Text);
            _Order.BillToPhone = StringHelper.StripHtml(BillToPhone.Text);

            // UPDATE SHIPPING ADDRESSES
            foreach (OrderShipment shipment in shipments)
            {
                shipment.ShipToFirstName = _Order.BillToFirstName;
                shipment.ShipToLastName = _Order.BillToLastName;
                shipment.ShipToCountryCode = _Order.BillToCountryCode;
                shipment.ShipToCompany = _Order.BillToCompany;
                shipment.ShipToAddress1 = _Order.BillToAddress1;
                shipment.ShipToAddress2 = _Order.BillToAddress2;
                shipment.ShipToCity = _Order.BillToCity;
                shipment.ShipToProvince = _Order.BillToProvince;
                shipment.ShipToPostalCode = _Order.BillToPostalCode;
                shipment.ShipToPhone = _Order.BillToPhone;
            }

            // SAVE ORDER
            _Order.Save(false, false);
        }

        private static List<OrderShipment> GetShipToBilling(Order order)
        {
            List<OrderShipment> shipments = new List<OrderShipment>();
            foreach (OrderShipment shipment in order.Shipments)
            {
                if (order.BillToFirstName != shipment.ShipToFirstName) continue;
                if (order.BillToLastName != shipment.ShipToLastName) continue;
                if (order.BillToCountryCode != shipment.ShipToCountryCode) continue;
                if (order.BillToCompany != shipment.ShipToCompany) continue;
                if (order.BillToAddress1 != shipment.ShipToAddress1) continue;
                if (order.BillToAddress2 != shipment.ShipToAddress2) continue;
                if (order.BillToCity != shipment.ShipToCity) continue;
                if (order.BillToProvince != shipment.ShipToProvince) continue;
                if (order.BillToPostalCode != shipment.ShipToPostalCode) continue;
                if (order.BillToPhone != shipment.ShipToPhone) continue;
                shipments.Add(shipment);
            }
            return shipments;
        }
    }
}
