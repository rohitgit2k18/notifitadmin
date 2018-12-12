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
using CommerceBuilder.Orders;
using CommerceBuilder.Messaging;

namespace AbleCommerce.Admin.People.Subscriptions
{
    public partial class ShippingAddress : System.Web.UI.UserControl
    {
        private int _subscriptionId;
        private Subscription _subscription;

        protected void Page_Init(object sender, EventArgs e)
        {
            _subscriptionId = AlwaysConvert.ToInt(Request.QueryString["SubscriptionId"]);
            _subscription = SubscriptionDataSource.Load(_subscriptionId);
            CountryCode.DataSource = CountryDataSource.LoadAll("Name");
            CountryCode.DataBind();
            //INIT ADDRESS
            Address address = _subscription.GetShippingAddress();
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

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveShippingAddress();
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                SavedMessage.Visible = true;
            }
        }

        private void SaveShippingAddress()
        {
            _subscription.ShipToFirstName = FirstName.Text;
            _subscription.ShipToLastName = LastName.Text;
            _subscription.ShipToCompany = Company.Text;
            _subscription.ShipToAddress1 = Address1.Text;
            _subscription.ShipToAddress2 = Address2.Text;
            _subscription.ShipToCity = City.Text;
            _subscription.ShipToProvince = Province.Text;
            _subscription.ShipToPostalCode = PostalCode.Text;
            _subscription.ShipToCountryCode = CountryCode.Items[CountryCode.SelectedIndex].Value;
            _subscription.ShipToPhone = Phone.Text;
            _subscription.ShipToFax = Fax.Text;
            _subscription.ShipToResidence = (Residence.SelectedIndex == 0);

            try
            {
                EmailProcessor.NotifySubscriptionUpdated(_subscription);
            }
            catch (Exception ex)
            {
                Logger.Error("Error sending subscription updated email.", ex);
            }

            _subscription.Save();
        }
    }
}