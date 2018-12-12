// -----------------------------------------------------------------------
// <copyright file="AddProduct.aspx.cs" company="Able Solutions Corporation">
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
    using CommerceBuilder.Products;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Utility;
    using System.Collections.Generic;
    using System.IO;
    using CommerceBuilder.Users;
    using System.Linq;
    using CommerceBuilder.Taxes.Providers.TaxCloud;
    using CommerceBuilder.Taxes;

    public partial class AddProduct : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        Product product = new Product();
        protected void Page_Load(object sender, EventArgs e)
        {
            // a category is required to add a product
            int categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            Category category = CategoryDataSource.Load(categoryId);
            if (category == null) Response.Redirect("~/Admin/Products/ManageProducts.aspx");
            // initialize the page caption
            Caption.Text = string.Format(Caption.Text, category.Name);
            if (!Page.IsPostBack)
            {
                if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.EndsWith("ManageProducts.aspx"))
                {
                    CancelButton.NavigateUrl = "~/Admin/Products/ManageProducts.aspx";
                    CancelButton2.NavigateUrl = "~/Admin/Products/ManageProducts.aspx";
                }
                else
                {
                    CancelButton.NavigateUrl = "~/Admin/Catalog/Browse.aspx?CategoryId=" + categoryId.ToString();
                    CancelButton2.NavigateUrl = "~/Admin/Catalog/Browse.aspx?CategoryId=" + categoryId.ToString();
                }

                ProductGroups.Attributes.Add("disabled", "true");

                if (trTIC.Visible && product.TIC.HasValue && product.TIC != 0) TIC.Text = product.TIC.ToString();
            }

            // adjust form for store settings
            if (!AbleContext.Current.Store.Settings.EnableInventory)
            {
                CurrentInventoryMode.Visible = false;
                InventoryDisabledMessage.Visible = true;
            }
            else
            {
                ProductVariantManager vm = new ProductVariantManager(product.Id);
                if (vm.Count == 0)
                {
                    CurrentInventoryMode.Items.RemoveAt(2);
                    if (product.InventoryMode == InventoryMode.Variant) product.InventoryMode = InventoryMode.None;
                }
                if (product.InventoryMode == InventoryMode.Product)
                {
                    InStock.Text = product.InStock.ToString();
                    LowStock.Text = product.InStockWarningLevel.ToString();
                    AvailabilityDate.SelectedDate = product.AvailabilityDate.HasValue ? product.AvailabilityDate.Value: DateTime.MinValue;
                    BackOrder.Checked = product.AllowBackorder;
                }
                else if (product.InventoryMode == InventoryMode.Variant)
                {
                    BackOrder.Checked = product.AllowBackorder;
                }
            }
            AllowReviewsPanel.Visible = (AbleContext.Current.Store.Settings.ProductReviewEnabled != CommerceBuilder.Users.UserAuthFilter.None);

            // initialize form helpers
            WeightUnit.Text = AbleContext.Current.Store.WeightUnit.ToString();
            MeasurementUnit.Text = AbleContext.Current.Store.MeasurementUnit.ToString();
            MetaKeywordsCharCount.Text = ((int)(MetaKeywordsValue.MaxLength - MetaKeywordsValue.Text.Length)).ToString();
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);
            MetaDescriptionCharCount.Text = ((int)(MetaDescriptionValue.MaxLength - MetaDescriptionValue.Text.Length)).ToString();
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);

            // VALIDATE GOOGLE CATEGORY
            PublishAsVariants.Attributes.Add("onclick", "if(this.checked && document.getElementById('" + GoogleCategory.ClientID + "').value.toLowerCase().indexOf('apparel & accessories') != 0) { alert('You can only submit variant products for google feed if product belongs to \"Apparel & Accessories\" google categoryor a sub-category.'); return false; }");

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
            // TAX CLOUD TIC FIELD
            TaxCloudProvider taxCloudProvider = ProviderHelper.LoadTaxProvider<TaxCloudProvider>();
            trTIC.Visible = taxCloudProvider != null && taxCloudProvider.Activated;
        }

        public void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // save the product
                Product product = SaveProduct();

                // redirect
                if (((Control)sender).ID == "SaveAndCloseButton" || ((Control)sender).ID== "SaveAndCloseButton2") Response.Redirect(CancelButton.NavigateUrl);
                Response.Redirect("EditProduct.aspx?CategoryId=" + product.Categories[0].ToString() + "&ProductId=" + product.Id.ToString());
            }
        }

        protected void Warehouse_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // default should be the store warehouse
                ListItem selectedItem = Warehouse.Items.FindByValue(AbleContext.Current.Store.DefaultWarehouseId.ToString());
                if (selectedItem != null)
                {
                    Warehouse.SelectedIndex = Warehouse.Items.IndexOf(selectedItem);
                }
            }
        }

        protected void TaxCode_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // default should be "Taxable" if it exists
                ListItem selectedItem = TaxCode.Items.FindByText("Taxable");
                if (selectedItem != null)
                {
                    TaxCode.SelectedIndex = TaxCode.Items.IndexOf(selectedItem);
                }
            }
        }

        protected void CurrentInventoryMode_SelectedIndexChanged(object sender, EventArgs e)
        {
            trProductInventory.Visible = CurrentInventoryMode.SelectedIndex == 1;
            LowStockHolder.Visible = CurrentInventoryMode.SelectedIndex == 1;
            AvailabilityDate.Visible = CurrentInventoryMode.SelectedIndex == 1;
            BackOrdersHolder.Visible = CurrentInventoryMode.SelectedIndex > 0;
            RestockNotificationHolder.Visible = CurrentInventoryMode.SelectedIndex > 0;
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

        protected void PublishAsVariants_CheckChanged(object sender, EventArgs e)
        {
            GoogleFeedOptionsRow.Visible = !PublishAsVariants.Checked;
        }

        private Product SaveProduct()
        {
            // create a new product
            product.Categories.Add(AbleCommerce.Code.PageHelper.GetCategoryId());

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
            product.MinQuantity = AlwaysConvert.ToInt16(MinQuantity.Text);
            product.MaxQuantity = AlwaysConvert.ToInt16(MaxQuantity.Text);
            product.HtmlHead = HtmlHead.Text.Trim();
            product.SearchKeywords = SearchKeywords.Text.Trim();
            product.EnableGroups = AlwaysConvert.ToBool(EnableGroups.SelectedValue, false);
            product.HandlingCharges = AlwaysConvert.ToDecimal(HandlingCharges.Text);
            foreach (ListItem item in ProductGroups.Items)
            {
                if (item.Selected)
                {
                    int groupId = AlwaysConvert.ToInt(item.Value);
                    ProductGroup pg = new ProductGroup(product, GroupDataSource.Load(groupId));
                    product.ProductGroups.Add(pg);
                }
            }
            
            // search engines and feeds
            product.CustomUrl = CustomUrl.Text;
            product.ExcludeFromFeed = !IncludeInFeed.Checked;
            product.Title = ProductTitle.Text.Trim();
            product.MetaDescription = MetaDescriptionValue.Text.Trim();
            product.MetaKeywords = MetaKeywordsValue.Text.Trim();
            product.GoogleCategory = GoogleCategory.Text;
            product.Condition = Condition.SelectedValue;
            product.Gender = Gender.SelectedValue;
            product.AgeGroup = AgeGroup.SelectedValue;
            product.AdwordsGrouping = AdwordsGrouping.Text;
            product.AdwordsLabels = AdwordsLabels.Text;
            product.ExcludedDestination = ExcludedDestination.SelectedValue;
            product.AdwordsRedirect = AdwordsRedirect.Text;
            product.PublishFeedAsVariants = PublishAsVariants.Checked;
            product.Color = Color.Text;
            product.Size = Size.Text;

            // TAX CLOUD PRODUCT TIC
            if (trTIC.Visible && !string.IsNullOrEmpty(HiddenTIC.Value)) product.TIC = AlwaysConvert.ToInt(HiddenTIC.Value);
            else product.TIC = null;

            // save product (establish catalog node)
            product.Save();

            // recalculate the average orderby
            product.RecalculateOrderBy();
            product.Save();
            return product;
        }
    }
}