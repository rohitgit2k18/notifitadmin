namespace AbleCommerce.Admin.Orders.Print
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Eventing;

    public partial class PullSheet : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private IList<string> orderNumbers;

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
            ItemGrid.DataSource = OrderPullItemDataSource.GeneratePullSheet(selectedOrders.ToArray());
            ItemGrid.DataBind();
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
                    EventsManager.Instance.RaiseInventoryPullSheetPrinted(null, new OrderEventArgs(order));
            }
        }
    }
}