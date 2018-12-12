namespace AbleCommerce.Admin.People.Subscriptions
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Linq;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using AbleCommerce.Code;
    using CommerceBuilder.Messaging;

    public partial class EditSubscription : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Product _Product;
        private int _SubscriptionId;
        private Subscription _Subscription;
        private string _returnUrl = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            _SubscriptionId = AlwaysConvert.ToInt(Request.QueryString["SubscriptionId"]);
            _Subscription = SubscriptionDataSource.Load(_SubscriptionId);
            if (_Subscription == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            _returnUrl = GetReturnUrl();
            _Product = _Subscription.Product;

            Caption.Text = string.Format(Caption.Text, _Product.Name);

            if(!Page.IsPostBack) InitFormValues();

            CancelButton.NavigateUrl = _returnUrl;
        }

        protected void InitFormValues()
        {
            SubscriptionName.Text = _Subscription.Name;
            SubscriptionQuantity.Text = _Subscription.Quantity.ToString();
            BindSubscriptionGroup();
            Order order = _Subscription.OrderItem.Order;
            OrderNumber.Text = order.OrderNumber.ToString();
            OrderNumber.NavigateUrl = string.Format(OrderNumber.NavigateUrl, order.OrderNumber);
            OrderDate.Text = string.Format("{0:d}", _Subscription.OrderDate);
            User user = _Subscription.User;
            UserName.Text = user.UserName;
            UserName.NavigateUrl = string.Format(UserName.NavigateUrl, user.Id);

            // DECIDE SUBSCRIPTION TYPE, RECURRING SUBSCRIPTIONS HAVE VALUE FOR PaymentFrequency AND PaymentFrequencyUnit FIELDS. 
            SubscriptionType.Text = (!_Subscription.PaymentFrequency.HasValue || !_Subscription.PaymentFrequencyUnit.HasValue) ? "One Time" : "Recurring";
            Active.Checked = _Subscription.IsActive;

            /**
            FOR RECURRING SUBSCRIPTIONS TRY TO GENERATE OPTIONAL PAYMENT FREQUENCY OPTIONS FROM ASSOCIATED SUBSCRIPTION PLAN,
            OPTIONAL FREQUENCIES ALLOW CUSTOMERS TO SELECT THE RECURRING INTERVALS DURING PLAN PURCHASE.
            **/
            if (_Subscription.PaymentFrequency.HasValue && _Subscription.PaymentFrequencyUnit.HasValue)
            {
                // RELATED SUBSCRIPTION PLAN HAVE OPTIONAL FREQUENCIES, ALLOW MERCHANT TO CHANGE OPTIONAL FREQUENCY SELECTION MADE BY CUSTOMER
                if (!string.IsNullOrEmpty(_Product.SubscriptionPlan.OptionalPaymentFrequencies))
                {
                    PaymentFrequencyUnit unit = _Subscription.PaymentFrequencyUnit.Value;
                    string[] frequencyValues = _Product.SubscriptionPlan.OptionalPaymentFrequencies.Split(',');
                    Frequency.Items.Clear();
                    if (frequencyValues != null && frequencyValues.Length > 0)
                    {
                        foreach (string val in frequencyValues)
                        {
                            var frequencyValue = AlwaysConvert.ToInt(val);
                            if (frequencyValue > 0)
                            {
                                // BUILD OPTIONAL FREQUENCY ITEMS FOR EXAMPLE 2 DAYS, 3 MONTH ETC
                                string text = string.Format("{0} {1}{2}", frequencyValue, unit, frequencyValue > 1 ? "s" : string.Empty);
                                Frequency.Items.Add(new ListItem(text, frequencyValue.ToString()));
                            }
                        }
                    }

                    FixedFrequency.Visible = false;
                    Frequency.Visible = true;
                }
                else
                {
                    // FIXED FREQUENCY IS MERCHANT DEFIEND RECURRING INTERVAL FOR SUBSCRIPTION PLAN. IT CAN'T BE CHANGED AFTER PLAN PURCHASE.
                    FixedFrequency.Text = string.Format("{0} {1}{2}", _Subscription.PaymentFrequency, _Subscription.PaymentFrequencyUnit, _Subscription.PaymentFrequency > 1 ? "s" : string.Empty);
                    FixedFrequency.Visible = true;
                    Frequency.Visible = false;
                }
            }
            else trFrequency.Visible = false;

            // PROCESSING STATUS TELLS US ABOUT THE RESULT OF BACKEND RECURRING ORDER MAINTINANCE SERVICES ACTIONS FOR THIS SUBSCRIPTION
            ProcessingStatusLabel.Text = _Subscription.ProcessingStatus.ToString();

            // ANY MESSAGE SENT BY SYSTEM RELATED TO PROCESSINGSTATUS FOR EXAMPLE COULD BE ERROR DETAILS IF STATUS IS ERROR
            string statusMsg = string.IsNullOrEmpty(_Subscription.ProcessingStatusMessage)? "" : _Subscription.ProcessingStatusMessage;
            ProcessingMessage.Text = _Subscription.ProcessingStatus == ProcessingStatus.OK ? "OK" : statusMsg;
            ClearStatusBtn.Visible = _Subscription.ProcessingStatus != ProcessingStatus.OK;

            // FOR RECURRING SUBSCRIPTION THIS IS DATE WHEN LAST ORDER WAS CREATED FOR SUBSCRIPTION. 
            UpdateLastOrderDateForDisplay();
            

            // FOR RECURRING SUBSCRIPTION THIS IS DATE WHEN NEXT ORDER WILL BE CREATED FOR SUBSCRIPTION. 
            DateTime nextOrderDate = _Subscription.NextOrderDateForDisplay;
            if (_Subscription.ExpirationDate > DateTime.MinValue && _Subscription.ExpirationDate.Value.Year != DateTime.MaxValue.Year) Expiration.Text = string.Format("{0:d}", _Subscription.ExpirationDate);
            else Expiration.Text = "N/A";
            if (_Subscription.IsActive && nextOrderDate != DateTime.MinValue) NextOrderDate.Text = string.Format("{0:d}", nextOrderDate);
            else NextOrderDate.Text = "N/A";
                        
            ListItem frequencyItem = Frequency.Items.FindByValue(_Subscription.PaymentFrequency.ToString());
            if (frequencyItem != null) frequencyItem.Selected = true;
            BasePrice.Text = _Subscription.BasePrice.LSCurrencyFormat("ulc");
            BaseTaxCode.Text = _Subscription.BaseTaxCode != null ? _Subscription.BaseTaxCode.Name : "N/A";
            if (_Subscription.RecurringChargeEx > 0) RecurringCharge.Text = _Subscription.RecurringChargeEx.LSCurrencyFormat("ulc");
            else RecurringCharge.Text = string.Empty;
            RecurringChargeMode.Text = _Subscription.RecurringChargeMode.ToString();
            RecurringTaxCode.Text = _Subscription.RecurringTaxCodeEx != null ? _Subscription.RecurringTaxCodeEx.Name : "N/A";
            if (_Subscription.NumberOfPayments > 0) NumberOfPayments.Text = _Subscription.NumberOfPayments.ToString();
            else NumberOfPayments.Text = string.Empty;
            BillingAddressLink.NavigateUrl = string.Format(BillingAddressLink.NavigateUrl, user.Id, _SubscriptionId);
            BillingAddressLiteral.Text = _Subscription.FormatBillAddress(true);
            bool isShippable = _Subscription.OrderItem.Shippable != CommerceBuilder.Shipping.Shippable.No;
            ShippingAddressLiteral.Text = isShippable ? _Subscription.FormatShipAddress(true) : "N/A";
            PaymentInfo.Text = _Subscription.PaymentProfile == null ? "N/A" : _Subscription.PaymentProfile.NameAndTypeWithReference;
            ShippingAddress1.Visible = isShippable;
        }

        private void BindSubscriptionGroup()
        {
            SubscriptionGroup.Items.Clear();
            SubscriptionGroup.Items.Add(new ListItem(string.Empty));
            IList<CommerceBuilder.Users.Group> groupCol = GroupDataSource.LoadAll("Name");

            CommerceBuilder.Users.Group group;
            for (int i = groupCol.Count - 1; i >= 0; i--)
            {
                group = groupCol[i];
                if (group.Roles.Count > 0)
                {
                    groupCol.RemoveAt(i);
                }
            }

            SubscriptionGroup.DataSource = groupCol;
            SubscriptionGroup.DataBind();

            // SELECT VALUE
            ListItem item = SubscriptionGroup.Items.FindByValue(_Subscription.GroupId.ToString());
            if (item != null) item.Selected = true;
        }



        /// <summary>
        /// Gets the next order date for display purpose
        /// </summary>
        protected void UpdateLastOrderDateForDisplay()
        {
            DateTime lastOrderDate = DateTime.MinValue;
            string orderNumber = string.Empty;
            SubscriptionOrder subscriptionOrder = _Subscription.SubscriptionOrders.OrderByDescending(so => so.Order.OrderDate)
                    .Take(1)
                    .SingleOrDefault();

            if (subscriptionOrder != null)
            {
                lastOrderDate = subscriptionOrder.Order.OrderDate;
                orderNumber = subscriptionOrder.Order.OrderNumber.ToString();
            }
            else
            {
                lastOrderDate = _Subscription.OrderDate;
                orderNumber = _Subscription.OrderItem != null ? _Subscription.OrderItem.Order.OrderNumber.ToString() : string.Empty;
            }

            string fieldValue = "N/A";
            if (lastOrderDate != DateTime.MinValue) fieldValue = string.Format(LastOrderDate.Text, lastOrderDate, orderNumber);

            LastOrderDate.Text = fieldValue;
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            Save();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        protected void ClearStatusBtn_Click(object sender, EventArgs e)
        {
            _Subscription.ProcessingStatus = ProcessingStatus.OK;
            _Subscription.ProcessingStatusMessage = string.Empty;
            _Subscription.Save();
            InitFormValues();
        }

        protected void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            Save();
            Response.Redirect(_returnUrl);
        }

        private void Save()
        {
            _Subscription.Name = SubscriptionName.Text;
            int selectedGroupId = AlwaysConvert.ToInt(SubscriptionGroup.SelectedValue);
            _Subscription.GroupId = selectedGroupId;
            _Subscription.IsActive = Active.Checked;
            short frequency = AlwaysConvert.ToInt16(Frequency.Text);

            // IF PAYMENT FREQUENCY IS CHANGED BY MERCHANT
            if (trFrequency.Visible && frequency > 0 && _Subscription.PaymentFrequency != frequency)
            {
                _Subscription.PaymentFrequency = frequency;

                // RECALCULATE NEXT ORDER DATE ACCORDING TO NEW FREQUENCY VALUE
                _Subscription.RecalculateNextOrderDueDate();

                // RECALCULATE EXPIRATION ACCORDING TO NEW FREQUENCY VALUE
                _Subscription.RecalculateExpiration();
            }

            short numberOfPayments = AlwaysConvert.ToInt16(NumberOfPayments.Text);
            if (numberOfPayments != _Subscription.NumberOfPayments)
            {
                _Subscription.NumberOfPayments = numberOfPayments;
                _Subscription.RecalculateExpiration();
            }
            
            try
            {
                EmailProcessor.NotifySubscriptionUpdated(_Subscription);
            }
            catch (Exception ex)
            {
                Logger.Error("Error sending subscription updated email.", ex);
            }

            _Subscription.Save();
            InitFormValues();
        }

        private class AddressComparer : IComparer, IComparer<Address>
        {
            private int _PrimaryAddressId;
            public AddressComparer(int primaryAddressId)
            {
                _PrimaryAddressId = primaryAddressId;
            }
            public int Compare(object x, object y)
            {
                return this.Compare(x as Address, y as Address);
            }
            public int Compare(Address x, Address y)
            {
                if (x.Id == y.Id) return 0;
                if (x.Id == _PrimaryAddressId) return -1;
                if (y.Id == _PrimaryAddressId) return 1;
                string nX = (string.IsNullOrEmpty(x.Company) ? string.Empty : x.Company + " ") + x.FullName;
                string nY = (string.IsNullOrEmpty(y.Company) ? string.Empty : y.Company + " ") + y.FullName;
                return string.Compare(nX, nY);
            }
        }

        protected string GetOrderDueDate(object dataItem)
        {
            SubscriptionOrder so = (SubscriptionOrder)dataItem;
            return so.OrderDueDate != DateTime.MinValue ? so.OrderDueDate.ToString() : "N/A";
        }

        protected string GetPaymentAlertDate(object dataItem) 
        {
            SubscriptionOrder so = (SubscriptionOrder)dataItem;
            return so.PaymentAlertDate.HasValue && so.PaymentAlertDate != DateTime.MinValue && so.PaymentAlertDate != DateTime.MaxValue ? so.PaymentAlertDate.ToString() : "N/A";
        }

        protected string GetOrderStatus(Object orderStatusId)
        {
            OrderStatus status = OrderStatusDataSource.Load((int)orderStatusId);
            if (status != null) return status.Name;
            return string.Empty;
        }

        private string GetReturnUrl()
        {
            String returnUrl = Request.QueryString["ReturnUrl"];
            if (!String.IsNullOrEmpty(returnUrl)) return System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(returnUrl));
            else return "Default.aspx";
        }
    }
}