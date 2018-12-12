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
using CommerceBuilder.Search;
using CommerceBuilder.Taxes;
using CommerceBuilder.Utility;
using CommerceBuilder.DomainModel;
using System.Linq;
using AbleCommerce.Code;
using CommerceBuilder.Stores;

namespace AbleCommerce
{
    public partial class AdvancedSearch : CommerceBuilder.UI.AbleCommercePage
    {
        private int _CategoryCount = 0;

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                BindProductsGrid();
                string keyword = StringHelper.StripHtml(Keywords.Text).Trim();
                if (!string.IsNullOrEmpty(keyword))
                {
                    SearchHistory record = new SearchHistory(keyword, AbleContext.Current.User);
                    record.Save();
                }
            }
        }

        private void BindProductsGrid()
        {
            SearchResultsPanel.Visible = true;
            ProductsGrid.Visible = true;
            ProductsGrid.PageIndex = 0;
            ProductsGrid.DataBind();
        }

        protected void InitializeCategoryTree()
        {
            IList<CategoryLevelNode> categories = CategoryParentDataSource.GetCategoryLevels(0, true);
            foreach (CategoryLevelNode node in categories)
            {
                string prefix = string.Empty;
                for (int i = 0; i <= node.CategoryLevel; i++) prefix += " . . ";
                CategoryList.Items.Add(new ListItem(prefix + node.Name, node.CategoryId.ToString()));
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryCount = CategoryDataSource.CountAll();
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            bool displayCategorySearch = settings.CategorySearchDisplayLimit > 0 && _CategoryCount >= settings.CategorySearchDisplayLimit;


            if (!Page.IsPostBack && !displayCategorySearch)
            {
                InitializeCategoryTree();
                SelectCategoryLabel.Visible = true;
                EnterCategoryLabel.Visible = false;
            }
            else if (displayCategorySearch)
            {
                // DISPLAY AUTO COMPLETE FOR CATEGORY SEARCH OPTION
                string js = PageHelper.GetAutoCompleteScript(Page.ResolveClientUrl("~/CategorySuggest.ashx"), CategoryAutoComplete, HiddenSelectedCategoryId, "Key", "Value");

                ScriptManager.RegisterStartupScript(SearchAjax, this.GetType(), "CATEGORY_SUGGEST", js, true);
                CategoryAutoComplete.Visible = true;
                CategoryList.Visible = false;
                SelectCategoryLabel.Visible = false;
                EnterCategoryLabel.Visible = true;
            }
            AbleCommerce.Code.PageHelper.SetDefaultButton(Keywords, SearchButton.ClientID);
            AbleCommerce.Code.PageHelper.SetDefaultButton(LowPrice, SearchButton.ClientID);
            AbleCommerce.Code.PageHelper.SetDefaultButton(HighPrice, SearchButton.ClientID);

            int minLength = AbleContext.Current.Store.Settings.MinimumSearchLength;
            KeywordValidator.MinimumLength = minLength;
            KeywordValidator.ErrorMessage = String.Format(KeywordValidator.ErrorMessage, minLength);
        }

        protected String GetCatsList(object product)
        {
            Product p = (Product)product;
            StringBuilder output = new StringBuilder();
            foreach (int categoryId in p.Categories)
            {
                Category category = CategoryDataSource.Load(categoryId);
                if (category != null)
                {
                    output.Append("<a href=\"" + Page.ResolveUrl(category.NavigateUrl) + "\" >" + category.Name + "</a>, ");
                }
            }

            // REMOVE LAST COMMA
            String retValue = output.ToString();
            if (!String.IsNullOrEmpty(retValue))
            {
                return retValue.Substring(0, retValue.Length - 2);
            }
            else
            {
                return retValue;
            }
        }

        protected string GetManufacturerLink(int manufacturerId)
        {
            Manufacturer manufacturer = ManufacturerDataSource.Load(manufacturerId);
            if (manufacturer != null)
            {
                return manufacturer.Name;
            }
            return String.Empty;
        }

        protected void ProductDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["keyword"] = StringHelper.StripHtml(Keywords.Text).Trim();

            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            bool displayCategorySearch = settings.CategorySearchDisplayLimit > 0 && _CategoryCount >= settings.CategorySearchDisplayLimit;
            if (displayCategorySearch) e.InputParameters["categoryId"] = AlwaysConvert.ToInt(HiddenSelectedCategoryId.Value);
        }

        protected void ProductDs_Selected(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.ReturnValue is IList)
            {
                IList<Product> products = (IList<Product>)e.ReturnValue;
                
                // DELAYED QUERIES TO EAGER LOAD RELATED DATA FOR PERFORMANCE BOOST
                if (products.Count < 415)
                {
                    List<int> ids = products.Select(p => p.Id).ToList<int>();

                    var futureQuery = NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(ids)
                        .Fetch(p => p.Specials).Eager
                        .Future<Product>();

                    NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(ids)
                        .Fetch(p => p.ProductOptions).Eager
                        .Future<Product>();

                    NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(ids)
                        .Fetch(p => p.ProductKitComponents).Eager
                        .Future<Product>();

                    NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(ids)
                        .Fetch(p => p.ProductTemplates).Eager
                        .Future<Product>();

                    futureQuery.ToList();
                }
            }
        }
    }
}