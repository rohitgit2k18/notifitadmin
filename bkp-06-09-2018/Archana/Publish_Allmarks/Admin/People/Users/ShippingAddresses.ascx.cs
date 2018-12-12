namespace AbleCommerce.Admin.People.Users
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Text.RegularExpressions;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;

    public partial class ShippingAddresses : System.Web.UI.UserControl
    {
        private int _userId;
        private User _User;
        
        protected void Page_Init(object sender, EventArgs e)
        {
            _userId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
            _User = UserDataSource.Load(_userId);
            CountryCode.DataSource = CountryDataSource.LoadAll("Name");
            CountryCode.DataBind();
            BindShippingAddresses(true);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            BindAddress();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveShippingAddress();
                Toggle(true, AlwaysConvert.ToInt(AddressId.Value));
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                SavedMessage.Visible = true;
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the address
                SaveShippingAddress();
                Toggle(false);
            }
        }

        private void SaveShippingAddress()
        {
            int addressId = AlwaysConvert.ToInt(AddressId.Value);
            Address address = AddressDataSource.Load(addressId);
            if (address == null)
            {
                address = new Address();
                address.User = _User;
            }

            address.FirstName = FirstName.Text;
            address.LastName = LastName.Text;
            address.Company = Company.Text;
            address.Address1 = Address1.Text;
            address.Address2 = Address2.Text;
            address.City = City.Text;
            address.Province = Province.Text;
            address.PostalCode = PostalCode.Text;
            address.CountryCode = CountryCode.Items[CountryCode.SelectedIndex].Value;
            address.Phone = Phone.Text;
            address.Fax = Fax.Text;
            address.Residence = (Residence.SelectedIndex == 0);
            address.Save();
            AddressId.Value = address.Id.ToString();
        }

        protected void BackButton_Click(object sender, EventArgs e)
        {
            Toggle(false);
        }

        protected void EditAddressButton_Click(object sender, EventArgs e)
        {
            Toggle(true, AlwaysConvert.ToInt(ShippingAddressList.SelectedValue));
        }

        private void Toggle(bool edit, int addressId = 0)
        {
            if (edit)
            {
                AddressId.Value = addressId.ToString();
                ViewPH.Visible = false;
                EditPH.Visible = true;
            }
            else
            {
                AddressId.Value = string.Empty;
                ViewPH.Visible = true;
                EditPH.Visible = false;
                BindShippingAddresses(true);
            }
        }

        private void BindAddress() 
        {
            //INIT ADDRESS
            int addressId = AlwaysConvert.ToInt(AddressId.Value);
            Address address = AddressDataSource.Load(addressId);
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
                ListItem selectedCountry = CountryCode.Items.FindByValue(AbleContext.Current.Store.DefaultWarehouse.CountryCode);
                if (!String.IsNullOrEmpty(address.CountryCode)) selectedCountry = CountryCode.Items.FindByValue(address.CountryCode.ToString());
                if (selectedCountry != null) CountryCode.SelectedIndex = CountryCode.Items.IndexOf(selectedCountry);
                Phone.Text = address.Phone;
                Fax.Text = address.Fax;
                Residence.SelectedIndex = (address.Residence ? 0 : 1);
            }
            else
            {
                string countryCode = _User.PrimaryAddress != null ? _User.PrimaryAddress.CountryCode : string.Empty;
                if (string.IsNullOrEmpty(countryCode))
                    countryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                ListItem selectedCountry = CountryCode.Items.FindByValue(countryCode);
                if (selectedCountry != null) CountryCode.SelectedIndex = CountryCode.Items.IndexOf(selectedCountry);
            }
        }

        private void BindShippingAddresses(bool clearExistingItems = false)
        {
            // BIND (OR RE-BIND) SHIPPING ADDRESSES
            string itemText;

            if (clearExistingItems) ShippingAddressList.Items.Clear();

            // ADD ADDRESSES FROM USER ADDRESS BOOK
            IList<Address> userAddresses = AddressDataSource.LoadForUser(_userId);
            foreach (Address address in userAddresses)
            {
                itemText = GetAddressItemText(address.FirstName, address.LastName, address.Address1, address.City, address.PostalCode, address.Province, address.CountryCode);
                if (ShippingAddressList.Items.FindByText(itemText) == null)
                {
                    if (address.Id == _User.PrimaryAddressId) continue;
                    ShippingAddressList.Items.Add(new ListItem(itemText, address.Id.ToString()));
                }
            }

            ShippingAddressList.Items.Add(new ListItem("Add New Address..", "-1"));
        }

        private string GetAddressItemText(string firstName, string lastName, string streetAddress, string city, string zip, string province, string country)
        {
            string itemText = firstName + " " + lastName + " " + streetAddress;
            if (itemText.Length > 40) itemText = itemText.Substring(0, 37) + "...";
            itemText = itemText + " ";
            if (!string.IsNullOrEmpty(province)) itemText = itemText + " " + province;

            if (!string.IsNullOrEmpty(zip)) itemText = itemText + " " + zip;
            else
            {
                itemText = itemText + " " + country;
            }

            return itemText;
        }

        protected void DeleteAddressButton_Click(object sender, EventArgs e)
        {
            int addressId = AlwaysConvert.ToInt(ShippingAddressList.SelectedValue);
            if(addressId > 0)
            {
                AddressDataSource.Delete(addressId);
                BindShippingAddresses(true);
            }
        }
    }
}
