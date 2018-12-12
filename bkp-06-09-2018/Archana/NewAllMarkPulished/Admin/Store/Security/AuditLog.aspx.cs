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

namespace AbleCommerce.Admin._Store.Security
{
public partial class AuditLog : CommerceBuilder.UI.AbleCommerceAdminPage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        _OrderUrl = AbleCommerce.Code.NavigationHelper.GetAdminUrl("Orders/ViewOrder.aspx");
        if (!Page.IsPostBack)
        {
            Logger.Audit(AuditEventType.ViewAuditLog, true, string.Empty);
        }
    }
    
    private string _OrderUrl;

    protected void AuditEventGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            AuditEvent auditEvent = (AuditEvent)e.Row.DataItem;
            if (auditEvent.EventType == AuditEventType.ViewCardData)
            {
                Order order = OrderDataSource.Load(AlwaysConvert.ToInt(auditEvent.RelatedId));
                if (order != null)
                {
                    PlaceHolder phRe = (PlaceHolder)e.Row.FindControl("phRe");
                    if (phRe != null)
                    {
                        HyperLink link = new HyperLink();
                        link.NavigateUrl = _OrderUrl + "?OrderNumber=" + order.OrderNumber.ToString();
                        link.Text = "Order #" + order.OrderNumber.ToString();
                        phRe.Controls.Add(link);
                    }
                }
            }
        }
    }

}
}
