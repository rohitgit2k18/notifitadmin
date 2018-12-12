namespace AbleCommerce.Admin.Orders.Edit
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;
    using CommerceBuilder.Taxes.Providers.TaxCloud;

    public partial class EditOrderItems : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId;
        private Order _Order;

        protected void Page_Init(object sender, EventArgs e)
        {
            _OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(_OrderId);
            if (_Order == null) Response.Redirect("Default.aspx");
            string suffix = "?OrderNumber=" + _Order.OrderNumber;
            AddProductLink.NavigateUrl += suffix;
            AddOtherItemLink.NavigateUrl += suffix;
            RecalculateTaxesButton.Visible = TaxHelper.IsATaxProviderEnabled();
            BindGrids();

            TaxExemptionMessagePanel.Visible = !string.IsNullOrEmpty(this._Order.TaxExemptionReference);
            if (TaxExemptionMessagePanel.Visible) TaxExemptionMessage.Text = string.Format(TaxExemptionMessage.Text, this._Order.TaxExemptionReference);

            // WE DON'T SUPPORT TAX CLOUD TAX RECALCULATION
            TaxGateway taxGateway = null;
            TaxCloudProvider taxProvider = null;
            int taxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(TaxCloudProvider)));
            if (taxGatewayId > 0) taxGateway = TaxGatewayDataSource.Load(taxGatewayId);
            if (taxGateway != null) taxProvider = taxGateway.GetProviderInstance() as TaxCloudProvider;
            if (taxProvider != null && taxProvider.EnableTaxCloud)
            {
                TaxCloudWarningMessagePanel.Visible = true;
                TaxCloudReclaculationMessage.Text = string.Format(TaxCloudReclaculationMessage.Text, _Order.OrderNumber);
            }
        }

        protected void ShipmentCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Recalc")
            {
                int itemId = AlwaysConvert.ToInt(e.CommandArgument);
                int index = _Order.Shipments.IndexOf(itemId);
                if (index > -1)
                {
                    OrderShipment shipment = _Order.Shipments[index];
                    ShipMethod shipMethod = shipment.ShipMethod;
                    if (shipMethod != null)
                    {
                        ShipRateQuote rate = shipMethod.GetShipRateQuote(shipment);
                        if (rate != null)
                        {
                            // REMOVE OLD SHIPPING CHARGES FOR THIS SHIPMENT
                            for (int i = _Order.Items.Count - 1; i >= 0; i--)
                            {
                                OrderItem item = _Order.Items[i];
                                if (item.OrderShipmentId == shipment.Id)
                                {
                                    if (item.OrderItemType == OrderItemType.Shipping || item.OrderItemType == OrderItemType.Handling)
                                    {
                                        _Order.Items.DeleteAt(i);
                                    }
                                }
                            }

                            // ADD NEW SHIPPING LINE ITEMS TO THE ORDER
                            OrderItem shipRateLineItem = new OrderItem();
                            shipRateLineItem.OrderId = _Order.Id;
                            shipRateLineItem.OrderItemType = OrderItemType.Shipping;
                            shipRateLineItem.OrderShipmentId = shipment.Id;
                            shipRateLineItem.Name = shipMethod.Name;
                            shipRateLineItem.Price = rate.Rate;
                            shipRateLineItem.Quantity = 1;
                            shipRateLineItem.TaxCodeId = shipMethod.TaxCodeId;
                            _Order.Items.Add(shipRateLineItem);
                            if (rate.Surcharge > 0)
                            {
                                shipRateLineItem = new OrderItem();
                                shipRateLineItem.OrderId = _Order.Id;
                                shipRateLineItem.OrderItemType = OrderItemType.Handling;
                                shipRateLineItem.OrderShipmentId = shipment.Id;
                                shipRateLineItem.Name = shipMethod.Name;
                                shipRateLineItem.Price = rate.Surcharge;
                                shipRateLineItem.Quantity = 1;
                                shipRateLineItem.TaxCodeId = shipMethod.TaxCodeId;
                                _Order.Items.Add(shipRateLineItem);
                            }
                            _Order.Save(true, false);
                            BindGrids();
                            ShippingRecalculatedMessage.Visible = true;
                        }
                    }
                }
            }
        }

        protected void ItemsGrid_DataBound(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.Columns[4].Visible = TaxHelper.ShowTaxColumn;
        }

        protected void ItemsGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int itemId = AlwaysConvert.ToInt(e.CommandArgument);
            int index = _Order.Items.IndexOf(itemId);
            if (index > -1)
            {
                switch (e.CommandName)
                {
                    case "DeleteItem":
                        _Order.Items.RemoveAt(index);
                        _Order.Save(true, false);
                        BindGrids();
                        break;
                    case "EditItem":
                        OrderItem item = _Order.Items[index];
                        GiftCertMessage.Visible = item.GiftCertificates.Count > 0;
                        EditItemDialogCaption.Text = "Edit " + item.Name;
                        EditItemName.Text = item.Name;
                        EditItemQuantity.Text = item.Quantity.ToString();
                        EditItemPrice.Text = item.Price.ToString("F2");
                        EditItemId.Value = itemId.ToString();
                        EditItemPopup.Show();
                        break;
                }
            }
        }

        protected void SaveEditButton_Click(object sender, EventArgs e)
        {
            int itemId = AlwaysConvert.ToInt(EditItemId.Value);
            int index = _Order.Items.IndexOf(itemId);
            if (index > -1)
            {
                OrderItem orderItem = _Order.Items[index];
                orderItem.Price = AlwaysConvert.ToDecimal(EditItemPrice.Text);
                orderItem.Quantity = AlwaysConvert.ToInt16(EditItemQuantity.Text);

                // Do not allow positive values for Discount/Credit or negative values for charge
                switch (orderItem.OrderItemTypeId)
                {
                    case ((short)OrderItemType.Discount):
                    case ((short)OrderItemType.Credit):
                        if (orderItem.Price > 0) orderItem.Price = Decimal.Negate((Decimal)orderItem.Price);
                        break;
                    case ((short)OrderItemType.Charge):
                        if (orderItem.Price < 0) orderItem.Price = Decimal.Negate((Decimal)orderItem.Price);
                        break;
                    default:
                        break;
                }

                // UPDATE THE CALCULATED SUMMARY VALUES OF ORDER
                _Order.Save(true, false);
                BindGrids();
            }
            EditItemPopup.Hide();
        }
        
        protected void RecalculateTaxesButton_OnClick(object sender, EventArgs e)
        {
            // RECALCULATE TAXES FOR THE ORDER
            TaxCalculator.Recalculate(_Order);
            //OrderItemGrid.DataBind();
            TaxesRecalculatedMessage.Visible = true;
            BindGrids();
        }

        protected void OrderItemDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["orderId"] = AbleCommerce.Code.PageHelper.GetOrderId();
        }

        protected string GetShipToAddress(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            return shipment.FormatToAddress(true);
        }

        protected string GetShipFromAddress(object dataItem)
        {
            OrderShipment shipment = (OrderShipment)dataItem;
            return shipment.FormatFromAddress(true);
        }

        private void BindGrids()
        {
            EditShipmentsGrid.DataSource = _Order.Shipments;
            EditShipmentsGrid.DataBind();
            IList<OrderItem> nonShippingItems = OrderHelper.GetNonShippingItems(_Order);
            if (nonShippingItems.Count > 0)
            {
                NonShippingItemsGrid.DataSource = nonShippingItems;
                NonShippingItemsGrid.DataBind();
            }
            else
            {
                NonShippingItemsPanel.Visible = false;
            }
        }

        protected IList<OrderItem> GetShipmentItems(int shipmentId)
        {
            IList<OrderItem> newCollection = new List<OrderItem>();
            foreach (OrderItem item in _Order.Items)
            {
                if (item.OrderShipmentId == shipmentId)
                {
                    newCollection.Add(item);
                }
            }

            newCollection.Sort(new OrderItemComparer());
            return newCollection;
        }
    }
}