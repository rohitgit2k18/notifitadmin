namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using System.Collections.Generic;

    public partial class CancelOrder : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId = 0;
        private Order _Order;

        protected Order Order
        {
            get
            {
                if (_Order == null)
                {
                    _Order = OrderDataSource.Load(this.OrderId);
                }
                return _Order;
            }
        }

        protected int OrderId
        {
            get
            {
                if (_OrderId.Equals(0))
                {
                    _OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
                }
                return _OrderId;
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Comment.Text))
            {
                OrderNote note = new OrderNote(OrderId, AbleContext.Current.UserId, DateTime.UtcNow, Comment.Text, IsPrivate.Checked ? NoteType.Private : NoteType.Public);
                note.Order = this.Order;
                Order.Notes.Add(note);
                Order.Notes.Save();
            }

            if (PendingPaymentsPH.Visible)
            {
                Order.Cancel(CancelPaymentsCheckBox.Checked);
            }
            else
            {
                Order.Cancel(false);
            }

            Response.Redirect("ViewOrder.aspx?OrderNumber=" + Order.OrderNumber.ToString());
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) BackButton.NavigateUrl = "ViewOrder.aspx?OrderNumber=" + Order.OrderNumber.ToString();

            int count = GetPendingTransactionCount();
            PendingPaymentsPH.Visible = (count > 0);
            if (PendingPaymentsPH.Visible)
                PendingPaymentsLabel.Text = string.Format(PendingPaymentsLabel.Text, count);

            // ACTIVE GIFTCERTIFICATES
            int gcCount = 0;
            foreach (GiftCertificate gc in Order.GiftCertificates)
            {
                if (gc.SerialNumber != null && gc.SerialNumber.Length > 0)
                    gcCount++;
            }
            PHActiveGCs.Visible = (gcCount > 0);
            if (PHActiveGCs.Visible)
                ActiveGCsLabel.Text = string.Format(ActiveGCsLabel.Text, gcCount);

            // ACTIVE DIGITAL GOODS
            int dgCount = 0;
            foreach (OrderItem oi in Order.Items)
            {
                foreach (OrderItemDigitalGood oidg in oi.DigitalGoods)
                {
                    if (oidg.IsActivated()) dgCount++;
                }
            }
            PHActiveDGs.Visible = (dgCount > 0);
            if (PHActiveDGs.Visible)
                ActiveDGsLabel.Text = string.Format(ActiveDGsLabel.Text, dgCount);

            // DEACTIVATE ALL ASSOCIATED SUBSCRIPTIONS
            int subCount = SubscriptionDataSource.CountActiveForOrder(_Order.Id);
            PHActiveSubscriptions.Visible = (subCount > 0);
            if (PHActiveSubscriptions.Visible)
                ActiveSubscriptionsLabel.Text = string.Format(ActiveSubscriptionsLabel.Text, subCount);
        }

        private int GetPendingTransactionCount()
        {
            int count = 0;
            foreach (Payment payment in Order.Payments)
            {
                if (payment.IsVoidable)
                    count++;
            }
            return count;
        }
    }
}