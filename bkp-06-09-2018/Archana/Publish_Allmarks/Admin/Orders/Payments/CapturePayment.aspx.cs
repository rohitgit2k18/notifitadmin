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

    public partial class CapturePayment : CommerceBuilder.UI.AbleCommerceAdminPage
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


        protected void Page_Load(object sender, EventArgs e)
        {
            InitVars();
            if (!Page.IsPostBack)
            {
                Caption.Text = string.Format(Caption.Text, (_Order.Payments.IndexOf(_PaymentId) + 1), _Payment.ReferenceNumber);
                CurrentPaymentStatus.Text = StringHelper.SpaceName(_Payment.PaymentStatus.ToString()).ToUpperInvariant();
                CurrentPaymentStatus.CssClass = AbleCommerce.Code.CssHelper.GetPaymentStatusCssClass(_Payment.PaymentStatus);
                PaymentDate.Text = string.Format("{0:g}", _Payment.PaymentDate);
                Amount.Text = _Payment.Amount.LSCurrencyFormat("lc");
                PaymentMethod.Text = _Payment.PaymentMethodName;
                decimal orig = _Payment.Transactions.GetTotalAuthorized();
                decimal rem = _Payment.Transactions.GetRemainingAuthorized();
                decimal bal = _Order.GetBalance(false);
                OriginalAuthorization.Text = orig.LSCurrencyFormat("lc");
                RemainingAuthorization.Text = rem.LSCurrencyFormat("lc");
                trRemainingAuthorization.Visible = (orig != rem);
                CaptureAmount.Text = string.Format("{0:F2}", rem > bal ? bal : rem);
                OrderBalance.Text = bal.LSCurrencyFormat("lc");
                trAdditionalCapture.Visible = IsPartialCaptureSupported();
            }
            AccountDataViewport.PaymentId = _PaymentId;
        }

        protected bool IsPartialCaptureSupported()
        {
            Transaction lastAuth = _Payment.Transactions.GetLastAuthorization();
            if (lastAuth != null)
            {
                PaymentGateway gateway = lastAuth.PaymentGateway;
                if (gateway != null)
                {
                    IPaymentProvider instance = gateway.GetInstance();
                    return ((instance.SupportedTransactions & SupportedTransactions.PartialCapture) == SupportedTransactions.PartialCapture);
                }
            }
            return false;
        }

        protected void SubmitCaptureButton_Click(object sender, EventArgs e)
        {
            //GET THE CAPTURE AMOUNT
            decimal rem = _Payment.Transactions.GetRemainingAuthorized();
            decimal bal = _Order.GetBalance(false);
            string originalCaptureAmount = string.Format("{0:F2}", rem > bal ? bal : rem);

            decimal captureAmount = AlwaysConvert.ToDecimal(CaptureAmount.Text);
            // AC8-2854: IF amount is not changed by merchant then
            // to avoid rounding issues, restore the original amount upto 4 decimal digits
            if(originalCaptureAmount == CaptureAmount.Text) captureAmount = rem > bal ? bal : rem;
            bool finalCapture = NoAdditionalCapture.Checked;
            if (captureAmount > 0)
            {
                _Payment.Capture(captureAmount, finalCapture, false);
                if (!string.IsNullOrEmpty(CustomerNote.Text))
                {
                    OrderNote note = new OrderNote(_Order.Id, AbleContext.Current.UserId, DateTime.UtcNow, CustomerNote.Text, NoteType.Public);
                    note.Save();
                }
            }
            Response.Redirect("Default.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }

        protected void CancelCaptureButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }

    }
}