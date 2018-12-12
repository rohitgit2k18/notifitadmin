namespace AbleCommerce.ConLib.Checkout.PaymentForms
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Utility;

    [Description("Payment form for a gift certificate based payment")]
    public partial class GiftCertificatePaymentForm : System.Web.UI.UserControl
    {
        // DEFINE EVENTS TO TRIGGER FOR CHECKOUT
        public event CheckingOutEventHandler CheckingOut;
        public event CheckedOutEventHandler CheckedOut;

        public decimal PaymentAmount { get; set; }

        private string _ValidationGroup = "GiftCertificate";

        [Browsable(true), DefaultValue("GiftCertificate")]
        [Description("Gets or sets the validation group for this control and all child controls.")]
        public string ValidationGroup
        {
            get { return _ValidationGroup; }
            set { _ValidationGroup = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            GiftCertificateNumber.ValidationGroup = _ValidationGroup;
            GiftCertificateNumberRequired.ValidationGroup = _ValidationGroup;
            GiftCertificateButton.ValidationGroup = _ValidationGroup;
            GiftCertificateButton.OnClientClick = "if (Page_ClientValidate('" + this.ValidationGroup + "')) { this.value='Processing...';this.onclick=function(){return false;}; }";
            GiftCertificateNumber.Attributes.Add("autocomplete", "off");
        }

        private Payment GetPayment()
        {
            Payment payment = new Payment();
            IPaymentMethodProvider payMethProvider = AbleContext.Resolve<IPaymentMethodProvider>();
            payment.PaymentMethod = payMethProvider.GetGiftCertificatePaymentMethod();
            payment.Amount = this.PaymentAmount > 0 ? this.PaymentAmount : AbleContext.Current.User.Basket.Items.TotalPrice();
            AccountDataDictionary instrumentBuilder = new AccountDataDictionary();
            instrumentBuilder["SerialNumber"] = StringHelper.StripHtml(GiftCertificateNumber.Text);
            payment.AccountData = instrumentBuilder.ToString();
            payment.ReferenceNumber = Payment.GenerateReferenceNumber(GiftCertificateNumber.Text);
            return payment;
        }

        protected void GiftCertificateButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                bool checkOut = true;
                if (CheckingOut != null)
                {
                    // CREATE THE PAYMENT OBJECT
                    Payment payment = GetPayment();
                    CheckingOutEventArgs c = new CheckingOutEventArgs(payment);
                    CheckingOut(this, c);
                    checkOut = !c.Cancel;
                }
                if (checkOut)
                {
                    Basket basket = AbleContext.Current.User.Basket;
                    GiftCertificateNumber.Text = StringHelper.StripHtml(GiftCertificateNumber.Text);
                    GiftCertificate gc = GiftCertificateDataSource.LoadForSerialNumber(GiftCertificateNumber.Text);
                    if (gc == null)
                    {
                        GiftCertPaymentErrors.Text = "This is not a valid gift certificate : " + GiftCertificateNumber.Text;
                    }
                    else if (gc.Balance <= 0)
                    {
                        GiftCertPaymentErrors.Text = "There is no balance left for this gift certificate : " + GiftCertificateNumber.Text;
                    }
                    else if (gc.IsExpired())
                    {
                        GiftCertPaymentErrors.Text = "This gift certificate is expired : " + GiftCertificateNumber.Text;
                    }
                    else if (AlreadyInUse(basket, gc))
                    {
                        GiftCertPaymentErrors.Text = "This gift certificate is already applied to your basket : " + GiftCertificateNumber.Text;
                    }
                    else
                    {
                        // process this gift certificate
                        decimal basketTotal = basket.Items.TotalPrice();
                        BasketItem bitem = new BasketItem();
                        bitem.Basket = basket;
                        bitem.OrderItemType = OrderItemType.GiftCertificatePayment;
                        bitem.Price = -(gc.Balance > basketTotal ? basketTotal : gc.Balance);
                        bitem.Quantity = 1;
                        bitem.Name = gc.Name;
                        bitem.Sku = gc.SerialNumber;
                        basket.Items.Add(bitem);
                        basket.Save();
                        decimal remBalance = basket.Items.TotalPrice();
                        if (remBalance > 0)
                        {
                            GiftCertPaymentErrors.Text = string.Format("A payment of {0} will be made using gift certificate {1}. It will leave a balance of {2} for this order. Please make additional payments.", gc.Balance.LSCurrencyFormat("lc"), GiftCertificateNumber.Text, remBalance.LSCurrencyFormat("lc"));
                        }
                        else
                        {
                            //payment done. process checkout
                            ICheckoutService checkoutService = AbleContext.Resolve<ICheckoutService>();
                            CheckoutRequest checkoutRequest = new CheckoutRequest(basket);
                            CheckoutResponse checkoutResponse = checkoutService.ExecuteCheckout(checkoutRequest);
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
                    if (!string.IsNullOrEmpty(GiftCertPaymentErrors.Text))
                    {
                        GiftCertErrorsPanel.Visible = true;
                    }
                }
            }
        }

        private bool AlreadyInUse(Basket basket, GiftCertificate gc)
        {
            foreach (BasketItem item in basket.Items)
            {
                if (item.OrderItemType == OrderItemType.GiftCertificatePayment
                    && item.Sku == gc.SerialNumber)
                {
                    return true;
                }
            }
            return false;
        }
    }
}