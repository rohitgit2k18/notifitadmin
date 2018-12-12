namespace AbleCommerce.Admin.Orders.Print
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Eventing;

    public partial class Invoices : CommerceBuilder.UI.AbleCommerceAdminPage
    {

        private List<string> orderNumbers;
        protected int OrderCount = 0;

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
        /// Gets a collection of orders from a list of order ids.
        /// </summary>
        /// <param name="orderIds">The orderIds to load.</param>
        /// <returns>A collection of orders from the list of ids.</returns>
        protected IList<Order> GetOrders(params int[] orderIds)
        {
            IList<Order> orders = new List<Order>();
            foreach (int orderId in orderIds)
            {
                Order order = OrderDataSource.Load(orderId);
                if (order != null)
                {
                    orders.Add(order);
                }
            }
            OrderCount = orders.Count;
            return orders;
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
            OrderRepeater.DataSource = GetOrders(selectedOrders.ToArray());
            OrderRepeater.DataBind();
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

        private OrderItemType[] displayItemTypes = { OrderItemType.Product, OrderItemType.Discount, 
        OrderItemType.Coupon, OrderItemType.Shipping, OrderItemType.Handling, OrderItemType.GiftWrap,
        OrderItemType.Charge, OrderItemType.Credit, OrderItemType.GiftCertificate, OrderItemType.Tax};
        protected IList<OrderItem> GetItems(object dataItem)
        {
            Order order = (Order)dataItem;
            IList<OrderItem> items = new List<OrderItem>();
            foreach (OrderItem item in order.Items)
            {
                if (Array.IndexOf(displayItemTypes, item.OrderItemType) > -1 && (item.OrderItemType != OrderItemType.Tax))
                {
                    if (item.OrderItemType == OrderItemType.Product && item.IsChildItem)
                    {
                        // WHETHER THE CHILD ITEM DISPLAYS DEPENDS ON THE ROOT
                        OrderItem rootItem = item.GetParentItem(true);
                        if (rootItem != null && rootItem.Product != null && rootItem.ItemizeChildProducts)
                        {
                            // ITEMIZED DISPLAY ENABLED, SHOW THIS CHILD ITEM
                            items.Add(item);
                        }
                    }
                    else items.Add(item);
                }
            }
            //ADD IN TAX ITEMS IF SPECIFIED FOR DISPLAY
            TaxInvoiceDisplay displayMode = TaxHelper.InvoiceDisplay;
            if (displayMode == TaxInvoiceDisplay.LineItem || displayMode == TaxInvoiceDisplay.LineItemRegistered)
            {
                foreach (OrderItem item in order.Items)
                {
                    //IS THIS A TAX ITEM?
                    if (item.OrderItemType == OrderItemType.Tax)
                    {
                        //IS THE TAX ITEM A PARENT ITEM OR A CHILD OF A DISPLAYED ITEM?
                        if (!item.IsChildItem || (items.IndexOf(AlwaysConvert.ToInt(item.ParentItemId)) > -1))
                        {
                            //TAX SHOULD BE SHOWN
                            items.Add(item);
                        }
                    }
                }
            }

            // SORT ITEMS AND COMBINE ORDER COUPONS TO COMPLETE INTITIALIZATION
            items.Sort(new OrderItemComparer());
            items = items.CombineOrderCoupons();
            return items;
        }

        protected string GetBillToAddress(object dataItem)
        {
            Order order = (Order)dataItem;
            string pattern = order.BillToCountry.AddressFormat;
            if (!string.IsNullOrEmpty(order.BillToEmail) && !pattern.Contains("[Email]") && !pattern.Contains("[Email_U]")) pattern += "\r\nEmail: [Email]";
            if (!string.IsNullOrEmpty(order.BillToPhone) && !pattern.Contains("[Phone]") && !pattern.Contains("[Phone_U]")) pattern += "\r\nPhone: [Phone]";
            if (!string.IsNullOrEmpty(order.BillToFax) && !pattern.Contains("[Fax]") && !pattern.Contains("[Fax_U]")) pattern += "\r\nFax: [Fax]";

            return ((Order)dataItem).FormatAddress(pattern, true);
        }

        protected string GetShipToAddress(object dataItem)
        {
            Order order = (Order)dataItem;
            List<string> addressList = new List<string>();
            foreach (OrderShipment shipment in order.Shipments)
            {
                string pattern = shipment.ShipToCountry.AddressFormat;
                if (!string.IsNullOrEmpty(shipment.ShipToEmail) && !pattern.Contains("[Email]") && !pattern.Contains("[Email_U]")) pattern += "\r\nEmail: [Email]";
                if (!string.IsNullOrEmpty(shipment.ShipToPhone) && !pattern.Contains("[Phone]") && !pattern.Contains("[Phone_U]")) pattern += "\r\nPhone: [Phone]";
                if (!string.IsNullOrEmpty(shipment.ShipToFax) && !pattern.Contains("[Fax]") && !pattern.Contains("[Fax_U]")) pattern += "\r\nFax: [Fax]";

                string shipTo = shipment.FormatToAddress(pattern, true);
                if (!addressList.Contains(shipTo)) addressList.Add(shipTo);
            }
            if (addressList.Count == 0) return "n/a";
            return string.Join("<hr />", addressList.ToArray());
        }

        protected decimal GetTotal(object dataItem, params OrderItemType[] orderItems)
        {
            return ((Order)dataItem).Items.TotalPrice(orderItems);
        }

        protected bool ShowAdjustmentsRow(object dataItem)
        {
            return (GetAdjustmentsTotal(dataItem) != 0);
        }

        protected decimal GetAdjustmentsTotal(object dataItem)
        {
            Order order = dataItem as Order;
            if (order == null) return 0;
            return order.Items.TotalPrice(OrderItemType.Charge, OrderItemType.Credit, OrderItemType.Coupon, OrderItemType.GiftWrap);
        }

        protected decimal GetProductTotal(object dataItem)
        {
            Order order = dataItem as Order;
            if (order == null) return 0;
            return order.Items.TotalPrice(OrderItemType.Product, OrderItemType.Discount);
        }

        protected decimal GetShippingTotal(object dataItem)
        {
            Order order = dataItem as Order;
            if (order == null) return 0;
            return order.Items.TotalPrice(OrderItemType.Shipping, OrderItemType.Handling);
        }

        protected void OrderItems_DataBinding(object sender, EventArgs e)
        {
            GridView grid = (GridView)sender;
            grid.Columns[2].Visible = TaxHelper.ShowTaxColumn;
            grid.Columns[2].HeaderText = TaxHelper.TaxColumnHeader;
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
            IList<Order> orders = GetOrders(selectedOrders.ToArray());
            foreach (Order order in orders)
            {
                EventsManager.Instance.RaiseOrderInvoicePrinted(null, new OrderEventArgs(order));
            }
        }
    }
}