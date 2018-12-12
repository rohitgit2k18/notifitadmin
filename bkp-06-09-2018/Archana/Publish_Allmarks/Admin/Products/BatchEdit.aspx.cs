namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.UI.WebControls;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;
    using CommerceBuilder.Stores;

    public partial class BatchEdit : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private bool _ShowEditGrid = false;
        private bool _EnableScrolling = true;
        private List<Product> _SelectedProducts = new List<Product>();
        private List<int> _SelectedProductIds = new List<int>();
        private List<string> _SelectedFields = new List<string>();
        private Dictionary<string, string> _ProductFields = new Dictionary<string, string>();
        private Dictionary<string, string> _ProductFieldDescriptions = new Dictionary<string, string>();
        private bool _DisplayCategorySearch = false;

        public override void ProcessRequest(System.Web.HttpContext context)
        {
            try
            {
                base.ProcessRequest(context);
            }
            catch (System.Web.HttpUnhandledException ex)
            {
                Exception tempException = ex;
                string errorMessage = "An error has occurred due to the restrictions enforced by ASP.NET security settings. The page is unable to process a very large data set. You can ease the restriction by increasing the value of \"aspnet:MaxHttpCollectionKeys\" setting in web.config under website root.";
                bool isMaxHttpCollectionKeysExceededException = false;

                // check if the exception is related to ThrowIfMaxHttpCollectionKeysExceeded
                if (tempException.StackTrace.Contains("ThrowIfMaxHttpCollectionKeysExceeded"))
                    isMaxHttpCollectionKeysExceededException = true;
                else
                {
                    while (tempException.InnerException != null)
                    {
                        if (tempException.StackTrace.Contains("ThrowIfMaxHttpCollectionKeysExceeded") || tempException.InnerException.StackTrace.Contains("ThrowIfMaxHttpCollectionKeysExceeded"))
                        {
                            isMaxHttpCollectionKeysExceededException = true;
                            break;
                        }
                        else
                            tempException = tempException.InnerException;
                    }
                }

                if (isMaxHttpCollectionKeysExceededException)
                {
                    Logger.Error(errorMessage, ex);
                    // show error message with the possible fix information
                    context.Response.Write(errorMessage);                    
                }
                else 
                {
                    Logger.Error(ex.Message, ex);
                    throw ex;
                }
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // INITIALIZE FORM FIELDS
            int categoryCount = CategoryDataSource.CountAll();
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            _DisplayCategorySearch = settings.CategorySearchDisplayLimit > 0 && categoryCount >= settings.CategorySearchDisplayLimit;

            if (_DisplayCategorySearch)
            {
                // DISPLAY AUTO COMPLETE FOR CATEGORY SEARCH OPTION
                string js = PageHelper.GetAutoCompleteScript("../../CategorySuggest.ashx", CategoryAutoComplete, HiddenSelectedCategoryId, "Key", "Value");

                ScriptManager.RegisterStartupScript(EditAjax, this.GetType(), "CATEGORY_SUGGEST", js, true);
                CategoryAutoComplete.Visible = true;
                CategoryFilter.Visible = false;
            }
            else InitializeCategoryTree();
            ManufacturerFilter.DataSource = ManufacturerDataSource.LoadAll("Name");
            ManufacturerFilter.DataBind();
            VendorFilter.DataSource = VendorDataSource.LoadAll("Name");
            VendorFilter.DataBind();
            InitJs();
            LoadSearchCriteria();
            InitializeFieldSelections();

            // LOAD VIEWSTATE DATA
            LoadCustomViewState();

            // INITIALIZE GRID ACCORDING TO VIEWSTATE
            SearchPanel.Visible = !_ShowEditGrid;
            EditPanel.Visible = _ShowEditGrid;
            if (EditPanel.Visible)
            {
                BindEditGrid();
            }
        }

        private void InitializeFieldSelections()
        {
            // BUILD THE LIST OF AVAILABLE FIELDS
            _ProductFields["allowbackorder"] = "Allow Backorder";
            _ProductFields["enablenotifications"] = "Restock Notifications";
            if (AbleContext.Current.Store.Settings.ProductReviewEnabled != UserAuthFilter.None)
                _ProductFields["allowreviews"] = "Allow Reviews";
            _ProductFields["costofgoods"] = "Cost of Goods";
            _ProductFields["customurl"] = "Custom Url";
            _ProductFields["description"] = "Description";
            _ProductFields["disablepurchase"] = "Disable Purchase";
            _ProductFields["displaypage"] = "Display Page";
            _ProductFields["excludefromfeed"] = "Exclude From Feed";
            _ProductFields["isfeatured"] = "Featured";
            _ProductFields["isgiftcertificate"] = "Gift Certificate";
            _ProductFields["wrapgroupid"] = "Gift Wrap";
            _ProductFields["height"] = "Height";
            _ProductFields["hideprice"] = "Hide Price";
            _ProductFields["metadescription"] = "Meta Description";
            _ProductFields["metakeywords"] = "Meta Keywords";
            _ProductFields["iconalttext"] = "Icon Alt Text";
            _ProductFields["iconurl"] = "Icon Url";
            _ProductFields["imagealttext"] = "Image Alt Text";
            _ProductFields["imageurl"] = "Image Url";
            _ProductFields["instock"] = "In Stock";
            _ProductFields["inventorymodeid"] = "Inventory Tracking";
            _ProductFields["enablegroups"] = "Group Restrictions";
            _ProductFields["length"] = "Length";
            _ProductFields["instockwarninglevel"] = "Low Stock";
            _ProductFields["manufacturerid"] = "Manufacturer";
            _ProductFields["modelnumber"] = "Manuf. Part No.";
            _ProductFields["maximumprice"] = "Max Price";
            _ProductFields["maxquantity"] = "Max Quantity";
            _ProductFields["minimumprice"] = "Min Price";
            _ProductFields["minquantity"] = "Min Quantity";
            _ProductFields["extendeddescription"] = "More Details";
            _ProductFields["msrp"] = "MSRP";
            _ProductFields["name"] = "Name";
            _ProductFields["isprohibited"] = "Prohibited";
            _ProductFields["price"] = "Price";
            _ProductFields["shippableid"] = "Shippable";
            _ProductFields["sku"] = "SKU";
            _ProductFields["summary"] = "Summary";
            _ProductFields["taxcodeid"] = "Tax Code";
            _ProductFields["thumbnailalttext"] = "Thumbnail Alt Text";
            _ProductFields["thumbnailurl"] = "Thumbnail Url";
            _ProductFields["usevariableprice"] = "Variable Price";
            _ProductFields["vendorid"] = "Vendor";
            _ProductFields["visibilityid"] = "Visibility";
            _ProductFields["warehouseid"] = "Warehouse";
            _ProductFields["weight"] = "Weight";
            _ProductFields["width"] = "Width";

            // NEW FIELDS
            _ProductFields["title"] = "Title";
            _ProductFields["gtin"] = "GTIN";
            _ProductFields["searchkeywords"] = "Search Keywords";
            _ProductFields["htmlhead"] = "Html Head";
            _ProductFields["googlecategory"] = "Google Category";
            _ProductFields["condition"] = "Condition";
            _ProductFields["gender"] = "Gender";
            _ProductFields["agegroup"] = "Age Group";
            _ProductFields["color"] = "Color";
            _ProductFields["size"] = "Size";
            _ProductFields["adwordsgrouping"] = "Adwords Grouping";
            _ProductFields["adwordslabels"] = "Adwords Labels";
            _ProductFields["excludeddestination"] = "Excluded Destination";
            _ProductFields["adwordsredirect"] = "Adwords Redirect";
            _ProductFields["publishfeedasvariants"] = "Publish Feed As Variants";
            _ProductFields["tic"] = "TaxCloud TIC";

            // SET FIELD DESCRIPTIONS
            _ProductFieldDescriptions["allowbackorder"] = "If inventory control is enabled, check this field to enable backorder for the product.";
            _ProductFieldDescriptions["enablenotifications"] = "Enable/Disable back in stock notifications.";
            if (AbleContext.Current.Store.Settings.ProductReviewEnabled != UserAuthFilter.None)
                _ProductFieldDescriptions["allowreviews"] = "If product reviews are enabled on store then you can enable/disable reviews on product level through this Allow Review property.";
            _ProductFieldDescriptions["costofgoods"] = "The cost of goods for this product - what you pay to acquire your inventory.";
            _ProductFieldDescriptions["customurl"] = "You can provide a custom URL to access your product. This URL will override the default one generated by system.";
            _ProductFieldDescriptions["description"] = "The main description of the product that is usually shown on the product detail page.";
            _ProductFieldDescriptions["disablepurchase"] = "When checked, this product cannot be purchased by a customer.";
            _ProductFieldDescriptions["displaypage"] = "Indicates the web display page used when the product is viewed.";
            _ProductFieldDescriptions["excludefromfeed"] = "When checked, this product is not included in automated product feeds such as Google Base.";
            _ProductFieldDescriptions["extendeddescription"] = "An extended description of the product that can be viewed by the customer.";
            _ProductFieldDescriptions["height"] = "The shipping height of the product.";
            _ProductFieldDescriptions["hideprice"] = "When checked, the price of the product is not shown until the customer requests to see it or adds the item to the basket.";
            _ProductFieldDescriptions["metadescription"] = "Any content here will be put into the meta description for the product display page.";
            _ProductFieldDescriptions["metakeywords"] = "Any content here will be put into the meta keywords for the product display page.";
            _ProductFieldDescriptions["iconalttext"] = "Alternate text for the icon image.";
            _ProductFieldDescriptions["iconurl"] = "The product icon image.";
            _ProductFieldDescriptions["imagealttext"] = "Alternate text for the main product image.";
            _ProductFieldDescriptions["imageurl"] = "The main product image.";
            _ProductFieldDescriptions["instock"] = "Indicates the count of the product currenly in stock.  This value is only effective if inventory tracking is enabled for the store and the product is set to track inventory at the product level.";
            _ProductFieldDescriptions["instockwarninglevel"] = "Indicates the inventory level at which a warning notice will be sent to the merchant.  This value is only effective if inventory tracking is enabled for the store and the product is set to track inventory.";
            _ProductFieldDescriptions["inventorymodeid"] = "Indicates the inventory mode for the product.  This value is only effective if inventory tracking is enabled for the store.";
            _ProductFieldDescriptions["enablegroups"] = "Enable/Disable group based access to this product.";
            _ProductFieldDescriptions["isfeatured"] = "When checked, the product is marked as featured.";
            _ProductFieldDescriptions["isgiftcertificate"] = "When checked, the product generates a gift certificate when it is purchased.";
            _ProductFieldDescriptions["isprohibited"] = "When checked, this product cannot be purchased with Google Checkout or PayPal.";
            _ProductFieldDescriptions["length"] = "The shipping length of the product.";
            _ProductFieldDescriptions["manufacturerid"] = "The manufacturer of the product.";
            _ProductFieldDescriptions["maximumprice"] = "The maximum price that can be set for the product.  This value is only effective if the product uses variable pricing.";
            _ProductFieldDescriptions["maxquantity"] = "The maximum quantity of the product that can be purchased by a customer in a single order.";
            _ProductFieldDescriptions["minimumprice"] = "The minimum price that can be set for the product.  This value is only effective if the product uses variable pricing.";
            _ProductFieldDescriptions["minquantity"] = "The minimum quantity of the product that must be purchased by a customer in a single order.";
            _ProductFieldDescriptions["modelnumber"] = "The model number of the product.";
            _ProductFieldDescriptions["msrp"] = "The manufacturer suggested retail price of the product.";
            _ProductFieldDescriptions["name"] = "The name of the product.";
            _ProductFieldDescriptions["price"] = "The base price of the product.";
            _ProductFieldDescriptions["shippableid"] = "Indicates whether or not the product is shippable.";
            _ProductFieldDescriptions["sku"] = "The SKU of the product.";
            _ProductFieldDescriptions["summary"] = "A summary description of the product.  This generally appears on category or search display pages where the product is listed with other products.";
            _ProductFieldDescriptions["taxcodeid"] = "The tax code of the product.";
            _ProductFieldDescriptions["thumbnailalttext"] = "Alternate text for the thumbnail image.";
            _ProductFieldDescriptions["thumbnailurl"] = "Thumbnail image for the prdocut.";
            _ProductFieldDescriptions["usevariableprice"] = "When checked, the product is set to use a variable price that can be adjusted by the customer at checkout.  Useful for sales of gift certificates or donation items.";
            _ProductFieldDescriptions["vendorid"] = "The vendor of the product.";
            _ProductFieldDescriptions["visibilityid"] = "Indicates whether the product is visible on the retail store website.";
            _ProductFieldDescriptions["warehouseid"] = "The warehouse of the product.";
            _ProductFieldDescriptions["weight"] = "The shipping weight of the product.";
            _ProductFieldDescriptions["width"] = "The shipping width of the prodouct.";
            _ProductFieldDescriptions["wrapgroupid"] = "The gift wrapping styles associated with the product.";

            // New fields
            _ProductFieldDescriptions["title"] = "Title of the product displayed for catalog display";
            _ProductFieldDescriptions["gtin"] = "The UPC, ISBN, or GTIN of the product.";
            _ProductFieldDescriptions["searchkeywords"] = "The data like keywords and frequent misspellings. It will always be searched on the retail site.";
            _ProductFieldDescriptions["htmlhead"] = "The custom data for HTML HEAD portion";
            _ProductFieldDescriptions["googlecategory"] = "If using Google Feed, select the appropriate category for this product.";
            _ProductFieldDescriptions["condition"] = "Describe the condition of the product.";
            _ProductFieldDescriptions["gender"] = "If the product has a specific gender associated you can specify it here.  This usually applies only to clothing items.";
            _ProductFieldDescriptions["agegroup"] = "If the product is associated with a specific age group you can specify it here.  This usually applies only to clothing items.";
            _ProductFieldDescriptions["color"] = "The color of the item - this is required for Google Feed to list apparel items";
            _ProductFieldDescriptions["size"] = "The size of the item - this is required for Google Feed to list clothing or shoes.";
            _ProductFieldDescriptions["adwordsgrouping"] = "Used to group products in an arbitrary way. It can be used for Product Filters to limit a campaign to a group of products, or Product Targets to bid differently for a group of products. This is a required field if the advertiser wants to bid differently to different subsets of products in the CPC or CPA % version. It can only hold one value.";
            _ProductFieldDescriptions["adwordslabels"] = "Very similar to adwords_grouping, but it will only only work on CPC. It can hold multiple values, allowing a product to be tagged with multiple labels.";
            _ProductFieldDescriptions["excludeddestination"] = "Specify a value if you are using either Google Shopping or Commerce Search and you would like to exclude the item from either of these destinations.";
            _ProductFieldDescriptions["adwordsredirect"] = "Allows advertisers to override the product URL when the product is shown within the context of Product Ads. This allows advertisers to track different sources of traffic separately from Google Shopping.";
            _ProductFieldDescriptions["publishfeedasvariants"] = "Indicates that this product should be published in google feed as a single product or as multiple variants. Google define variants as a group of identical products that only differ by the attributes ‘color’, ‘material’, ‘pattern’, or ‘size’.";
            _ProductFieldDescriptions["tic"] = "TaxCloud Taxability Information Code need to specified if the TIC of this product differs from default TIC.";

            // DRAW SELECTED FIELDS
            SelectedFields.Items.Clear();
            List<string> defaultFields = GetDefaultFields();
            foreach (string field in defaultFields)
            {
                SelectedFields.Items.Add(new ListItem(_ProductFields[field], field));
            }

            // DRAW AVAILABLE FIELDS
            AvailableFields.Items.Clear();
            foreach (string field in _ProductFields.Keys)
            {
                if (!defaultFields.Contains(field))
                {
                    AvailableFields.Items.Add(new ListItem(_ProductFields[field], field));
                }
            }

        }

        private List<string> GetDefaultFields()
        {
            List<string> defaultFields = new List<string>();
            string defaultFieldList = AbleContext.Current.User.Settings.GetValueByKey("BatchEditFieldList");
            if (!string.IsNullOrEmpty(defaultFieldList))
            {
                string[] defaultFieldArray = defaultFieldList.Split(",".ToCharArray());
                foreach (string field in defaultFieldArray)
                {
                    string cleanField = field.Trim().ToLowerInvariant();
                    if (IsValidField(cleanField))
                    {
                        defaultFields.Add(cleanField);
                    }
                }
            }
            if (defaultFields.Count == 0)
            {
                defaultFields.Add("instock");
                defaultFields.Add("name");
                defaultFields.Add("price");
                defaultFields.Add("sku");
            }
            return defaultFields;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool rebind = false;

            // DETERMINE IF EVENTS NEED TO BE HANDLED
            string eventTarget = Request.Form["__EVENTTARGET"];
            if (eventTarget == SearchButton.UniqueID)
            {
                SearchButton_Click();
                rebind = true;
            }
            else if (eventTarget == NewSearchButton.UniqueID)
            {
                NewSearchButton_Click();
                rebind = true;
            }
            else if (eventTarget == SaveButton.UniqueID)
            {
                SaveGrid();
                rebind = true;
            }

            // REBIND GRID IF NEEDED IN RESPONSE TO ACTION
            if (rebind)
            {
                SearchPanel.Visible = !_ShowEditGrid;
                EditPanel.Visible = _ShowEditGrid;
                if (EditPanel.Visible)
                {
                    BindEditGrid();
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            SaveCustomViewState();
        }

        protected void InitializeCategoryTree()
        {
            IList<CategoryLevelNode> categories = CategoryParentDataSource.GetCategoryLevels(0);
            foreach (CategoryLevelNode node in categories)
            {
                string prefix = string.Empty;
                for (int i = 0; i <= node.CategoryLevel; i++) prefix += " . . ";
                CategoryFilter.Items.Add(new ListItem(prefix + node.Name, node.CategoryId.ToString()));
            }
        }

        private void BindEditGrid()
        {
            // START TABLE
            BatchEditGrid.Controls.Clear();
            if (_EnableScrolling) BatchEditGrid.Controls.Add(new LiteralControl("<div style=\"width:100%;overflow:auto;\">"));
            BatchEditGrid.Controls.Add(new LiteralControl("<table cellspacing=\"0\" class=\"pagedList\" width=\"100%\">\n"));

            // DRAW HEADERS
            BatchEditGrid.Controls.Add(new LiteralControl("<tr>\n"));
            BatchEditGrid.Controls.Add(new LiteralControl("<th align=\"left\">Product</th>"));
            foreach (string field in _SelectedFields)
            {
                BatchEditGrid.Controls.Add(new LiteralControl(string.Format("<th align=\"left\" nowrap>")));
                ToolTipLabel colHeader = new ToolTipLabel();
                colHeader.Text = _ProductFields[field];
                colHeader.ToolTip = _ProductFieldDescriptions[field];
                colHeader.SkinID = "ColHeader";
                BatchEditGrid.Controls.Add(colHeader);
                BatchEditGrid.Controls.Add(new LiteralControl("</th>"));
            }
            BatchEditGrid.Controls.Add(new LiteralControl("</tr>\n"));

            // DRAW ROWS
            bool isOddRow = true;
            foreach (Product product in _SelectedProducts)
            {
                if (isOddRow) BatchEditGrid.Controls.Add(new LiteralControl("<tr class=\"oddRow\">\n"));
                else BatchEditGrid.Controls.Add(new LiteralControl("<tr class=\"evenRow\">\n"));
                isOddRow = !isOddRow;
                string productUrl = "../Products/EditProduct.aspx?ProductId=" + product.Id;
                BatchEditGrid.Controls.Add(new LiteralControl(string.Format("<td>\n<input type=\"hidden\" name=\"P{0}\" value=\"1\">\n<a href=\"{2}\">{1}</a>\n</td>\n", product.Id, Server.HtmlEncode(product.Name), productUrl)));
                foreach (string field in _SelectedFields)
                {
                    string cellAlignment;
                    List<Control> controls = DrawField(product, field, out cellAlignment);
                    if (controls != null && controls.Count > 0)
                    {
                        if (!string.IsNullOrEmpty(cellAlignment)) BatchEditGrid.Controls.Add(new LiteralControl("<td align=\"" + cellAlignment + "\" nowrap>\n"));
                        else BatchEditGrid.Controls.Add(new LiteralControl("<td nowrap>\n"));
                        foreach (Control wc in controls) BatchEditGrid.Controls.Add(wc);
                        BatchEditGrid.Controls.Add(new LiteralControl("</td>\n"));
                    }
                    else BatchEditGrid.Controls.Add(new LiteralControl("<td>&nbsp</td>"));
                }
                BatchEditGrid.Controls.Add(new LiteralControl("</tr>\n"));
            }

            // CLOSE TABLE
            BatchEditGrid.Controls.Add(new LiteralControl("</table>\n"));
            if (_EnableScrolling) BatchEditGrid.Controls.Add(new LiteralControl("</div>\n"));
        }

        protected void SearchButton_Click()
        {
            _SelectedProducts.Clear();
            _SelectedProductIds.Clear();
            int categoryId = 0;
            if (!_DisplayCategorySearch) categoryId = AlwaysConvert.ToInt(CategoryFilter.SelectedValue);
            else categoryId = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);

            IList<Product> products = ProductDataSource.FindProducts(NameFilter.Text, SkuFilter.Text, categoryId,
                AlwaysConvert.ToInt(ManufacturerFilter.SelectedValue), AlwaysConvert.ToInt(VendorFilter.SelectedValue), BitFieldState.Any, 0,
                AlwaysConvert.ToInt(MaximumRows.SelectedValue), 0, string.Empty);
            if (products.Count > 0)
            {
                foreach (Product product in products) AddProductToList(product);
                BuildFieldList(HiddenSelectedFields.Value);
                SaveSearchCriteria();
                _ShowEditGrid = true;
                _EnableScrolling = EnableScrolling.Checked;

                // CHECK IF A WARNING NEED TO BE DISPlAYED
                int fieldsCount = _SelectedFields.Count * _SelectedProducts.Count;
                int allowedMaximumFields = AlwaysConvert.ToInt(System.Configuration.ConfigurationManager.AppSettings.Get("aspnet:MaxHttpCollectionKeys"));
                WarningPanel.Visible = fieldsCount > (allowedMaximumFields - 50);
            }
            else
            {
                NoResultsMessage.Visible = true;
                _ShowEditGrid = false;
            }
        }

        private void LoadSearchCriteria()
        {
            string searchCriteriaList = AbleContext.Current.User.Settings.GetValueByKey("BatchEditSearchCriteria");
            if (!string.IsNullOrEmpty(searchCriteriaList))
            {
                string[] searchCriteriaArray = searchCriteriaList.Split("|".ToCharArray());
                if (searchCriteriaArray.Length == 7)
                {
                    NameFilter.Text = searchCriteriaArray[0];
                    SkuFilter.Text = searchCriteriaArray[1];
                    ListItem selItem = null;
                    if (!_DisplayCategorySearch)
                    {
                        selItem = CategoryFilter.Items.FindByValue(searchCriteriaArray[2]);
                        if (selItem != null) CategoryFilter.SelectedIndex = CategoryFilter.Items.IndexOf(selItem);
                    }
                    else
                    {
                        Category selectedCategory = CategoryDataSource.Load(AlwaysConvert.ToInt(searchCriteriaArray[2]));
                        if (selectedCategory != null) CategoryAutoComplete.Text = selectedCategory.Name;
                        HiddenSelectedCategoryId.Value = searchCriteriaArray[2];
                    }

                    selItem = ManufacturerFilter.Items.FindByValue(searchCriteriaArray[3]);
                    if (selItem != null) ManufacturerFilter.SelectedIndex = ManufacturerFilter.Items.IndexOf(selItem);
                    selItem = VendorFilter.Items.FindByValue(searchCriteriaArray[4]);
                    if (selItem != null) VendorFilter.SelectedIndex = VendorFilter.Items.IndexOf(selItem);
                    selItem = MaximumRows.Items.FindByValue(searchCriteriaArray[5]);
                    if (selItem != null) MaximumRows.SelectedIndex = MaximumRows.Items.IndexOf(selItem);
                    EnableScrolling.Checked = AlwaysConvert.ToBool(searchCriteriaArray[6], true);
                }
            }
        }

        private void SaveSearchCriteria()
        {
            User user = AbleContext.Current.User;
            // SAVE CRITERIA
            List<string> searchCriteria = new List<string>();
            searchCriteria.Add(NameFilter.Text);
            searchCriteria.Add(SkuFilter.Text);
            if (!_DisplayCategorySearch) searchCriteria.Add(CategoryFilter.SelectedValue);
            else searchCriteria.Add(HiddenSelectedCategoryId.Value);
            searchCriteria.Add(ManufacturerFilter.SelectedValue);
            searchCriteria.Add(VendorFilter.SelectedValue);
            searchCriteria.Add(MaximumRows.SelectedValue);
            searchCriteria.Add(EnableScrolling.Checked.ToString());
            user.Settings.SetValueByKey("BatchEditSearchCriteria", string.Join("|", searchCriteria.ToArray()));
            // SAVE FIELDS
            string defaultFields = string.Empty;
            if (_SelectedFields.Count > 0) defaultFields = string.Join(",", _SelectedFields.ToArray());
            user.Settings.SetValueByKey("BatchEditFieldList", defaultFields);
            // UPDATE USER
            user.Save();
        }

        private void NewSearchButton_Click()
        {
            _ShowEditGrid = false;
        }

        private void InitJs()
        {
            this.Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "selectbox", this.ResolveUrl("~/Scripts/selectbox.js"));
            string unselectedBoxName = AvailableFields.ClientID;
            string selectedBoxName = SelectedFields.ClientID;
            AvailableFields.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + unselectedBoxName + "'], this.form['" + selectedBoxName + "'], true, '')");
            SelectedFields.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + selectedBoxName + "'], this.form['" + unselectedBoxName + "'], true, '');");
            SelectAllFields.Attributes.Add("onclick", "moveAllOptions(this.form['" + unselectedBoxName + "'], this.form['" + selectedBoxName + "'], true, ''); return false;");
            SelectField.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + unselectedBoxName + "'], this.form['" + selectedBoxName + "'], true, ''); return false;");
            UnselectField.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + selectedBoxName + "'], this.form['" + unselectedBoxName + "'], true, ''); return false;");
            UnselectAllFields.Attributes.Add("onclick", "moveAllOptions(this.form['" + selectedBoxName + "'], this.form['" + unselectedBoxName + "'], true, ''); return false;");
            SearchButton.OnClientClick = "var ele=document.getElementById('" + HiddenSelectedFields.ClientID + "');ele.value=getOptions(document.getElementById('" + selectedBoxName + "'));";

            // CUSTOM JAVASCRIPT TO WORK WITH EDITOR BOX
            StringBuilder script = new StringBuilder();
            script.Append("var _EditHtmlFieldRef = null;\n");
            script.Append("function ShowEditHtmlDialog(fieldId)\n");
            script.Append("{\n");
            script.Append("\tvar callerField = document.getElementById(fieldId);\n");
            script.Append("\tvar destextRef = document.getElementById('" + EditDescription.ClientID + "');\n");
            script.Append("\tif (callerField && destextRef)\n");
            script.Append("\t{\n");
            script.Append("\t\t_EditHtmlFieldRef= fieldId;\n");
            script.Append("\t\tdestextRef.value = callerField.value;\n");
            script.Append("\t\t$find('" + EditHtmlPopup.ClientID + "').show();\n");
            script.Append("\t\tdestextRef.focus();\n");
            script.Append("\t}\n");
            script.Append("}\n");
            script.Append("function SaveEditHtmlDialog()\n");
            script.Append("{\n");            
            script.Append("\tvar callerField = document.getElementById(_EditHtmlFieldRef);\n");
            script.Append("\tvar destextRef = document.getElementById('" + EditDescription.ClientID + "');\n");
            script.Append("\tif (callerField && destextRef) callerField.value = destextRef.value;\n");
            script.Append("\treturn HideEditHtmlDialog();\n");
            script.Append("}\n");
            script.Append("function HideEditHtmlDialog()\n");
            script.Append("{\n");
            script.Append("\tvar callerField = document.getElementById(_EditHtmlFieldRef);\n");
            script.Append("\tif (callerField) callerField.focus();\n");
            script.Append("\t_EditHtmlFieldRef = null;\n");
            script.Append("\t$find('" + EditHtmlPopup.ClientID + "').hide();\n");
            script.Append("\treturn false;\n");
            script.Append("}\n\n");
            script.Append("var _EditLongTextFieldRef = null;\n");
            script.Append("function ShowEditLongTextDialog(fieldId)\n");
            script.Append("{\n");
            script.Append("\tvar callerField = document.getElementById(fieldId);\n");
            script.Append("\tvar textRef = document.getElementById('" + EditLongText.ClientID + "');\n");
            script.Append("\tif (callerField && textRef)\n");
            script.Append("\t{\n");
            script.Append("\t\t_EditLongTextFieldRef = fieldId;\n");
            script.Append("\t\ttextRef.value = callerField.value;\n");
            script.Append("\t\t$find('" + EditLongTextPopup.ClientID + "').show();\n");
            script.Append("\t\ttextRef.focus();\n");
            script.Append("\t}\n");
            script.Append("}\n");
            script.Append("function SaveEditLongTextDialog()\n");
            script.Append("{\n");
            script.Append("\tvar callerField = document.getElementById(_EditLongTextFieldRef);\n");
            script.Append("\tvar textRef = document.getElementById('" + EditLongText.ClientID + "');\n");
            script.Append("\tif (callerField && textRef) callerField.value = textRef.value;\n");
            script.Append("\treturn HideEditLongTextDialog();\n");
            script.Append("}\n");
            script.Append("function HideEditLongTextDialog()\n");
            script.Append("{\n");
            script.Append("\tvar callerField = document.getElementById(_EditLongTextFieldRef);\n");
            script.Append("\tif (callerField) callerField.focus();\n");
            script.Append("\t_EditLongTextFieldRef = null;\n");
            script.Append("\t$find('" + EditLongTextPopup.ClientID + "').hide();\n");
            script.Append("\treturn false;\n");
            script.Append("}\n\n");
            this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "editHtmlDialog", script.ToString(), true);
        }

        private void AddProductToList(int productId)
        {
            AddProductToList(ProductDataSource.Load(productId));
        }

        private void AddProductToList(Product product)
        {
            if (product != null && !_SelectedProductIds.Contains(product.Id))
            {
                _SelectedProducts.Add(product);
                _SelectedProductIds.Add(product.Id);
            }
        }

        private void BuildFieldList(string fieldList)
        {
            _SelectedFields.Clear();
            if (!string.IsNullOrEmpty(fieldList))
            {
                string[] tempFields = fieldList.Split(",".ToCharArray());
                if (tempFields != null && tempFields.Length > 0)
                {
                    for (int i = 0; i < tempFields.Length; i++)
                    {
                        AddFieldToList(tempFields[i]);
                    }
                }
            }
        }

        private void AddFieldToList(string field)
        {
            if (IsValidField(field) && !_SelectedFields.Contains(field))
                _SelectedFields.Add(field);
        }

        private bool IsValidField(string field)
        {
            if (field != null)
            {
                string cleanField = field.Trim().ToLowerInvariant();
                foreach (string key in _ProductFields.Keys)
                {
                    if (key.ToLowerInvariant() == cleanField) return true;
                }
            }
            return false;
        }

        private List<Control> DrawCheckField(int productId, string field, bool initialChecked)
        {
            List<Control> controls = new List<Control>();
            string checkedValue = initialChecked ? " checked" : string.Empty;
            controls.Add(new LiteralControl(string.Format("<input type=\"checkbox\" name=\"P{0}_{1}\" value=\"1\"{2}>\n", productId, field, checkedValue)));
            return controls;
        }

        private List<Control> DrawTextField(int productId, string field, string initialValue, int maxlength, int width, bool required)
        {
            List<Control> controls = new List<Control>();
            controls.Add(new LiteralControl(string.Format("<input type=\"text\" name=\"P{0}_{1}\" value=\"{2}\" maxlength=\"{3}\" style=\"width:{4}px\">\n", productId, field, Server.HtmlEncode(initialValue), maxlength, width)));
            return controls;
        }

        private List<Control> DrawLongTextField(int productId, string field, string initialValue, int width)
        {
            List<Control> controls = new List<Control>();
            string fieldId = string.Format("P{0}_{1}", productId, field);
            controls.Add(new LiteralControl(string.Format("<input type=\"text\" name=\"{0}\" id=\"{0}\" value=\"{1}\" style=\"width:{2}px\"><input type=\"button\" value=\"  ..  \" onclick=\"ShowEditLongTextDialog('{0}');return false;\">\n", fieldId, Server.HtmlEncode(initialValue), width)));
            return controls;
        }

        private List<Control> DrawHtmlField(int productId, string field, string initialValue, int width)
        {
            List<Control> controls = new List<Control>();
            string fieldId = string.Format("P{0}_{1}", productId, field);
            controls.Add(new LiteralControl(string.Format("<input type=\"text\" name=\"{0}\" id=\"{0}\" value=\"{1}\" style=\"width:{2}px\"><input type=\"button\" value=\"  ..  \" onclick=\"ShowEditHtmlDialog('{0}');return false;\">\n", fieldId, Server.HtmlEncode(initialValue), width)));
            return controls;
        }

        private List<Control> DrawNumberField(int productId, string field, string initialValue, int maxlength, int width, bool required)
        {
            List<Control> controls = new List<Control>();
            controls.Add(new LiteralControl(string.Format("<input type=\"text\" name=\"P{0}_{1}\" value=\"{2}\" maxlength=\"{3}\" style=\"width:{4}px\">\n", productId, field, Server.HtmlEncode(initialValue), maxlength, width)));
            return controls;
        }

        private List<Control> DrawDropDownField(int productId, string field, List<ListItem> items, string selectedValue, bool showHeader)
        {
            return DrawDropDownField(productId, field, items, selectedValue, showHeader, string.Empty);
        }

        private List<Control> DrawDropDownField(int productId, string field, List<ListItem> items, string selectedValue, bool showHeader, string headerText)
        {
            // BUILD THE SELECT BOX
            StringBuilder sb = new StringBuilder();
            sb.Append(string.Format("<select name=\"P{0}_{1}\">\n", productId, field));
            if (showHeader) sb.Append("<option value=\"\">" + headerText + "</option>\n");
            foreach (ListItem item in items)
            {
                sb.Append("<option value=\"" + Server.HtmlEncode(item.Value) + "\"");
                if (item.Value == selectedValue) sb.Append(" selected");
                sb.Append(">" + Server.HtmlEncode(item.Text) + "</option>\n");
            }
            sb.Append("</select>\n");

            // CREATE AND RETURN THE LITERAL CONTROL
            List<Control> controls = new List<Control>();
            controls.Add(new LiteralControl(sb.ToString()));
            return controls;
        }

        private List<Control> DrawField(Product product, string field, out string cellAlignment)
        {
            cellAlignment = string.Empty;
            if (field != null)
            {
                string cleanField = field.Trim().ToLowerInvariant();
                switch (cleanField)
                {
                    case "allowbackorder":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.AllowBackorder);
                    case "enablenotifications":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.EnableRestockNotifications);
                    case "allowreviews":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.AllowReviews);
                    case "costofgoods":
                        return DrawNumberField(product.Id, cleanField, product.CostOfGoods.ToString("F2"), 10, 50, false);
                    case "customurl":
                        return DrawTextField(product.Id, cleanField, product.CustomUrl, 150, 150, false);
                    case "description":
                        return DrawHtmlField(product.Id, cleanField, product.Description, 200);
                    case "disablepurchase":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.DisablePurchase);
                    case "displaypage":
                        int webpageId = product.Webpage != null ? product.Webpage.Id : 0;
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), webpageId.ToString(), true, "Inherit");
                    case "excludefromfeed":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.ExcludeFromFeed);
                    case "extendeddescription":
                        return DrawHtmlField(product.Id, cleanField, product.ExtendedDescription, 200);
                    case "height":
                        return DrawNumberField(product.Id, cleanField, product.Height.ToString("F2"), 10, 50, false);
                    case "hideprice":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.HidePrice);
                    case "metadescription":
                        return DrawLongTextField(product.Id, cleanField, product.MetaDescription, 200);
                    case "metakeywords":
                        return DrawLongTextField(product.Id, cleanField, product.MetaKeywords, 200);
                    case "iconalttext":
                        return DrawTextField(product.Id, cleanField, product.IconAltText, 255, 200, false);
                    case "iconurl":
                        return DrawTextField(product.Id, cleanField, product.IconUrl, 255, 200, false);
                    case "imagealttext":
                        return DrawTextField(product.Id, cleanField, product.ImageAltText, 255, 200, false);
                    case "imageurl":
                        return DrawTextField(product.Id, cleanField, product.ImageUrl, 255, 200, false);
                    case "instock":
                        return DrawNumberField(product.Id, cleanField, product.InStock.ToString(), 10, 50, false);
                    case "instockwarninglevel":
                        return DrawNumberField(product.Id, cleanField, product.InStockWarningLevel.ToString(), 10, 50, false);
                    case "inventorymodeid":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.InventoryModeId.ToString(), false);
                    case "enablegroups":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.EnableGroups.ToString().ToLower(), false);
                    case "isfeatured":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.IsFeatured);
                    case "isgiftcertificate":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.IsGiftCertificate);
                    case "isprohibited":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.IsProhibited);
                    case "length":
                        return DrawNumberField(product.Id, cleanField, product.Length.ToString("F2"), 10, 50, false);
                    case "manufacturerid":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.ManufacturerId.ToString(), true);
                    case "maximumprice":
                        return DrawNumberField(product.Id, cleanField, product.MaximumPrice.LSCurrencyFormat("F2"), 10, 50, false);
                    case "maxquantity":
                        return DrawNumberField(product.Id, cleanField, product.MaxQuantity.ToString(), 10, 50, false);
                    case "minimumprice":
                        return DrawNumberField(product.Id, cleanField, product.MinimumPrice.LSCurrencyFormat("F2"), 10, 50, false);
                    case "minquantity":
                        return DrawNumberField(product.Id, cleanField, product.MinQuantity.ToString(), 10, 50, false);
                    case "modelnumber":
                        return DrawTextField(product.Id, cleanField, product.ModelNumber, 40, 80, false);
                    case "msrp":
                        return DrawNumberField(product.Id, cleanField, product.MSRP.ToString("F2"), 10, 50, false);
                    case "name":
                        return DrawTextField(product.Id, cleanField, product.Name, 255, 200, true);
                    case "price":
                        return DrawNumberField(product.Id, cleanField, product.Price.ToString("F2"), 10, 50, false);
                    case "shippableid":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.ShippableId.ToString(), false);
                    case "sku":
                        return DrawTextField(product.Id, cleanField, product.Sku, 40, 80, false);
                    case "summary":
                        return DrawLongTextField(product.Id, cleanField, product.Summary, 200);
                    case "taxcodeid":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.TaxCodeId.ToString(), true);
                    case "thumbnailalttext":
                        return DrawTextField(product.Id, cleanField, product.ThumbnailAltText, 255, 200, false);
                    case "thumbnailurl":
                        return DrawTextField(product.Id, cleanField, product.ThumbnailUrl, 255, 200, false);
                    case "usevariableprice":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.UseVariablePrice);
                    case "vendorid":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.VendorId.ToString(), true);
                    case "visibilityid":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.VisibilityId.ToString(), false);
                    case "warehouseid":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.WarehouseId.ToString(), false);
                    case "weight":
                        return DrawNumberField(product.Id, cleanField, product.Weight.ToString("F2"), 10, 50, false);
                    case "width":
                        return DrawNumberField(product.Id, cleanField, product.Width.ToString("F2"), 10, 50, false);
                    case "wrapgroupid":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.WrapGroupId.ToString(), true);

                    // NEW FIELDS
                    case "title":
                        return DrawTextField(product.Id, cleanField, product.Title, 255, 200, false);
                    case "gtin":
                        return DrawTextField(product.Id, cleanField, product.GTIN, 255, 200, false);
                    case "searchkeywords":
                        return DrawTextField(product.Id, cleanField, product.SearchKeywords, 255, 200, false);
                    case "htmlhead":
                        return DrawTextField(product.Id, cleanField, product.HtmlHead, 255, 200, false);
                    case "googlecategory":
                        return DrawTextField(product.Id, cleanField, product.GoogleCategory, 255, 200, false);
                    case "condition":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.Condition, false);
                    case "gender":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.Gender, false);
                    case "agegroup":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.AgeGroup, false);
                    case "color":
                        return DrawTextField(product.Id, cleanField, product.Color, 255, 200, false);
                    case "size":
                        return DrawTextField(product.Id, cleanField, product.Size, 255, 200, false);
                    case "adwordsgrouping":
                        return DrawTextField(product.Id, cleanField, product.AdwordsGrouping, 255, 200, false);
                    case "adwordslabels":
                        return DrawTextField(product.Id, cleanField, product.AdwordsLabels, 255, 200, false);
                    case "excludeddestination":
                        return DrawDropDownField(product.Id, cleanField, GetListItems(product, cleanField), product.ExcludedDestination, false);
                    case "adwordsredirect":
                        return DrawTextField(product.Id, cleanField, product.AdwordsRedirect, 255, 200, false);
                    case "publishfeedasvariants":
                        cellAlignment = "center";
                        return DrawCheckField(product.Id, cleanField, product.PublishFeedAsVariants);
                    case "tic":
                        return DrawTextField(product.Id, cleanField, product.TIC.ToString(), 10, 200, false);
                }
            }
            return null;
        }

        private Dictionary<string, List<ListItem>> _ListItemCache = new Dictionary<string, List<ListItem>>();
        private List<ListItem> GetListItems(Product product, string field)
        {
            if (!_ListItemCache.ContainsKey(field))
            {
                // LIST ITEMS NOT CACHED, CONSTRUCT THEM
                // SET THE CACHE FLAG TO FALSE IF THE OPTIONS DEPEND ON THE PRODUCT
                bool enableCache = true;
                List<ListItem> listItems = new List<ListItem>();
                switch (field)
                {
                    case "displaypage":
                        IList<Webpage> webpages = WebpageDataSource.LoadForWebpageType(WebpageType.ProductDisplay);
                        foreach (Webpage webpage in webpages)
                        {
                            listItems.Add(new ListItem(webpage.Name, webpage.Id.ToString()));
                        }
                        break;
                    case "inventorymodeid":
                        enableCache = false;
                        listItems.Add(new ListItem("Disabled", "0"));
                        if (AbleContext.Current.Store.Settings.EnableInventory)
                        {
                            listItems.Add(new ListItem("Track Product", "1"));
                            if (product.Variants.Count > 0)
                            {
                                listItems.Add(new ListItem("Track Variants", "2"));
                            }
                        }
                        break;
                    case "enablegroups":
                        enableCache = false;
                        listItems.Add(new ListItem("Enabled", "true"));
                        listItems.Add(new ListItem("Disabled", "false"));
                        
                        break;
                    case "manufacturerid":
                        IList<Manufacturer> manufacturers = ManufacturerDataSource.LoadAll("Name");
                        foreach (Manufacturer manufacturer in manufacturers)
                        {
                            listItems.Add(new ListItem(manufacturer.Name, manufacturer.Id.ToString()));
                        }
                        break;
                    case "shippableid":
                        listItems.Add(new ListItem("No", "0"));
                        listItems.Add(new ListItem("Yes", "1"));
                        listItems.Add(new ListItem("Separately", "2"));
                        break;
                    case "taxcodeid":
                        IList<TaxCode> taxCodes = TaxCodeDataSource.LoadAll("Name");
                        foreach (TaxCode taxCode in taxCodes)
                        {
                            listItems.Add(new ListItem(taxCode.Name, taxCode.Id.ToString()));
                        }
                        break;
                    case "vendorid":
                        IList<Vendor> vendors = VendorDataSource.LoadAll("Name");
                        foreach (Vendor vendor in vendors)
                        {
                            listItems.Add(new ListItem(vendor.Name, vendor.Id.ToString()));
                        }
                        break;
                    case "visibilityid":
                        listItems.Add(new ListItem("Public", "0"));
                        listItems.Add(new ListItem("Hidden", "1"));
                        listItems.Add(new ListItem("Private", "2"));
                        break;
                    case "warehouseid":
                        IList<Warehouse> warehouses = WarehouseDataSource.LoadAll("Name");
                        foreach (Warehouse warehouse in warehouses)
                        {
                            listItems.Add(new ListItem(warehouse.Name, warehouse.Id.ToString()));
                        }
                        break;
                    case "wrapgroupid":
                        IList<WrapGroup> wrapGroups = WrapGroupDataSource.LoadAll("Name");
                        foreach (WrapGroup wrapGroup in wrapGroups)
                        {
                            listItems.Add(new ListItem(wrapGroup.Name, wrapGroup.Id.ToString()));
                        }
                        break;
                    case "condition":
                        string[] itemNames = new string[] { "New", "Used", "Refurbished" };
                        foreach (string itemName in itemNames)
                        {
                            listItems.Add(new ListItem(itemName, itemName));
                        }
                        break;
                    case "gender":
                        itemNames = new string[] { "Unisex", "Male", "Female" };
                        foreach (string itemName in itemNames)
                        {
                            listItems.Add(new ListItem(itemName, itemName));
                        }
                        break;
                    case "agegroup":
                       itemNames = new string[] { "", "Adult", "Kids" };
                       foreach (string itemName in itemNames)
                       {
                           listItems.Add(new ListItem(itemName, itemName));
                       }
                        break;
                    case "excludeddestination":
                        itemNames = new string[] { "", "Shopping", "Commerce Search" };
                        foreach (string itemName in itemNames)
                        {
                            listItems.Add(new ListItem(itemName, itemName));
                        }
                        break;
                }
                if (!enableCache) return listItems;
                _ListItemCache[field] = listItems;
            }
            return _ListItemCache[field];
        }

        private bool IsValidListItemValue(Product product, string field, string value, bool emptyIsValid)
        {
            if (string.IsNullOrEmpty(value)) return emptyIsValid;
            List<ListItem> validItems = GetListItems(product, field);
            foreach (ListItem item in validItems)
            {
                if (item.Value == value) return true;
            }
            return false;
        }

        private void SaveGrid()
        {
            // SAVE THE GRID
            foreach (Product product in _SelectedProducts)
            {
                // SEE IF WE CAN LOCATE THIS PRODUCT
                if (AlwaysConvert.ToInt(Request.Form["P" + product.Id]) == 1)
                {
                    // THE PRODUCT WAS PRESENT IN THE GRID
                    foreach (string field in _SelectedFields)
                    {
                        UpdateField(product, field);
                    }
                }
                product.Save();
            }
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        private void UpdateField(Product product, string field)
        {
            if (field != null)
            {
                string cleanField = field.Trim().ToLowerInvariant();
                string fieldValue = GetValueFromFormPost(product.Id, cleanField);
                switch (cleanField)
                {
                    case "allowbackorder":
                        product.AllowBackorder = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "enablenotifications":
                        product.EnableRestockNotifications = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "allowreviews":
                        product.AllowReviews = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "costofgoods":
                        product.CostOfGoods = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "customurl":
                        bool isValid = false;
                        string oldCustomUrl = product.CustomUrl;
                        string newCustomUrl = fieldValue.Trim();
                        if (!string.IsNullOrEmpty(newCustomUrl) && string.IsNullOrEmpty(oldCustomUrl) || oldCustomUrl != newCustomUrl)
                            isValid = !CustomUrlDataSource.IsAlreadyUsed(newCustomUrl);
                        else
                            isValid = true;
                        if (isValid)
                            product.CustomUrl = fieldValue;
                        break;
                    case "description":
                        product.Description = fieldValue;
                        break;
                    case "disablepurchase":
                        product.DisablePurchase = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "displaypage":
                        if (IsValidListItemValue(product, field, fieldValue, true)) product.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(fieldValue));
                        break;
                    case "excludefromfeed":
                        product.ExcludeFromFeed = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "extendeddescription":
                        product.ExtendedDescription = fieldValue;
                        break;
                    case "height":
                        product.Height = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "hideprice":
                        product.HidePrice = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "metadescription":
                        product.MetaDescription = fieldValue;
                        break;
                    case "metakeywords":
                        product.MetaKeywords = fieldValue;
                        break;
                    case "iconalttext":
                        product.IconAltText = fieldValue;
                        break;
                    case "iconurl":
                        product.IconUrl = fieldValue;
                        break;
                    case "imagealttext":
                        product.ImageAltText = fieldValue;
                        break;
                    case "imageurl":
                        product.ImageUrl = fieldValue;
                        break;
                    case "instock":
                        product.InStock = AlwaysConvert.ToInt(fieldValue);
                        break;
                    case "instockwarninglevel":
                        product.InStockWarningLevel = AlwaysConvert.ToInt(fieldValue);
                        break;
                    case "inventorymodeid":
                        if (IsValidListItemValue(product, field, fieldValue, false)) product.InventoryModeId = AlwaysConvert.ToByte(fieldValue);
                        break;
                    case "enablegroups":
                        if (IsValidListItemValue(product, field, fieldValue, false)) product.EnableGroups = AlwaysConvert.ToBool(fieldValue, false);
                        break;
                    case "isfeatured":
                        product.IsFeatured = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "isgiftcertificate":
                        product.IsGiftCertificate = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "isprohibited":
                        product.IsProhibited = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "length":
                        product.Length = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "manufacturerid":
                        if (IsValidListItemValue(product, field, fieldValue, true)) product.ManufacturerId = AlwaysConvert.ToInt(fieldValue);
                        break;
                    case "maximumprice":
                        product.MaximumPrice = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "maxquantity":
                        product.MaxQuantity = AlwaysConvert.ToInt16(fieldValue);
                        break;
                    case "minimumprice":
                        product.MinimumPrice = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "minquantity":
                        product.MinQuantity = AlwaysConvert.ToInt16(fieldValue);
                        break;
                    case "modelnumber":
                        product.ModelNumber = fieldValue;
                        break;
                    case "msrp":
                        product.MSRP = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "name":
                        if (!string.IsNullOrEmpty(fieldValue)) product.Name = fieldValue;
                        break;
                    case "price":
                        product.Price = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "shippableid":
                        if (IsValidListItemValue(product, field, fieldValue, false)) product.ShippableId = AlwaysConvert.ToByte(fieldValue);
                        break;
                    case "sku":
                        product.Sku = fieldValue;
                        break;
                    case "summary":
                        product.Summary = fieldValue;
                        break;
                    case "taxcodeid":
                        if (IsValidListItemValue(product, field, fieldValue, true)) product.TaxCodeId = AlwaysConvert.ToInt(fieldValue);
                        break;
                    
                    case "thumbnailalttext":
                        product.ThumbnailAltText = fieldValue;
                        break;
                    case "thumbnailurl":
                        product.ThumbnailUrl = fieldValue;
                        break;
                    case "usevariableprice":
                        product.UseVariablePrice = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "vendorid":
                        if (IsValidListItemValue(product, field, fieldValue, true)) product.VendorId = AlwaysConvert.ToInt(fieldValue);
                        break;
                    case "visibilityid":
                        if (IsValidListItemValue(product, field, fieldValue, false)) product.VisibilityId = AlwaysConvert.ToByte(fieldValue);
                        break;
                    case "warehouseid":
                        if (IsValidListItemValue(product, field, fieldValue, false)) product.WarehouseId = AlwaysConvert.ToInt(fieldValue);
                        break;
                    case "weight":
                        product.Weight = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "width":
                        product.Width = AlwaysConvert.ToDecimal(fieldValue);
                        break;
                    case "wrapgroupid":
                        if (IsValidListItemValue(product, field, fieldValue, true)) product.WrapGroupId = AlwaysConvert.ToInt(fieldValue);
                        break;
                    case "title":
                        product.Title = fieldValue;
                        break;
                    case "gtin":
                        product.GTIN = fieldValue;
                        break;
                    case "searchkeywords":
                        product.SearchKeywords = fieldValue;
                        break;
                    case "htmlhead":
                        product.HtmlHead = fieldValue;
                        break;
                    case "googlecategory":
                        product.GoogleCategory = fieldValue;
                        break;
                    case "condition":
                        product.Condition = fieldValue;
                        break;
                    case "gender":
                        product.Gender = fieldValue;
                        break;
                    case "agegroup":
                        product.AgeGroup = fieldValue;
                        break;
                    case "color":
                        product.Color = fieldValue;
                        break;
                    case "size":
                        product.Size = fieldValue;
                        break;
                    case "adwordsgrouping":
                        product.AdwordsGrouping = fieldValue;
                        break;
                    case "adwordslabels":
                        product.AdwordsLabels = fieldValue;
                        break;
                    case "excludeddestination":
                        product.ExcludedDestination = fieldValue;
                        break;
                    case "adwordsredirect":
                        product.AdwordsRedirect = fieldValue;
                        break;
                    case "publishfeedasvariants":
                        product.PublishFeedAsVariants = (AlwaysConvert.ToInt(fieldValue) == 1);
                        break;
                    case "tic":
                        if (string.IsNullOrEmpty(fieldValue)) product.TIC = null;
                        else product.TIC = AlwaysConvert.ToInt(fieldValue);
                        break;
                }
            }
        }

        private string GetValueFromFormPost(int productId, string field)
        {
            string tempValue = Request.Form["P" + productId + "_" + field];
            if (tempValue == null) return string.Empty;
            return tempValue.Trim();
        }

        #region CustomViewState
        private void LoadCustomViewState()
        {
            if (Page.IsPostBack)
            {
                UrlEncodedDictionary customViewState = new UrlEncodedDictionary(EncryptionHelper.DecryptAES(Request.Form[VS.UniqueID]));
                _ShowEditGrid = AlwaysConvert.ToBool(customViewState.TryGetValue("ShowEditGrid"), false);
                _EnableScrolling = AlwaysConvert.ToBool(customViewState.TryGetValue("EnableScrolling"), true);
                string selectedProducts = customViewState.TryGetValue("SP");
                if (!string.IsNullOrEmpty(selectedProducts))
                {
                    int[] tempProductIds = AlwaysConvert.ToIntArray(selectedProducts);
                    if (tempProductIds != null && tempProductIds.Length > 0)
                    {
                        for (int i = 0; i < tempProductIds.Length; i++)
                        {
                            AddProductToList(tempProductIds[i]);
                        }
                    }
                }
                BuildFieldList(customViewState.TryGetValue("SF"));
            }
        }

        private void SaveCustomViewState()
        {
            UrlEncodedDictionary customViewState = new UrlEncodedDictionary();
            customViewState["ShowEditGrid"] = _ShowEditGrid.ToString();
            customViewState["EnableScrolling"] = _EnableScrolling.ToString();
            if (_SelectedProductIds.Count > 0)
                customViewState["SP"] = AlwaysConvert.ToList(",", _SelectedProductIds.ToArray());
            else customViewState["SP"] = string.Empty;
            if (_SelectedFields.Count > 0)
                customViewState["SF"] = string.Join(",", _SelectedFields.ToArray());
            else customViewState["SF"] = string.Empty;
            VS.Value = EncryptionHelper.EncryptAES(customViewState.ToString());
        }

        #endregion
    }
}