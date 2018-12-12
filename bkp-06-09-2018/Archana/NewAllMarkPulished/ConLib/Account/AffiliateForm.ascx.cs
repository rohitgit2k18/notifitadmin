namespace AbleCommerce.ConLib.Account
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Messaging;
    using System.Net.Mail;

    [Description("Implements the affiliate data input form")]
    public partial class AffiliateForm : System.Web.UI.UserControl
    {
        public Affiliate Affiliate { get; set; }
        private StoreSettingsManager settings;
        private string _subject = "New Affiliate Self-Signup";

        [Browsable(true), DefaultValue("New Affiliate Self-Signup")]
        [Description("Default email subject for the new affiliate self-signup.")]
        public string Subject
        {
            get { return _subject; }
            set { _subject = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            settings = AbleContext.Current.Store.Settings;
            Country.DataSource = CountryDataSource.LoadAll();
            Country.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                InitEditForm();
            }

            SaveAndClose.Visible = false;
            if (this.Affiliate != null)
            {
                CancelButon.Visible = true;
                SaveButton.Text = "Save";
                SaveAndClose.Visible = true;
            }
        }

        private void InitEditForm()
        {
            User user = AbleContext.Current.User;
            TaxId.Text = user.TaxExemptionReference;

            if (this.Affiliate != null)
            {
                // INITIALIZE FORM
                Name.Text = this.Affiliate.Name;
                WebsiteUrl.Text = this.Affiliate.WebsiteUrl;
                Email.Text = this.Affiliate.Email;
                FirstName.Text = this.Affiliate.FirstName;
                LastName.Text = this.Affiliate.LastName;
                Address1.Text = this.Affiliate.Address1;
                Address2.Text = this.Affiliate.Address2;
                City.Text = this.Affiliate.City;
                Province.Text = this.Affiliate.Province;
                PostalCode.Text = this.Affiliate.PostalCode;
                Country.DataSource = CountryDataSource.LoadAll("Name");
                Country.DataBind();
                if (string.IsNullOrEmpty(this.Affiliate.CountryCode)) this.Affiliate.CountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                ListItem selectedCountry = Country.Items.FindByValue(this.Affiliate.CountryCode);
                if (selectedCountry != null) Country.SelectedIndex = Country.Items.IndexOf(selectedCountry);
                Phone.Text = this.Affiliate.PhoneNumber;
                MobileNumber.Text = this.Affiliate.MobileNumber;
                FaxNumber.Text = this.Affiliate.FaxNumber;
                Company.Text = this.Affiliate.Company;
                InitCountryAndProvince(this.Affiliate.CountryCode, this.Affiliate.Province);
            }
            else
            {
                Name.Text = user.PrimaryAddress.FullName;
                FirstName.Text = user.PrimaryAddress.FirstName;
                LastName.Text = user.PrimaryAddress.LastName;
                Email.Text = user.Email;
                Address1.Text = user.PrimaryAddress.Address1;
                Address2.Text = user.PrimaryAddress.Address2;
                City.Text = user.PrimaryAddress.City;
                Province.Text = user.PrimaryAddress.Province;
                PostalCode.Text = user.PrimaryAddress.PostalCode;
                Country.DataSource = CountryDataSource.LoadAll("Name");
                Country.DataBind();
                if (string.IsNullOrEmpty(user.PrimaryAddress.CountryCode)) user.PrimaryAddress.CountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                ListItem selectedCountry = Country.Items.FindByValue(user.PrimaryAddress.CountryCode);
                if (selectedCountry != null) Country.SelectedIndex = Country.Items.IndexOf(selectedCountry);
                Phone.Text = user.PrimaryAddress.Phone;
                FaxNumber.Text = user.PrimaryAddress.Fax;
                Company.Text = user.PrimaryAddress.Company;
                InitCountryAndProvince(user.PrimaryAddress.CountryCode, user.PrimaryAddress.Province);
            }
        }

        private void InitCountryAndProvince(String countryCode, String province)
        {
            //MAKE SURE THE CORRECT ADDRESS IS SELECTED        
            bool foundCountry = false;
            if (!string.IsNullOrEmpty(countryCode))
            {
                ListItem selectedCountry = Country.Items.FindByValue(countryCode);
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
            if (Province.Visible) Province.Text = province;
            else
            {
                ListItem selectedProvince = Province2.Items.FindByValue(province);
                if (selectedProvince != null) Province2.SelectedIndex = Province2.Items.IndexOf(selectedProvince);
            }
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
                ListItem selectedProvince = Province2.Items.FindByValue(Request.Form[Province2.UniqueID]);
                if (selectedProvince != null) selectedProvince.Selected = true;
                Province2Required.Enabled = true;
            }
            else
            {
                Province.Visible = true;
                Province2.Visible = false;
                Province2.Items.Clear();
                Province2Required.Enabled = false;
            }
        }

        protected void Country_Changed(object sender, EventArgs e)
        {
            //UPDATE THE FORM FOR THE NEW COUNTRY
            UpdateCountry();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Save();
            }
        }

        protected void Save()
        {
            bool newAffilate = false;
            if (this.Affiliate == null)
            {
                this.Affiliate = new CommerceBuilder.Marketing.Affiliate();
                newAffilate = true;
            }
            this.Affiliate.Name = Name.Text;
            this.Affiliate.WebsiteUrl = WebsiteUrl.Text;
            this.Affiliate.Email = Email.Text;
            this.Affiliate.FirstName = FirstName.Text;
            this.Affiliate.LastName = LastName.Text;
            this.Affiliate.Address1 = Address1.Text;
            this.Affiliate.Address2 = Address2.Text;
            this.Affiliate.City = City.Text;
            this.Affiliate.Province = (Province.Visible ? StringHelper.StripHtml(Province.Text) : Province2.SelectedValue);
            this.Affiliate.PostalCode = PostalCode.Text;
            this.Affiliate.CountryCode = Country.SelectedValue;
            this.Affiliate.PhoneNumber = Phone.Text;
            this.Affiliate.FaxNumber = FaxNumber.Text;
            this.Affiliate.MobileNumber = MobileNumber.Text;
            this.Affiliate.Company = Company.Text;
            this.Affiliate.ReferralPeriodId = (byte)settings.AffiliatePersistence;
            this.Affiliate.ReferralPeriod = settings.AffiliatePersistence;
            this.Affiliate.ReferralDays = settings.AffiliateReferralPeriod;
            this.Affiliate.CommissionIsPercent = settings.AffiliateCommissionIsPercent;
            this.Affiliate.CommissionOnTotal = settings.AffiliateCommissionOnTotal;
            this.Affiliate.CommissionRate = (decimal)settings.AffiliateCommissionRate;

            // CREATE NEW AFFILIATE GROUP
            if (newAffilate)
            {
                Group group = new Group();
                group.Name = string.Format("Affiliate [{0}]", this.Affiliate.Name);
                group.Save();
                AbleContext.Current.User.UserGroups.Add(new UserGroup(AbleContext.Current.User, group));
                AbleContext.Current.User.Save();
                this.Affiliate.Group = group;
            }

            this.Affiliate.Save();

            // SAVE TAXID FIELD
            User user = AbleContext.Current.User;
            user.TaxExemptionReference = TaxId.Text;
            user.Save();

            // SEND AFFILIATE REGISTRATION EMAIL IF SELF SIGNUP IS ENABLED
            if (settings.AffiliateAllowSelfSignup && newAffilate)
            {                
                // SEND THE AFFILIATE SELF-SIGNUP EMAIL TO MERCHANT
                SendAffiliateEmail();

                // SEND THE AFFILIATE SELF-SIGNUP CONFIRMATION EMAIL TO CUSTOMER
                int emailTemplateId = settings.AffiliateRegistrationEmailTemplateId;
                EmailTemplate template = EmailTemplateDataSource.Load(emailTemplateId);
                if (template != null)
                {
                    template.Parameters.Add("store", AbleContext.Current.Store);
                    template.Parameters.Add("affiliate", this.Affiliate);
                    template.Send();
                }
            }

            if (newAffilate)
                Response.Redirect("~/Members/MyAffiliateAccount.aspx");
            SavedMessage.Visible = true;
        }

        private void SendAffiliateEmail()
        {
            MailMessage mailMessage = new MailMessage();
            mailMessage.To.Add(settings.DefaultEmailAddress);
            mailMessage.From = new System.Net.Mail.MailAddress(Email.Text);
            mailMessage.Subject = this.Subject;
            mailMessage.Body += "Name: " + FirstName.Text + " " + LastName.Text + Environment.NewLine;
            mailMessage.Body += "Email: " + Email.Text + Environment.NewLine;
            mailMessage.BodyEncoding = System.Text.Encoding.UTF8;
            mailMessage.IsBodyHtml = false;
            mailMessage.Priority = System.Net.Mail.MailPriority.High;
            SmtpSettings smtpSettings = SmtpSettings.DefaultSettings;

            try
            {
                EmailClient.Send(mailMessage);
            }
            catch (Exception exp)
            {
                Logger.Error("Affiliate Self-Signup Exception: Exp" + Environment.NewLine + exp.Message);
            }
        }

        protected void CancelButton_Click(Object sender, EventArgs e)
        {
            if(this.Affiliate != null)
                Response.Redirect("~/Members/MyAffiliateAccount.aspx");
            else
                Response.Redirect("~/Members/MyAccount.aspx");
        }

        protected void SaveAndClose_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Save();
                Response.Redirect("~/Members/MyAffiliateAccount.aspx");
            }
        }
    }
}