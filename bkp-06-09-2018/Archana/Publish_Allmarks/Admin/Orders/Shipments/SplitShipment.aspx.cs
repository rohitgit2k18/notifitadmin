namespace AbleCommerce.Admin.Orders.Shipments
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class SplitShipment : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private OrderShipment _OrderShipment;
        private List<ListItem> _ShipmentChoices;

        protected void Page_Init(object sender, EventArgs e)
        {
            int shipmentId = AlwaysConvert.ToInt(Request.QueryString["ShipmentId"]);
            _OrderShipment = OrderShipmentDataSource.Load(shipmentId);
            if (_OrderShipment == null)
            {
                int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
                int orderNumber = OrderDataSource.LookupOrderNumber(orderId);
                Response.Redirect("Default.aspx?OrderNumber=" + orderNumber.ToString());
            }
            Caption.Text = string.Format(Caption.Text, _OrderShipment.ShipmentNumber, _OrderShipment.Order.OrderNumber);
            CancelLink.NavigateUrl += "?OrderNumber=" + _OrderShipment.Order.OrderNumber.ToString();
            //ADD ITEMS TO SHIPMENTS LIST
            _ShipmentChoices = new List<ListItem>();
            _ShipmentChoices.Add(new ListItem(""));
            foreach (OrderShipment shipment in _OrderShipment.Order.Shipments)
            {
                if (!shipment.IsShipped && (shipment.Id != shipmentId))
                {
                    string address = string.Format("{0} {1} {2} {3}", shipment.ShipToFirstName, shipment.ShipToLastName, shipment.ShipToAddress1, shipment.ShipToCity);
                    if (address.Length > 50) address = address.Substring(0, 47) + "...";
                    string name = "Shipment #" + shipment.ShipmentNumber + " to " + address;
                    _ShipmentChoices.Add(new ListItem(name, shipment.Id.ToString()));
                }
            }
            _ShipmentChoices.Add(new ListItem("New shipment...", "0"));
            //BIND ITEMS
            ShipmentItems.DataSource = _OrderShipment.OrderItems;
            ShipmentItems.DataBind();
            //BIND THE MOVE LOCATIONS
            foreach (GridViewRow row in ShipmentItems.Rows)
            {
                DropDownList shipment = (DropDownList)row.FindControl("Shipment");
                if (shipment != null) shipment.Items.AddRange(_ShipmentChoices.ToArray());
            }
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            bool itemFound = false;
            OrderShipment newShipment = null;
            OrderShipment moveShipment = null;
            foreach (GridViewRow row in ShipmentItems.Rows)
            {
                HiddenField hf = (HiddenField)row.FindControl("Id");
                int orderItemId = AlwaysConvert.ToInt(hf.Value);
                int index = _OrderShipment.OrderItems.IndexOf(orderItemId);
                if (index > -1)
                {
                    TextBox tb = (TextBox)row.FindControl("MoveQty");
                    short qty = AlwaysConvert.ToInt16(tb.Text);
                    DropDownList ddl = (DropDownList)row.FindControl("Shipment");
                    string selectedShipment = Request.Form[ddl.UniqueID];
                    if ((qty > 0) && (!string.IsNullOrEmpty(selectedShipment)))
                    {
                        OrderItem orderItem = _OrderShipment.OrderItems[index];
                        itemFound = true;
                        int shipmentId = AlwaysConvert.ToInt(selectedShipment);
                        moveShipment = OrderShipmentDataSource.Load(shipmentId);
                        if (moveShipment == null)
                        {
                            if (newShipment == null)
                            {
                                newShipment = _OrderShipment.Copy();
                                newShipment.Save();
                            }
                            moveShipment = newShipment;
                        }
                        if (qty < orderItem.Quantity)
                        {
                            //SPLIT PART OF THIS ITEM TO ANOTHER SHIPMENT
                            OrderItem splitItem = OrderItem.Copy(orderItem.Id, false);                            
                            splitItem.Quantity = qty;
                            splitItem.OrderShipmentId = moveShipment.Id;
                            splitItem.Save();
                            if (orderItem.ParentItemId == orderItem.Id)
                            {
                                splitItem.ParentItemId = splitItem.Id;
                                splitItem.Save();
                            }
                            moveShipment.OrderItems.Add(splitItem);
                            orderItem.Quantity -= qty;
                            orderItem.Save();
                        }
                        else
                        {
                            //MOVE WHOLE ITEM TO ANOTHER SHIPMENT
                            orderItem.OrderShipmentId = moveShipment.Id;
                            orderItem.Save();
                            _OrderShipment.OrderItems.RemoveAt(index);
                        }
                    }
                }
            }

            if (itemFound)
            {
                Response.Redirect(CancelLink.NavigateUrl);
            }
            else
            {
                CustomValidator quantityError = new CustomValidator();
                quantityError.ErrorMessage = "You must pick at least one item to move.";
                quantityError.Text = "&nbsp;";
                quantityError.IsValid = false;
                phQuantityValidation.Controls.Add(quantityError);
            }
        }
    }
}