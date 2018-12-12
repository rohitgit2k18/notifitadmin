namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DomainModel;
    using System.Linq;

    public partial class EditProductTemplate : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Product _Product;

        public int ProductId 
        {
            get 
            {
                return AbleCommerce.Code.PageHelper.GetProductId();
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            _Product = ProductDataSource.Load(productId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            Caption.Text = string.Format(Caption.Text, _Product.Name);

            // DETERMINE THE TEMPLATE LIST - ON FIRST VISIT THIS IS THE SAVED TEMPLATES ASSOCIATED WITH PRODUCT
            // ON POSTBACK IT COULD BE DIFFERENT IF CHANGED BY THE MERCHANT
            InitializeTemplateList();

            // INITIALIZE THE DIALOG TO UPDATE SELECTED TEMPLATES
            InitializeChangeTemplatesJS();
            InitializeChangeTemplatesDialog();

            // BUILD CHOICES BASED ON CURRENT TEMPLATES
            BuildProductChoices();
        }

        private void InitializeTemplateList()
        {
            if (Page.IsPostBack)
            {
                _Product.ProductTemplates.Clear();
                int[] selectedTemplates = AlwaysConvert.ToIntArray(Request.Form[HiddenSelectedTemplates.UniqueID]);
                if (selectedTemplates != null && selectedTemplates.Length > 0)
                {
                    foreach (int ptid in selectedTemplates)
                    {
                        ProductTemplate template = ProductTemplateDataSource.Load(ptid);
                        if (template != null)
                        {
                            _Product.ProductTemplates.Add(template);
                        }
                    }
                }
            }
            else
            {
                HiddenSelectedTemplates.Value = GetTemplateIdList();
            }
            TemplateList.Text = GetTemplateList();
        }

        /// <summary>
        /// Initializes javascript required by the change Templates dialog
        /// </summary>
        private void InitializeChangeTemplatesJS()
        {
            this.Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "selectbox", this.ResolveUrl("~/Scripts/selectbox.js"));
            string leftBoxName = AvailableTemplates.ClientID;
            string rightBoxName = SelectedTemplates.ClientID;
            AvailableTemplates.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, '')");
            SelectedTemplates.Attributes.Add("onDblClick", "moveSelectedOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, '');");
            SelectAllTemplates.Attributes.Add("onclick", "moveAllOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, ''); return false;");
            SelectTemplate.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + leftBoxName + "'], this.form['" + rightBoxName + "'], true, ''); return false;");
            UnselectTemplate.Attributes.Add("onclick", "moveSelectedOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, ''); return false;");
            UnselectAllTemplates.Attributes.Add("onclick", "moveAllOptions(this.form['" + rightBoxName + "'], this.form['" + leftBoxName + "'], true, ''); return false;");
            StringBuilder changeTemplateListScript = new StringBuilder();
            changeTemplateListScript.AppendLine("function changeTemplateList(){");
            changeTemplateListScript.AppendLine("\t$get('" + HiddenSelectedTemplates.ClientID + "').value=getOptions($get('" + rightBoxName + "'));");
            changeTemplateListScript.AppendLine("\t$get('" + TemplateList.ClientID + "').innerHTML=getOptionNames($get('" + rightBoxName + "'));");
            changeTemplateListScript.AppendLine("\t$get('" + TemplateListChanged.ClientID + "').value='1';");
            changeTemplateListScript.AppendLine("}");
            this.Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "changeTemplateList", changeTemplateListScript.ToString(), true);
        }

        /// <summary>
        /// Initializes the change Templates dialog with current user Template settings
        /// </summary>
        private void InitializeChangeTemplatesDialog()
        {
            AvailableTemplates.Items.Clear();
            SelectedTemplates.Items.Clear();
            IList<ProductTemplate> allTemplates = ProductTemplateDataSource.LoadAll("Name");
            foreach (ProductTemplate t in allTemplates)
            {
                ListItem newItem = new ListItem(t.Name, t.Id.ToString());
                bool templateSelected = _Product.ProductTemplates.IndexOf(t.Id) > -1;
                if (templateSelected) SelectedTemplates.Items.Add(newItem);
                else AvailableTemplates.Items.Add(newItem);
            }
        }

        /// <summary>
        /// Gets a comma delimited list of assigned template names for the current product
        /// </summary>
        /// <returns>Comma delimited list of template names, or the empty text if no 
        /// templates are assigned to the product</returns>
        protected string GetTemplateList()
        {
            List<string> templateNames = new List<string>();
            foreach (ProductTemplate productTemplate in _Product.ProductTemplates)
            {
                templateNames.Add(productTemplate.Name);
            }
            if (templateNames.Count == 0) return string.Empty;
            return string.Join(", ", templateNames.ToArray());
        }

        protected string GetTemplateIdList()
        {
            List<string> templateIds = new List<string>();
            foreach (ProductTemplate productTemplate in _Product.ProductTemplates)
            {
                templateIds.Add(productTemplate.Id.ToString());
            }
            if (templateIds.Count == 0) return string.Empty;
            return string.Join(",", templateIds.ToArray());
        }

        protected void BuildProductChoices()
        {
            if (_Product.ProductTemplates.Count > 0)
            {
                foreach (ProductTemplate template in _Product.ProductTemplates)
                {
                    StringBuilder customerFields = new StringBuilder();
                    // SHOW THE SECTION HEADER
                    phCustomFields.Controls.Add(new LiteralControl("<div class=\"sectionHeader\">" + template.Name + "</div>"));
                    phCustomFields.Controls.Add(new LiteralControl("<table cellspacing=\"0\" class=\"inputForm\">"));
                    foreach (InputField input in template.InputFields)
                    {
                        if (input.IsMerchantField)
                        {
                            // CHECK IF IT IS A TEXT AREA FIELD
                            ImageButton htmlButton = null;
                            string tempValue = string.Empty;
                            ProductTemplateField cf = FindTemplateField(input.Id);
                            if (cf != null) tempValue = cf.InputValue;
                            WebControl o = input.GetControl(tempValue);
                            if (o != null)
                            {
                                // SHOW HTML EDITOR FOR TEXT AREA
                                TextBox textBox = o as TextBox;
                                if (textBox != null && textBox.TextMode == TextBoxMode.MultiLine)
                                {
                                    htmlButton = new ImageButton();
                                    htmlButton.SkinID = "HtmlIcon";
                                }
                            }

                            // OPEN THE ROW
                            phCustomFields.Controls.Add(new LiteralControl("<tr>"));
                            // CREATE A LABEL FOR THE CHOICE
                            phCustomFields.Controls.Add(new LiteralControl("<th class=\"rowHeader\" valign=\"top\">" + input.UserPrompt));
                            if (htmlButton != null)
                            {
                                phCustomFields.Controls.Add(new LiteralControl("<br/>"));
                                phCustomFields.Controls.Add(htmlButton);
                            }
                            phCustomFields.Controls.Add(new LiteralControl("</th>"));
                            // ADD THE CONTROL TO THE PLACEHOLDER
                            phCustomFields.Controls.Add(new LiteralControl("<td valign=\"top\">"));
                            
                            if (o != null)
                            {
                                phCustomFields.Controls.Add(o);
                            }
                            phCustomFields.Controls.Add(new LiteralControl("</td></tr>"));

                            // BIND THE HTML EDITOR
                            if (htmlButton != null) AbleCommerce.Code.PageHelper.SetHtmlEditor(o as TextBox, htmlButton);
                        }
                        else
                        {
                            // DISPLAY INFO ABOUT THE CUSTOMER FIELD
                            customerFields.Append("<tr>");
                            customerFields.Append("<th class=\"rowHeader\">" + input.UserPrompt + "</th>");
                            customerFields.Append("<td>");
                            customerFields.Append("<i>Customer Field, " + StringHelper.SpaceName(input.InputType.ToString()) + "</i>");
                            customerFields.Append("</td></tr>");
                        }
                    }
                    if (customerFields.Length > 0)
                    {
                        phCustomFields.Controls.Add(new LiteralControl(customerFields.ToString()));
                    }
                    phCustomFields.Controls.Add(new LiteralControl("</table><br />"));
                }
            }
            else
            {
                phCustomFields.Controls.Clear();
            }
        }

        protected ProductTemplateField FindTemplateField(int inputFieldId)
        {
            if (_Product != null)
            {
                foreach (ProductTemplateField cf in _Product.TemplateFields)
                {
                    if (cf.InputFieldId == inputFieldId) return cf;
                }
            }
            return null;
        }

        public void SaveButton_Click(object sender, EventArgs e)
        {
            // UPDATE TEMPLATE AND COLLECT ANY VALUES
            if (_Product.ProductTemplates.Count > 0)
            {
                // DELETE THE OLD PRODUCT TEMPLATE ASSOCIATION FROM DATABASE
                int[] selectedTemplates = AlwaysConvert.ToIntArray(Request.Form[HiddenSelectedTemplates.UniqueID]);
                ClearInvalidTemplateFields(_Product, selectedTemplates);
                if (selectedTemplates != null && selectedTemplates.Length > 0)
                {
                    for (int i = _Product.ProductTemplates.Count - 1; i > -1; i--)
                    {
                        // check if this template is in the list of selected templates
                        ProductTemplate template = _Product.ProductTemplates[i];
                        if (Array.IndexOf(selectedTemplates, template.Id) < 0)
                        {
                            _Product.ProductTemplates.DeleteAt(i);
                        }
                    }
                }

                // GATHER NEW VALUES FOR PRODUCT CUSTOM FIELDS
                AbleCommerce.Code.ProductHelper.CollectProductTemplateInput(_Product, phCustomFields);
                _Product.TemplateFields.Save();
            }
            else
            {
                // NO TEMPLATES SHOULD BE ASSOCIATED TO THE PRODUCT
                _Product.ProductTemplates.DeleteAll();
                _Product.TemplateFields.DeleteAll();
            }

            // DISPLAY CONFIRMATION
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        private void ClearInvalidTemplateFields(Product product, int[] selectedTemplates)
        {
            if (selectedTemplates != null)
            {
                List<ProductTemplateField> fields = (from tf in product.TemplateFields
                                                     where Array.IndexOf(selectedTemplates, tf.InputField.ProductTemplateId) < 0
                                                     select tf).ToList<ProductTemplateField>();

                foreach (ProductTemplateField tf in fields)
                    tf.Delete();
            }
            else
                product.TemplateFields.DeleteAll();
        }

        [System.Web.Services.WebMethod]
        public static string[] ValidateTemplates()
        {
            Dictionary<int, string> templateDictionary = new Dictionary<int, string>();
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                IList<ProductTemplate> oldTemplates = product.ProductTemplates;
                if (oldTemplates.Count > 0)
                {
                    foreach (var oldTemplate in oldTemplates)
                        templateDictionary.Add(oldTemplate.Id, oldTemplate.Name);

                    string templateIds = System.Web.HttpContext.Current.Request.QueryString["Templates"];
                    if (!string.IsNullOrEmpty(templateIds))
                    {
                        string[] ids = templateIds.Split(',');
                        if (ids != null && ids.Length > 0)
                        {
                            foreach (var oldTemplate in oldTemplates)
                            {
                                if (ids.Contains(oldTemplate.Id.ToString()))
                                {
                                    templateDictionary.Remove(oldTemplate.Id);
                                }
                            }
                        }
                    }
                }
            }

            string[] templatesRemoved = new string[0];
            if (templateDictionary.Count > 0)
            {
                templatesRemoved = new string[templateDictionary.Count];
                templateDictionary.Values.CopyTo(templatesRemoved, 0);
            }
            return templatesRemoved;
        }

        public void ChangeTemplateListCancelButton_Click(object sender, EventArgs e)
        {
            InitializeTemplateList();
            ModalPopupExtender.Hide();
        }
    }
}