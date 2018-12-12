namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    public partial class ViewGiftCertificates : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Order _Order;

        protected void Page_Load(object sender, EventArgs e)
        {
            int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(orderId);
            if (_Order == null) Response.Redirect("Default.aspx");

            if (!Page.IsPostBack)
            {
                BindGiftCertificatesGrid();
            }
        }

        protected void BindGiftCertificatesGrid()
        {
            GiftCertificatesGrid.DataSource = GetGiftCertificates();
            GiftCertificatesGrid.DataBind();
        }

        protected IList<GiftCertificate> GetGiftCertificates()
        {
            IList<GiftCertificate> gcCol;
            gcCol = new List<GiftCertificate>();
            foreach (OrderItem orderItem in _Order.Items)
            {
                gcCol.AddRange(orderItem.GiftCertificates);
            }
            return gcCol;
        }

        protected GiftCertificate FindGiftCertificate(int GiftCertificateId)
        {
            GiftCertificate gc = null;
            foreach (OrderItem orderItem in _Order.Items)
            {
                gc = FindGiftCertificate(orderItem, GiftCertificateId);
                if (gc != null) break;
            }
            return gc;
        }

        protected GiftCertificate FindGiftCertificate(OrderItem orderItem, int GiftCertificateId)
        {
            foreach (GiftCertificate gc in orderItem.GiftCertificates)
            {
                if (gc.Id == GiftCertificateId)
                {
                    return gc;
                }
            }
            return null;
        }

        protected void GiftCertificatesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = AlwaysConvert.ToInt(e.CommandArgument);
            int GiftCertificateId = AlwaysConvert.ToInt(GiftCertificatesGrid.DataKeys[index].Value);
            GiftCertificate gc = FindGiftCertificate(GiftCertificateId);

            if (gc == null) return;

            IGiftCertKeyProvider provider = AbleContext.Container.Resolve<IGiftCertKeyProvider>();
            GiftCertificateTransaction trans;

            if (e.CommandName.Equals("Activate"))
            {
                gc.SerialNumber = provider.GenerateGiftCertificateKey();
                trans = new GiftCertificateTransaction();
                trans.GiftCertificate = gc;
                trans.Amount = gc.Balance;
                trans.Description = "Gift certificate activated.";
                trans.OrderId = _Order.Id;
                trans.TransactionDate = LocaleHelper.LocalNow;
                gc.Transactions.Add(trans);
                gc.Save();
                // Trigger Gift Certificate Activated / Validate Event
                StoreEventEngine.GiftCertificateValidated(gc, trans);
                BindGiftCertificatesGrid();
            }
            else if (e.CommandName.Equals("Deactivate"))
            {
                gc.SerialNumber = "";
                trans = new GiftCertificateTransaction();
                trans.GiftCertificate = gc;
                trans.Amount = gc.Balance;
                trans.Description = "Gift certificate deactivated.";
                trans.OrderId = _Order.Id;
                trans.TransactionDate = LocaleHelper.LocalNow;
                gc.Transactions.Add(trans);
                gc.Save();
                BindGiftCertificatesGrid();
            }
        }

        protected void GiftCertificatesGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int GiftCertificateId = (int)GiftCertificatesGrid.DataKeys[GiftCertificatesGrid.Rows[e.RowIndex].DataItemIndex].Value;
            DeleteGiftCertificate(GiftCertificateId);
            BindGiftCertificatesGrid();
        }

        protected void DeleteGiftCertificate(int GiftCertificateId)
        {
            GiftCertificate gc = null;
            foreach (OrderItem orderItem in _Order.Items)
            {
                gc = FindGiftCertificate(orderItem, GiftCertificateId);
                if (gc != null)
                {
                    orderItem.GiftCertificates.Remove(gc);
                    gc.Delete();
                    return;
                }
            }
        }

        protected bool HasSerialKey(object obj)
        {
            GiftCertificate oigc = (GiftCertificate)obj;
            return oigc.SerialNumber != null && oigc.SerialNumber.Length > 0;
        }

        protected OrderItem FindOrderItem(int orderItemId)
        {
            foreach (OrderItem orderItem in _Order.Items)
            {
                if (orderItem.Id == orderItemId) return orderItem;
            }
            return null;
        }

        protected string GetEditUrl(object obj)
        {
            GiftCertificate gc = (GiftCertificate)obj;
            return string.Format("~/Admin/Payment/EditGiftCertificate.aspx?GiftCertificateId={0}&OrderNumber={1}", gc.Id, _Order.OrderNumber);
        }
    }
}