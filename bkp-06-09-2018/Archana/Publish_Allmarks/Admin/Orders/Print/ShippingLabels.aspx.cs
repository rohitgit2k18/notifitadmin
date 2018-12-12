namespace AbleCommerce.Admin.Orders.Print
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.HtmlControls;
    using System.Web.UI.WebControls;
    using System.Linq;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Eventing;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.UPS;
    using System.Web.UI;

    public partial class ShippingLabels : CommerceBuilder.UI.AbleCommerceAdminPage
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

        protected void SetControlValue(Control parent, string controlName, string controlValue)
        {
            Control control = AbleCommerce.Code.PageHelper.RecursiveFindControl(parent, controlName);
            if (control != null)
            {
                TextBox tb = control as TextBox;
                if (tb != null) tb.Text = controlValue;
            }
        }
    }
}