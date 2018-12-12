namespace AbleCommerce.Code
{
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Text;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Products;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.UI.WebControls;
    using CommerceBuilder.Extensions;
    using System.Linq;
    using CommerceBuilder.Users;

    public class ProductHelper
    {
        /// <summary>
        /// Builds the control(s) to select product options.
        /// </summary>
        /// <param name="product">The product to build the controls for</param>
        /// <param name="phOptions">The place holder control where the controls will be added.</param>
        /// <returns>The controls are added to phOptions, and the return value is a dictionary of currently selected options.  The key is the option ID, the value is the choice ID selected.</returns>
        public static Dictionary<int, int> BuildProductOptions(Product product, PlaceHolder phOptions)
        {
            return BuildProductOptions(product, phOptions, false);
        }

        /// <summary>
        /// Builds the control(s) to select product options.
        /// </summary>
        /// <param name="product">The product to build the controls for</param>
        /// <param name="phOptions">The place holder control where the controls will be added.</param>
        /// <param name="showAllOptions">If true, all options are made available even if they are out of stock or otherwise unavailable.</param>
        /// <returns>The controls are added to phOptions, and the return value is a dictionary of currently selected options.  The key is the option ID, the value is the choice ID selected.</returns>
        public static Dictionary<int, int> BuildProductOptions(Product product, PlaceHolder phOptions, bool showAllOptions)
        {
            Dictionary<int, int> selectedChoices = new Dictionary<int, int>();
            if ((product.ProductOptions.Count > 0))
            {
                Page page = phOptions.Page;
                HttpRequest request = HttpContext.Current.Request;
                IList<ProductOption> productOptions = product.ProductOptions;
                int optionCount = productOptions.Count;

                // DETERMINE THE SELECTED CHOICES
                string baseId = phOptions.UniqueID.Substring(0, phOptions.UniqueID.Length - phOptions.ID.Length);
                for (int i = 0; i < optionCount; i++)
                {
                    Option option = productOptions[i].Option;
                    string selectedChoice = request.Form[baseId + "option" + i];
                    if (!string.IsNullOrEmpty(selectedChoice))
                    {
                        int choiceId = AlwaysConvert.ToInt(selectedChoice);
                        if (choiceId != 0) selectedChoices.Add(option.Id, choiceId);
                    }
                }

                for (int i = 0; i < optionCount; i++)
                {
                    Option option = productOptions[i].Option;
                    // CREATE A LABEL FOR THE ATTRIBUTE
                    phOptions.Controls.Add(new LiteralControl("<tr><th class=\"rowHeader\"" + (option.ShowThumbnails ? " valign=\"top\"" : string.Empty) + ">" + option.Name + ":</th>"));
                    phOptions.Controls.Add(new LiteralControl("<td align=\"left\">"));
                    if (option.ShowThumbnails)
                    {
                        // CREATE THE OPTION PICKER CONTROL TO THE PLACEHOLDER
                        OptionPicker picker = new OptionPicker();
                        picker.ID = "option" + i;
                        picker.CssClass = "optionPicker";
                        // WE ALWAYS HAVE TO POSTBACK FOR THUMBNAIL PICKER
                        picker.AutoPostBack = true;
                        picker.OptionId = option.Id;
                        picker.SelectedChoices = new Dictionary<int, int>(selectedChoices);
                        picker.ForceToLoadAllChoices = showAllOptions;
                        // ADD THE CONTROL TO THE PLACEHOLDER
                        phOptions.Controls.Add(picker);
                        if (selectedChoices.ContainsKey(option.Id))
                        {
                            picker.SelectedChoiceId = selectedChoices[option.Id];
                        }
                        // ADD VALIDATOR
                        OptionPickerValidator aspOptionsValidator = new OptionPickerValidator();
                        aspOptionsValidator.ID = "optionValidator" + i;
                        aspOptionsValidator.ControlToValidate = picker.ID;
                        aspOptionsValidator.ValidationGroup = "AddToBasket";
                        aspOptionsValidator.Text = "*";
                        aspOptionsValidator.ErrorMessage = string.Format("Please make your selection for {0}.", option.Name);
                        phOptions.Controls.Add(new LiteralControl("&nbsp;"));
                        phOptions.Controls.Add(aspOptionsValidator);
                    }
                    else
                    {
                        // CREATE A DROPDOWN FOR THE OPTIONS
                        DropDownList aspOptions = new DropDownList();
                        RequiredFieldValidator aspOptionsValidator = new RequiredFieldValidator();
                        aspOptions.ID = "option" + i;
                        aspOptions.AutoPostBack = true;
                        aspOptionsValidator.ID = "optionValidator" + i;
                        aspOptionsValidator.ControlToValidate = aspOptions.ID;
                        aspOptionsValidator.ValidationGroup = "AddToBasket";
                        aspOptionsValidator.Text = "*";
                        aspOptionsValidator.ErrorMessage = string.Format("Please make your selection for {0}.", option.Name);
                        aspOptions.Items.Add(option.HeaderText);
                        // GET THE COLLECTION OF CHOICES THAT ARE AVAILABLE FOR THE CURRENT SELECTIONS
                        IList<OptionChoice> availableOptions;
                        if (!showAllOptions && i < ProductVariant.MAXIMUM_ATTRIBUTES)
                        {
                            availableOptions = OptionChoiceDataSource.GetAvailableChoices(product.Id, option.Id, selectedChoices);
                        }
                        else
                        {
                            availableOptions = option.Choices;
                        }
                        // ADD AVAILABLE CHOICES TO THE LIST
                        foreach (OptionChoice choice in availableOptions)
                        {
                            aspOptions.Items.Add(new ListItem(choice.Name, choice.Id.ToString()));
                        }
                        // ADD THE CONTROL TO THE PLACEHOLDER
                        phOptions.Controls.Add(aspOptions);
                        phOptions.Controls.Add(new LiteralControl("&nbsp;"));
                        phOptions.Controls.Add(aspOptionsValidator);
                        // SEE WHETHER A VALID VALUE FOR THIS FIELD IS PRESENT IN FORM POST
                        if (selectedChoices.ContainsKey(option.Id))
                        {
                            ListItem selectedItem = aspOptions.Items.FindByValue(selectedChoices[option.Id].ToString());
                            if (selectedItem != null) selectedItem.Selected = true;
                        }
                    }
                    phOptions.Controls.Add(new LiteralControl("</td></tr>"));
                    // KEEP LOOPING UNTIL WE REACH THE END OR WE COME TO AN OPTION THAT IS NOT SELECTED
                }
            }
            //RETURN SELECTED OPTIONS
            return selectedChoices;
        }

        public static Dictionary<int, int> BuildProductOptions(KitProduct kitProduct, PlaceHolder phOptions)
        {
            if (kitProduct == null) return null;
            Product product = kitProduct.Product;
            Dictionary<int, int> selectedChoices = new Dictionary<int, int>();
            if ((product.ProductOptions.Count > 0))
            {
                Page page = phOptions.Page;
                HttpRequest request = HttpContext.Current.Request;
                for (int i = 0; i < product.ProductOptions.Count; i++)
                {
                    Option option = product.ProductOptions[i].Option;
                    // CREATE A LABEL FOR THE ATTRIBUTE
                    phOptions.Controls.Add(new LiteralControl("<tr><th class=\"rowHeader\"" + (option.ShowThumbnails ? " valign=\"top\"" : string.Empty) + ">" + option.Name + ":</th>"));
                    phOptions.Controls.Add(new LiteralControl("<td align=\"left\">"));

                    // CREATE A DROPDOWN FOR THE OPTIONS
                    DropDownList aspOptions = new DropDownList();
                    RequiredFieldValidator aspOptionsValidator = new RequiredFieldValidator();
                    aspOptions.ID = "option" + i;
                    aspOptionsValidator.ID = "optionValidator" + i;
                    aspOptionsValidator.ControlToValidate = aspOptions.ID;
                    aspOptionsValidator.ValidationGroup = "AddToBasket";
                    aspOptionsValidator.Text = string.Empty;
                    aspOptionsValidator.ErrorMessage = string.Empty;
                    aspOptions.Items.Add(option.HeaderText);

                    // GET THE COLLECTION OF CHOICES THAT ARE AVAILABLE FOR THE CURRENT SELECTIONS
                    IList<OptionChoice> availableOptions;
                    if (i < ProductVariant.MAXIMUM_ATTRIBUTES)
                    {
                        availableOptions = OptionChoiceDataSource.GetAvailableChoices(product.Id, option.Id, selectedChoices);
                    }
                    else
                    {
                        availableOptions = option.Choices;
                    }
                    // ADD AVAILABLE CHOICES TO THE LIST
                    foreach (OptionChoice choice in availableOptions)
                    {
                        aspOptions.Items.Add(new ListItem(choice.Name, choice.Id.ToString()));
                    }

                    // ADD THE CONTROL TO THE PLACEHOLDER
                    phOptions.Controls.Add(aspOptions);
                    phOptions.Controls.Add(aspOptionsValidator);

                    string selectedValue = request.Form[aspOptions.UniqueID];
                    if (!string.IsNullOrEmpty(selectedValue))
                    {
                        ListItem selectedItem = aspOptions.Items.FindByValue(selectedValue);
                        if (selectedItem != null)
                        {
                            int val = AlwaysConvert.ToInt(selectedValue);
                            if (val != 0)
                            {
                                selectedChoices.Add(option.Id, val);
                                selectedItem.Selected = true;
                            }
                        }
                    }
                    else
                    {
                        ProductVariant productVariant = kitProduct.ProductVariant;
                        int optionChoiceId = 0;
                        switch (i)
                        {
                            case 0:
                                optionChoiceId = (productVariant.Option1 > 0) ? productVariant.Option1 : 0;
                                break;
                            case 1:
                                optionChoiceId = (productVariant.Option2 > 0) ? productVariant.Option2 : 0;
                                break;
                            case 2:
                                optionChoiceId = (productVariant.Option3 > 0) ? productVariant.Option3 : 0;
                                break;
                            case 3:
                                optionChoiceId = (productVariant.Option4 > 0) ? productVariant.Option4 : 0;
                                break;
                            case 4:
                                optionChoiceId = (productVariant.Option5 > 0) ? productVariant.Option5 : 0;
                                break;
                            case 5:
                                optionChoiceId = (productVariant.Option6 > 0) ? productVariant.Option6 : 0;
                                break;
                            case 6:
                                optionChoiceId = (productVariant.Option7 > 0) ? productVariant.Option7 : 0;
                                break;
                            case 7:
                                optionChoiceId = (productVariant.Option8 > 0) ? productVariant.Option8 : 0;
                                break;
                            default:
                                //FIND OPTION CHOICE ID TO HANDLE SELECTIONS FOR MORE THEN 8 OPTIONS
                                if (!string.IsNullOrEmpty(productVariant.OptionList))
                                {
                                    string[] options = productVariant.OptionList.Split(',');
                                    if (options != null && options.Length > 8 && i > 7)
                                        optionChoiceId = AlwaysConvert.ToInt(options[i]);
                                }
                                break;
                        }
                        if (optionChoiceId > 0)
                        {
                            ListItem listItem = aspOptions.Items.FindByValue(optionChoiceId.ToString());
                            if (listItem != null)
                                listItem.Selected = true;
                        }
                    }
                    phOptions.Controls.Add(new LiteralControl("</td></tr>"));
                    // KEEP LOOPING UNTIL WE REACH THE END OR WE COME TO AN OPTION THAT IS NOT SELECTED
                }
            }
            return selectedChoices;
        }

        public static void BuildProductChoices(Product product, PlaceHolder phChoices)
        {
            // ADD IN THE PRODUCT TEMPLATE CHOICES
            foreach (ProductTemplate template in product.ProductTemplates)
            {
                foreach (InputField input in template.InputFields)
                {
                    if (!input.IsMerchantField)
                    {
                        // ADD THE CONTROL TO THE PLACEHOLDER
                        phChoices.Controls.Add(new LiteralControl("<tr><td colspan=\"2\">"));
                        phChoices.Controls.Add(new LiteralControl((input.UserPrompt + "<br />")));
                        WebControl o = input.GetControl();
                        if (o != null)
                        {
                            phChoices.Controls.Add(o);
                        }
                        phChoices.Controls.Add(new LiteralControl("</td></tr>"));
                    }
                }
            }
        }

        public static List<int> BuildKitOptions(Product product, PlaceHolder phOptions)
        {
            return BuildKitOptions(product, phOptions, false);
        }

        public static List<int> BuildKitOptions(Product product, PlaceHolder phOptions, bool ignoreInventory)
        {
            List<int> selectedChoices = new List<int>();
            foreach (ProductKitComponent pkc in product.ProductKitComponents)
            {
                KitComponent component = pkc.KitComponent;
                if (component.InputType != KitInputType.IncludedHidden && component.KitProducts.Count > 0)
                {
                    // CREATE A LABEL FOR THE ATTRIBUTE
                    phOptions.Controls.Add(new LiteralControl("<tr><th class=\"rowHeader\">" + component.Name + ":</th>"));
                    // ADD THE CONTROL TO THE PLACEHOLDER
                    phOptions.Controls.Add(new LiteralControl("<td align=\"left\">"));
                    WebControl o = component.GetControl(ignoreInventory);
                    if (o != null)
                    {
                        Type oType = o.GetType();
                        if (oType.Equals(typeof(RadioButtonList)))
                        {
                            ((RadioButtonList)o).AutoPostBack = true;
                        }
                        else if (oType.Equals(typeof(DropDownList)))
                        {
                            ((DropDownList)o).AutoPostBack = true;
                        }
                        else if (oType.Equals(typeof(CheckBoxList)))
                        {
                            ((CheckBoxList)o).AutoPostBack = true;
                        }
                        phOptions.Controls.Add(o);
                        // SEE WHETHER A VALID VALUE FOR THIS FIELD IS PRESENT IN FORM POST
                        IList<int> theseOptions = component.GetControlValue(o);
                        selectedChoices.AddRange(theseOptions);
                    }
                    phOptions.Controls.Add(new LiteralControl("</td></tr>"));
                }
            }
            return selectedChoices;
        }

        public static string GetSKU(object dataItem)
        {
            if (dataItem is BasketItem) return GetSKU((BasketItem)dataItem);
            if (dataItem is OrderItem) return GetSKU((OrderItem)dataItem);
            throw new ArgumentException("Input must be BasketItem or OrderItem.  You passed: " + dataItem.GetType().ToString(), "dataItem");
        }

        public static string GetSKU(BasketItem item)
        {
            switch (item.OrderItemType)
            {
                case OrderItemType.Product:
                    return item.Sku;
                case OrderItemType.GiftWrap:
                    return "GIFT WRAP";
                case OrderItemType.Coupon:
                    return "COUPON";
                case OrderItemType.Discount:
                    return "DISCOUNT";
                case OrderItemType.Shipping:
                    return "SHIPPING";
                case OrderItemType.Handling:
                    return "HANDLING";
                case OrderItemType.Tax:
                    return "TAX";
                case OrderItemType.GiftCertificatePayment:
                    return "GIFTCERT PAYMENT";
                case OrderItemType.Charge:
                    return "CHARGE";
                case OrderItemType.Credit:
                    return "CREDIT";
                case OrderItemType.GiftCertificate:
                    return "GIFTCERT";
                default:
                    return string.Empty;
            }
        }

        public static string GetSKU(OrderItem item)
        {
            switch (item.OrderItemType)
            {
                case OrderItemType.Product:
                    return item.Sku;
                case OrderItemType.GiftWrap:
                    return "GIFT WRAP";
                case OrderItemType.Coupon:
                    return "COUPON";
                case OrderItemType.Discount:
                    return "DISCOUNT";
                case OrderItemType.Shipping:
                    return "SHIPPING";
                case OrderItemType.Handling:
                    return "HANDLING";
                case OrderItemType.Tax:
                    return "TAX";
                case OrderItemType.GiftCertificatePayment:
                    return "GIFTCERT PAYMENT";
                case OrderItemType.Charge:
                    return "CHARGE";
                case OrderItemType.Credit:
                    return "CREDIT";
                case OrderItemType.GiftCertificate:
                    return "GIFTCERT";
                default:
                    return string.Empty;
            }
        }

        public static bool RequiredKitOptionsSelected(Product product, List<int> selectedKitProductIds)
        {
            if (product.KitStatus != KitStatus.Master) return true;

            Dictionary<int, List<int>> requiredIdsTable = new Dictionary<int, List<int>>();
            foreach (ProductKitComponent pkc in product.ProductKitComponents)
            {
                KitComponent component = pkc.KitComponent;
                if (string.IsNullOrEmpty(component.HeaderOption) && (component.InputType == KitInputType.DropDown || component.InputType == KitInputType.RadioButton))
                {
                    requiredIdsTable.Add(component.Id, GetKitProductIds(component));
                }
            }

            bool optionsSelected = true;
            foreach (int compId in requiredIdsTable.Keys)
            //for (int i = 0; i < requiredIdsTable.Count; i++)
            {
                List<int> optionIds = requiredIdsTable[compId];
                //selected kipt option ids must have one of the option ids
                bool found = false;
                foreach (int optionId in optionIds)
                {
                    if (selectedKitProductIds.Exists(delegate(int val) { return val == optionId; }))
                    {
                        found = true;
                        break;
                    }
                }

                if (!found)
                {
                    optionsSelected = false;
                    break;
                }
            }

            return optionsSelected;
        }

        private static List<int> GetKitProductIds(KitComponent comp)
        {
            List<int> optionIds = new List<int>();
            foreach (KitProduct choice in comp.KitProducts)
            {
                optionIds.Add(choice.Id);
            }
            return optionIds;
        }

        /// <summary>
        /// Gets all assets for a product regardless of variant.
        /// </summary>
        /// <param name="page">Page context</param>
        /// <param name="product">Product to get assets for</param>
        /// <param name="returnUrl">URL to use for the return location when pages visited.</param>
        /// <returns></returns>
        public static List<AbleCommerce.Code.ProductAssetWrapper> GetAssets(Page page, Product product, string returnUrl)
        {
            // BUILD LIST OF ASSETS
            List<string> assetTracker = new List<string>();
            string encodedReturnUrl;
            if (!string.IsNullOrEmpty(returnUrl)) encodedReturnUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(returnUrl));
            else encodedReturnUrl = string.Empty;
            List<AbleCommerce.Code.ProductAssetWrapper> assetList = new List<AbleCommerce.Code.ProductAssetWrapper>();
            string agreeUrl = page.ResolveUrl("~/ViewLicenseAgreement.aspx") + "?id={0}&ReturnUrl=" + encodedReturnUrl;
            string agreePopup = agreeUrl + "\" onclick=\"" + AbleCommerce.Code.PageHelper.GetPopUpScript(agreeUrl, "license", 640, 480, "resizable=1,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no") + ";return false";
            string readmeUrl = page.ResolveUrl("~/ViewReadme.aspx") + "?ReadmeId={0}&ReturnUrl=" + encodedReturnUrl;
            string readmePopup = readmeUrl + "\" onclick=\"" + AbleCommerce.Code.PageHelper.GetPopUpScript(readmeUrl, "readme", 640, 480, "resizable=1,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no") + ";return false";
            foreach (ProductDigitalGood pdg in product.DigitalGoods)
            {
                DigitalGood digitalGood = pdg.DigitalGood;
                Readme readme = digitalGood.Readme;
                if (readme != null && assetTracker.IndexOf("R" + readme.Id.ToString()) < 0)
                {
                    assetList.Add(new AbleCommerce.Code.ProductAssetWrapper(string.Format(readmePopup, readme.Id), readme.DisplayName));
                    assetTracker.Add("R" + readme.Id.ToString());
                }
                LicenseAgreement agreement = digitalGood.LicenseAgreement;
                if (agreement != null && assetTracker.IndexOf("L" + agreement.Id.ToString()) < 0)
                {
                    assetList.Add(new AbleCommerce.Code.ProductAssetWrapper(string.Format(agreePopup, agreement.Id), agreement.DisplayName));
                    assetTracker.Add("L" + agreement.Id.ToString());
                }
            }
            return assetList;
        }

        public static List<AbleCommerce.Code.ProductAssetWrapper> GetAssets(Page page, Product product, string optionList, string kitList, string returnUrl)
        {
            // BUILD LIST OF ASSETS
            List<string> assetTracker = new List<string>();
            string encodedReturnUrl;
            if (!string.IsNullOrEmpty(returnUrl)) encodedReturnUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(returnUrl));
            else encodedReturnUrl = string.Empty;
            List<AbleCommerce.Code.ProductAssetWrapper> assetList = new List<AbleCommerce.Code.ProductAssetWrapper>();

            string agreeUrl = page.ResolveUrl("~/ViewLicenseAgreement.aspx") + "?id={0}&ReturnUrl=" + encodedReturnUrl;
            string agreePopup = agreeUrl + "\" onclick=\"" + AbleCommerce.Code.PageHelper.GetPopUpScript(agreeUrl, "license", 640, 480, "resizable=1,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no") + ";return false";
            string readmeUrl = page.ResolveUrl("~/ViewReadme.aspx") + "?ReadmeId={0}&ReturnUrl=" + encodedReturnUrl;
            string readmePopup = readmeUrl + "\" onclick=\"" + AbleCommerce.Code.PageHelper.GetPopUpScript(readmeUrl, "readme", 640, 480, "resizable=1,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no") + ";return false";

            List<ProductAndOptionList> products = new List<ProductAndOptionList>();
            products.Add(new ProductAndOptionList(product, optionList));

            // IF IT IS A KIT LOOK FOR CHILD PRODUCTS AS WELL
            if (!String.IsNullOrEmpty(kitList))
            {
                if (product.IsKit)
                {
                    bool kitIsBundled = !product.Kit.ItemizeDisplay;
                    int[] kitProductIds = AlwaysConvert.ToIntArray(kitList);
                    if (kitProductIds != null && kitProductIds.Length > 0)
                    {
                        foreach (int kitProductId in kitProductIds)
                        {
                            KitProduct kitProduct = KitProductDataSource.Load(kitProductId);
                            if ((kitProduct != null)
                                && (kitProduct.KitComponent.InputType == KitInputType.IncludedHidden || kitIsBundled))
                            {
                                products.Add(new ProductAndOptionList(kitProduct.Product, kitProduct.OptionList));
                            }
                        }
                    }
                }
            }

            foreach (ProductAndOptionList pol in products)
            {
                foreach (ProductDigitalGood pdg in pol.Product.DigitalGoods)
                {
                    if ((string.IsNullOrEmpty(pdg.OptionList)) || (pol.OptionList == pdg.OptionList))
                    {
                        DigitalGood digitalGood = pdg.DigitalGood;
                        Readme readme = digitalGood.Readme;
                        if (readme != null && assetTracker.IndexOf("R" + readme.Id.ToString()) < 0)
                        {
                            assetList.Add(new AbleCommerce.Code.ProductAssetWrapper(string.Format(readmePopup, readme.Id), readme.DisplayName));
                            assetTracker.Add("R" + readme.Id.ToString());
                        }
                        LicenseAgreement agreement = digitalGood.LicenseAgreement;
                        if (agreement != null && assetTracker.IndexOf("L" + agreement.Id.ToString()) < 0)
                        {
                            assetList.Add(new AbleCommerce.Code.ProductAssetWrapper(string.Format(agreePopup, agreement.Id), agreement.DisplayName));
                            assetTracker.Add("L" + agreement.Id.ToString());
                        }
                    }
                }
            }
            return assetList;
        }

        public static void CollectProductTemplateInput(BasketItem item, Control container)
        {
            // COLLECT ANY ADDITIONAL INPUTS
            Product product = item.Product;
            if (product != null)
            {
                foreach (ProductTemplate template in product.ProductTemplates)
                {
                    foreach (InputField input in template.InputFields)
                    {
                        //ONLY LOOK FOR CUSTOMER INPUT FIELDS
                        if (!input.IsMerchantField)
                        {
                            //SEE IF WE CAN LOCATE THE CONTROL
                            WebControl inputControl = (WebControl)AbleCommerce.Code.PageHelper.RecursiveFindControl(container, input.UniqueId);
                            if (inputControl != null)
                            {
                                // look for existing input item
                                BasketItemInput itemInput = item.Inputs.FirstOrDefault(bi => bi.InputFieldId == input.Id);
                                if (itemInput == null)
                                {
                                    // need to add the input item
                                    itemInput = new BasketItemInput();
                                    itemInput.InputFieldId = input.Id;
                                    itemInput.BasketItem = item;
                                    item.Inputs.Add(itemInput);
                                }

                                // update input value
                                itemInput.InputValue = input.GetControlValue(inputControl);
                            }
                        }
                    }
                }
            }
        }

        public static void CollectProductTemplateInput(OrderItem item, Control container)
        {
            // COLLECT ANY ADDITIONAL INPUTS
            Product product = item.Product;
            if (product != null)
            {
                foreach (ProductTemplate template in product.ProductTemplates)
                {
                    foreach (InputField input in template.InputFields)
                    {
                        //ONLY LOOK FOR CUSTOMER INPUT FIELDS
                        if (!input.IsMerchantField)
                        {
                            //SEE IF WE CAN LOCATE THE CONTROL
                            WebControl inputControl = (WebControl)AbleCommerce.Code.PageHelper.RecursiveFindControl(container, input.UniqueId);
                            if (inputControl != null)
                            {
                                OrderItemInput itemInput = new OrderItemInput();
                                itemInput.OrderItem = item;
                                itemInput.Name = input.Name;
                                itemInput.InputValue = input.GetControlValue(inputControl);
                                item.Inputs.Add(itemInput);
                            }
                        }
                    }
                }
            }
        }

        public static void CollectProductTemplateInput(Product product, Control container)
        {
            foreach (ProductTemplate template in product.ProductTemplates)
            {
                // COLLECT ANY ADDITIONAL INPUTS
                foreach (InputField input in template.InputFields)
                {
                    //LOOK FOR MERCHANT INPUT FIELDS
                    if (input.IsMerchantField)
                    {
                        //SEE IF WE CAN LOCATE THE CONTROL
                        WebControl inputControl = (WebControl)AbleCommerce.Code.PageHelper.RecursiveFindControl(container, input.UniqueId);
                        if (inputControl != null)
                        {
                            ProductTemplateField itemInput = (from tf in product.TemplateFields where tf.InputField.Id == input.Id select tf).SingleOrDefault<ProductTemplateField>();
                            if (itemInput == null)
                                itemInput = new ProductTemplateField();
                            itemInput.Product = product;
                            itemInput.InputField = input;
                            itemInput.InputValue = input.GetControlValue(inputControl);

                            if(itemInput.IsTransient())
                                product.TemplateFields.Add(itemInput);
                        }
                    }
                }
            }
        }

        public static string GetRecurringPaymentMessage(OrderItem orderItem)
        {
            if (orderItem.Product == null || orderItem.Product.SubscriptionPlan == null) return string.Empty;

            // GET TEXTUAL REPRESENTATION OF THE PAYMENT INTERVAL (WEEKLY, MONTHLY, EVERY 2 MONTHS, ETC.)            
            string paymentPeriod = GetPaymentPeriod(orderItem.FrequencyUnit, orderItem.Frequency, orderItem.Product.SubscriptionPlan.NumberOfPayments);

            return GetRecurringPaymentMessage(orderItem.Price, orderItem.TaxCode != null ? orderItem.TaxCode.Id : 0, orderItem.Product.SubscriptionPlan, paymentPeriod);
        }

        public static string GetRecurringPaymentMessage(BasketItem basketItem)
        {
            Product product = basketItem.Product;
            
            // GET TEXTUAL REPRESENTATION OF THE PAYMENT INTERVAL (WEEKLY, MONTHLY, EVERY 2 MONTHS, ETC.)
            string paymentPeriod = GetPaymentPeriod(basketItem.FrequencyUnit, basketItem.Frequency, product.SubscriptionPlan.NumberOfPayments);

            return GetRecurringPaymentMessage(product.Price, product.TaxCode != null ? product.TaxCode.Id : 0, product.SubscriptionPlan, paymentPeriod);
        }

        public static string GetRecurringPaymentMessage(WishlistItem wishlistItem)
        {
            Product product = wishlistItem.Product;

            // GET TEXTUAL REPRESENTATION OF THE PAYMENT INTERVAL (WEEKLY, MONTHLY, EVERY 2 MONTHS, ETC.)
            string paymentPeriod = GetPaymentPeriod(wishlistItem.FrequencyUnit, wishlistItem.Frequency, product.SubscriptionPlan.NumberOfPayments);

            return GetRecurringPaymentMessage(product.Price, product.TaxCode != null ? product.TaxCode.Id : 0, product.SubscriptionPlan, paymentPeriod);
        }

        public static string GetRecurringPaymentMessage(decimal productPrice, int taxCodeId, SubscriptionPlan sp, int paymentFequency)
        {
            // GET TEXTUAL REPRESENTATION OF THE PAYMENT INTERVAL (WEEKLY, MONTHLY, EVERY 2 MONTHS, ETC.)
            string paymentPeriod = GetPaymentPeriod(sp.PaymentFrequencyUnit, paymentFequency, sp.NumberOfPayments);
            return GetRecurringPaymentMessage(productPrice, taxCodeId, sp, paymentPeriod);
        }

        public static string GetRecurringPaymentMessage(decimal productPrice, int taxCodeId, SubscriptionPlan sp, string paymentPeriod)
        {
            // GET THE PRICE WITH TAX
            decimal firstPaymentWithTax = TaxHelper.GetShopPrice(productPrice, taxCodeId);

            // DETERMINE RECURRING CHARGE WITH TAX
            decimal recurringPaymentWithTax;
            if (sp.RecurringChargeSpecified)
            {
                decimal recurringPayment = sp.RecurringChargeMode == InheritanceMode.Override ? sp.RecurringCharge : productPrice + sp.RecurringCharge;
                recurringPaymentWithTax = TaxHelper.GetShopPrice(recurringPayment, sp.RecurringTaxCode != null ? sp.RecurringTaxCode.Id : 0);
            }
            else recurringPaymentWithTax = firstPaymentWithTax;

            // DETERMINE WHETHER THERE IS A DIFFERENT FIRST AND RECURRING CHARGE
            if (firstPaymentWithTax != recurringPaymentWithTax)
            {
                // INITIAL CHARGE FOLLOWED BY ALTERNATE RECURRING AMOUNT
                if (sp.NumberOfPayments == 0)
                {
                    // PAYMENTS CONTINUE UNTIL CANCELLED
                    return string.Format("First payment of <span class=\"priceDisplay\">{0}</span>, followed by a payment of <span class=\"priceDisplay\">{1}</span> charged {2} until cancelled.", firstPaymentWithTax.LSCurrencyFormat("ulc"), recurringPaymentWithTax.LSCurrencyFormat("ulc"), paymentPeriod);
                }
                else
                {
                    // A SET NUMBER OF PAYMENTS ARE MADE
                    return string.Format("First payment of <span class=\"priceDisplay\">{0}</span>, followed by {1} payments of <span class=\"priceDisplay\">{2}</span> charged {3}.", firstPaymentWithTax.LSCurrencyFormat("ulc"), sp.NumberOfPayments - 1, recurringPaymentWithTax.LSCurrencyFormat("ulc"), paymentPeriod);
                }
            }
            else
            {
                if (sp.NumberOfPayments == 1)
                {
                    // ONE TIME CHARGE FOR A SUBSCRIPTION
                    return string.Format("Subscription is valid for {0}", paymentPeriod);
                }
                else
                {
                    // DETERMINE IF PAYMENTS ARE OPEN ENDED OR A SET NUMBER
                    string paymentEnding = (sp.NumberOfPayments == 0 ? " until cancelled." : " for " + sp.NumberOfPayments + " payments.");
                    return string.Format("Payment of <span class=\"priceDisplay\">{0}</span> charged {1}", firstPaymentWithTax.LSCurrencyFormat("ulc"), paymentPeriod) + paymentEnding;
                }
            }
        }

        private static string GetPaymentPeriod(PaymentFrequencyUnit paymentFrequencyUnit, int paymentFrequency, int numberOfPayments = 0)
        {
            // DETERMINE THE TEXTUAL REPRESENTATION OF THE PAYMENT INTERVAL (WEEKLY, MONTHLY, ETC.)
            switch (paymentFrequencyUnit)
            {
                case PaymentFrequencyUnit.Day:
                    if (numberOfPayments == 1) return paymentFrequency.ToString() + " days";    
                    if (paymentFrequency == 1) return paymentFrequency + " day";
                    if (paymentFrequency == 7) return "weekly";
                    if (paymentFrequency == 14) return "every two weeks";
                    if (paymentFrequency == 28) return "every four weeks";
                    return "every " + paymentFrequency + " days";
                case PaymentFrequencyUnit.Month:
                    if (numberOfPayments == 1) return paymentFrequency.ToString() + " months";    
                    if (paymentFrequency == 1) return paymentFrequency + " month";
                    if (paymentFrequency == 1) return "monthly";
                    if (paymentFrequency == 3) return "quarterly";
                    if (paymentFrequency == 6) return "twice per year";
                    if (paymentFrequency == 12) return "yearly";
                    return "every " + paymentFrequency + " months";
                default:
                    if (numberOfPayments == 1) return paymentFrequency.ToString() + " years";    
                    if (paymentFrequency == 1) return paymentFrequencyUnit.ToString().ToLowerInvariant() + "ly";
                    return "every " + paymentFrequency + paymentFrequencyUnit.ToString().ToLowerInvariant() + "s";
            }
        }

        private struct ProductAndOptionList
        {
            public Product Product;
            public string OptionList;
            public ProductAndOptionList(Product product, string optionList)
            {
                this.Product = product;
                this.OptionList = optionList;
            }
        }

        public static string GetThumbnailUrl(object productLineItem)
        {
            if (productLineItem is BasketItem)
            {
                BasketItem item = (BasketItem)productLineItem;
                if (item != null && item.OrderItemType == OrderItemType.Product && item.Product != null)
                {
                    if (item.ProductVariant != null && !string.IsNullOrEmpty(item.ProductVariant.ThumbnailUrl))
                        return item.ProductVariant.ThumbnailUrl;
                    else if (!string.IsNullOrEmpty(item.Product.ThumbnailUrl)) 
                        return item.Product.ThumbnailUrl;
                }
            }
            else if (productLineItem is OrderItem)
            {
                OrderItem oitem = productLineItem as OrderItem;
                if (oitem != null && oitem.OrderItemType == OrderItemType.Product)
                {
                    if (oitem.ProductVariant != null && !string.IsNullOrEmpty(oitem.ProductVariant.ThumbnailUrl))
                        return oitem.ProductVariant.ThumbnailUrl;
                    else if (oitem.Product != null && !string.IsNullOrEmpty(oitem.Product.ThumbnailUrl))
                        return oitem.Product.ThumbnailUrl;
                }
            }
            else if (productLineItem is WishlistItem)
            {
                WishlistItem item = productLineItem as WishlistItem;
                if (item.Product != null)
                {
                    if (item.ProductVariant != null && !string.IsNullOrEmpty(item.ProductVariant.ThumbnailUrl))
                        return item.ProductVariant.ThumbnailUrl;
                    else if (!string.IsNullOrEmpty(item.Product.ThumbnailUrl)) return item.Product.ThumbnailUrl;
                }
            }

            return string.Empty;
        }

        public static string GetIconUrl(object productLineItem)
        {
            if (productLineItem is BasketItem)
            {
                BasketItem bitem = productLineItem as BasketItem;
                if (bitem != null && bitem.OrderItemType == OrderItemType.Product && bitem.Product != null)
                {
                    if (bitem.ProductVariant != null && !string.IsNullOrEmpty(bitem.ProductVariant.IconUrl))
                        return bitem.ProductVariant.IconUrl;
                    else if (!string.IsNullOrEmpty(bitem.Product.IconUrl))
                        return bitem.Product.IconUrl;
                }
            }
            else if (productLineItem is OrderItem)
            {
                OrderItem oitem = productLineItem as OrderItem;
                if (oitem != null && oitem.OrderItemType == OrderItemType.Product)
                {
                    if (oitem.ProductVariant != null && !string.IsNullOrEmpty(oitem.ProductVariant.IconUrl))
                        return oitem.ProductVariant.IconUrl;
                    else if (oitem.Product != null && !string.IsNullOrEmpty(oitem.Product.IconUrl))
                        return oitem.Product.IconUrl;
                }
            }
            else if (productLineItem is WishlistItem)
            {
                WishlistItem item = productLineItem as WishlistItem;
                if (item.Product != null)
                {
                    if (item.ProductVariant != null && !string.IsNullOrEmpty(item.ProductVariant.IconUrl))
                        return item.ProductVariant.IconUrl;
                    else if (!string.IsNullOrEmpty(item.Product.IconUrl)) return item.Product.IconUrl;
                }
            }

            return string.Empty;
        }
    }
}