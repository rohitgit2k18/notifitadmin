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
public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
{

    private IList<Warehouse> _Warehouses;

    protected void Page_Init(object sender, EventArgs e)
    {
        _Warehouses = WarehouseDataSource.LoadAll();
    }
    
    protected string GetAddress(object dataItem)
    {
        return ((Warehouse)dataItem).FormatAddress(true);
    }

    protected int CountProducts(object dataItem)
    {
        return ProductDataSource.CountForWarehouse(((Warehouse)dataItem).Id);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindWarehouses();
        }
    }

    protected void BindWarehouses()
    {
        WarehouseGrid.DataSource = _Warehouses;
        WarehouseGrid.DataBind();
        DefaultWarehouse.DataSource = _Warehouses;
        DefaultWarehouse.DataBind();
        ListItem selected = DefaultWarehouse.Items.FindByValue(AbleContext.Current.Store.DefaultWarehouseId.ToString());
        if (selected != null) DefaultWarehouse.SelectedIndex = DefaultWarehouse.Items.IndexOf(selected);
    }

    protected void WarehouseGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int warehouseId = (int)WarehouseGrid.DataKeys[e.RowIndex].Value;
        int index = _Warehouses.IndexOf(warehouseId);
        if (index > -1)
        {
            _Warehouses.DeleteAt(index);
            BindWarehouses();
        }
    }

    protected bool HasProducts(object dataItem)
    {
        Warehouse w = (Warehouse)dataItem;
        return (ProductDataSource.CountForWarehouse(w.Id) > 0);
    }

    protected bool ShowDeleteButton(object dataItem)
    {		
        Warehouse w = (Warehouse)dataItem;
		if(w.Id == AbleContext.Current.Store.DefaultWarehouseId) return false;
        return (ProductDataSource.CountForWarehouse(w.Id) <= 0);
    }

    protected bool ShowDeleteLink(object dataItem)
    {
        Warehouse w = (Warehouse)dataItem;
		if(w.Id == AbleContext.Current.Store.DefaultWarehouseId) return false;
        return (ProductDataSource.CountForWarehouse(w.Id) > 0);
    }

	protected bool IsDefaultWarehouse(object dataItem)
	{
        Warehouse w = (Warehouse)dataItem;
        return w.Id == AbleContext.Current.Store.DefaultWarehouseId;
	}

    protected void DefaultWarehouse_SelectedIndexChanged(object sender, EventArgs e)
    {
        int newDefaultWarehouseId = AlwaysConvert.ToInt(DefaultWarehouse.SelectedValue);
        if (_Warehouses.IndexOf(newDefaultWarehouseId) > -1)
        {
            AbleContext.Current.Store.DefaultWarehouseId = newDefaultWarehouseId;
            AbleContext.Current.Store.Save();
        }
        BindWarehouses();
    }

}
}
