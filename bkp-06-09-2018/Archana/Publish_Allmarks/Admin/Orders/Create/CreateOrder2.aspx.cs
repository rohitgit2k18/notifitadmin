//-----------------------------------------------------------------------
// <copyright file="CreateOrder2.aspx.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Admin.Orders.Create
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;

    public partial class CreateOrder2 : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _UserId;
        private User _User;
        private Basket _Basket;
        private OrderItemType[] displayItemTypes = { OrderItemType.Product, OrderItemType.Discount };
        private Dictionary<int, int> _SelectedOptions = null;
        List<int> _SelectedKitProducts = null;
        IInventoryManager _InventoryManager;
        private bool _StoreInventoryEnabled;

        protected void Page_Load(object sender, EventArgs e)
        {
            // LOCATE THE USER THAT THE ORDER IS BEING PLACED FOR
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UID"]);
            _User = UserDataSource.Load(_UserId);
            if (_User == null) Response.Redirect("CreateOrder1.aspx");
            _Basket = _User.Basket;

            // INITIALIZE INVENTORY VARIABLES
            _InventoryManager = AbleContext.Resolve<IInventoryManager>();
            _StoreInventoryEnabled = AbleContext.Current.Store.Settings.EnableInventory;

            // SHOW QUANTITY AVAILABLE COLUMN IF INVENTORY IS ENABLED
            BasketGrid.Columns[4].Visible = _StoreInventoryEnabled;

            // INITIALIZE THE CAPTION
            string userName = _User.IsAnonymous ? "Unregistered User" : _User.UserName;
            Caption.Text = string.Format(Caption.Text, userName);

            // SEE IF THE ADD PRODUCT FORM SHOULD BE VISIBLE
            int productId = AlwaysConvert.ToInt(Request.Form[AddProductId.UniqueID]);
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                ShowProductForm(product);
            }
        }

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            // GET THE BASKET AND RECALCULATE IT
            IBasketService service = AbleContext.Resolve<IBasketService>();
            service.Combine(_Basket);
            service.Recalculate(_Basket);

            // BIND THE BASKET GRID
            BindBasketGrid();
            InventoryAlertUpdate();
        }

        protected string GetConfirmDelete(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            string name = item.Name;
            if (item.OrderItemType == OrderItemType.Product && item.ProductVariant != null)
            {
                name += " (" + item.ProductVariant.VariantName + ")";
            }
            return string.Format("return confirm('Are you sure you want to delete {0}?\')", name.Replace("'", "\\'"));
        }

        private void BindBasketGrid()
        {
            IList<BasketItem> displayItems = new List<BasketItem>();
            foreach (BasketItem item in _Basket.Items)
            {
                if (Array.IndexOf(displayItemTypes, item.OrderItemType) > -1)
                {
                    if (item.OrderItemType == OrderItemType.Product && item.IsChildItem)
                    {
                        // WHETHER THE CHILD ITEM DISPLAYS DEPENDS ON THE ROOT
                        BasketItem rootItem = item.GetParentItem(true);
                        if (rootItem != null && rootItem.Product != null && rootItem.Product.Kit != null && rootItem.Product.Kit.ItemizeDisplay)
                        {
                            // ITEMIZED DISPLAY ENABLED, SHOW THIS CHILD ITEM
                            displayItems.Add(item);
                        }
                    }
                    else
                    {
                        // NO ADDITIONAL CHECK REQUIRED TO INCLUDE ROOT PRODUCTS OR NON-PRODUCTS
                        displayItems.Add(item);
                    }
                }
            }
            displayItems.Sort(new BasketItemComparer());
            BasketGrid.DataSource = displayItems;
            BasketGrid.DataBind();
        }

        protected void BasketGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // COMBINE FOOTER CELLS FOR SUBTOTAL
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                if (e.Row.Cells.Count > 2)
                {
                    // account for possibly hidden in stock column
                    int colspan = e.Row.Cells.Count - (_StoreInventoryEnabled ? 1 : 2);
                    int iterations = e.Row.Cells.Count - 3;
                    for (int i = 0; i <= iterations; i++)
                    {
                        e.Row.Cells.RemoveAt(0);
                    }
                    e.Row.Cells[0].ColumnSpan = colspan;
                }
            }
        }

        protected string GetAvailableQuantity(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            if (_StoreInventoryEnabled && item.Product != null && item.Product.InventoryMode != InventoryMode.None)
            {
                List<int> kitList = null;
                if (!string.IsNullOrEmpty(item.KitList))
                {
                    kitList = new List<int>();
                    kitList.AddRange(AlwaysConvert.ToIntArray(item.KitList));
                }
                InventoryManagerData inv = _InventoryManager.CheckStock(item.ProductId, item.OptionList, kitList);
                return inv.InStock.ToString();
            }
            else
            {
                return "n/a";
            }
        }

        protected bool CanDeleteBasketItem(object dataItem)
        {
            BasketItem basketItem = (BasketItem)dataItem;
            switch (basketItem.OrderItemType)
            {
                case OrderItemType.Discount:
                case OrderItemType.Handling:
                case OrderItemType.Shipping:
                case OrderItemType.Tax:
                    return false;
                case OrderItemType.Product:
                    return !basketItem.IsChildItem;
                default:
                    return true;
            }
        }

        protected void BasketGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                int index = _Basket.Items.IndexOf(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
                if (index > -1) _Basket.Items.DeleteAt(index);
            }
        }

        protected void BasketGrid_DataBound(object sender, EventArgs e)
        {
            OrderButtonPanel.Visible = (BasketGrid.Rows.Count > 0);
        }

        protected decimal GetBasketSubtotal()
        {
            return _Basket.Items.TotalPrice(OrderItemType.Product, OrderItemType.Discount);
        }

        protected void CheckoutButton_Click(object sender, EventArgs e)
        {
            string basketHash = _Basket.ContentHash;
            SaveBasket();
            if (basketHash != _Basket.GetContentHash())
            {
                IBasketService service = AbleContext.Resolve<IBasketService>();
                service.Combine(_Basket);
                service.Recalculate(_Basket);
            }
            if (ValidateInventory())
            {
                Response.Redirect("CreateOrder3.aspx?UID=" + _UserId);
            }
            else
            {
                // SET THE FLAG SO THAT WE CAN PROCEED TO CHECKOUT AFTER AN INVENTORY ACTION IS SELECTED
                DummyInventoryAction.Value = "checkout";
            }
            
        }

        protected void ClearBasketButton_Click(object sender, EventArgs e)
        {
            IBasketService basketService = AbleContext.Resolve<IBasketService>();
            basketService.Clear(_Basket);
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            SaveBasket();
            if (!ValidateInventory())
            {
                DummyInventoryAction.Value = "recalculate";
            }
        }

        protected void FindProductSearchButton_Click(object sender, EventArgs e)
        {
            FindProductSearchResults.Visible = true;
            FindProductSearchResults.DataBind();
        }

        protected void AddProductSaveButton_Click(object sender, EventArgs e)
        {
            // SAVE THE BASKET FOR A NEW USER
            if (_Basket.Id == 0)
            {
                _Basket.Save();
            }

            if (Page.IsValid)
            {
                BasketItem basketItem = CreateBasketItem();
                if (basketItem != null)
                {
                    _Basket.Items.Add(basketItem);
                    SaveBasket();
                }
                BasketAjax.Update();
                HideProductForm();
            }
        }

        protected void AddProductCancelButton_Click(object sender, EventArgs e)
        {
            HideProductForm();
        }

        private void SaveBasket()
        {
            int rowIndex = 0;
            foreach (GridViewRow saverow in BasketGrid.Rows)
            {
                int basketItemId = (int)BasketGrid.DataKeys[rowIndex].Value;
                int itemIndex = _Basket.Items.IndexOf(basketItemId);
                if ((itemIndex > -1))
                {
                    BasketItem item = _Basket.Items[itemIndex];
                    if ((item.OrderItemType == OrderItemType.Product))
                    {
                        TextBox quantity = (TextBox)saverow.FindControl("Quantity");
                        if (quantity != null)
                        {
                            item.Quantity = AlwaysConvert.ToInt16(quantity.Text);
                            // Update for Minimum Maximum quantity of product
                            if (item.Quantity < item.Product.MinQuantity)
                            {
                                item.Quantity = item.Product.MinQuantity;
                                quantity.Text = item.Quantity.ToString();
                            }
                            else if ((item.Product.MaxQuantity > 0) && (item.Quantity > item.Product.MaxQuantity))
                            {
                                item.Quantity = item.Product.MaxQuantity;
                                quantity.Text = item.Quantity.ToString();
                            }
                        }
                    }
                    rowIndex++;
                }
            }
            // SAVE THE WHOLE BASKET
            _Basket.Save();
        }

        protected void InventoryActionButton_Click(object sender, EventArgs e)
        {
            string action = InventoryAction.SelectedValue;
            if (action == "Update")
            {
                ValidateInventory(true);
            }

            // PROCEED WITH CHECKOUT IF REQUIERED
            bool containProducts = false;
            foreach (BasketItem item in _Basket.Items)
            {
                if (item.OrderItemType == OrderItemType.Product)
                {
                    containProducts = true;
                    break;
                }

            }
            if (containProducts && DummyInventoryAction.Value == "checkout")
            {
                Response.Redirect("CreateOrder3.aspx?UID=" + _UserId);
            }

            // RESET THE FLAG
            DummyInventoryAction.Value = string.Empty;
        }

        /// <summary>
        /// Validates the product inventory for items currently added in basket
        /// </summary>
        /// <param name="fixQuantity">Indicate if the quantity need to be fixed as per available stock. If no then it will only record warning messages</param>
        /// <returns>returns true if no issues found</returns>
        protected bool ValidateInventory(bool fixQuantity = false)
        {
            bool recalculateRequried = false;
            // VALIDATE INVENTORY 
            List<string> warningMessages = new List<string>();
            if (_StoreInventoryEnabled)
            {
                Dictionary<string, InventoryInfo> inventories = new Dictionary<string, InventoryInfo>();
                string tempMessage;
                InventoryInfo info;
                foreach (BasketItem item in _Basket.Items)
                {
                    if (item.OrderItemType != OrderItemType.Product || item.IsChildItem) continue;
                    info = GetInventoryInfo(inventories, item);
                    bool enforceInv = info.InventoryStatus.InventoryMode != InventoryMode.None
                        && info.InventoryStatus.AllowBackorder == false;
                    if (enforceInv)
                    {
                        // inventory needs to be enforced                        
                        if (item.Quantity > info.NowAvailable)
                        {
                            if (fixQuantity)
                            {
                                if (info.NowAvailable < 1)
                                    item.Quantity = 0;
                                else
                                    item.Quantity = (short)info.NowAvailable;
                                item.Save();

                                recalculateRequried = true;
                            }
                            else
                            {
                                tempMessage = GetInventoryStockMessage(item, info);
                                warningMessages.Add(tempMessage);
                            }
                        }

                        // if this was a kit product and some quanity of it getting included
                        // update the inventories for all its component products
                        if (item.Product.KitStatus == KitStatus.Master && item.Quantity > 0)
                        {
                            InventoryInfo info1;
                            foreach (InventoryManagerData invd1 in info.InventoryStatus.ChildItemInventoryData)
                            {
                                info1 = inventories[invd1.ProductId + "_" + invd1.OptionList + "_"];
                                if (invd1.InventoryMode != InventoryMode.None
                                    && invd1.AllowBackorder == false)
                                {
                                    // ensure that none of the component product exceeds inventory
                                    int effectiveQuantity = item.Quantity * invd1.Multiplier;
                                    if (effectiveQuantity > info1.NowAvailable)
                                    {
                                        if (fixQuantity)
                                        {
                                            if (info1.NowAvailable < 1) item.Quantity = 0;
                                            else item.Quantity = (short)(info1.NowAvailable / invd1.Multiplier);
                                        }
                                        else
                                        {
                                            tempMessage = GetInventoryStockMessage(item, info1);
                                            warningMessages.Add(tempMessage);
                                        }
                                    }
                                    info1.NowAvailable -= item.Quantity * invd1.Multiplier;
                                    inventories[invd1.ProductId + "_" + invd1.OptionList + "_"] = info1;
                                }
                            }
                        }

                        info.NowAvailable -= item.Quantity;
                    }

                    int curQty = item.Quantity;
                    tempMessage = ValidateMinMaxLimits(item, info);
                    if (!string.IsNullOrEmpty(tempMessage))
                    {
                        warningMessages.Add(tempMessage);
                        if (enforceInv)
                        {
                            info.NowAvailable += curQty - item.Quantity;
                        }
                    }
                }

                // CHECK IF WE NEED TO DISPLAY THE WARNINGS
                if (!fixQuantity && warningMessages.Count > 0)
                {
                    InventoryMessages.DataSource = warningMessages;
                    InventoryMessages.DataBind();
                    InventoryPopup.Show();
                }
                else if(warningMessages.Count > 0)
                {
                    InventoryPopup.Hide();
                    // save the basket
                    _Basket.Save();
                }
            }

            if (recalculateRequried)
            {
                IBasketService service = AbleContext.Resolve<IBasketService>();
                service.Combine(_Basket);
                service.Recalculate(_Basket);
            }

            return warningMessages.Count == 0;
        }

        protected BasketItem CreateBasketItem()
        {
            //GET THE PRODUCT ID
            int productId = AlwaysConvert.ToInt(AddProductId.Value);
            Product product = ProductDataSource.Load(productId);
            if (product == null) return null;
            //GET THE QUANTITY
            short tempQuantity = AlwaysConvert.ToInt16(AddProductQuantity.Text);
            if (tempQuantity < 1) return null;
            //RECALCULATE SELECTED KIT OPTIONS
            GetSelectedKitOptions(product);
            // DETERMINE THE OPTION LIST
            string optionList = ProductVariantDataSource.GetOptionList(productId, _SelectedOptions, false);

            //CREATE THE BASKET ITEM WITH GIVEN OPTIONS
            bool calculateOneTimePrice = AlwaysConvert.ToBool(OptionalSubscription.SelectedValue, false);
            BasketItem basketItem = BasketItemDataSource.CreateForProduct(productId, tempQuantity, optionList, AlwaysConvert.ToList(",", _SelectedKitProducts), _UserId, calculateOneTimePrice);
            if (basketItem != null)
            {
                //BASKET ID
                basketItem.BasketId = _Basket.Id;

                // PRODUCT PRICE FOR VARIABLE PRICE PRODUCT
                if (product.UseVariablePrice && !product.IsSubscription && !product.IsKit) basketItem.Price = AlwaysConvert.ToDecimal(AddProductVariablePrice.Text);
                else basketItem.Price = AlwaysConvert.ToDecimal(AddProductPrice.Text);

                if (product.IsSubscription)
                {
                    if (product.SubscriptionPlan.IsOptional)
                    {
                        basketItem.IsSubscription = !calculateOneTimePrice;
                    }
                    else
                        basketItem.IsSubscription = true;

                    if (basketItem.IsSubscription && product.SubscriptionPlan.IsRecurring)
                    {
                        basketItem.Frequency = product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional ? AlwaysConvert.ToInt16(AutoDeliveryInterval.SelectedValue) : product.SubscriptionPlan.PaymentFrequency;
                        basketItem.FrequencyUnit = product.SubscriptionPlan.PaymentFrequencyUnit;
                    }
                    else if (basketItem.IsSubscription)
                    {
                        basketItem.Frequency = product.SubscriptionPlan.PaymentFrequency;
                        basketItem.FrequencyUnit = product.SubscriptionPlan.PaymentFrequencyUnit;
                    }
                }


                // COLLECT ANY ADDITIONAL INPUTS            
                AbleCommerce.Code.ProductHelper.CollectProductTemplateInput(basketItem, this);
            }
            return basketItem;
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

        protected void FindProductSearchResults_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("Add"))
            {
                int productId = AlwaysConvert.ToInt(e.CommandArgument);
                Product product = ProductDataSource.Load(productId);
                if (product != null)
                {
                        // NEED TO COLLECT ADDITIONAL INPUT TO ADD PRODUCT
                        ShowProductForm(product);
                }
            }
            FindProductSearchResults.DataBind();
        }

        protected void ShowProductForm(Product product)
        {
            if (product.IsSubscription)
            {
                if (product.SubscriptionPlan.IsRecurring && product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional)
                {
                    string value = Request.Form[AutoDeliveryInterval.UniqueID];
                    BindAutoDelieveryOptions(product);

                    if (!string.IsNullOrEmpty(value))
                    {
                        ListItem item = AutoDeliveryInterval.Items.FindByValue(value);
                        if (item != null)
                            item.Selected = true;
                    }
                }
                else
                {
                    AutoDeliveryPH.Visible = false;
                }

                OptionalSubscription.Visible = product.SubscriptionPlan.IsOptional;
            }
            else
            {
                trSubscriptionRow.Visible = false;
            }

            AddPopup.Show();
            //SET NAME AND PRICE
            AddProductName.Text = product.Name;
            // SET QUANTITY TO ONE IF NOT SPECIFIED
            if (string.IsNullOrEmpty(AddProductQuantity.Text) || AddProductQuantity.Text == "0") AddProductQuantity.Text = "1";
            AddProductId.Value = product.Id.ToString();
            //BUILD PRODUCT ATTRIBUTES
            _SelectedOptions = AbleCommerce.Code.ProductHelper.BuildProductOptions(product, phOptions, true);
            //BUILD PRODUCT CHOICES
            AbleCommerce.Code.ProductHelper.BuildProductChoices(product, phOptions);
            //BUILD KIT OPTIONS, IGNORING INVENTORY
            _SelectedKitProducts = AbleCommerce.Code.ProductHelper.BuildKitOptions(product, phOptions, true);
            //SET PRICE
            string optionList = ProductVariantDataSource.GetOptionList(product.Id, _SelectedOptions, true);
            // IF ALL OPTIONS HAVE A VALUE SELECTED, SHOW THE BASKET CONTROLS
            AddProductSaveButton.Visible = (_SelectedOptions.Count == product.ProductOptions.Count);
        }

        protected void HideProductForm()
        {
            AddProductId.Value = string.Empty;
            AddPopup.Hide();
            // HIDE THIS PANEL TO PREVENT VALUES FROM POSTED BACK
            AddProductPanel.Visible = false;
        }

        protected void BindAutoDelieveryOptions(Product product)
        {
            if (product.SubscriptionPlan != null)
            {
                string[] vals = product.SubscriptionPlan.OptionalPaymentFrequencies.Split(',');
                PaymentFrequencyUnit unit = product.SubscriptionPlan.PaymentFrequencyUnit;
                AutoDeliveryInterval.Items.Clear();
                if (vals != null && vals.Length > 0)
                {
                    foreach (string val in vals)
                    {
                        var item = AlwaysConvert.ToInt(val);
                        if (item > 0)
                        {
                            string text = string.Format("{0} {1}{2}", item, unit, item > 1 ? "s" : string.Empty);
                            AutoDeliveryInterval.Items.Add(new ListItem(text, item.ToString()));
                        }
                    }
                }
            }
        }

        protected void AddProductPrice_PreRender(object sender, EventArgs e)
        {
            int productId = AlwaysConvert.ToInt(AddProductId.Value);
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                //GET THE SELECTED KIT OPTIONS
                GetSelectedKitOptions(product);
                //SET THE CURRENT CALCULATED PRICE
                string optionList = ProductVariantDataSource.GetOptionList(productId, _SelectedOptions, true);
                bool calculateOneTimePrice = AlwaysConvert.ToBool(OptionalSubscription.SelectedValue, false);
                ProductCalculator pcalc = ProductCalculator.LoadForProduct(productId, 1, optionList, AlwaysConvert.ToList(",", _SelectedKitProducts), _UserId, false, calculateOneTimePrice);
                AddProductPrice.Text = string.Format("{0:F2}", pcalc.Price);

                if (product.IsSubscription)
                {
                    if (product.SubscriptionPlan.IsRecurring)
                    {
                        if (!calculateOneTimePrice)
                        {
                            short frequency = product.SubscriptionPlan.PaymentFrequencyType == PaymentFrequencyType.Optional ? AlwaysConvert.ToInt16(AutoDeliveryInterval.SelectedValue) : product.SubscriptionPlan.PaymentFrequency;
                            SubscriptionMessage.Text = ProductHelper.GetRecurringPaymentMessage(product.Price, 0, product.SubscriptionPlan, frequency);
                            SubscriptionMessage.Visible = true;
                        }
                        else
                        {
                            SubscriptionMessage.Visible = false;
                        }
                    }
                    else
                    {
                        trSubscriptionRow.Visible = product.SubscriptionPlan.IsOptional;
                    }
                }
                else
                {
                    trSubscriptionRow.Visible = false;
                }

                if (product.UseVariablePrice && !product.IsSubscription && !product.IsKit)
                {
                    AddProductVariablePrice.Text = string.Format("{0:F2}", pcalc.Price);
                    AddProductVariablePrice.Visible = true;
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
                AddProductPrice.Visible = !AddProductVariablePrice.Visible;
                if ((AddProductPrice.Visible && _Basket.UserId == AbleContext.Current.UserId) || (product.IsKit))
                {
                    AddProductPrice.Enabled = false;
                }
            }
        }

        private static string GetInventoryStockMessage(BasketItem item, InventoryInfo info)
        {
            string message = string.Empty;
            if (info.NowAvailable < 1)
            {
                string tempItemName = (item.ProductVariant == null) ? item.Name : tempItemName = item.Name + " (" + item.ProductVariant.VariantName + ")";
                if (item.Product.KitStatus == KitStatus.Master)
                {
                    message = string.Format("The item '{0}' or one of its components is currently out of stock.", tempItemName);
                }
                else
                {
                    message = string.Format("The item '{0}' is out of stock.", tempItemName);
                }
            }
            else
            {
                string tempItemName = (item.ProductVariant == null) ? item.Name : tempItemName = item.Name + " (" + item.ProductVariant.VariantName + ")";
                if (item.Product.KitStatus == KitStatus.Master)
                {
                    message = string.Format("Item '{0}' (or one of its components) only has {1} available but this order contains {2}.", tempItemName, info.InventoryStatus.InStock, item.Quantity);
                }
                else
                {
                    message = string.Format("Item '{0}' only has {1} available but this order contains {2}.", tempItemName, info.InventoryStatus.InStock, item.Quantity);
                }
            }
            return message;
        }

        protected void InventoryAlertUpdate()
        {
            int productId = AlwaysConvert.ToInt(AddProductId.Value);
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                // WE HAVE A VALID PRODUCT, ARE ANY AVAILABLE OPTIONS SELECTED?
                bool allProductOptionsSelected = (_SelectedOptions.Count == product.ProductOptions.Count);
                if (allProductOptionsSelected)
                {
                    // OPTIONS ARE GOOD, VERIFY ANY REQUIRED KIT OPTIONS ARE SELECTED
                    GetSelectedKitOptions(product);
                    bool requiredKitOptionsSelected = AbleCommerce.Code.ProductHelper.RequiredKitOptionsSelected(product, _SelectedKitProducts);
                    if (requiredKitOptionsSelected)
                    {
                        // KIT OPTIONS ARE ALSO VALID, DETERMINE APPROPRIATE WARNINGS
                        Store store = AbleContext.Current.Store;
                        List<string> warningMessages = new List<string>();

                        string optionList = string.Empty;
                        if (product.ProductOptions.Count > 0)
                        {
                            // OPTIONS ARE PRESENT, CHECK AVAILABLILITY
                            optionList = ProductVariantDataSource.GetOptionList(productId, _SelectedOptions, true);
                            ProductVariant variant = ProductVariantDataSource.LoadForOptionList(product.Id, optionList);
                            if (!variant.Available) warningMessages.Add("The selected variant is marked as unavailable.");

                            // WE ALSO NEED TO ALERT INVENTORY IF ENABLED AT VARIANT LEVEL AND THIS IS NOT A KIT
                            if (_StoreInventoryEnabled
                                && product.KitStatus != KitStatus.Master
                                && product.InventoryMode == InventoryMode.Variant)
                                warningMessages.Add("The selected variant has a current stock level of " + variant.InStock + ".");
                        }

                        // CHECK STOCK QUANTITY FOR PRODUCT, IF STORE INVENTORY IS ENABLED
                        // AND THE STOCK IS MANAGED AT THE PRODUCT LEVEL OR THIS IS A KIT
                        if (_StoreInventoryEnabled && (product.InventoryMode == InventoryMode.Product || product.KitStatus == KitStatus.Master))
                        {
                            InventoryManagerData inv = _InventoryManager.CheckStock(productId, optionList, _SelectedKitProducts);
                            if (!inv.AllowBackorder)
                            {
                                if (product.KitStatus == KitStatus.Master)
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

        private static string ValidateMinMaxLimits(BasketItem item, InventoryInfo info)
        {
            if (item == null) return string.Empty;
            string tempMessage = string.Empty;
            if (item.Quantity > 0)
            {
                // validate min/max limits
                short tempMaxQuantity = item.Product.MaxQuantity;
                if ((tempMaxQuantity > 0) && (item.Quantity > tempMaxQuantity))
                {
                    string tempItemName = (item.ProductVariant == null) ? item.Name : tempItemName = item.Name + " (" + item.ProductVariant.VariantName + ")";
                    tempMessage = string.Format("The quantity of item {0} exceeds the purchase limit of {1}.", tempItemName, tempMaxQuantity);
                    item.Quantity = tempMaxQuantity;
                }
                short tempMinQuantity = item.Product.MinQuantity;
                if ((tempMinQuantity > 0) && (item.Quantity < tempMinQuantity))
                {
                    string tempItemName = (item.ProductVariant == null) ? item.Name : item.Name + " (" + item.ProductVariant.VariantName + ")";
                    if (tempMinQuantity <= info.NowAvailable)
                    {
                        tempMessage = string.Format("The quantity of item {0} is below the minimum purchase quantity of {1}.", tempItemName, tempMinQuantity);
                        item.Quantity = tempMinQuantity;
                    }
                    else
                    {
                        tempMessage = string.Format("The item '{0}' can not be purchased because its available stock is below the minimum purchase quantity of {1}.", tempItemName, tempMinQuantity);
                        item.Quantity = 0;
                    }
                }
            }
            return tempMessage;
        }

        private InventoryInfo GetInventoryInfo(Dictionary<string, InventoryInfo> inventories, BasketItem item)
        {
            // KEY MUST BE UNIQUE FOR THE PRODUCT (INCLUDING OPTIONS AND KITS)
            string key = item.Product.Id + "_" + item.OptionList + "_" + item.KitList;
            if (inventories.ContainsKey(key))
            {
                // RETURN THE INVENTORY INFO FROM CACHE
                return inventories[key];
            }
            else
            {
                // CREATE A NEW INVENTORY INFO STRUCTURE
                InventoryManagerData invd = _InventoryManager.CheckStock(item);
                InventoryInfo info = new InventoryInfo(invd);
                inventories[key] = info;

                // POPULATE THE INVENTORY INFO FOR ANY CHILD PRODUCTS
                foreach (InventoryManagerData invd1 in invd.ChildItemInventoryData)
                {
                    // CHILD KEY WILL NOT CONTAIN THE KIT LIST PART AS WE DO NOT ALLOW TO NEXT KITS
                    string childKey = invd1.ProductId + "_" + invd1.OptionList + "_";
                    if (!inventories.ContainsKey(childKey))
                        inventories[childKey] = new InventoryInfo(invd1);
                }
                return info;
            }
        }

        /// <summary>
        /// Holds inventory info used in validating the basket
        /// </summary>
        private struct InventoryInfo
        {
            /// <summary>
            /// Gets or sets the inventory manager data
            /// </summary>
            public InventoryManagerData InventoryStatus;

            /// <summary>
            /// Gets or sets the current stock (taking in memory processing into account)
            /// </summary>
            public int NowAvailable;

            /// <summary>
            /// Initializes a new instance of the InventoryInfo struct.
            /// </summary>
            /// <param name="invd">Inventory manager data.</param>
            public InventoryInfo(InventoryManagerData invd)
            {
                InventoryStatus = invd;
                NowAvailable = invd.InStock;
            }
        }
    }
}