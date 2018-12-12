namespace AbleCommerce.ConLib.Checkout.PaymentForms
{
    using System;
    using System.Collections.Generic;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services.Checkout;
    using System.ComponentModel;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Shipping.Providers;
    using CommerceBuilder.Users;
    using System.Web.Script.Serialization;

    [Description("Payment form for a mail based payment")]
    public partial class MailPaymentForm : System.Web.UI.UserControl
    {
        //DEFINE EVENTS TO TRIGGER FOR CHECKOUT
        public event CheckingOutEventHandler CheckingOut;
        public event CheckedOutEventHandler CheckedOut;

        private string _ValidationGroup = "MailPayment";

        [Browsable(true), DefaultValue("MailPayment")]
        [Description("Gets or sets the validation group for this control and all child controls.")]
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        public decimal PaymentAmount { get; set; }

        public int PaymentMethodId { get; set; }

        protected void Page_Init(object sender, EventArgs e)
        {
            UpdateValidationOptions();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            PaymentMethod method = PaymentMethodDataSource.Load(this.PaymentMethodId);
            if (method != null)
            {
                MailButton.Text = string.Format(MailButton.Text, method.Name);
                MailButton.OnClientClick = "if (Page_ClientValidate('" + this.ValidationGroup + "')) { this.value='Processing...';this.onclick=function(){return false;}; }";
            }
            else
            {
                this.Controls.Clear();
            }
        }

        private void UpdateValidationOptions()
        {
            MailButton.ValidationGroup = _ValidationGroup;
        }

        private Payment GetPayment()
        {
            Payment payment = new Payment();
            payment.PaymentMethod = PaymentMethodDataSource.Load(this.PaymentMethodId);
            if (this.PaymentAmount > 0) payment.Amount = this.PaymentAmount;
            else payment.Amount = AbleContext.Current.User.Basket.Items.TotalPrice();
            return payment;
        }

        protected void MailButton_Click(object sender, EventArgs e)
        {
            // CREATE THE PAYMENT OBJECT
            Payment payment = GetPayment();

            // PROCESS CHECKING OUT EVENT
            bool checkOut = true;
            if (CheckingOut != null)
            {
                CheckingOutEventArgs c = new CheckingOutEventArgs(payment);
                CheckingOut(this, c);
                checkOut = !c.Cancel;
            }
            if (checkOut)
            {

                // CONTINUE TO PROCESS THE CHECKOUT
                Basket basket = AbleContext.Current.User.Basket;


                //Remove code?
                //ICheckoutService checkoutService = AbleContext.Resolve<ICheckoutService>();
                //CheckoutRequest checkoutRequest = new CheckoutRequest(basket, payment);
                //CheckoutResponse checkoutResponse = checkoutService.ExecuteCheckout(checkoutRequest);

                //CUSTOM: PROCESS THE CHECKOUT
                CheckoutRequest checkoutRequest = new CheckoutRequest(null);
                CheckoutResponse checkoutResponse = basket.Checkout(checkoutRequest);
                if (checkoutResponse.Success)
                {
                    Order order = new Order();

                    order = OrderDataSource.Load(checkoutResponse.OrderId);

                    Address address = AbleContext.Current.User.PrimaryAddress;

                    // Add the contact details to the saved order.
                    order.BillToEmail = address.Email;
                    order.BillToFirstName = address.FirstName;
                    order.BillToLastName = address.LastName;
                    order.BillToPhone = address.Phone;
                    order.BillToCompany = address.Company;
                    order.Save();

                    // Save the Comment entered on the Quote Form to the CustomFields table.
                    CustomField comment = new CustomField();
                    comment.FieldName = "QuoteRequestComment";
                    comment.FieldValue = Comments.Text;
                    comment.TableName = "Orders";
                    comment.ForeignKeyId = order.Id;
                    comment.Store.Id = order.StoreId;
                    comment.Save();

                    // The list of files that have been uploaded
                    List<FileAttachment> files = Session["UPLOADED_BASKET"] as List<FileAttachment>;

                    //CrmHelper.SaveEnquiry(order, StringHelper.StripHtml(Comments.Text), files, AbleContext.Current.Store);

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
}