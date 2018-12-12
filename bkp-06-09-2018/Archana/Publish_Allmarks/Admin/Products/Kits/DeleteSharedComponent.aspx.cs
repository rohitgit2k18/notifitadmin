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

namespace AbleCommerce.Admin.Products.Kits
{
public partial class DeleteSharedComponent : CommerceBuilder.UI.AbleCommerceAdminPage
{

    private int _CategoryId;
    private Category _Category;
    private int _ProductId;
    private Product _Product;
    private int _KitComponentId;
    private KitComponent _KitComponent;

    protected void Page_Init(object sender, EventArgs e)
    {
        //INITIALIZE VARIABLES
        _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
        _Category = CategoryDataSource.Load(_CategoryId);
        _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
        _Product = ProductDataSource.Load(_ProductId);
        if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
        _KitComponentId = AlwaysConvert.ToInt(Request.QueryString["KitComponentId"]);
        _KitComponent = KitComponentDataSource.Load(_KitComponentId);
        if (_KitComponent == null) Response.Redirect("EditKit.aspx?CategoryId=" + _CategoryId.ToString() + "&ProductId=" + _ProductId.ToString());
        //INITIALIZE PAGE ELEMENTS
        Caption.Text = string.Format(Caption.Text, _KitComponent.Name);
        BindKitList();
    }

    protected void DeleteButton_Click(object sender, EventArgs e)
    {
        if (Detach.Checked)
        {
            ProductKitComponent pkc = ProductKitComponentDataSource.Load(_Product.Id, _KitComponent.Id);
            int index = _Product.ProductKitComponents.IndexOf(pkc);
            if (index > -1) _Product.ProductKitComponents.DeleteAt(index);
        }
        else
        {
            _KitComponent.Delete();
        }
        Response.Redirect(string.Format("EditKit.aspx?CategoryId={0}&ProductId={1}", _CategoryId, _ProductId));
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("EditKit.aspx?CategoryId={0}&ProductId={1}", _CategoryId, _ProductId));
    }

    protected void BindKitList()
    {
        List<Product> products = new List<Product>();
        foreach (ProductKitComponent pkc in _KitComponent.ProductKitComponents)
        {
            products.Add(pkc.Product);
        }
        KitList.DataSource = products;
        KitList.DataBind();
    }

    protected void BackButton_Click(object sender, EventArgs e)
    {
        Response.Redirect(string.Format("EditKit.aspx?CategoryId={0}&ProductId={1}", _CategoryId, _ProductId));
    }

}
}
