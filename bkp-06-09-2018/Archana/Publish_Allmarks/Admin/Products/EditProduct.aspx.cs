// -----------------------------------------------------------------------
// <copyright file="EditProduct.aspx.cs" company="Able Solutions Corporation">

// Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
// -----------------------------------------------------------------------

namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Utility;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Xml;
    using System.Text;
    using System.Web.Caching;
    using CommerceBuilder.Users;
    using CommerceBuilder.Taxes.Providers.TaxCloud;
    using CommerceBuilder.Taxes;
    using System.Web;

    public partial class EditProduct : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            // ensure we have a valid product
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            _Product = ProductDataSource.Load(productId);
            if (_Product == null) Response.Redirect("~/Admin/Products/ManageProducts.aspx");

            // initialize the page caption
            Page.Title = string.Format(Page.Title, _Product.Name);
            Caption.Text = string.Format(Caption.Text, _Product.Name);
            if (!Page.IsPostBack)
            {
                if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.EndsWith("ManageProducts.aspx"))
                {
                    CancelButton.NavigateUrl = "~/Admin/Products/ManageProducts.aspx";
                    CancelButton2.NavigateUrl = "~/Admin/Products/ManageProducts.aspx";
                }
                else
                {
                    CancelButton.NavigateUrl = "~/Admin/Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId();
                    CancelButton2.NavigateUrl = "~/Admin/Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId();
                }

                // SHOW SAVE CONFIRMATION NOTIFICATION IF NEEDED
                if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.ToLowerInvariant().EndsWith("addproduct.aspx"))
                {
                    SavedMessage.Visible = true;
                    SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                }
            }

            //delete prouduct confirmation
            string confirmationJS = String.Format("return confirm('Are you sure you want to delete product \"{0}\"?');", _Product.Name);
            DeleteButton.Attributes.Add("onclick", confirmationJS);
            DeleteButton1.Attributes.Add("onclick", confirmationJS);

            // adjust form for store settings
            if (!AbleContext.Current.Store.Settings.EnableInventory)
            {
                CurrentInventoryMode.Visible = false;
                InventoryDisabledMessage.Visible = true;
            }
            else if (!Page.IsPostBack)
            {
                ProductVariantManager vm = new ProductVariantManager(_Product.Id);
                if (vm.Count == 0)
                {
                    CurrentInventoryMode.Items.RemoveAt(2);
                    if (_Product.InventoryMode == InventoryMode.Variant) _Product.InventoryMode = InventoryMode.None;
                }
            }
            AllowReviewsPanel.Visible = (AbleContext.Current.Store.Settings.ProductReviewEnabled != CommerceBuilder.Users.UserAuthFilter.None);

            // initialize product form
            if (!Page.IsPostBack)
            {
                LoadProduct();
            }
            TIC.Text = HiddenTIC.Value;

            // initialize form helpers
            WeightUnit.Text = AbleContext.Current.Store.WeightUnit.ToString();
            MeasurementUnit.Text = AbleContext.Current.Store.MeasurementUnit.ToString();
            MetaKeywordsCharCount.Text = ((int)(MetaKeywordsValue.MaxLength - MetaKeywordsValue.Text.Length)).ToString();
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);
            MetaDescriptionCharCount.Text = ((int)(MetaDescriptionValue.MaxLength - MetaDescriptionValue.Text.Length)).ToString();
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);

            // VALIDATE GOOGLE CATEGORY
            PublishAsVariants.Attributes.Add("onclick", "if(this.checked && document.getElementById('" + GoogleCategory.ClientID + "').value.toLowerCase().indexOf('apparel & accessories') != 0) { alert('You can only submit variant products for google feed if product belongs to \"Apparel & Accessories\" google category or a sub-category.'); return false; }");

            if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor)
            {
                AbleCommerce.Code.PageHelper.SetHtmlEditor(Summary, SummaryHtmlButton);
                AbleCommerce.Code.PageHelper.SetHtmlEditor(Description, DescriptionHtmlButton);
                AbleCommerce.Code.PageHelper.SetHtmlEditor(ExtendedDescription, ExtendedDescriptionHtmlButton);
            }
            else
            {
                SummaryHtmlButton.Visible = false;
                DescriptionHtmlButton.Visible = false;
                ExtendedDescriptionHtmlButton.Visible = false;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            //Calculate billable weight 
            billableWeightLink.Visible = _Product.Weight > 0;
            if (billableWeightLink.Visible)
            {
                ProductWeightLabel.Text = string.Format(ProductWeightLabel.Text, _Product.Weight);

                if (_Product.Height > 0 && _Product.Width > 0 && _Product.Length > 0)
                {
                    decimal productDimensions = _Product.Height * _Product.Width * _Product.Length;
                    decimal domesticWeight = productDimensions / 166;
                    decimal internationalWeight = productDimensions / 139;
                    DomesticLabel.Text = string.Format(DomesticLabel.Text, domesticWeight);
                    InternationalLabel.Text = string.Format(InternationalLabel.Text, internationalWeight);
                }
                else
                {
                    trDimensionalWeightText.Visible = true;
                    trDomesticWeight.Visible = false;
                    trInternationalWeight.Visible = false;
                }
            }

            // TAX CLOUD TIC FIELD
            TaxCloudProvider taxCloudProvider = ProviderHelper.LoadTaxProvider<TaxCloudProvider>();
            trTIC.Visible = taxCloudProvider != null && taxCloudProvider.Activated;

            //Get File Names Uploaded
            string replaceText = "Assets/PDF/";
            if (_Product.CustomFields.Count > 0)
            {
                foreach (var rec in _Product.CustomFields)
                {
                    switch(rec.FieldName)
                    {
                        case "Download1":
                            FileName1.Text = rec.FieldValue.Replace(replaceText, "");
                            break;
                        case "Download2":
                            FileName2.Text = rec.FieldValue.Replace(replaceText, "");
                            break;
                        case "Download3":
                            FileName3.Text = rec.FieldValue.Replace(replaceText, "");
                            break;
                        default:
                            break;
                    }
                }
            }
        }

        public void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the product
                SaveProduct();

                // show confirmation
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                Caption.Text = _Product.Name;
                Page.Title = "Edit Product '" + _Product.Name + "'";
            }
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the product
                SaveProduct();

                // redirect away
                Response.Redirect(CancelButton.NavigateUrl);
            }
        }

        public void DeleteButton_Click(object sender, EventArgs e)
        {
            _Product.Delete();
            Response.Redirect(CancelButton.NavigateUrl);
        }

        protected void ManufacturerList_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) SetSelectedItem(ManufacturerList, _Product.ManufacturerId.ToString());
        }

        protected void Warehouse_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) SetSelectedItem(Warehouse, _Product.WarehouseId.ToString());
        }

        protected void Vendor_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) SetSelectedItem(Vendor, _Product.VendorId.ToString());
        }

        protected void TaxCode_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) SetSelectedItem(TaxCode, _Product.TaxCodeId.ToString());
        }

        protected void CurrentInventoryMode_SelectedIndexChanged(object sender, EventArgs e)
        {
            trProductInventory.Visible = CurrentInventoryMode.SelectedIndex == 1;
            LowStockHolder.Visible = CurrentInventoryMode.SelectedIndex == 1;
            trVariantInventory.Visible = CurrentInventoryMode.SelectedIndex == 2;
            BackOrdersHolder.Visible = CurrentInventoryMode.SelectedIndex > 0;
            RestockNotificationHolder.Visible = CurrentInventoryMode.SelectedIndex > 0;
        }

        protected void WrapGroup_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) SetSelectedItem(WrapGroup, _Product.WrapGroupId.ToString());
        }
        
        protected void DisplayPage_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) SetSelectedItem(DisplayPage, _Product.WebpageId.ToString());
        }

        protected void NewManufacturerLink_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(NewManufacturerName.Value))
            {
                Manufacturer manufacturer = ManufacturerDataSource.LoadForName(NewManufacturerName.Value, true);
                ManufacturerList.DataBind();
                ListItem selectedItem = ManufacturerList.Items.FindByValue(manufacturer.Id.ToString());
                if (selectedItem != null)
                {
                    ManufacturerList.SelectedIndex = ManufacturerList.Items.IndexOf(selectedItem);
                }
            }
        }

        private void SaveProduct()
        {
            // get a reference to the loaded product
            // this assists in file comparions between add/edit page
            Product product = _Product;

            // basic product information pane
            product.Name = Name.Text;
            product.ManufacturerId = AlwaysConvert.ToInt(ManufacturerList.SelectedValue);
            product.Price = AlwaysConvert.ToDecimal(Price.Text);
            product.ModelNumber = ModelNumber.Text;
            product.MSRP = AlwaysConvert.ToDecimal(Msrp.Text);
            product.Weight = AlwaysConvert.ToDecimal(Weight.Text);
            product.CostOfGoods = AlwaysConvert.ToDecimal(CostOfGoods.Text);
            product.GTIN = Gtin.Text;
            product.Sku = Sku.Text;
            product.IsFeatured = IsFeatured.Checked;

            // descriptions
            product.Summary = Summary.Text;
            product.Description = Description.Text;
            product.ExtendedDescription = ExtendedDescription.Text;

            // shipping, tax, and inventory
            product.WarehouseId = AlwaysConvert.ToInt(Warehouse.SelectedValue);
            product.VendorId = AlwaysConvert.ToInt(Vendor.SelectedValue);
            product.ShippableId = (byte)AlwaysConvert.ToInt(IsShippable.SelectedValue);
            product.Length = AlwaysConvert.ToDecimal(Length.Text);
            product.Width = AlwaysConvert.ToDecimal(Width.Text);
            product.Height = AlwaysConvert.ToDecimal(Height.Text);
            product.TaxCodeId = AlwaysConvert.ToInt(TaxCode.SelectedValue);
            if (CurrentInventoryMode.Visible)
            {
                product.InventoryModeId = AlwaysConvert.ToByte(CurrentInventoryMode.SelectedIndex);
                if (product.InventoryMode == InventoryMode.Product)
                {
                    product.InStock = AlwaysConvert.ToInt(InStock.Text);
                    product.AvailabilityDate = AvailabilityDate.SelectedDate;
                    product.InStockWarningLevel = AlwaysConvert.ToInt(LowStock.Text);
                    product.AllowBackorder = BackOrder.Checked;
                }
                else if (product.InventoryMode == InventoryMode.Variant)
                { 
                    product.AllowBackorder = BackOrder.Checked;
                }

                product.EnableRestockNotifications = EnableRestockNotifications.Checked;
            }

            // advanced settings
            product.WrapGroupId = AlwaysConvert.ToInt(WrapGroup.SelectedValue);
            product.AllowReviews = AllowReviewsPanel.Visible ? AllowReviews.Checked : true;
            product.Visibility = (CatalogVisibility)Visibility.SelectedIndex;
            product.HidePrice = HidePrice.Checked;
            product.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(DisplayPage.SelectedValue));
            product.IsProhibited = IsProhibited.Checked;
            product.IsGiftCertificate = GiftCertificate.Checked;
            product.DisablePurchase = DisablePurchase.Checked;
            product.UseVariablePrice = UseVariablePrice.Checked;
            product.MinimumPrice = AlwaysConvert.ToDecimal(MinPrice.Text);
            product.MaximumPrice = AlwaysConvert.ToDecimal(MaxPrice.Text);
            product.HandlingCharges = AlwaysConvert.ToDecimal(HandlingCharges.Text);
            product.MinQuantity = AlwaysConvert.ToInt16(MinQuantity.Text);
            product.MaxQuantity = AlwaysConvert.ToInt16(MaxQuantity.Text);
            product.HtmlHead = HtmlHead.Text.Trim();
            product.SearchKeywords = SearchKeywords.Text.Trim();
            _Product.EnableGroups = AlwaysConvert.ToBool(EnableGroups.SelectedValue, false);
            _Product.ProductGroups.DeleteAll();
            foreach (ListItem item in ProductGroups.Items)
            {
                if (item.Selected)
                {
                    int groupId = AlwaysConvert.ToInt(item.Value);
                    ProductGroup pg = new ProductGroup(_Product, GroupDataSource.Load(groupId));
                    _Product.ProductGroups.Add(pg);
                }
            }
                        
            // search engines and feeds
            product.CustomUrl = CustomUrl.Text;
            CustomUrlValidator.OriginalValue = _Product.CustomUrl;
            product.ExcludeFromFeed = !IncludeInFeed.Checked;
            product.Title = ProductTitle.Text.Trim();
            product.MetaDescription = MetaDescriptionValue.Text.Trim();
            product.MetaKeywords = MetaKeywordsValue.Text.Trim();
            product.GoogleCategory = GoogleCategory.Text;
            product.Condition = Condition.SelectedValue;
            product.Gender = Gender.SelectedValue;
            product.AgeGroup = AgeGroup.SelectedValue;
            product.Color = Color.Text;
            product.Size = Size.Text;
            product.AdwordsGrouping = AdwordsGrouping.Text;
            product.AdwordsLabels = AdwordsLabels.Text;
            product.ExcludedDestination = ExcludedDestination.SelectedValue;
            product.AdwordsRedirect = AdwordsRedirect.Text;
            product.PublishFeedAsVariants = PublishAsVariants.Checked;

            // TAX CLOUD PRODUCT TIC
            if (trTIC.Visible && !string.IsNullOrEmpty(HiddenTIC.Value))
            {
                product.TIC = AlwaysConvert.ToInt(HiddenTIC.Value);
            }
            else product.TIC = null;

            // save product
            product.Save();
            ModalPopupExtender.Hide();
        }

        private void SetSelectedItem(DropDownList list, string selectedValue)
        {
            ListItem selectedItem = list.Items.FindByValue(selectedValue);
            if (selectedItem != null)
            {
                list.SelectedIndex = list.Items.IndexOf(selectedItem);
            }
        }

        protected void PublishAsVariants_CheckChanged(object sender, EventArgs e)
        {
            GoogleFeedOptionsRow.Visible = !PublishAsVariants.Checked;
        }

        private void LoadProduct()
        {
            // basic product information pane
            Name.Text = _Product.Name;
            Price.Text = String.Format("{0:F2}", _Product.Price);
            ModelNumber.Text = _Product.ModelNumber;
            if (_Product.MSRP > 0) Msrp.Text = string.Format("{0:F2}", _Product.MSRP);
            Weight.Text = string.Format("{0:F2}", _Product.Weight);
            if (_Product.CostOfGoods > 0) CostOfGoods.Text = String.Format("{0:F2}", _Product.CostOfGoods);
            Gtin.Text = _Product.GTIN;
            Sku.Text = _Product.Sku;
            IsFeatured.Checked = _Product.IsFeatured;

            // descriptions
            Summary.Text = _Product.Summary;
            Description.Text = _Product.Description;
            ExtendedDescription.Text = _Product.ExtendedDescription;

            // shipping, tax, and inventory
            SetSelectedItem(IsShippable, _Product.ShippableId.ToString());
            if (_Product.Length > 0) Length.Text = string.Format("{0:F2}", _Product.Length);
            if (_Product.Width > 0) Width.Text = string.Format("{0:F2}", _Product.Width);
            if (_Product.Height > 0) Height.Text = string.Format("{0:F2}", _Product.Height);
            if (CurrentInventoryMode.Visible)
            {
                if (_Product.InventoryMode == InventoryMode.Product) CurrentInventoryMode.SelectedIndex = 1;
                else if (_Product.InventoryMode == InventoryMode.Variant) CurrentInventoryMode.SelectedIndex = 2;
                CurrentInventoryMode_SelectedIndexChanged(null, null);
                if (trProductInventory.Visible)
                {
                    InStock.Text = _Product.InStock.ToString();
                    AvailabilityDate.SelectedDate = _Product.AvailabilityDate.HasValue ? _Product.AvailabilityDate.Value : DateTime.MinValue; ;
                    LowStock.Text = _Product.InStockWarningLevel.ToString();
                }
                if (BackOrdersHolder.Visible)
                {
                    BackOrder.Checked = _Product.AllowBackorder;
                }

                EnableRestockNotifications.Checked = _Product.EnableRestockNotifications;
            }

            // advanced settings
            AllowReviews.Checked = _Product.AllowReviews;
            Visibility.SelectedIndex = (int)_Product.Visibility;
            HidePrice.Checked = _Product.HidePrice;
            IsProhibited.Checked = _Product.IsProhibited;
            GiftCertificate.Checked = _Product.IsGiftCertificate;
            DisablePurchase.Checked = _Product.DisablePurchase;
            UseVariablePrice.Checked = _Product.UseVariablePrice;
            if (_Product.MinimumPrice > 0) MinPrice.Text = _Product.MinimumPrice.LSCurrencyFormat("F2");
            if (_Product.MaximumPrice > 0) MaxPrice.Text = _Product.MaximumPrice.LSCurrencyFormat("F2");
            if (_Product.HandlingCharges > 0) HandlingCharges.Text = _Product.HandlingCharges.LSCurrencyFormat("F2");
            if (_Product.MinQuantity > 0) MinQuantity.Text = _Product.MinQuantity.ToString();
            if (_Product.MaxQuantity > 0) MaxQuantity.Text = _Product.MaxQuantity.ToString();
            HtmlHead.Text = _Product.HtmlHead;
            SearchKeywords.Text = _Product.SearchKeywords;

            // search engines and feeds
            CustomUrl.Text = _Product.CustomUrl;
            CustomUrlValidator.OriginalValue = _Product.CustomUrl;
            IncludeInFeed.Checked = !_Product.ExcludeFromFeed;
            ProductTitle.Text = _Product.Title;
            MetaDescriptionValue.Text = _Product.MetaDescription;
            MetaKeywordsValue.Text = _Product.MetaKeywords;
            GoogleCategory.Text = _Product.GoogleCategory;
            SelectItem(Condition, _Product.Condition);
            SelectItem(Gender, _Product.Gender);
            SelectItem(AgeGroup, _Product.AgeGroup);
            Color.Text = _Product.Color;
            Size.Text = _Product.Size;
            AdwordsGrouping.Text = _Product.AdwordsGrouping;
            AdwordsLabels.Text = _Product.AdwordsLabels;
            SelectItem(ExcludedDestination, _Product.ExcludedDestination);
            AdwordsRedirect.Text = _Product.AdwordsRedirect;
            PublishAsVariants.Checked = _Product.PublishFeedAsVariants;
            GoogleFeedOptionsRow.Visible = !_Product.PublishFeedAsVariants;
            ProductGroups.DataBind();
            ProductGroups.ClearSelection();
            
            foreach (ProductGroup pg in _Product.ProductGroups)
            {
                ListItem item = ProductGroups.Items.FindByValue(pg.Group.Id.ToString());
                if (item != null)
                    item.Selected = true;
            }

            ListItem liEnableGroups = EnableGroups.Items.FindByValue(_Product.EnableGroups.ToString().ToLower());
            if (liEnableGroups != null)
                liEnableGroups.Selected = true;
            ProductGroups.Enabled = _Product.EnableGroups;
            ProductGroups.Attributes.Remove("disabled");
            if(!_Product.EnableGroups)
                ProductGroups.Attributes.Add("disabled", "true");

            // TAX CLOUD TIC
            if (trTIC.Visible && _Product.TIC.HasValue)
            {
                if (_Product.TIC.Value == 0)
                {
                    TIC.Text = "00000";
                    HiddenTIC.Value = "00000";
                }
                else
                {
                    TIC.Text = _Product.TIC.ToString();
                    HiddenTIC.Value = _Product.TIC.ToString();
                }
            }
        }

        private void SelectItem(DropDownList list, string value) 
        {
            ListItem item = list.Items.FindByValue(value);
            if (item != null)
                item.Selected = true;
        }

        //[System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
        [System.Web.Services.WebMethod]
        public static string[] GetGoogleCategories(string prefixText, int count, string contextKey)
        {
            List<string> categories = LoadTaxonomy();
            prefixText = prefixText.Trim();
            return (from c in categories where c.IndexOf(prefixText, StringComparison.InvariantCultureIgnoreCase) > -1 select c).ToArray();
        }

        public static List<string> LoadTaxonomy()
        {
            Cache cache = HttpContextHelper.SafeGetCache();
            CacheWrapper cacheWraper = null;
            if (cache != null)
            {
                cacheWraper = cache.Get("GOOGLE_TAXONOMY") as CacheWrapper;
                if (cacheWraper != null)
                {
                    return (List<string>)cacheWraper.CacheValue;
                }
            }

            List<string> categories = new List<string>();
            using (System.IO.StreamReader file = new System.IO.StreamReader(FileHelper.SafeMapPath("~/App_Data/taxonomy.en-US.txt")))
            {
                string line = null;
                while ((line = file.ReadLine()) != null)
                {
                    if (line.StartsWith("#"))
                        continue;

                    categories.Add(line);
                }
                file.Close();
            }

            if (cache != null)
            {
                cacheWraper = new CacheWrapper(categories);
                cache.Remove("GOOGLE_TAXONOMY");
                cache.Add("GOOGLE_TAXONOMY", cacheWraper, null, DateTime.UtcNow.AddHours(1), Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
            }

            return categories;
        }

        protected void UploadButton_Click1(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                //Format: ProductID_Title_OrderNo
                string theFileName = Path.Combine(Server.MapPath("~/Assets/PDF/"), FileUpload1.FileName);
                if (File.Exists(theFileName))
                {
                    File.Delete(theFileName);
                }
                FileUpload1.SaveAs(theFileName);
                SavePDFUpload(FileUpload1.FileName, "Download1");
            }
        }

        protected void UploadButton_Click2(object sender, EventArgs e)
        {
            if (FileUpload2.HasFile)
            {
                string theFileName = Path.Combine(Server.MapPath("~/Assets/PDF/"), FileUpload2.FileName);
                if (File.Exists(theFileName))
                {
                    File.Delete(theFileName);
                }
                FileUpload2.SaveAs(theFileName);
                SavePDFUpload(FileUpload2.FileName, "Download2");
            }
        }

        protected void UploadButton_Click3(object sender, EventArgs e)
        {
            if (FileUpload3.HasFile)
            {
                string theFileName = Path.Combine(Server.MapPath("~/Assets/PDF/"), FileUpload3.FileName);
                if (File.Exists(theFileName))
                {
                    File.Delete(theFileName);
                }
                FileUpload3.SaveAs(theFileName);
                SavePDFUpload(FileUpload3.FileName, "Download3");
            }
        }


        private void SavePDFUpload(string fileName, string fieldName)
        {
            //Ensure the Product Custom Field is always ovewriting the correct upload
            ProductCustomField customField = null;
            customField = _Product.CustomFields.Where(x => x.ProductId == _Product.Id).FirstOrDefault(s => s.FieldName.Equals(fieldName));

            if (customField == null)
            {
                customField = new ProductCustomField();
                customField.ProductId = _Product.Id;
            }

            customField.IsVisible = true;
            customField.IsUserDefined = true;
            customField.FieldName = String.Format(fieldName);
            customField.FieldValue = String.Format("Assets/PDF/{0}", fileName);
            customField.Save();
        }
    }
}