namespace AbleCommerce.Admin.Orders.Payments
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;

    public partial class ucRecordPayment : System.Web.UI.UserControl
    {
        private int _OrderId = 0;
        private CommerceBuilder.Orders.Order _Order;

        protected CommerceBuilder.Orders.Order Order
        {
            get
            {
                if (_Order == null)
                {
                    _Order = OrderDataSource.Load(this.OrderId);
                }
                return _Order;
            }
        }

        protected int OrderId
        {
            get
            {
                if (_OrderId.Equals(0))
                {
                    _OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
                }
                return _OrderId;
            }
        }

        IList<PaymentMethod> methods;

        protected void Page_Load(object sender, EventArgs e)
        {
            ICriteria criteria = NHibernateHelper.CreateCriteria<PaymentMethod>();
            criteria.Add(Restrictions.Not(Restrictions.Eq("PaymentInstrumentId", (short)PaymentInstrumentType.GiftCertificate)));
            criteria.Add(Restrictions.Not(Restrictions.Eq("PaymentInstrumentId", (short)PaymentInstrumentType.GoogleCheckout)));

            methods = PaymentMethodDataSource.LoadForCriteria(criteria);

            if (!Page.IsPostBack)
            {
                CancelLink.NavigateUrl += "?OrderNumber=" + Order.OrderNumber.ToString();
                SelectedPaymentMethod.DataSource = methods;
                SelectedPaymentMethod.DataBind();
                Amount.Text = string.Format("{0:F2}", Order.GetBalance(true));
                //LOAD PAYMENT STATUSES
                foreach (PaymentStatus status in Enum.GetValues(typeof(PaymentStatus)))
                {
                    selPaymentStatus.Items.Add(new ListItem(status.ToString(), ((int)status).ToString()));
                }

                //ListItem completed = selPaymentStatus.Items.FindByValue(((int)PaymentStatus.Captured).ToString());
                //if (completed != null) completed.Selected = true;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            AbleContext.Current.Database.BeginTransaction();
            Payment payment = new Payment();
            payment.OrderId = OrderId;
            payment.PaymentMethodId = AlwaysConvert.ToInt(SelectedPaymentMethod.SelectedValue);
            payment.ReferenceNumber = ReferenceNumber.Text;
            payment.Amount = AlwaysConvert.ToDecimal(Amount.Text);
            payment.CurrencyCode = "USD";
            payment.PaymentStatusId = AlwaysConvert.ToInt16(selPaymentStatus.SelectedValue);
            payment.PaymentStatusReason = PaymentStatusReason.Text;
            Order.Payments.Add(payment);
            string addNote = string.Format("A payment of type {0} and amount {1:c} is recorded as {2}.", payment.PaymentMethodName, payment.Amount, payment.PaymentStatus);
            Order.Notes.Add(new OrderNote(Order.Id, AbleContext.Current.UserId, LocaleHelper.LocalNow, addNote, NoteType.SystemPrivate));
            Order.Save(true, true);
            AbleContext.Current.Database.CommitTransaction();
            Response.Redirect(CancelLink.NavigateUrl);
        }

        protected PaymentMethod GetSelectedMethod()
        {
            int paymentMethodId = AlwaysConvert.ToInt(SelectedPaymentMethod.SelectedValue);
            if (methods != null)
            {
                foreach (PaymentMethod method in methods)
                {
                    if (method.Id == paymentMethodId) return method;
                }
            }
            return null;
        }

        protected void SelectedPaymentMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            PaymentMethod method = GetSelectedMethod();
            if (method != null)
            {
                selPaymentStatus.Items.Clear();
                if (method.IsCreditOrDebitCard())
                {
                    foreach (PaymentStatus s in Enum.GetValues(typeof(PaymentStatus)))
                    {
                        ListItem item = new ListItem(StringHelper.SpaceName(s.ToString()), ((int)s).ToString());
                        selPaymentStatus.Items.Add(item);
                    }
                }
                else
                {
                    ListItem item = new ListItem(StringHelper.SpaceName(PaymentStatus.Unprocessed.ToString()), ((int)PaymentStatus.Unprocessed).ToString());
                    selPaymentStatus.Items.Add(item);

                    item = new ListItem(StringHelper.SpaceName(PaymentStatus.Completed.ToString()), ((int)PaymentStatus.Completed).ToString());
                    selPaymentStatus.Items.Add(item);
                }
            }
        }
    }
}