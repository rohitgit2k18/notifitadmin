using System;
using System.Web.UI.WebControls;
using CommerceBuilder.Orders;
using CommerceBuilder.Shipping.Providers;
using CommerceBuilder.Taxes;

namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class mOrderShipments : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Order != null && this.Order.Shipments.Count > 0)
            {
                ShipmentRepeater.DataSource = this.Order.Shipments;
                ShipmentRepeater.DataBind();
            }
            else ShipmentsPanel.Visible = false;
        }

        protected string GetShipToAddress(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            string pattern = shipment.ShipToCountry.AddressFormat;
            if (!string.IsNullOrEmpty(shipment.ShipToEmail) && !pattern.Contains("[Email]") && !pattern.Contains("[Email_U]")) pattern += "\r\nEmail: [Email]";
            if (!string.IsNullOrEmpty(shipment.ShipToPhone) && !pattern.Contains("[Phone]") && !pattern.Contains("[Phone_U]")) pattern += "\r\nPhone: [Phone]";
            if (!string.IsNullOrEmpty(shipment.ShipToFax) && !pattern.Contains("[Fax]") && !pattern.Contains("[Fax_U]")) pattern += "\r\nFax: [Fax]";
            return shipment.FormatToAddress(pattern, true).Replace("<br />", ", ");
        }

        protected string GetShipStatus(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            if (shipment.IsShipped) return "Shipped";
            if (this.Order.OrderStatus.IsValid) return "Waiting to Ship";
            return "Cancelled";
        }

        protected bool HasTrackingNumbers(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            return (shipment.TrackingNumbers.Count > 0);
        }

        protected string GetTrackingUrl(object dataItem)
        {
            TrackingNumber trackingNumber = (TrackingNumber)dataItem;
            if (trackingNumber.ShipGateway != null)
            {
                IShippingProvider provider = trackingNumber.ShipGateway.GetProviderInstance();
                TrackingSummary summary = provider.GetTrackingSummary(trackingNumber);
                if (summary != null)
                {
                    // TRACKING DETAILS FOUND
                    if (summary.TrackingResultType == TrackingResultType.InlineDetails)
                    {
                        //send to view tracking page
                        return string.Format("MyTrackingInfo.aspx?TrackingNumberId={0}", trackingNumber.Id.ToString());
                    }
                    else if (summary.TrackingResultType == TrackingResultType.ExternalLink)
                    {
                        return summary.TrackingLink;
                    }
                }
            }
            return string.Empty;
        }

        protected bool ShowProductImagePanel(object dataItem)
        {
            OrderItem item = (OrderItem)dataItem;
            return item.OrderItemType == OrderItemType.Product
                && item.Product != null;
        }
    }
}