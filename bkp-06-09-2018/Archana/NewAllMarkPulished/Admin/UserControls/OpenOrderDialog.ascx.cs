namespace AbleCommerce.Admin.UserControls
{
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
    using CommerceBuilder.Utility;
    using CommerceBuilder.Orders;

    public partial class OpenOrderDialog : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            AbleCommerce.Code.PageHelper.SetDefaultButton(OrderNumber, OpenOrderButton.ClientID);
        }

        protected void OpenOrderButton_Click(object sender, System.Web.UI.ImageClickEventArgs e)
        {
            int orderId = OrderDataSource.LookupOrderId(AlwaysConvert.ToInt(OrderNumber.Text));
            Order order = OrderDataSource.Load(orderId);
            if (order != null)
            {
                Response.Redirect("ViewOrder.aspx?OrderNumber=" + order.OrderNumber);
            }
        }
    }
}
