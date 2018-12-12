namespace AbleCommerce.Admin.Orders.Shipments
{
    using System;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class DeleteShipment : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private OrderShipment _OrderShipment;

        protected void Page_Init(object sender, EventArgs e)
        {
            int shipmentId = AlwaysConvert.ToInt(Request.QueryString["ShipmentId"]);
            _OrderShipment = OrderShipmentDataSource.Load(shipmentId);
            if (_OrderShipment == null)
            {
                int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
                int orderNumber = OrderDataSource.LookupOrderNumber(orderId);
                Response.Redirect("Default.aspx?OrderNumber=" + orderNumber.ToString());
            }
            Caption.Text = string.Format(Caption.Text, _OrderShipment.ShipmentNumber);
            CancelLink.NavigateUrl += "?OrderNumber=" + _OrderShipment.Order.OrderNumber.ToString();

            // BIND ITEMS
            ShipTo.Text = _OrderShipment.FormatToAddress(true);
            ShipFrom.Text = _OrderShipment.FormatFromAddress(true);
            ShippingMethod.Text = _OrderShipment.ShipMethodName;
            ShipmentItems.DataSource = _OrderShipment.OrderItems;
            ShipmentItems.DataBind();
        }

        protected void DeleteShipmentButton_Click(object sender, EventArgs e)
        {
            // DELETE FROM ORDER
            Order order = _OrderShipment.Order;
            order.Shipments.Remove(_OrderShipment);
            foreach (OrderItem item in _OrderShipment.OrderItems)
            {
                order.Items.Remove(item);
            }

            // save and recalculate
            order.Items.Save();
            order.Save(true, false);
            Response.Redirect(CancelLink.NavigateUrl);
        }
    }
}