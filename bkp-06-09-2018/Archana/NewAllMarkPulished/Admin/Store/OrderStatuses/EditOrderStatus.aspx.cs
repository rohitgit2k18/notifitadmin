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

    public partial class EditOrderStatus : CommerceBuilder.UI.AbleCommerceAdminPage
    {

        private int _OrderStatusId;
        private OrderStatus _OrderStatus;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            _OrderStatusId = AlwaysConvert.ToInt(Request.QueryString["OrderStatusId"]);
            _OrderStatus = OrderStatusDataSource.Load(_OrderStatusId);
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(DisplayName);
            Caption.Text = string.Format(Caption.Text, _OrderStatus.Name);
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
                // INITIALIZE FORM
                Name.Text = _OrderStatus.Name;
                Name.Focus();
                DisplayName.Text = _OrderStatus.DisplayName;
                Report.Checked = _OrderStatus.IsActive;
                Cancelled.Checked = !_OrderStatus.IsValid;
                InventoryAction.SelectedIndex = (int)_OrderStatus.InventoryActionId;
                foreach (OrderStatusTrigger trigger in _OrderStatus.Triggers)
                {
                    ListItem item = Triggers.Items.FindByValue(trigger.StoreEventId.ToString());
                    if (item != null) item.Selected = true;
                }
            }
        }

        protected void EmailTemplates_DataBound(object sender, System.EventArgs e)
        {
            if (EmailTemplates.Items.Count > 0)
            {
                ListItem item;
                foreach (EmailTemplate email in _OrderStatus.EmailTemplates)
                {
                    item = EmailTemplates.Items.FindByValue(email.Id.ToString());
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                    else
                    {
                        NoEmailTemplatesDefinedLabel.Visible = true;
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
            SaveOrderStatuses();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the order statuses
                SaveOrderStatuses();

                // redirect away
                Response.Redirect("Default.aspx");
            }
        }

        private void SaveOrderStatuses()
        {
            _OrderStatus.Name = Name.Text;
            _OrderStatus.DisplayName = DisplayName.Text;
            //ACTIVE FLAG IS USED TO DETERMINE VALID SALES FOR REPORTING
            _OrderStatus.IsActive = Report.Checked;
            //VALID FLAG IS USED TO DERMINE WHICH ORDERS ARE BAD
            _OrderStatus.IsValid = (!Cancelled.Checked);
            _OrderStatus.InventoryAction = (CommerceBuilder.Orders.InventoryAction)InventoryAction.SelectedIndex;
            _OrderStatus.Triggers.DeleteAll();
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
            _OrderStatus.EmailTemplates.Clear();
            _OrderStatus.Save();

            foreach (ListItem item in EmailTemplates.Items)
            {
                var tempalte = EntityLoader.Load<EmailTemplate>(AlwaysConvert.ToInt(item.Value));
                int index = tempalte.OrderStatuses.IndexOf(_OrderStatus.Id);
                if (item.Selected)
                {
                    if (index < 0)
                    {
                        tempalte.OrderStatuses.Add(_OrderStatus);
                    }
                }
                else
                {
                    if (index >= 0)
                    {
                        tempalte.OrderStatuses.RemoveAt(index);
                    }
                }

                tempalte.Save();
            }
        }
    }
}