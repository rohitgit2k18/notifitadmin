namespace AbleCommerce.Members
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;

    public partial class PayMyOrder : CommerceBuilder.UI.AbleCommercePage
    {
        private int _OrderId;

        protected void Page_Load(object sender, EventArgs e)
        {
            _OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
            Order order = OrderDataSource.Load(_OrderId);
            if (order == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page, "Members/MyAccount.aspx"));
            if (order.User != null && order.User.Id != AbleContext.Current.UserId) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page, "Members/MyAccount.aspx"));

            // cannot make payment on invalid orders or orders with subscription payments
            string viewOrderUrl = Page.ResolveUrl("~/Members/MyOrder.aspx?OrderNumber=" + order.OrderNumber);

            // cannot make payment on invalid orders or orders with subscription payments
            if (!order.OrderStatus.IsValid 
                || order.Payments.Where(payment => payment.Subscription != null).Count() > 0)
                Response.Redirect(viewOrderUrl);

            // CANCEL FAILED AUTHORIZATIONS
            List<Payment> failedPayments = order.Payments.Where(p => p.PaymentStatus == PaymentStatus.AuthorizationFailed).ToList();
            failedPayments.ForEach(p => p.Void());

            // Make sure the order has a balance to pay
            decimal unpaidBalance = order.GetCustomerBalance();
            if (unpaidBalance <= 0) Response.Redirect(viewOrderUrl);

            // BIND HEADER
            Caption.Text = String.Format(Caption.Text, order.OrderNumber);

            // BIND CHILD CONTROLS
            ToggleFailedPaymentPanel(order);
            OrderTotalSummary.Order = order;
            BillingAddress.Order = order;
            PaymentWidget.Order = order;
            OrderShipments.Order = order;
            OrderNonShippableItems.Order = order;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // PREVENT REPEATED FAILED PAYMENT ATTEMPTS
            Order order = OrderDataSource.Load(_OrderId);
            if (HasTooManyFailedPayments(order, 3))
            {
                // DISABLE PAYMENT FORM FOR TOO MANY FAILED ATTEMPTS
                TooManyTriesPanel.Visible = true;
                PaymentFailedPanel.Visible = false;
                PaymentWidget.Visible = false;
            }
        }

        /// <summary>
        /// Determines whether the last X payments in a row have "failed"
        /// </summary>
        /// <returns>True if the last X payments in a row have "failed"</returns>
        private static bool HasTooManyFailedPayments(Order order, int limit)
        {
            int paymentCount = order.Payments.Count;
            if (paymentCount < limit) return false;
            int failedPaymentCount = 0;
            for (int i = paymentCount - 1; i >= 0; i--)
            {
                Payment payment = order.Payments[i];
                if (IsFailedPayment(payment))
                {
                    failedPaymentCount++;
                    if (failedPaymentCount == limit) return true;
                }
                else return false;
            }
            return false;
        }

        private void ToggleFailedPaymentPanel(Order order)
        {
            Payment lastPayment = order.Payments.LastPayment();
            if (lastPayment != null && lastPayment.PaymentStatus == PaymentStatus.Void)
            {
                Transaction authTx = GetLastAuthorization(lastPayment);
                if (authTx != null && authTx.TransactionStatus == TransactionStatus.Failed)
                {
                    PaymentFailedPanel.Visible = true;
                    string failedReason = authTx.ResponseMessage;
                    if (string.IsNullOrEmpty(failedReason)) failedReason = "Authorization failed";
                    PaymentFailedReason.Text = failedReason;
                }
            }
            else PaymentFailedPanel.Visible = false;
        }

        /// <summary>
        /// Determines whether this payment has "failed"
        /// </summary>
        /// <param name="p">Payment to check</param>
        /// <returns>True if the payment authorization failed</returns>
        private static bool IsFailedPayment(Payment payment)
        {
            Transaction authTx = GetLastAuthorization(payment);
            return (authTx != null && authTx.TransactionStatus == TransactionStatus.Failed);
        }

        /// <summary>
        /// Gets the last authorization transaction
        /// </summary>
        /// <param name="p">The payment</param>
        /// <returns>The last authorization transaction</returns>
        private static Transaction GetLastAuthorization(Payment payment)
        {
            for (int i = payment.Transactions.Count - 1; i >= 0; i--)
            {
                Transaction t = payment.Transactions[i];
                if (t.TransactionType == TransactionType.Authorize ||
                    t.TransactionType == TransactionType.AuthorizeCapture ||
                    t.TransactionType == TransactionType.AuthorizeRecurring) return t;
            }
            return null;
        }
    }
}