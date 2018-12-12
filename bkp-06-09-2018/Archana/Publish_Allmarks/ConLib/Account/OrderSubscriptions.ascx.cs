namespace AbleCommerce.ConLib.Account
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using CommerceBuilder.Orders;

    [Description("Displays subscriptions for a given order")]
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

        protected string GetExpirationDate(object o)
        {
 	 	 	Subscription subscription = o as Subscription;
 	 	 	if (subscription.ExpirationDate.HasValue && subscription.ExpirationDate.Value > DateTime.MinValue && subscription.ExpirationDate.Value.Year != DateTime.MaxValue.Year)
 	 	 	 	return string.Format("{0:d}", subscription.ExpirationDate);
 	 	 	else return "N/A";
        }
    }
}