namespace AbleCommerce.Admin.Orders.Print
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.HtmlControls;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Eventing;

    public partial class PackSlips : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private List<string> orderNumbers;
        protected int ShipmentCount = 0;

        private string GetOrderNumbers(IList<int> orders)
        {
            if (orderNumbers == null)
            {
                orderNumbers = new List<string>();
                foreach (int orderId in orders)
                {
                    int orderNumber = OrderDataSource.LookupOrderNumber(orderId);
                    orderNumbers.Add(orderNumber.ToString());
                }
            }
            if (orderNumbers.Count == 0) return string.Empty;
            return string.Join(", ", orderNumbers.ToArray());
        }

        /// <summary>
        /// Gets a collection of unshipped shipments for the selected orders.
        /// </summary>
        /// <param name="orders">The orderIds to gather shipments for.</param>
        /// <returns>A collection of unshipped shipments for the selected orders.</returns>
        protected IList<OrderShipment> GetShipments(params int[] orders)
        {
            bool includeShipped = AlwaysConvert.ToInt(Request.QueryString["is"]) == 1;
            int shipmentNumber = AlwaysConvert.ToInt(Request.QueryString["ShipmentNumber"]);
            IList<OrderShipment> shipments = new List<OrderShipment>();
            foreach (int orderId in orders)
            {
                Order order = OrderDataSource.Load(orderId);
                if (order != null)
                {
                    foreach (OrderShipment shipment in order.Shipments)
                    {
                        if ((shipmentNumber == 0 || shipmentNumber == shipment.ShipmentNumber)
                            && (includeShipped || !shipment.IsShipped))
                        {
                            shipments.Add(shipment);
                        }
                    }
                }
            }
            ShipmentCount = shipments.Count;
            return shipments;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Request.UrlReferrer != null)
                {
                    Back.NavigateUrl = Request.UrlReferrer.ToString();
                }
            }

            IList<int> selectedOrders = GetSelectedOrders();
            if ((selectedOrders == null) || (selectedOrders.Count == 0)) Response.Redirect("~/Admin/Orders/Default.aspx");
            ShipmentRepeater.DataSource = GetShipments(selectedOrders.ToArray());
            ShipmentRepeater.DataBind();
            OrderList.Text = GetOrderNumbers(selectedOrders);
        }

        private IList<int> GetSelectedOrders()
        {
            IList<int> selectedOrders = null;
            // CHECK FOR QUERYSTRING PARAMETERS
            int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
            if (orderId > 0)
            {
                selectedOrders = new List<int>();
                selectedOrders.Add(orderId);
            }
            // CHECK SESSION
            else selectedOrders = AbleContext.Current.Session.SelectedOrderIds;
            return selectedOrders;
        }

        protected IList<OrderItem> GetProducts(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            Order order = shipment.Order;
            IList<OrderItem> products = new List<OrderItem>();
            foreach (OrderItem item in order.Items)
            {
                if ((item.OrderItemType == OrderItemType.Product) && (item.OrderShipmentId == shipment.Id))
                {
                    if (item.IsChildItem)
                    {
                        // WHETHER THE CHILD ITEM DISPLAYS DEPENDS ON THE ROOT
                        OrderItem rootItem = item.GetParentItem(true);
                        if (rootItem != null && rootItem.Product != null && rootItem.ItemizeChildProducts)
                        {
                            // ITEMIZED DISPLAY ENABLED, SHOW THIS CHILD ITEM
                            products.Add(item);
                        }
                    }
                    else products.Add(item);
                }
            }
            products.Sort(new OrderItemComparer());
            return products;
        }

        protected string GetShipToAddress(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            string pattern = shipment.ShipToCountry.AddressFormat;
            if (!string.IsNullOrEmpty(shipment.ShipToEmail) && !pattern.Contains("[Email]") && !pattern.Contains("[Email_U]")) pattern += "\r\nEmail: [Email]";
            if (!string.IsNullOrEmpty(shipment.ShipToPhone) && !pattern.Contains("[Phone]") && !pattern.Contains("[Phone_U]")) pattern += "\r\nPhone: [Phone]";
            if (!string.IsNullOrEmpty(shipment.ShipToFax) && !pattern.Contains("[Fax]") && !pattern.Contains("[Fax_U]")) pattern += "\r\nFax: [Fax]";
            return shipment.FormatToAddress(pattern, true);
        }

        protected string GetShipFromAddress(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            string pattern = shipment.ShipToCountry.AddressFormat;
            if (!string.IsNullOrEmpty(shipment.Warehouse.Email) && !pattern.Contains("[Email]") && !pattern.Contains("[Email_U]")) pattern += "\r\nEmail: [Email]";
            if (!string.IsNullOrEmpty(shipment.Warehouse.Phone) && !pattern.Contains("[Phone]") && !pattern.Contains("[Phone_U]")) pattern += "\r\nPhone: [Phone]";
            if (!string.IsNullOrEmpty(shipment.Warehouse.Fax) && !pattern.Contains("[Fax]") && !pattern.Contains("[Fax_U]")) pattern += "\r\nFax: [Fax]";
            return shipment.FormatFromAddress(pattern, true);
        }

        protected void Print_Click(object sender, EventArgs e)
        {
            string scriptKey = "scriptKey";
            if (!Page.ClientScript.IsStartupScriptRegistered(Page.GetType(), scriptKey))
            {
                this.Page.ClientScript.RegisterStartupScript(this.GetType(), scriptKey, "window.print();", true);
            }

            IList<int> selectedOrders = GetSelectedOrders();
            if ((selectedOrders == null) || (selectedOrders.Count == 0))
                return;
            foreach (int orderId in selectedOrders)
            {
                Order order = OrderDataSource.Load(orderId);
                if (order != null)
                    EventsManager.Instance.RaisePackingListPrinted(null, new OrderEventArgs(order));
            }
        }
    }
}