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
public partial class EditManufacturer : CommerceBuilder.UI.AbleCommerceAdminPage
{

    int _ManufacturerId = 0;
    Manufacturer _Manufacturer;

    protected void Page_Load(object sender, System.EventArgs e)
    {
        _ManufacturerId = AlwaysConvert.ToInt(Request.QueryString["ManufacturerId"]);
        _Manufacturer = ManufacturerDataSource.Load(_ManufacturerId);
        if (_Manufacturer == null) Response.Redirect("Default.aspx");

        Caption.Text = string.Format(Caption.Text, _Manufacturer.Name);
        FindAssignProducts1.AssignmentValue = _ManufacturerId;
        FindAssignProducts1.OnAssignProduct += new AssignProductEventHandler(FindAssignProducts1_AssignProduct);
        FindAssignProducts1.OnLinkCheck += new AssignProductEventHandler(FindAssignProducts1_LinkCheck);
        FindAssignProducts1.OnCancel += new EventHandler(FindAssignProducts1_CancelButton);
    }

    protected void FindAssignProducts1_AssignProduct(object sender, FindAssignProductEventArgs e)
    {
        SetManufacturer(e.ProductId, e.Link);
    }

    protected void FindAssignProducts1_LinkCheck(object sender, FindAssignProductEventArgs e)
    {
        e.Link = IsProductLinked(e.Product);
    }

    protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }

    private void SetManufacturer(int relatedProductId, bool linked)
    {
        Product product = ProductDataSource.Load(relatedProductId);
        if (product != null)
        {
            AbleContext.Current.Database.BeginTransaction();
            if (linked) product.Manufacturer = _Manufacturer;
            else product.Manufacturer = null;
            product.Save();
            AbleContext.Current.Database.CommitTransaction();
        }

    }

    protected bool IsProductLinked(Product product)
    {
        if (product != null && product.Manufacturer != null)
        {
            return (product.Manufacturer.Equals(_Manufacturer));
        }
        return false;
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }
}
}
