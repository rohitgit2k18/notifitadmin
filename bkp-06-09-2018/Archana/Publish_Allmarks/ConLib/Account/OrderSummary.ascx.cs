namespace AbleCommerce.ConLib.Account
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Orders;

    [Description("Displays order summary for an order")]
    public partial class OrderSummary : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                // update summary data
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