namespace AbleCommerce.Admin.Orders.Edit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services;
    using CommerceBuilder.Utility;

    public partial class ReturnItems : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId = 0;

        protected void Page_Init(object sender, EventArgs e)
        {
            _OrderId = PageHelper.GetOrderId();
            Order order = OrderDataSource.Load(_OrderId);
            if (order == null) Response.Redirect("../Default.aspx");
            Caption.Text = string.Format(Caption.Text, order.OrderNumber);
            CancelLink.NavigateUrl += order.OrderNumber;
            BindGrid(order);
        }

        protected void ReturnButton_Click(object sender, EventArgs e)
        {
            List<ItemReturnInfo> itemsToReturn = new List<ItemReturnInfo>();
            Order order = OrderDataSource.Load(_OrderId);
            foreach (GridViewRow row in ReturnableItems.Rows)
            {
                int orderItemId = AlwaysConvert.ToInt(ReturnableItems.DataKeys[row.DataItemIndex].Value);
                OrderItem item = order.Items.FirstOrDefault(find => find.Id.Equals(orderItemId));
                if (item != null)
                {
                    int returnQuantity = AlwaysConvert.ToInt(((TextBox)row.FindControl("ReturnQuantity")).Text);
                    if (returnQuantity > 0)
                    {
                        itemsToReturn.Add(new ItemReturnInfo(item, returnQuantity, ReturnToInventory.Checked));
                    }
                }
            }
            IOrderService service = AbleContext.Resolve<IOrderService>();
            service.ReturnItems(order, itemsToReturn);

            // add note if indicated
            if (!string.IsNullOrEmpty(OrderNote.Text))
            {
                order.Notes.Add(new OrderNote(order, AbleContext.Current.User, LocaleHelper.LocalNow, OrderNote.Text, OrderNoteIsPrivate.Checked ? NoteType.Private : NoteType.Public));
                order.Save(false, false);
            }

            // display confirmation
            BindGrid(order);
            ReturnedMessage.Visible = true;
        }

        private void BindGrid(Order order)
        {
            List<OrderItem> returnableItems = order.Items.Where(item => item.OrderItemType.Equals(OrderItemType.Product)).ToList();
            if (returnableItems != null && returnableItems.Count > 0)
            {
                trInventory.Visible = AbleContext.Current.Store.Settings.EnableInventory && returnableItems.Count(item => item.Product != null && item.Product.InventoryMode != CommerceBuilder.Products.InventoryMode.None && item.InventoryStatus == InventoryStatus.Destocked) > 0;
                ReturnableItems.DataSource = returnableItems;
                ReturnableItems.DataBind();
            }
            else
            {
                ReturnPanel.Visible = false;
                NoReturnsPanel.Visible = true;
            }
        }
    }
}