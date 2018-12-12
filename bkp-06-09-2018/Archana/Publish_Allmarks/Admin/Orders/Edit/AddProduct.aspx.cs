namespace AbleCommerce.Admin.Orders.Edit
{
    using System;
    using CommerceBuilder.Orders;

    public partial class AddProduct : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        public void Page_Init(object sender, EventArgs e)
        {
            int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
            Order order = OrderDataSource.Load(orderId);
            if (order == null) Response.Redirect("~/Admin/Orders/Default.aspx");
            Caption.Text = string.Format(Caption.Text, order.OrderNumber);
        }
    }
}