namespace AbleCommerce.Admin._Store.OrderStatuses
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Messaging;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    public partial class AddOrderStatus : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(DisplayName);
            if (!Page.IsPostBack)
            {
                // LOAD TRIGGERS SELECT BOX
                foreach (int storeEventId in Enum.GetValues(typeof(StoreEvent)))
                {
                    if ((storeEventId >= 100) && (storeEventId < 200))
                    {
                        StoreEvent storeEvent = (StoreEvent)storeEventId;
                        Triggers.Items.Add(new ListItem(StringHelper.SpaceName(storeEvent.ToString()), storeEventId.ToString()));
                    }
                }
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            OrderStatus _OrderStatus = new OrderStatus();
            _OrderStatus.Name = Name.Text;
            _OrderStatus.DisplayName = DisplayName.Text;
            //ACTIVE FLAG IS USED TO DETERMINE VALID SALES FOR REPORTING
            _OrderStatus.IsActive = Report.Checked;
            //VALID FLAG IS USED TO DERMINE WHICH ORDERS ARE BAD
            _OrderStatus.IsValid = (!Cancelled.Checked);
            _OrderStatus.InventoryAction = (CommerceBuilder.Orders.InventoryAction)InventoryAction.SelectedIndex;
            foreach (ListItem item in Triggers.Items)
            {
                if (item.Selected)
                {
                    StoreEvent thisEvent = AlwaysConvert.ToEnum<StoreEvent>(item.Value, StoreEvent.None);
                    OrderStatus oldOrderStatus = OrderStatusTriggerDataSource.LoadForStoreEvent(thisEvent);
                    if (oldOrderStatus != null)
                    {
                        List<OrderStatusTrigger> triggers = (from t in oldOrderStatus.Triggers
                                                             where t.StoreEvent == thisEvent
                                                             select t).ToList<OrderStatusTrigger>();
                        triggers.DeleteAll<OrderStatusTrigger>();
                    }

                    // DROP EXISTING TRIGGERS FOR THIS EVENT
                    (from t in _OrderStatus.Triggers where t.StoreEvent == thisEvent select t).ToList<OrderStatusTrigger>().DeleteAll<OrderStatusTrigger>();
                    _OrderStatus.Triggers.Add(new OrderStatusTrigger(thisEvent, _OrderStatus));
                }
            }
            _OrderStatus.Save();

            foreach (ListItem item in EmailTemplates.Items)
            {
                var tempalte = EntityLoader.Load<EmailTemplate>(AlwaysConvert.ToInt(item.Value));
                if (item.Selected)
                {
                    tempalte.OrderStatuses.Add(_OrderStatus);
                }

                tempalte.Save();
            }
            Response.Redirect("Default.aspx");
        }
    }
}