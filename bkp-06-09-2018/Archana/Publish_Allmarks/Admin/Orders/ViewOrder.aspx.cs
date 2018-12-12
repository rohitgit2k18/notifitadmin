//-----------------------------------------------------------------------
// <copyright file="ViewOrder.aspx.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Payments.Providers;

    public partial class ViewOrder : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Order _order;
        private int UrlMaxLenght = 30;

        protected void Page_Load(object sender, EventArgs e)
        {
            _order = AbleCommerce.Code.OrderHelper.GetOrderFromContext();
            if (_order == null) Response.Redirect("Default.aspx");
            if (!Page.IsPostBack)
            {
                BindOrderStatuses();
            }

            PrintButton.NavigateUrl = string.Format("~/admin/orders/Print/Invoices.aspx?OrderNumber={0}", _order.OrderNumber);
            OrderShipmentSummary.OrderId = _order.Id;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Caption.Text = string.Format(Caption.Text, _order.OrderNumber, _order.OrderStatus.Name);
            BindBillingColumn();
            BindPaymentColumn();
            BindOrderItemGrid();
        }

        protected void ChangeStatusOKButton_Click(object sender, EventArgs e)
        {
            // change status
            int newStatusId = AlwaysConvert.ToInt(NewStatus.SelectedValue);
            OrderStatus newStatus = OrderStatusDataSource.Load(newStatusId);
            if (_order.OrderStatusId != newStatusId && newStatus != null)
            {
                OrderStatus cancelledStatus = OrderStatusTriggerDataSource.LoadForStoreEvent(StoreEvent.OrderCancelled);
                if (cancelledStatus != null && newStatusId == cancelledStatus.Id)
                {
                    Response.Redirect("CancelOrder.aspx?OrderNumber=" + _order.OrderNumber.ToString());
                }
                else
                {
                    _order.OrderStatus = newStatus;
                    _order.Save(false, false);
                    BindOrderStatuses();
                    OrderStatusUpdatedMessage.Text = string.Format(OrderStatusUpdatedMessage.Text, newStatus.Name);
                    OrderStatusUpdatedMessage.Visible = true;
                }
            }
        }

        private void BindOrderStatuses()
        {
            // bind change status options
            IList<OrderStatus> statuses = OrderStatusDataSource.LoadAll("OrderBy");
            int currentStatusIndex = statuses.IndexOf(_order.OrderStatusId);
            if (currentStatusIndex > -1) statuses.RemoveAt(currentStatusIndex);
            NewStatus.DataSource = statuses;
            NewStatus.DataBind();
        }

        private void BindBillingColumn()
        {
            OrderDate.Text = string.Format("{0:g}", _order.OrderDate);
            OrderStatus.Text = _order.OrderStatus.Name;
            BindBillToAddress();
            if (_order.TaxExemptionType != CommerceBuilder.Taxes.TaxExemptionType.None)
            {
                TaxExemptionPanel.Visible = true;
                TaxExemptionType.Text = StringHelper.SpaceName(_order.TaxExemptionType.ToString());
                if (!string.IsNullOrEmpty(_order.TaxExemptionReference))
                {
                    TaxExemptionReference.Text = string.Format(TaxExemptionReference.Text, _order.TaxExemptionReference);
                    TaxExemptionReference.Visible = true;
                }
            }
        }

        private void BindBillToAddress()
        {
            string pattern = "[Company]\r\n[Name]\r\n[Address1]\r\n[Address2]\r\n[City], [Province] [PostalCode]\r\n[Country_U]\r\n";
            Country country = CountryDataSource.Load(_order.BillToCountryCode);
            if (country != null)
            {
                if (!string.IsNullOrEmpty(country.AddressFormat)) pattern = country.AddressFormat;
            }
            BillingAddress.Text = _order.FormatAddress(pattern, true);
            BillToEmail.Text = _order.BillToEmail;
            MoveOrderButton.NavigateUrl = string.Format(MoveOrderButton.NavigateUrl, _order.OrderNumber.ToString());
            string returnUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Admin/Orders/ViewOrder.aspx?OrderNumber=" + _order.OrderNumber.ToString()));
            BillToEmail.NavigateUrl += "?OrderNumber=" + _order.OrderNumber.ToString() + "&ReturnUrl=" + returnUrl;
            if (!string.IsNullOrEmpty(_order.BillToPhone)) BillToPhone.Text = string.Format(BillToPhone.Text, _order.BillToPhone);
            else BillToPhone.Visible = false;
            if (!string.IsNullOrEmpty(_order.BillToFax)) BillToFax.Text = string.Format(BillToFax.Text, _order.BillToFax);
            else BillToFax.Visible = false;
        }

        protected void BindOrderItemGrid()
        {
            IList<OrderItem> itemList = new List<OrderItem>();
            foreach (OrderItem item in _order.Items)
            {
                switch (item.OrderItemType)
                {
                    case OrderItemType.Tax:
                    case OrderItemType.GiftCertificatePayment:
                        break;
                    default:
                        itemList.Add(item);
                        break;
                }
            }

            // SHOW TAXES IF SPECIFIED
            TaxInvoiceDisplay displayMode = TaxHelper.InvoiceDisplay;
            if (displayMode == TaxInvoiceDisplay.LineItem || displayMode == TaxInvoiceDisplay.LineItemRegistered)
            {
                foreach (OrderItem item in _order.Items)
                {
                    if ((item.OrderItemType == OrderItemType.Tax))
                        itemList.Add(item);
                }
            }

            // SORT AND COMBINE ORDER COUPONS FOR DISPLAY
            itemList.Sort(new OrderItemComparer());
            itemList = itemList.CombineOrderCoupons();
            OrderItemGrid.DataSource = itemList;
            OrderItemGrid.DataBind();
        }

        /// <summary>
        /// Binds the order details in the payment column
        /// </summary>
        protected void BindPaymentColumn()
        {
            // bind status
            OrderTotal.Text = _order.TotalCharges.LSCurrencyFormat("lc");
            OrderBalance.Text = _order.GetBalance(false).LSCurrencyFormat("lc");
            CurrentPaymentStatus.Text = _order.PaymentStatus.ToString();
            if (_order.PaymentStatus == OrderPaymentStatus.Paid) CurrentPaymentStatus.CssClass = "goodCondition";
            else CurrentPaymentStatus.CssClass = "errorCondition";


            // check for the last payment record
            Payment payment = GetLastPayment();
            if (payment != null)
            {
                // bind static payment info
                LastPaymentAmount.Text = payment.Amount.LSCurrencyFormat("lc");
                LastPaymentStatus.Text = StringHelper.SpaceName(payment.PaymentStatus.ToString());
                LastPaymentReference.Text = payment.PaymentMethodName;
                if (!string.IsNullOrEmpty(payment.ReferenceNumber))
                {
                    LastPaymentReference.Text += " " + payment.ReferenceNumber;
                }

                // bind transaction details
                Transaction lastAuthorization = payment.Transactions.GetLastAuthorization();
                if (lastAuthorization == null) lastAuthorization = payment.Transactions.GetLastRecurringAuthorization();
                if (lastAuthorization != null)
                {
                    string friendlyCVV = AbleCommerce.Code.StoreDataHelper.TranslateCVVCode(lastAuthorization.CVVResultCode);
                    if (!string.IsNullOrEmpty(lastAuthorization.CVVResultCode)) friendlyCVV += " (" + lastAuthorization.CVVResultCode + ")";
                    LastPaymentCVV.Text = friendlyCVV;
                    string friendlyAVS = AbleCommerce.Code.StoreDataHelper.TranslateAVSCode(lastAuthorization.AVSResultCode);
                    if (!string.IsNullOrEmpty(lastAuthorization.AVSResultCode)) friendlyAVS += " (" + lastAuthorization.AVSResultCode + ")";
                    LastPaymentAVS.Text = friendlyAVS;
                }
                else
                {
                    TransactionPanel.Visible = false;
                }

                PaymentGateway gateway = null;
                if (payment.PaymentMethod != null)
                {
                    gateway = payment.PaymentMethod.PaymentGateway;
                }

                if (gateway == null && payment.PaymentProfile != null)
                { 
                    int gatewayId = PaymentGatewayDataSource.GetPaymentGatewayIdByClassId(payment.PaymentProfile.GatewayIdentifier);
                    gateway = PaymentGatewayDataSource.Load(gatewayId);
                }

                IPaymentProvider provider = (gateway != null ? gateway.GetInstance() : null);
                SupportedTransactions supportedTransactions = SupportedTransactions.None;
                if (provider != null)
                    supportedTransactions = provider.SupportedTransactions;
                
                // bind payment buttons
                ReceivedButton.Visible = (payment.PaymentStatus == PaymentStatus.Unprocessed);
                if ((supportedTransactions & SupportedTransactions.Void) == SupportedTransactions.Void)
                {
                    VoidLink.Visible = ((payment.PaymentStatus == PaymentStatus.Unprocessed) || (payment.PaymentStatus == PaymentStatus.Authorized) || (payment.PaymentStatus == PaymentStatus.AuthorizationFailed) || (payment.PaymentStatus == PaymentStatus.CaptureFailed));
                    VoidLink.NavigateUrl = "Payments/VoidPayment.aspx?PaymentId=" + payment.Id.ToString();
                }
                else
                {
                    VoidLink.Visible = false;
                }

                if ((((supportedTransactions & SupportedTransactions.Capture) == SupportedTransactions.Capture) || ((supportedTransactions & SupportedTransactions.AuthorizeCapture) == SupportedTransactions.AuthorizeCapture)))
                {
                    CaptureLink.Visible = (payment.PaymentStatus == PaymentStatus.Authorized);
                    CaptureLink.NavigateUrl = "Payments/CapturePayment.aspx?PaymentId=" + payment.Id.ToString();
                }
                else
                {
                    VoidLink.Visible = false;
                }

                ButtonPanel.Visible = ReceivedButton.Visible || VoidLink.Visible || CaptureLink.Visible;
            }
            else
            {
                LastPaymentPanel.Visible = false;
            }

            // IP details
            if (!string.IsNullOrEmpty(_order.RemoteIP))
            {
                CustomerIP.Text = _order.RemoteIP;
                CustomerIPBlocked.Visible = BannedIPDataSource.IsBanned(CustomerIP.Text);
                BlockCustomerIP.Visible = (!CustomerIPBlocked.Visible && (_order.RemoteIP != Request.UserHostAddress));
                BlockCustomerIP.OnClientClick = string.Format(BlockCustomerIP.OnClientClick, _order.RemoteIP);
            }
            else
            {
                CustomerIPPanel.Visible = false;
            }

            //Refferrer url
            if (!string.IsNullOrEmpty(_order.Referrer))
            {
                if (_order.Referrer.Length > UrlMaxLenght)
                {
                    OrderReferrer.NavigateUrl = _order.Referrer;
                    OrderReferrer.Text = _order.Referrer.Substring(0, UrlMaxLenght) + "...";
                }
                else
                {
                    OrderReferrer.NavigateUrl = _order.Referrer;
                    OrderReferrer.Text = _order.Referrer.Replace("/", "/<wbr />").Replace("_", "_<wbr />");
                }
            }

            // affiliate details
            if (_order.AffiliateId != 0)
            {
                Affiliate.Text = _order.Affiliate.Name;
            }
            else
            {
                AffiliatePanel.Visible = false;
            }
            TaxExemptionMessagePanel.Visible = this._order.Items.TotalPrice(OrderItemType.Tax) == 0 &&  !string.IsNullOrEmpty(this._order.TaxExemptionReference);
        }

        protected void ReceivedButton_Click(object sender, EventArgs e)
        {
            Payment payment = GetLastPayment();
            if (payment != null)
            {
                AbleContext.Current.Database.BeginTransaction();
                payment.PaymentStatus = PaymentStatus.Completed;
                payment.Save(true);
                AbleContext.Current.Database.CommitTransaction();
            }
        }

        protected void BlockCustomerIP_Click(object sender, ImageClickEventArgs e)
        {
            BannedIP block = new BannedIP();
            block.IPRangeStart = BannedIP.ConvertToNumber(_order.RemoteIP);
            block.IPRangeEnd = block.IPRangeStart;
            block.Comment = "Order #" + _order.OrderNumber.ToString();
            block.Save();
        }

        protected string GetProductName(object dataItem)
        {
            OrderItem orderItem = (OrderItem)dataItem;
            if (string.IsNullOrEmpty(orderItem.VariantName)) return orderItem.Name;
            return string.Format("{0} ({1})", orderItem.Name, orderItem.VariantName);
        }

        protected bool IsGiftCert(object dataItem)
        {
            OrderItem orderItem = dataItem as OrderItem;
            if (orderItem == null) return false;
            return (orderItem.GiftCertificates.Count > 0);
        }

        protected bool IsDigitalGood(object dataItem)
        {
            OrderItem orderItem = dataItem as OrderItem;
            if (orderItem == null) return false;
            return (orderItem.DigitalGoods.Count > 0);
        }

        protected void OrderItemGrid_DataBinding(object sender, EventArgs e)
        {
            GridView grid = (GridView)sender;
            grid.Columns[2].Visible = TaxHelper.ShowTaxColumn;
            grid.Columns[2].HeaderText = TaxHelper.TaxColumnHeader;
        }

        private Payment GetLastPayment()
        {
            // IF THERE IS ANY INCOMPLETE PAYMENT, RETURN THE FIRST ONE FOUND
            foreach (Payment payment in _order.Payments)
            {
                if ((payment.PaymentStatus == PaymentStatus.Unprocessed) || (payment.PaymentStatus == PaymentStatus.AuthorizationPending) ||
                    (payment.PaymentStatus == PaymentStatus.Authorized) || (payment.PaymentStatus == PaymentStatus.CapturePending))
                {
                    return payment;
                }
            }
            if (_order.Payments.Count > 0) return _order.Payments[_order.Payments.Count - 1];
            return null;
        }
    }
}