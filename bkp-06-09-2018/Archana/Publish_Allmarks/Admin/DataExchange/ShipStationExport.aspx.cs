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
    public partial class ShipStationExport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        ShipStationExportManager _shipStationExportManager = null;

        protected void Page_Init(object sender, EventArgs e)
        {
            BindOrderStatuses();
            ShipStationWizard.StartNextButtonText = "Search";
            ShipStationWizard.FinishPreviousButtonText = "New Search";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _shipStationExportManager = ShipStationExportManager.Instance;
        }

        protected void OrderDs_Selecting(object sender, System.Web.UI.WebControls.ObjectDataSourceSelectingEventArgs e)
        {
            // ADD IN THE SEARCH CRITERIA
            ShipStationExportOptions options = GetExportOptions();
            e.InputParameters["exportOptions"] = options;
        }

        protected void ShipStationWizard_NextButtonClick(object sender, WizardNavigationEventArgs e)
        {
            switch (e.NextStepIndex)
            {
                case 1:
                    OrderGrid.DataBind();
                    if (OrderGrid.Rows.Count == 0)
                    {
                        ShipStationWizard.FinishCompleteButtonStyle.CssClass = "hideExportButton";
                        ExportOptionsPanel.Visible = false;
                        OrdersTitleLabel.Visible = false;
                    }
                    else
                    {
                        ShipStationWizard.FinishCompleteButtonStyle.CssClass = "button";
                        ExportOptionsPanel.Visible = true;
                        OrdersTitleLabel.Visible = true;
                    }
                    break;
            }
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            if (_shipStationExportManager.ExportInfo != null && _shipStationExportManager.IsExportRunning)
            {
                ProgressLabel.Text = string.Format(ProgressLabel.Text, _shipStationExportManager.ExportInfo.TotalItems, _shipStationExportManager.ExportInfo.ItemsExported);
            }
            else
            {
                Timer1.Enabled = false;
                ProgressPanel.Visible = false;

                IList<string> messages = _shipStationExportManager.ExportInfo.Messages;
                if (messages != null && messages.Count > 0)
                {
                    MessagesPanel.Visible = true;
                    Messages.DataSource = _shipStationExportManager.ExportInfo.Messages;
                    Messages.DataBind();
                }
                else
                {
                    // show confirmation
                    ExportCompleteMessage.Visible = true;
                    ExportCompleteMessage.Text = string.Format(ExportCompleteMessage.Text, LocaleHelper.LocalNow);
                }

                FinishPanel.Visible = true;
                FinishedMessage.Text = string.Format(FinishedMessage.Text, LocaleHelper.LocalNow);
            }
        }

        protected void ShipStationWizard_FinishButtonClick(object sender, WizardNavigationEventArgs e)
        {
            if (Page.IsValid)
            {
                ShipStationExportOptions exportOptions = GetExportOptions();
                _shipStationExportManager.Export(exportOptions);
                Timer1.Enabled = true;
                ProgressLabel.Text = "Starting export.";
                ProgressPanel.Visible = true;
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

        private ShipStationExportOptions GetExportOptions()
        {
            ShipStationExportOptions exportOptions = new ShipStationExportOptions();
            if (OrderStartDate.SelectedStartDate > DateTime.MinValue)
                exportOptions.FromDate = OrderStartDate.SelectedStartDate;
            if (OrderEndDate.SelectedEndDate > DateTime.MinValue && OrderEndDate.SelectedEndDate < DateTime.MaxValue)
                exportOptions.EndDate = OrderEndDate.SelectedEndDate;

            exportOptions.IncludeExportedOrders = IncludeExported.Checked;
            exportOptions.NewOrderStatusId = AlwaysConvert.ToInt(NewOrderStatus.SelectedValue);
            exportOptions.OrderNumbers = OrderNumberFilter.Text.Trim();
            exportOptions.OrderStatusId = AlwaysConvert.ToInt(StatusFilter.SelectedValue);
            exportOptions.ShipmentStatus = (OrderShipmentStatus)AlwaysConvert.ToByte(ShipmentStatusFilter.SelectedValue);
            exportOptions.PaymentStatus = (OrderPaymentStatus)AlwaysConvert.ToByte(PaymentStatusFilter.SelectedValue);

            // RETURN THE CRITERIA OBJECT
            return exportOptions;
        }

        private void BindOrderStatuses()
        {
            //GET ORDER STATUSES FOR STORE
            IList<OrderStatus> statuses = OrderStatusDataSource.LoadAll();
            IList<OrderStatus> validStatuses = new List<OrderStatus>();
            IList<OrderStatus> invalidStatuses = new List<OrderStatus>();
            //BUILD STATUS FILTER
            String statusNamePrefix = "- ";
            foreach (OrderStatus status in statuses)
            {
                if (status.IsValid)
                {
                    validStatuses.Add(status);
                }
                else
                {
                    invalidStatuses.Add(status);
                }
            }
            // ADD VALID STATUSES
            StatusFilter.Items.Add(new ListItem("All Valid", "-2"));
            foreach (OrderStatus status in validStatuses)
            {
                StatusFilter.Items.Add(new ListItem(statusNamePrefix + status.Name, status.Id.ToString()));
                NewOrderStatus.Items.Add(new ListItem(statusNamePrefix + status.Name, status.Id.ToString()));
            }
            // ADD INVALID STATUSES
            StatusFilter.Items.Add(new ListItem("All Invalid", "-3"));
            foreach (OrderStatus status in invalidStatuses)
            {
                StatusFilter.Items.Add(new ListItem(statusNamePrefix + status.Name, status.Id.ToString()));
                NewOrderStatus.Items.Add(new ListItem(statusNamePrefix + status.Name, status.Id.ToString()));
            }
            // SET THE DEFAULT AS ALL-VALID
            StatusFilter.SelectedIndex = 1;
        }

        protected void CancelExportLink_Click(object sender, EventArgs e)
        {
            if (_shipStationExportManager != null)
            {
                 ProgressLabel.Text = "Cancelling export.";
                _shipStationExportManager.CancelExport();
            }
        }
    }
}