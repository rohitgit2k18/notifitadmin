namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Shipping;
    
    public partial class OrderShipmentSummary : System.Web.UI.UserControl
    {
        public int OrderId { get; set; }

        public bool ShowShipmentNumbers { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Order order = OrderDataSource.Load(OrderId);

            // make sure we have shipments to list
            if (order != null && order.Shipments.Count > 0)
            {
                ShowShipmentNumbers = order.Shipments.Count > 1;
                BindShippingButtons(order);
                BindShipmentList(order);
                BindShippingAddress(order);
            }
            else
            {
                NoShipmentsPanel.Visible = true;
                ShipmentsPanel.Visible = false;
            }
        }

        protected string GetShippingStatus(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            if (shipment.IsShipped) return string.Format("Shipped {0:d}", shipment.ShipDate);
            return "Unshipped";
        }

        private string GetShipmentDetailsUrl(Order order)
        {
            return "~/Admin/Orders/Shipments/Default.aspx?OrderNumber=" + order.OrderNumber;
        }

        private void BindShippingButtons(Order order)
        {
            // packing slip button shows for valid orders with 1 shipment
            PackingListButton.Visible = order.OrderStatus.IsValid && order.Shipments.Count == 1;
            PackingListButton.NavigateUrl = string.Format(PackingListButton.NavigateUrl, order.OrderNumber);

            // ship button displays for valid orders if there is one unshipped shipment
            ShipButton.Visible = PackingListButton.Visible && !order.Shipments[0].IsShipped;
            ShipButton.NavigateUrl = string.Format(ShipButton.NavigateUrl, order.Shipments[0].Id);

            // shipping details shows for all orders with shipments if ship button is not showing
            ShippingDetailsButton.Visible = !ShipButton.Visible;
            ShippingDetailsButton.NavigateUrl = GetShipmentDetailsUrl(order);
        }

        private void BindShipmentList(Order order)
        {
            List<OrderShipment> firstTwoShipments = new List<OrderShipment>();
            firstTwoShipments.Add(order.Shipments[0]);
            if (order.Shipments.Count > 1) firstTwoShipments.Add(order.Shipments[1]);
            ShipmentList.DataSource = firstTwoShipments;
            ShipmentList.DataBind();
            MoreShipmentsLink.Visible = order.Shipments.Count > 2;
            MoreShipmentsLink.NavigateUrl = GetShipmentDetailsUrl(order);
        }

        private void BindShippingAddress(Order order)
        {
            if (order.Shipments.Count == 1)
            {
                OrderShipment firstShipment = order.Shipments[0];
                ShippingAddress.Text = firstShipment.FormatToAddress(true);
                if (!string.IsNullOrEmpty(firstShipment.ShipToEmail)) ShipToEmail.Text = string.Format(ShipToEmail.Text, firstShipment.ShipToEmail);
                else ShipToEmail.Visible = false;
                if (!string.IsNullOrEmpty(firstShipment.ShipToPhone)) ShipToPhone.Text = string.Format(ShipToPhone.Text, firstShipment.ShipToPhone);
                else ShipToPhone.Visible = false;
                if (!string.IsNullOrEmpty(firstShipment.ShipToFax)) ShipToFax.Text = string.Format(ShipToFax.Text, firstShipment.ShipToFax);
                else ShipToFax.Visible = false;
            }
            else
            {
                ShippingAddressPanel.Visible = false;
            }
        }
    }
}