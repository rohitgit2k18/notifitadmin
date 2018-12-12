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

namespace AbleCommerce.Admin.People.Vendors
{
public partial class EditVendor : CommerceBuilder.UI.AbleCommerceAdminPage
{

    int _VendorId = 0;
    Vendor _Vendor;

    protected void Page_Load(object sender, System.EventArgs e) {
        _VendorId = AlwaysConvert.ToInt(Request.QueryString["VendorId"]);
        _Vendor = VendorDataSource.Load(_VendorId);
        if (_Vendor == null) Response.Redirect("Default.aspx");

        Caption.Text = string.Format(Caption.Text, _Vendor.Name);
        FindAssignProducts1.AssignmentValue = _VendorId;
        FindAssignProducts1.OnAssignProduct += new AssignProductEventHandler(FindAssignProducts1_AssignProduct);
        FindAssignProducts1.OnLinkCheck += new AssignProductEventHandler(FindAssignProducts1_LinkCheck);
        FindAssignProducts1.OnCancel += new EventHandler(FindAssignProducts1_CancelButton);
    }

    protected void FindAssignProducts1_AssignProduct(object sender, FindAssignProductEventArgs e)
    {
        UpdateAssociation(e.ProductId, e.Link);
    }

    protected void FindAssignProducts1_LinkCheck(object sender, FindAssignProductEventArgs e)
    {
        e.Link = IsProductLinked(e.Product);
    }

    protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }
    
    protected void CancelButton_Click(object sender, System.EventArgs e ) {
        Response.Redirect("Default.aspx");
    }

    private void UpdateAssociation(int relatedProductId, bool linked)
    {
        Product product = ProductDataSource.Load(relatedProductId);
        if (product != null)
        {
            if (linked) product.Vendor = _Vendor;
            else product.Vendor = null;
            product.Save();
        }

    }

    protected bool IsProductLinked(Product product)
    {
        if (product != null && product.Vendor != null)
        {
            return (product.Vendor.Equals(_Vendor));
        }
        return false;
    }
}
}
