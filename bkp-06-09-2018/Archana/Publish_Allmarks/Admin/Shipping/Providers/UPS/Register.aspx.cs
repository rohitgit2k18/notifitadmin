namespace AbleCommerce.Admin.Shipping.Providers._UPS
{
    using System;
    using System.Collections.Generic;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.UPS;
    using CommerceBuilder.Utility;

    public partial class Register : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // VERIFY THIS PROVIDER IS NOT ALREADY REGISTERED
            string classId = Misc.GetClassId(typeof(UPS));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count > 0)
            {
                Response.Redirect("Configure.aspx?ShipGatewayId=" + gateways[0].Id);
            }

            // INITIALIZE FORM
            if (!Page.IsPostBack)
            {
                Warehouse defaultWarehouse = AbleContext.Current.Store.DefaultWarehouse;
                ContactName.Text = AbleContext.Current.User.PrimaryAddress.FullName;
                CompanyName.Text = AbleContext.Current.Store.Name;
                Address1.Text = defaultWarehouse.Address1;
                Address2.Text = defaultWarehouse.Address2;
                City.Text = defaultWarehouse.City;
                string countryCode = defaultWarehouse.CountryCode;
                if ((countryCode.Equals("US") || countryCode.Equals("CA")))
                {
                    Province userProvince = new Province();
                    if ((!string.IsNullOrEmpty(defaultWarehouse.Province)
                                && (defaultWarehouse.Province.Length == 2)))
                    {
                        Province.Text = defaultWarehouse.Province;
                    }
                    PostalCode.Text = defaultWarehouse.PostalCode;
                }
                ListItem countryItem = Country.Items.FindByValue(countryCode);
                if (countryItem != null)
                {
                    countryItem.Selected = true;
                }
                Phone.Text = Regex.Replace(defaultWarehouse.Phone, "[^0-9]", "");
                Email.Text = defaultWarehouse.Email;
            }
        }

        protected void NextButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // CUSTOM ERROR VALIDATION
                if (Country.SelectedValue.Equals("US"))
                {
                    // MAKE SURE POSTALCODE AND PROVINCECODE WERE PROVIDED
                    if (string.IsNullOrEmpty(Province.Text))
                    {
                        AddCustomErrorMessage("You must enter a valid 2 letter state abbreviation.", Province);
                    }
                    else
                    {
                        // MAKE SURE THE VALUE IS VALID
                        Province.Text = Province.Text.ToUpperInvariant();
                        string[] states = "AL|AK|AS|AZ|AR|CA|CO|CT|DE|DC|FM|FL|GA|GU|HI|ID|IL|IN|IA|KS|KY|LA|ME|MH|MD|MA|MI|MN|MS|MO|MT|NE|NV|NH|NJ|NM|NY|NC|ND|MP|OH|OK|OR|PW|PA|PR|RI|SC|SD|TN|TX|UT|VT|VI|VA|WA|WV|WI|WY|AE|AA|AE|AE|AP".Split("|".ToCharArray());
                        if (Array.IndexOf(states, Province.Text) < 0)
                        {
                            AddCustomErrorMessage("You must enter a valid 2 letter state abbreviation.", Province);
                        }
                    }
                    if (string.IsNullOrEmpty(PostalCode.Text))
                    {
                        AddCustomErrorMessage("Your 5 digit ZIP code is required.", PostalCode);
                    }
                    else
                    {
                        // MAKE SURE ZIP IS VALID FORMAT
                        if (!Regex.IsMatch(PostalCode.Text, "^\\d{5}$"))
                        {
                            AddCustomErrorMessage("You must enter a valid 5 digit ZIP code.", PostalCode);
                        }
                    }
                }
                else if (Country.SelectedValue.Equals("CA"))
                {
                    // MAKE SURE POSTALCODE AND PROVINCECODE WERE PROVIDED
                    if (string.IsNullOrEmpty(Province.Text))
                    {
                        AddCustomErrorMessage("You must enter a valid 2 letter province abbreviation.", Province);
                    }
                    else
                    {
                        // MAKE SURE THE VALUE IS VALID
                        Province.Text = Province.Text.ToUpperInvariant();
                        string[] states = "AB|BC|MB|NB|NL|NT|NS|NU|ON|PE|QC|SK|YT".Split("|".ToCharArray());
                        if ((Array.IndexOf(states, Province.Text) < 0))
                        {
                            AddCustomErrorMessage("You must enter a valid 2 letter province abbreviation.", Province);
                        }
                    }
                    if (string.IsNullOrEmpty(PostalCode.Text))
                    {
                        AddCustomErrorMessage("Your 6 character postal code is required.", PostalCode);
                    }
                    else
                    {
                        // MAKE SURE ZIP IS VALID FORMAT
                        PostalCode.Text = PostalCode.Text.ToUpperInvariant().Replace(" ", "");
                        if (!Regex.IsMatch(PostalCode.Text, "^([A-Za-z]\\d[A-Za-z]( |-)*\\d[A-Za-z]\\d)$"))
                        {
                            AddCustomErrorMessage("You must enter a valid postal code.", PostalCode);
                        }
                    }

                }
                // CHECK FOR VALID PHONE NUMBER
                Phone.Text = Regex.Replace(Phone.Text, "[^0-9]", "");
                Regex phoneRegex = new Regex(@"^\d{10,16}$");
                if (!phoneRegex.IsMatch(Phone.Text))
                {
                    PhoneValidator2.IsValid = false;
                }

                if (Page.IsValid)
                {
                    // CONTINUE WITH REGISTRATION
                    UPS.UpsRegistrationInformation registration = new UPS.UpsRegistrationInformation();
                    registration.ContactName = ContactName.Text;
                    registration.ContactTitle = ContactTitle.Text;
                    registration.Company = CompanyName.Text;
                    registration.CompanyUrl = CompanyUrl.Text;
                    registration.Address1 = Address1.Text;
                    if (!String.IsNullOrEmpty(Address2.Text)) registration.Address2 = Address2.Text;
                    registration.City = City.Text;
                    registration.CountryCode = Country.SelectedValue;
                    if ((registration.CountryCode.Equals("US") || registration.CountryCode.Equals("CA")))
                    {
                        registration.StateProvinceCode = Province.Text;
                        registration.PostalCode = PostalCode.Text;
                    }
                    else
                    {
                        registration.StateProvinceCode = string.Empty;
                        registration.PostalCode = string.Empty;
                    }
                    Phone.Text = Phone.Text;
                    registration.ContactPhone = Phone.Text;
                    registration.ContactEmail = Email.Text;
                    registration.ShipperNumber = UpsAccount.Text;
                    registration.RequestContact = RequestContact.SelectedValue.Equals("YES");
                    try
                    {
                        // SEND THE REGISTRATION
                        UPS provider = new UPS();
                        ShipGateway gateway = new ShipGateway();
                        gateway.Name = provider.Name;
                        gateway.ClassId = Misc.GetClassId(typeof(UPS));
                        provider.Register(gateway, registration);
                        if (provider.IsActive)
                        {
                            gateway.UpdateConfigData(provider.GetConfigData());
                            gateway.Enabled = true;
                            gateway.Save();
                            Response.Redirect("Register.aspx?ShipGatewayId=" + gateway.Id);
                        }
                    }
                    catch (Exception ex)
                    {
                        AddCustomErrorMessage("Error during registration: " + ex.Message, RequestContact);
                    }
                }
            }
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }

        private void AddCustomErrorMessage(string message, Control controlToValidate)
        {
            CustomValidator customValidator = new CustomValidator();
            customValidator.IsValid = false;
            customValidator.ErrorMessage = message;
            customValidator.Text = "*";
            controlToValidate.Parent.Controls.Add(customValidator);
        }
    }
}