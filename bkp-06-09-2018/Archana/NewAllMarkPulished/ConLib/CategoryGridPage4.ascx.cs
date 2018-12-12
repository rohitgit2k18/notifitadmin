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
    using AjaxControlToolkit;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DomainModel;
    using NHibernate.Transform;

    [Description("A category page that displays all contents in a grid format.  This page displays products, webpages, and links.")]
    public partial class CategoryGridPage4 : System.Web.UI.UserControl
    {
        private int _pageSize;
        private Category _category;
        private IList<CatalogNode> _contentNodes;
        private int _hiddenPageIndex;
        private int _lastPageIndex;
        
        private int _cols = 3;

        [Browsable(true), DefaultValue(3)]
        [Description("The number of columns to display")]
        public int Cols
        {
            get { return _cols; }
            set { _cols = value; }
        }

        private int _MaximumSummaryLength = 250; // LENGTH IN CHARACTERS
        /// <summary>
        /// Maximum characters to display for summary
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(250)]
        [Description("Maximum characters to display for summary")]
        public int MaximumSummaryLength
        {
            get { return _MaximumSummaryLength; }
            set { _MaximumSummaryLength = value; }
        }

        private string _pagingLinksLocation = "BOTTOM";
        /// <summary>
        /// Indicates where the paging links will be displayd, possible values are "TOP", "BOTTOM" and "TOPANDBOTTOM"
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("BOTTOM")]
        [Description("Indicates where the paging links will be displayd, possible values are \"TOP\", \"BOTTOM\" and \"TOPANDBOTTOM\".")]
        public string PagingLinksLocation
        {
            get { return _pagingLinksLocation; }
            set
            {
                // possible values are "TOP", "BOTTOM" and "TOPANDBOTTOM"
                String tmpLocation = value.ToUpperInvariant();
                if (tmpLocation == "TOP" || tmpLocation == "BOTTOM" || tmpLocation == "TOPANDBOTTOM")
                {
                    _pagingLinksLocation = tmpLocation;
                }
            }
        }

        private bool _displayBreadCrumbs = true;
        /// <summary>
        /// Indicates wheather the breadcrumbs should be displayed or not, default value is true
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates wheather the breadcrumbs should be displayed or not, default value is true.")]
        public bool DisplayBreadCrumbs
        {
            get { return _displayBreadCrumbs; }
            set { _displayBreadCrumbs = value; }
        }

        private string _defaultCaption = "Catalog";
        /// <summary>
        /// Caption text that will be shown when root category will be browsed
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Catalog")]
        [Description("Caption text that will be shown as caption when root category will be browsed.")]
        public string DefaultCaption
        {
            get { return _defaultCaption; }
            set { _defaultCaption = value; }
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

        private bool _showDescription = true;
        /// <summary>
        /// Indicates wheather the description should be displayed or not, default value is true
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates wheather the description should be displayed or not, default value is true.")]
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

        private void BindPage()
        {
            CategoryBreadCrumbs1.Visible = DisplayBreadCrumbs;
            CategoryBreadCrumbs1.CategoryId = this.CategoryId;

            //BIND THE DISPLAY ELEMENTS
            if (IsValidCategory())
            {
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
                    else CategoryDescriptionPanel.Visible = false;

                    if (!string.IsNullOrEmpty(_category.ThumbnailUrl))
                    {
                        CategoryThumbnail.ImageUrl = _category.ThumbnailUrl;
                    }
                }
                else
                {
                    // IF IT IS ROOT CATEGORY
                    Caption.Text = DefaultCaption;
                    CategoryDescriptionPanel.Visible = false;
                }
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
                _lastPageIndex = ((int)Math.Ceiling(((double)_contentNodes.Count / (double)_pageSize))) - 1;
                _PagingVarsInitialized = true;
            }
        }

        protected void Page_Init(object sender, System.EventArgs e)
        {
            Trace.Write(this.GetType().ToString(), "Load Begin");
            _category = CategoryDataSource.Load(this.CategoryId);
            //EXIT PROCESSING IF CATEGORY IS INVALID OR MARKED PRIVATE
            if (!IsValidCategory())
            {
                SearchResultsAjaxPanel.Visible = false;
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
                Trace.Write(this.GetType().ToString(), "Load Complete");
            }
        }

        private void BindSearchResultsPanel()
        {
            Trace.Write(this.GetType().ToString(), "Begin Bind Search Results");
            if (_contentNodes.Count > 0)
            {
                //SORT THE CATEGORIES ACCORDINGLY
                string sortExpression = SortResults.SelectedValue;
                if (!string.IsNullOrEmpty(sortExpression))
                {
                    string[] sortTokens = sortExpression.Split(" ".ToCharArray());
                    System.Web.UI.WebControls.SortDirection dir = (sortTokens[1] == "ASC" ? System.Web.UI.WebControls.SortDirection.Ascending : System.Web.UI.WebControls.SortDirection.Descending);
                    switch (sortTokens[0])
                    {
                        case "Featured":
                            _contentNodes.Sort(new FeaturedComparer(dir));
                            break;
                        case "Price":
                            _contentNodes.Sort(new PriceComparer(dir));
                            break;
                        case "Name":
                            _contentNodes.Sort(new NameComparer(dir));
                            break;
                        case "Manufacturer":
                            _contentNodes.Sort(new ManufacturerComparer(dir));
                            break;
                    }
                }

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
                phEmptyCategory.Visible = (_category != null && _category.CatalogNodes.Count == 0);
                phNoSearchResults.Visible = !phEmptyCategory.Visible;
            }
            //UPDATE AJAX PANEL
            SearchResultsAjaxPanel.Update();
            Trace.Write(this.GetType().ToString(), "End Bind Search Results");

        }

        protected void BindResultHeader()
        {
            //UPDATE THE RESULT INDEX MESSAGE
            int startRowIndex = (_pageSize * _hiddenPageIndex);
            int endRowIndex = startRowIndex + _pageSize;
            if (endRowIndex > _contentNodes.Count) endRowIndex = _contentNodes.Count;
            if (_contentNodes.Count == 0) startRowIndex = -1;
            IList<CatalogNode> bindNodes = new List<CatalogNode>();
            ResultIndexMessage.Text = string.Format(ResultIndexMessage.Text, (startRowIndex + 1), endRowIndex, _contentNodes.Count);
            for (int i = startRowIndex; i < endRowIndex; i++)
            {
                bindNodes.Add(_contentNodes[i]);
            }
            CatalogNodeList.DataSource = bindNodes;
            CatalogNodeList.DataBind();
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
                _hiddenPageIndex = AlwaysConvert.ToInt((string)e.CommandArgument);
                if (_hiddenPageIndex < 0) _hiddenPageIndex = 0;
                if (_hiddenPageIndex > _lastPageIndex) _hiddenPageIndex = _lastPageIndex;
                HiddenPageIndex.Value = _hiddenPageIndex.ToString();
            }
        }
        #endregion

        #region Comparers

        private class NameComparer : IComparer
        {
            System.Web.UI.WebControls.SortDirection _SortDirection;
            public NameComparer(System.Web.UI.WebControls.SortDirection sortDirection)
            {
                _SortDirection = sortDirection;
            }

            #region IComparer Members
            public int Compare(object x, object y)
            {
                if (_SortDirection == System.Web.UI.WebControls.SortDirection.Ascending)
                    return ((CatalogNode)x).Name.CompareTo(((CatalogNode)y).Name);
                return ((CatalogNode)y).Name.CompareTo(((CatalogNode)x).Name);
            }
            #endregion
        }

        private class PriceComparer : IComparer
        {
            System.Web.UI.WebControls.SortDirection _SortDirection;
            public PriceComparer(System.Web.UI.WebControls.SortDirection sortDirection)
            {
                _SortDirection = sortDirection;
            }

            #region IComparer Members
            public int Compare(object x, object y)
            {
                decimal xPrice = 0;
                decimal yPrice = 0;

                CatalogNode catalogNodeX = x as CatalogNode;
                CatalogNode catalogNodeY = y as CatalogNode;

                if (catalogNodeX.CatalogNodeType == CatalogNodeType.Product)
                {
                    xPrice = ((CommerceBuilder.Products.Product)catalogNodeX.ChildObject).Price;
                }

                if (catalogNodeY.CatalogNodeType == CatalogNodeType.Product)
                {
                    yPrice = ((CommerceBuilder.Products.Product)catalogNodeY.ChildObject).Price;
                }

                if (_SortDirection == System.Web.UI.WebControls.SortDirection.Ascending)
                    return (xPrice.CompareTo(yPrice));
                return (yPrice.CompareTo(xPrice));
            }
            #endregion
        }

        private class ManufacturerComparer : IComparer
        {
            System.Web.UI.WebControls.SortDirection _SortDirection;
            public ManufacturerComparer(System.Web.UI.WebControls.SortDirection sortDirection)
            {
                _SortDirection = sortDirection;
            }

            #region IComparer Members
            public int Compare(object x, object y)
            {
                string xMan = string.Empty;
                Product pX = null;
                if (((CatalogNode)x).CatalogNodeType == CatalogNodeType.Product)
                    pX = ((Product)((CatalogNode)x).ChildObject);
                if ((pX != null) && (pX.Manufacturer != null)) xMan = pX.Manufacturer.Name;
                string yMan = string.Empty;
                Product pY = null;
                if (((CatalogNode)y).CatalogNodeType == CatalogNodeType.Product)
                    pY = ((Product)((CatalogNode)y).ChildObject);
                if ((pY != null) && (pY.Manufacturer != null)) yMan = pY.Manufacturer.Name;
                if (_SortDirection == System.Web.UI.WebControls.SortDirection.Ascending)
                    return (xMan.CompareTo(yMan));
                return (yMan.CompareTo(xMan));
            }
            #endregion
        }

        /// <summary>
        /// sort by IsFeatured, OrderBy, Name
        /// </summary>
        private class FeaturedComparer : IComparer
        {
            System.Web.UI.WebControls.SortDirection _sortDirection;

            public FeaturedComparer(System.Web.UI.WebControls.SortDirection sortDirection)
            {
                _sortDirection = sortDirection;
            }

            public int Compare(object x, object y)
            {
                // cast the catalog nodes and prepare for sort
                CatalogNode catalogNodeX = (CatalogNode)x;
                CatalogNode catalogNodeY = (CatalogNode)y;
                bool sortAscending = _sortDirection == System.Web.UI.WebControls.SortDirection.Ascending;

                // categories come before all other items
                if (catalogNodeX.CatalogNodeType == CatalogNodeType.Category
                    && catalogNodeY.CatalogNodeType != CatalogNodeType.Category) return sortAscending ? -1 : 1;
                if (catalogNodeY.CatalogNodeType == CatalogNodeType.Category
                    && catalogNodeX.CatalogNodeType != CatalogNodeType.Category) return sortAscending ? 1 : -1;

                // primary sort by featured status
                // determine if X is featured
                bool isFeaturedX = false;
                if (catalogNodeX.CatalogNodeType == CatalogNodeType.Product)
                {
                    Product productX = catalogNodeX.ChildObject as Product;
                    if (productX != null) isFeaturedX = productX.IsFeatured;
                }

                // determine if Y is featured
                bool isFeaturedY = false;
                if (catalogNodeY.CatalogNodeType == CatalogNodeType.Product)
                {
                    Product productY = catalogNodeY.ChildObject as Product;
                    if (productY != null) isFeaturedY = productY.IsFeatured;
                }

                // return result of sort if not a match
                if (isFeaturedX != isFeaturedY)
                {
                    int comparison;
                    if (sortAscending) comparison = isFeaturedY.CompareTo(isFeaturedX);
                    else comparison = isFeaturedX.CompareTo(isFeaturedY);
                    return comparison;
                }

                // secondary sort by orderby
                if (catalogNodeX.OrderBy != catalogNodeY.OrderBy)
                {
                    int comparison;
                    if (sortAscending) comparison = catalogNodeX.OrderBy.CompareTo(catalogNodeY.OrderBy);
                    else comparison = catalogNodeY.OrderBy.CompareTo(catalogNodeX.OrderBy);
                    return comparison;
                }

                // tertiary sort by name
                if (sortAscending) return catalogNodeX.Name.CompareTo(catalogNodeY.Name);
                else return catalogNodeY.Name.CompareTo(catalogNodeX.Name);
            }
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
            CatalogNodeList.RepeatColumns = Cols;
            if (IsValidCategory())
            {
                // INITIALIZE THE CONTENT NODES
                _contentNodes = new List<CatalogNode>();
                IList<CatalogNode> visibleNodes;
                if (_category != null) visibleNodes = CatalogDataSource.LoadForCategory(_category.Id, true, true, 0, 0, string.Empty);
                else visibleNodes = CatalogDataSource.LoadForCategory(0, true, true, 0, 0, string.Empty);

                if (visibleNodes.Count > 0)
                {
                    // FETCH THE ASSOCIATED CATALOG ITEMS INTO ORM OBJECT GRAPH AND DISCARD RESULTS 
                    // THIS IS ESSENTIALLY FOR PERFORMANCE BOOST BY MINIMIZING NUMBER OF QUERIES
                    var productIds = visibleNodes.Where(n => n.CatalogNodeType == CatalogNodeType.Product)
                        .Select(n => n.CatalogNodeId)
                        .ToList<int>();

                    if (productIds.Count > 0 && productIds.Count < 415)
                    {
                        var futureQuery = NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(productIds)
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

                    var categoryIds = visibleNodes.Where(n => n.CatalogNodeType == CatalogNodeType.Category)
                        .Select(n => n.CatalogNodeId)
                        .ToList<int>();

                    if (categoryIds.Count > 0 && categoryIds.Count < 2000)
                    {
                        NHibernateHelper.QueryOver<Category>()
                            .AndRestrictionOn(c => c.Id).IsIn(categoryIds)
                            .List<Category>();
                    }

                    var webpageIds = visibleNodes.Where(n => n.CatalogNodeType == CatalogNodeType.Webpage)
                        .Select(n => n.CatalogNodeId)
                        .ToList<int>();

                    if (webpageIds.Count > 0 && webpageIds.Count < 2000)
                    {
                        NHibernateHelper.QueryOver<Webpage>()
                            .AndRestrictionOn(w => w.Id).IsIn(webpageIds)
                            .List<Webpage>();
                    }

                    var linkIds = visibleNodes.Where(n => n.CatalogNodeType == CatalogNodeType.Link)
                        .Select(n => n.CatalogNodeId)
                        .ToList<int>();

                    if (linkIds.Count > 0 && linkIds.Count < 2000)
                    {
                        NHibernateHelper.QueryOver<Link>()
                            .AndRestrictionOn(l => l.Id).IsIn(linkIds)
                            .List<Link>();
                    }
                }

                foreach (CatalogNode node in visibleNodes)
                {
                    if (node.CatalogNodeType == CatalogNodeType.Category)
                    {
                        // only add categories that have publicly visible content
                        int visibleCount = CatalogDataSource.CountForCategory(node.CatalogNodeId, true, true);
                        if (visibleCount > 0) _contentNodes.Add(node);
                    }
                    else
                    {
                        _contentNodes.Add(node);
                    }
                }

                if (_pageSize == 0)
                    _pageSize = _contentNodes.Count;
                int minimumPageSize = AlwaysConvert.ToInt(PageSizeOptions.Items[0].Value);
                PageSizePanel.Visible = _contentNodes.Count > minimumPageSize;

                // BIND PAGE
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
                if (_category == null) _category = CategoryDataSource.Load(this.CategoryId);
                if (_category != null && _category.Visibility != CatalogVisibility.Private) return true;
                else return false;
            }
        }

        protected Product GetProduct(Object dataItem)
        {
            CatalogNode node = (CatalogNode)dataItem;
            if (node.CatalogNodeType == CatalogNodeType.Product)
                return (Product)node.ChildObject;
            return null;
        }

        protected Webpage GetWebpage(Object dataItem)
        {
            CatalogNode node = (CatalogNode)dataItem;
            if (node.CatalogNodeType == CatalogNodeType.Webpage)
                return (Webpage)node.ChildObject;
            return null;
        }

        protected Link GetLink(Object dataItem)
        {
            CatalogNode node = (CatalogNode)dataItem;
            if (node.CatalogNodeType == CatalogNodeType.Link)
                return (Link)node.ChildObject;
            return null;
        }

        protected Category GetCategory(Object dataItem)
        {
            CatalogNode node = (CatalogNode)dataItem;
            if (node.CatalogNodeType == CatalogNodeType.Category)
                return (Category)node.ChildObject;
            return null;
        }

        protected string GetCategoryName(Object dateItem)
        {
            CatalogNode node = (CatalogNode)dateItem;
            if (node.CatalogNodeType == CatalogNodeType.Category)
                return (string)node.Name;
            return null;
        }

        protected string GetCategoryUrl(Object dateItem)
        {
            CatalogNode node = (CatalogNode)dateItem;
            if (node.CatalogNodeType == CatalogNodeType.Category)
                return (string)node.NavigateUrl;
            return null;
        }
    }
}