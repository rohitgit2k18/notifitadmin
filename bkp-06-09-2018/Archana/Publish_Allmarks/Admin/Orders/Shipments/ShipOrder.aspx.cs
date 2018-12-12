namespace AbleCommerce.Admin.Orders.Shipments
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Shipping.Providers;
    using CommerceBuilder.Common;

    public partial class ShipOrder : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Order _Order;
        private OrderShipment _OrderShipment;
        private bool _IsProviderSupportShipping = false;

        protected void Page_Init(object sender, EventArgs e)
        {
            int shipmentId = AlwaysConvert.ToInt(Request.QueryString["OrderShipmentId"]);
            _OrderShipment = OrderShipmentDataSource.Load(shipmentId);
            if (_OrderShipment == null) Response.Redirect("../Default.aspx");
            _Order = _OrderShipment.Order;
            Caption.Text = string.Format(Caption.Text, _Order.OrderNumber);
            ShipmentNumber.Text = string.Format(ShipmentNumber.Text, _Order.Shipments.IndexOf(_OrderShipment.Id) + 1, _Order.Shipments.Count);
            ShippingMethod.Text = _OrderShipment.ShipMethodName;
            trShipMessage.Visible = !string.IsNullOrEmpty(_OrderShipment.ShipMessage);
            ShipMessage.Text = _OrderShipment.ShipMessage;
            ShipFrom.Text = _OrderShipment.FormatFromAddress();
            ShipTo.Text = _OrderShipment.FormatToAddress();
            ShipmentItems.DataSource = GetShipmentItems();
            ShipmentItems.DataBind();

            // check if ship gateway supports shipping feature
            CommerceBuilder.Shipping.ShipGateway shipGateway = _OrderShipment.ShipMethod != null ?_OrderShipment.ShipMethod.ShipGateway : null;
            IShippingProvider shipProvider = null;
            if( shipGateway != null)
            {
                shipProvider = shipGateway.GetProviderInstance();
                _IsProviderSupportShipping = shipProvider != null && shipProvider.IsShippingSupported;
            }

            ShipGateway.DataSource = ShipGatewayDataSource.LoadAll();
            ShipGateway.DataBind();
            if (ShipGateway.Items.Count > 1)
            {
                //TRY TO PRESET THE CORRECT GATEWAY
                if (_OrderShipment.ShipMethod != null)
                {
                    ListItem item = ShipGateway.Items.FindByValue(_OrderShipment.ShipMethod.ShipGatewayId.ToString());
                    if (item != null) item.Selected = true;
                }
            }
            else
            {
                ShipGateway.Visible = false;
            }

            if (_IsProviderSupportShipping)
            {
                autoTrackingInputPanel.Visible = true;

                // update the provider name
                ProviderInstructionText.Text = string.Format(ProviderInstructionText.Text, shipProvider.Name);
                ProviderInstructionText.Visible = true;
            }
            else autoTrackingInputPanel.Visible = false;

            CancelButton.NavigateUrl += "?OrderNumber=" + _OrderShipment.Order.OrderNumber.ToString();
        }

        protected List<OrderItem> GetShipmentItems()
        {
            List<OrderItem> items = new List<OrderItem>();
            foreach (OrderItem item in _Order.Items)
            {
                if ((item.OrderShipmentId == _OrderShipment.Id) && (item.OrderItemType == OrderItemType.Product)) items.Add(item);
            }
            return items;
        }

        protected void RequestShipmentButton_Click(object sender, EventArgs e)
        {
            Ship(true);
        }

        protected void ShipButton_Click(object sender, EventArgs e)
        {
            Ship(false);
        }

        private void Ship(bool requestTracking)
        {
            //WE HAVE TO LOOK FOR ANY ITEMS NOT BEING SHIPPED
            //BUILD A DICTIONARY OF QUANTITY TO SHIP
            bool itemFound = false;
            bool isPartial = false;
            bool quantityExceeded = false;
            Dictionary<int, short> quantities = new Dictionary<int, short>();
            foreach (GridViewRow row in ShipmentItems.Rows)
            {
                HiddenField hf = (HiddenField)row.FindControl("Id");
                int orderItemId = AlwaysConvert.ToInt(hf.Value);
                int index = _OrderShipment.OrderItems.IndexOf(orderItemId);
                if (index > -1)
                {
                    TextBox tb = (TextBox)row.FindControl("Quantity");
                    short qty = AlwaysConvert.ToInt16(tb.Text);
                    itemFound = itemFound || (qty > 0);
                    isPartial = isPartial || (qty < _OrderShipment.OrderItems[index].Quantity);
                    quantityExceeded = quantityExceeded || (qty > _OrderShipment.OrderItems[index].Quantity);
                    quantities.Add(orderItemId, qty);
                }
            }

            if ((itemFound) && (!quantityExceeded))
            {
                try
                {
                    // start transation to do it in single step
                    AbleContext.Current.Database.BeginTransaction();

                    //CHECK IF WE ARE NOT SHIPPING ALL OF THE ITEMS
                    if (isPartial)
                    {
                        //AT LEAST ONE ITEM MUST BE MOVED TO A NEW SHIPMENT
                        //CREATE A COPY OF THIS SHIPMENT
                        OrderShipment newShipment = _OrderShipment.Copy();
                        newShipment.Save();
                        _Order.Shipments.Add(newShipment);
                        //KEEP TRACK OF ITEMS TO REMOVE FROM THE CURRENT SHIPMENT
                        List<int> removeItems = new List<int>();
                        //LOOP THE ITEMS AND DECIDE WHICH TO PUT IN THE NEW SHIPMENT
                        foreach (OrderItem item in _OrderShipment.OrderItems)
                        {
                            int searchItemId = (AlwaysConvert.ToInt(item.ParentItemId) == 0) ? item.Id : AlwaysConvert.ToInt(item.ParentItemId);
                            if (quantities.ContainsKey(searchItemId))
                            {
                                short shipQty = quantities[searchItemId];
                                if (shipQty != item.Quantity)
                                {
                                    if (shipQty > 0)
                                    {
                                        //WE HAVE TO SPLIT THIS ITEM
                                        OrderItem newItem = OrderItem.Copy(item.Id, true);
                                        newItem.Quantity = (short)(item.Quantity - shipQty);
                                        newItem.OrderShipmentId = newShipment.Id;
                                        newItem.Save();
                                        newShipment.OrderItems.Add(newItem);
                                        //UPDATE THE CURRENT ITEM
                                        item.Quantity = shipQty;
                                        item.Save();
                                    }
                                    else
                                    {
                                        //THIS ITEM JUST NEEDS TO BE MOVED
                                        item.OrderShipmentId = newShipment.Id;
                                        item.Save();
                                        newShipment.OrderItems.Add(item);
                                        removeItems.Add(item.Id);
                                    }
                                }
                            }
                        }
                        //REMOVE ANY ITEMS THAT WERE MOVED TO ANOTHER SHIPMENT
                        foreach (int id in removeItems)
                        {
                            int delIndex = _OrderShipment.OrderItems.IndexOf(id);
                            if (delIndex > -1) _OrderShipment.OrderItems.RemoveAt(delIndex);
                        }
                    }

                    //Add the Tracking Number
                    int shipgwId = AlwaysConvert.ToInt(ShipGateway.SelectedValue);
                    string trackingData = AddTrackingNumber.Text.Trim();
                    if (!string.IsNullOrEmpty(trackingData))
                    {
                        TrackingNumber tnum = new TrackingNumber();
                        tnum.TrackingNumberData = trackingData;
                        tnum.ShipGatewayId = shipgwId;
                        tnum.OrderShipmentId = _OrderShipment.Id;
                        _OrderShipment.TrackingNumbers.Add(tnum);
                    }

                    //SHIP THE CURRENT SHIPMENT
                    _OrderShipment.Ship(requestTracking, LocaleHelper.LocalNow);

                    // end transaction
                    AbleContext.Current.Database.CommitTransaction();

                    //RETURN TO SHIPMENTS PAGE
                    Response.Redirect(CancelButton.NavigateUrl, false);
                }
                catch (Exception ex)
                {
                    AbleContext.Current.Database.RollbackTransaction();
                    Logger.Error(string.Format("An error occurred while trying to confirm shipment to provider: {0}", ex.Message), ex);

                    CustomValidator shipError = new CustomValidator();
                    shipError.Text = "*";
                    shipError.ErrorMessage = ex.Message;
                    shipError.IsValid = false;
                    phValidation.Controls.Add(shipError);
                }
            }
            else
            {
                CustomValidator quantityError = new CustomValidator();
                if (quantityExceeded)
                    quantityError.ErrorMessage = "You cannot move more than the existing quantity.";
                else
                    quantityError.ErrorMessage = "You must pick at least one item to move.";
                quantityError.Text = "&nbsp;";
                quantityError.IsValid = false;
                phValidation.Controls.Add(quantityError);
            }
        }
    }
}