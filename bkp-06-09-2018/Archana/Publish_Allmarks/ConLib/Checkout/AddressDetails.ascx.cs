using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Users;
using CommerceBuilder.Shipping;
using CommerceBuilder.Common;
using CommerceBuilder.Utility;
using System.Web.Security;
using CommerceBuilder.Orders;

namespace AbleCommerce.ConLib.Checkout
{
    public partial class AddressDetails : System.Web.UI.UserControl
    {
        private Address _address { get; set; }        
        public bool CollectEmail { get; set; }
        
        public string ValidationGroupName { get; set; }

        private bool _loadHiddenAddrId = true;
        private int _AddressId;
        public int AddressId
        {
            get { return _AddressId; }
            set 
            { 
                _AddressId = value;
                if (_AddressId != 0)
                {
                    _loadHiddenAddrId = false;
                }
                else
                {
                    _loadHiddenAddrId = true;
                }
            }
        }        

        public event AddressUpdateEventHandler OnAddressUpdate;
        public event EventHandler OnAddressCancel;
                
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            {
                // try to load the address id from postback
                if (_loadHiddenAddrId)
                {
                    AddressId = AlwaysConvert.ToInt(HiddenAddressId.Value);
                }
            }
            DoLoad(false);
        }

        protected void Page_PreRender()
        {
            HiddenAddressId.Value = AddressId.ToString();

            bool loginRequired = false;
            User user = AbleContext.Current.User;
            Basket basket = user.Basket;

            if (user.IsAnonymousOrGuest)
            {
                CreateAccount.Visible = true;
                if (basket.Items.HasDigitalGoods() || basket.Items.HasSubscriptions())
                {
                    loginRequired = !(AbleContext.Current.Store.Settings.AllowAnonymousCheckout && AbleContext.Current.Store.Settings.AllowAnonymousCheckoutForDigitalGoods);
                }
                else
                {
                    loginRequired = !AbleContext.Current.Store.Settings.AllowAnonymousCheckout;
                }
            }

            if (loginRequired)
            {
                CreateAccount.Visible = false;
                CreateAccountUpdatePanel.Visible = true;
                CreateAccountPh.Visible = true;
            }
        }

        protected void DoLoad(bool external)
        {
            _address = AddressDataSource.Load(AddressId);
            if (_address == null)
                _address = new Address();

            if (!string.IsNullOrEmpty(ValidationGroupName))
            {
                EmailAddressValid.ValidationGroup = ValidationGroupName;
                FirstNameRequired.ValidationGroup = ValidationGroupName;
                LastNameRequired.ValidationGroup = ValidationGroupName;
                Address1Required.ValidationGroup = ValidationGroupName;
                CityRequired.ValidationGroup = ValidationGroupName;
                PostalCodeRequired.ValidationGroup = ValidationGroupName;
                Province2Invalid.ValidationGroup = ValidationGroupName;
                Province2Required.ValidationGroup = ValidationGroupName;
                TelephoneRequired.ValidationGroup = ValidationGroupName;
                SaveButton.ValidationGroup = ValidationGroupName;
                RegisterValidationSummary.ValidationGroup = ValidationGroupName;

                // PASSWORD FIELDS
                PasswordRequired.ValidationGroup = ValidationGroupName;
                ConfirmPasswordRequired.ValidationGroup = ValidationGroupName;
                PasswordCompare.ValidationGroup = ValidationGroupName;
                DuplicateEmailValidator.ValidationGroup = ValidationGroupName;
                InvalidRegistration.ValidationGroup = ValidationGroupName;
            }

            if (!Page.IsPostBack || external)
            {
                Country.DataSource = CountryDataSource.LoadAll();
                Country.DataBind();
                InitAddressForm();
            }
            // handle create account options
            
            CreateAccountUpdatePanel.Visible = AbleContext.Current.User.IsAnonymousOrGuest;
            if (CreateAccountUpdatePanel.Visible) ShowPasswordPolicy();
        }

        public void Reload()
        {
            DoLoad(true);
        }

        protected void InitAddressForm()
        {
            EmailPanel.Visible = this.CollectEmail;
            FirstName.Text = _address.FirstName;
            LastName.Text = _address.LastName;
            Address1.Text = _address.Address1;
            Address2.Text = _address.Address2;
            City.Text = _address.City;
            PostalCode.Text = _address.PostalCode;
            InitCountryAndProvince();
            Company.Text = _address.Company;
            Email.Text = _address.Email;
            Telephone.Text = _address.Phone;
            Fax.Text = _address.Fax;
            Residence.SelectedIndex = _address.Residence ? 0 : 1;
        }

        private void InitCountryAndProvince()
        {
            //MAKE SURE THE CORRECT ADDRESS IS SELECTED
            bool foundCountry = false;
            if (!string.IsNullOrEmpty(_address.CountryCode))
            {
                ListItem selectedCountry = Country.Items.FindByValue(_address.CountryCode);
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
            if (Province.Visible) Province.Text = _address.Province;
            else
            {
                ListItem selectedProvince = Province2.Items.FindByValue(_address.Province);
                if (selectedProvince != null) Province2.SelectedIndex = Province2.Items.IndexOf(selectedProvince);
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

        private void UpdateCountry()
        {
            //SEE WHETHER POSTAL CODE IS REQUIRED
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            PostalCodeRequired.Enabled = (Array.IndexOf(countries, Country.SelectedValue) > -1);
            PostalCodeRequiredLabel.Visible = PostalCodeRequired.Enabled;
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

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            string provinceName = string.Empty;
            if (!ValidateProvince(out provinceName)) return;

            // NEED TO REGISTER USER
            if (AbleContext.Current.User.IsAnonymousOrGuest)
            {
                if (CreateAccountPh.Visible)
                {
                    bool result = false;
                    result = ValidatePassword();
                    if (result)
                    {
                        // PERFORM CUSTOM VALIDATION TO ENSURE EMAIL IS NOT ALREADY REGISTERED
                        string userName = StringHelper.StripHtml(Email.Text);
                        if (!UserDataSource.IsEmailRegistered(userName))
                        {
                            // CHECK IF THE USER GUEST ACCOUNT EXISTS ALREADY
                            if (AbleContext.Current.User.IsGuest)
                            {                                
                                // MIGRATE ACTIVE USER TO NEW ACCOUNT
                                AbleContext.Current.User.UserName = userName;
                                AbleContext.Current.User.SetPassword(Password.Text);
                                AbleContext.Current.User.Save();
                                FormsAuthentication.SetAuthCookie(userName, false);
                            }
                            else
                            {

                                // NO USER REGISTERED WITH THAT USERNAME OR EMAIL 
                                MembershipCreateStatus status;
                                User newUser = UserDataSource.CreateUser(userName, userName, Password.Text, string.Empty, string.Empty, true, 0, out status);
                                if (status == MembershipCreateStatus.Success)
                                {
                                    // WE HAVE TO VALIDATE CREDENTIALS SO A MODIFIED FORM POST CANNOT ACCESS THIS CODE
                                    if (Membership.ValidateUser(userName, Password.Text))
                                    {
                                        // MIGRATE ACTIVE USER TO NEW ACCOUNT
                                        CommerceBuilder.Users.User.Migrate(AbleContext.Current.User, newUser, true, true, true);
                                        AbleContext.Current.User = newUser;
                                        FormsAuthentication.SetAuthCookie(userName, false);
                                    }
                                }
                                else
                                {
                                    result = false;
                                    InvalidRegistration.IsValid = result;
                                    switch (status)
                                    {
                                        case MembershipCreateStatus.DuplicateUserName:
                                        case MembershipCreateStatus.DuplicateEmail:
                                            InvalidRegistration.ErrorMessage = "The user-name you have provided is already registered.  Sign in to access your account.";
                                            break;
                                        case MembershipCreateStatus.InvalidEmail:
                                            InvalidRegistration.ErrorMessage = "The email address you have provided is not valid.";
                                            break;
                                        case MembershipCreateStatus.InvalidUserName:
                                            InvalidRegistration.ErrorMessage = "The user-name you have provided is not valid.";
                                            break;
                                        case MembershipCreateStatus.InvalidPassword:
                                            InvalidRegistration.ErrorMessage = "The password you have provided is not valid.";
                                            break;
                                        default:
                                            InvalidRegistration.ErrorMessage = "Unexpected error in registration (" + status.ToString() + ")";
                                            break;
                                    }
                                }
                            }
                        }
                        else
                        {
                            result = false;
                            DuplicateEmailValidator.IsValid = false;
                        }
                    }

                    if (!result) return;
                }
                else if (AbleContext.Current.User.IsAnonymous)
                {
                    // VALIDATE EMAIL, IF EMAIL IS ALREADY REGISTERED, ASK FOR LOGIN
                    string newEmail = StringHelper.StripHtml(Email.Text);
                    if (UserDataSource.IsEmailRegistered(newEmail))
                    {
                        InvalidRegistration.IsValid = false;
                        InvalidRegistration.ErrorMessage = "The email address you have provided is already registered. Please sign in to access your account.";
                        return;
                    }

                    // ANONYMOUS USER SELECTING GUEST CHECKOUT, CREATE TEMPORARY ACCOUNT
                    User oldUser = AbleContext.Current.User;
                    string newUserName = "zz_anonymous_" + Guid.NewGuid().ToString("N") + "@domain.xyz";
                    string newPassword = Guid.NewGuid().ToString("N");
                    MembershipCreateStatus createStatus;
                    User newUser = UserDataSource.CreateUser(newUserName, newEmail, newPassword, string.Empty, string.Empty, true, 0, out createStatus);

                    // IF THE CREATE FAILS, IGNORE AND CONTINUE CREATING THE ORDER
                    if (createStatus == MembershipCreateStatus.Success)
                    {
                        // CHANGE THE NAME AND EMAIL TO SOMETHING MORE FRIENDLY THAN GUID
                        newUser.UserName = "zz_anonymous_" + newUser.Id.ToString() + "@domain.xyz";
                        newUser.Save();
                        CommerceBuilder.Users.User.Migrate(oldUser, newUser, true, true);
                        AbleContext.Current.User = newUser;
                        FormsAuthentication.SetAuthCookie(newUser.UserName, false);
                    }
                }
            }

            string address1 = StringHelper.StripHtml(Address1.Text);
            string address2 = StringHelper.StripHtml(Address2.Text);
            string city = StringHelper.StripHtml(City.Text);
            string postColde = StringHelper.StripHtml(PostalCode.Text);
            if (_address.Address1 != address1 || _address.Address2 != address2 || _address.City != city || _address.Province != provinceName || _address.PostalCode != postColde)
                _address.Validated = false;
            _address.FirstName = StringHelper.StripHtml(FirstName.Text);
            _address.LastName = StringHelper.StripHtml(LastName.Text);
            if(CollectEmail)
            _address.Email = StringHelper.StripHtml(Email.Text);
            _address.Address1 = address1;
            _address.Address2 = address2;
            _address.Company = StringHelper.StripHtml(Company.Text);
            _address.City = city;
            _address.Province = provinceName;
            _address.PostalCode = postColde;
            _address.CountryCode = Country.SelectedValue;
            _address.Phone = StringHelper.StripHtml(Telephone.Text);
            _address.Fax = StringHelper.StripHtml(Fax.Text);
            _address.Residence = Residence.SelectedIndex == 0;

            if (OnAddressUpdate != null)
                OnAddressUpdate(this, new AddressEventArgs(_address));
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            if (OnAddressCancel != null)
                OnAddressCancel(this, new EventArgs());
        }

        #region createAccount

        protected void CreateAccount_CheckedChanged(object sender, EventArgs e)
        {
            CreateAccountPh.Visible = CreateAccount.Checked;
            ShowPasswordPolicy();
        }

        private bool ValidatePassword()
        {
            //VALIDATE PASSWORD POLICY
            CustomerPasswordPolicy policy = new CustomerPasswordPolicy();
            if (!policy.TestPassword(null, Password.Text))
            {
                CustomValidator policyValidator = new CustomValidator();
                policyValidator.ControlToValidate = "Password";
                policyValidator.IsValid = false;
                policyValidator.Text = "*";
                policyValidator.ErrorMessage = "The password does not meet the minimum requirements.";
                policyValidator.SetFocusOnError = false;
                policyValidator.ValidationGroup = ValidationGroupName;
                policyValidator.CssClass = "requiredField";
                PasswordValidatorPanel.Controls.Add(policyValidator);

                // CELAR PASSWORD
                Password.Attributes.Add("value", string.Empty);
                ConfirmPassword.Attributes.Add("value", string.Empty);
                return false;
            }
            return true;
        }

        private bool _PasswordLengthValidatorAdded = false;
        private void ShowPasswordPolicy()
        {
            //SHOW THE PASSWORD POLICY
            CustomerPasswordPolicy policy = new CustomerPasswordPolicy();
            if (policy.MinLength > 0)
            {
                PasswordPolicyLength.Text = string.Format(PasswordPolicyLength.Text, policy.MinLength);
                if (!_PasswordLengthValidatorAdded)
                {
                    RegularExpressionValidator PasswordLengthValidator = new RegularExpressionValidator();
                    PasswordLengthValidator.ID = "PasswordLengthValidator";
                    PasswordLengthValidator.EnableViewState = false;
                    PasswordLengthValidator.ControlToValidate = "Password";
                    PasswordLengthValidator.Text = "*";
                    PasswordLengthValidator.ErrorMessage = "Password must be at least " + policy.MinLength.ToString() + " characters.";
                    PasswordLengthValidator.ValidationExpression = ".{" + policy.MinLength.ToString() + ",}";
                    PasswordLengthValidator.SetFocusOnError = false;
                    PasswordLengthValidator.EnableClientScript = false;
                    PasswordLengthValidator.ValidationGroup = ValidationGroupName;
                    PasswordLengthValidator.CssClass = "requiredField";
                    PasswordValidatorPanel.Controls.Add(PasswordLengthValidator);
                    _PasswordLengthValidatorAdded = true;
                }
            }
            else PasswordPolicyLength.Visible = false;
            List<string> requirements = new List<string>();
            if (policy.RequireUpper) requirements.Add("uppercase letter");
            if (policy.RequireLower) requirements.Add("lowercase letter");
            if (policy.RequireNumber) requirements.Add("number");
            if (policy.RequireSymbol) requirements.Add("symbol");
            if (!policy.RequireNumber && !policy.RequireSymbol && policy.RequireNonAlpha) requirements.Add("non-letter");
            PasswordPolicyRequired.Visible = (requirements.Count > 0);
            if (requirements.Count > 0)
            {
                if (requirements.Count > 1) requirements[requirements.Count - 1] = "and " + requirements[requirements.Count - 1];
                PasswordPolicyRequired.Text = string.Format(PasswordPolicyRequired.Text, string.Join(", ", requirements.ToArray()));
            }
        }
        #endregion
    }

    public class AddressEventArgs : EventArgs 
    {
        public int AddressId { get; set; }

        public Address Address { get; set; }

        public AddressEventArgs(Address address) 
        {
            Address = address;
            AddressId = address.Id;
        }
    }

    public delegate void AddressUpdateEventHandler(object sender, AddressEventArgs e);    
}