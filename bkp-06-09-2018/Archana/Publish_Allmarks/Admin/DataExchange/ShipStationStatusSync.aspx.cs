using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.DataExchange;
using CommerceBuilder.Utility;
using System.IO;
using CommerceBuilder.Common;
using CommerceBuilder.Search;
using CommerceBuilder.Users;
using System.Web.Script.Serialization;
using CommerceBuilder.Orders;

namespace AbleCommerce.Admin.DataExchange
{
    public partial class ShipStationStatusSync : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        ShipStationExportManager _shipStationExportManager = null;

        protected void Page_Init(object sender, EventArgs e)
        {
            OrderGrid.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _shipStationExportManager = ShipStationExportManager.Instance;
            SyncButton.Visible = OrderGrid.Rows.Count > 0;
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            if (_shipStationExportManager.IsSyncing)
            {
                ProgressPanel.Visible = true;
                SyncButton.Visible = false;
            }
            else
            {
                Timer1.Enabled = false;
                ProgressPanel.Visible = false;
                ProgressPanel.Visible = false;
                SyncButton.Visible = true;
            }
        }

        protected string GetOrderStatus(Object orderStatusId)
        {
            OrderStatus status = OrderStatusDataSource.Load((int)orderStatusId);
            if (status != null) return status.Name;
            return string.Empty;
        }

        protected string GetPaymentStatus(object dataItem)
        {
            Order order = (Order)dataItem;
            if (order.PaymentStatus == OrderPaymentStatus.Paid) return "Paid";
            if (order.Payments.Count > 0)
            {
                order.Payments.Sort("PaymentDate");
                var lastPayment = order.Payments[order.Payments.Count - 1];
                return StringHelper.SpaceName(lastPayment.PaymentStatus.ToString());
            }
            return order.PaymentStatus.ToString();
        }

        protected void SyncButton_Click(object sender, EventArgs e)
        {
            _shipStationExportManager.SyncStatuses();
            Timer1.Enabled = true;
            SyncButton.Visible = false;
            ProgressPanel.Visible = true;
            OrderGrid.DataBind();
        }
    }
}