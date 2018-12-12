namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;

    public partial class ViewGiftCertificate : CommerceBuilder.UI.AbleCommerceAdminPage
    {

        private int _GiftCertificateId;
        private GiftCertificate _GiftCertificate;

        protected void Page_Init(object sender, EventArgs e)
        {
            _GiftCertificateId = AlwaysConvert.ToInt(Request.QueryString["GiftCertificateId"]);
            _GiftCertificate = GiftCertificateDataSource.Load(_GiftCertificateId);
            if (_GiftCertificate == null) Response.Redirect("Default.aspx");
            if (!Page.IsPostBack)
            {
                //UPDATE CAPTION
                Caption.Text = String.Format(Caption.Text, _GiftCertificate.Name, _GiftCertificate.OrderItem.Order.Id);
                BindGiftCertificate();
            }
        }

        protected void BindGiftCertificate()
        {
            Name.Text = _GiftCertificate.Name;

            if (string.IsNullOrEmpty(_GiftCertificate.SerialNumber))
            {
                Serial.Text = "Not Assigned Yet.";
            }
            else
            {
                Serial.Text = _GiftCertificate.SerialNumber;
            }

            Balance.Text = _GiftCertificate.Balance.LSCurrencyFormat("lc");

            // SHOW LAST DESCRIPTION
            if (_GiftCertificate.Transactions != null && _GiftCertificate.Transactions.Count > 0)
            {
                GiftCertificateTransaction gct = _GiftCertificate.Transactions[_GiftCertificate.Transactions.Count - 1];
                Description.Text = gct.Description + " (Modified at " + gct.TransactionDate.ToString() + ")";
            }

            if (_GiftCertificate.IsExpired())
            {
                Expires.Text = "Already expired at " + _GiftCertificate.ExpirationDate.ToString();
            }
            else if (_GiftCertificate.ExpirationDate == null || _GiftCertificate.ExpirationDate.Equals(DateTime.MinValue))
            {
                Expires.Text = "N/A";
            }
            else
            {
                Expires.Text = _GiftCertificate.ExpirationDate.ToString();
            }
        }
    }
}