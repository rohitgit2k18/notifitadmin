//-----------------------------------------------------------------------
// <copyright file="CreateOrder4.aspx.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Admin.Orders.Create
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Services;

    public partial class CreateOrder4 : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _UserId;
        private User _User;
        Basket _Basket;

        /// <summary>
        ///  For orders placed on behalf of unregistered users, this field holds the 
        /// user account that matches the email address given on the billing form (if any)
        /// </summary>
        private User _ExistingUser;

        protected void Page_Init(object sender, EventArgs e)
        {
            // LOCATE THE USER THAT THE ORDER IS BEING PLACED FOR
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UID"]);
            _User = UserDataSource.Load(_UserId);
            if (_User == null) Response.Redirect("CreateOrder1.aspx");
            _Basket = _User.Basket;
            MiniBasket1.BasketId = _Basket.Id;
            if (!Page.IsPostBack)
            {
                IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                preCheckoutService.Recalculate(_Basket);
            }

            // INITIALIZE THE CAPTION
            string userName = _User.IsAnonymous ? "Unregistered User" : _User.UserName;
            Caption.Text = string.Format(Caption.Text, userName);

            // SHOW BILLING ADDRESS
            BillToAddress.Text = _User.PrimaryAddress.ToString(true);
            EditAddressesLink.NavigateUrl += "?UID=" + _UserId;

            // SHOW REGISTRATION PANEL IF USER IS ANONYMOUS
            if (_User.IsAnonymous)
            {
                RegisterPanel.Visible = true;
                string billToEmail = _User.PrimaryAddress.Email;
                IList<User> matchingUsers = UserDataSource.LoadForEmail(billToEmail, false);
                bool userExists = (matchingUsers.Count > 0);
                if (userExists)
                {
                    _ExistingUser = matchingUsers[0];
                    AccountUserName.Text = _ExistingUser.UserName;
                    AccountEmail.Text = _ExistingUser.Email;
                }
                else
                {
                    AccountUserName.Text = billToEmail;
                    AccountEmail.Text = billToEmail;
                }
                RegisteredUserHelpText.Visible = userExists;
                UnregisteredUserHelpText.Visible = !userExists;
                LinkAccountLabel.Visible = userExists;
                CreateAccountLabel.Visible = !userExists;
                trAccountPassword.Visible = !userExists;
                trForceExpiration.Visible = !userExists;
            }

            // SHOW SHIPPING METHODS IF NECESSARY
            ShippingMethodPanel.Visible = _Basket.Items.HasShippableProducts();
            if (ShippingMethodPanel.Visible)
            {
                tdShipTo.Visible = true;
                Address shipAddress = this.ShippingAddress;
                if (shipAddress != null) ShipToAddress.Text = shipAddress.ToString(true);
                if (!Page.IsPostBack)
                {
                    // ONLY BIND SHIPMENT LIST ON FIRST VISIT
                    ShipmentList.DataSource = _Basket.Shipments;
                    ShipmentList.DataBind();
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // SHOW PAYMENT METHODS
            BindPaymentMethodForms();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            PaymentMethodCaption.Text = string.Format(PaymentMethodCaption.Text, _Basket.Items.TotalPrice().LSCurrencyFormat("lc"));
        }

        protected int ShipmentCount
        {
            get { return _Basket.Shipments.Count; }
        }

        protected void ShipmentList_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            //SHOW SHIPPING METHODS
            DropDownList ShipMethodList = (DropDownList)e.Item.FindControl("ShipMethodList");
            if (ShipMethodList != null)
            {
                BasketShipment shipment = (BasketShipment)e.Item.DataItem;
                if (shipment != null)
                {
                    // CALCULATE THE SHIPPING RATES
                    ICollection<ShipRateQuote> rateQuotes =  AbleContext.Resolve<IShipRateQuoteCalculator>().QuoteForShipment(shipment);
                    foreach (ShipRateQuote quote in rateQuotes)
                    {
                        decimal totalRate = TaxHelper.GetShopPrice(quote.TotalRate, quote.ShipMethod.TaxCodeId, null, new TaxAddress(shipment.Address));
                        string formattedRate = totalRate.LSCurrencyFormat("ulc");
                        string methodName = (totalRate > 0) ? quote.Name + ": " + formattedRate : quote.Name;
                        ShipMethodList.Items.Add(new ListItem(methodName, quote.ShipMethodId.ToString()));
                    }
                }
            }
        }

        protected void ShipMethodList_SelectedIndexChanged(object sender, EventArgs e)
        {
            // UPDATE SHIPMENTS
            for (int i = 0; i < ShipmentList.Items.Count; i++)
            {
                RepeaterItem item = ShipmentList.Items[i];
                if (item != null)
                {
                    BasketShipment shipment = _Basket.Shipments[i];
                    DropDownList ShipMethodList = (DropDownList)item.FindControl("ShipMethodList");
                    if (shipment != null && ShipMethodList != null)
                    {
                        shipment.ShipMethodId = AlwaysConvert.ToInt(ShipMethodList.Items[ShipMethodList.SelectedIndex].Value);
                    }
                }
            }

            // UPDATE THE ORDER ITMES PANEL TO REFLECT ANY CHANGE
            _Basket.Save();
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(_Basket);

            BindPaymentMethodForms();
            BasketAjax.Update();
        }

        private Address ShippingAddress
        {
            get
            {
                if (_Basket.Shipments.Count > 0)
                {
                    int index = _User.Addresses.IndexOf(_Basket.Shipments[0].AddressId);
                    if (index > -1) return _User.Addresses[index];
                }
                return null;
            }
        }

        private void BindPaymentMethodForms()
        {
            //CHECK ORDER TOTAL
            decimal orderTotal = _Basket.Items.TotalPrice();

            CreditCardPaymentForm.Visible = false;
            GiftCertificatePaymentForm.Visible = false;
            CheckPaymentForm.Visible = false;
            PurchaseOrderPaymentForm.Visible = false;
            PayPalPaymentForm.Visible = false;
            MailPaymentForm.Visible = false;
            PhoneCallPaymentForm.Visible = false;
            ZeroValuePaymentForm.Visible = false;
            DeferPaymentForm.Visible = false;

            if (orderTotal > 0)
            {
                List<DictionaryEntry> paymentMethods = new List<DictionaryEntry>();
                //ADD PAYMENT FORMS
                bool creditCardAdded = false;
                IList<PaymentMethod> availablePaymentMethods = AbleCommerce.Code.StoreDataHelper.GetPaymentMethods(_UserId);
                foreach (PaymentMethod method in availablePaymentMethods)
                {
                    switch (method.PaymentInstrumentType)
                    {
                        case PaymentInstrumentType.AmericanExpress:
                        case PaymentInstrumentType.Discover:
                        case PaymentInstrumentType.JCB:
                        case PaymentInstrumentType.MasterCard:
                        case PaymentInstrumentType.Visa:
                        case PaymentInstrumentType.DinersClub:
                        case PaymentInstrumentType.Maestro:
                        case PaymentInstrumentType.SwitchSolo:
                        case PaymentInstrumentType.VisaDebit:
                            if (!creditCardAdded)
                            {
                                paymentMethods.Insert(0, new DictionaryEntry(0, "Credit/Debit Card"));
                                creditCardAdded = true;
                            }
                            break;
                        case PaymentInstrumentType.Check:
                        case PaymentInstrumentType.PurchaseOrder:
                        case PaymentInstrumentType.PayPal:
                        case PaymentInstrumentType.Mail:
                        case PaymentInstrumentType.PhoneCall:
                            paymentMethods.Add(new DictionaryEntry(method.Id, method.Name));
                            break;
                        default:
                            //types not supported
                            break;
                    }
                }

                if (AbleCommerce.Code.StoreDataHelper.HasGiftCertificates())
                {
                    paymentMethods.Add(new DictionaryEntry(-1, "Gift Certificate"));
                }
                paymentMethods.Add(new DictionaryEntry(-2, "Defer Payment"));

                //BIND THE RADIO LIST FOR PAYMENT METHOD SELECTION
                PaymentMethodList.DataSource = paymentMethods;
                PaymentMethodList.DataBind();

                //CONTINUE IF PAYMENT METHODS ARE AVAILABLE
                if (paymentMethods.Count > 0)
                {
                    //MAKE SURE THE CORRECT PAYMENT METHOD IS SELECTED
                    int paymentMethodId = AlwaysConvert.ToInt(Request.Form[PaymentMethodList.UniqueID]);
                    ListItem selectedListItem = PaymentMethodList.Items.FindByValue(paymentMethodId.ToString());
                    if (selectedListItem != null)
                    {
                        PaymentMethodList.SelectedIndex = PaymentMethodList.Items.IndexOf(selectedListItem);
                    }
                    else PaymentMethodList.SelectedIndex = 0;

                    //GET THE CURRENTLY SELECTED METHOD
                    paymentMethodId = AlwaysConvert.ToInt(PaymentMethodList.SelectedValue);
                    if (paymentMethodId == 0)
                    {
                        CreditCardPaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                        CreditCardPaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                        CreditCardPaymentForm.Visible = true;
                    }
                    else if (paymentMethodId == -1)
                    {
                        GiftCertificatePaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                        GiftCertificatePaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                        GiftCertificatePaymentForm.Visible = true;
                    }
                    else if (paymentMethodId == -2)
                    {
                        DeferPaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                        DeferPaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                        DeferPaymentForm.Visible = true;
                    }
                    else
                    {
                        //DISPLAY FORM FOR SPECIFIC METHOD
                        PaymentMethod selectedMethod = availablePaymentMethods[availablePaymentMethods.IndexOf(paymentMethodId)];
                        switch (selectedMethod.PaymentInstrumentType)
                        {
                            case PaymentInstrumentType.Check:
                                CheckPaymentForm.PaymentMethodId = selectedMethod.Id;
                                CheckPaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                                CheckPaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                                CheckPaymentForm.Visible = true;
                                break;
                            case PaymentInstrumentType.PurchaseOrder:
                                PurchaseOrderPaymentForm.PaymentMethodId = selectedMethod.Id;
                                PurchaseOrderPaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                                PurchaseOrderPaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                                PurchaseOrderPaymentForm.Visible = true;
                                break;
                            case PaymentInstrumentType.PayPal:
                                PayPalPaymentForm.PaymentMethodId = selectedMethod.Id;
                                PayPalPaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                                PayPalPaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                                PayPalPaymentForm.Visible = true;
                                break;
                            case PaymentInstrumentType.Mail:
                                MailPaymentForm.PaymentMethodId = selectedMethod.Id;
                                MailPaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                                MailPaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                                MailPaymentForm.Visible = true;
                                break;
                            case PaymentInstrumentType.PhoneCall:
                                PhoneCallPaymentForm.PaymentMethodId = selectedMethod.Id;
                                PhoneCallPaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                                PhoneCallPaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                                PhoneCallPaymentForm.Visible = true;
                                break;
                            default:
                                //types not supported
                                break;
                        }
                    }
                }
            }
            else
            {
                ZeroValuePaymentForm.CheckingOut += new CheckingOutEventHandler(CheckingOut);
                ZeroValuePaymentForm.CheckedOut += new CheckedOutEventHandler(CheckedOut);
                ZeroValuePaymentForm.Visible = true;
            }

            //WE DO NOT NEED THE PAYMENT SELECTION LIST IF THERE IS NOT MORE THAN ONE
            //AVAILABLE TYPE OF PAYMENT
            tdPaymentMethodList.Visible = (PaymentMethodList.Items.Count > 1) && (orderTotal > 0);
        }

        void CheckedOut(object sender, CheckedOutEventArgs e)
        {
            CheckoutResponse response = e.CheckoutResponse;
            if (response.Success)
            {
                // STOP TRACKING THE ANONYMOUS USER
                Session["CreateOrder_AnonUserId"] = null;

                // CREATE / LINK USER ACCOUNT IF NEEDED
                if (RegisterPanel.Visible && CreateAccount.Checked)
                {
                    if (_ExistingUser == null)
                    {
                        // THERE IS NO EXISTING ACCOUNT, SO CREATE A NEW USER
                        string email = _User.PrimaryAddress.Email;
                        _User.UserName = email;
                        _User.Email = email;
                        _User.IsApproved = true;
                        _User.Save();
                        _User.SetPassword(Password.Text);
                        _User.Passwords[0].ForceExpiration = ForceExpiration.Checked;
                        _User.Save();
                    }
                    else
                    {
                        // THERE IS AN EXISTING USER, SO MIGRATE THIS ORDER
                        OrderDataSource.UpdateUser(_UserId, _ExistingUser.Id);
                        AddressDataSource.UpdateUser(_UserId, _ExistingUser.Id);
                    }
                }

                // REDIRECT TO THE FINAL ORDER
                Response.Redirect("~/Admin/Orders/ViewOrder.aspx?OrderNumber=" + response.Order.OrderNumber);
            }
            else
            {
                // SHOW ERRORS TO CUSTOMER
                WarningMessageList.DataSource = e.CheckoutResponse.WarningMessages;
                WarningMessageList.DataBind();
            }
        }

        void CheckingOut(object sender, CheckingOutEventArgs e)
        {
            //MAKE SURE WE HAVE VALIDATED THIS FORM
            Page.Validate("OPC");
            //IF ANYTHING WAS INVALID CANCEL CHECKOUT
            if (!Page.IsValid) e.Cancel = true;
            //MAKE SURE THE SHIPPING MESSAGE IS SET
            if (!e.Cancel)
            {
                int shipmentIndex = 0;
                foreach (RepeaterItem item in ShipmentList.Items)
                {
                    BasketShipment shipment = _Basket.Shipments[shipmentIndex];
                    TextBox shipMessage = (TextBox)item.FindControl("ShipMessage");
                    if (shipMessage != null)
                    {
                        shipment.ShipMessage = StringHelper.Truncate(shipMessage.Text, 200);
                        shipment.Save();
                    }
                    shipmentIndex++;
                }
            }
        }

        protected void CreateAccount_CheckedChanged(object sender, EventArgs e)
        {
            PasswordRequired.Enabled = CreateAccount.Checked;
        }
    }
}