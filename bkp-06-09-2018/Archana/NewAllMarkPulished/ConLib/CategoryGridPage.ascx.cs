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
    using CommerceBuilder.Products;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DomainModel;
    using AbleCommerce.Code;


    [Description("The defualt category page that displays products in a grid format. Allows customers to browse your catalog.")]
    public partial class CategoryGridPage : System.Web.UI.UserControl
    {        
        private int _pageSize;
        private int _manufacturerId = 0;
        private string _keywords = string.Empty;
        private string _shopBy = string.Empty;
        private int _hiddenPageIndex;
        private int _searchResultCount;
        private int _lastPageIndex;
        private int _categoryId;
        private Category _category;


        private int _cols = 3;
        [Browsable(true), DefaultValue(3)]
        [Description("The number of columns to display")]
        public int Cols 
        {
            get { return _cols;  }
            set { _cols = value; }
        }

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

        private void BindPage()
        {
            //BIND THE DISPLAY ELEMENTS
            if (IsValidCategory())
            {
                CategoryBreadCrumbs1.Visible = DisplayBreadCrumbs;
                CategoryBreadCrumbs1.CategoryId = this._categoryId;
                if (_category != null)
                {
                    Caption.Text = _category.Name;

                    if (!string.IsNullOrEmpty(_category.Summary) && ShowSummary)
                    {
                        CategorySummaryPanel.Visible = true;
                        CategorySummary.Text = _category.Summary;
                    }
                    else
                        CategorySummaryPanel.Visible = false;

                    if (!string.IsNullOrEmpty(_category.Description) && ShowDescription)
                    {
                        CategoryDescriptionPanel.Visible = true;
                        CategoryDescription.Text = _category.Description;
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
            }
            else
            {
                CategoryHeaderPanel.Visible = false;
            }

            BindSearchResultsPanel();
        }

        private bool _PagingVarsInitialized = false;
        private void InitializePagingVars(bool forceRefresh)
        {
            Trace.Write("Initialize Paging Vars");
            if (!_PagingVarsInitialized || forceRefresh)
            {
                _hiddenPageIndex = AlwaysConvert.ToInt(HiddenPageIndex.Value);
                _searchResultCount = ProductDataSource.AdvancedSearchCount(_keywords, this._categoryId, _manufacturerId, true, true, true, 0, 0, false, PageHelper.GetShopByChoices());
                _lastPageIndex = ((int)Math.Ceiling(((double)_searchResultCount / (double)_pageSize))) - 1;
                _PagingVarsInitialized = true;
            }
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            _categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            _manufacturerId = AlwaysConvert.ToInt(Request.QueryString["m"]);
            _shopBy = StringHelper.StripHtml(Server.UrlDecode(Request.QueryString["shopby"]));
            if (!string.IsNullOrEmpty(_shopBy))
            {
                _shopBy = StringHelper.StripHtml(_shopBy).Trim();
            }

            string eventTarget = Request["__EVENTTARGET"];
            if (string.IsNullOrEmpty(eventTarget) || !eventTarget.EndsWith("PageSizeOptions"))
            {
                string pageSizeOption = Request.QueryString["ps"];
                if (!string.IsNullOrEmpty(pageSizeOption))
                {
                    PageSizeOptions.ClearSelection();
                    ListItem item = PageSizeOptions.Items.FindByValue(pageSizeOption);
                    if (item != null) item.Selected = true;
                }
            }
            else
            if (eventTarget.EndsWith("PageSizeOptions"))
            {
                string url = Request.RawUrl;
                if (url.Contains("?"))
                    url = Request.RawUrl.Substring(0, Request.RawUrl.IndexOf("?"));
                url += "?s=" + SortResults.SelectedValue;
                url += "&ps=" + PageSizeOptions.SelectedValue;
                if (_categoryId != 0) url += "&c=" + _categoryId.ToString();
                if (_manufacturerId != 0) url += "&m=" + _manufacturerId.ToString();
                if (!string.IsNullOrEmpty(_shopBy)) url += "&shopby=" + _shopBy;
                Response.Redirect(url);
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

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            Trace.Write(this.GetType().ToString(), "Load Begin");
            _pageSize = AlwaysConvert.ToInt(PageSizeOptions.SelectedValue);
            if (_pageSize == 0)
            {
                _pageSize = ProductDataSource.AdvancedSearchCount(_keywords, this._categoryId, _manufacturerId, true, true, true, 0, 0, false, PageHelper.GetShopByChoices());
            }
            ProductList.RepeatColumns = Cols;
            _keywords = Server.UrlDecode(Request.QueryString["k"]);
            if (!string.IsNullOrEmpty(_keywords))
                _keywords = StringHelper.StripHtml(_keywords).Trim();
            _category = CategoryDataSource.Load(this._categoryId);

            //EXIT PROCESSING IF CATEGORY IS INVALID OR MARKED PRIVATE
            if (!IsValidCategory())
            {
                SearchResultsPanel.Visible = false;
            }
            else
            {
                if (_category != null)
                {
                    //REGISTER THE PAGEVISIT
                    AbleCommerce.Code.PageVisitHelper.RegisterPageVisit(_category.Id, CatalogNodeType.Category, _category.Name);
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

                SetPagerIndex();
            }

            if (IsValidCategory())
            {
                //BIND PAGE
                BindPage();
            }
        }

        protected void BindSubCategories()
        {
            IList<Category> allCategories = CategoryDataSource.LoadForParent(this._categoryId, true);
            List<SubCategoryData> populatedCategories = new List<SubCategoryData>();
            foreach (Category category in allCategories)
            {
                // SEARCH ALL CATEGORIES
                int totalProducts = ProductDataSource.AdvancedSearchCount(_keywords, category.Id, _manufacturerId, true, true, true, 0, 0, false, PageHelper.GetShopByChoices());
                if (totalProducts > 0)
                {
                    populatedCategories.Add(new SubCategoryData(category.Id, category.Name, category.NavigateUrl, totalProducts));
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

        private void BindSearchResultsPanel()
        {
            Trace.Write(this.GetType().ToString(), "Begin Bind Search Results");
            //INITIALIZE PAGING VARIABLES
            InitializePagingVars(false);
            //BIND THE RESULT HEADER
            BindResultHeader();
            //BIND THE PRODUCT LIST
            BindProductList();
            //BIND THE PAGING CONTROLS FOOTER
            BindPagingControls();
            Trace.Write(this.GetType().ToString(), "End Bind Search Results");
        }

        protected void BindResultHeader()
        {
            //UPDATE THE RESULT INDEX MESSAGE
            int startRowIndex = (_pageSize * _hiddenPageIndex);
            int endRowIndex = startRowIndex + _pageSize;
            if (endRowIndex > _searchResultCount) endRowIndex = _searchResultCount;
            if (_searchResultCount == 0) startRowIndex = -1;
            ResultIndexMessage.Text = string.Format(ResultIndexMessage.Text, (startRowIndex + 1), endRowIndex, _searchResultCount);
        }

        protected void SortResults_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindPage();
        }

        protected void BindProductList()
        {
            IList<Product> products = ProductDataSource.AdvancedSearch(_keywords, this._categoryId, _manufacturerId, true, true, true, 0, 0, PageHelper.GetShopByChoices(), _pageSize, (_hiddenPageIndex * _pageSize), SortResults.SelectedValue);
            
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

                NHibernateHelper.QueryOver<Product>()
                    .AndRestrictionOn(p => p.Id).IsIn(ids)
                    .Fetch(p => p.Reviews).Eager
                    .Future<Product>();

                futureQuery.ToList();
            }

            ProductList.DataSource = products;
            ProductList.DataBind();
            NoSearchResults.Visible = (_searchResultCount == 0);

            if (_pageSize == 0)
                _pageSize = products.Count;

            int minimumPageSize = AlwaysConvert.ToInt(PageSizeOptions.Items[0].Value);
            int totalResults = ProductDataSource.AdvancedSearchCount(_keywords, this._categoryId, _manufacturerId, true, true, true, 0, 0, false, PageHelper.GetShopByChoices());
            PageSizePanel.Visible = totalResults > minimumPageSize;
        }

        #region PagingControls

        protected void BindPagingControls()
        {
            if (_lastPageIndex > 0)
            {
                PagerPanel.Visible = (PagingLinksLocation == "BOTTOM" || PagingLinksLocation == "TOPANDBOTTOM");
                PagerPanelTop.Visible = (PagingLinksLocation == "TOP" || PagingLinksLocation == "TOPANDBOTTOM");

                float tempIndex = ((float)_hiddenPageIndex / 10) * 10;
                int currentPagerIndex = (int)tempIndex;

                int totalPages = currentPagerIndex + 1 + _pageSize; // ADD ONE BECAUSE IT IS A ZERO BASED INDEX
                if (totalPages > (_lastPageIndex + 1)) totalPages = (_lastPageIndex + 1);

                string baseUrl;
                if (_category != null) baseUrl = this.Page.ResolveUrl(_category.NavigateUrl) + "?";
                else if (this._categoryId == 0) baseUrl = this.Page.ResolveUrl(Request.Url.AbsolutePath) + "?";
                else baseUrl = AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page, "Search.aspx?");
                if (!string.IsNullOrEmpty(_keywords)) baseUrl += "k=" + Server.UrlEncode(_keywords) + "&";
                if (_manufacturerId != 0) baseUrl += "m=" + _manufacturerId.ToString() + "&";
                if (!String.IsNullOrEmpty(SortResults.SelectedValue)) baseUrl += "s=" + SortResults.SelectedValue + "&";

                // INCLUDE CATEGORY ID IF PAGE HAVE SEARCH SIDE BAR
                baseUrl += "c=" + _categoryId + "&";

                if (!string.IsNullOrEmpty(PageSizeOptions.SelectedValue))
                {
                    baseUrl += "ps=" + PageSizeOptions.SelectedValue + "&";
                }

                if (!string.IsNullOrEmpty(_shopBy)) baseUrl += "shopby=" + _shopBy + "&";

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


        protected void PagerControls_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Page")
            {
                InitializePagingVars(false);
                _hiddenPageIndex = AlwaysConvert.ToInt((string)e.CommandArgument);
                if (_hiddenPageIndex < 0) _hiddenPageIndex = 0;
                if (_hiddenPageIndex > _lastPageIndex) _hiddenPageIndex = _lastPageIndex < 0 ? 0 : _lastPageIndex;
                HiddenPageIndex.Value = _hiddenPageIndex.ToString();
            }
        }
        protected void SetPagerIndex()
        {
            InitializePagingVars(false);
            _hiddenPageIndex = AlwaysConvert.ToInt(Request.QueryString["p"]);
            if (_hiddenPageIndex < 0) _hiddenPageIndex = 0;
            if (_hiddenPageIndex > _lastPageIndex) _hiddenPageIndex = _lastPageIndex < 0 ? 0 : _lastPageIndex;
            HiddenPageIndex.Value = _hiddenPageIndex.ToString();
        }
        #endregion

        private bool IsValidCategory()
        {
            // IF IT IS ROOT CATEGORY
            if (this._categoryId == 0) return true;
            else
            {
                // TRY TO LOAD THE CATEGORY AGAIN
                if (_category == null) _category = CategoryDataSource.Load(this._categoryId);
                if (_category != null && _category.Visibility != CatalogVisibility.Private) return true;
                else return false;
            }
        }
    }
}