namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Search;
    using CommerceBuilder.Utility;
    using System.Collections.Generic;

    public partial class PaymentManager : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                InitDateQuickPick();

                // INITIALIZE PAYMENT STATUS DROPDOWN
                foreach (PaymentStatus s in Enum.GetValues(typeof(PaymentStatus)))
                {
                    ListItem item = new ListItem(StringHelper.SpaceName(s.ToString()), ((int)s).ToString());
                    PaymentStatusFilter.Items.Add(item);
                }

                ListItem authorizedItem = PaymentStatusFilter.Items.FindByText("Authorized");
                PaymentStatusFilter.SelectedIndex = PaymentStatusFilter.Items.IndexOf(authorizedItem);
            }
        }

        private bool IsAssignableGateway(PaymentGateway gateway)
        {
            string gcerClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GiftCertificatePaymentProvider));
#pragma warning disable 618
            string gchkClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GoogleCheckout.GoogleCheckout));
#pragma warning restore 618
            //string ppalClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.PayPal.PayPalProvider));

            if (gcerClassId.Equals(gateway.ClassId)
                || gchkClassId.Equals(gateway.ClassId)
                /*|| ppalClassId.Equals(gateway.ClassId)*/)
            {
                return false;
            }
            return true;
        }

        private void InitDateQuickPick()
        {
            StringBuilder js = new StringBuilder();
            js.AppendLine("function dateQP(selectDom) {");
            js.AppendLine("var startPicker = document.getElementById('" + StartDate.PickerClientId + "');");
            js.AppendLine("var endPicker = document.getElementById('" + EndDate.PickerClientId + "');");
            js.AppendLine("switch(selectDom.selectedIndex){");
            string setStart = "startPicker.value = '{0}';";
            string setEnd = "endPicker.value = '{0}';";
            string clearStart = "startPicker.value = '';";
            string clearEnd = "endPicker.value = '';";
            int startIndex = 1;

            DateQuickPick.Items.Add(new ListItem("Today"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 7 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-7).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 14 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-14).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 30 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-30).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 60 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-60).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 90 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-90).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last 120 Days"));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, LocaleHelper.LocalNow.AddDays(-120).ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("This Week"));
            DateTime startDate = LocaleHelper.LocalNow.AddDays(-1 * (int)LocaleHelper.LocalNow.DayOfWeek);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last Week"));
            startDate = LocaleHelper.LocalNow.AddDays((-1 * (int)LocaleHelper.LocalNow.DayOfWeek) - 7);
            DateTime endDate = startDate.AddDays(6);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(string.Format(setEnd, endDate.ToString("d")));
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("This Month"));
            startDate = new DateTime(LocaleHelper.LocalNow.Year, LocaleHelper.LocalNow.Month, 1);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("Last Month"));
            DateTime lastMonth = LocaleHelper.LocalNow.AddMonths(-1);
            startDate = new DateTime(lastMonth.Year, lastMonth.Month, 1);
            endDate = new DateTime(startDate.Year, startDate.Month, DateTime.DaysInMonth(lastMonth.Year, lastMonth.Month));
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(string.Format(setEnd, endDate.ToString("d")));
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("This Year"));
            startDate = new DateTime(LocaleHelper.LocalNow.Year, 1, 1);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(string.Format(setStart, startDate.ToString("d")));
            js.Append(clearEnd);
            js.AppendLine("break;");

            DateQuickPick.Items.Add(new ListItem("All Dates"));
            startDate = new DateTime(LocaleHelper.LocalNow.Year, 1, 1);
            js.Append("case " + (startIndex++).ToString() + ": ");
            js.Append(clearStart);
            js.Append(clearEnd);
            js.AppendLine("break;");

            // close switch
            js.Append("}");

            // reset quick picker
            js.AppendLine("selectDom.selectedIndex = 0;");
            js.Append("}");
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "dateQP", js.ToString(), true);
            DateQuickPick.Attributes.Add("onChange", "dateQP(this)");
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            PaymentGrid.DataBind();
            SearchResultAjax.Update();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdatePaymentDisplayJS", "UpdatePaymentDisplay()", true);
        }

        protected void PaymentsDs_Selecting(object sender, System.Web.UI.WebControls.ObjectDataSourceSelectingEventArgs e)
        {
            // ADD IN THE SEARCH CRITERIA
            e.InputParameters["filter"] = GetPaymentsFilter();
        }

        protected PaymentFilter GetPaymentsFilter()
        {
            // CREATE CRITERIA INSTANCE
            PaymentFilter criteria = new PaymentFilter();
            if (StartDate.SelectedStartDate > DateTime.MinValue)
                criteria.DateStart = StartDate.SelectedStartDate;
            if (EndDate.SelectedEndDate > DateTime.MinValue && EndDate.SelectedEndDate < DateTime.MaxValue)
                criteria.DateEnd = EndDate.SelectedEndDate;
            criteria.PaymentStatusId = AlwaysConvert.ToInt16(PaymentStatusFilter.SelectedValue);
            criteria.OrderNumberRange = OrderNumberFilter.Text.Trim();
            criteria.TransactionId = TransactionIdFilter.Text.Trim();

            List<int> paymentMethodIds = new List<int>();
            foreach(ListItem item in PaymentMethodFilter.Items)
            {
                if(item.Selected) paymentMethodIds.Add(AlwaysConvert.ToInt(item.Value));
            }
            if(paymentMethodIds.Count > 0) criteria.PaymentMethodIds = paymentMethodIds.ToArray();

            return criteria;
        }

        protected void PaymentGrid_DataBound(object sender, EventArgs e)
        {
            bool foundPayment = false;
            foreach (GridViewRow gvr in PaymentGrid.Rows)
            {
                CheckBox cb = (CheckBox)gvr.FindControl("SelectPaymentCheckBox");
                if (cb.Visible)
                {
                    foundPayment = true;
                    ScriptManager.RegisterArrayDeclaration(PaymentGrid, "CheckBoxIDs", String.Concat("'", cb.ClientID, "'"));
                }
            }
            BatchPanel.Visible = foundPayment;
        }

        protected string GetOrderBalance(object dataItem)
        {
            Payment payment = (Payment)dataItem;
            return payment.Order.GetBalance(false).LSCurrencyFormat("lc");
        }

        protected string GetTransactionData(object dataItem)
        {
            Payment payment = (Payment)dataItem;
            if (payment.Transactions.Count == 0) return string.Empty;
            StringBuilder paymentData = new StringBuilder();
            Transaction lastTransaction = payment.Transactions[payment.Transactions.Count - 1];
            if (lastTransaction != null)
            {
                if (!string.IsNullOrEmpty(lastTransaction.AuthorizationCode)) paymentData.Append("Auth:" + lastTransaction.AuthorizationCode + "<br />");
                if (!string.IsNullOrEmpty(lastTransaction.ProviderTransactionId)) paymentData.Append("TxID:" + lastTransaction.ProviderTransactionId + "<br />");
                if (lastTransaction.TransactionType == TransactionType.Authorize)
                {
                    paymentData.Append("CVV:" + AbleCommerce.Code.StoreDataHelper.TranslateCVVCode(lastTransaction.CVVResultCode) + " (" + lastTransaction.CVVResultCode + ")<br />");
                    paymentData.Append("AVS:" + AbleCommerce.Code.StoreDataHelper.TranslateAVSCode(lastTransaction.AVSResultCode) + " (" + lastTransaction.AVSResultCode + ")");
                }
            }
            return paymentData.ToString();
        }

        #region Capture Payments

        protected void PaymentGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Capture")
            {
                // INIT VARS
                int paymentId = AlwaysConvert.ToInt(e.CommandArgument);
                Payment payment = PaymentDataSource.Load(paymentId);
                if (payment != null)
                {
                    CaptureDialogCaption.Text = string.Format(CaptureDialogCaption.Text, paymentId, payment.ReferenceNumber);
                    CurrentPaymentStatus.Text = StringHelper.SpaceName(payment.PaymentStatus.ToString()).ToUpperInvariant();
                    CurrentPaymentStatus.CssClass = AbleCommerce.Code.CssHelper.GetPaymentStatusCssClass(payment.PaymentStatus);
                    PaymentDate.Text = string.Format("{0:g}", payment.PaymentDate);
                    Amount.Text = payment.Amount.LSCurrencyFormat("lc");
                    PaymentMethod.Text = payment.PaymentMethodName;
                    decimal orig = payment.Transactions.GetTotalAuthorized();
                    decimal rem = payment.Transactions.GetRemainingAuthorized();
                    decimal bal = payment.Order.GetBalance(false);
                    OriginalAuthorization.Text = orig.LSCurrencyFormat("lc");
                    RemainingAuthorization.Text = rem.LSCurrencyFormat("lc");
                    trRemainingAuthorization.Visible = (orig != rem);
                    CaptureAmount.Text = string.Format("{0:F2}", bal);
                    OrderBalance.Text = bal.LSCurrencyFormat("lc");
                    trAdditionalCapture.Visible = IsPartialCaptureSupported(payment);


                    AccountDataViewport.PaymentId = paymentId;

                    HiddenPaymentId.Value = paymentId.ToString();
                    CapturePopup.Show();
                }
            }
        }

        protected bool IsPartialCaptureSupported(Payment payment)
        {
            Transaction lastAuth = payment.Transactions.GetLastAuthorization();
            if (lastAuth != null)
            {
                PaymentGateway gateway = lastAuth.PaymentGateway;
                if (gateway != null)
                {
                    IPaymentProvider instance = gateway.GetInstance();
                    return ((instance.SupportedTransactions & SupportedTransactions.PartialCapture) == SupportedTransactions.PartialCapture);
                }
            }
            return false;
        }



        protected void SubmitCaptureButton_Click(object sender, EventArgs e)
        {
            int paymentId = AlwaysConvert.ToInt(HiddenPaymentId.Value);
            Payment payment = PaymentDataSource.Load(paymentId);
            if (payment != null)
            {

                //GET THE CAPTURE AMOUNT
                decimal captureAmount = AlwaysConvert.ToDecimal(CaptureAmount.Text);
                bool finalCapture = NoAdditionalCapture.Checked;
                if (captureAmount > 0)
                {
                    payment.Capture(captureAmount, finalCapture, false);
                    if (!string.IsNullOrEmpty(CustomerNote.Text))
                    {
                        OrderNote note = new OrderNote(payment.Order.Id, AbleContext.Current.UserId, DateTime.UtcNow, CustomerNote.Text, NoteType.Public);
                        note.Save();
                    }
                }

                // UPDATE THE GRID
                CapturePopup.Hide();
                PaymentGrid.DataBind();
                SearchResultAjax.Update();
            }
        }

        protected void CaptureAllButton_Click(object sender, EventArgs e)
        {
            foreach (GridViewRow row in PaymentGrid.Rows)
            {
                CheckBox checkbox = (CheckBox)row.FindControl("SelectPaymentCheckBox");
                if ((checkbox != null) && (checkbox.Checked))
                {
                    int paymentId = Convert.ToInt32(PaymentGrid.DataKeys[row.RowIndex].Value);
                    Payment payment = PaymentDataSource.Load(paymentId);
                    if (payment != null)
                    {
                        if (payment.Amount > 0)
                        {
                            payment.Capture(payment.Amount, true, false);
                        }
                    }
                }
            }
            PaymentGrid.DataBind();
            SearchResultAjax.Update();
        }

        #endregion
    }
}