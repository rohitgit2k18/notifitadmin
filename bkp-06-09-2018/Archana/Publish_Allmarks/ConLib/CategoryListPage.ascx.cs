namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DomainModel;
    using NHibernate.Transform;

    [Description("A category page that displays all contents of a category in a simple list format. This page displays products, webpages, and links.")]
    public partial class CategoryListPage : System.Web.UI.UserControl
    {
        private Category _Category;
        private int _HiddenPageIndex;
        private int _LastPageIndex;
        private int _totalProducts = 0;

        private string _PagingLinksLocation = "BOTTOM";
        /// <summary>
        /// Indicates where the paging links will be displayd, possible values are "TOP", "BOTTOM" and "TOPANDBOTTOM"
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("BOTTOM")]
        [Description("Indicates where the paging links will be displayd, possible values are \"TOP\", \"BOTTOM\" and \"TOPANDBOTTOM\".")]
        public string PagingLinksLocation
        {
            get { return _PagingLinksLocation; }
            set
            {
                // possible values are "TOP", "BOTTOM" and "TOPANDBOTTOM"
                String tmpLocation = value.ToUpperInvariant();
                if (tmpLocation == "TOP" || tmpLocation == "BOTTOM" || tmpLocation == "TOPANDBOTTOM")
                {
                    _PagingLinksLocation = tmpLocation;
                }
            }
        }

        private bool _DisplayBreadCrumbs = true;
        /// <summary>
        /// Indicates wheather the breadcrumbs should be displayed or not, default value is true
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates wheather the breadcrumbs should be displayed or not, default value is true.")]
        public bool DisplayBreadCrumbs
        {
            get { return _DisplayBreadCrumbs; }
            set { _DisplayBreadCrumbs = value; }
        }

        private string _DefaultCaption = "Catalog";
        /// <summary>
        /// Caption text that will be shown when root category will be browsed
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Catalog")]
        [Description("Caption text that will be shown as caption when root category will be browsed.")]
        public string DefaultCaption
        {
            get { return _DefaultCaption; }
            set { _DefaultCaption = value; }
        }

        private int _PageSize = 20;
        [Browsable(true), DefaultValue(20)]
        [Description("Number of items to display on one page.")]
        public int PageSize
        {
            get { return _PageSize; }
            set { _PageSize = value; }
        }

        private bool _showSummary = false;
        /// <summary>
        /// Indicates wheather the summary should be displayed or not, default value is false
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("Indicates wheather the summary should be displayed or not, default value is false.")]
        public bool ShowSummary
        {
            get { return _showSummary; }
            set { _showSummary = value; }
        }

        private bool _showDescription = false;
        /// <summary>
        /// Indicates wheather the description should be displayed or not, default value is false
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("Indicates wheather the description should be displayed or not, default value is false.")]
        public bool ShowDescription
        {
            get { return _showDescription; }
            set { _showDescription = value; }
        }

        public int CategoryId
        {
            get
            {
                if (ViewState["CategoryId"] == null)
                    ViewState["CategoryId"] = AbleCommerce.Code.PageHelper.GetCategoryId();
                return (int)ViewState["CategoryId"];
            }
            set
            {
                ViewState["CategoryId"] = value;
            }
        }

        protected void Page_Init(object sender, System.EventArgs e)
        {
            Trace.Write(this.GetType().ToString(), "Load Begin");
            _Category = CategoryDataSource.Load(this.CategoryId);
            //EXIT PROCESSING IF CATEGORY IS INVALID OR MARKED PRIVATE
            if (!IsValidCategory())
            {
                SearchResultsAjaxPanel.Visible = false;
            }
            else
            {
                if (_Category != null)
                {
                    //REGISTER THE PAGEVISIT
                    AbleCommerce.Code.PageVisitHelper.RegisterPageVisit(_Category.Id, CatalogNodeType.Category, _Category.Name);
                }

                if (!Page.IsPostBack)
                {
                    //INITIALIZE SEARCH CRITERIA ON FIRST VISIT
                    HiddenPageIndex.Value = Request.QueryString["p"];
                    string tempSort = Request.QueryString["s"];
                    if (!string.IsNullOrEmpty(tempSort))
                    {
                        ListItem item = SortResults.Items.OfType<ListItem>().SingleOrDefault(x => string.Compare(x.Value, tempSort, StringComparison.InvariantCultureIgnoreCase) == 0);
                        if (item != null) item.Selected = true;
                    }
                }

                Trace.Write(this.GetType().ToString(), "Load Complete");
            }
        }
        
        protected void Page_Load(object sender, EventArgs e)
        {
            CategoryBreadCrumbs1.Visible = DisplayBreadCrumbs;
            CategoryBreadCrumbs1.CategoryId = this.CategoryId;

            //BIND THE DISPLAY ELEMENTS
            if (IsValidCategory())
            {
                if (_Category != null)
                {
                    Caption.Text = _Category.Name;

                    if (!string.IsNullOrEmpty(_Category.Summary) && ShowSummary)
                    {
                        CategorySummaryPanel.Visible = true;
                        CategorySummary.Text = _Category.Summary;
                    }
                    else
                        CategorySummaryPanel.Visible = false;

                    if (!string.IsNullOrEmpty(_Category.Description) && ShowDescription)
                    {
                        CategoryDescriptionPanel.Visible = true;
                        CategoryDescription.Text = _Category.Description;
                    }
                    else
                        CategoryDescriptionPanel.Visible = false;
                }
                else
                {
                    // IF IT IS ROOT CATEGORY
                    Caption.Text = DefaultCaption;
                }
                
                BindSubCategories();

                if (_Category != null)
                {
                    //UPDATE THE RESULT INDEX MESSAGE
                    _totalProducts = ProductDataSource.CountForCategory(true, _Category.Id, false, true);
                }
                
                //INITIALIZE PAGING VARIABLES
                InitializePagingVars(false);

                int startRowIndex = (_PageSize * _HiddenPageIndex);
                int endRowIndex = startRowIndex + _PageSize;
                if (endRowIndex > _totalProducts) endRowIndex = _totalProducts;
                if (_totalProducts == 0) startRowIndex = -1;
                
                ResultIndexMessage.Text = string.Format(ResultIndexMessage.Text, (startRowIndex + 1), endRowIndex, _totalProducts);
                if (_Category != null)
                {
                    var products = ProductDataSource.LoadForCategory(true, _Category.Id, false, true, SortResults.SelectedValue, PageSize, startRowIndex);
                    if (products.Count > 0)
                    {
                        var productIds = products.Select(p => p.Id)
                        .ToList<int>();

                        var futureQuery = NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(productIds)
                        .Fetch(p => p.Manufacturer).Eager
                        .Fetch(p => p.Specials).Eager
                        .Future<Product>();

                        NHibernateHelper.QueryOver<Product>()
                            .AndRestrictionOn(p => p.Id).IsIn(productIds)
                            .Fetch(p => p.ProductOptions).Eager
                            .Future<Product>();

                        NHibernateHelper.QueryOver<Product>()
                            .AndRestrictionOn(p => p.Id).IsIn(productIds)
                            .Fetch(p => p.ProductKitComponents).Eager
                            .Future<Product>();

                        NHibernateHelper.QueryOver<Product>()
                            .AndRestrictionOn(p => p.Id).IsIn(productIds)
                            .Fetch(p => p.ProductTemplates).Eager
                            .Future<Product>();

                        NHibernateHelper.QueryOver<Product>()
                            .AndRestrictionOn(p => p.Id).IsIn(productIds)
                            .Fetch(p => p.Reviews).Eager
                            .Future<Product>();

                        futureQuery.ToList();
                    }

                    CatalogNodeList.DataSource = products;
                    CatalogNodeList.DataBind();
                }

                if (_totalProducts > 0)
                {
                    phCategoryContents.Visible = true;
                    
                    //BIND THE PAGING CONTROLS FOOTER
                    BindPagingControls();
                }
                else
                {
                    ResultIndexMessage.Text = string.Format(ResultIndexMessage.Text, 0, 0, 0);
                    
                    //HIDE THE CONTENTS
                    phCategoryContents.Visible = false;
                    phEmptyCategory.Visible = (_Category != null && _Category.CatalogNodes.Count == 0);
                    phNoSearchResults.Visible = !phEmptyCategory.Visible;
                }

                //UPDATE AJAX PANEL
                SearchResultsAjaxPanel.Update();
            }
            else
            {
                CategoryHeaderPanel.Visible = false;
            }
            
            int manufecturerCount = ManufacturerDataSource.CountAll();

            foreach (ListItem li in SortResults.Items)
            {
                if (li.Value.StartsWith("Manufacturer"))
                {
                    li.Enabled = manufecturerCount > 0;
                }
            }
        }

        protected void BindSubCategories()
        {
            IList<Category> allCategories = CategoryDataSource.LoadForParent(this.CategoryId, true);
            List<SubCategoryData> populatedCategories = new List<SubCategoryData>();
            foreach (Category category in allCategories)
            {
                int totalItems = ProductDataSource.CountForCategory(true, category.Id, false, true);
                if (totalItems > 0)
                {
                    populatedCategories.Add(new SubCategoryData(category.Id, category.Name, category.NavigateUrl, totalItems));
                }
            }
            if (populatedCategories.Count > 0)
            {
                SubCategoryPanel.Visible = true;
                SubCategoryRepeater.DataSource = populatedCategories;
                SubCategoryRepeater.DataBind();
            }
            else SubCategoryPanel.Visible = false;
        }

        protected void CatalogNodeList_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                Product product = (Product)e.Item.DataItem;
                Label productSku = (Label)e.Item.FindControl("ProductSku");
                productSku.Text = product.Sku;

                HyperLink productName = (HyperLink)e.Item.FindControl("ProductName");
                productName.Text = product.Name;
                productName.NavigateUrl = product.NavigateUrl;

                HyperLink productManufacturer = (HyperLink)e.Item.FindControl("ProductManufacturer");
                Manufacturer manufacturer = product.Manufacturer;
                if (manufacturer != null)
                {
                    productManufacturer.Text = manufacturer.Name;
                    productManufacturer.NavigateUrl = string.Format("~/Search.aspx?m={0}", manufacturer.Id);
                }
                else
                    productManufacturer.Visible = false;

                Label productRetailPrice = (Label)e.Item.FindControl("ProductRetailPrice");
                if (!product.UseVariablePrice && product.MSRP > 0)
                {
                    productRetailPrice.Text = TaxHelper.GetShopPrice(product.MSRP, product.TaxCode != null ? product.TaxCode.Id : 0).LSCurrencyFormat("ulc");
                }
                else
                    productRetailPrice.Visible = false;
            }
        }

        #region PagingControls

        protected void BindPagingControls()
        {
            if (_LastPageIndex > 0)
            {
                PagerPanel.Visible = (PagingLinksLocation == "BOTTOM" || PagingLinksLocation == "TOPANDBOTTOM");
                PagerPanelTop.Visible = (PagingLinksLocation == "TOP" || PagingLinksLocation == "TOPANDBOTTOM");

                float tempIndex = ((float)_HiddenPageIndex / 10) * 10;
                int currentPagerIndex = (int)tempIndex;

                int totalPages = currentPagerIndex + 1 + _PageSize; // ADD ONE BECAUSE IT IS A ZERO BASED INDEX
                if (totalPages > (_LastPageIndex + 1)) totalPages = (_LastPageIndex + 1);

                string baseUrl;
                if (_Category != null) baseUrl = this.Page.ResolveUrl(_Category.NavigateUrl) + "?";
                else if (this.CategoryId == 0) baseUrl = this.Page.ResolveUrl(Request.Url.AbsolutePath) + "?";
                else baseUrl = AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page, "Search.aspx?");
                //if (!string.IsNullOrEmpty(_Keywords)) baseUrl += "k=" + Server.UrlEncode(_Keywords) + "&";
                //if (_ManufacturerId != 0) baseUrl += "m=" + _ManufacturerId.ToString() + "&";
                if (!String.IsNullOrEmpty(SortResults.SelectedValue)) baseUrl += "s=" + SortResults.SelectedValue + "&";

                if (PagerPanel.Visible)
                {
                    PagerControls.DataSource = AbleCommerce.Code.NavigationHelper.GetPaginationLinks(currentPagerIndex, totalPages, baseUrl);
                    PagerControls.DataBind();
                }

                if (PagerPanelTop.Visible)
                {
                    PagerControlsTop.DataSource = AbleCommerce.Code.NavigationHelper.GetPaginationLinks(currentPagerIndex, totalPages, baseUrl);
                    PagerControlsTop.DataBind();
                }
            }
            else
            {
                PagerPanel.Visible = false;
                PagerPanelTop.Visible = false;
            }
        }

        #endregion

        private bool _PagingVarsInitialized = false;
        private void InitializePagingVars(bool forceRefresh)
        {
            Trace.Write("Initialize Paging Vars");
            if (!_PagingVarsInitialized || forceRefresh)
            {
                _HiddenPageIndex = AlwaysConvert.ToInt(HiddenPageIndex.Value);
                _LastPageIndex = ((int)Math.Ceiling(((double)_totalProducts / (double)_PageSize))) - 1;
                _PagingVarsInitialized = true;
            }
        }

        private bool IsValidCategory()
        {
            // IF IT IS ROOT CATEGORY
            if (this.CategoryId == 0) return true;
            else
            {
                // TRY TO LOAD THE CATEGORY AGAIN
                if (_Category == null) _Category = CategoryDataSource.Load(this.CategoryId);
                if (_Category != null && _Category.Visibility != CatalogVisibility.Private) return true;
                else return false;
            }
        }

        public class SubCategoryData
        {
            private int _CategoryId;
            private string _Name;
            private int _ProductCount;
            private string _NavigateUrl;
            public int CategoryId { get { return _CategoryId; } }
            public string Name { get { return _Name; } }
            public int ProductCount { get { return _ProductCount; } }
            public string NavigateUrl { get { return _NavigateUrl; } }
            public SubCategoryData(int categoryId, string name, string navigateUrl, int productCount)
            {
                _CategoryId = categoryId;
                _Name = name;
                _NavigateUrl = navigateUrl;
                _ProductCount = productCount;
            }
        }
    }
}