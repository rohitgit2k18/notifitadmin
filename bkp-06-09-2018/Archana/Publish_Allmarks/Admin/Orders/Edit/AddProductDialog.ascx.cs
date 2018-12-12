namespace AbleCommerce.Admin.Orders.Edit
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Users;

    public partial class AddProductDialog : System.Web.UI.UserControl
    {
        Dictionary<int, int> _SelectedOptions = null;
        List<int> _SelectedKitProducts = null;
        private int _OrderId;
        private Order _Order;
        private int _ProductId;
        private Product _Product;
        private int _OrderShipmentId;
        private OrderShipment _OrderShipment;

        protected int OrderId
        {
            set
            {
                _OrderId = value;
                _Order = OrderDataSource.Load(_OrderId);
            }
            get { return _OrderId; }
        }

        protected int OrderShipmentId
        {
            set
            {
                _OrderShipmentId = value;
                _OrderShipment = OrderShipmentDataSource.Load(_OrderShipmentId);
                if (_OrderShipment != null) _Order = _OrderShipment.Order;
            }
            get { return _OrderShipmentId; }
        }

        public void Page_Init(object sender, EventArgs e)
        {
            if (_Order == null) OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
            if (_OrderShipment == null) OrderShipmentId = AlwaysConvert.ToInt(Request.QueryString["OrderShipmentId"]);
            if (_Order == null) Response.Redirect("~/Admin/Orders/Default.aspx");
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);


            if (_Product == null)
            {
                if (_OrderShipment == null) Response.Redirect("~/Admin/Orders/Edit/FindProduct.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
                else Response.Redirect("~/Admin/Orders/Shipments/FindProduct.aspx?OrderShipmentId=" + _OrderShipmentId.ToString());
            }

            if (_OrderShipment == null) BackButton.NavigateUrl = "~/Admin/Orders/Edit/EditOrderItems.aspx?OrderNumber=" + _Order.OrderNumber.ToString();
            else BackButton.NavigateUrl = "~/Admin/Orders/Shipments/EditShipment.aspx?OrderShipmentId=" + _OrderShipmentId.ToString();

            // update instruction text
            GiftCertMessage.Visible = _Product.IsGiftCertificate;
            DigitalGoodsMessage.Visible = _Product.IsDigitalGood;
            SubscriptionMessage.Visible = _Product.IsSubscription;

            //SET NAME AND PRICE
            Name.Text = _Product.Name;
            HiddenProductId.Value = _Product.Id.ToString();
            //BUILD PRODUCT ATTRIBUTES
            _SelectedOptions = AbleCommerce.Code.ProductHelper.BuildProductOptions(_Product, phOptions, true);
            //BUILD PRODUCT CHOICES
            AbleCommerce.Code.ProductHelper.BuildProductChoices(_Product, phOptions);
            //BUILD KIT OPTIONS
            _SelectedKitProducts = AbleCommerce.Code.ProductHelper.BuildKitOptions(_Product, phOptions);
            //SET PRICE
            string optionList = ProductVariantDataSource.GetOptionList(_Product.Id, _SelectedOptions, true);
            ProductCalculator pcalc = ProductCalculator.LoadForProduct(_Product.Id, 1, optionList, AlwaysConvert.ToList(",", _SelectedKitProducts), _Order.UserId);
            Price.Text = string.Format("{0:F2}", pcalc.Price);
            // IF ALL OPTIONS HAVE A VALUE SELECTED, SHOW THE BASKET CONTROLS
            SaveButton.Visible = (_SelectedOptions.Count >= _Product.ProductOptions.Count);
            //BackButton.NavigateUrl += "?OrderNumber=" + _Order.OrderNumber.ToString();


            //CHECK IF SHIPMENTS NEED TO BE DISPLAYED
            trShipment.Visible = (_OrderShipment == null && _Product.Shippable != Shippable.No);
            if (trShipment.Visible)
            {
                //BIND SHIPMENT LIST
                foreach (OrderShipment shipment in _Order.Shipments)
                {
                    string address = string.Format("{0} {1} {2} {3}", shipment.ShipToFirstName, shipment.ShipToLastName, shipment.ShipToAddress1, shipment.ShipToCity);
                    if (address.Length > 50) address = address.Substring(0, 47) + "...";
                    string name = "Shipment #" + shipment.ShipmentNumber + " to " + address;
                    ShipmentsList.Items.Add(new ListItem(name, shipment.Id.ToString()));
                }

                if (_Order.Shipments != null && _Order.Shipments.Count == 1)
                {
                    // IF THERE IS JUST ONLY ONE SHIPMENT THEN SELECT IT
                    ShipmentsList.SelectedIndex = 2;
                }
            }

            // if a new shipment option is selected then initialize the related fields
            DisplayOrderShipmentFields(ShipmentsList.SelectedValue == "-1"); ShipFrom.DataSource = AbleContext.Current.Store.Warehouses;
            ShipFrom.DataBind();
            if (AddressList.Items.Count <= 1) BindShippingAddresses(this.AddressList);
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            IList<OrderItem> orderItems = GetOrderItems();
            if ((orderItems != null) && (orderItems.Count > 0))
            {
                int shipmentId;
                if (_OrderShipment == null) shipmentId = AlwaysConvert.ToInt(ShipmentsList.SelectedValue);
                else shipmentId = _OrderShipmentId;

                // create a new shipment if required
                if (shipmentId == -1)
                {
                    _OrderShipment = new OrderShipment(_Order);

                    _OrderShipment.Order = _Order;
                    _OrderShipment.WarehouseId = AlwaysConvert.ToInt(ShipFrom.SelectedValue);
                    SetAddress(_OrderShipment);
                    if (ShipMethodList.SelectedIndex > -1)
                    {
                        _OrderShipment.ShipMethodId = AlwaysConvert.ToInt(ShipMethodList.SelectedItem.Value);
                        _OrderShipment.ShipMethodName = ShipMethodList.SelectedItem.Text;
                    }

                    // ADD TO ORDER, SAVE AND RECALCULATE
                    _Order.Shipments.Add(_OrderShipment);
                    _Order.Save(true, false);

                    _OrderShipmentId = _OrderShipment.Id;
                    shipmentId = _OrderShipmentId;
                }

                // JIRA: AC8-2949: FIX THE OrderBy issue
                short nextOrderBy = OrderItemDataSource.GetNextOrderBy(_OrderId);

                foreach (OrderItem item in orderItems)
                {
                    item.Order = _Order;
                    item.OrderShipmentId = shipmentId;

                    // JIRA: AC8-2949: FIX THE OrderBy issue
                    item.OrderBy = nextOrderBy++;

                    _Order.Items.Add(item);
                }
                _Order.Save(true, false);

                // IF IT IS A GIFT CERTIFICATE PRODUCT ITEM, GENERATE GIFT CERTIFICATES
                //NOTE: HAVE TO DO IT AFTER (ADDING THE ORDER ITEM TO ORDER + SAVING THE ORDER)
                foreach (OrderItem item in orderItems)
                {
                    if (item.Product != null && item.Product.IsGiftCertificate)
                    {
                        item.GenerateGiftCertificates(false);
                        item.Save();
                    }

                    //GENERATE (BUT DO NOT ACTIVATE) SUBSCRIPTIONS (IF THERE ARE ANY)
                    if (item.OrderItemType == OrderItemType.Product && item.Product != null)
                    {
                        Product product = item.Product;
                        if (product.IsSubscription)
                        {
                            SubscriptionPlan plan = product.SubscriptionPlan;
                            if (!plan.IsOptional)
                            {
                                item.IsSubscription = true;
                                item.Frequency = plan.PaymentFrequency;
                                item.FrequencyUnit = plan.PaymentFrequencyUnit;
                                item.GenerateSubscriptions(false);
                            }
                        }
                    }
                }
            }

            if (_OrderShipment == null) Response.Redirect("~/Admin/Orders/Edit/EditOrderItems.aspx?OrderNumber=" + _Order.OrderNumber.ToString());
            else Response.Redirect("~/Admin/Orders/Shipments/EditShipment.aspx?OrderShipmentId=" + _OrderShipmentId.ToString());
        }

        protected void Price_PreRender(object sender, EventArgs e)
        {
            int productId = AlwaysConvert.ToInt(HiddenProductId.Value);
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                //GET THE SELECTED KIT OPTIONS
                GetSelectedKitOptions(product);
            }
            //SET THE CURRENT CALCULATED PRICE
            string optionList = ProductVariantDataSource.GetOptionList(productId, _SelectedOptions, true);
            ProductCalculator pcalc = ProductCalculator.LoadForProduct(productId, 1, optionList, AlwaysConvert.ToList(",", _SelectedKitProducts));
            Price.Text = string.Format("{0:F2}", pcalc.Price);

            if (product.UseVariablePrice)
            {
                string varPriceText = string.Empty;
                if (product.MinimumPrice > 0)
                {
                    if (product.MaximumPrice > 0)
                    {
                        varPriceText = string.Format("(between {0} and {1})", product.MinimumPrice.LSCurrencyFormat("lcf"), product.MaximumPrice.LSCurrencyFormat("lcf"));
                    }
                    else
                    {
                        varPriceText = string.Format("(at least {0})", product.MinimumPrice.LSCurrencyFormat("lcf"));
                    }
                }
                else if (product.MaximumPrice > 0)
                {
                    varPriceText = string.Format("({0} maximum)", product.MaximumPrice.LSCurrencyFormat("lcf"));
                }
                phVariablePrice.Controls.Add(new LiteralControl(varPriceText));
            }

            // CHANGING PRODUCT PRICE OPTION SHOULD NOT AVAILABLE FOR KIT PRODUCTS
            Price.Enabled = (product.KitStatus != KitStatus.Master);

            InventoryAlertUpdate();
        }

        protected void GetSelectedKitOptions(Product product)
        {
            _SelectedKitProducts = new List<int>();
            //COLLECT ANY KIT VALUES
            foreach (ProductKitComponent pkc in product.ProductKitComponents)
            {
                // FIND THE CONTROL
                KitComponent component = pkc.KitComponent;

                if (component.InputType == KitInputType.IncludedHidden)
                {
                    foreach (KitProduct choice in component.KitProducts)
                    {
                        _SelectedKitProducts.Add(choice.Id);
                    }
                }
                else
                {
                    System.Web.UI.WebControls.WebControl inputControl = (System.Web.UI.WebControls.WebControl)AbleCommerce.Code.PageHelper.RecursiveFindControl(phOptions, component.UniqueId);
                    if (inputControl != null)
                    {
                        IList<int> kitProducts = component.GetControlValue(inputControl);
                        foreach (int selectedKitProductId in kitProducts)
                        {
                            _SelectedKitProducts.Add(selectedKitProductId);
                        }
                    }
                }
            }
        }

        protected IList<OrderItem> GetOrderItems()
        {
            //GET THE PRODUCT ID
            int productId = AlwaysConvert.ToInt(HiddenProductId.Value);
            Product product = ProductDataSource.Load(productId);
            if (product == null) return null;
            //GET THE QUANTITY
            short tempQuantity = AlwaysConvert.ToInt16(Quantity.Text);
            if (tempQuantity < 1) return null;
            if (tempQuantity > System.Int16.MaxValue) tempQuantity = System.Int16.MaxValue;

            //RECALCULATE SELECTED KIT OPTIONS
            GetSelectedKitOptions(product);
            // DETERMINE THE OPTION LIST
            string optionList = ProductVariantDataSource.GetOptionList(productId, _SelectedOptions, false);
            //CREATE THE BASKET ITEM WITH GIVEN OPTIONS

            IList<OrderItem> orderItems = OrderItemDataSource.CreateForProduct(productId, tempQuantity, optionList, AlwaysConvert.ToList(",", _SelectedKitProducts));
            if (orderItems.Count > 0)
            {
                // COLLECT ANY ADDITIONAL INPUTS FOR BASE ITEM
                AbleCommerce.Code.ProductHelper.CollectProductTemplateInput(orderItems[0], phOptions);

                // UPADATE THE PRICE OF BASE ITEM IF NEEDED ( KIT PRICE WILL NOT BE MODIFIED)
                if (orderItems[0].Price != AlwaysConvert.ToDecimal(Price.Text) && (product.KitStatus != KitStatus.Master))
                {
                    orderItems[0].Price = AlwaysConvert.ToDecimal(Price.Text);
                }
            }
            return orderItems;
        }

        protected void InventoryAlertUpdate()
        {
            if (_Product != null)
            {
                // WE HAVE A VALID PRODUCT, ARE ANY AVAILABLE OPTIONS SELECTED?
                bool allProductOptionsSelected = (_SelectedOptions.Count == _Product.ProductOptions.Count);
                if (allProductOptionsSelected)
                {
                    // OPTIONS ARE GOOD, VERIFY ANY REQUIRED KIT OPTIONS ARE SELECTED
                    GetSelectedKitOptions(_Product);
                    bool requiredKitOptionsSelected = AbleCommerce.Code.ProductHelper.RequiredKitOptionsSelected(_Product, _SelectedKitProducts);
                    if (requiredKitOptionsSelected)
                    {
                        // KIT OPTIONS ARE ALSO VALID, DETERMINE APPROPRIATE WARNINGS
                        Store store = AbleContext.Current.Store;
                        List<string> warningMessages = new List<string>();

                        string optionList = string.Empty;
                        if (_Product.ProductOptions.Count > 0)
                        {
                            // OPTIONS ARE PRESENT, CHECK AVAILABLILITY
                            optionList = ProductVariantDataSource.GetOptionList(_ProductId, _SelectedOptions, true);
                            ProductVariant variant = ProductVariantDataSource.LoadForOptionList(_Product.Id, optionList);
                            if (!variant.Available) warningMessages.Add("The selected variant is marked as unavailable.");

                            // WE ALSO NEED TO ALERT INVENTORY IF ENABLED AT VARIANT LEVEL AND THIS IS NOT A KIT
                            if (store.Settings.EnableInventory
                                && _Product.KitStatus != KitStatus.Master
                                && _Product.InventoryMode == InventoryMode.Variant)
                                warningMessages.Add("The selected variant has a current stock level of " + variant.InStock + ".");
                        }

                        // CHECK STOCK QUANTITY FOR PRODUCT, IF STORE INVENTORY IS ENABLED
                        // AND THE STOCK IS MANAGED AT THE PRODUCT LEVEL OR THIS IS A KIT
                        if (store.Settings.EnableInventory && (_Product.InventoryMode == InventoryMode.Product || _Product.KitStatus == KitStatus.Master))
                        {
                            IInventoryManager inventoryManager = AbleContext.Resolve<IInventoryManager>();
                            InventoryManagerData inv = inventoryManager.CheckStock(_ProductId, optionList, _SelectedKitProducts);
                            if (!inv.AllowBackorder)
                            {
                                if (_Product.KitStatus == KitStatus.Master)
                                {
                                    // INVENTORY MESSAGE FOR KIT PRODUCTS
                                    warningMessages.Add("The selected configuration has a current stock level of " + inv.InStock + ".");
                                }
                                else
                                {
                                    // NOT KIT OR VARIANT
                                    warningMessages.Add("This product has a current stock level of " + inv.InStock + ".");
                                }
                            }
                        }

                        // SHOW ANY WARNING MESSAGES
                        if (warningMessages.Count > 0)
                        {
                            InventoryWarningMessage.Text = "Note: " + string.Join(" ", warningMessages.ToArray());
                            trInventoryWarning.Visible = true;
                        }
                    }
                }
            }
        }

        protected void ShipmentsList_SelectedIndexChanged(object sender, EventArgs e)
        {
            int shipmentId = AlwaysConvert.ToInt(ShipmentsList.SelectedValue);
            if (shipmentId == -1) DisplayOrderShipmentFields(true);
            else DisplayOrderShipmentFields(false);
        }

        private void DisplayOrderShipmentFields(bool show)
        {
            if (show)
            {
                ShipFrom.DataSource = AbleContext.Current.Store.Warehouses;
                ShipFrom.DataBind();
                if(AddressList.Items.Count <=1) BindShippingAddresses(this.AddressList);
            }

            trNewShipmentFrom.Visible = show;
            trNewShipmentAddress.Visible = show;
            trNewShipmentShipMethod.Visible = show;
        }

        protected void BindShippingAddresses(DropDownList shippingAddress)
        {
            // keep selected value
            string selectedValue = AddressList.SelectedItem.Value;

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

            // restore selected value
            int selectedAddressId = AlwaysConvert.ToInt(selectedValue);
            if (selectedAddressId > 0) 
            {
                ListItem item = AddressList.Items.FindByValue(selectedValue);
                AddressList.SelectedItem.Selected = false;
                item.Selected = true;
            }
        }

        private string GetAddressItemText(string firstName, string lastName, string streetAddress, string city)
        {
            string itemText = firstName + " " + lastName + " " + streetAddress;
            if (itemText.Length > 40) itemText = itemText.Substring(0, 37) + "...";
            return itemText + " " + city;
        }

        private void SetAddress(OrderShipment newShipment)
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
    }
}