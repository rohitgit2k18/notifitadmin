//-----------------------------------------------------------------------
// <copyright file="BillingAddress.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.ConLib.Account
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

    [Description("Displays the user billing address for a specific order.")]
    public partial class BillingAddress : System.Web.UI.UserControl
    {
        IList<Country> _Countries;
        bool _ShowEditLink = false;

        public Order Order { get; set; }


        [Browsable(true), DefaultValue(false)]
        [Description("Indicates whether the edit link for billing address is shown.")]
        public bool ShowEditLink { 
            get {return _ShowEditLink;}
            set { _ShowEditLink = value; }
        }

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
        

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                string pattern = this.Order.BillToCountry.AddressFormat;
                if (!string.IsNullOrEmpty(this.Order.BillToEmail) && !pattern.Contains("[Email]") && !pattern.Contains("[Email_U]")) pattern += "\r\nEmail: [Email]";
                if (!string.IsNullOrEmpty(this.Order.BillToPhone) && !pattern.Contains("[Phone]") && !pattern.Contains("[Phone_U]")) pattern += "\r\nPhone: [Phone]";
                if (!string.IsNullOrEmpty(this.Order.BillToFax) && !pattern.Contains("[Fax]") && !pattern.Contains("[Fax_U]")) pattern += "\r\nFax: [Fax]";

                AddressData.Text = this.Order.FormatAddress(pattern, true);
                EditAddressLink.Visible = ShowEditLink;
                EditBillInfoPopup.CancelControlID = EditBillAddressPanel.Visible ? CancelBillInfoButton.ClientID : DummyCancelBillAddressLink.ClientID;
            }
            else
            {
                this.Controls.Clear();
            }
        }

        #region BillingAddress
        protected void EditAddressButton_Click(object sender, EventArgs e)
        {
            if (AbleCommerce.Code.PageHelper.IsResponsiveTheme(this.Page))
            {
                User user = AbleContext.Current.User;
                string editAddressUrl = "EditMyAddress.aspx";

                if (user != null && user.PrimaryAddressId > 0)
                {
                    editAddressUrl = string.Format("{0}?AddressId={1}", editAddressUrl, user.PrimaryAddressId);
                    if (this.Order.OrderNumber > 0) editAddressUrl += "&OrderNumber=" + Order.OrderNumber.ToString();
                    Response.Redirect(editAddressUrl);
                }
            }
            else
            {
                //INITIALIZE BILLING ADDRESS
                EditBillAddressPanel.Visible = true;
                InitializeBillingAddress();

                EditBillInfoPopup.Show();
            }
        }

        protected void UpdateBillInfoButton_Click(object sender, EventArgs e)
        {
            SaveBillingAddress();
            EditBillAddressPanel.Visible = true;
            EditBillInfoPopup.Hide();
        }

        protected void BillToCountry_Changed(object sender, EventArgs e)
        {
            SelectCountryAndProvince(BillToCountry, BillToCountry.SelectedValue, false, BillToProvince, BillToProvinceList, BillToPostalCodeRequired, this.Order.BillToProvince, false);
            EditBillInfoPopup.Show();
        }


        private void InitializeBillingAddress()
        {
            User user = AbleContext.Current.User;
            BillToFirstName.Text = this.Order.BillToFirstName;
            BillToLastName.Text = this.Order.BillToLastName;
            BillToCompany.Text = this.Order.BillToCompany;
            BillToAddress1.Text = this.Order.BillToAddress1;
            BillToAddress2.Text = this.Order.BillToAddress2;
            BillToCity.Text = this.Order.BillToCity;
            BillToPostalCode.Text = this.Order.BillToPostalCode;
            //BillToAddressType.SelectedIndex = ( this.Order.BillToIsResidence ? 0 : 1);
            BillToPhone.Text = this.Order.BillToPhone;
            //INITIALIZE BILLING COUNTRY AND PROVINCE
            BillToCountry.DataSource = this.Countries;
            BillToCountry.DataBind();
            if (this.Order.BillToCountryCode.Length == 0) this.Order.BillToCountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
            SelectCountryAndProvince(BillToCountry, this.Order.BillToCountryCode, false, BillToProvince, BillToProvinceList, BillToPostalCodeRequired, this.Order.BillToProvince, false);
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
            List<OrderShipment> shipments = GetShipToBilling(this.Order);

            BillToProvince.Visible = !BillToProvinceList.Visible;

            // UPDATE THE BILLING ADDRESS
            this.Order.BillToFirstName = StringHelper.StripHtml(BillToFirstName.Text);
            this.Order.BillToLastName = StringHelper.StripHtml(BillToLastName.Text);
            this.Order.BillToCountryCode = BillToCountry.SelectedValue;
            this.Order.BillToCompany = StringHelper.StripHtml(BillToCompany.Text);
            this.Order.BillToAddress1 = StringHelper.StripHtml(BillToAddress1.Text);
            this.Order.BillToAddress2 = StringHelper.StripHtml(BillToAddress2.Text);
            this.Order.BillToCity = StringHelper.StripHtml(BillToCity.Text);
            this.Order.BillToProvince = (BillToProvince.Visible ? StringHelper.StripHtml(BillToProvince.Text) : BillToProvinceList.SelectedValue);
            this.Order.BillToPostalCode = StringHelper.StripHtml(BillToPostalCode.Text);
            this.Order.BillToPhone = StringHelper.StripHtml(BillToPhone.Text);

            // UPDATE SHIPPING ADDRESSES
            foreach (OrderShipment shipment in shipments)
            {
                shipment.ShipToFirstName = this.Order.BillToFirstName;
                shipment.ShipToLastName = this.Order.BillToLastName;
                shipment.ShipToCountryCode = this.Order.BillToCountryCode;
                shipment.ShipToCompany = this.Order.BillToCompany;
                shipment.ShipToAddress1 = this.Order.BillToAddress1;
                shipment.ShipToAddress2 = this.Order.BillToAddress2;
                shipment.ShipToCity = this.Order.BillToCity;
                shipment.ShipToProvince = this.Order.BillToProvince;
                shipment.ShipToPostalCode = this.Order.BillToPostalCode;
                shipment.ShipToPhone = this.Order.BillToPhone;
            }

            // SAVE ORDER
            this.Order.Save(false, false);
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
        #endregion
    }
}