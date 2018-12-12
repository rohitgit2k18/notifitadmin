namespace AbleCommerce.Admin.Orders.Shipments
{
    using System;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class MergeShipment : CommerceBuilder.UI.AbleCommerceAdminPage
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
            Caption.Text = string.Format(Caption.Text, _OrderShipment.ShipmentNumber, _OrderShipment.Order.OrderNumber);
            CancelLink.NavigateUrl += "?OrderNumber=" + _OrderShipment.Order.OrderNumber.ToString();
            //BIND ITEMS
            ShipmentItems.DataSource = _OrderShipment.OrderItems;
            ShipmentItems.DataBind();
            //ADD ITEMS TO SHIPMENTS LIST
            foreach (OrderShipment shipment in _OrderShipment.Order.Shipments)
            {
                if ((shipment.Id != shipmentId) && (!shipment.IsShipped))
                {
                    string address = string.Format("{0} {1} {2} {3}", shipment.ShipToFirstName, shipment.ShipToLastName, shipment.ShipToAddress1, shipment.ShipToCity);
                    if (address.Length > 50) address = address.Substring(0, 47) + "...";
                    string name = "Shipment #" + shipment.ShipmentNumber + " to " + address;
                    ShipmentsList.Items.Add(new ListItem(name, shipment.Id.ToString()));
                }
            }
        }

        protected void MergeButton_Click(object sender, EventArgs e)
        {
            int otherShipmentId = AlwaysConvert.ToInt(ShipmentsList.SelectedValue);
            OrderShipment otherShipment = OrderShipmentDataSource.Load(otherShipmentId);
            if (otherShipment != null)
            {
                foreach (OrderItem item in _OrderShipment.OrderItems)
                {
                    item.OrderShipmentId = otherShipmentId;
                    item.Save();
                }
                _OrderShipment.OrderItems.Clear();
                _OrderShipment.Delete();
            }
            Response.Redirect(CancelLink.NavigateUrl);
        }
    }
}