namespace AbleCommerce.Admin.Orders.Shipments
{
    using System;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class FindProduct : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        public void Page_Init(object sender, EventArgs e)
        {
            int orderShipmentId = AlwaysConvert.ToInt(Request.QueryString["OrderShipmentId"]);
            OrderShipment orderShipment = OrderShipmentDataSource.Load(orderShipmentId);
            if (orderShipment == null) Response.Redirect("Default.aspx");
            Caption.Text = string.Format(Caption.Text, orderShipment.ShipmentNumber, orderShipment.Order.OrderNumber);
        }
    }
}