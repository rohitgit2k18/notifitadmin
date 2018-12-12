namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Common;

    public partial class EditSimilarProducts : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Product _Product;
        private string _IconPath = string.Empty;
        private bool _DisplayCategorySearch = false;

        protected void Page_Init(object sender, EventArgs e)
        {   
            int productId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(productId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            Caption.Text = string.Format(Caption.Text, _Product.Name);
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);

            int categoryCount = CategoryDataSource.CountAll();
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            _DisplayCategorySearch = settings.CategorySearchDisplayLimit > 0 && categoryCount >= settings.CategorySearchDisplayLimit;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                InitializeCategoryTree();
                int count = RelatedProductDataSource.CountForProduct(_Product.Id);
                if (count == 0)
                {
                    count = RelatedProductDataSource.CountForChildProduct(_Product.Id);
                }
                if (count == 0) Filter.SelectedValue = "4";
                else Filter.SelectedValue = "0";
                SearchButton_Click(null, null);
            }

            if (_DisplayCategorySearch)
            {
                // DISPLAY AUTO COMPLETE FOR CATEGORY SEARCH OPTION
                string js = PageHelper.GetAutoCompleteScript("../../CategorySuggest.ashx", CategoryAutoComplete, HiddenSelectedCategoryId, "Key", "Value");

                ScriptManager.RegisterStartupScript(MainContentAjax, this.GetType(), "CATEGORY_SUGGEST", js, true);
                CategoryAutoComplete.Visible = true;
                CategoryList.Visible = false;
            }
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            SearchResultsGrid.Visible = true;
            SearchResultsGrid.PageIndex = 0;
            SearchResultsGrid.DataBind();
        }

        protected void ResetButton_Click(object sender, EventArgs e)
        {
            SearchName.Text = string.Empty;
            CategoryList.SelectedIndex = 0;
            CategoryAutoComplete.Text = string.Empty;
            HiddenSelectedCategoryId.Value = string.Empty;
            Filter.SelectedIndex = 0;
            ProductGroups.SelectedIndex = 0;
            ShowImages.Checked = false;
            SearchResultsGrid.Visible = false;
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageProducts.aspx");
        }

        protected void ProductSearchDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            CrossSellState csf = (CrossSellState)AlwaysConvert.ToByte(Filter.SelectedValue);
            e.InputParameters["crossSellFilter"] = csf;
            SearchResultsGrid.Columns[2].Visible = ShowImages.Checked;

            if (_DisplayCategorySearch) e.InputParameters["categoryId"] = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            GridView grid = SearchResultsGrid;
            foreach (GridViewRow row in grid.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    int dataItemIndex = row.DataItemIndex;
                    dataItemIndex = (dataItemIndex - (grid.PageSize * grid.PageIndex));
                    int productId = (int)grid.DataKeys[dataItemIndex].Value;
                    Product product = ProductDataSource.Load(productId);
                    if (product == null) continue;
                    DropDownList crossSellState = (DropDownList)grid.Rows[row.RowIndex].FindControl("CrossSellState");
                    int state = AlwaysConvert.ToInt(crossSellState.SelectedValue);
                    switch (state)
                    {
                        case 0:
                            AdjustCrossSellLinking(_Product.Id, product.Id, CrossSellState.Unlinked);
                            break;
                        case 1:
                            AdjustCrossSellLinking(_Product.Id, product.Id, CrossSellState.CrossLinked);
                            break;
                        case 2:
                            AdjustCrossSellLinking(_Product.Id, product.Id, CrossSellState.LinksTo);
                            break;
                        case 3:
                            AdjustCrossSellLinking(_Product.Id, product.Id, CrossSellState.LinkedFrom);
                            break;
                    }
                }
            }
            grid.DataBind();
            SavedMessage.Visible = true;
        }

        protected void AdjustCrossSellLinking(int firstProductId, int secondProductId, CrossSellState crossSellState)
        {
            RelatedProduct toReleatedProduct = RelatedProductDataSource.Load(firstProductId, secondProductId);
            RelatedProduct fromReleatedProduct = RelatedProductDataSource.Load(secondProductId, firstProductId);
            switch (crossSellState)
            {
                case CrossSellState.Unlinked:

                    if (toReleatedProduct != null)
                        toReleatedProduct.Delete();

                    if (fromReleatedProduct != null)
                        fromReleatedProduct.Delete();

                    break;
                case CrossSellState.CrossLinked:

                    if (toReleatedProduct == null)
                    {
                        toReleatedProduct = new RelatedProduct(firstProductId, secondProductId);
                        toReleatedProduct.Save();
                    }

                    if (fromReleatedProduct == null)
                    {
                        fromReleatedProduct = new RelatedProduct(secondProductId, firstProductId);
                        fromReleatedProduct.Save();
                    }

                    break;
                case CrossSellState.LinksTo:
                    if (toReleatedProduct == null)
                    {
                        toReleatedProduct = new RelatedProduct(firstProductId, secondProductId);
                        toReleatedProduct.Save();
                    }
                    if (fromReleatedProduct != null)
                        fromReleatedProduct.Delete();
                    break;
                case CrossSellState.LinkedFrom:
                    if (toReleatedProduct != null)
                        toReleatedProduct.Delete();
                    if (fromReleatedProduct == null)
                    {
                        fromReleatedProduct = new RelatedProduct(secondProductId, firstProductId);
                        fromReleatedProduct.Save();
                    }
                    break;
            }
        }

        protected void InitializeCategoryTree()
        {
            if (!_DisplayCategorySearch)
            {
                IList<CategoryLevelNode> categories = CategoryParentDataSource.GetCategoryLevels(0, true);
                foreach (CategoryLevelNode node in categories)
                {
                    string prefix = string.Empty;
                    for (int i = 0; i <= node.CategoryLevel; i++) prefix += " . . ";
                    CategoryList.Items.Add(new ListItem(prefix + node.Name, node.CategoryId.ToString()));
                }
            }
        }

        protected void SearchResultsGrid_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Product product = (Product)e.Row.DataItem;
                if (product == null) return;

                DropDownList crossSellStateList = (DropDownList)e.Row.FindControl("CrossSellState");
                CrossSellState currentState = GetCrossSellState(_Product.Id, product.Id);
                switch (currentState)
                {
                    case CrossSellState.Linked:
                    case CrossSellState.CrossLinked:
                        crossSellStateList.SelectedValue = "1";
                        break;
                    case CrossSellState.LinksTo:
                        crossSellStateList.SelectedValue = "2";
                        break;
                    case CrossSellState.LinkedFrom:
                        crossSellStateList.SelectedValue = "3";
                        break;
                    case CrossSellState.Unlinked:
                        crossSellStateList.SelectedValue = "0";
                        break;
                }
            }
        }

        protected CrossSellState GetCrossSellState(int firstProductId, int secondProductId)
        {
            int masterCount = RelatedProductDataSource.GetRelatedCount(firstProductId, secondProductId);
            int childCount = RelatedProductDataSource.GetRelatedCount(secondProductId, firstProductId);

            CrossSellState crossSellState = CrossSellState.Unlinked;

            if (masterCount > 0 && childCount > 0)
                crossSellState = CrossSellState.CrossLinked;
            else
                if (masterCount > 0 && childCount == 0)
                    crossSellState = CrossSellState.LinksTo;
                else
                    if (masterCount == 0 && childCount > 0)
                        crossSellState = CrossSellState.LinkedFrom;
            return crossSellState;
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
    }
}