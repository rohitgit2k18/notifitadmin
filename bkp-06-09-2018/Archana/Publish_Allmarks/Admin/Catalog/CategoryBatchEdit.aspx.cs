namespace AbleCommerce.Admin.Catalog
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

    public partial class CategoryBatchEdit : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private bool _ShowEditGrid = false;
        private bool _EnableScrolling = true;
        private List<Category> _SelectedCategories = new List<Category>();
        private List<int> _SelectedCategoryIds = new List<int>();
        private List<string> _SelectedFields = new List<string>();
        private Dictionary<string, string> _CategoryFields = new Dictionary<string, string>();
        private Dictionary<string, string> _CategoryFieldDescriptions = new Dictionary<string, string>();
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
            _CategoryFields["name"] = "Name";
            _CategoryFields["visibilityid"] = "Visibility";
            _CategoryFields["thumbnailalttext"] = "Thumbnail Alt Text";
            _CategoryFields["thumbnailurl"] = "Thumbnail Url";
            _CategoryFields["customurl"] = "Custom Url";           
            _CategoryFields["summary"] = "Summary";
            _CategoryFields["description"] = "Description";
            _CategoryFields["pagetitle"] = "Page Title";
            _CategoryFields["metadescription"] = "Meta Description";
            _CategoryFields["metakeywords"] = "Meta Keyword";
            _CategoryFields["htmlhead"] = "Html Head";
            _CategoryFields["displaypage"] = "Display Page";           
            
            // SET FIELD DESCRIPTIONS
            _CategoryFieldDescriptions["name"] = "The name of the category.";
            _CategoryFieldDescriptions["visibilityid"] = "Indicates whether the category is visible on the retail store website.";
            _CategoryFieldDescriptions["customurl"] = "You can provide a custom URL to access your category. This URL will override the default one generated by system.";
            _CategoryFieldDescriptions["summary"] = "A summary description of the category.  This generally appears on category or search display pages where the category is listed with other category.";
            _CategoryFieldDescriptions["description"] = "The main description of the category that is usually shown on the category detail page.";
            _CategoryFieldDescriptions["pagetitle"] = "Title of the category displayed for catalog display";
            _CategoryFieldDescriptions["thumbnailalttext"] = "Alternate text for the thumbnail image.";
            _CategoryFieldDescriptions["thumbnailurl"] = "Thumbnail image for the category.";
            _CategoryFieldDescriptions["metadescription"] = "Any content here will be put into the meta description for the category display page.";
            _CategoryFieldDescriptions["metakeywords"] = "Any content here will be put into the meta keywords for the category display page.";
            _CategoryFieldDescriptions["htmlhead"] = "The custom data for HTML HEAD portion";
            _CategoryFieldDescriptions["displaypage"] = "Indicates the web display page used when the category is viewed.";

            // DRAW SELECTED FIELDS
            SelectedFields.Items.Clear();
            List<string> defaultFields = GetDefaultFields();
            foreach (string field in defaultFields)
            {
                SelectedFields.Items.Add(new ListItem(_CategoryFields[field], field));
            }

            // DRAW AVAILABLE FIELDS
            AvailableFields.Items.Clear();
            foreach (string field in _CategoryFields.Keys)
            {
                if (!defaultFields.Contains(field))
                {
                    AvailableFields.Items.Add(new ListItem(_CategoryFields[field], field));
                }
            }

        }

        private List<string> GetDefaultFields()
        {
            List<string> defaultFields = new List<string>();
            string defaultFieldList = AbleContext.Current.User.Settings.GetValueByKey("CategoryBatchEditFieldList");
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
                defaultFields.Add("name");
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
            BatchEditGrid.Controls.Add(new LiteralControl("<th align=\"left\">Category</th>"));
            foreach (string field in _SelectedFields)
            {
                BatchEditGrid.Controls.Add(new LiteralControl(string.Format("<th align=\"left\" nowrap>")));
                ToolTipLabel colHeader = new ToolTipLabel();
                colHeader.Text = _CategoryFields[field];
                colHeader.ToolTip = _CategoryFieldDescriptions[field];
                colHeader.SkinID = "ColHeader";
                BatchEditGrid.Controls.Add(colHeader);
                BatchEditGrid.Controls.Add(new LiteralControl("</th>"));
            }
            BatchEditGrid.Controls.Add(new LiteralControl("</tr>\n"));

            // DRAW ROWS
            bool isOddRow = true;
            foreach (Category category in _SelectedCategories)
            {
                if (isOddRow) BatchEditGrid.Controls.Add(new LiteralControl("<tr class=\"oddRow\">\n"));
                else BatchEditGrid.Controls.Add(new LiteralControl("<tr class=\"evenRow\">\n"));
                isOddRow = !isOddRow;
                string categoryUrl = "../Catalog/EditCategory.aspx?CategoryId=" + category.Id;
                BatchEditGrid.Controls.Add(new LiteralControl(string.Format("<td>\n<input type=\"hidden\" name=\"C{0}\" value=\"1\">\n<a href=\"{2}\">{1}</a>\n</td>\n", category.Id, Server.HtmlEncode(category.Name), categoryUrl)));
                foreach (string field in _SelectedFields)
                {
                    string cellAlignment;
                    List<Control> controls = DrawField(category, field, out cellAlignment);
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
            _SelectedCategories.Clear();
            _SelectedCategoryIds.Clear();
            int categoryId = 0;
            if (!_DisplayCategorySearch) categoryId = AlwaysConvert.ToInt(CategoryFilter.SelectedValue);
            else categoryId = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);

            IList<Category> categories = CategoryDataSource.FindCategories(NameFilter.Text, categoryId, AlwaysConvert.ToInt(MaximumRows.SelectedValue));
            if (categories.Count > 0)
            {
                foreach (Category category in categories) AddCategoryToList(category.Id);
                BuildFieldList(HiddenSelectedFields.Value);
                SaveSearchCriteria();
                _ShowEditGrid = true;
                _EnableScrolling = EnableScrolling.Checked;

                // CHECK IF A WARNING NEED TO BE DISPlAYED
                int fieldsCount = _SelectedFields.Count * _SelectedCategories.Count;
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
            string searchCriteriaList = AbleContext.Current.User.Settings.GetValueByKey("CategoryBatchEditSearchCriteria");
            if (!string.IsNullOrEmpty(searchCriteriaList))
            {
                string[] searchCriteriaArray = searchCriteriaList.Split("|".ToCharArray());
                if (searchCriteriaArray.Length == 7)
                {
                    NameFilter.Text = searchCriteriaArray[0];
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
            if (!_DisplayCategorySearch) searchCriteria.Add(CategoryFilter.SelectedValue);
            else searchCriteria.Add(HiddenSelectedCategoryId.Value);
            searchCriteria.Add(MaximumRows.SelectedValue);
            searchCriteria.Add(EnableScrolling.Checked.ToString());
            user.Settings.SetValueByKey("CategoryBatchEditSearchCriteria", string.Join("|", searchCriteria.ToArray()));
            // SAVE FIELDS
            string defaultFields = string.Empty;
            if (_SelectedFields.Count > 0) defaultFields = string.Join(",", _SelectedFields.ToArray());
            user.Settings.SetValueByKey("CategoryBatchEditFieldList", defaultFields);
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

        private void AddCategoryToList(int categoryId)
        {
            AddCategoryToList(CategoryDataSource.Load(categoryId));
        }

        private void AddCategoryToList(Category category)
        {
            if (category != null && !_SelectedCategoryIds.Contains(category.Id))
            {
                _SelectedCategories.Add(category);
                _SelectedCategoryIds.Add(category.Id);
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
                foreach (string key in _CategoryFields.Keys)
                {
                    if (key.ToLowerInvariant() == cleanField) return true;
                }
            }
            return false;
        }

        private List<Control> DrawCheckField(int categoryId, string field, bool initialChecked)
        {
            List<Control> controls = new List<Control>();
            string checkedValue = initialChecked ? " checked" : string.Empty;
            controls.Add(new LiteralControl(string.Format("<input type=\"checkbox\" name=\"C{0}_{1}\" value=\"1\"{2}>\n", categoryId, field, checkedValue)));
            return controls;
        }

        private List<Control> DrawTextField(int categoryId, string field, string initialValue, int maxlength, int width, bool required)
        {
            List<Control> controls = new List<Control>();
            controls.Add(new LiteralControl(string.Format("<input type=\"text\" name=\"C{0}_{1}\" value=\"{2}\" maxlength=\"{3}\" style=\"width:{4}px\">\n", categoryId, field, Server.HtmlEncode(initialValue), maxlength, width)));
            return controls;
        }

        private List<Control> DrawLongTextField(int categoryId, string field, string initialValue, int width)
        {
            List<Control> controls = new List<Control>();
            string fieldId = string.Format("C{0}_{1}", categoryId, field);
            controls.Add(new LiteralControl(string.Format("<input type=\"text\" name=\"{0}\" id=\"{0}\" value=\"{1}\" style=\"width:{2}px\"><input type=\"button\" value=\"  ..  \" onclick=\"ShowEditLongTextDialog('{0}');return false;\">\n", fieldId, Server.HtmlEncode(initialValue), width)));
            return controls;
        }

        private List<Control> DrawHtmlField(int categoryId, string field, string initialValue, int width)
        {
            List<Control> controls = new List<Control>();
            string fieldId = string.Format("C{0}_{1}", categoryId, field);
            controls.Add(new LiteralControl(string.Format("<input type=\"text\" name=\"{0}\" id=\"{0}\" value=\"{1}\" style=\"width:{2}px\"><input type=\"button\" value=\"  ..  \" onclick=\"ShowEditHtmlDialog('{0}');return false;\">\n", fieldId, Server.HtmlEncode(initialValue), width)));
            return controls;
        }

        private List<Control> DrawNumberField(int categoryId, string field, string initialValue, int maxlength, int width, bool required)
        {
            List<Control> controls = new List<Control>();
            controls.Add(new LiteralControl(string.Format("<input type=\"text\" name=\"C{0}_{1}\" value=\"{2}\" maxlength=\"{3}\" style=\"width:{4}px\">\n", categoryId, field, Server.HtmlEncode(initialValue), maxlength, width)));
            return controls;
        }

        private List<Control> DrawDropDownField(int categoryId, string field, List<ListItem> items, string selectedValue, bool showHeader)
        {
            return DrawDropDownField(categoryId, field, items, selectedValue, showHeader, string.Empty);
        }

        private List<Control> DrawDropDownField(int categoryId, string field, List<ListItem> items, string selectedValue, bool showHeader, string headerText)
        {
            // BUILD THE SELECT BOX
            StringBuilder sb = new StringBuilder();
            sb.Append(string.Format("<select name=\"C{0}_{1}\">\n", categoryId, field));
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

        private List<Control> DrawField(Category category, string field, out string cellAlignment)
        {
            cellAlignment = string.Empty;
            if (field != null)
            {
                string cleanField = field.Trim().ToLowerInvariant();
                switch (cleanField)
                {
                    case "name":
                        return DrawTextField(category.Id, cleanField, category.Name, 255, 200, true);
                    case "customurl":
                        return DrawTextField(category.Id, cleanField, category.CustomUrl, 150, 150, false);
                    case "displaypage":
                        int webpageId = category.Webpage != null ? category.Webpage.Id : 0;
                        return DrawDropDownField(category.Id, cleanField, GetListItems(category, cleanField), webpageId.ToString(), true, "Inherit");
                    case "visibilityid":
                        return DrawDropDownField(category.Id, cleanField, GetListItems(category, cleanField), category.VisibilityId.ToString(), false);
                    case "summary":
                        return DrawLongTextField(category.Id, cleanField, category.Summary, 200);
                    case "description":
                        return DrawHtmlField(category.Id, cleanField, category.Description, 200);
                    case "metadescription":
                        return DrawLongTextField(category.Id, cleanField, category.MetaDescription, 200);
                    case "metakeywords":
                        return DrawLongTextField(category.Id, cleanField, category.MetaKeywords, 200);
                    case "thumbnailalttext":
                        return DrawTextField(category.Id, cleanField, category.ThumbnailAltText, 255, 200, false);
                    case "thumbnailurl":
                        return DrawTextField(category.Id, cleanField, category.ThumbnailUrl, 255, 200, false);                                 
                    case "pagetitle":
                        return DrawTextField(category.Id, cleanField, category.Title, 255, 200, false);
                    case "htmlhead":
                        return DrawTextField(category.Id, cleanField, category.HtmlHead, 255, 200, false);
                }
            }
            return null;
        }

        private Dictionary<string, List<ListItem>> _ListItemCache = new Dictionary<string, List<ListItem>>();
        private List<ListItem> GetListItems(Category category, string field)
        {
            if (!_ListItemCache.ContainsKey(field))
            {
                // LIST ITEMS NOT CACHED, CONSTRUCT THEM
                // SET THE CACHE FLAG TO FALSE IF THE OPTIONS DEPEND ON THE CATEGORY
                bool enableCache = true;
                List<ListItem> listItems = new List<ListItem>();
                switch (field)
                {
                    case "displaypage":
                        IList<Webpage> webpages = WebpageDataSource.LoadForWebpageType(WebpageType.CategoryDisplay);
                        foreach (Webpage webpage in webpages)
                        {
                            listItems.Add(new ListItem(webpage.Name, webpage.Id.ToString()));
                        }
                        break;
                    
                    case "visibilityid":
                        listItems.Add(new ListItem("Public", "0"));
                        listItems.Add(new ListItem("Hidden", "1"));
                        listItems.Add(new ListItem("Private", "2"));
                        break;                    
                }
                if (!enableCache) return listItems;
                _ListItemCache[field] = listItems;
            }
            return _ListItemCache[field];
        }

        private bool IsValidListItemValue(Category category, string field, string value, bool emptyIsValid)
        {
            if (string.IsNullOrEmpty(value)) return emptyIsValid;
            List<ListItem> validItems = GetListItems(category, field);
            foreach (ListItem item in validItems)
            {
                if (item.Value == value) return true;
            }
            return false;
        }

        private void SaveGrid()
        {
            // SAVE THE GRID
            foreach (Category category in _SelectedCategories)
            {
                // SEE IF WE CAN LOCATE THIS CATEGORY
                if (AlwaysConvert.ToInt(Request.Form["C" + category.Id]) == 1)
                {
                    // THE CATEGORY WAS PRESENT IN THE GRID
                    foreach (string field in _SelectedFields)
                    {
                        UpdateField(category, field);
                    }
                }
                category.Save();
            }
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        private void UpdateField(Category category, string field)
        {
            if (field != null)
            {
                string cleanField = field.Trim().ToLowerInvariant();
                string fieldValue = GetValueFromFormPost(category.Id, cleanField);
                switch (cleanField)
                {                    
                    case "customurl":
                        bool isValid = false;
                        string oldCustomUrl = category.CustomUrl;
                        string newCustomUrl = fieldValue.Trim();
                        if (!string.IsNullOrEmpty(newCustomUrl) && string.IsNullOrEmpty(oldCustomUrl) || oldCustomUrl != newCustomUrl)
                            isValid = !CustomUrlDataSource.IsAlreadyUsed(newCustomUrl);
                        else
                            isValid = true;
                        if (isValid)
                            category.CustomUrl = fieldValue;
                        break;                    
                    case "displaypage":
                        if (IsValidListItemValue(category, field, fieldValue, true)) category.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(fieldValue));
                        break;
                    case "visibilityid":
                        if (IsValidListItemValue(category, field, fieldValue, false)) category.VisibilityId = AlwaysConvert.ToByte(fieldValue);
                        break;
                    case "description":
                        category.Description = fieldValue;
                        break;
                    case "metadescription":
                        category.MetaDescription = fieldValue;
                        break;
                    case "metakeywords":
                        category.MetaKeywords = fieldValue;
                        break;                  
                    case "name":
                        if (!string.IsNullOrEmpty(fieldValue)) category.Name = fieldValue;
                        break;                    
                    case "summary":
                        category.Summary = fieldValue;
                        break;                    
                    case "thumbnailalttext":
                        category.ThumbnailAltText = fieldValue;
                        break;
                    case "thumbnailurl":
                        category.ThumbnailUrl = fieldValue;
                        break;
                    case "pagetitle":
                        category.Title = fieldValue;
                        break;
                    case "htmlhead":
                        category.HtmlHead = fieldValue;
                        break;
                }
            }
        }

        private string GetValueFromFormPost(int categoryId, string field)
        {
            string tempValue = Request.Form["C" + categoryId + "_" + field];
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
                string selectedCategories = customViewState.TryGetValue("SC");
                if (!string.IsNullOrEmpty(selectedCategories))
                {
                    int[] tempCategoryIds = AlwaysConvert.ToIntArray(selectedCategories);
                    if (tempCategoryIds != null && tempCategoryIds.Length > 0)
                    {
                        for (int i = 0; i < tempCategoryIds.Length; i++)
                        {
                            AddCategoryToList(tempCategoryIds[i]);
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
            if (_SelectedCategoryIds.Count > 0)
                customViewState["SC"] = AlwaysConvert.ToList(",", _SelectedCategoryIds.ToArray());
            else customViewState["SC"] = string.Empty;
            if (_SelectedFields.Count > 0)
                customViewState["SF"] = string.Join(",", _SelectedFields.ToArray());
            else customViewState["SF"] = string.Empty;
            VS.Value = EncryptionHelper.EncryptAES(customViewState.ToString());
        }

        #endregion
    }
}