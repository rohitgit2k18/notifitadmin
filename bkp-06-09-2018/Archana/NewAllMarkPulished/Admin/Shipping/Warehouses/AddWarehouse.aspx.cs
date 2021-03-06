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
public partial class AddWarehouse : CommerceBuilder.UI.AbleCommerceAdminPage
{

    protected void Page_Init(object sender, System.EventArgs e)
    {
        Country.DataSource = CountryDataSource.LoadAll();
        Country.DataBind();
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Address1);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Address2);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(City);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Province);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Province2);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(PostalCode);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Country);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Phone);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Fax);
        AbleCommerce.Code.PageHelper.SetDefaultButton(Email, SaveButton.ClientID);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            InitCountryAndProvince();
        }
    }

    private void InitCountryAndProvince()
    {
        //MAKE SURE THE CORRECT ADDRESS IS SELECTED
        Warehouse defaultWarehouse = AbleContext.Current.Store.DefaultWarehouse;
        ListItem selectedCountry = Country.Items.FindByValue(defaultWarehouse.CountryCode);
        if (selectedCountry != null) Country.SelectedIndex = Country.Items.IndexOf(selectedCountry);
        //MAKE SURE THE PROVINCE LIST IS CORRECT FOR THE COUNTRY
        UpdateCountry();
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid) {
            Warehouse warehouse = new Warehouse();
            warehouse.Name = Name.Text;
            warehouse.Address1 = Address1.Text;
            warehouse.Address2 = Address2.Text;
            warehouse.City = City.Text;
            warehouse.Province = (Province.Visible ? Province.Text : Province2.SelectedValue);
            warehouse.PostalCode = PostalCode.Text;
            warehouse.CountryCode = Country.SelectedValue;
            warehouse.Phone = Phone.Text;
            warehouse.Fax = Fax.Text;
            warehouse.Email = Email.Text;
            IAddressValidatorService validationService = AddressValidatorServiceLocator.Locate();
            if (validationService != null) validationService.ValidateAddress(warehouse);
            warehouse.Save();
            Response.Redirect("Default.aspx");
        }
    }
    
    protected void CancelButton_Click(object sender, EventArgs e) {
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
