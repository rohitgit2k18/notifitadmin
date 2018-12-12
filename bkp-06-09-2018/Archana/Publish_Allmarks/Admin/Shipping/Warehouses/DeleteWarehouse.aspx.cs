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
using CommerceBuilder.Shipping;

namespace AbleCommerce.Admin.Shipping.Warehouses
{
public partial class DeleteWarehouse : CommerceBuilder.UI.AbleCommerceAdminPage
{

    int _WarehouseId = 0;
    Warehouse _Warehouse;

    protected void Page_Init(object sender, System.EventArgs e)
    {
        _WarehouseId = AlwaysConvert.ToInt(Request.QueryString["WarehouseId"]);
        _Warehouse = WarehouseDataSource.Load(_WarehouseId);
        if (_Warehouse == null) Response.Redirect("Default.aspx");
		//you can not delete default warehouse
		if(_Warehouse.Id == AbleContext.Current.Store.DefaultWarehouseId) Response.Redirect("Default.aspx");
        Caption.Text = string.Format(Caption.Text, _Warehouse.Name);
        InstructionText.Text = string.Format(InstructionText.Text, _Warehouse.Name);
        BindWarehouses();
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }

    protected void DeleteButton_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid)
        {
            WarehouseDataSource.MoveProducts(_Warehouse.Id, AlwaysConvert.ToInt(WarehouseList.SelectedValue));
            _Warehouse.Delete();
            Response.Redirect("Default.aspx");
        }
    }

    private void BindWarehouses()
    {
        IList<Warehouse> warehouses = WarehouseDataSource.LoadAll("Name");
        int index = warehouses.IndexOf(_WarehouseId);
        if (index > -1) warehouses.RemoveAt(index);
        WarehouseList.DataSource = warehouses;
        WarehouseList.DataBind();
    }

}
}
