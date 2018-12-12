namespace AbleCommerce.Checkout
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class EditBillAddress : CommerceBuilder.UI.AbleCommercePage
    {
        private StoreSettingsManager _settings;
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
        
        protected void Page_Init(object sender, EventArgs e)
        {
            _settings = AbleContext.Current.Store.Settings;
            
            if (AbleContext.Current.User.Basket.Items.Count == 0)
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
            _addressValidator = AddressValidatorServiceLocator.Locate();
            Country.DataSource = CountryDataSource.LoadAll();
            Country.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (CheckQuoteBasketItems())
            {
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetQuotePageUrl());
            }
            if (!Page.IsPostBack)
            {
                InitAddressForm();
            }
            
            IntializeCreateAccountPanel();
            IntializeShippingPanel();
            IntializeEmailLists();
            PasswordValidatorPanel.Controls.Clear();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            string shipToOption = AlwaysConvert.ToString(Session["SHIP_TO_OPTION"]);
            if (!string.IsNullOrEmpty(shipToOption))
            {
                ListItem item = ShipToOption.Items.FindByValue(shipToOption);
                if (item != null)
                {
                    ShipToOption.ClearSelection();
                    item.Selected = true;
                }
            }
        }

        protected void BillingPageContinue_Click(Object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (UpdateAddress(true)) GoToNextPage();
            }
        }

        private bool UpdateAddress(bool validate)
        {
            // NEED TO REGISTER USER
            if (AbleContext.Current.User.IsAnonymous)
            {
                if (CreateNewAccountPanel.Visible)
                {
                    if (!CreateNewAccount())
                    {
                        return false;
                    }
                    else
                    {
                        CreateNewAccountPanel.Visible = false;
                    }
                }
                else
                {
                    // VALIDATE EMAIL, IF EMAIL IS ALREADY REGISTERED, ASK FOR LOGIN
                    string newEmail = StringHelper.StripHtml(BillToEmail.Text);
                    if (UserDataSource.IsEmailRegistered(newEmail))
                    {
                        InvalidRegistration.IsValid = false;
                        InvalidRegistration.ErrorMessage = "The email address you have provided is already registered. Please sign in to access your account.";
                        return false;
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

            // MAILING LIST SIGNUP
            if (EmailLists.Visible && EmailLists.Items.Count > 0)
            {
                string email = AbleContext.Current.User.Email;
                int listIndex = 0;
                IList<EmailList> emailLists = GetPublicEmailLists();
                if (emailLists != null && emailLists.Count > 0)
                {
                    foreach (ListViewDataItem item in EmailLists.Items)
                    {
                        EmailList list = emailLists[listIndex];
                        CheckBox selected = (CheckBox)item.FindControl("Selected");
                        if (selected != null)
                        {
                            if (selected.Checked)
                            {
                                EmailListSignup signup = EmailListSignupDataSource.Load(list.Id, email);
                                if (signup == null || signup.SignupDate < LocaleHelper.LocalNow.AddMinutes(-5))
                                    list.ProcessSignupRequest(email);
                            }
                            else
                                list.RemoveMember(email);
                        }
                        else list.RemoveMember(email);
                        listIndex++;
                    }
                }
            }

            string provinceName = string.Empty;
            if (ValidateProvince(out provinceName))
            {
                Address address = AbleContext.Current.User.PrimaryAddress;
                string address1 = StringHelper.StripHtml(Address1.Text);
                string address2 = StringHelper.StripHtml(Address2.Text);
                string city = StringHelper.StripHtml(City.Text);
                string postColde = StringHelper.StripHtml(PostalCode.Text);
                if (address.Address1 != address1 || address.Address2 != address2 || address.City != city || address.Province != provinceName || address.PostalCode != postColde)
                    address.Validated = false;
                address.FirstName = StringHelper.StripHtml(FirstName.Text);
                address.LastName = StringHelper.StripHtml(LastName.Text);
                address.Address1 = address1;
                address.Address2 = address2;
                address.Company = StringHelper.StripHtml(Company.Text);
                address.Email = trEmail.Visible ? StringHelper.StripHtml(BillToEmail.Text) : StringHelper.StripHtml(UserName.Text);
                address.City = city;
                address.Province = provinceName;
                address.PostalCode = postColde;
                address.CountryCode = Country.SelectedValue;
                address.Phone = StringHelper.StripHtml(Telephone.Text);
                address.Fax = StringHelper.StripHtml(Fax.Text);
                address.Residence = !IsBusinessAddress.Checked;
                address.Save();

                if (validate && !address.Validated && _addressValidator != null)
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

                                return false;
                            }
                        }
                    }
                }
            }
            else
            {
                Province2Invalid.IsValid = false;
                UpdateCountry();
                return false;
            }

            return true;
        }

        protected void GoToNextPage() 
        {
            string nextPageUrl = "Payment.aspx";
            if (ShippingAddressPanel.Visible)
            {
                switch (ShipToOption.SelectedValue)
                {
                    case "SHIP_TO_BILLING_ADDRESS":
                        // need to ensure all items are going to the billing address
                        Basket basket = AbleContext.Current.User.Basket;
                        IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                        preCheckoutService.Package(basket, true);
                        nextPageUrl = "ShipMethod.aspx";
                        break;

                    case "SHIP_TO_ADDRESS":
                        nextPageUrl = "ShipAddress.aspx";
                        break;

                    case "SHIP_TO_MULTIPLE_ADDRESSES":
                        nextPageUrl = "ShipAddresses.aspx";
                        break;
                }

                Session["SHIP_TO_OPTION"] = ShipToOption.SelectedValue;
            }

            Response.Redirect(nextPageUrl);
        }

        protected void UseValidAddressButton_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            if (!UpdateAddress(false)) return;

            if (ValidAddresses != null)
            {
                Address address = AbleContext.Current.User.PrimaryAddress;
                int id = AlwaysConvert.ToInt(ValidAddressesList.SelectedValue);
                if (id == 0)
                {
                    address.Validated = true;
                    address.Save();
                }
                else
                {
                    ValidAddress validAddress = (from va in ValidAddresses where va.Id == id select va).SingleOrDefault();
                    if (validAddress != null)
                    {
                        address.Address1 = validAddress.Address1;
                        address.Address2 = validAddress.Address2;
                        address.City = validAddress.City;
                        address.Province = validAddress.Province;
                        address.PostalCode = validAddress.PostalCode;
                        address.CountryCode = Country.SelectedValue;
                        address.Validated = true;
                        address.Save();
                    }
                }
            }

            ValidAddresses = null;
            GoToNextPage();
        }

        protected void CancelValidAddressButton_Click(Object sender, EventArgs e)
        {
            ValidAddresses = null;
            ValidAddressesList.Items.Clear();
            ValidAddressesPanel.Visible = false;
        }

        public Boolean CheckQuoteBasketItems()
        {
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);
            return basket.Items.Any(item => item.OrderItemType == OrderItemType.Product && (item.Price <= 0 || !(item.Product.VolumeDiscounts.Any() && item.Product.VolumeDiscounts[0].Levels.Any())));
        }

        #region SHIPPING

        protected void IntializeShippingPanel() 
        {
            bool hasShippableProducts = AbleContext.Current.User.Basket.Items.HasShippableProducts();
            bool allowsMultipleShipments = AbleContext.Current.Store.Settings.EnableShipToMultipleAddresses && AbleContext.Current.User.Basket.Items.ShippableProductCount() > 1;

            // IF THERE IS ATLEAST ONE SHIPPABLE PRODUCT THEN SHOW SHIPPING PANEL OTHERWISE HIDE IT
            if (hasShippableProducts)
            {
                ShippingAddressPanel.Visible = true;

                // IF MULTIPLE SHIPMENT OPTION IS NOT ALLOWED THEN REMOVE IT
                if (!allowsMultipleShipments)
                {
                    ListItem item = ShipToOption.Items.FindByValue("SHIP_TO_MULTIPLE_ADDRESSES");
                    if (item != null)
                        ShipToOption.Items.Remove(item);
                }

                NoShipmentPanel.Visible = false;
            }
            else
            {
                ShippingAddressPanel.Visible = false;
                NoShipmentPanel.Visible = true;
            }
        }

        #endregion

        #region NEW ACCOUNT

        protected void IntializeCreateAccountPanel()
        {
            bool showCreateAccount = false;
            if (_settings.AllowAnonymousCheckout && AbleContext.Current.User.IsAnonymous)
            {
                if (Request.QueryString["GC"] == "0")
                    showCreateAccount = false;
                else
                    showCreateAccount = true;
            }
            else
                if (!_settings.AllowAnonymousCheckout && AbleContext.Current.User.IsAnonymous)
                {
                    showCreateAccount = true;
                }
            
            // SHOW ACCOUNT PANEL ONLY IF REQUIRED
            if (showCreateAccount)
            {
                ShowPasswordPolicy();
                CreateNewAccountPanel.Visible = true;
                trEmail.Visible = false;
            }
            else
            {
                CreateNewAccountPanel.Visible = false;
            }
        }

        protected bool CreateNewAccount()
        {
            bool result = false;
            if (Page.IsValid && ValidatePassword())
            {
                if ((!trCaptchaField.Visible) || CaptchaImage.Authenticate(CaptchaInput.Text))
                {
                    // PERFORM CUSTOM VALIDATION TO ENSURE EMAIL IS NOT ALREADY REGISTERED
                    string userName = StringHelper.StripHtml(UserName.Text.Trim());
                    if (!UserDataSource.IsEmailRegistered(userName))
                    {
                        // NO USER REGISTERED WITH THAT USERNAME OR EMAIL 
                        MembershipCreateStatus status;
                        User newUser = UserDataSource.CreateUser(userName, userName, Password.Text, string.Empty, string.Empty, true, 0, out status);
                        if (status == MembershipCreateStatus.Success)
                        {
                            // WE HAVE TO VALIDATE CREDENTIALS SO A MODIFIED FORM POST CANNOT ACCESS THIS CODE
                            if (Membership.ValidateUser(userName, Password.Text))
                            {
                                // SET A DEFAULT BILLING ADDRESS FOR THE USER
                                newUser.PrimaryAddress.Email = userName;
                                newUser.PrimaryAddress.CountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                                newUser.PrimaryAddress.Residence = true;
                                newUser.Save();

                                // MIGRATE ACTIVE USER TO NEW ACCOUNT
                                CommerceBuilder.Users.User.Migrate(AbleContext.Current.User, newUser, false, true);
                                AbleContext.Current.User = newUser;
                                FormsAuthentication.SetAuthCookie(userName, false);
                                result = true;
                            }
                        }
                        else
                        {
                            InvalidRegistration.IsValid = false;
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
                    else
                    {
                        DuplicateEmailValidator.IsValid = false;
                    }
                }
                else
                {
                    //CAPTCHA IS VISIBLE AND DID NOT AUTHENTICATE
                    CustomValidator invalidInput = new CustomValidator();
                    invalidInput.Text = "*";
                    invalidInput.ErrorMessage = "You did not input the verification number correctly.";
                    invalidInput.IsValid = false;
                    phCaptchaValidators.Controls.Add(invalidInput);
                    CaptchaInput.Text = "";
                    Password.Attributes.Add("value", string.Empty);
                    RefreshCaptcha();
                }
            }

            return result;
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
            if (PasswordPolicyRequired.Visible)
            {
                if (requirements.Count > 1) requirements[requirements.Count - 1] = "and " + requirements[requirements.Count - 1];
                PasswordPolicyRequired.Text = string.Format(PasswordPolicyRequired.Text, string.Join(", ", requirements.ToArray()));
            }
            // SHOW THE REGISTRATION CAPTCHA IF CUSTOMER POLICY INDICATES IT
            trCaptchaField.Visible = policy.ImageCaptcha;
            trCaptchaImage.Visible = policy.ImageCaptcha;
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
                PasswordValidatorPanel.Controls.Add(policyValidator);
                return false;
            }
            return true;
        }

        protected void ChangeImageLink_Click(object sender, EventArgs e)
        {
            RefreshCaptcha();
            Password.Attributes.Add("value", Password.Text);
        }

        private void RefreshCaptcha()
        {
            CaptchaImage.ChallengeText = StringHelper.RandomNumber(6);
        }

        #endregion

        #region EMAIL LISTS

        private void IntializeEmailLists()
        {
            if (!Page.IsPostBack)
            {
                if (!AbleContext.Current.User.IsAnonymous || CreateNewAccountPanel.Visible)
                {
                    EmailLists.DataSource = GetPublicEmailLists();
                    EmailLists.DataBind();
                }
                else
                {
                    EmailLists.Visible = false;
                }
            }
        }

        private IList<EmailList> GetPublicEmailLists()
        {

            IList<EmailList> emailLists  = new List<EmailList>();
            IList<EmailList> allLists = EmailListDataSource.LoadAll("Name");
            foreach (EmailList list in allLists)
            {
                if (list.IsPublic) 
                    emailLists.Add(list);
            }
            
            return emailLists;
        }

        protected bool IsEmailListChecked(object dataItem)
        {
            User user = AbleContext.Current.User;
            if (user.IsAnonymous) return true;
            EmailList list = (EmailList)dataItem;
            return (list.IsMember(user.Email));
        }

        #endregion

        #region BILLING ADDRESS

        protected void InitAddressForm()
        {
            Address address = AbleContext.Current.User.PrimaryAddress;
            FirstName.Text = address.FirstName;
            LastName.Text = address.LastName;
            Address1.Text = address.Address1;
            Address2.Text = address.Address2;
            City.Text = address.City;
            PostalCode.Text = address.PostalCode;
            InitCountryAndProvince();
            Company.Text = address.Company;
            BillToEmail.Text = address.Email;
            Telephone.Text = address.Phone;
            Fax.Text = address.Fax;
            IsBusinessAddress.Checked = !address.Residence;
            AddressValidationPanel.Visible = _addressValidator != null;
        }

        private void InitCountryAndProvince()
        {
            //MAKE SURE THE CORRECT ADDRESS IS SELECTED
            Address address = AbleContext.Current.User.PrimaryAddress;
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

        #endregion
    }
}