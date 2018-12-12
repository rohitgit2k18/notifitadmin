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
using CommerceBuilder.Payments;

namespace AbleCommerce.Admin.Reports
{
public partial class GiftCertTransactions : CommerceBuilder.UI.AbleCommerceAdminPage
{

    private int _GiftCertificateId;
    private GiftCertificate _GiftCertificate;

    protected void Page_Init(object sender, EventArgs e)
    {
        _GiftCertificateId = AlwaysConvert.ToInt(Request.QueryString["GiftCertificateId"]);
        _GiftCertificate = GiftCertificateDataSource.Load(_GiftCertificateId);
        if (_GiftCertificate == null) Response.Redirect("Default.aspx");
        
		if (!Page.IsPostBack)
        {            
            BindTransactions();
			Caption.Text = string.Format(Caption.Text,_GiftCertificate.Name);
        }
    }

    protected void Page_PreInit(object sender, EventArgs e)
    {
        // READ ONLY SESSION
        AbleContext.Current.Database.GetSession().DefaultReadOnly = true;
    }

    protected void Page_SaveStateComplete(object sender, EventArgs e)
    {
        // END READ ONLY SESSION
        AbleContext.Current.Database.GetSession().DefaultReadOnly = false;
    }
    
    protected void BindTransactions()
    {
        TransactionGrid.DataSource = _GiftCertificate.Transactions;
        TransactionGrid.DataBind();        
    }

    protected string GetOrderNumber(object obj)
    {
        GiftCertificateTransaction trans = obj as GiftCertificateTransaction;
        if (trans == null) return "";
        if (trans.Order == null) return "";
        return trans.Order.OrderNumber.ToString();
    }

    protected string GetOrderLink(object obj)
    {
        GiftCertificateTransaction trans = obj as GiftCertificateTransaction;
        if (trans == null) return "";
        if (trans.Order == null) return "";
        return "~/Admin/Orders/ViewOrder.aspx?OrderNumber=" + trans.Order.OrderNumber.ToString();
    }

    protected bool HasOrder(object obj)
    {
		GiftCertificateTransaction trans = obj as GiftCertificateTransaction;
		if (trans == null) return false;
		if(trans.Order == null) return false;
		return trans.Order.Id > 0;
	}
}
}
