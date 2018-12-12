namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.Services;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Search;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DataExchange;
    using System.Web.Script.Serialization;
    using CommerceBuilder.Users;
    using AbleCommerce.Code;
    using CommerceBuilder.Stores;

    public partial class ManageProducts : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private string _IconPath = string.Empty;
        private bool _DisplayCategorySearch = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            int categoryCount = CategoryDataSource.CountAll();
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            _DisplayCategorySearch = settings.CategorySearchDisplayLimit > 0 && categoryCount >= settings.CategorySearchDisplayLimit;

            if (!Page.IsPostBack)
            {
                InitializeCategoryTree();
                LoadSearchFilter();
            }

            if (_DisplayCategorySearch)
            {
                // DISPLAY AUTO COMPLETE FOR CATEGORY SEARCH OPTION
                string js = PageHelper.GetAutoCompleteScript("../../CategorySuggest.ashx", CategoryAutoComplete, HiddenSelectedCategoryId, "Key", "Value");
                js += PageHelper.GetAutoCompleteScript("../../CategorySuggest.ashx", NewProductCategory, HiddenNewProductCategoryId, "Key", "Value");

                ScriptManager.RegisterStartupScript(PageAjax, this.GetType(), "CATEGORY_SUGGEST", js, true);
                CategoryAutoComplete.Visible = true;
                CategoriesList.Visible = false;

                CategoryDropDown.Visible = false;
                NewProductCategory.Visible = true;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ProductFilter filter = Session["ProductSearchFilter"] as ProductFilter;
            if (filter == null) filter = new ProductFilter();
            if (filter.GroupId > 0)
            {
                ListItem item = ProductGroups.Items.FindByValue(filter.GroupId.ToString());
                if (item != null)
                {
                    GroupPH.Controls.Clear();
                    GroupPH.Controls.Add(new LiteralControl(string.Format("<option>Remove From {0} Group</option>", item.Text)));
                }
            }

            var serializer = new JavaScriptSerializer();
            var result = serializer.Serialize(filter);
            ScriptManager.RegisterClientScriptBlock(Page, typeof(Page), "searchQueryJson", "var searchQuery = " + result + ";", true);
            gridFooter.Visible = PG.Rows.Count > 0;

            CategoriesList.Visible = !_DisplayCategorySearch;
            CategoryAutoComplete.Visible = !CategoriesList.Visible;
        }

        protected void Page_InIt(object sender, EventArgs e)
        {
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
        }

        protected void ProductsDS_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            BitFieldState featured = OnlyFeatured.Checked ? BitFieldState.True : BitFieldState.Any;
            e.InputParameters["featured"] = featured;
            if (_DisplayCategorySearch) e.InputParameters["categoryId"] = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);
            PG.Columns[1].Visible = ShowProductThumbnails.Checked;
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            SaveSearchFilter();
            PG.DataBind();
        }

        protected void OkButton_Click(object sender, EventArgs e)
        {
            string categoryId = CategoryDropDown.SelectedValue;
            if (_DisplayCategorySearch) categoryId = HiddenNewProductCategoryId.Value;
            Response.Redirect("~/Admin/Products/AddProduct.aspx?CategoryId=" + categoryId);
        }

        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            List<object> values = PG.GetSelectedDataKeyValues();
            if (values.Count > 0)
            {
                List<int> productIds = values.ConvertAll<int>(delegate(object value) { return Convert.ToInt32(value); });
                foreach (int productId in productIds)
                    ProductDataSource.Delete(productId);
            }

            PG.DataBind();
        }

        [WebMethod()]
        public static bool DeleteProducts(int[] productIds)
        {
            List<string> ids = new List<string>();
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            foreach (int pid in productIds)
            {
                ProductDataSource.Delete(pid);
            }
            database.CommitTransaction();
            return true;
        }

        [WebMethod()]
        public static bool DeleteAllProducts(ProductFilter filter)
        {
            int totalCount = ProductDataSource.FindProductsCount(filter.Name, filter.SearchDescriptions, filter.Sku, filter.CategoryId, filter.ManufacturerId, filter.VendorId, filter.Featured, 0, filter.FromPrice, filter.ToPrice, filter.DigitalGoodsOnly, filter.GiftCertificatesOnly, filter.KitsOnly, filter.SubscriptionsOnly);
            int currentIndex = 0;
            while (currentIndex < totalCount)
            {
                IList<Product> currentBatch = ProductDataSource.FindProducts(filter.Name, filter.SearchDescriptions, filter.Sku, filter.CategoryId, filter.ManufacturerId, filter.VendorId, filter.Featured, 0, filter.FromPrice, filter.ToPrice, filter.DigitalGoodsOnly, filter.GiftCertificatesOnly, filter.KitsOnly, filter.SubscriptionsOnly, 100, currentIndex);
                foreach (Product p in currentBatch)
                {
                    p.Delete();
                }
                currentIndex += 100;
            }
            return true;
        }

        [WebMethod()]
        public static bool AssignProducts(int[] productIds, int[] groupIds, string groupRestrictions)
        {
            List<string> ids = new List<string>();
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            List<Group> groups = new List<Group>();
            foreach (int gid in groupIds)
            {
                Group group = GroupDataSource.Load(gid);
                if (group != null)
                    groups.Add(group);
            }

            foreach (int pid in productIds)
            {
                Product product = ProductDataSource.Load(pid);
                foreach (Group group in groups)
                {
                    ProductGroup pg = ProductGroupDataSource.Load(pid, group.Id);
                    if (pg == null)
                    {
                        pg = new ProductGroup(product, group);
                        product.ProductGroups.Add(pg);
                    }
                }

                switch (groupRestrictions)
                {
                    case "YES":
                        product.EnableGroups = true;
                        break;

                    case "NO":
                        product.EnableGroups = false;
                        break;

                    default:
                        break;
                }

                product.Save();
            }
            database.CommitTransaction();
            return true;
        }

        [WebMethod()]
        public static bool AssignAllProducts(ProductFilter filter, int[] groupIds, string groupRestrictions)
        {
            int totalCount = ProductDataSource.FindProductsCount(filter.Name, filter.SearchDescriptions, filter.Sku, filter.CategoryId, filter.ManufacturerId, filter.VendorId, filter.Featured, 0, filter.FromPrice, filter.ToPrice, filter.DigitalGoodsOnly, filter.GiftCertificatesOnly, filter.KitsOnly, filter.SubscriptionsOnly);
            int currentIndex = 0;
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            List<Group> groups = new List<Group>();
            foreach (int gid in groupIds)
            {
                Group group = GroupDataSource.Load(gid);
                if (group != null)
                    groups.Add(group);
            }
            while (currentIndex < totalCount)
            {
                IList<Product> currentBatch = ProductDataSource.FindProducts(filter.Name, filter.SearchDescriptions, filter.Sku, filter.CategoryId, filter.ManufacturerId, filter.VendorId, filter.Featured, 0, filter.FromPrice, filter.ToPrice, filter.DigitalGoodsOnly, filter.GiftCertificatesOnly, filter.KitsOnly, filter.SubscriptionsOnly, 100, currentIndex);
                foreach (Product p in currentBatch)
                {
                    foreach (Group group in groups)
                    {
                        ProductGroup pg = ProductGroupDataSource.Load(p.Id, group.Id);
                        if (pg == null)
                        {
                            pg = new ProductGroup(p, group);
                            p.ProductGroups.Add(pg);
                        }
                    }

                    switch (groupRestrictions)
                    {
                        case "YES":
                            p.EnableGroups = true;
                            break;

                        case "NO":
                            p.EnableGroups = false;
                            break;

                        default:
                            break;
                    }

                    p.Save();
                }
                currentIndex += 100;
            }

            database.CommitTransaction();
            return true;
        }

        [WebMethod()]
        public static bool UnAssignProducts(int[] productIds, int groupId)
        {
            List<string> ids = new List<string>();
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            foreach (int pid in productIds)
            {
                ProductGroup pg = ProductGroupDataSource.Load(pid, groupId);
                if (pg != null)
                {
                    var product = pg.Product;
                    product.ProductGroups.Remove(pg);
                    product.Save();
                    pg.Delete();
                }
            }
            database.CommitTransaction();
            return true;
        }

        [WebMethod()]
        public static bool UnAssignAllProducts(ProductFilter filter, int groupId)
        {
            int totalCount = ProductDataSource.FindProductsCount(filter.Name, filter.SearchDescriptions, filter.Sku, filter.CategoryId, filter.ManufacturerId, filter.VendorId, filter.Featured, 0, filter.FromPrice, filter.ToPrice, filter.DigitalGoodsOnly, filter.GiftCertificatesOnly, filter.KitsOnly, filter.SubscriptionsOnly);
            int currentIndex = 0;
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            while (currentIndex < totalCount)
            {
                IList<Product> currentBatch = ProductDataSource.FindProducts(filter.Name, filter.SearchDescriptions, filter.Sku, filter.CategoryId, filter.ManufacturerId, filter.VendorId, filter.Featured, 0, filter.FromPrice, filter.ToPrice, filter.DigitalGoodsOnly, filter.GiftCertificatesOnly, filter.KitsOnly, filter.SubscriptionsOnly, 100, currentIndex);
                foreach (Product p in currentBatch)
                {
                    ProductGroup pg = ProductGroupDataSource.Load(p.Id, groupId);
                    if (pg != null)
                    {
                        p.ProductGroups.Remove(pg);
                        p.Save();
                        pg.Delete();
                    }
                }
                currentIndex += 100;
            }

            database.CommitTransaction();
            return true;
        }

        protected string GetVisibilityIconUrl(object dataItem)
        {
            return _IconPath + "Cms" + (((Product)dataItem).Visibility) + ".gif";
        }

        protected string GetPreviewUrl(object dataItem)
        {
            Product product = (Product)dataItem;
            return Page.ResolveUrl(product.NavigateUrl);
        }

        protected void ProductsGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName.StartsWith("Do_"))
            {
                int productId = AlwaysConvert.ToInt(e.CommandArgument);
                Product product = ProductDataSource.Load(productId);
                switch (e.CommandName)
                {
                    case "Do_Copy":
                        int newProductId = CatalogDataSource.Copy(productId, CatalogNodeType.Product, 0);
                        Response.Redirect(string.Format("EditProduct.aspx?ProductId={0}", newProductId));
                        break;
                    case "Do_Delete":
                        if (product != null)
                        {
                            product.Delete();
                        }
                        break;
                    case "Do_Pub":
                        // TOGGLE VISIBILITY
                        switch (product.Visibility)
                        {
                            case CatalogVisibility.Public:
                                product.Visibility = CatalogVisibility.Hidden;
                                break;
                            case CatalogVisibility.Hidden:
                                product.Visibility = CatalogVisibility.Private;
                                break;
                            default:
                                product.Visibility = CatalogVisibility.Public;
                                break;
                        }
                        product.Save();
                        break;
                }
                PG.DataBind();
            }
        }

        protected void InitializeCategoryTree()
        {
            if (!_DisplayCategorySearch)
            {
                ListItemCollection items = new ListItemCollection();
                int st = 1;
                IList<CategoryLevelNode> categories = CategoryParentDataSource.GetCategoryLevels(0);
                foreach (CategoryLevelNode node in categories)
                {
                    string prefix = string.Empty;
                    for (int i = st; i <= node.CategoryLevel; i++) prefix += " . . ";
                    items.Add(new ListItem(prefix + node.Name, node.CategoryId.ToString()));
                }

                CategoriesList.DataSource = items;
                CategoriesList.DataBind();

                CategoryDropDown.DataSource = items;
                CategoryDropDown.DataBind();
            }
        }

        protected void ResetButton_Click(object sender, EventArgs e)
        {
            // RESET THE SESSION
            Session.Remove("ProductSearchFilter");

            Name.Text = string.Empty;
            SearchDescriptions.Checked = false;
            Sku.Text = string.Empty;
            CategoriesList.SelectedIndex = 0;
            CategoryAutoComplete.Text = string.Empty;
            HiddenSelectedCategoryId.Value = string.Empty;
            ManufacturerList.SelectedIndex = 0;
            VendorList.SelectedIndex = 0;
            ProductGroups.SelectedIndex = 0;
            OnlyFeatured.Checked = false;
            FromPrice.Text = string.Empty;
            ToPrice.Text = string.Empty;
            OnlyDigitalGoods.Checked = false;
            OnlyGiftCertificates.Checked = false;
            OnlyKits.Checked = false;
            OnlySubscriptions.Checked = false;
            ShowProductThumbnails.Checked = false;
        }

        protected string GetGroups(Object dataItem)
        {
            Product product = (Product)dataItem;
            List<string> groupNames = new List<string>();
            foreach (var pg in product.ProductGroups)
            {
                groupNames.Add(pg.Group.Name);
            }

            return string.Join(",", groupNames.ToArray());
        }

        private void LoadSearchFilter()
        {
            ProductFilter criteria = Session["ProductSearchFilter"] as ProductFilter;
            if (criteria != null)
            {
                Name.Text = criteria.Name;
                SearchDescriptions.Checked = criteria.SearchDescriptions;
                Sku.Text = criteria.Sku;
                ListItem selectedItem = null;

                if (!_DisplayCategorySearch)
                {
                    CategoriesList.DataBind();
                    selectedItem = CategoriesList.Items.FindByValue(criteria.CategoryId.ToString());
                    if (selectedItem != null) CategoriesList.SelectedIndex = CategoriesList.Items.IndexOf(selectedItem);
                }
                else
                {
                    Category selectedCategory = CategoryDataSource.Load(criteria.CategoryId);
                    if (selectedCategory != null) CategoryAutoComplete.Text = selectedCategory.Name;
                    HiddenSelectedCategoryId.Value = criteria.CategoryId.ToString();
                }

                ManufacturerList.DataBind();
                selectedItem = ManufacturerList.Items.FindByValue(criteria.ManufacturerId.ToString());
                if (selectedItem != null) ManufacturerList.SelectedIndex = ManufacturerList.Items.IndexOf(selectedItem);

                VendorList.DataBind();
                selectedItem = VendorList.Items.FindByValue(criteria.VendorId.ToString());
                if (selectedItem != null) VendorList.SelectedIndex = VendorList.Items.IndexOf(selectedItem);

                ProductGroups.DataBind();
                selectedItem = ProductGroups.Items.FindByValue(criteria.GroupId.ToString());
                if (selectedItem != null) ProductGroups.SelectedIndex = ProductGroups.Items.IndexOf(selectedItem);

                OnlyFeatured.Checked = criteria.Featured == BitFieldState.True;
                FromPrice.Text = criteria.FromPrice.ToString();
                ToPrice.Text = criteria.ToPrice.ToString();

                OnlyDigitalGoods.Checked = criteria.DigitalGoodsOnly;
                OnlyGiftCertificates.Checked = criteria.GiftCertificatesOnly;
                OnlyKits.Checked = criteria.KitsOnly;
                OnlySubscriptions.Checked = criteria.SubscriptionsOnly;
                ShowProductThumbnails.Checked = criteria.IncludeThumbnails;
            }
        }

        private void SaveSearchFilter()
        {
            ProductFilter criteria = new ProductFilter();
            criteria.Name = Name.Text;
            criteria.SearchDescriptions = SearchDescriptions.Checked;
            criteria.Sku = Sku.Text;

            if (!_DisplayCategorySearch) criteria.CategoryId = AlwaysConvert.ToInt(CategoriesList.SelectedValue);
            else criteria.CategoryId = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);

            criteria.ManufacturerId = AlwaysConvert.ToInt(ManufacturerList.SelectedValue);
            criteria.VendorId = AlwaysConvert.ToInt(VendorList.SelectedValue);
            criteria.Featured = OnlyFeatured.Checked ? BitFieldState.True : BitFieldState.Any;
            criteria.FromPrice = AlwaysConvert.ToDecimal(FromPrice.Text);
            criteria.ToPrice = AlwaysConvert.ToDecimal(ToPrice.Text);
            criteria.DigitalGoodsOnly = OnlyDigitalGoods.Checked;
            criteria.GiftCertificatesOnly = OnlyGiftCertificates.Checked;
            criteria.KitsOnly = OnlyKits.Checked;
            criteria.SubscriptionsOnly = OnlySubscriptions.Checked;
            criteria.IncludeThumbnails = ShowProductThumbnails.Checked;
            criteria.GroupId = AlwaysConvert.ToInt(ProductGroups.SelectedValue);

            // RETURN THE CRITERIA OBJECT
            Session["ProductSearchFilter"] = criteria;
        }

        protected void BatchButton_Click(object sender, EventArgs e)
        {
            List<string> messages = new List<string>();
            string ids = Request.Form["SelectedProductIds"];

            if (!string.IsNullOrEmpty(ids))
            {
                Session["EXPORT_PRODUCT_IDS"] = ids;
                Response.Redirect("../DataExchange/ProductsExport.aspx?type=selected");
            }
        }
    }
}