namespace AbleCommerce.ConLib.Account
{
    using System;
    using System.ComponentModel;
    using AbleCommerce.Code;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;

    [Description("Displays payments made for an order")]
    public partial class OrderPayments : System.Web.UI.UserControl
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            int orderId = PageHelper.GetOrderId();
            Order order = OrderDataSource.Load(orderId);
            if (order != null && order.Payments.Count > 0)
            {
                //BIND PAYMENTS
                PaymentGrid.DataSource = order.Payments;
                PaymentGrid.DataBind();
            }
            else
            {
                PaymentPanel.Visible = false;
            }
        }

        protected bool ShowMailPaymentMessage(object dataItem)
        {
            Payment payment = (Payment)dataItem;
            return (payment.PaymentMethod != null && payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.Mail && payment.PaymentStatus == PaymentStatus.Unprocessed);
        }
    }
}