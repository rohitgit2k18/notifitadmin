namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Reflection;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Stores;

    [Description("Builds amazon payment button")]
    public partial class AmazonPaymentButton : System.Web.UI.UserControl
    {
        private int _PaymentId;
        public int PaymentId
        {
            get { return _PaymentId; }
            set { _PaymentId = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Payment payment = PaymentDataSource.Load(this.PaymentId);
            if (payment != null && IsUnprocessedAmazonPayment(payment))
            {
                IPaymentProvider amazonProvider = GetAmazonProvider();
                if (amazonProvider != null)
                {
                    MethodInfo buttonMethod = amazonProvider.GetType().GetMethod("GetPaymentButton");
                    object[] parameters = new object[] { payment };
                    ImageButton paymentButton = (ImageButton)buttonMethod.Invoke(amazonProvider, parameters);
                    this.ButtonPanel.Controls.Add(paymentButton);
                }
            }
        }

        private static bool IsUnprocessedAmazonPayment(Payment payment)
        {
            if (payment.PaymentStatus != PaymentStatus.Unprocessed && payment.PaymentStatus != PaymentStatus.AuthorizationPending) return false;
            if (payment.PaymentMethod == null) return false;
            if (payment.PaymentMethod.PaymentInstrumentType != PaymentInstrumentType.Amazon) return false;
            return true;
        }

        private IPaymentProvider GetAmazonProvider()
        {
            Store store = AbleContext.Current.Store;
            IList<PaymentGateway> gatewayList = store.PaymentGateways;
            foreach (PaymentGateway gateway in gatewayList)
            {
                if (gateway.ClassId.EndsWith("CommerceBuilder.Amazon"))
                {
                    return gateway.GetInstance();
                }
            }
            return null;
        }
    }
}