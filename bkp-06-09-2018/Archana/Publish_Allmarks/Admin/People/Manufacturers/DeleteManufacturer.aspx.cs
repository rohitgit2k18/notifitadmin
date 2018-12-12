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
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using System.Collections.Generic;

namespace AbleCommerce.Admin.People.Manufacturers
{
public partial class DeleteManufacturer : CommerceBuilder.UI.AbleCommerceAdminPage
{

    int _ManufacturerId = 0;
    Manufacturer _Manufacturer;

    protected void Page_Init(object sender, System.EventArgs e)
    {
        _ManufacturerId = AlwaysConvert.ToInt(Request.QueryString["ManufacturerId"]);
        _Manufacturer = ManufacturerDataSource.Load(_ManufacturerId);
        if (_Manufacturer == null) Response.Redirect("Default.aspx");
        Caption.Text = string.Format(Caption.Text, _Manufacturer.Name);
        InstructionText.Text = string.Format(InstructionText.Text, _Manufacturer.Name);
        BindManufacturers();
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }

    protected void DeleteButton_Click(object sender, System.EventArgs e)
    {
        int manufacturerId = AlwaysConvert.ToInt(ManufacturerList.SelectedValue);
        if(manufacturerId > 0) _Manufacturer.Delete(manufacturerId);
        else _Manufacturer.Delete();
        Response.Redirect("Default.aspx");
    }

    private void BindManufacturers()
    {
        IList<Manufacturer> manufacturers = ManufacturerDataSource.LoadAll("Name");
        int index = manufacturers.IndexOf(_ManufacturerId);
        if (index > -1) manufacturers.RemoveAt(index);
        ManufacturerList.DataSource = manufacturers;
        ManufacturerList.DataBind();
    }

}
}
