namespace AbleCommerce.Admin._Store.Security
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using System.Xml;
    using System.Web;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Store _Store;
        private StoreSettingsManager _Settings;
        private const int MAX_PAYMENT_LIFESPAN = 60;

        protected void Page_Init(object sender, EventArgs e)
        {
            for (int i = 0; i <= MAX_PAYMENT_LIFESPAN; i++)
            {
                PaymentLifespan.Items.Add(i.ToString());
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _Store = AbleContext.Current.Store;
            _Settings = _Store.Settings;
            if (!Page.IsPostBack)
            {
                // INITIALIZE FIELDS ON FIRST LOAD
                StoreUrl.Text = _Store.StoreUrl;
                SSLEnabled.Checked = _Settings.SSLEnabled;
                SecureAllPages.Checked = IsSecureAllPages();
                SSLDomain.Text = _Settings.EncryptedUri;
                FileExtAssets.Text = _Settings.FileExt_Assets;
                FileExtThemes.Text = _Settings.FileExt_Themes;
                FileExtDigitalGoods.Text = _Settings.FileExt_DigitalGoods;
                ListItem item = PaymentLifespan.Items.FindByValue(_Settings.PaymentLifespan.ToString());
                if (item != null) item.Selected = true;
                EnableCreditCardStorage.Checked = _Settings.EnableCreditCardStorage;

                // GET LIST OF LICENSED SUBDOMAINS
                CommerceBuilder.Licensing.License license = CommerceBuilder.Licensing.KeyService.GetCurrentLicense();
                List<string> subDomains = new List<string>();
                foreach (string domain in license.Domains)
                {
                    if (IsSubdomain(domain)) subDomains.Add(domain);
                }

                // BIND SUBDOMAIN LIST
                MobileDomain.DataSource = subDomains;
                MobileDomain.DataBind();
                ListItem subdomainItem = MobileDomain.Items.FindByValue(_Settings.MobileStoreDomain);
                if (subdomainItem != null) subdomainItem.Selected = true;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            SecureAllPages.Enabled = SSLEnabled.Checked;
            SecureAllPagesLabel.Enabled = SSLEnabled.Checked;
            if (SSLEnabled.Checked)
                SecureAllPagesLabel.Attributes.Remove("style");
            else
                SecureAllPagesLabel.Attributes.Add("style", "color:#BCBCBC;");
        }

        private bool RequireSslValidation()
        {
            // IF SSL IS NOT ENABLED, AND WE TURNED IT ON, WE NEED TO VALIDATE SETTINGS
            if (!_Settings.SSLEnabled) return SSLEnabled.Checked;
            // IF WE TURNED OFF SSL, THEN WE DON'T NEED FURTHER VALIDATION
            if (!SSLEnabled.Checked) { return false; }
            // SSL WAS AND IS ON.
            // IF SECURE DOMAIN CHANGED WE NEED TO REVALIDATE
            if (_Settings.EncryptedUri.ToLowerInvariant() != SSLDomain.Text.ToLowerInvariant()) return true;
            // IF STORE DOMAIN CHANGED, WE NEED TO REVALDIATE
            string existingStoreDomain = UrlHelper.GetDomainFromUrl(_Store.StoreUrl).ToLowerInvariant();
            string newStoreDomain = UrlHelper.GetDomainFromUrl(StoreUrl.Text).ToLowerInvariant();
            if (existingStoreDomain != newStoreDomain) return true;
            // WHATEVER CHANGED IS NOT GOING TO BREAK SSL
            return false;
        }

        private string GetTestSslUrl()
        {
            string testDomain = SSLDomain.Text;
            if (testDomain == string.Empty) testDomain = UrlHelper.GetDomainFromUrl(StoreUrl.Text);
            string adminUrl = Page.ResolveUrl(AbleCommerce.Code.NavigationHelper.GetAdminUrl("default.aspx"));
            return "https://" + testDomain + adminUrl;
        }

        /// <summary>
        /// ENSURE THAT WE HAVE VALID SECOND LEVEL DOMAINS 
        /// </summary>
        /// <returns></returns>
        private bool ValidateSecondLevelDomainMatch()
        {
            // NO NEED TO VALIDATE IF AN ALTERNATE DOMAIN IS NOT PROVIDED
            if (string.IsNullOrEmpty(SSLDomain.Text)) return true;

            // DETERMINE STANDARD AND SSL DOMAINS
            string storeDomain = UrlHelper.GetDomainFromUrl(StoreUrl.Text);
            string encryptedDomain = SSLDomain.Text;
            if (storeDomain.ToLowerInvariant() == encryptedDomain.ToLowerInvariant())
            {
                // THE STANDARD AND SSL DOMAINS MATCH, WE SHOULD NOT SPECIFY SSL DOMAIN
                SSLDomain.Text = string.Empty;
                return true;
            }

            // SEE WHETHER SECOND LEVEL DOMAINS MATCH
            string storeDomain2 = UrlHelper.GetSecondLevelDomainFromUrl(storeDomain);
            string encryptedDomain2 = UrlHelper.GetSecondLevelDomainFromUrl(encryptedDomain);

            // IF SECOND LEVEL DOMAINS MATCH, THE VALUES ARE ACCEPTABLE
            if (storeDomain2 == encryptedDomain2) return true;

            // SECOND LEVEL DOMAINS DO NOT MATCH
            // REGISTER CUSTOM ERROR MESSAGE AND RETURN FAILURE
            CustomValidator validator = new CustomValidator();
            validator.Text = "*";
            validator.ErrorMessage = "SSL domain cannot have a different second level domain as the store URL.  Store Domain: " + storeDomain2 + ", SSL Domain: " + encryptedDomain2;
            validator.IsValid = false;
            phSslDomain.Controls.Add(validator);
            return false;
        }

        private bool IsSubdomain(string domain)
        {
            if (string.IsNullOrEmpty(domain)) return false;
            string[] parts = domain.Split('.');
            if (parts.Length < 3) return false;
            string storeDomain = UrlHelper.GetDomainFromUrl(StoreUrl.Text);
            if (domain == storeDomain) return false;
            string storeDomain2 = UrlHelper.GetSecondLevelDomainFromUrl(storeDomain);
            string domain2 = UrlHelper.GetSecondLevelDomainFromUrl(domain);
            return (domain2 == storeDomain2);
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (RequireSslValidation())
                {
                    if (ValidateSecondLevelDomainMatch())
                    {
                        // SHOW THE DIALOG TO TEST AND APPROVE SSL SETTINGS
                        TestSslUrl.NavigateUrl = GetTestSslUrl();
                        TestSslUrl.Text = TestSslUrl.NavigateUrl;
                        ChangeSslPopup.Show();
                    }
                }
                else
                {
                    SaveSettings();
                }
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl());
        }

        protected void ConfirmChangeSslButton_Click(object sender, EventArgs e)
        {
            SaveSettings();
        }

        private void SaveSettings()
        {
            // SAVE THE URL/SSL CONFIGURATION
            _Store.StoreUrl = StoreUrl.Text;
            _Settings.SSLEnabled = SSLEnabled.Checked;
            if (_Settings.SSLEnabled && !string.IsNullOrEmpty(SSLDomain.Text))
            {
                // ENSURE CORRECT URI VALUES
                _Settings.EncryptedUri = SSLDomain.Text;
                _Settings.UnencryptedUri = UrlHelper.GetDomainFromUrl(_Store.StoreUrl);
            }
            else
            {
                // RESET URI VALUES
                SSLDomain.Text = string.Empty;
                _Settings.UnencryptedUri = string.Empty;
                _Settings.EncryptedUri = string.Empty;
            }

            _Settings.MobileStoreDomain = MobileDomain.SelectedValue;
            UpdatesSSLConfig(SecureAllPages.Checked);

            // IF NO SSL DOMAIN IS SET, COOKIE DOMAIN SHOULD BE BLANK (UNSET)
            // VERIFY WEB.CONFIG IS CONSISTENT WITH WHATEVER IS DETERMINED AS THE COOKIE DOMAIN
            string cookieDomain = UrlHelper.GetSecondLevelDomainFromUrl(_Settings.EncryptedUri);
            

            try
            {
                UrlHelper.UpdateWebConfigCookieDomain(cookieDomain);
            }
            catch (Exception exp)
            {
                phSslDomain.Controls.Add(new LiteralControl("<br />"));
                Label error = new Label();
                error.SkinID = "ErrorCondition";
                error.Text = "There was a problem attempting to save this change,<br /> please read error log for more details.";
                phSslDomain.Controls.Add(error);
                Logger.Error("Unable to save SSL changes in web.config", exp);
            }

            // SAVE FILE EXTENSIONS
            _Settings.FileExt_Assets = FileExtAssets.Text;
            _Settings.FileExt_Themes = FileExtThemes.Text;
            _Settings.FileExt_DigitalGoods = FileExtDigitalGoods.Text;

            // SET PAYMENT ACCOUNT SETTINGS
            _Settings.PaymentLifespan = AlwaysConvert.ToInt(PaymentLifespan.SelectedValue);
            _Settings.EnableCreditCardStorage = EnableCreditCardStorage.Checked;

            // SAVE ALL AND DISPLAY CONFIRMATION
            _Store.Save();
            AppCache.Clear();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        private bool IsSecureAllPages() 
        {
            XmlDocument sslDoc = new XmlDocument();
            sslDoc.Load(FileHelper.SafeMapPath("~/App_Data/ssl.config"));
            XmlNode webrootNode = sslDoc.DocumentElement.SelectSingleNode("//securePages/directory[@path='/']");
            return webrootNode != null;
        }

        private void UpdatesSSLConfig(bool secureAllPages) 
        {
            string filePath = FileHelper.SafeMapPath("~/App_Data/ssl.config");
            XmlDocument sslDoc = new XmlDocument();
            sslDoc.LoadXml(FileHelper.ReadText(filePath));
            XmlNode webrootNode = sslDoc.DocumentElement.SelectSingleNode("//securePages/directory[@path='/']");

            if (secureAllPages)
            {
                if (webrootNode == null)
                {
                    XmlElement wre = sslDoc.CreateElement("directory");
                    XmlAttribute path = sslDoc.CreateAttribute("path");
                    path.Value = "/";
                    wre.Attributes.Append(path);
                    XmlNode securePages = sslDoc.DocumentElement.SelectSingleNode("//securePages");
                    if (securePages != null)
                    {
                        securePages.AppendChild(wre);
                        sslDoc.Save(filePath);
                    }
                }
            }
            else
            {
                if (webrootNode != null)
                {
                    webrootNode.ParentNode.RemoveChild(webrootNode);
                    sslDoc.Save(filePath);
                }
            }

            // RESTART THE APPLICATION TO INVALIDATE THE CACHE 
            HttpRuntime.UnloadAppDomain();
        }
    }
}