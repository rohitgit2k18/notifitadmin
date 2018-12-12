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
using CommerceBuilder.Taxes;

namespace AbleCommerce.Admin.Taxes
{
public partial class TaxCodeProducts : CommerceBuilder.UI.AbleCommerceAdminPage
{
    private int _TaxCodeId;
    private TaxCode _TaxCode;
    protected void Page_Load(object sender, EventArgs e)
    {
        _TaxCodeId = AlwaysConvert.ToInt(Request.QueryString["TaxCodeId"]);
        _TaxCode  = TaxCodeDataSource.Load(_TaxCodeId);
        if (_TaxCode == null) Response.Redirect("Default.aspx");
        if (!Page.IsPostBack)
        {
            Caption.Text = string.Format(Caption.Text, _TaxCode.Name);
        }

        FindAssignProducts1.AssignmentValue = _TaxCodeId;
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
        Response.Redirect("TaxCodes.aspx");
    }

    private void UpdateAssociation(int relatedProductId, bool associate)
    {
        Product product = ProductDataSource.Load(relatedProductId);
        if (product != null)
        {
            if (associate)
            {
                product.TaxCode = _TaxCode;
            }
            else product.TaxCode = null;
            product.Save();
        }
    }
    
    protected bool IsProductLinked(Product product)
    {
        if (product != null && product.TaxCode != null)
        {
            return (product.TaxCode.Equals(_TaxCode));
        }
        return false;
    }
}
}
