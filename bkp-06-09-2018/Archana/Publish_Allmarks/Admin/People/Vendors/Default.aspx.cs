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
public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
{
    int _VendorId = 0;
    Vendor _Vendor;

    protected void AddVendorButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            Vendor vendor = new Vendor();
            vendor.Name = AddVendorName.Text;
            vendor.Save();
            AddVendorName.Text = string.Empty;
            VendorGrid.DataBind();
        }
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {            
        AbleCommerce.Code.PageHelper.SetDefaultButton(AddVendorName, AddVendorButton.ClientID);
    }

    protected void VendorGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.Equals("EditVendor"))
        {
            string[] data = ((string)e.CommandArgument).Split(':');
            _VendorId = AlwaysConvert.ToInt(data[0]);
            HiddenVendorId.Value = _VendorId.ToString();
            _Vendor = VendorDataSource.Load(_VendorId);
            VendorName.Text = _Vendor.Name;
            Email.Text = _Vendor.Email;
            ModalPopupExtender.Show();
            EditAjax.Update();
        }
    }

    private Dictionary<int, int> _ProductCounts = new Dictionary<int, int>();
    protected int GetProductCount(object dataItem)
    {
        Vendor v = (Vendor)dataItem;
        if (_ProductCounts.ContainsKey(v.Id)) return _ProductCounts[v.Id];
        int count = ProductDataSource.CountForVendor(v.Id);
        _ProductCounts[v.Id] = count;
        return count;
    }

    protected bool ShowDeleteButton(object dataItem)
    {
        Vendor v = (Vendor)dataItem;
        return (v.Products.Count <= 0);
    }

    protected bool ShowDeleteLink(object dataItem)
    {
        Vendor v = (Vendor)dataItem;
        return (v.Products.Count > 0);
    }

    protected void SaveButton_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid)
        {
            // save the vendors
            SaveVendors();
        }

        ModalPopupExtender.Hide();
        VendorGrid.DataBind();
        EditAjax.Update();
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        ModalPopupExtender.Hide();
    }

    private void SaveVendors()
    {
        int _vendorId = AlwaysConvert.ToInt(HiddenVendorId.Value);
        _Vendor = VendorDataSource.Load(_vendorId);
        _Vendor.Name = VendorName.Text;
        _Vendor.Email = Email.Text.Replace(" ", "");
        _Vendor.Save();
    }
}
}
