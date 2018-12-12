namespace AbleCommerce.Admin.Orders.Batch
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;

    public partial class Cancel : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private IList<Order> _Orders;
        private string _OrderNumbers;

        protected void LoadOrders(params int[] orderIds)
        {
            _Orders = new List<Order>();
            foreach (int orderId in orderIds)
            {
                Order order = OrderDataSource.Load(orderId);
                if (order != null) _Orders.Add(order);
            }
            _Orders.Sort("OrderId");
            List<string> OrderNumbers = new List<string>();
            foreach (Order order in _Orders)
                OrderNumbers.Add(order.OrderNumber.ToString());
            _OrderNumbers = string.Join(", ", OrderNumbers.ToArray());
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            IList<int> selectedOrders = AbleContext.Current.Session.SelectedOrderIds;
            if ((selectedOrders == null) || (selectedOrders.Count == 0)) Response.Redirect("~/Admin/Orders/Default.aspx");
            LoadOrders(selectedOrders.ToArray());
            OrderGrid.DataSource = _Orders;
            OrderGrid.DataBind();
            OrderList.Text = _OrderNumbers;
        }

        protected string GetOrderStatus(Object orderStatusId)
        {
            OrderStatus status = OrderStatusDataSource.Load((int)orderStatusId);
            if (status != null) return status.Name;
            return string.Empty;
        }

        protected string GetPaymentStatus(object dataItem)
        {
            Order order = (Order)dataItem;
            if (order.PaymentStatus == OrderPaymentStatus.Paid) return "Paid";
            if (order.Payments.Count > 0)
            {
                order.Payments.Sort("PaymentDate");
                Payment lastPayment = order.Payments[order.Payments.Count - 1];
                return StringHelper.SpaceName(lastPayment.PaymentStatus.ToString());
            }
            return string.Empty;
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            AbleContext.Current.Database.BeginTransaction();
            foreach (Order order in _Orders)
            {
                if (!string.IsNullOrEmpty(Comment.Text))
                {
                    order.Notes.Add(new OrderNote(order.Id, AbleContext.Current.UserId, DateTime.UtcNow, Comment.Text, IsPrivate.Checked ? NoteType.Private : NoteType.Public));
                    order.Notes.Save();
                }
                order.Cancel();
            }
            AbleContext.Current.Database.CommitTransaction();
            CommentPanel.Visible = false;
            ConfirmPanel.Visible = true;
            OrderList2.Text = _OrderNumbers;
        }
    }
}