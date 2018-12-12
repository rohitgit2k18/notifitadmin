namespace AbleCommerce.Members
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;
    using System.Web.UI.WebControls;

    public partial class MyAccount : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IList<Order> orders = AbleContext.Current.User.Orders;
            orders.Sort("OrderDate", CommerceBuilder.Common.SortDirection.DESC);
            OrderGrid.DataSource = orders;
            OrderGrid.DataBind();
        }

        protected string GetShipTo(object dataItem)
        {
            Order order = (Order)dataItem;
            List<string> recipients = new List<string>();
            foreach (OrderShipment shipment in order.Shipments)
            {
                string name = shipment.ShipToFullName;
                if (!recipients.Contains(name)) recipients.Add(name);
            }
            return string.Join(", ", recipients.ToArray());
        }

        protected string GetOrderStatus(object dataItem)
        {
            Order order = (Order)dataItem;
            OrderStatus status = order.OrderStatus;
            if (status == null) return string.Empty;
            return StringHelper.SpaceName(status.DisplayName);
        }

        protected string GetOrderItemName(object dataItem)
        {
            OrderItem orderItem = (OrderItem)dataItem;
            if (orderItem != null)
            {
                if (!string.IsNullOrEmpty(orderItem.VariantName))
                {
                    return orderItem.Name + " (" + orderItem.VariantName + ")";
                }
                return orderItem.Name;
            }
            return string.Empty;
        }

        protected void OrderGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            OrderGrid.PageIndex = e.NewPageIndex;
            OrderGrid.DataBind();
        }
    }
}