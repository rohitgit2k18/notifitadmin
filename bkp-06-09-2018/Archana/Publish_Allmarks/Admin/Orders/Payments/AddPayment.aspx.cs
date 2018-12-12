namespace AbleCommerce.Admin.Orders.Payments
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class AddPayment : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId = 0;
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

        protected void RecordPayment_CheckedChanged(object sender, EventArgs e)
        {
            ProcessPaymentPanel.Visible = ProcessPayment.Checked;
            RecordPaymentPanel.Visible = !ProcessPayment.Checked;
        }

        protected void ProcessPayment_CheckedChanged(object sender, EventArgs e)
        {
            ProcessPaymentPanel.Visible = ProcessPayment.Checked;
            RecordPaymentPanel.Visible = !ProcessPayment.Checked;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                decimal actualBalance = Order.GetBalance(false);
                decimal pendingBalance = Order.GetBalance(true);
                Balance.Text = pendingBalance.LSCurrencyFormat("lc");
                PendingMessage.Visible = (actualBalance != pendingBalance);
            }
        }
    }
}