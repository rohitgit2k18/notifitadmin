namespace AbleCommerce.Mobile.Checkout
{
    using System;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Products;
    using AbleCommerce.Code;

    public partial class Receipt : CommerceBuilder.UI.AbleCommercePage
    {
        private bool _HandleFailedPayments = true;
        Order _Order = null;

        public bool HandleFailedPayments
        {
            get { return _HandleFailedPayments; }
            set { _HandleFailedPayments = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            _Order = OrderDataSource.Load(PageHelper.GetOrderId());
            if (_Order == null) Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Members/MyAccount.aspx"));
            if (_Order.User != null && _Order.User.Id != AbleContext.Current.UserId) Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Members/MyAccount.aspx"));
            
            // CHECK FOR FAILED PAYMENTS
            if (this.HandleFailedPayments) ValidatePayments(_Order);

            // BIND ORDER
            Caption.Text = String.Format(Caption.Text, _Order.OrderNumber);
            decimal unpaidBalance = _Order.GetCustomerBalance();
            if (!_Order.OrderStatus.IsValid)
            {
                OrderInvalidPanel.Visible = true;
            }
            else if (unpaidBalance > 0 && !OrderHasSubscriptionPayments(_Order))
            {
                BalanceDuePanel.Visible = true;
                BalanceDueMessage.Text = string.Format(BalanceDueMessage.Text, unpaidBalance.LSCurrencyFormat("ulc"), this.Page.ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/Members/PayMyOrder.aspx?OrderNumber=") + _Order.OrderNumber.ToString()));
            }

            // BIND CHILD WIDGETS
            OrderSummary.Order = _Order;
            OrderTotalSummary.Order = _Order;
            BillingAddress.Order = _Order;
            OrderPayments.Order = _Order;
            OrderShipments.Order = _Order;
            OrderNonShippableItems.Order = _Order;
            OrderDigitalGoods.Order = _Order;
            OrderGiftCertificates.Order = _Order;
            OrderNotes.Order = _Order;
            OrderSubscriptions.Order = _Order;
            AffiliateTracker.Order = _Order;

            // REPEAT ORDER BUTTON
            if (this.IsRepeatable)
            {
                ReorderButton.Visible = !AbleContext.Current.Store.Settings.ProductPurchasingDisabled;
                ReorderButton.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Reorder.ashx?o=") + _Order.Id.ToString();
            }
        }

        private void ValidatePayments(Order order)
        {
            // ONLY VALIDATE PAYMENT IF THERE IS ONE NON SUSCRIPTION PAYMENT / ONE TRANSACTION
            if (order.Payments.Count == 1 && order.Payments[0].SubscriptionId == 0 && order.Payments[0].Transactions.Count == 1)
            {
                decimal balance = order.GetBalance(true);
                if (order.OrderStatus.IsValid && balance > 0)
                {
                    Payment lastPayment = order.Payments.LastPayment();
                    if (lastPayment != null)
                    {
                        // GET LAST AUTHORIZATION (EXCLUDING A RECURRING AUTH)
                        Transaction authTx = GetLastAuthorization(lastPayment);
                        if (authTx != null && authTx.TransactionStatus == TransactionStatus.Failed)
                        {
                            //SEND THE CUSTOMER TO THE PAY ORDER PAGE
                            Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Members/PayMyOrder.aspx?OrderNumber=" + order.OrderNumber.ToString()));
                        }
                    }
                }
            }
        }

        private Transaction GetLastAuthorization(Payment p)
        {
            for (int i = p.Transactions.Count - 1; i >= 0; i--)
            {
                Transaction t = p.Transactions[i];
                if (t.TransactionType == TransactionType.Authorize ||
                    t.TransactionType == TransactionType.AuthorizeCapture) return t;
            }
            return null;
        }

        private bool OrderHasSubscriptionPayments(Order order)
        {
            foreach (Payment payment in order.Payments)
            {
                if (payment.Subscription != null && payment.Subscription.Id != 0) return true;
            }
            return false;
        }

        private bool IsRepeatable
        {
            get
            {
                int availableCount = 0;
                if (_Order != null)
                {
                    foreach (OrderItem item in _Order.Items)
                    {
                        if ((item.OrderItemType == OrderItemType.Product) && (!item.IsChildItem))
                        {
                            Product product = item.Product;
                            if ((product != null) && (product.Visibility != CommerceBuilder.Catalog.CatalogVisibility.Private))
                            {
                                availableCount++;
                            }
                        }
                    }
                }
                return (availableCount > 0);
            }
        }
    }
}