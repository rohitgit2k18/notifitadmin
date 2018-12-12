namespace AbleCommerce.Code
{
    using System;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;

    /// <summary>
    /// Delegate for handling events for checkout
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    public delegate void CheckedOutEventHandler(object sender, CheckedOutEventArgs e);

    public delegate void CheckingOutEventHandler(object sender, CheckingOutEventArgs e);

    public delegate void CouponAppliedEventHandler(object sender, EventArgs e);

    public class CheckedOutEventArgs
    {
        public CheckedOutEventArgs(CheckoutResponse response)
        {
            this.CheckoutResponse = response;
        }

        public CheckoutResponse CheckoutResponse { get; private set; }
    }

    public class CheckingOutEventArgs
    {
        private bool _Cancel;
        private Payment _Payment;

        public CheckingOutEventArgs() { }

        public CheckingOutEventArgs(Payment p)
        {
            _Payment = p;
        }

        public bool Cancel
        {
            get { return _Cancel; }
            set { _Cancel = value; }
        }

        public Payment Payment
        {
            get { return _Payment; }
        }
    }
}