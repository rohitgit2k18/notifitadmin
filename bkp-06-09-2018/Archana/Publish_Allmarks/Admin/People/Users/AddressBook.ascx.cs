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

    public partial class AddressBook : System.Web.UI.UserControl
    {
        private int _SubscriptionId;
        private int _UserId;
        private User _User;

        protected void Page_Init(object sender, EventArgs e)
        {
            _SubscriptionId =  AlwaysConvert.ToInt(Request.QueryString["SubscriptionId"]);
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
            _User = UserDataSource.Load(_UserId);
            CountryCode.DataSource = CountryDataSource.LoadAll("Name");
            CountryCode.DataBind();
            //INIT ADDRESS
            Address address = _User.PrimaryAddress;
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
                SaveUserAddress();
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                SavedMessage.Visible = true;
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the address
                SaveUserAddress();

                // redirect away
                if (!string.IsNullOrEmpty(Request.QueryString["SubscriptionId"]))
                    Response.Redirect("~/Admin/People/Subscriptions/EditSubscription.aspx?SubscriptionId=" + _SubscriptionId);
                Response.Redirect("Default.aspx");
            }
        }

        private void SaveUserAddress()
        {
            Address address = _User.PrimaryAddress;
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
        }

        protected void BackButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["SubscriptionId"]))
                Response.Redirect("~/Admin/People/Subscriptions/EditSubscription.aspx?SubscriptionId=" + _SubscriptionId);
            Response.Redirect("Default.aspx");
        }
    }
}
