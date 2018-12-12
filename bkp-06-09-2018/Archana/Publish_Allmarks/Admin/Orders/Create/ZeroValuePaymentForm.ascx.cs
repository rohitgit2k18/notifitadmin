namespace AbleCommerce.Admin.Orders.Create
{
    using System;
    using System.Collections.Generic;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class ZeroValuePaymentForm : System.Web.UI.UserControl
    {
        private int _UserId;
        private User _User;
        Basket _Basket;

        //DEFINE EVENTS TO TRIGGER FOR CHECKOUT
        public event CheckingOutEventHandler CheckingOut;
        public event CheckedOutEventHandler CheckedOut;

        private string _ValidationGroup = "ZeroValue";
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        private bool _ValidationSummaryVisible = false;
        public bool ValidationSummaryVisible
        {
            get { return _ValidationSummaryVisible; }
            set { _ValidationSummaryVisible = value; }
        }

        private void UpdateValidationOptions()
        {
            CompleteButton.ValidationGroup = _ValidationGroup;
            ValidationSummary1.ValidationGroup = _ValidationGroup;
            ValidationSummary1.Visible = _ValidationSummaryVisible;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // LOCATE THE USER THAT THE ORDER IS BEING PLACED FOR
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UID"]);
            _User = UserDataSource.Load(_UserId);
            if (_User == null) return;
            _Basket = _User.Basket;

            UpdateValidationOptions();
        }

        protected void CompleteButton_Click(object sender, EventArgs e)
        {
            bool checkOut = true;
            if (CheckingOut != null)
            {
                CheckingOutEventArgs c = new CheckingOutEventArgs();
                CheckingOut(this, c);
                checkOut = !c.Cancel;
            }
            if (checkOut)
            {
                //PROCESS THE CHECKOUT
                ICheckoutService checkoutService = AbleContext.Resolve<ICheckoutService>();
                CheckoutRequest checkoutRequest = new CheckoutRequest(_Basket);
                CheckoutResponse checkoutResponse = checkoutService.ExecuteCheckout(checkoutRequest, false);
                if (checkoutResponse.Success)
                {
                    if (CheckedOut != null) CheckedOut(this, new CheckedOutEventArgs(checkoutResponse));
                    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetReceiptUrl(checkoutResponse.Order.OrderNumber));
                }
                else
                {
                    IList<string> warningMessages = checkoutResponse.WarningMessages;
                    if (warningMessages.Count == 0)
                        warningMessages.Add("The order could not be submitted at this time.  Please try again later or contact us for assistance.");
                    if (CheckedOut != null) CheckedOut(this, new CheckedOutEventArgs(checkoutResponse));
                }
            }
        }
    }
}