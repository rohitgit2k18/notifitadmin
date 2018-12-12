namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Collections.Generic;

    public partial class ViewSubscriptions : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Order _Order;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(orderId);
            Caption.Text = string.Format(Caption.Text, _Order.OrderNumber);
            if (!Page.IsPostBack)
            {
                BindSubscriptions();
            }
        }

        private void BindSubscriptions()
        {
            IList<Subscription> subscriptions = new List<Subscription>();
            if (_Order.IsSubscriptionGenerated)
            {
                IList<SubscriptionOrder> subOrders = SubscriptionOrderDataSource.LoadForOrder(_Order.Id);
                foreach (SubscriptionOrder subOrder in subOrders)
                {
                    if (subOrder.Subscription != null) subscriptions.Add(subOrder.Subscription);
                }

                SubscriptionGrid.DataSource = subscriptions;
                SubscriptionGrid.DataBind();
            }
            else
            {
                subscriptions = SubscriptionDataSource.LoadForOrder(_Order.Id);
                SubscriptionGrid.DataSource = subscriptions;
                SubscriptionGrid.DataBind();
            }
        }

        protected void SubscriptionGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int subscriptionId = AlwaysConvert.ToInt(e.CommandArgument);
            Subscription subscription = SubscriptionDataSource.Load(subscriptionId);
            switch (e.CommandName)
            {
                case "Activate":
                    subscription.Activate();
                    SubscriptionGrid.DataBind();
                    break;
                case "Deactivate":
                    subscription.Deactivate();
                    SubscriptionGrid.DataBind();
                    break;
                case "CancelSubscription":
                    subscription.Delete();
                    SubscriptionGrid.DataBind();
                    break;
            }

            BindSubscriptions();
        }

        protected String GetGroupName(object id)
        {
            int groupId = AlwaysConvert.ToInt(id);
            Group group = GroupDataSource.Load(groupId);
            if (group != null) return group.Name;
            else return string.Empty;
        }

        protected void SubscriptionGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            SubscriptionGrid.EditIndex = e.NewEditIndex;
            BindSubscriptions();
        }

        protected void SubscriptionGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e) 
        {
            SubscriptionGrid.EditIndex = -1;
            SubscriptionGrid.DataBind();
            e.Cancel = true;
        }

        protected void SubscriptionGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int subscriptionId = (int)SubscriptionGrid.DataKeys[e.RowIndex].Value;
            Subscription subscription = SubscriptionDataSource.Load(subscriptionId);
            if (subscription != null)
            {
                DateTime expiry = AlwaysConvert.ToDateTime(e.NewValues["ExpirationDate"], DateTime.MinValue);
                if (expiry != DateTime.MinValue)
                {
                    expiry = GetEndOfDay(expiry);
                    subscription.ExpirationDate = expiry;
                    subscription.Save();
                }
            }
            SubscriptionGrid.EditIndex = -1;
            BindSubscriptions();
            e.Cancel = true;
        }

        private static DateTime GetEndOfDay(DateTime date)
        {
            return new DateTime(date.Year, date.Month, date.Day, 23, 59, 59, DateTimeKind.Local);
        }

        protected void SubscriptionDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["OrderId"] = AbleCommerce.Code.PageHelper.GetOrderId();
        }

        protected string GetExpiration(object o)
        {
            Subscription subscription = o as Subscription;
            if (subscription != null && subscription.ExpirationDate.HasValue && subscription.ExpirationDate != DateTime.MinValue && subscription.ExpirationDate.Value.Year != DateTime.MaxValue.Year)
                return string.Format("{0:d}", subscription.ExpirationDate);
            return "N/A";
        }

        protected string GetNextPayment(object dataItem) 
        {
            Subscription subscription = (Subscription)dataItem;
            DateTime paymentDate = subscription.NextOrderDateForDisplay;
            return paymentDate == DateTime.MinValue ? "N/A" : paymentDate.ToShortDateString();
        }

        protected string GetEditSubscriptionUrl(object dataItem)
        {
            Subscription subscription = (Subscription)dataItem;
            string returnUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(string.Format("~/Admin/Orders/ViewSubscriptions.aspx?OrderNumber={0}", _Order.OrderNumber)));
            string editUrl = string.Format("~/Admin/People/Subscriptions/EditSubscription.aspx?SubscriptionId={0}&ReturnUrl={1}", subscription.Id, returnUrl);
            return editUrl;
        }
    }
}