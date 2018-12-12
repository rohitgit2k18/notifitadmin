using System;
using System.Collections.Generic;
using CommerceBuilder.Orders;
using CommerceBuilder.Payments;

namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class OrderGiftCertificates : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                IList<GiftCertificate> giftCertificateCollection = GetGiftCertificates(this.Order);
                if (giftCertificateCollection.Count > 0)
                {
                    GiftCertificatesPanel.Visible = true;
                    GiftCertificatesGrid.DataSource = giftCertificateCollection;
                    GiftCertificatesGrid.DataBind();
                }
            }
        }

        private IList<GiftCertificate> GetGiftCertificates(Order order)
        {

            IList<GiftCertificate> gcList = new List<GiftCertificate>();
            foreach (OrderItem orderItem in order.Items)
            {
                foreach (GiftCertificate gc in orderItem.GiftCertificates)
                {
                    if (gc != null) gcList.Add(gc);
                }
            }
            return gcList;
        }

        protected String GetGCDescription(object dataItem)
        {
            GiftCertificate gc = (GiftCertificate)dataItem;
            if (gc.Transactions.Count == 0) return String.Empty;
            return gc.Transactions[gc.Transactions.Count - 1].Description;
        }
    }
}