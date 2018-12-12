namespace AbleCommerce.Admin.Orders.Shipments
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers;
    using CommerceBuilder.Utility;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Order _Order;

        protected void Page_Load(object sender, EventArgs e)
        {
            int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(orderId);
            if (_Order == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Orders/Default.aspx"));
            Caption.Text = string.Format(Caption.Text, _Order.OrderNumber);
            BindShipmentsGrid();
            AddShipmentLink.NavigateUrl = "AddShipment.aspx?OrderNumber=" + _Order.OrderNumber.ToString();
        }

        protected string GetTrackingUrl(object dataItem)
        {
            TrackingNumber trackingNumber = (TrackingNumber)dataItem;
            if (trackingNumber.ShipGateway != null)
            {
                IShippingProvider provider = trackingNumber.ShipGateway.GetProviderInstance();
                TrackingSummary summary = provider.GetTrackingSummary(trackingNumber);
                if (summary != null)
                {
                    // TRACKING DETAILS FOUND
                    if (summary.TrackingResultType == TrackingResultType.InlineDetails)
                    {
                        // send to view tracking page
                        return string.Format("ViewTrackingNumber.aspx?TrackingNumberId={0}", trackingNumber.Id.ToString());
                    }
                    else if (summary.TrackingResultType == TrackingResultType.ExternalLink)
                    {
                        return summary.TrackingLink;
                    }
                }
            }
            return string.Empty;
        }

        protected int OrderNumber
        {
            get
            {
                return _Order.OrderNumber;
            }
        }

        protected string GetShipToAddress(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            return shipment.FormatToAddress(true);
        }

        protected string GetSku(object dataItem)
        {
            OrderItem orderItem = (OrderItem)dataItem;
            if (orderItem.OrderItemType == OrderItemType.Product) return orderItem.Sku;
            return StringHelper.SpaceName(orderItem.OrderItemType.ToString());
        }

        protected bool ShowSplitLink(Object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            //DO NOT DISPLAY IF THIS SHIPMENT IS ALREADY SHIPPED
            if (shipment.IsShipped) return false;
            //ONLY DISPLAY IF THERE IS MORE THAN ONE PRODUCT IN THE SHIPMENT
            return (shipment.OrderItems.ProductCount() > 1);
        }

        protected bool ShowMergeLink(Object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            //DO NOT DISPLAY IF THIS SHIPMENT IS ALREADY SHIPPED
            if (shipment.IsShipped) return false;
            foreach (OrderShipment otherShipment in _Order.Shipments)
            {
                //IF THERE IS MORE THAN ONE UNSHIPPED SHIPMENT, SHOW THE MERGE BUTTON
                if ((shipment.Id != otherShipment.Id) && (!otherShipment.IsShipped)) return true;
            }
            return false;
        }

        /// <summary>
        /// Determines if a shipment is empty
        /// </summary>
        /// <param name="dataItem">OrderShipment object</param>
        /// <returns>True if the shipment contains no products</returns>
        /// <remarks>Used to determine whether to use simple or advanced delete</remarks>
        protected bool ShowDeleteLink(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            foreach (OrderItem item in shipment.OrderItems)
            {
                if (item.OrderItemType == OrderItemType.Product)
                    return false;
            }
            return true;
        }

        /// <summary>
        /// Determines if a shipment can be voided
        /// </summary>
        /// <param name="dataItem">OrderShipment object</param>
        /// <returns>True if the shipment can be cancelled/voided</returns>
        protected bool ShowVoidButton(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            if (shipment.TrackingNumbers.Count > 0 &&
                shipment.ShipMethod != null &&
                shipment.ShipMethod.ShipGateway != null &&
                shipment.ShipMethod.ShipGateway.GetProviderInstance().IsShippingSupported)
                return true;

            return false;
        }

        protected bool ShowDeleteButton(object dataItem)
        {
            // DO NOT SHOW BUTTON IF LINK IS VISIBLE
            if (ShowDeleteLink(dataItem)) return false;

            // WE CAN ONLY DELETE IF THE SHIPMENT IS NOT SHIPPED
            OrderShipment shipment = (OrderShipment)dataItem;
            return !shipment.IsShipped;
        }

        protected void EditShipmentsGrid_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DelShp")
            {
                int shipmentId = AlwaysConvert.ToInt(e.CommandArgument);
                int index = _Order.Shipments.IndexOf(shipmentId);
                if (index > -1)
                {
                    OrderShipment shipment = _Order.Shipments[index];

                    // DELETE FROM ORDER
                    _Order.Shipments.Remove(shipment);
                    foreach (OrderItem item in shipment.OrderItems)
                    {
                        _Order.Items.Remove(item);
                    }

                    _Order.Save(true, false);
                    BindShipmentsGrid();
                }
            }
            else if (e.CommandName == "ChangeShipMethod")
            {
                int shipmentId = AlwaysConvert.ToInt(e.CommandArgument);
                int index = _Order.Shipments.IndexOf(shipmentId);
                if (index > -1)
                {
                    // SHOW THE CHANGE SHIPMENT POPUP
                    ChangeShipMethodShipmentId.Value = shipmentId.ToString();
                    ChangeShipMethodDialogCaption.Text = string.Format(ChangeShipMethodDialogCaption.Text, index + 1);
                    OrderShipment shipment = _Order.Shipments[index];
                    ExistingShipMethod.Text = shipment.ShipMethodName;

                    // GENERATE RATE QUOTES FOR ALL SHIPPING METHODS
                    List<ShipRateQuote> rateQuotes = new List<ShipRateQuote>();
                    IList<ShipMethod> shipMethods = ShipMethodDataSource.LoadAll();
                    foreach (ShipMethod method in shipMethods)
                    {
                        ShipRateQuote quote = method.GetShipRateQuote(shipment);
                        if (quote != null) rateQuotes.Add(quote);
                    }

                    // GET LIST OF SHIPPING METHODS THAT WOULD BE AVAILABLE TO THE CUSTOMER
                    IList<ShipMethod> customerShipMethods = ShipMethodDataSource.LoadForShipment(shipment);

                    // ADD RATE QUOTES TO THE DROPDOWN
                    foreach (ShipRateQuote quote in rateQuotes)
                    {
                        string name = string.Format("{0} : {1}", quote.Name, quote.Rate.LSCurrencyFormat("lc"));
                        if (customerShipMethods.IndexOf(quote.ShipMethodId) < 0)
                        {
                            // SHOW NOTE IF HIDDEN SHIPPING METHODS ARE AVAIALBLE
                            name = "** " + name;
                            HiddenShipMethodWarning.Visible = true;
                        }
                        NewShipMethod.Items.Add(new ListItem(name, quote.ShipMethodId.ToString()));
                    }
                    ChangeShipMethodPopup.Show();
                }
            }
            else if (e.CommandName == "VoidShp")
            {
                int shipmentId = AlwaysConvert.ToInt(e.CommandArgument);
                int index = _Order.Shipments.IndexOf(shipmentId);
                if (index > -1)
                {
                    OrderShipment shipment = _Order.Shipments[index];
                    shipment.Void();
                    
                    _Order.Save(true, false);
                    BindShipmentsGrid();
                }
            }
        }

        protected bool IsReturnButtonVisible(Object dataItem)
        {
            bool visible = true;
            OrderShipment shipment = (OrderShipment)dataItem;
            visible = shipment.IsShipped;
            if (visible)
            {
                // IF COUNT OF RETURN_ABLE ITEMS MORE THEN ZERO
                int count = 0;
                foreach (OrderItem oi in shipment.OrderItems)
                {
                    if (oi.OrderItemType == OrderItemType.Product) count++;
                }
                if (count == 0) visible = false;
            }
            return visible;
        }

        protected void ChangeShipMethodOKButton_Click(object source, EventArgs e)
        {
            int shipmentId = AlwaysConvert.ToInt(Request.Form[ChangeShipMethodShipmentId.UniqueID]);
            int index = _Order.Shipments.IndexOf(shipmentId);
            if (index > -1)
            {
                // WE FOUND THE TARGET SHIPMENT. REMOVE OLD SHIPPING LINE ITEMS
                OrderShipment shipment = _Order.Shipments[index];
                for (int i = shipment.OrderItems.Count - 1; i >= 0; i--)
                {
                    OrderItemType itemType = shipment.OrderItems[i].OrderItemType;
                    if (itemType == OrderItemType.Shipping || itemType == OrderItemType.Handling)
                    {
                        shipment.OrderItems.DeleteAt(i);
                    }
                }

                // SEE IF WE HAVE A NEW SELECTED SHIPMETHOD
                int shipMethodId = AlwaysConvert.ToInt(Request.Form[NewShipMethod.UniqueID]);
                ShipMethod shipMethod = ShipMethodDataSource.Load(shipMethodId);
                if (shipMethod != null)
                {
                    ShipRateQuote rate = shipMethod.GetShipRateQuote(shipment);
                    if (rate != null)
                    {
                        // ADD NEW SHIPPING LINE ITEMS TO THE ORDER
                        OrderItem shipRateLineItem = new OrderItem();
                        shipRateLineItem.OrderId = _Order.Id;
                        shipRateLineItem.OrderItemType = OrderItemType.Shipping;
                        shipRateLineItem.OrderShipmentId = shipmentId;
                        shipRateLineItem.Name = shipMethod.Name;
                        shipRateLineItem.Price = rate.Rate;
                        shipRateLineItem.Quantity = 1;
                        shipRateLineItem.TaxCodeId = shipMethod.TaxCodeId;
                        shipRateLineItem.Save();
                        shipment.OrderItems.Add(shipRateLineItem);
                        if (rate.Surcharge > 0)
                        {
                            shipRateLineItem = new OrderItem();
                            shipRateLineItem.OrderId = _Order.Id;
                            shipRateLineItem.OrderItemType = OrderItemType.Handling;
                            shipRateLineItem.OrderShipmentId = shipmentId;
                            shipRateLineItem.Name = shipMethod.Name;
                            shipRateLineItem.Price = rate.Surcharge;
                            shipRateLineItem.Quantity = 1;
                            shipRateLineItem.TaxCodeId = shipMethod.TaxCodeId;
                            shipRateLineItem.Save();
                            shipment.OrderItems.Add(shipRateLineItem);
                        }

                        //Add the Tracking Number
                        ShipGateway shipGateway = shipMethod.ShipGateway;
                        foreach (TrackingNumber tn in shipment.TrackingNumbers)
                        {
                            tn.ShipGateway = shipGateway;
                        }

                    }
                }

                // UPDATE THE SHIPMENT WITH NEW METHOD ASSOCIATION
                shipment.ShipMethodId = shipMethodId;
                shipment.ShipMethodName = (shipMethod != null ? shipMethod.Name : string.Empty);
                shipment.Save();

                // RELOAD ORDER AND REBIND THE PAGE FOR UPDATED INFO
                _Order = OrderDataSource.Load(_Order.Id);
                BindShipmentsGrid();
            }
        }

        protected string GetShipFromAddress(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            return shipment.FormatFromAddress(true);
        }

        protected bool ShowShipMessage(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            return !string.IsNullOrEmpty(shipment.ShipMessage);
        }

        protected bool ShowTracking(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            return shipment.TrackingNumbers.Count > 0;
        }

        protected bool ShowLabelLink(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            return shipment.LabelImages.Count > 0;
        }

        private void BindShipmentsGrid()
        {
            // AC8-2888: REMOVE ORDER OBJECT FROM SESSION CACHE BEFORE BINDING SHIPMENTS GRID TO FIX CACHING ISSUE
            AbleContext.Current.Database.GetSession().Evict(_Order);
            _Order = OrderDataSource.Load(AbleCommerce.Code.PageHelper.GetOrderId());

            EditShipmentsGrid.DataSource = _Order.Shipments;
            EditShipmentsGrid.DataBind();
        }

        protected IList<OrderItem> GetShipmentItems(int shipmentId)
        {
            return _Order.Items.GetDisplayItems(shipmentId);
        }

        protected bool ShipButtonVisible(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            if(!shipment.ShipDate.Equals(System.DateTime.MinValue)) return false;
            if (!shipment.Order.OrderStatus.IsValid) return false;

            foreach (OrderItem item in shipment.OrderItems)
            {
                // WE ALREDY KNOW IF THERE IS A PRODUCT IN SHIPMENT IT MUST BE SHIPPABLE AT THE TIME WHEN GET ADDED TO ORDER
                if (item.OrderItemType == OrderItemType.Product) return true;
            }

            return false;
        }
    }
}