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
    
    public partial class VoidPayment : CommerceBuilder.UI.AbleCommerceAdminPage
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
                bool supportsVoid = SupportsVoid();
                PaymentReference.Text = _Payment.PaymentMethodName + " - " + _Payment.ReferenceNumber;
                PaymentAmount.Text = _Payment.Amount.LSCurrencyFormat("lc");
                decimal authorizations = _Payment.Transactions.GetTotalAuthorized();
                decimal captures = _Payment.Transactions.GetTotalCaptured();
                AuthorizationAmount.Text = authorizations.LSCurrencyFormat("lc");
                CaptureAmount.Text = captures.LSCurrencyFormat("lc");
                decimal voidAmount = authorizations > 0 ? authorizations - captures : _Payment.Amount;
                VoidAmount.Text = voidAmount.LSCurrencyFormat("lc");
                ProcessVoidHelpText.Visible = supportsVoid;
                if (!supportsVoid)
                {
                    if (_Payment.PaymentMethod != null && (_Payment.PaymentMethod.IsCreditOrDebitCard() ||
                        _Payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.PayPal))
                    {
                        ForcedVoidAuthorizationHelpText.Visible = true;
                        ForcedVoidPaymentHelpText.Visible = false;
                        this.Title = "Void Authorization";
                        Caption.Text = "Void Authorization";
                    }
                    else
                    {
                        ForcedVoidAuthorizationHelpText.Visible = false;
                        ForcedVoidPaymentHelpText.Visible = true;
                        this.Title = "Void Payment";
                        Caption.Text = "Void Payment";
                    }
                }
                else
                {
                    ForcedVoidAuthorizationHelpText.Visible = false;
                    ForcedVoidPaymentHelpText.Visible = false;
                }
            }
        }

        protected void SubmitVoidButton_Click(object sender, EventArgs e)
        {
            _Payment.Void();
            if (!string.IsNullOrEmpty(CustomerNote.Text))
            {
                OrderNote note = new OrderNote(_Order.Id, AbleContext.Current.UserId, DateTime.UtcNow, CustomerNote.Text, NoteType.Public);
                _Order.Notes.Add(note);
                _Order.Save(false, false);
            }
            Response.Redirect("Default.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }

        protected void CancelVoidButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }
    }
}