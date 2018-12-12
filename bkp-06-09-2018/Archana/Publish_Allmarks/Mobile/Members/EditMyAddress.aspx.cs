using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Shipping;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.UI;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile.Members
{
    public partial class EditMyAddress : AbleCommercePage
    {
        protected int AddressId
        {
            get
            {
                if (ViewState["AddressId"] != null) return (int)ViewState["AddressId"];
                return 0;
            }
            set
            {
                ViewState["AddressId"] = value;
            }
        }

        private Address _Address = null;
        protected Address Address
        {
            get
            {
                if (_Address == null)
                {
                    User user = AbleContext.Current.User;
                    if (this.AddressId != 0)
                    {
                        int index = user.Addresses.IndexOf(this.AddressId);
                        if (index > -1) _Address = user.Addresses[index];
                    }
                    if (_Address == null)
                    {
                        _Address = new Address();
                        _Address.User = user;
                        _Address.CountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                        _Address.Residence = true;
                    }
                }
                return _Address;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            this.TrackViewState();
            Country.DataSource = CountryDataSource.LoadAll();
            Country.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                this.AddressId = AlwaysConvert.ToInt(Request.QueryString["AddressId"]);
                InitAddressForm();
            }
        }

        protected void InitAddressForm()
        {
            Address address = this.Address;
            string actionLabel = (address.Id == 0) ? "Create" : "Edit";
            string typeLabel = (address.Id == AbleContext.Current.User.PrimaryAddress.Id) ? "Billing" : "Shipping";
            EditAddressCaption.Text = string.Format(EditAddressCaption.Text, actionLabel, typeLabel);
            FirstName.Text = address.FirstName;
            LastName.Text = address.LastName;
            Address1.Text = address.Address1;
            Address2.Text = address.Address2;
            City.Text = address.City;
            PostalCode.Text = address.PostalCode;
            InitCountryAndProvince();
            Phone.Text = address.Phone;
            Company.Text = address.Company;
            Fax.Text = address.Fax;
            Residence.SelectedIndex = (address.Residence ? 0 : 1);
        }

        private void InitCountryAndProvince()
        {
            //MAKE SURE THE CORRECT ADDRESS IS SELECTED
            Address address = this.Address;
            bool foundCountry = false;
            if (!string.IsNullOrEmpty(address.CountryCode))
            {
                ListItem selectedCountry = Country.Items.FindByValue(address.CountryCode);
                if (selectedCountry != null)
                {
                    Country.SelectedIndex = Country.Items.IndexOf(selectedCountry);
                    foundCountry = true;
                }
            }
            if (!foundCountry)
            {
                Warehouse defaultWarehouse = AbleContext.Current.Store.DefaultWarehouse;
                ListItem selectedCountry = Country.Items.FindByValue(defaultWarehouse.CountryCode);
                if (selectedCountry != null) Country.SelectedIndex = Country.Items.IndexOf(selectedCountry);
            }
            //MAKE SURE THE PROVINCE LIST IS CORRECT FOR THE COUNTRY
            UpdateCountry();
            //NOW LOOK FOR THE PROVINCE TO SET
            if (Province.Visible) Province.Text = address.Province;
            else
            {
                ListItem selectedProvince = Province2.Items.FindByValue(address.Province);
                if (selectedProvince != null) Province2.SelectedIndex = Province2.Items.IndexOf(selectedProvince);
            }
        }

        protected void EditSaveButton_Click(object sender, EventArgs e)
        {
            string provinceName;
            if (ValidateProvince(out provinceName))
            {
                if (Page.IsValid)
                {
                    Address address = this.Address;
                    address.FirstName = StringHelper.StripHtml(FirstName.Text);
                    address.LastName = StringHelper.StripHtml(LastName.Text);
                    address.Address1 = StringHelper.StripHtml(Address1.Text);
                    address.Address2 = StringHelper.StripHtml(Address2.Text);
                    address.Company = StringHelper.StripHtml(Company.Text);
                    address.City = StringHelper.StripHtml(City.Text);
                    address.Province = provinceName;
                    address.PostalCode = StringHelper.StripHtml(PostalCode.Text);
                    address.CountryCode = Country.SelectedValue;
                    address.Phone = StringHelper.StripHtml(Phone.Text);
                    address.Fax = StringHelper.StripHtml(Fax.Text);
                    address.Residence = (Residence.SelectedIndex == 0);
                    AbleContext.Current.User.Addresses.Add(address);
                    address.Save();
                    ShowAddressBook();
                }
            }
            else
            {
                Province2Invalid.IsValid = false;
                UpdateCountry();
            }
        }

        /// <summary>
        /// Validates the current province value
        /// </summary>
        /// <returns></returns>
        private bool ValidateProvince(out string provinceName)
        {
            provinceName = (Province.Visible ? StringHelper.StripHtml(Province.Text) : Province2.SelectedValue);
            string countryCode = Country.SelectedValue;
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

        protected void EditCancelButton_Click(object sender, EventArgs e)
        {
            ShowAddressBook();
        }

        protected void ShowAddressBook()
        {
            Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Members/MyAddressBook.aspx"));
        }

        private void UpdateCountry()
        {
            //SEE WHETHER POSTAL CODE IS REQUIRED
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            PostalCodeRequired.Enabled = (Array.IndexOf(countries, Country.SelectedValue) > -1);
            //SEE WHETHER PROVINCE LIST IS DEFINED
            IList<Province> provinces = ProvinceDataSource.LoadForCountry(Country.SelectedValue, "Name");
            if (provinces.Count > 0)
            {
                Province.Visible = false;
                Province2.Visible = true;
                Province2.Items.Clear();
                Province2.Items.Add(string.Empty);
                foreach (Province province in provinces)
                {
                    string provinceValue = (!string.IsNullOrEmpty(province.ProvinceCode) ? province.ProvinceCode : province.Name);
                    Province2.Items.Add(new ListItem(province.Name, provinceValue));
                }
                ListItem selectedProvince = FindSelectedProvince();
                if (selectedProvince != null) selectedProvince.Selected = true;
                Province2Required.Enabled = true;
                Province.Text = string.Empty;
            }
            else
            {
                Province.Visible = true;
                Province2.Visible = false;
                Province2.Items.Clear();
                Province2Required.Enabled = false;
            }
        }

        /// <summary>
        /// Obtains the province that should default to selected in the drop down list
        /// </summary>
        /// <returns>The province that should default to selected in the drop down list</returns>
        private ListItem FindSelectedProvince()
        {
            string defaultValue = Province.Text;
            if (string.IsNullOrEmpty(defaultValue)) defaultValue = Request.Form[Province2.UniqueID];
            if (string.IsNullOrEmpty(defaultValue)) return null;
            defaultValue = defaultValue.ToUpperInvariant();
            foreach (ListItem item in Province2.Items)
            {
                string itemText = item.Text.ToUpperInvariant();
                string itemValue = item.Value.ToUpperInvariant();
                if (itemText == defaultValue || itemValue == defaultValue) return item;
            }
            return null;
        }

        protected void Country_Changed(object sender, EventArgs e)
        {
            //UPDATE THE FORM FOR THE NEW COUNTRY
            UpdateCountry();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            this.SaveViewState();
        }
    }
}