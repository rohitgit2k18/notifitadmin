namespace AbleCommerce.Admin.Orders.Shipments
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class AddShipment : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Order _Order;

        protected void Page_Init(object sender, EventArgs e)
        {
            int orderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(orderId);
            if (_Order == null) Response.Redirect("../Default.aspx");
            Caption.Text = string.Format(Caption.Text, _Order.OrderNumber);
            ShipFrom.DataSource = AbleContext.Current.Store.Warehouses;
            ShipFrom.DataBind();
            ShipToCountryCode.DataSource = AbleContext.Current.Store.Countries;
            ShipToCountryCode.DataTextField = "Name";
            ShipToCountryCode.DataValueField = "CountryCode";
            ShipToCountryCode.DataBind();
            BindShippingAddresses(this.AddressList);
        }

        protected void BindShippingAddresses(DropDownList shippingAddress)
        {
            // BIND (OR RE-BIND) SHIPPING ADDRESSES
            string itemText;

            // ADD SHIP TO ADDRESSES
            foreach (OrderShipment shipment in _Order.Shipments)
            {
                itemText = GetAddressItemText(shipment.ShipToFirstName, shipment.ShipToLastName, shipment.ShipToAddress1, shipment.ShipToCity);
                if (shippingAddress.Items.FindByText(itemText) == null)
                {
                    shippingAddress.Items.Add(new ListItem(itemText, "S_" + shipment.Id));
                }
            }

            // ADD ADDRESSES FROM USER ADDRESS BOOK
            IList<Address> userAddresses = AddressDataSource.LoadForUser(_Order.UserId);
            foreach (Address address in userAddresses)
            {
                itemText = GetAddressItemText(address.FirstName, address.LastName, address.Address1, address.City);
                if (shippingAddress.Items.FindByText(itemText) == null)
                {
                    shippingAddress.Items.Add(new ListItem(itemText, address.Id.ToString()));
                }
            }

            // ADD ORDER BILL TO ADDRESS
            itemText = GetAddressItemText(_Order.BillToFirstName, _Order.BillToLastName, _Order.BillToAddress1, _Order.BillToCity);
            if (shippingAddress.Items.FindByText(itemText) == null)
            {
                shippingAddress.Items.Insert(0, new ListItem(itemText, "B_" + _Order.Id));
            }

            // ADD NEW ITEM
            shippingAddress.Items.Add(new ListItem("Add new..."));
        }

        private string GetAddressItemText(string firstName, string lastName, string streetAddress, string city)
        {
            string itemText = firstName + " " + lastName + " " + streetAddress;
            if (itemText.Length > 40) itemText = itemText.Substring(0, 37) + "...";
            return itemText + " " + city;
        }

        private void SetAddress(OrderShipment newShipment)
        {
            if (AddressList.SelectedIndex < (AddressList.Items.Count - 1))
            {
                string selectedValue = AddressList.SelectedItem.Value;
                //USE EXISTING ADDRESS
                if (selectedValue.StartsWith("B_"))
                {
                    //USE ORDER BILLING ADDRESS
                    newShipment.ShipToFirstName = _Order.BillToFirstName;
                    newShipment.ShipToLastName = _Order.BillToLastName;
                    newShipment.ShipToAddress1 = _Order.BillToAddress1;
                    newShipment.ShipToAddress2 = _Order.BillToAddress2;
                    newShipment.ShipToCity = _Order.BillToCity;
                    newShipment.ShipToProvince = _Order.BillToProvince;
                    newShipment.ShipToPostalCode = _Order.BillToPostalCode;
                    newShipment.ShipToCountryCode = _Order.BillToCountryCode;
                    newShipment.ShipToPhone = _Order.BillToPhone;
                    newShipment.ShipToCompany = _Order.BillToCompany;
                    newShipment.ShipToFax = _Order.BillToFax;
                    newShipment.ShipToResidence = true;
                }
                else if (selectedValue.StartsWith("S_"))
                {
                    //USE SHIPPING ADDRESS
                    int shipmentId = AlwaysConvert.ToInt(AddressList.SelectedItem.Value.Split('_')[1]);
                    int index = _Order.Shipments.IndexOf(shipmentId);
                    if (index > -1)
                    {
                        OrderShipment shipment = _Order.Shipments[index];
                        newShipment.ShipToFirstName = shipment.ShipToFirstName;
                        newShipment.ShipToLastName = shipment.ShipToLastName;
                        newShipment.ShipToAddress1 = shipment.ShipToAddress1;
                        newShipment.ShipToAddress2 = shipment.ShipToAddress2;
                        newShipment.ShipToCity = shipment.ShipToCity;
                        newShipment.ShipToProvince = shipment.ShipToProvince;
                        newShipment.ShipToPostalCode = shipment.ShipToPostalCode;
                        newShipment.ShipToCountryCode = shipment.ShipToCountryCode;
                        newShipment.ShipToPhone = shipment.ShipToPhone;
                        newShipment.ShipToCompany = shipment.ShipToCompany;
                        newShipment.ShipToFax = shipment.ShipToFax;
                        newShipment.ShipToResidence = shipment.ShipToResidence;
                    }
                }
                else
                {
                    //USE ADDRESS FROM ADDRESS BOOK
                    int addressId = AlwaysConvert.ToInt(selectedValue);
                    Address address = AddressDataSource.Load(addressId);
                    newShipment.ShipToFirstName = address.FirstName;
                    newShipment.ShipToLastName = address.LastName;
                    newShipment.ShipToAddress1 = address.Address1;
                    newShipment.ShipToAddress2 = address.Address2;
                    newShipment.ShipToCity = address.City;
                    newShipment.ShipToProvince = address.Province;
                    newShipment.ShipToPostalCode = address.PostalCode;
                    newShipment.ShipToCountryCode = address.CountryCode;
                    newShipment.ShipToPhone = address.Phone;
                    newShipment.ShipToCompany = address.Company;
                    newShipment.ShipToFax = address.Fax;
                    newShipment.ShipToResidence = address.Residence;
                }
            }
            else
            {
                //ADD A NEW ADDRESS
                newShipment.ShipToFirstName = ShipToFirstName.Text;
                newShipment.ShipToLastName = ShipToLastName.Text;
                newShipment.ShipToAddress1 = ShipToAddress1.Text;
                newShipment.ShipToAddress2 = ShipToAddress2.Text;
                newShipment.ShipToCity = ShipToCity.Text;
                newShipment.ShipToProvince = ShipToProvince.Text;
                newShipment.ShipToPostalCode = ShipToPostalCode.Text;
                newShipment.ShipToCountryCode = ShipToCountryCode.SelectedValue;
                newShipment.ShipToPhone = ShipToPhone.Text;
                newShipment.ShipToCompany = ShipToCompany.Text;
                newShipment.ShipToResidence = ShipToAddressType.SelectedIndex == 0;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            OrderShipment newShipment = new OrderShipment();
            newShipment.Order = _Order;
            newShipment.WarehouseId = AlwaysConvert.ToInt(ShipFrom.SelectedValue);
            SetAddress(newShipment);
            if (ShipMethodList.SelectedIndex > -1)
            {
                newShipment.ShipMethodId = AlwaysConvert.ToInt(ShipMethodList.SelectedItem.Value);
                newShipment.ShipMethodName = ShipMethodList.SelectedItem.Text;
                decimal shippingCost = AlwaysConvert.ToDecimal(ShipCharges.Text);
                if (shippingCost > 0)
                {
                    // Add Shipping & Handling item
                    OrderItem shippingCharge = new OrderItem();
                    shippingCharge.Name = ShipMethodList.SelectedItem.Text;
                    shippingCharge.OrderItemType = OrderItemType.Shipping;
                    shippingCharge.Price = AlwaysConvert.ToDecimal(ShipCharges.Text);
                    shippingCharge.Order = newShipment.Order;
                    shippingCharge.Quantity = 1;
                    shippingCharge.OrderShipment = newShipment;
                    newShipment.OrderItems.Add(shippingCharge);

                    // ADD TO ORDER ITEMS
                    _Order.Items.Add(shippingCharge);
                }
            }
            newShipment.ShipMessage = ShipMessage.Text;
            
            // ADD TO ORDER, SAVE AND RECALCULATE
            _Order.Shipments.Add(newShipment);
            _Order.Save(true, false);
            Response.Redirect("Default.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            trNewAddress.Visible = (AddressList.SelectedIndex == (AddressList.Items.Count - 1));
            trShipCharge.Visible = (ShipMethodList.SelectedIndex != 0);
        }
    }
}