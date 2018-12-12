namespace AbleCommerce.Admin._Store.OrderStatuses
{
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void StatusGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName.StartsWith("Move"))
            {
                Store store = AbleContext.Current.Store;
                store.OrderStatuses.Sort("OrderBy");
                int orderStatusId = AlwaysConvert.ToInt(e.CommandArgument.ToString());
                int index;
                switch (e.CommandName)
                {
                    case "MoveUp":
                        index = store.OrderStatuses.IndexOf(orderStatusId);
                        if (index > 0)
                        {
                            OrderStatus tempStatus = store.OrderStatuses[index - 1];
                            store.OrderStatuses[index - 1] = store.OrderStatuses[index];
                            store.OrderStatuses[index] = tempStatus;
                        }
                        break;
                    case "MoveDown":
                        index = store.OrderStatuses.IndexOf(orderStatusId);
                        if (index < store.OrderStatuses.Count - 1)
                        {
                            OrderStatus tempStatus = store.OrderStatuses[index + 1];
                            store.OrderStatuses[index + 1] = store.OrderStatuses[index];
                            store.OrderStatuses[index] = tempStatus;
                        }
                        break;
                }

                // make sure order statuses are in order
                index = 0;
                foreach (OrderStatus status in store.OrderStatuses)
                {
                    status.OrderBy = (short)index;
                    index++;
                }
                store.Save();

                // rebind grid to reflect update
                StatusGrid.DataBind();
            }
        }

        protected string GetX(object boolValue)
        {
            return (bool)boolValue ? "X" : string.Empty;
        }

        protected string GetTriggers(object dataItem)
        {
            OrderStatus orderStatus = (OrderStatus)dataItem;
            List<string> triggers = new List<string>();
            foreach (OrderStatusTrigger trigger in orderStatus.Triggers)
            {
                triggers.Add(StringHelper.SpaceName(trigger.StoreEvent.ToString()));
            }
            return string.Join("<br />", triggers.ToArray());
        }

        protected bool HasOrders(object dataItem)
        {
            OrderStatus os = (OrderStatus)dataItem;
            return (OrderDataSource.CountForOrderStatus(os.Id) > 0);
        }
    }
}