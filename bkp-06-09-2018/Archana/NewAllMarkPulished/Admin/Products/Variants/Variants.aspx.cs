namespace AbleCommerce.Admin.Products.Variants
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using System.Linq;

    public partial class _Variants : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _ProductId;
        private Product _Product;
        private ProductVariantManager _VariantManager;
        private bool _ShowInventory;
        private string _DisplayRangeLabelText;
        private string _IconPath;
        private string _optionsGridKey = "OptionsGridColumnsProductId";
        int selectedCount = 0;
        List<string> names = new List<string>();

        //stores data from form post
        Dictionary<string, string> _FormValues = new Dictionary<string, string>();

        //hold the last displayed datasource
        IList<ProductVariant> _DisplayedVariants;

        //stores the page we are currently displaying
        private const int _PageSize = 40;
        private int _CurrentPage;
        private int _VariantCount;
        private int _TotalPages;
        private int _WholePages;
        private int _LeftOverItems;

        protected bool ShowPager { get; set; }

        protected void Page_Init(object sender, EventArgs e)
        {
            _ProductId = AbleCommerce.Code.PageHelper.GetProductId();
            _Product = ProductDataSource.Load(_ProductId);
            _ShowInventory = (_Product.InventoryMode == InventoryMode.Variant && AbleContext.Current.Store.Settings.EnableInventory);
            if (_Product == null) Response.Redirect("../../Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId());
            _VariantManager = new ProductVariantManager(_ProductId);
            if (_VariantManager.Count == 0) Response.Redirect("Options.aspx?ProductId=" + _ProductId.ToString());
            if (_Product.ProductOptions.Count > ProductVariant.MAXIMUM_ATTRIBUTES)
            {
                TooManyVariantsPanel.Visible = true;
                TooManyVariantsMessage.Text = string.Format(TooManyVariantsMessage.Text, _Product.Name, ProductVariant.MAXIMUM_ATTRIBUTES);
            }

            //FIGURE OUT PAGING SETTINGS
            _VariantCount = _VariantManager.CountVariantGrid();
            _WholePages = _VariantCount / _PageSize;
            _LeftOverItems = _VariantCount % _PageSize;
            if (_LeftOverItems > 0) _TotalPages = _WholePages + 1;
            else _TotalPages = _WholePages;
            PagerPanel.Visible = (_TotalPages > 1);

            if (!Page.IsPostBack)
            {
                _optionsGridKey = _optionsGridKey + _ProductId;
                string optionsGridColumns = AbleContext.Current.User.Settings.GetValueByKey(_optionsGridKey);
                if (!string.IsNullOrEmpty(optionsGridColumns))
                {
                    string[] cols = optionsGridColumns.Split(',');
                    if (cols != null)
                    {
                        names = cols.ToList<string>();

                        foreach (string name in names)
                        {
                            ListItem li = FieldNamesList.Items.FindByValue(name);
                            if (li != null && !li.Selected)
                            {
                                li.Selected = true;
                            }
                        }
                    }
                }
            }
            //LOAD VIEW STATE
            LoadCustomViewState();
            //SAVE THIS TEXT FOR LATER
            _DisplayRangeLabelText = DisplayRangeLabel.Text;
            //CONVERT VARIANT FORM DATA TO STRING DICTIONARY
            ParseFormData();
            //INITIALIZE THE GRID
            BindVariantGrid();
            //UPDATE THE CAPTION
            Caption.Text = string.Format(Caption.Text, _Product.Name);

            //HIDE THE FIELDS WHEN INVENTORY IS DISABLED FOR VARIANT PRODUCT
            if (!_ShowInventory)
            {
                List<ListItem> removeItems = new List<ListItem>();
                for (int i = 0; i < FieldNamesList.Items.Count; i++)
                {                    
                    ListItem item = FieldNamesList.Items[i];
                    if ((item.Value == "InStock") || (item.Value == "Availability") || (item.Value == "LowStock"))
                    {
                        removeItems.Add(item);
                    }
                }

                foreach (ListItem li in removeItems)
                    FieldNamesList.Items.Remove(li);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // REGISTER PICK IMAGE SCRIPT
            string browseUrl = Page.ResolveUrl("~/Admin/Products/Assets/AssetManager.aspx");
            string pickImage = "<script type=\"text/javascript\">\r\nfunction PickImage(sField) { window.open('" + browseUrl + "?ImageId=PI&Field=' + sField, 'PickImage'); return false; }\r\n</script>";
            Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "PickImage", pickImage);
        }

        /// <summary>
        /// This is a helper function to parse the variant form data into a string dictionary
        /// so we can support the ContainsKey method
        /// </summary>
        private void ParseFormData()
        {
            _FormValues.Clear();
            foreach (string key in Request.Form.Keys)
            {
                if (key != null && key.StartsWith("V_"))
                {
                    _FormValues.Add(key, Request.Form[key]);
                }
            }
        }

        private void LoadCustomViewState()
        {
            if (Page.IsPostBack)
            {
                UrlEncodedDictionary customViewState = new UrlEncodedDictionary(EncryptionHelper.DecryptAES(Request.Form[VS_CustomState.UniqueID]));
                _CurrentPage = AlwaysConvert.ToInt(customViewState.TryGetValue("CurrentPage"));
                names = new List<string>(customViewState.TryGetValue("ColumnNames").Split(','));
                if (_CurrentPage < 1) _CurrentPage = 1;
            }
        }

        private string SafeTryGetValue(Dictionary<string, string> dic, string key)
        {
            if (dic.ContainsKey(key)) return dic[key];
            return string.Empty;
        }

        protected void UpdateSelected_Click(object sender, EventArgs e)
        {            
            foreach (ListItem item in FieldNamesList.Items)
            {
                if (item.Selected)
                {    
                    names.Add(item.Value);
                }               
            }

            // SAVE SELECTED COLUMNS
            _optionsGridKey = _optionsGridKey + _ProductId;
            var settings = AbleContext.Current.User.Settings;
            settings.SetValueByKey(_optionsGridKey, string.Join(",", names.Distinct().ToArray()));
            settings.Save();

            BindVariantGrid();
        }

        protected void FieldList_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (ListItem item in FieldNamesList.Items)
            {
                if (!item.Selected)
                {
                    names.Remove(item.Value);
                }
            }
        }

        protected void VariantGrid_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            // GET THE ICON PATH           
            if (string.IsNullOrEmpty(_IconPath)) _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);            
            if (e.Item.ItemType == ListItemType.Header)
            {
               PlaceHolder phVariantHeader = e.Item.FindControl("phVariantHeader") as PlaceHolder;

                if (phVariantHeader != null)
                {
                    StringBuilder headerBuilder = new StringBuilder();
                    if (names.Contains("SKU")) headerBuilder.Append("<th>SKU</th>");
                    if (names.Contains("GTIN")) headerBuilder.Append("<th>GTIN</th>");
                    if (names.Contains("Price")) headerBuilder.Append("<th>Price</th>");
                    if (names.Contains("Retail")) headerBuilder.Append("<th>Retail</th>");
                    if (names.Contains("Model")) headerBuilder.Append("<th>Model #</th>");
                    if (names.Contains("Dimensions")) headerBuilder.Append("<th>Dimensions</th>");
                    if (names.Contains("HandlingCharges")) headerBuilder.Append("<th>Special Handling Charges</th>");
                    if (names.Contains("Weight")) headerBuilder.Append("<th>Weight</th>");
                    if (names.Contains("COGS")) headerBuilder.Append("<th>COGS</th>");
                    if (names.Contains("Available")) headerBuilder.Append("<th>Available</th>");
                    if (_ShowInventory)
                    {
                        if (names.Contains("InStock")) headerBuilder.Append("<th>In Stock</th>");
                        if (names.Contains("Availability")) headerBuilder.Append("<th>Availability Date</th>");
                        if (names.Contains("LowStock")) headerBuilder.Append("<th>Low Stock</th>");
                    }
                    if (names.Contains("Image")) headerBuilder.Append("<th>Image</th>");
                    if (names.Contains("Thumbnail")) headerBuilder.Append("<th>Thumbnail</th>");
                    if (names.Contains("Icon")) headerBuilder.Append("<th>Icon</th>");
                    phVariantHeader.Controls.Add(new LiteralControl(headerBuilder.ToString()));
                }
            }
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                PlaceHolder phVariantRow = e.Item.FindControl("phVariantRow") as PlaceHolder;
                if (phVariantRow != null)
                {
                    ProductVariant variant = (ProductVariant)e.Item.DataItem;
                    int variantIndex = _VariantManager.IndexOf(variant);
                    StringBuilder rowBuilder = new StringBuilder();
                    string skuKey = "V_" + variantIndex.ToString() + "S";
                    string gtinKey = "V_" + variantIndex.ToString() + "G";
                    string priceKey = "V_" + variantIndex.ToString() + "P";
                    string retailKey = "V_" + variantIndex.ToString() + "RT";
                    string modelKey = "V_" + variantIndex.ToString() + "M"; 
                    string lengthKey = "V_" + variantIndex.ToString() + "L";
                    string widthKey = "V_" + variantIndex.ToString() + "WI";
                    string heightKey = "V_" + variantIndex.ToString() + "H";
                    string handlingChargesKey = "V_" + variantIndex.ToString() + "SH";
                    string priceModKey = "V_" + variantIndex.ToString() + "PM";
                    string weightKey = "V_" + variantIndex.ToString() + "W";
                    string weightModKey = "V_" + variantIndex.ToString() + "WM";
                    string cogsKey = "V_" + variantIndex.ToString() + "C";
                    string availKey = "V_" + variantIndex.ToString() + "A";
                    string instockKey = "V_" + variantIndex.ToString() + "I";
                    string availDateKey = "V_" + variantIndex.ToString() + "AD";
                    string restockKey = "V_" + variantIndex.ToString() + "R";
                    string imageKey = "V_" + variantIndex.ToString() + "IMG";
                    string thumbKey = "V_" + variantIndex.ToString() + "THU";
                    string iconKey = "V_" + variantIndex.ToString() + "ICO";

                    //CHECK IF THIS VARIANT IS IN FORM POST
                    if (_FormValues.Any(v => v.Key.StartsWith("V_" + variantIndex.ToString())))
                    {
                        //UPDATE THE VALUES BASED ON THE FORM POST
                        if (_FormValues.ContainsKey(skuKey))
                            variant.Sku = SafeTryGetValue(_FormValues, skuKey);
                        if (_FormValues.ContainsKey(gtinKey))
                            variant.GTIN = SafeTryGetValue(_FormValues, gtinKey);
                        if(_FormValues.ContainsKey(priceKey))
                            variant.Price = AlwaysConvert.ToDecimal(SafeTryGetValue(_FormValues, priceKey));
                        if (_FormValues.ContainsKey(retailKey))
                            variant.MSRP = AlwaysConvert.ToDecimal(SafeTryGetValue(_FormValues, retailKey));
                        if (_FormValues.ContainsKey(priceModKey))
                            variant.PriceModeId = AlwaysConvert.ToByte(SafeTryGetValue(_FormValues, priceModKey));
                        if (_FormValues.ContainsKey(modelKey))
                            variant.ModelNumber = SafeTryGetValue(_FormValues, modelKey);
                        if (_FormValues.ContainsKey(lengthKey))
                            variant.Length = AlwaysConvert.ToDecimal(SafeTryGetValue(_FormValues, lengthKey));
                        if (_FormValues.ContainsKey(widthKey))
                            variant.Width = AlwaysConvert.ToDecimal(SafeTryGetValue(_FormValues, widthKey));
                        if (_FormValues.ContainsKey(heightKey))
                            variant.Height = AlwaysConvert.ToDecimal(SafeTryGetValue(_FormValues, heightKey));
                        if (_FormValues.ContainsKey(handlingChargesKey))
                            variant.HandlingCharges = AlwaysConvert.ToDecimal(SafeTryGetValue(_FormValues, handlingChargesKey));
                        if (_FormValues.ContainsKey(weightKey))
                            variant.Weight = AlwaysConvert.ToDecimal(SafeTryGetValue(_FormValues, weightKey));
                        if (_FormValues.ContainsKey(weightModKey))
                            variant.WeightModeId = AlwaysConvert.ToByte(SafeTryGetValue(_FormValues, weightModKey));
                        if (_FormValues.ContainsKey(cogsKey))
                            variant.CostOfGoods = AlwaysConvert.ToDecimal(SafeTryGetValue(_FormValues, cogsKey));
                        if (_FormValues.ContainsKey(availKey))
                            variant.Available = (SafeTryGetValue(_FormValues, availKey) == "1,0");
                        if (_FormValues.ContainsKey(imageKey))
                            variant.ImageUrl = SafeTryGetValue(_FormValues, imageKey);
                        if (_FormValues.ContainsKey(thumbKey))
                            variant.ThumbnailUrl = SafeTryGetValue(_FormValues, thumbKey);
                        if (_FormValues.ContainsKey(iconKey))
                            variant.IconUrl = SafeTryGetValue(_FormValues, iconKey);

                        if (_ShowInventory)
                        {
                            if (_FormValues.ContainsKey(instockKey))
                                variant.InStock = AlwaysConvert.ToInt(SafeTryGetValue(_FormValues, instockKey));
                            if (_FormValues.ContainsKey(availDateKey))
                                variant.AvailabilityDate = AlwaysConvert.ToDateTime(SafeTryGetValue(_FormValues, availDateKey), DateTime.MinValue);
                            if (_FormValues.ContainsKey(restockKey))
                                variant.InStockWarningLevel = AlwaysConvert.ToInt(SafeTryGetValue(_FormValues, restockKey));
                        }
                    }
     
                    //DRAW THE DATA ROW
                    string rowClass = (e.Item.ItemType == ListItemType.Item) ? "oddRow" : "evenRow";
                    string autoExpand = selectedCount > 9 ? "noExpand" : "expandColumns";
                    string smallExpands = selectedCount > 9 ? "nosmallExpand" : "expandSmallColumns";
                    string overrideSelected = string.Empty;                   

                    rowBuilder.Append("<tr class=\"" + rowClass + "\">\r\n");
                    rowBuilder.Append("<td>" + (variantIndex + 1) + "</td>\r\n");
                    rowBuilder.Append("<td>" + variant.VariantName + "</td>\r\n");
                    if (names.Contains("SKU")) rowBuilder.Append("<td align=\"center\"><input name=\"" + skuKey + "\" type=\"text\" value=\"" + variant.Sku + "\" class= \"" + autoExpand + "\" /></td>\r\n");
                    if (names.Contains("GTIN")) rowBuilder.Append("<td align=\"center\"><input name=\"" + gtinKey + "\" type=\"text\" value=\"" + variant.GTIN + "\" class= \"" + autoExpand + "\" /></td>\r\n");
                    if (names.Contains("Price"))
                    {
                        rowBuilder.Append("<td align=\"center\"><input name=\"" + priceKey + "\" type=\"text\" value=\"" + variant.Price.LSCurrencyFormat("F2") + "\" class= \"" + smallExpands + "\" />");
                        overrideSelected = (variant.PriceMode == ModifierMode.Modify) ? string.Empty : " selected";
                        rowBuilder.Append("<select name=\"" + priceModKey + "\"><option value=\"0\">Modify</option><option value=\"1\"" + overrideSelected + ">Override</option></select></td>\r\n");
                    }
                    if (names.Contains("Retail")) rowBuilder.Append("<td align=\"center\"><input name=\"" + retailKey + "\" type=\"text\" value=\"" + variant.MSRP.LSCurrencyFormat("F2") + "\" class= \"" + smallExpands + "\" />");
                    if (names.Contains("Model")) rowBuilder.Append("<td align=\"center\"><input name=\"" + modelKey + "\" type=\"text\" value=\"" + variant.ModelNumber + "\" class= \"" + autoExpand + "\" />");
                    if (names.Contains("Dimensions"))
                    {
                        rowBuilder.Append("<td align=\"center\">L <input name=\"" + lengthKey + "\" type=\"text\" value=\"" + variant.Length.LSCurrencyFormat("F2") + "\" style=\"width:46px;\" />");
                        rowBuilder.Append("W <input name=\"" + widthKey + "\" type=\"text\" value=\"" + variant.Width.LSCurrencyFormat("F2") + "\" style=\"width:46px;\" />");
                        rowBuilder.Append("H <input name=\"" + heightKey + "\" type=\"text\" value=\"" + variant.Height.LSCurrencyFormat("F2") + "\" style=\"width:46px;\" />");
                    }
                    if (names.Contains("HandlingCharges")) rowBuilder.Append("<td align=\"center\"><input name=\"" + handlingChargesKey + "\" type=\"text\" value=\"" + variant.HandlingCharges.LSCurrencyFormat("F2") + "\" class= \"" + smallExpands + "\" />");
                    if (names.Contains("Weight"))
                    {
                        rowBuilder.Append("<td align=\"center\"><input name=\"" + weightKey + "\" type=\"text\" value=\"" + variant.Weight.LSCurrencyFormat("F2") + "\" class= \"" + smallExpands + "\" />");
                        overrideSelected = (variant.WeightMode == ModifierMode.Modify) ? string.Empty : " selected";
                        rowBuilder.Append("<select name=\"" + weightModKey + "\"><option value=\"0\">Modify</option><option value=\"1\"" + overrideSelected + ">Override</option></select></td>\r\n");
                    }
                    if (names.Contains("COGS")) rowBuilder.Append("<td align=\"center\"><input name=\"" + cogsKey + "\" type=\"text\" value=\"" + variant.CostOfGoods.LSCurrencyFormat("F2") + "\" class= \"" + smallExpands + "\" /></td>\r\n");
                    string checkedAttribute = string.Empty;
                    if (names.Contains("Available"))
                    {
                        if (variant.Available) checkedAttribute = " checked=\"true\"";
                        rowBuilder.Append("<td align=\"center\"><input name=\"" + availKey + "\" type=\"checkbox\"" + checkedAttribute + " value=\"1\" /><input name=\"" + availKey + "\" type=\"hidden\"" + checkedAttribute + " value=\"0\" /></td>");
                    }                    
                    if (_ShowInventory)
                    {
                        if (names.Contains("InStock")) rowBuilder.Append("<td align=\"center\"><input name=\"" + instockKey + "\" type=\"text\" value=\"" + variant.InStock.ToString("F0") + "\" class= \"" + smallExpands + "\" /></td>\r\n");
                        if (names.Contains("Availability")) rowBuilder.Append("<td align=\"center\"><input name=\"" + availDateKey + "\" type=\"text\" value=\"" + ((variant.AvailabilityDate.HasValue && variant.AvailabilityDate != DateTime.MinValue) ? variant.AvailabilityDate.Value.ToShortDateString() : string.Empty) + "\" style=\"width:90px;\" class=\"pickerAndCalendar\" /></td>\r\n");
                        if (names.Contains("LowStock")) rowBuilder.Append("<td align=\"center\"><input name=\"" + restockKey + "\" type=\"text\" value=\"" + variant.InStockWarningLevel.ToString("F0") + "\" class= \"" + smallExpands + "\" /></td>\r\n");
                    }
                    if (names.Contains("Image")) rowBuilder.Append("<td align=\"center\"><input name=\"" + imageKey + "\" type=\"text\" value=\"" + variant.ImageUrl + "\" class= \"" + autoExpand + "\" /><input name=\"" + imageKey + "B\" alt=\"Browse\" onclick=\"return PickImage('" + imageKey + "');\" type=\"image\" align=\"absmiddle\" src=\"" + _IconPath + "find.gif\" /></td>\r\n");
                    if (names.Contains("Thumbnail")) rowBuilder.Append("<td align=\"center\"><input name=\"" + thumbKey + "\" type=\"text\" value=\"" + variant.ThumbnailUrl + "\" class= \"" + autoExpand + "\" /><input name=\"" + thumbKey + "B\" alt=\"Browse\" onclick=\"return PickImage('" + thumbKey + "');\" type=\"image\" align=\"absmiddle\" src=\"" + _IconPath + "find.gif\" /></td>\r\n");
                    if (names.Contains("Icon")) rowBuilder.Append("<td align=\"center\"><input name=\"" + iconKey + "\" type=\"text\" value=\"" + variant.IconUrl + "\" class= \"" + autoExpand + "\" /><input name=\"" + iconKey + "B\" alt=\"Browse\" onclick=\"return PickImage('" + iconKey + "');\" type=\"image\" align=\"absmiddle\" src=\"" + _IconPath + "find.gif\" /></td>\r\n");
                    rowBuilder.Append("</tr>\r\n");                    
                    phVariantRow.Controls.Add(new LiteralControl(rowBuilder.ToString()));
                }
            }
        }

        protected void ChangePage(object sender, EventArgs e)
        {
            string WhichSender = sender.ToString();
            // If display criteria has changed or user has clicked "Update Display" button, display first page with selected criteria 
            // If user has clicked navigation link (first,previous,next,last) or selected page to jump to, display selected page 
            if (WhichSender == "System.Web.UI.WebControls.LinkButton")
            {
                SaveGrid();
                LinkButton lb = (LinkButton)sender;
                _CurrentPage = AlwaysConvert.ToInt(lb.CommandArgument);
                BindVariantGrid();
            }
            else
            {
                SaveGrid();
                DropDownList ddl = (DropDownList)sender;
                _CurrentPage = AlwaysConvert.ToInt(ddl.SelectedItem.Text);
                BindVariantGrid();
            }
        }

        private void BindVariantGrid()
        {
            //VALIDATE CURRENT PAGE IS IN RANGE
            if (_CurrentPage > _TotalPages | _CurrentPage < 1)
            {
                //RESET TO THE FIRST PAGE
                _CurrentPage = 1;
            }

            //CHECK IF LAST PAGE
            if (_CurrentPage == _TotalPages)
            {
                //HIDE NEXT AND LAST LINK FOR LAST PAGE
                NextLink.Visible = false;
                LastLink.Visible = false;
            }
            else
            {
                //SHOW NEXT AND LAST LINK FOR THIS PAGE
                NextLink.Visible = true;
                LastLink.Visible = true;
                NextLink.CommandArgument = ((int)(_CurrentPage + 1)).ToString();
                LastLink.CommandArgument = _TotalPages.ToString();
            }

            if (_CurrentPage == 1)
            {
                //HIDE PREVIOUS AND FIRST LINK FOR FIRST PAGE
                PreviousLink.Visible = false;
                FirstLink.Visible = false;
            }
            else
            {
                //SHOW PREVIOUS AND NEXT LINK FOR THIS PAGE
                PreviousLink.Visible = true;
                FirstLink.Visible = true;
                PreviousLink.CommandArgument = ((int)(_CurrentPage - 1)).ToString();
                FirstLink.CommandArgument = "1";
            }

            //BUILD PAGE LIST
            JumpPage.Items.Clear();
            if (_TotalPages <= 100)
            {
                //ADD ALL PAGES TO LIST
                for (int x = 1; x <= _TotalPages; x++)
                {
                    JumpPage.Items.Add(x.ToString());
                }
                JumpPage.SelectedIndex = (_CurrentPage - 1);
            }
            else
            {
                //DISPLAY ONLY ONE HUNDRED PAGES
                int startPage, endPage;
                if (_CurrentPage < 51)
                {
                    //SHOW FIRST HUNDRED PAGES
                    startPage = 1;
                    endPage = 100;
                }
                else if (_CurrentPage > _TotalPages - 100)
                {
                    //SHOW LAST HUNDRED PAGES
                    startPage = _TotalPages - 100;
                    endPage = _TotalPages;
                }
                else
                {
                    //SHOW RANGE OF HUNDRED
                    startPage = _CurrentPage - 50;
                    endPage = _CurrentPage + 50;
                }
                for (int i = startPage; i <= endPage; i++)
                {
                    JumpPage.Items.Add(i.ToString());
                }
                JumpPage.SelectedIndex = (_CurrentPage - startPage);
            }

            // Set the record count and page count text 
            PageCountLabel.Text = _TotalPages.ToString();

            // Determine the starting and ending index in the IDList ArrayList given the current page 
            int startIndex = _PageSize * (_CurrentPage - 1);
            int endIndex = Math.Min((_PageSize * (_CurrentPage - 1)) + (_PageSize - 1), ((_WholePages * _PageSize) + _LeftOverItems - 1));

            DisplayRangeLabel.Text = string.Format(_DisplayRangeLabelText, (startIndex + 1), (endIndex + 1), _VariantCount);

            //BIND THE REPEATER HERE
            _DisplayedVariants = _VariantManager.LoadVariantGrid(_PageSize, startIndex);
            VariantGrid.DataSource = _DisplayedVariants;
            VariantGrid.DataBind();
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            SaveGrid();
            SavedMessage.Text = string.Format(SavedMessage.Text, DateTime.Now);
            SavedMessage.Visible = true;
        }

        protected void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            SaveGrid();
            CancelButton_Click(sender, e);
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Options.aspx?ProductId=" + _ProductId.ToString());
        }

        private void SaveGrid()
        {
            //SAVES THE LAST VARIANT GRID DISPLAYED
            //THIS GRID WOULD HAVE BEEN UPDATED WITH FORM POST VALUES DURING THE DATABIND
            _DisplayedVariants.Save();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            SaveCustomViewState();   
        }

        private void SaveCustomViewState()
        {
            List<string> selectedNames = new List<string>();
            foreach(ListItem item in FieldNamesList.Items)
            {
                if (item.Selected)
                {
                    selectedCount++;
                    selectedNames.Add(item.Value);
                }
            }

            //SHOW SAVE BUTTONS WHEN ATLEAST ONE FIELD IS SELECTED FOR EDITING
            SaveButton.Visible = selectedCount > 0;
            SaveAndCloseButton.Visible = SaveButton.Visible;

            UrlEncodedDictionary customViewState = new UrlEncodedDictionary();
            customViewState.Add("CurrentPage", _CurrentPage.ToString());
            customViewState.Add("ColumnNames", string.Join(",", selectedNames.ToArray()));
            VS_CustomState.Value = EncryptionHelper.EncryptAES(customViewState.ToString());
        }
    }
}