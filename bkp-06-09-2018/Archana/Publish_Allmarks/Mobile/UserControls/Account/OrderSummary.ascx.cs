using System;
using CommerceBuilder.Orders;

namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class mOrderSummary : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                // update summary data
                OrderNumber.Text = Order.OrderNumber.ToString();
                OrderDate.Text = string.Format("{0:g}", this.Order.OrderDate);
                OrderStatus.Text = this.Order.OrderStatus.DisplayName;
            }
            else
            {
                this.Controls.Clear();
            }
        }
    }
}