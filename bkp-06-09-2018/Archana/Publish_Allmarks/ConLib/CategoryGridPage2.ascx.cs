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
    using CommerceBuilder.Utility;
    using CommerceBuilder.DomainModel;

    [Description("A category page that displays all products in a grid format.")]
    public partial class CategoryGridPage2 : System.Web.UI.UserControl
    {
        private int _pageSize;
        private Category _Category;
        private IList<Product> _ContentNodes;
        private int _HiddenPageIndex;
        private int _searchResultCount;
        private int _LastPageIndex;

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
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates wheather the breadcrumbs should be displayed or not, default value is true.")]
        [Personalizable(), WebBrowsable()]
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
                _HiddenPageIndex = AlwaysConvert.ToInt(HiddenPageIndex.Value);
                _searchResultCount = ProductDataSource.CountForCategory(true, this.CategoryId, false, true);
                _LastPageIndex = ((int)Math.Ceiling(((double)_searchResultCount / (double)_pageSize))) - 1;
                _PagingVarsInitialized = true;
            }
        }

        protected void Page_Init(object sender, System.EventArgs e)
        {
            Trace.Write(this.GetType().ToString(), "Load Begin");
            _Category = CategoryDataSource.Load(this.CategoryId);
            //EXIT PROCESSING IF CATEGORY IS INVALID OR MARKED PRIVATE
            if (!IsValidCategory())
            {
               // SearchResultsAjaxPanel.Visible = false;
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
                    _HiddenPageIndex = AlwaysConvert.ToInt(Request.QueryString["p"]);
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

        protected void BindSubCategories()
        {
            IList<Category> allCategories = CategoryDataSource.LoadForParent(this.CategoryId, true);
            List<SubCategoryData> populatedCategories = new List<SubCategoryData>();
            foreach (Category category in allCategories)
            {
                int productCount = ProductDataSource.CountForCategory(true, category.Id, true, true);
                if (productCount > 0)
                {
                    populatedCategories.Add(new SubCategoryData(category.Id, category.Name, category.NavigateUrl, productCount));
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
            if (_ContentNodes.Count > 0)
            {   
                phCategoryContents.Visible = true;
                //INITIALIZE PAGING VARIABLES
                InitializePagingVars(false);
                //BIND THE RESULT PANE
                BindResultHeader();
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
            //SearchResultsAjaxPanel.Update();
            Trace.Write(this.GetType().ToString(), "End Bind Search Results");
        }

        protected void SortResults_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindSearchResultsPanel();
        }

        protected void BindResultHeader()
        {
            //UPDATE THE RESULT INDEX MESSAGE
            int startRowIndex = (_pageSize * _HiddenPageIndex);
            int endRowIndex = startRowIndex + _pageSize;
            if (endRowIndex > _searchResultCount) endRowIndex = _searchResultCount;
            if (_searchResultCount == 0) startRowIndex = -1;
            ResultIndexMessage.Text = string.Format(ResultIndexMessage.Text, (startRowIndex + 1), endRowIndex, _searchResultCount);
            CatalogNodeList.DataSource = _ContentNodes;
            CatalogNodeList.DataBind();
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

                int totalPages = currentPagerIndex + 1 + _pageSize; // ADD ONE BECAUSE IT IS A ZERO BASED INDEX
                if (totalPages > (_LastPageIndex + 1)) totalPages = (_LastPageIndex + 1);

                string baseUrl;
                if (_Category != null) baseUrl = this.Page.ResolveUrl(_Category.NavigateUrl) + "?";
                else if (this.CategoryId == 0) baseUrl = this.Page.ResolveUrl(Request.Url.AbsolutePath) + "?";
                else baseUrl = AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page, "Search.aspx?");
                //if (!string.IsNullOrEmpty(_Keywords)) baseUrl += "k=" + Server.UrlEncode(_Keywords) + "&";
                //if (_ManufacturerId != 0) baseUrl += "m=" + _ManufacturerId.ToString() + "&";
                if (!String.IsNullOrEmpty(SortResults.SelectedValue)) baseUrl += "s=" + SortResults.SelectedValue + "&";
                if (!string.IsNullOrEmpty(PageSizeOptions.SelectedValue))
                {
                    baseUrl += "ps=" + PageSizeOptions.SelectedValue + "&";
                }

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
                _HiddenPageIndex = AlwaysConvert.ToInt((string)e.CommandArgument);
                _searchResultCount = ProductDataSource.CountForCategory(true, this.CategoryId, false, true);
                if (_HiddenPageIndex < 0) _HiddenPageIndex = 0;
                if (_HiddenPageIndex > _LastPageIndex) _HiddenPageIndex = _LastPageIndex;
                HiddenPageIndex.Value = _HiddenPageIndex.ToString();
            }
        }
        protected void SetPagerIndex()
        {
            InitializePagingVars(false);            
            _HiddenPageIndex = AlwaysConvert.ToInt(Request.QueryString["p"]);
            if (_HiddenPageIndex < 0) _HiddenPageIndex = 0;
            if (_HiddenPageIndex > _LastPageIndex) _HiddenPageIndex = _LastPageIndex < 0 ? 0 : _LastPageIndex;
            HiddenPageIndex.Value = _HiddenPageIndex.ToString();
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
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
                    Response.Redirect(url); 
                }

            _pageSize = AlwaysConvert.ToInt(PageSizeOptions.SelectedValue);
            SetPagerIndex();

            CatalogNodeList.RepeatColumns = Cols;
            if (IsValidCategory())
            {
                //INITIALIZE THE CONTENT NODES
                _ContentNodes = new List<Product>();
                List<Product> visibleNodes = (List<Product>)ProductDataSource.LoadForCategory(true, this.CategoryId, false, true, SortResults.SelectedValue, _pageSize, (_HiddenPageIndex * _pageSize));

                // CUSTOM SORTING ON VOLUME PRICES
                if (SortResults.SelectedValue.Equals("Price ASC")) {
                    visibleNodes = visibleNodes.OrderBy(x => (x.VolumeDiscounts.Any() && x.VolumeDiscounts[0].Levels.Any()) ? x.VolumeDiscounts[0].Levels.First().DiscountAmount : x.Price).ThenBy(x => (x.VolumeDiscounts.Any() && x.VolumeDiscounts[0].Levels.Any()) ? x.VolumeDiscounts[0].Levels.Last().DiscountAmount : 0).ToList(); //Lowest-Highest
                } else if (SortResults.SelectedValue.Equals("Price DESC")) {
                    visibleNodes = visibleNodes.OrderByDescending(x => (x.VolumeDiscounts.Any() && x.VolumeDiscounts[0].Levels.Any()) ? x.VolumeDiscounts[0].Levels.First().DiscountAmount : x.Price).ThenByDescending(x => (x.VolumeDiscounts.Any() && x.VolumeDiscounts[0].Levels.Any()) ? x.VolumeDiscounts[0].Levels.Last().DiscountAmount : 0 ).ToList(); //Highest-Lowest
                }

                if (visibleNodes.Count > 0)
                {
                    _ContentNodes.AddRange(visibleNodes);

                    // DELAYED QUERIES TO EAGER LOAD RELATED DATA FOR PERFORMANCE BOOST
                    List<int> ids = visibleNodes.Select(p => p.Id).ToList();
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

                if (_pageSize == 0)
                    _pageSize = _ContentNodes.Count;

                int minimumPageSize = AlwaysConvert.ToInt(PageSizeOptions.Items[0].Value);
                PageSizePanel.Visible = _searchResultCount > minimumPageSize;

                //BIND PAGE
                BindPage();
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
                if (node.VolumeDiscounts.Count > 0 && node.VolumeDiscounts[0].Levels.Any()) {
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