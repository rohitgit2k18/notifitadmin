namespace AbleCommerce.Admin.Orders.Payments
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;

    public partial class ucProcessPayment : System.Web.UI.UserControl
    {
        private int _OrderId = 0;
        private CommerceBuilder.Orders.Order _Order;

        IList<PaymentMethod> _OnlinePaymentMethods;
        private void InitOnlinePaymentMethods()
        {
            ICriteria criteria = NHibernateHelper.CreateCriteria<PaymentMethod>();
            criteria.Add(Restrictions.Not(Restrictions.Eq("PaymentInstrumentId", (short)PaymentInstrumentType.GiftCertificate)));
            criteria.Add(Restrictions.Not(Restrictions.Eq("PaymentInstrumentId", (short)PaymentInstrumentType.GoogleCheckout)));
            IList<PaymentMethod> allMethods = PaymentMethodDataSource.LoadForCriteria(criteria);
            _OnlinePaymentMethods = new List<PaymentMethod>();
            foreach (PaymentMethod m in allMethods)
            {
                if ((m.PaymentGateway != null) && (m.PaymentInstrumentType != PaymentInstrumentType.PayPal)) _OnlinePaymentMethods.Add(m);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            _OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(_OrderId);
            InitOnlinePaymentMethods();
            SelectedPaymentMethod.DataSource = _OnlinePaymentMethods;
            SelectedPaymentMethod.DataBind();
            if (!Page.IsPostBack)
            {
                BindPaymentMethod();
                CancelLink.NavigateUrl += "?OrderNumber=" + _Order.OrderNumber.ToString();
            }
        }

        protected PaymentMethod GetSelectedMethod()
        {
            int paymentMethodId = AlwaysConvert.ToInt(SelectedPaymentMethod.SelectedValue);
            foreach (PaymentMethod method in _OnlinePaymentMethods)
            {
                if (method.Id == paymentMethodId) return method;
            }
            return null;
        }

        protected void PopulateExpiration()
        {
            ExpirationYear.Items.Clear();
            int thisYear = DateTime.UtcNow.Year;
            for (int i = 0; (i <= 10); i++)
            {
                ExpirationYear.Items.Add(new ListItem((thisYear + i).ToString()));
            }
            //POPULATE START DATE DROPDOWN
            StartDateYear.Items.Clear();
            for (int i = 2000; (i <= thisYear); i++)
            {
                StartDateYear.Items.Add(new ListItem(i.ToString()));
            }
        }

        protected void ShowCheckForm()
        {
            CheckPanel.Visible = true;
            CheckPaymentAmount.Text = string.Format("{0:F2}", _Order.GetBalance(true));
            SaveButton.Visible = true;
            SaveButton.ValidationGroup = "Check";
        }

        private void ShowCreditCardForm(string paymentMethodName, int securityCodeLength, bool isIntlCard)
        {
            CreditCardPanel.Visible = true;
            SecurityCode.MaxLength = securityCodeLength;
            PopulateExpiration();
            CreditCardPaymentAmount.Text = string.Format("{0:F2}", _Order.GetBalance(true));
            CardName.Text = _Order.BillToFirstName + " " + _Order.BillToLastName;
            IntlCVVMessage.Visible = isIntlCard;
            trIssueNumber.Visible = isIntlCard;
            trStartDate.Visible = isIntlCard;
            SecurityCodeValidator.Enabled = !isIntlCard;
            SaveButton.Visible = true;
            SaveButton.ValidationGroup = "CreditCard";
        }

        private void BindPaymentMethod()
        {
            CheckPanel.Visible = false;
            CreditCardPanel.Visible = false;
            SaveButton.Visible = false;
            PaymentMethod method = GetSelectedMethod();
            if (method != null)
            {
                switch (method.PaymentInstrumentType)
                {
                    case PaymentInstrumentType.AmericanExpress:
                        ShowCreditCardForm(method.Name, 4, false);
                        break;
                    case PaymentInstrumentType.Discover:
                    case PaymentInstrumentType.JCB:
                    case PaymentInstrumentType.MasterCard:
                    case PaymentInstrumentType.Visa:
                    case PaymentInstrumentType.Maestro:
                    case PaymentInstrumentType.SwitchSolo:
                    case PaymentInstrumentType.VisaDebit:
                        ShowCreditCardForm(method.Name, 3, method.IsIntlDebitCard());
                        break;
                    case PaymentInstrumentType.Check:
                        ShowCheckForm();
                        break;
                }
            }
        }

        protected void SelectedPaymentMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindPaymentMethod();
        }

        private bool CustomValidation()
        {
            //if isssue number is visible, we must validate additional rules
            if (trIssueNumber.Visible)
            {
                //INTERNATIONAL DEBIT CARD, ISSUE NUMBER OR START DATE REQUIRED
                bool invalidIssueNumber = (!Regex.IsMatch(IssueNumber.Text, "\\d{1,2}"));
                bool invalidStartDate = ((StartDateMonth.SelectedIndex == 0) || (StartDateYear.SelectedIndex == 0));
                if (invalidIssueNumber && invalidStartDate)
                {
                    IntlDebitValidator1.IsValid = false;
                    IntlDebitValidator2.IsValid = false;
                    return false;
                }
            }
            return true;
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && CustomValidation())
            {
                PaymentMethod method = GetSelectedMethod();
                if (method != null)
                {
                    Payment payment = new Payment();
                    payment.Order = _Order;
                    payment.PaymentMethodId = method.Id;
                    AccountDataDictionary paymentInstrumentBuilder = new AccountDataDictionary();
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
                            paymentInstrumentBuilder["AccountName"] = CardName.Text;
                            paymentInstrumentBuilder["AccountNumber"] = CardNumber.Text;
                            paymentInstrumentBuilder["ExpirationMonth"] = ExpirationMonth.SelectedItem.Value;
                            paymentInstrumentBuilder["ExpirationYear"] = ExpirationYear.SelectedItem.Value;
                            paymentInstrumentBuilder["SecurityCode"] = SecurityCode.Text;
                            if (IssueNumber.Text.Length > 0) paymentInstrumentBuilder["IssueNumber"] = IssueNumber.Text;
                            if ((StartDateMonth.SelectedIndex > 0) && (StartDateYear.SelectedIndex > 0))
                            {
                                paymentInstrumentBuilder["StartDateMonth"] = StartDateMonth.SelectedItem.Value;
                                paymentInstrumentBuilder["StartDateYear"] = StartDateYear.SelectedItem.Value;
                            }
                            payment.ReferenceNumber = StringHelper.MakeReferenceNumber(CardNumber.Text);
                            payment.Amount = AlwaysConvert.ToDecimal(CreditCardPaymentAmount.Text);
                            break;
                        case PaymentInstrumentType.Check:
                            paymentInstrumentBuilder["RoutingNumber"] = RoutingNumber.Text;
                            paymentInstrumentBuilder["BankName"] = BankName.Text;
                            paymentInstrumentBuilder["AccountHolder"] = AccountHolder.Text;
                            paymentInstrumentBuilder["AccountNumber"] = BankAccountNumber.Text;
                            payment.ReferenceNumber = StringHelper.MakeReferenceNumber(BankAccountNumber.Text);
                            payment.Amount = AlwaysConvert.ToDecimal(CheckPaymentAmount.Text);
                            break;
                    }
                    if (payment.Amount > 0)
                    {
                        //ADD IN PAYMENT INSTRUMENT DATA FOR PROCESSING
                        payment.AccountData = paymentInstrumentBuilder.ToString();
                        payment.Authorize(false);
                        //REDIRECT TO PAYMENT PAGE
                        Response.Redirect("Default.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
                    }
                }
            }
        }

        private void DisableAutoComplete()
        {
            CardNumber.Attributes.Add("autocomplete", "off");
            SecurityCode.Attributes.Add("autocomplete", "off");
            IssueNumber.Attributes.Add("autocomplete", "off");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            DisableAutoComplete();
        }
    }
}