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

public partial class ViewProducts : CommerceBuilder.UI.AbleCommerceAdminPage
{
    private int _WarehouseId;
    private Warehouse _Warehouse;
    protected void Page_Load(object sender, EventArgs e)
    {
        _WarehouseId = AlwaysConvert.ToInt(Request.QueryString["WarehouseId"]);
        _Warehouse  = WarehouseDataSource.Load(_WarehouseId);
        if (_Warehouse == null) Response.Redirect("Default.aspx");
        Caption.Text = string.Format(Caption.Text, _Warehouse.Name);
        if (!Page.IsPostBack)
        {
            List<Warehouse> targets = new List<Warehouse>();
            IList<Warehouse> allWarehouses = WarehouseDataSource.LoadAll();
            foreach (Warehouse w in allWarehouses)
            {
                if (w.Id != AlwaysConvert.ToInt(_WarehouseId)) targets.Add(w);
            }
            if (targets.Count > 0)
            {
                NewWarehouse.DataSource = targets;
                NewWarehouse.DataBind();
            }
        }
        FindAssignProducts1.AssignmentValue = _WarehouseId;
        FindAssignProducts1.OnAssignProduct += new AssignProductEventHandler(FindAssignProducts1_AssignProduct);
        FindAssignProducts1.OnLinkCheck += new AssignProductEventHandler(FindAssignProducts1_LinkCheck);
        FindAssignProducts1.OnCancel += new EventHandler(FindAssignProducts1_CancelButton);
    }

    protected void FindAssignProducts1_AssignProduct(object sender, FindAssignProductEventArgs e)
    {
        UpdateWarehouseAssociation(e.ProductId, _WarehouseId, e.Link);
    }

    protected void FindAssignProducts1_LinkCheck(object sender, FindAssignProductEventArgs e)
    {
        e.Link = IsProductLinked(e.Product);
    }

    protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }

    protected void BackButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }

    protected void NewWarehouseUpdateButton_Click(object sender, EventArgs e)
    {
        int newWarehouseId = AlwaysConvert.ToInt(NewWarehouse.SelectedValue);
        Warehouse newWarehouse = WarehouseDataSource.Load(newWarehouseId);
        var products = FindAssignProducts1.GetSelectedProducts();
        foreach (Product p in products)
        {
            p.Warehouse = newWarehouse;
            p.Save();
        }
        Response.Redirect("Default.aspx");
    }

    private void UpdateWarehouseAssociation(int productId, int productWarehouseId, bool linked)
    {
        Product product = ProductDataSource.Load(productId);
        if (product != null)
        {
            if (linked)
            {
                Warehouse wh = WarehouseDataSource.Load(productWarehouseId);
                product.Warehouse = wh;
                wh.Save();
            }
            else
            {
                product.Warehouse = null;
                product.Save();
            }
        }
    }

    protected bool IsProductLinked(Product product)
    {
        if (product != null)
        {
            return product.WarehouseId == _WarehouseId;
        }
        return false;
    }
}
}
