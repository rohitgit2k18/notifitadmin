namespace AbleCommerce.Admin.Orders.Payments
{
    using System;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Payments.Providers;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId;
        private Order _Order;

        protected void Page_Init(object sender, EventArgs e)
        {
            _OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(_OrderId);
            if (_Order == null) Response.Redirect("../Default.aspx");
            Caption.Text = string.Format(Caption.Text, _Order.OrderNumber);
            AddPaymentLink.NavigateUrl += "?OrderNumber=" + _Order.OrderNumber.ToString();
            BindPayments();
        }

        protected string AppendOrderId(string url)
        {
            if (string.IsNullOrEmpty(url))
            {
                return "";
            }
            url = url + "?OrderNumber=" + _Order.OrderNumber.ToString();
            return url;
        }

        protected void BindPayments()
        {
            PaymentRepeater.DataSource = _Order.Payments;
            PaymentRepeater.DataBind();
        }

        protected void BuildTaskMenu(PlaceHolder phPaymentAction, Payment payment)
        {
            phPaymentAction.Controls.Clear();

            if (ShowButton("Received", payment)) phPaymentAction.Controls.Add(CreateActionButton("RecievedButton", "Mark as Received", "RECEIVED", payment.Id.ToString()));
            if (ShowButton("Authorize", payment)) phPaymentAction.Controls.Add(CreateActionButton("AuthorizeButton", "Authorize Payment", "AUTHORIZE", payment.Id.ToString()));
            if (ShowButton("RetryAuth", payment)) phPaymentAction.Controls.Add(CreateActionButton("RetryAuthButton", "Retry Authorization", "RETRY", payment.Id.ToString()));
            if (ShowButton("RetryCapture", payment)) phPaymentAction.Controls.Add(CreateActionButton("RetryCapture", "Retry Capture", "RETRY", payment.Id.ToString()));
            if (ShowButton("Capture", payment)) phPaymentAction.Controls.Add(CreateActionButton("CaptureButton", "Capture Payment", "CAPTURE", payment.Id.ToString()));
            if (ShowButton("Void", payment))
                if ((payment.PaymentMethod != null && (payment.PaymentMethod.IsCreditOrDebitCard() || payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.PayPal))
                    && payment.PaymentStatus != PaymentStatus.Unprocessed)
                    phPaymentAction.Controls.Add(CreateActionButton("VoidButton", "Void Authorization", "VOID", payment.Id.ToString()));
                else
                    phPaymentAction.Controls.Add(CreateActionButton("VoidButton", "Void Payment", "VOID", payment.Id.ToString()));
            if (ShowButton("Refund", payment)) phPaymentAction.Controls.Add(CreateActionButton("RefundButton", "Issue Refund", "REFUND", payment.Id.ToString()));
            phPaymentAction.Controls.Add(CreateActionButton("EditButton", "Edit Payment", "EDIT", payment.Id.ToString()));
            Button deleteButton = CreateActionButton("Delete", "Delete Payment", "DELETE", payment.Id.ToString());
            deleteButton.OnClientClick = "return confirm('This option will delete the payment and all transaction information, Are you sure you want to delete payments?');";
            phPaymentAction.Controls.Add(deleteButton);
        }

        protected Button CreateActionButton(string id, string text, string command, string commandArgument)
        {
            Button button = new Button();
            button.ID = id;
            button.Text = text;
            button.CommandName = "Do_" + command;
            button.CommandArgument = commandArgument;            
            return button;
        }

        public string GetSkinAVS(string code)
        {
            return string.Empty;
        }

        public string GetSkinCVV(string code)
        {
            return string.Empty;
        }

        protected void PaymentRepeater_ItemDataBound(object source, RepeaterItemEventArgs e)
        {
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                PlaceHolder taskMenu = (PlaceHolder)e.Item.FindControl("phPaymentAction");
                if (taskMenu != null) BuildTaskMenu(taskMenu, (Payment)e.Item.DataItem);
            }
        }

        protected void PaymentRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName.StartsWith("Do_"))
            {
                int paymentId = AlwaysConvert.ToInt(e.CommandArgument);
                int index = _Order.Payments.IndexOf(paymentId);
                if (index > -1)
                {
                    Payment payment = _Order.Payments[index];

                    string whichCommand = e.CommandName.Substring(3);

                    //TAKE ACTION BASED ON COMMAND
                    if (!string.IsNullOrEmpty(whichCommand))
                    {
                        whichCommand = whichCommand.ToUpperInvariant();
                        switch (whichCommand)
                        {
                            case "RETRY":
                                //IF THIS WAS A FAILED CAPTURE, RESET PAYMENT STATUS TO AUTHORIZED AND REDIRECT TO CAPTURE PAGE
                                if (payment.PaymentStatus == PaymentStatus.CaptureFailed)
                                {
                                    payment.UpdateStatus(PaymentStatus.Authorized);
                                    Response.Redirect("CapturePayment.aspx?PaymentId=" + payment.Id.ToString());
                                }
                                //THIS WAS A FAILED AUTHORIZATION, SHOW THE RETRY PANEL
                                Panel retryPanel = (Panel)AbleCommerce.Code.PageHelper.RecursiveFindControl(e.Item, "RetryPanel");
                                retryPanel.Visible = true;
                                break;
                            case "SUBMITRETRY":
                                TextBox securityCode = (TextBox)AbleCommerce.Code.PageHelper.RecursiveFindControl(e.Item, "RetrySecurityCode");
                                if (!string.IsNullOrEmpty(securityCode.Text))
                                {
                                    AccountDataDictionary accountData = new AccountDataDictionary(payment.AccountData);
                                    accountData["SecurityCode"] = securityCode.Text;
                                    payment.AccountData = accountData.ToString();
                                }
                                payment.PaymentStatus = CommerceBuilder.Payments.PaymentStatus.Unprocessed;
                                payment.Authorize(false);
                                BindPayments();
                                break;
                            case "CANCELRETRY":
                                //NO ACTION REQUIRED, THE REBIND STEP WILL HIDE THE RETRY PANEL
                                BindPayments();
                                break;
                            case "EDIT":
                                Response.Redirect("EditPayment.aspx?PaymentId=" + payment.Id.ToString());
                                break;
                            case "CAPTURE":
                                //REDIRECT TO CAPTURE FORM
                                Response.Redirect("CapturePayment.aspx?PaymentId=" + payment.Id.ToString());
                                break;
                            case "DELETE":
                                string deleteNote = string.Format("A payment of type {0} and amount {1:c} is deleted.", payment.PaymentMethodName, payment.Amount);
                                _Order.Payments.DeleteAt(index);
                                _Order.Notes.Add(new OrderNote(_Order.Id, AbleContext.Current.UserId, LocaleHelper.LocalNow, deleteNote, NoteType.SystemPrivate));
                                _Order.Notes.Save();
                                BindPayments();
                                break;
                            case "AUTHORIZE":
                                payment.Authorize();
                                BindPayments();
                                break;
                            case "RECEIVED":
                                AbleContext.Current.Database.BeginTransaction();
                                payment.PaymentStatus = PaymentStatus.Completed;
                                payment.Save(true);
                                AbleContext.Current.Database.CommitTransaction();
                                BindPayments();
                                break;
                            case "REFUND":
                                Response.Redirect("RefundPayment.aspx?PaymentId=" + payment.Id.ToString() + "&OrderNumber=" + _Order.OrderNumber);
                                break;
                            case "VOID":
                                Response.Redirect("VoidPayment.aspx?PaymentId=" + payment.Id.ToString() + "&OrderNumber=" + _Order.OrderNumber);
                                break;
                            default:
                                throw new ArgumentException("Unrecognized command: " + whichCommand);
                        }
                    }
                }
            }
        }

        public bool ShowButton(string buttonName, object dataItem)
        {
            Payment payment = (Payment)dataItem;
            PaymentMethod method = payment.PaymentMethod;
            PaymentGateway gateway = method == null ? null : method.PaymentGateway;
            IPaymentProvider provider = null;
            
            if (gateway != null)
                provider = gateway.GetInstance();

            SupportedTransactions supportedTransactions = SupportedTransactions.None ;
            if (provider != null)
                supportedTransactions = provider.SupportedTransactions;
            
            switch (buttonName.ToUpperInvariant())
            {
                case "RETRYAUTH":
                    if (provider != null)
                    {
                        if (!(((supportedTransactions & SupportedTransactions.Authorize) == SupportedTransactions.Authorize) || ((supportedTransactions & SupportedTransactions.AuthorizeCapture) == SupportedTransactions.AuthorizeCapture))) return false;
                    }

                    // DISABLE FOR PHONE CALL PAYMENT METHOD
                    if (payment.PaymentMethod != null && payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.PhoneCall) return false;
                    return (payment.PaymentStatus == PaymentStatus.AuthorizationFailed);
                case "RETRYCAPTURE":
                    if (provider != null)
                    {
                        if (!(((supportedTransactions & SupportedTransactions.Authorize) == SupportedTransactions.Authorize) || ((supportedTransactions & SupportedTransactions.AuthorizeCapture) == SupportedTransactions.AuthorizeCapture))) return false;
                    }

                    // DISABLE FOR PHONE CALL PAYMENT METHOD
                    if (payment.PaymentMethod != null && payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.PhoneCall) return false;
                    return (payment.PaymentStatus == PaymentStatus.CaptureFailed);
                case "RECEIVED":
                    return (payment.PaymentStatus == PaymentStatus.Unprocessed);
                case "AUTHORIZE":
                    if (provider != null)
                    {
                        if (!(((supportedTransactions & SupportedTransactions.Authorize) == SupportedTransactions.Authorize) || ((supportedTransactions & SupportedTransactions.AuthorizeCapture) == SupportedTransactions.AuthorizeCapture))) return false;
                    }

                    // DISABLE FOR PHONE CALL PAYMENT METHOD
                    if (payment.PaymentMethod != null && payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.PhoneCall) return false;
                    return (payment.PaymentStatus == PaymentStatus.Unprocessed);
                case "VOID":
                    if (provider != null)
                    {
                        if (!((supportedTransactions & SupportedTransactions.Void) == SupportedTransactions.Void)) return false;
                    }

                    //Disable Void for Google Checkout AND PHONE CALL PAYMENT METHOD
                    if (payment.PaymentMethod != null && (payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.GoogleCheckout || payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.PhoneCall))
                    {
                        return false;
                    }
                    else
                    {
                        //VOID SHOULD ONLY BE SHOWN IF THE PAYMENT IS UNPROCESSED OR IN AN AUTHORIZED STATE
                        return (payment.PaymentStatus == PaymentStatus.Unprocessed
                               || payment.PaymentStatus == PaymentStatus.AuthorizationFailed
                               || payment.PaymentStatus == PaymentStatus.Authorized
                               || payment.PaymentStatus == PaymentStatus.CaptureFailed);
                    }
                case "CAPTURE":
                    if (provider != null)
                    {
                        if (!(((supportedTransactions & SupportedTransactions.Capture) == SupportedTransactions.Capture) || ((supportedTransactions & SupportedTransactions.AuthorizeCapture) == SupportedTransactions.AuthorizeCapture))) return false;
                    }

                    // DISABLE FOR PHONE CALL PAYMENT METHOD
                    if (payment.PaymentMethod != null && payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.PhoneCall) return false;
                    return (payment.PaymentStatus == PaymentStatus.Authorized);
                case "CANCEL":
                    // DISABLE FOR PHONE CALL PAYMENT METHOD
                    if (payment.PaymentMethod != null && payment.PaymentMethod.PaymentInstrumentType == PaymentInstrumentType.PhoneCall) return false;
                    return (payment.PaymentStatus == PaymentStatus.Completed);
                case "REFUND":
                    if (provider != null)
                    {
                        if (!((supportedTransactions & SupportedTransactions.Refund) == SupportedTransactions.Refund)) return false;
                    }

                    //SHOW REFUND IF THE PAYMENT WAS MADE WITHIN 60 DAYS
                    //AND THE PAYMENT IS CAPTURED
                    //AND THERE IS IS A POSTIVE TRANSACTION CAPTURE AMOUNT
                    return ((payment.PaymentDate > DateTime.UtcNow.AddDays(-60))
                           && (payment.PaymentStatus == PaymentStatus.Captured)
                           && (payment.Transactions.GetTotalCaptured() > 0));
                case "DELETE":
                    //BY DEFAULT DO NOT SHOW THE DELETE BUTTON
                    return false;
                default:
                    throw new ArgumentException("Invalid button name: '" + buttonName, buttonName);
            }
        }

        public bool ShowTransactionElement(string elementName, object dataItem)
        {
            Transaction transaction = (Transaction)dataItem;
            switch (elementName.ToUpperInvariant())
            {
                case "AVSCVV":
                    return (transaction.TransactionType == TransactionType.Authorize || transaction.TransactionType == TransactionType.AuthorizeCapture || transaction.TransactionType == TransactionType.AuthorizeRecurring);
                default:
                    throw new ArgumentException("Invalid element name: '" + elementName, elementName);
            }
        }

        protected bool isSuccessfulTransaction(Object obj)
        {
            if (obj is TransactionStatus)
            {
                return ((TransactionStatus)obj) == TransactionStatus.Successful;
            }
            return false;
        }

        protected bool isFailedTransaction(Object obj)
        {
            if (obj is TransactionStatus)
            {
                return ((TransactionStatus)obj) == TransactionStatus.Failed;
            }
            return false;
        }

        protected bool isPendingTransaction(Object obj)
        {
            if (obj is TransactionStatus)
            {
                return ((TransactionStatus)obj) == TransactionStatus.Pending;
            }
            return false;
        }

        protected string GetCvv(object dataItem)
        {
            Transaction transaction = (Transaction)dataItem;
            return AbleCommerce.Code.StoreDataHelper.TranslateCVVCode(transaction.CVVResultCode) + " (" + transaction.CVVResultCode + ")";
        }

        protected string GetAvs(object dataItem)
        {
            Transaction transaction = (Transaction)dataItem;
            return AbleCommerce.Code.StoreDataHelper.TranslateAVSCode(transaction.AVSResultCode) + " (" + transaction.AVSResultCode + ")";
        }
    }
}