namespace AbleCommerce.Admin.Orders.Payments
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;

    public partial class EditPayment : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _PaymentId;
        private Payment _Payment;

        protected void Page_Load(object sender, EventArgs e)
        {
            _PaymentId = AlwaysConvert.ToInt(Request.QueryString["PaymentId"]);
            _Payment = PaymentDataSource.Load(_PaymentId);
            if (_Payment == null) Response.Redirect("../Default.aspx");
            if (!Page.IsPostBack)
            {
                PaymentMethod paymentMethod = _Payment.PaymentMethod;
                if ((paymentMethod != null) && (paymentMethod.IsCreditOrDebitCard() || paymentMethod.PaymentInstrumentType == PaymentInstrumentType.PayPal))
                {
                    foreach (PaymentStatus s in Enum.GetValues(typeof(PaymentStatus)))
                    {
                        ListItem item = new ListItem(StringHelper.SpaceName(s.ToString()), ((int)s).ToString());
                        if (s == _Payment.PaymentStatus) item.Selected = true;
                        CurrentPaymentStatus.Items.Add(item);
                    }
                }
                else
                {
                    ListItem item = new ListItem(StringHelper.SpaceName(PaymentStatus.Unprocessed.ToString()), ((int)PaymentStatus.Unprocessed).ToString());
                    if (PaymentStatus.Unprocessed == _Payment.PaymentStatus) item.Selected = true;
                    CurrentPaymentStatus.Items.Add(item);

                    item = new ListItem(StringHelper.SpaceName(PaymentStatus.Completed.ToString()), ((int)PaymentStatus.Completed).ToString());
                    if (PaymentStatus.Completed == _Payment.PaymentStatus) item.Selected = true;
                    CurrentPaymentStatus.Items.Add(item);

                    item = new ListItem(StringHelper.SpaceName(PaymentStatus.Void.ToString()), ((int)PaymentStatus.Void).ToString());
                    if (PaymentStatus.Void == _Payment.PaymentStatus) item.Selected = true;
                    CurrentPaymentStatus.Items.Add(item);
                }
                PaymentDate.Text = string.Format("{0:g}", _Payment.PaymentDate);
                Amount.Text = string.Format("{0:F2}", _Payment.Amount);
                PaymentMethod.Text = _Payment.PaymentMethodName;
                Caption.Text = string.Format(Caption.Text, _Payment.PaymentMethodName, _Payment.ReferenceNumber);
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            int orderNumber = OrderDataSource.LookupOrderNumber(_Payment.OrderId);
            Response.Redirect("Default.aspx?OrderNumber=" + orderNumber.ToString());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            AbleContext.Current.Database.BeginTransaction();
            _Payment.PaymentStatus = (PaymentStatus)(AlwaysConvert.ToInt(CurrentPaymentStatus.SelectedValue));
            _Payment.Save(true);
            AbleContext.Current.Database.CommitTransaction();
            int orderNumber = OrderDataSource.LookupOrderNumber(_Payment.OrderId);
            Response.Redirect("Default.aspx?OrderNumber=" + orderNumber.ToString());
        }
    }
}