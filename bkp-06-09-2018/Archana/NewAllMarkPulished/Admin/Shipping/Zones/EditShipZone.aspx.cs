using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Common;
using CommerceBuilder.Shipping;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Shipping.Zones
{
public partial class EditShipZone : CommerceBuilder.UI.AbleCommerceAdminPage
{
    private int _ShipZoneId = 0;
    private ShipZone _ShipZone;
    
    protected void RedirectMe()
    {
        Response.Redirect("Default.aspx");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        InitJs();
        _ShipZoneId = AlwaysConvert.ToInt(Request.QueryString["ShipZoneId"]);
        _ShipZone = ShipZoneDataSource.Load(_ShipZoneId);
        if (_ShipZone == null) RedirectMe();
        Caption.Text = string.Format(Caption.Text, _ShipZone.Name);
        if (!Page.IsPostBack)
        {
            Name.Text = _ShipZone.Name;
            PostalCodeFilter.Text = _ShipZone.PostalCodeFilter;
            ExcludePostalCodeFilter.Text = _ShipZone.ExcludePostalCodeFilter;
            CountryRule.SelectedIndex = _ShipZone.CountryRuleId;
            trCountryList.Visible = CountryRule.SelectedIndex > 0;
            CountryList.Text = GetCountryList();
            ProvinceRule.SelectedIndex = _ShipZone.ProvinceRuleId;
            trProvinceList.Visible = ProvinceRule.SelectedIndex > 0;
            ProvinceList.Text = GetProvinceList();
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        InitializeChangeCountryDialog();
        InitializeChangeProvinceDialog();
    }

    private void InitJs()
    {
        this.Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "selectbox", this.ResolveUrl("~/Scripts/selectbox.js"));
        string leftBoxName = AvailableCountries.ClientID;
        string rightBoxName = SelectedCountries.ClientID;
        AvailableCountries.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, '')");
        SelectedCountries.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, '');");
        SelectAllCountries.Attributes.Add("onclick", "moveAllOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, ''); return false;");
        SelectCountry.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, ''); return false;");
        UnselectCountry.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, ''); return false;");
        UnselectAllCountries.Attributes.Add("onclick", "moveAllOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, ''); return false;");
        ChangeCountryListOKButton.OnClientClick = HiddenSelectedCountries.ClientID + ".value=getOptions(" + rightBoxName + ")";
        leftBoxName = AvailableProvinces.ClientID;
        rightBoxName = SelectedProvinces.ClientID;
        AvailableProvinces.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, '')");
        SelectedProvinces.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, '');");
        SelectAllProvinces.Attributes.Add("onclick", "moveAllOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, ''); return false;");
        SelectProvince.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, ''); return false;");
        UnselectProvince.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, ''); return false;");
        UnselectAllProvinces.Attributes.Add("onclick", "moveAllOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, ''); return false;");
        ChangeProvinceListOKButton.OnClientClick = HiddenSelectedProvinces.ClientID + ".value=getOptions(" + rightBoxName + ")";
    }

    private void InitializeChangeCountryDialog()
    {
        AvailableCountries.Items.Clear();
        SelectedCountries.Items.Clear();
        IList<Country> allCountries = CountryDataSource.LoadAll();
        foreach (Country c in allCountries)
        {
            ListItem newItem = new ListItem(c.Name, c.Id);
            bool countrySelected = (_ShipZone.Countries.IndexOf(c) > -1);
            if (countrySelected) SelectedCountries.Items.Add(newItem);
            else AvailableCountries.Items.Add(newItem);
        }
    }

    private IList<Country> GetProvinceCountries()
    {
        if (_ShipZone.CountryRule == FilterRule.All) return CountryDataSource.LoadAll();
        IList<Country> includedCountries = new List<Country>();
        if (_ShipZone.CountryRule == FilterRule.IncludeSelected)
        {
            foreach (Country country in _ShipZone.Countries)
                includedCountries.Add(country);
        }
        else
        {
            IList<Country> allCountries = CountryDataSource.LoadAll();
            foreach (Country c in allCountries)
            {
                if (_ShipZone.Countries.IndexOf(c) < 0)
                    includedCountries.Add(c);
            }
        }
        return includedCountries;
    }

    private void InitializeChangeProvinceDialog()
    {
        AvailableProvinces.Items.Clear();
        SelectedProvinces.Items.Clear();
        IList<Country> provinceCountries = GetProvinceCountries();
        foreach (Country c in provinceCountries)
        {
            foreach (Province p in c.Provinces)
            {
                ListItem newItem = new ListItem(c.Name + " : " + p.Name, c.Id + ":" + p.Name);
                bool ProvinceSelected = (_ShipZone.Provinces.IndexOf(p) > -1);
                if (ProvinceSelected) SelectedProvinces.Items.Add(newItem);
                else AvailableProvinces.Items.Add(newItem);
            }
        }
    }

    private string GetCountryList()
    {
        List<string> countries = new List<string>();
        foreach (Country country in _ShipZone.Countries)
        {
            countries.Add(country.Name);
        }
        return string.Join(",", countries.ToArray());
    }

    private string GetProvinceList()
    {
        List<string> provinces = new List<string>();
        foreach (Province province in _ShipZone.Provinces)
        {
            provinces.Add(province.Name);
        }
        return string.Join(", ", provinces.ToArray());
    }

    protected void ChangeCountryListOKButton_Click(object sender, System.EventArgs e)
    {
        string controlName = HiddenSelectedCountries.UniqueID;
        string postedValue = Request.Form[controlName];
        //REMOVE ALL COUNTRIES ASSOCIATED WITH SHIPZONE
        _ShipZone.Countries.Clear();
        _ShipZone.Save();
        if (!string.IsNullOrEmpty(postedValue))
        {
            //GET LIST OF VALID COUNTRY CODES
            List<string> validCountryCodes = GetValidCountryCodes();
            //ADD SELECTED COUNTRIES BACK IN
            string[] postedCountryCodes = postedValue.Split(",".ToCharArray());
            foreach (string tempCode in postedCountryCodes)
            {
                string countryCode = tempCode.Trim();
                if (validCountryCodes.Contains(countryCode))
                {
                    Country country = CountryDataSource.Load(countryCode);
                    _ShipZone.Countries.Add(country);
                }
            }
            _ShipZone.Save();
        }
        CountryList.Text = GetCountryList();
    }

    protected void ChangeProvinceListOKButton_Click(object sender, System.EventArgs e)
    {
        string controlName = HiddenSelectedProvinces.UniqueID;
        string postedValue = Request.Form[controlName];
        //REMOVE ALL Provinces ASSOCIATED WITH SHIPZONE
        _ShipZone.Provinces.Clear();
        _ShipZone.Provinces.Save();
        if (!string.IsNullOrEmpty(postedValue))
        {
            //ADD SELECTED Provinces BACK IN
            List<string> validCountryCodes = GetValidCountryCodes();
            string[] postedProvinceCodes = postedValue.Split(",".ToCharArray());
            foreach (string tempCode in postedProvinceCodes)
            {
                string[] codeParts = tempCode.Split(":".ToCharArray());
                if (codeParts.Length == 2)
                {
                    string countryCode = codeParts[0].Trim();
                    if (validCountryCodes.Contains(countryCode))
                    {
                        string provinceName = codeParts[1].Trim();
                        int provinceId = ProvinceDataSource.GetProvinceIdByName(countryCode, provinceName);
                        if (provinceId > 0)
                        {
                            Province province = ProvinceDataSource.Load(provinceId);
                            _ShipZone.Provinces.Add(province);
                        }
                    }
                }
            }
            _ShipZone.Save();
        }
        ProvinceList.Text = GetProvinceList();
    }

    private List<string> GetValidCountryCodes()
    {
        List<string> allCountryCodes = new List<string>();
        IList<Country> allCountries = CountryDataSource.LoadAll();
        foreach (Country c in allCountries) allCountryCodes.Add(c.Id);
        return allCountryCodes;
    }

    protected void SaveButton_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid)
        {
            SaveShipZones();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        RedirectMe();
    }

    public void SaveAndCloseButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            SaveShipZones();
            RedirectMe();
        }
    }

    private void SaveShipZones()
    {
        _ShipZone.Name = Name.Text;
        _ShipZone.CountryRuleId = (byte)CountryRule.SelectedIndex;
        if (_ShipZone.CountryRuleId < 0 || _ShipZone.CountryRuleId > 2) _ShipZone.CountryRuleId = (byte)1;
        _ShipZone.PostalCodeFilter = PostalCodeFilter.Text;
        _ShipZone.ExcludePostalCodeFilter = ExcludePostalCodeFilter.Text;
        _ShipZone.ProvinceRuleId = (byte)ProvinceRule.SelectedIndex;
        if (_ShipZone.ProvinceRuleId < 0 || _ShipZone.ProvinceRuleId > 2) _ShipZone.ProvinceRuleId = (byte)1;
        _ShipZone.Save();
    }

    protected void CountryRule_SelectedIndexChanged(object sender, EventArgs e)
    {
        _ShipZone.CountryRuleId = (byte)CountryRule.SelectedIndex;
        if (_ShipZone.CountryRuleId < 0 || _ShipZone.CountryRuleId > 2) _ShipZone.CountryRuleId = (byte)1;
        _ShipZone.Save();
        trCountryList.Visible = (_ShipZone.CountryRuleId > 0);
    }

    protected void ProvinceRule_SelectedIndexChanged(object sender, EventArgs e)
    {
        _ShipZone.ProvinceRuleId = (byte)ProvinceRule.SelectedIndex;
        if (_ShipZone.ProvinceRuleId < 0 || _ShipZone.ProvinceRuleId > 2) _ShipZone.ProvinceRuleId = (byte)1;
        _ShipZone.Save();
        trProvinceList.Visible = (_ShipZone.ProvinceRuleId > 0);
    }
}
}
