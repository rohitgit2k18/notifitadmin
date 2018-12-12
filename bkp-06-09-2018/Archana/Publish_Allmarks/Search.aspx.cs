namespace AbleCommerce
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Services;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Products;
    using CommerceBuilder.Search;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Configuration;
    using CommerceBuilder.Search.Providers;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Catalog;

    public partial class Search : CommerceBuilder.UI.AbleCommercePage
    {
        private int _cols = 3;
        private int _pageSize;
        private int _categoryId = 0;
        private int _manufacturerId = 0;
        private string _keywords = string.Empty;
        private string _shopBy = string.Empty;
        private int _hiddenPageIndex;
        private int _searchResultCount;
        private int _lastPageIndex;
        private bool _pagingVarsInitialized = false;

        public int Cols
        {
            get { return _cols; }
            set { _cols = value; }
        }

        private void InitializePagingVars(bool forceRefresh)
        {
            Trace.Write(this.GetType().ToString(), "Begin InitializePagingVars");
            if (!_pagingVarsInitialized || forceRefresh)
            {
                _hiddenPageIndex = AlwaysConvert.ToInt(HiddenPageIndex.Value);
                _searchResultCount = ProductDataSource.AdvancedSearchCount(_keywords, _categoryId, _manufacturerId, true, true, true, 0, 0, SortResults.SelectedValue.StartsWith("IsFeatured"), PageHelper.GetShopByChoices());
                _lastPageIndex = ((int)Math.Ceiling(((double)_searchResultCount / (double)_pageSize))) - 1;
                if (_lastPageIndex < 0) _lastPageIndex = 0;
                if (_hiddenPageIndex > _lastPageIndex) _hiddenPageIndex = _lastPageIndex;
                _pagingVarsInitialized = true;
            }
            Trace.Write(this.GetType().ToString(), "End InitializePagingVars");
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            _categoryId = AlwaysConvert.ToInt(Request.QueryString["c"]);
            _manufacturerId = AlwaysConvert.ToInt(Request.QueryString["m"]);
            _keywords = StringHelper.StripHtml(Server.UrlDecode(Request.QueryString["k"]));
            if (!string.IsNullOrEmpty(_keywords))
            {
                _keywords = StringHelper.StripHtml(_keywords).Trim();
            }

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
                    if (!string.IsNullOrEmpty(_keywords)) url += "&k=" + _keywords;
                    if (!string.IsNullOrEmpty(_shopBy)) url += "&shopby=" + _shopBy;
                    Response.Redirect(url);
                }

            _pageSize = AlwaysConvert.ToInt(PageSizeOptions.SelectedValue);
            ProductList.RepeatColumns = Cols;
            if (_pageSize == 0)
            {
                _pageSize = ProductDataSource.AdvancedSearchCount(_keywords, _categoryId, _manufacturerId, true, true, true, 0, 0, false, PageHelper.GetShopByChoices());
            }

            if (!Page.IsPostBack)
            {
                if (ApplicationSettings.Instance.SearchProvider == "LuceneSearchProvider" || ApplicationSettings.Instance.SearchProvider == "SqlFtsSearchProvider")
                {
                    bool sortByRelevance = true;
                    if (!string.IsNullOrEmpty(_keywords))
                    {
                        ISearchProvider provider = SearchProviderLocator.Locate();
                        LuceneSearchProvider lucene = provider as LuceneSearchProvider;
                        if (lucene != null)
                            sortByRelevance = !lucene.UseSQLSearch(_keywords);
                        SqlFtsSearchProvider sqlFTS = provider as SqlFtsSearchProvider;
                        if (sqlFTS != null)
                            sortByRelevance = !sqlFTS.UseSQLSearch(_keywords);
                    }

                    if (sortByRelevance)
                        SortResults.Items.Insert(0, new ListItem("By Relevance", "FTS.RANK DESC"));
                }

                //INITIALIZE SEARCH CRITERIA ON FIRST VISIT
                HiddenPageIndex.Value = AlwaysConvert.ToInt(Request.QueryString["p"]).ToString();
                string tempSort = Request.QueryString["s"];
                if (!string.IsNullOrEmpty(tempSort))
                {
                    ListItem item = SortResults.Items.FindByValue(tempSort);
                    if (item != null) item.Selected = true;
                }
            }

            int manufecturerCount = ManufacturerDataSource.CountAll();
            bool showSortByManufacturer = false;
            if (manufecturerCount > 0 && _manufacturerId == 0)
            {
                IList<ManufacturerProductCount> mCounts = ProductDataSource.AdvancedSearchCountByManufacturer(_keywords, _categoryId, true, true, true, 0, 0, PageHelper.GetShopByChoices());
                showSortByManufacturer = mCounts != null && mCounts.Count > 0;
            }

            foreach (ListItem li in SortResults.Items)
            {
                if (li.Value.StartsWith("Manufacturer"))
                {
                    li.Enabled = showSortByManufacturer;
                }
            }

            BindSearchResultsPanel();
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
            Trace.Write(this.GetType().ToString(), "Begin BindResultHeader");
            if (string.IsNullOrEmpty(_keywords))
            {
                ResultTermMessage.Visible = false;
            }
            else
            {
                ResultTermMessage.Visible = true;
                ResultTermMessage.Text = string.Format(ResultTermMessage.Text, _keywords);
            }
            //UPDATE THE RESULT INDEX MESSAGE
            int startRowIndex = (_pageSize * _hiddenPageIndex);
            int endRowIndex = startRowIndex + _pageSize;
            if (endRowIndex > _searchResultCount) endRowIndex = _searchResultCount;
            if (_searchResultCount == 0) startRowIndex = -1;
            ResultIndexMessage.Text = string.Format(ResultIndexMessage.Text, (startRowIndex + 1), endRowIndex, _searchResultCount);
            Trace.Write(this.GetType().ToString(), "End BindResultHeader");
        }

        protected void SortResults_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindSearchResultsPanel();
        }

        protected void BindProductList()
        {
            Trace.Write(this.GetType().ToString(), "Begin BindProductList");
            var products = ProductDataSource.AdvancedSearch(_keywords, _categoryId, _manufacturerId, true, true, true, 0, 0, PageHelper.GetShopByChoices(), _pageSize, (_hiddenPageIndex * _pageSize), SortResults.SelectedValue);
            
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
            int minimumPageSize = AlwaysConvert.ToInt(PageSizeOptions.Items[0].Value);
            int totalResults = ProductDataSource.AdvancedSearchCount(_keywords, _categoryId, _manufacturerId, true, true, true, 0, 0, false, PageHelper.GetShopByChoices());
            PageSizePanel.Visible = totalResults > minimumPageSize;
            Trace.Write(this.GetType().ToString(), "End BindProductList");
        }

        #region PagingControls

        protected void BindPagingControls()
        {
            Trace.Write(this.GetType().ToString(), "Begin BindPagingControls");
            if (_lastPageIndex > 0)
            {
                PagerPanel.Visible = true;
                List<PagerLinkData> pagerLinkData = new List<PagerLinkData>();
                float tempIndex = ((float)_hiddenPageIndex / 10) * 10;
                int currentPagerIndex = (int)tempIndex;

                int totalPages = currentPagerIndex + 1 + _pageSize; // ADD ONE BECAUSE IT IS A ZERO BASED INDEX
                if (totalPages > (_lastPageIndex + 1)) totalPages = (_lastPageIndex + 1);

                string baseurl = string.Empty;
                string[] segm = this.Page.Request.Url.Segments;
                foreach (string sg in segm)
                {
                    baseurl += sg;
                }

                string navigateUrl = string.Empty;
                // ESCAPE THE & WITH &amp; and SPACES with + TO AVOID HTML VALIDATION ISSUES
                baseurl += "?" + (String.IsNullOrEmpty(_keywords) ? "" : "k=" + _keywords + "&amp;")
                + (_manufacturerId == 0 ? "" : "m=" + _manufacturerId.ToString() + "&")
                + (String.IsNullOrEmpty(SortResults.SelectedValue) ? "" : "s=" + SortResults.SelectedValue.Replace(" ", "+") + "&amp;")
                + (_categoryId == 0 ? "" : "c=" + _categoryId.ToString() + "&amp;");

                if (!string.IsNullOrEmpty(PageSizeOptions.SelectedValue))
                {
                    baseurl += "ps=" + PageSizeOptions.SelectedValue + "&amp;";
                }

                if(!string.IsNullOrEmpty(_shopBy))
                    baseurl += "shopby=" + _shopBy + "&amp;";

                PagerControls.DataSource = AbleCommerce.Code.NavigationHelper.GetPaginationLinks(currentPagerIndex, totalPages, baseurl);
                PagerControls.DataBind();
            }
            else
            {
                PagerPanel.Visible = false;
            }
            Trace.Write(this.GetType().ToString(), "End BindPagingControls");
        }



        protected void PagerControls_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Page")
            {
                InitializePagingVars(false);
                _hiddenPageIndex = AlwaysConvert.ToInt((string)e.CommandArgument);
                if (_hiddenPageIndex < 0) _hiddenPageIndex = 0;
                if (_hiddenPageIndex > _lastPageIndex) _hiddenPageIndex = _lastPageIndex;
                HiddenPageIndex.Value = _hiddenPageIndex.ToString();
            }
        }

        protected void SetPagerIndex()
        {
            InitializePagingVars(false);
            _hiddenPageIndex = AlwaysConvert.ToInt(Request.QueryString["p"]);
            if (_hiddenPageIndex < 0) _hiddenPageIndex = 0;
            if (_hiddenPageIndex > _lastPageIndex) _hiddenPageIndex = _lastPageIndex;
            HiddenPageIndex.Value = _hiddenPageIndex.ToString();
        }

        #endregion

        [WebMethod]
        public static string[] Suggest(string term)
        {
            return SearchHistoryDataSource.Suggest(term).ToArray();
        }

        protected string GetProductName(Object dateItem)
        {
            Product node = (Product)dateItem;
            if (node.CatalogNodeType == CatalogNodeType.Product)
                return (string)node.Name;
            return null;
        }

        protected string GetProductUrl(Object dateItem)
        {
            Product node = (Product)dateItem;
            if (node.CatalogNodeType == CatalogNodeType.Product)
                return (string)node.NavigateUrl;
            return null;
        }
        protected string GetProductPrice(Object dateItem)
        {
            Product node = (Product)dateItem;
            if (node.CatalogNodeType == CatalogNodeType.Product)
            {
                if (node.VolumeDiscounts.Count > 0 && node.VolumeDiscounts[0].Levels.Any())
                {
                    Decimal minPrice = node.VolumeDiscounts[0].Levels.Last().DiscountAmount;
                    Decimal maxPrice = node.VolumeDiscounts[0].Levels.First().DiscountAmount;
                    if (maxPrice != minPrice)
                        return String.Format("${0} TO ${1}", Decimal.Round(minPrice, 2), Decimal.Round(maxPrice, 2));
                    else
                        return String.Format("${0}", node.Price.ToString("#.##"));
                }

                if (node.MinimumPrice != null && node.MaximumPrice != null)
                    return String.Format("${0} TO ${1}", Decimal.Round((Decimal)node.MinimumPrice, 2), Decimal.Round((Decimal)node.MaximumPrice, 2));
                else if (node.Price > 0)
                    return String.Format("${0}", node.Price.ToString("#.##"));
            }
            return null;
        }
    }
}