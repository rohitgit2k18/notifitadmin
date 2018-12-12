namespace AbleCommerce.Admin.Orders.Payments
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Utility;
    
    public partial class CancelRecurringPayment : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId = 0;
        private Order _Order;
        private int _PaymentId = 0;
        private Payment _Payment;

        protected void InitVars()
        {
            _PaymentId = AlwaysConvert.ToInt(Request.QueryString["PaymentId"]);
            _Payment = PaymentDataSource.Load(_PaymentId);
            if (_Payment == null) Response.Redirect("../Default.aspx");
            _OrderId = _Payment.OrderId;
            _Order = _Payment.Order;
        }

        protected bool SupportsVoid()
        {
            Transaction lastAuth = _Payment.Transactions.GetLastAuthorization();
            if ((lastAuth != null) && (lastAuth.PaymentGateway != null))
            {
                IPaymentProvider instance = lastAuth.PaymentGateway.GetInstance();
                if (instance != null)
                    return ((instance.SupportedTransactions & SupportedTransactions.Void) == SupportedTransactions.Void);
            }
            return false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            InitVars();
            if (!Page.IsPostBack)
            {
                PaymentReference.Text = _Payment.PaymentMethodName + " - " + _Payment.ReferenceNumber;
                decimal authorizations = _Payment.Transactions.GetTotalAuthorized();
                decimal captures = _Payment.Transactions.GetTotalCaptured();
                AuthorizationAmount.Text = authorizations.LSCurrencyFormat("lc");
                CaptureAmount.Text = captures.LSCurrencyFormat("lc");
                VoidAmount.Text = string.Format("{0}", (authorizations - captures).LSCurrencyFormat("lc"));
                ProcessVoidHelpText.Visible = SupportsVoid();
                ForceVoidHelpText.Visible = !ProcessVoidHelpText.Visible;
            }
        }

        protected void SubmitVoidButton_Click(object sender, EventArgs e)
        {
            _Payment.Void();
            if (!string.IsNullOrEmpty(CustomerNote.Text))
            {
                OrderNote note = new OrderNote(_Order.Id, AbleContext.Current.UserId, DateTime.UtcNow, CustomerNote.Text, NoteType.Public);
                note.Save();
            }
            Response.Redirect("Default.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }

        protected void CancelVoidButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }
    }
}