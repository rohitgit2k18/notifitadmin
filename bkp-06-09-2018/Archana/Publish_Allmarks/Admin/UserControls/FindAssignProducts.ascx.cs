using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using AbleCommerce.Code;
using CommerceBuilder.Common;
using CommerceBuilder.Products;
using CommerceBuilder.Utility;
using CommerceBuilder.Catalog;
using CommerceBuilder.Stores;

namespace AbleCommerce.Admin.UserControls
{
    public partial class FindAssignProducts : System.Web.UI.UserControl
    {
        public string AssignmentTable { get; set; }
        public string AssignmentStatus { get; set; }
        public int AssignmentValue { get; set; } 
        private string _IconPath = string.Empty;
        private bool _DisplayCategorySearch = false;

        public event AssignProductEventHandler OnAssignProduct;
        public event AssignProductEventHandler OnLinkCheck;
        public event EventHandler OnCancel;
        
        protected void Page_Init(object sender, EventArgs e)
        {
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
            
            int categoryCount = CategoryDataSource.CountAll();
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            _DisplayCategorySearch = settings.CategorySearchDisplayLimit > 0 && categoryCount >= settings.CategorySearchDisplayLimit;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack && !_DisplayCategorySearch)
            {
                InitializeCategoryTree();
            }

            if (_DisplayCategorySearch)
            {
                // DISPLAY AUTO COMPLETE FOR CATEGORY SEARCH OPTION
                string js = PageHelper.GetAutoCompleteScript(Page.ResolveClientUrl("~/CategorySuggest.ashx"), CategoryAutoComplete, HiddenSelectedCategoryId, "Key", "Value");

                ScriptManager.RegisterStartupScript(UpdatePanel1, this.GetType(), "CATEGORY_SUGGEST", js, true);
                CategoryAutoComplete.Visible = true;
                CategoriesList.Visible = false;
            }

            switch(AssignmentStatus)
            {
                case "All":
                    AssignmentStatus = "Any";
                    break;
                case "AssignedProducts":
                    AssignmentStatus = "True";
                    break;
                case "UnassignedProducts":
                    AssignmentStatus = "False";
                    break;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            gridFooter.Visible = PG.Visible && PG.Rows.Count > 0;

            if (!Page.IsPostBack && gridFooter.Visible)
            {
                ProductAssignment.ClearSelection();
                ListItem item = ProductAssignment.Items.FindByValue(AssignmentStatus);
                if (item != null)
                    item.Selected = true;
                PG.DataBind();
            }
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            PG.DataBind();
        }

        protected void PG_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (PG.Rows.Count == 0)
                {
                    ProductAssignment.ClearSelection();
                    ListItem item = ProductAssignment.Items.FindByValue("Any");
                    if (item != null)
                        item.Selected = true;
                    PG.DataBind();
                }
            }
        }

        protected void ResetButton_Click(object sender, EventArgs e)
        {
            Name.Text = string.Empty;
            SearchDescriptions.Checked = false;
            Sku.Text = string.Empty;
            CategoriesList.SelectedIndex = 0;
            CategoryAutoComplete.Text = string.Empty;
            HiddenSelectedCategoryId.Value = string.Empty;
            FromPrice.Text = string.Empty;
            ToPrice.Text = string.Empty;
            ManufacturerList.SelectedIndex = 0;
            VendorList.SelectedIndex = 0;
            ProductGroups.SelectedIndex = 0;
            TaxCodeList.SelectedIndex = 0;
            OnlyFeatured.Checked = false;
            OnlyDigitalGoods.Checked = false;
            OnlyGiftCertificates.Checked = false;
            OnlyKits.Checked = false;
            OnlySubscriptions.Checked = false;
            ProductAssignment.SelectedIndex = 1;
            ShowProductThumbnails.Checked = false;
            PG.DataBind();
        }

        protected void ProductsDS_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            BitFieldState featured = OnlyFeatured.Checked ? BitFieldState.True : BitFieldState.Any;
            BitFieldState status = (BitFieldState)Enum.Parse(typeof(BitFieldState), ProductAssignment.SelectedValue);
            e.InputParameters["featured"] = featured;
            e.InputParameters["assignmentTable"] = this.AssignmentTable;
            e.InputParameters["assignmentValue"] = this.AssignmentValue;
            e.InputParameters["assignmentStatus"] = status;
            if (_DisplayCategorySearch) e.InputParameters["categoryId"] = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);
            PG.Columns[1].Visible = ShowProductThumbnails.Checked;
        }

        protected void AttachButton_Click(object sender, EventArgs e)
        {
            ImageButton attachButton = (ImageButton)sender;
            int dataItemIndex = AlwaysConvert.ToInt(attachButton.CommandArgument);
            GridView grid = PG;
            int productId = (int)grid.DataKeys[dataItemIndex].Value;
            if (OnAssignProduct != null)
                OnAssignProduct(this, new FindAssignProductEventArgs(productId, true));
            ImageButton removeButton = attachButton.Parent.FindControl("RemoveButton") as ImageButton;
            if (removeButton != null) removeButton.Visible = true;
            attachButton.Visible = false;
            PG.DataBind();
        }

        protected void RemoveButton_Click(object sender, EventArgs e)
        {
            ImageButton removeButton = (ImageButton)sender;
            int dataItemIndex = AlwaysConvert.ToInt(removeButton.CommandArgument);
            GridView grid = PG;
            int productId = (int)grid.DataKeys[dataItemIndex].Value;
            if (OnAssignProduct != null)
                OnAssignProduct(this, new FindAssignProductEventArgs(productId, false));
            ImageButton attachButton = removeButton.Parent.FindControl("AttachButton") as ImageButton;
            if (attachButton != null) attachButton.Visible = true;
            removeButton.Visible = false;
            PG.DataBind();
        }

        protected bool IsProductLinked(Product product)
        {
            FindAssignProductEventArgs e = new FindAssignProductEventArgs(product, false);
            if (OnLinkCheck != null)
                OnLinkCheck(this, e);
            return e.Link;
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

        protected string GetVisibilityIconUrl(object dataItem)
        {
            return _IconPath + "Cms" + (((Product)dataItem).Visibility) + ".gif";
        }

        protected string GetPreviewUrl(object dataItem)
        {
            Product product = (Product)dataItem;
            return Page.ResolveUrl(product.NavigateUrl);
        }

        protected void GoButton_Click(object sender, EventArgs e)
        {
            bool selectAll = AlwaysConvert.ToBool(SelectAll.Value, false);
            bool link = AlwaysConvert.ToBool(GridActions.SelectedValue, false);
            if (selectAll)
            {
                BitFieldState featured = OnlyFeatured.Checked ? BitFieldState.True : BitFieldState.Any;
                BitFieldState status = (BitFieldState)Enum.Parse(typeof(BitFieldState), ProductAssignment.SelectedValue);

                int categoryId = 0;
                if (!_DisplayCategorySearch) categoryId = AlwaysConvert.ToInt(CategoriesList.SelectedValue);
                else categoryId = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);

                IList<Product> products = ProductDataSource.FindProducts(Name.Text.Trim(), SearchDescriptions.Checked, Sku.Text.Trim(), categoryId, AlwaysConvert.ToInt(ManufacturerList.SelectedValue), AlwaysConvert.ToInt(VendorList.SelectedValue), featured, AlwaysConvert.ToInt(TaxCodeList.SelectedValue), AlwaysConvert.ToDecimal(FromPrice.Text), AlwaysConvert.ToDecimal(ToPrice.Text), OnlyDigitalGoods.Checked, OnlyGiftCertificates.Checked, OnlyKits.Checked, OnlySubscriptions.Checked, AlwaysConvert.ToInt(ProductGroups.SelectedValue), AssignmentTable, AssignmentValue, status);
                foreach (var product in products)
                {
                    if (OnAssignProduct != null)
                        OnAssignProduct(this, new FindAssignProductEventArgs(product.Id, link));
                }
            }
            else
            {
                int indexPeg = PG.PageSize * PG.PageIndex;

                foreach (GridViewRow row in PG.Rows)
                {
                    CheckBox selected = (CheckBox)PageHelper.RecursiveFindControl(row, "PID");
                    if ((selected != null) && selected.Checked)
                    {
                        int productId = (int)PG.DataKeys[row.DataItemIndex - indexPeg].Values[0];
                        if (OnAssignProduct != null)
                            OnAssignProduct(this, new FindAssignProductEventArgs(productId, link));
                    }
                }
            }

            PG.DataBind();
        }

        public IList<Product> GetSelectedProducts()
        {
            bool selectAll = AlwaysConvert.ToBool(SelectAll.Value, false);
            bool link = AlwaysConvert.ToBool(GridActions.SelectedValue, false);
            IList<Product> products = new List<Product>();
            if (selectAll)
            {
                BitFieldState featured = OnlyFeatured.Checked ? BitFieldState.True : BitFieldState.Any;
                BitFieldState status = (BitFieldState)Enum.Parse(typeof(BitFieldState), ProductAssignment.SelectedValue);
                int categoryId = 0;
                if (!_DisplayCategorySearch) categoryId = AlwaysConvert.ToInt(CategoriesList.SelectedValue);
                else categoryId = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);
                products = ProductDataSource.FindProducts(Name.Text.Trim(), SearchDescriptions.Checked, Sku.Text.Trim(), categoryId, AlwaysConvert.ToInt(ManufacturerList.SelectedValue), AlwaysConvert.ToInt(VendorList.SelectedValue), featured, AlwaysConvert.ToInt(TaxCodeList.SelectedValue), AlwaysConvert.ToDecimal(FromPrice.Text), AlwaysConvert.ToDecimal(ToPrice.Text), OnlyDigitalGoods.Checked, OnlyGiftCertificates.Checked, OnlyKits.Checked, OnlySubscriptions.Checked, AlwaysConvert.ToInt(ProductGroups.SelectedValue), AssignmentTable, AssignmentValue, status);
            }
            else
            {
                int indexPeg = PG.PageSize * PG.PageIndex;

                foreach (GridViewRow row in PG.Rows)
                {
                    CheckBox selected = (CheckBox)PageHelper.RecursiveFindControl(row, "PID");
                    if ((selected != null) && selected.Checked)
                    {
                        int dataItemIndex = row.DataItemIndex;
                        dataItemIndex = (dataItemIndex - (PG.PageSize * PG.PageIndex));
                        int productId = (int)PG.DataKeys[dataItemIndex].Value;
                        products.Add(ProductDataSource.Load(productId));
                    }
                }
            }

            return products;
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
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            if (OnCancel != null)
                OnCancel(sender, e);
        }
    }
}

namespace AbleCommerce 
{ 
    public class FindAssignProductEventArgs : EventArgs
    {
        public int ProductId { get; set; }
        public Product Product { get; set; }
        public bool Link { get; set; }
        
        public FindAssignProductEventArgs(int productId, bool link)
        {
            this.ProductId = productId;
            this.Link = link;
        }

        public FindAssignProductEventArgs(Product product, bool link)
            :this(product.Id, link)
        {
            this.Product = product;
        }
    }

    public delegate void AssignProductEventHandler(Object sender, FindAssignProductEventArgs e);
}