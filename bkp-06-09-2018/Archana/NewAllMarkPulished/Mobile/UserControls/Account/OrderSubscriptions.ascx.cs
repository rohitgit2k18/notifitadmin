using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CommerceBuilder.Extensions;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;


namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class OrderSubscriptions : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                IList<Subscription> SubscriptionCollection = GetSubscriptions(this.Order);
                if (SubscriptionCollection.Count > 0)
                {
                    SubscriptionsPanel.Visible = true;
                    SubscriptionsGrid.DataSource = SubscriptionCollection;
                    SubscriptionsGrid.DataBind();
                }
            }
        }

        private IList<Subscription> GetSubscriptions(Order order)
        {
            IList<Subscription> gcList = new List<Subscription>();
            foreach (OrderItem orderItem in order.Items)
            {
                foreach (Subscription gc in orderItem.Subscriptions)
                {
                    if (gc != null) gcList.Add(gc);
                }
            }
            return gcList;
        }

        protected string GetNextOrderDate(object o)
        {
            Subscription subscription = o as Subscription;
            DateTime nextOrderDate = subscription.NextOrderDateForDisplay;
            if (nextOrderDate != DateTime.MinValue)
                return string.Format("{0:d}", nextOrderDate);
            return "N/A";
        }

        protected string GetExpirationDate(object o)
        {
            Subscription subscription = o as Subscription;
            if (subscription.ExpirationDate.HasValue && subscription.ExpirationDate.Value > DateTime.MinValue && subscription.ExpirationDate.Value.Year != DateTime.MaxValue.Year)
                return string.Format("{0:d}", subscription.ExpirationDate);
            else return "N/A";
        }

        protected string GetIsActive(object o)
        {
            Subscription subscription = o as Subscription;
            if (subscription.IsActive) return "YES";
            else return "NO";
        }

        protected void SubscriptionsGrid_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Subscription subscription = e.Item.DataItem as Subscription;
                Label DeliveryFrequencyLabel = e.Item.FindControl("DeliveryFrequencyLabel") as Label;
                Label AutoDeliveryDescription = e.Item.FindControl("AutoDeliveryDescription") as Label;
                if (subscription.PaymentFrequency.HasValue && subscription.PaymentFrequencyUnit.HasValue)
                {
                    PaymentFrequencyUnit unit = subscription.PaymentFrequencyUnit.Value;
                    DeliveryFrequencyLabel = e.Item.FindControl("DeliveryFrequencyLabel") as Label;
                    if (DeliveryFrequencyLabel != null) DeliveryFrequencyLabel.Text = string.Format("{0} {1}{2}", subscription.PaymentFrequency, unit, subscription.PaymentFrequency > 1 ? "s" : string.Empty);

                    AutoDeliveryDescription = e.Item.FindControl("AutoDeliveryDescription") as Label;
                    if (AutoDeliveryDescription != null && subscription.SubscriptionPlan.IsRecurring)
                        AutoDeliveryDescription.Text = string.Format("(Recurring payment amount: {0})", subscription.RecurringChargeEx.LSCurrencyFormat("ulc"));
                }
                else
                {
                    if (DeliveryFrequencyLabel != null) DeliveryFrequencyLabel.Text = "N/A";
                    if (AutoDeliveryDescription != null) AutoDeliveryDescription.Text = string.Empty;
                }
            }
        }
    }
}