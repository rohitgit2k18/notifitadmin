using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Shipping.Providers;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using System.Collections.Generic;
using CommerceBuilder.Shipping;

namespace AbleCommerce.Admin.Shipping.Warehouses
{
public partial class EditWarehouse : CommerceBuilder.UI.AbleCommerceAdminPage
{

    protected int _WarehouseId;
    protected Warehouse _Warehouse;

    protected void Page_Init(object sender, System.EventArgs e)
    {
        _WarehouseId = AlwaysConvert.ToInt(Request.QueryString["WarehouseId"]);
        _Warehouse = WarehouseDataSource.Load(_WarehouseId);
        if (_Warehouse == null) RedirectMe();
        Caption.Text = string.Format(Caption.Text, _Warehouse.Name);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Address1);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Address2);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(City);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Province);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Province2);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(PostalCode);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Country);
        Country.DataSource = CountryDataSource.LoadAll();
        Country.DataBind();
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Phone);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Fax);
        AbleCommerce.Code.PageHelper.SetDefaultButton(Email, SaveButton.ClientID);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            InitAddressForm();
        }
    }

    protected void InitAddressForm()
    {
        Name.Text = _Warehouse.Name;
        Address1.Text = _Warehouse.Address1;
        Address2.Text = _Warehouse.Address2;
        City.Text = _Warehouse.City;
        PostalCode.Text = _Warehouse.PostalCode;
        InitCountryAndProvince();
        Phone.Text = _Warehouse.Phone;
        Fax.Text = _Warehouse.Fax;
        Email.Text = _Warehouse.Email;
    }

    private void InitCountryAndProvince()
    {
        //MAKE SURE THE CORRECT ADDRESS IS SELECTED
        bool foundCountry = false;
        if (!string.IsNullOrEmpty(_Warehouse.CountryCode))
        {
            ListItem selectedCountry = Country.Items.FindByValue(_Warehouse.CountryCode);
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
        if (Province.Visible) Province.Text = _Warehouse.Province;
        else
        {
            ListItem selectedProvince = Province2.Items.FindByValue(_Warehouse.Province);
            if (selectedProvince != null) Province2.SelectedIndex = Province2.Items.IndexOf(selectedProvince);
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            SaveWareHouse();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }
    }

    public void SaveAndCloseButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            SaveWareHouse();
            RedirectMe();
        }
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        RedirectMe();
    }

    private void SaveWareHouse()
    {
        _Warehouse.Name = Name.Text;
        _Warehouse.Address1 = Address1.Text;
        _Warehouse.Address2 = Address2.Text;
        _Warehouse.City = City.Text;
        _Warehouse.Province = (Province.Visible ? Province.Text : Province2.SelectedValue);
        _Warehouse.PostalCode = PostalCode.Text;
        _Warehouse.CountryCode = Country.SelectedValue;
        _Warehouse.Phone = Phone.Text;
        _Warehouse.Fax = Fax.Text;
        _Warehouse.Email = Email.Text;
        IAddressValidatorService validationService = AddressValidatorServiceLocator.Locate();
        if (validationService != null) validationService.ValidateAddress(_Warehouse);
        _Warehouse.Save();
    }

    protected void RedirectMe()
    {
        Response.Redirect("Default.aspx");
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

}
}
