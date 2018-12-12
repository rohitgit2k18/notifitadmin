using System;
using CommerceBuilder.Orders;
using CommerceBuilder.Payments;

namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class OrderPayments : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Order != null && this.Order.Payments.Count > 0)
            {
                //BIND PAYMENTS
                PaymentGrid.DataSource = this.Order.Payments;
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