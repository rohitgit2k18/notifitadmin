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
using CommerceBuilder.UI;
using CommerceBuilder.Marketing;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;
using CommerceBuilder.Products;

namespace AbleCommerce.Admin.Marketing.Coupons
{
public partial class CouponProducts : AbleCommerceAdminPage
{
    private Coupon _Coupon;
    private int _CouponId;

    protected void Page_Load(object sender, EventArgs e)
    {
        _CouponId = AlwaysConvert.ToInt(Request.QueryString["CouponId"]);
        _Coupon = CouponDataSource.Load(_CouponId);
        if (_Coupon == null) Response.Redirect("Default.aspx");
        if (_Coupon.ProductRule == CouponRule.All) RedirectToEdit();
        if (!Page.IsPostBack)
        {
            Caption.Text = string.Format(Caption.Text, _Coupon.Name);
        }
        
        FindAssignProducts1.AssignmentValue = _CouponId;
        FindAssignProducts1.OnAssignProduct += new AssignProductEventHandler(FindAssignProducts1_AssignProduct);
        FindAssignProducts1.OnLinkCheck += new AssignProductEventHandler(FindAssignProducts1_LinkCheck);
        FindAssignProducts1.OnCancel += new EventHandler(FindAssignProducts1_CancelButton);
    }

    protected void FindAssignProducts1_AssignProduct(object sender, FindAssignProductEventArgs e)
    {
        SetLink(e.ProductId, e.Link);
    }

    protected void FindAssignProducts1_LinkCheck(object sender, FindAssignProductEventArgs e)
    {
        e.Link = IsProductLinked(e.ProductId);
    }

    protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
    {
        Response.Redirect("EditCoupon.aspx?CouponId=" + _CouponId);
    }

    private void SetLink(int productId, bool linked)
    {
        int index = _Coupon.Products.IndexOf(productId);
        if (linked && (index < 0))
        {
            Product product = ProductDataSource.Load(productId);
            _Coupon.Products.Add(product);
            _Coupon.Save();
        }
        else if (!linked && (index > -1))
        {
            _Coupon.Products.RemoveAt(index);
            _Coupon.Save();
        }
    }

    protected bool IsProductLinked(int productId)
    {
        return (_Coupon.Products.IndexOf(productId) > -1);
    }

    private void RedirectToEdit()
    {
        Response.Redirect("EditCoupon.aspx?CouponId=" + _CouponId.ToString());
    }
}
}
