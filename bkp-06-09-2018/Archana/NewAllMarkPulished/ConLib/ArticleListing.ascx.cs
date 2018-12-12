namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using System.ComponentModel;
    using CommerceBuilder.Utility;

    [Description("A category page that displays webpages of a category with summary description in a row format.")]
    public partial class ArticleListing : System.Web.UI.UserControl
    {
        private Category _Category;
        private string _DefaultCaption = "Blog";
        private string _DefaultCategorySummary = "Welcome to our store.";        
        private int _currentPageIndex;
        private int _lastPageIndex;
        private int _defaultPageSize = 5;
        private int _pageSize = 5;
        private bool _displayBreadCrumbs = true;

        /// <summary>
        /// Enable or disable the displayof breadcrumbs.
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("Enable or disable the display of breadcrumbs.")]  
        public bool DisplayBreadCrumbs
        {
            get { return _displayBreadCrumbs; }
            set { _displayBreadCrumbs = value; }
        }
                
        /// <summary>
        /// Name that will be shown as caption when root category will be browsed
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Blog")]
        [Description("Caption text that will be shown as caption when root category will be browsed.")]        
        public string DefaultCaption
        {
            get { return _DefaultCaption; }
            set { _DefaultCaption = value; }
        }

        /// <summary>
        /// Summary that will be shown when root category will be browsed
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Welcome to our store blog.")]
        [Description("Summary that will be shown when root category will be browsed.")]
        public string DefaultCategorySummary
        {
            get { return _DefaultCategorySummary; }
            set { _DefaultCategorySummary = value; }
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

        private bool _showSummary = true;
        /// <summary>
        /// Indicates wheather the summary should be displayed or not, default value is true
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates wheather the summary should be displayed or not, default value is true.")]
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

        /// <summary>
        /// The maximum number of webpages to list at one page
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(5)]
        [Description("Number of blog posts to list at one page by default..")]
        public int DefaultPageSize
        {
            get
            {
                return _defaultPageSize;
            }
            set
            {
                _defaultPageSize = value;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // SET THE DEFAULT PAGE SIZE AND ADD A NEW OPTION BASED ON MaxItems parameter value if needed
            if (!Page.IsPostBack)
            {
                int selectedPageSize = AlwaysConvert.ToInt(PageSizeOptions.SelectedValue);
                if (this.DefaultPageSize > 0 && this.DefaultPageSize != selectedPageSize)
                {
                    PageSizeOptions.SelectedItem.Selected = false;

                    // check if an item with same value already exists
                    ListItem item = PageSizeOptions.Items.FindByValue(this.DefaultPageSize.ToString());
                    if (item == null)
                    {
                        item = new ListItem(this.DefaultPageSize + " Items", this.DefaultPageSize.ToString());
                        PageSizeOptions.Items.Add(item);
                    }

                    item.Selected = true;
                }
            }
        }

        private void InitializePageSize()
        {
            string eventTarget = Request["__EVENTTARGET"];            
            if (!Page.IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["ps"]))
                    _pageSize = AlwaysConvert.ToInt(Request.QueryString["ps"]);
                else _pageSize = this.DefaultPageSize;
            }
            else
            {
                if ((string.IsNullOrEmpty(eventTarget) || !eventTarget.EndsWith("PageSizeOptions")) && 
                    !string.IsNullOrEmpty(Request.QueryString["ps"]))
                    _pageSize = AlwaysConvert.ToInt(Request.QueryString["ps"]);
                else _pageSize = AlwaysConvert.ToInt(PageSizeOptions.SelectedValue);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // SET THE DEFAULT PAGE SIZE AND ADD A NEW OPTION BASED ON MaxItems parameter value if needed
            if (!Page.IsPostBack)
            {
                CategoryBreadCrumbs1.Visible = this.DisplayBreadCrumbs;
            }

            InitializePageSize();

            if (IsValidCategory())
            {
                string eventTarget = Request["__EVENTTARGET"];
                if (string.IsNullOrEmpty(eventTarget) || !eventTarget.EndsWith("PageSizeOptions"))
                {
                    PageSizeOptions.ClearSelection();
                    ListItem item = PageSizeOptions.Items.FindByValue(_pageSize.ToString());
                    if (item != null) item.Selected = true;
                }

                if (string.IsNullOrEmpty(eventTarget) || !eventTarget.EndsWith("SortResults"))
                {
                    string sortOption = Request.QueryString["s"];
                    if (!string.IsNullOrEmpty(sortOption))
                    {
                        SortResults.ClearSelection();
                        ListItem item = SortResults.Items.OfType<ListItem>().FirstOrDefault(x => string.Compare(x.Value, sortOption, StringComparison.InvariantCultureIgnoreCase) == 0);
                        if (item != null) item.Selected = true;
                    }
                }

                if (!string.IsNullOrEmpty(eventTarget))
                {
                    if (eventTarget.EndsWith("PageSizeOptions") || eventTarget.EndsWith("SortResults"))
                    {
                        string url = Request.RawUrl;
                        if (url.Contains("?"))
                            url = Request.RawUrl.Substring(0, Request.RawUrl.IndexOf("?"));
                        url += "?s=" + SortResults.SelectedValue;
                        url += "&ps=" + _pageSize.ToString();
                        Response.Redirect(url);
                    }
                }

                
                Caption.Text = this.DefaultCaption;

                if (_Category != null)
                {
                    // use category name if no default name is specified
                    if (string.IsNullOrEmpty(Caption.Text)) Caption.Text = _Category.Name;

                    CategoryBreadCrumbs1.CategoryId = this.CategoryId;

                    if (!string.IsNullOrEmpty(_Category.Summary) && ShowSummary)
                    {
                        CategorySummary.Text = _Category.Summary;
                    }  

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
                    // IT IS ROOT CATEGORY
                    CategoryBreadCrumbs1.CategoryId = this.CategoryId;
                    if (ShowSummary)
                    {
                        CategorySummary.Text = DefaultCategorySummary;
                    }
                }

                if (_Category != null)
                {
                    int count = WebpageDataSource.CountForCategory(_Category.Id, true, true);
                    if (count > 0)
                    {
                        _currentPageIndex = AlwaysConvert.ToInt(Request.QueryString["p"]);
                        if (_pageSize == 0) _lastPageIndex = 0;
                        else _lastPageIndex = ((int)Math.Ceiling(((double)count / (double)_pageSize))) - 1;

                        CatalogNodeList.DataSource = WebpageDataSource.LoadForCategory(_Category.Id, true, true, SortResults.SelectedValue, _pageSize, (_currentPageIndex * _pageSize));
                        CatalogNodeList.DataBind();
                        int startRowIndex = (_pageSize * _currentPageIndex);
                        int endRowIndex = startRowIndex + _pageSize;
                        if (endRowIndex > count || endRowIndex == 0) endRowIndex = count;
                        if (count == 0) startRowIndex = -1;
                        ResultIndexMessage.Text = string.Format(ResultIndexMessage.Text, (startRowIndex + 1), endRowIndex, count);
                        ResultIndexMessage.Text = string.Format(ResultIndexMessage.Text, (startRowIndex + 1), endRowIndex, count);
                        BindPagingControls();
                    }
                    else
                    {
                        phEmptyCategory.Visible = true;
                    }

                    AbleCommerce.Code.PageVisitHelper.RegisterPageVisit(_Category.Id, CatalogNodeType.Category, _Category.Name);
                }
            }
        }

        protected void CatalogNodeList_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                //GENERATE TEMPLATE WITH HTML CONTROLS
                //TO OPTIMIZE OUTPUT SIZE
                PlaceHolder itemTemplate1 = (PlaceHolder)e.Item.FindControl("phItemTemplate1");

                Webpage webpage = (Webpage)e.Item.DataItem;

                string catalogNodeUrl = this.Page.ResolveUrl(webpage.NavigateUrl);
                string target = "_self";

                Panel thumbnailPanel = (Panel)e.Item.FindControl("ThumbnailPanel");
                HyperLink itemThumbnailLink = (HyperLink)e.Item.FindControl("ItemThumbnailLink");
                Image itemThumbnail = (Image)e.Item.FindControl("ItemThumbnail");

                itemThumbnailLink.NavigateUrl = webpage.NavigateUrl;
                itemThumbnailLink.Target = target;

                if (!string.IsNullOrEmpty(webpage.ThumbnailUrl))
                {
                    itemThumbnail.ImageUrl = webpage.ThumbnailUrl;
                    itemThumbnail.AlternateText = string.IsNullOrEmpty(webpage.ThumbnailAltText) ? webpage.Name : webpage.ThumbnailAltText;
                }
                else
                {
                    thumbnailPanel.Visible = false;
                }

                HyperLink itemName = (HyperLink)e.Item.FindControl("ItemName");
                itemName.NavigateUrl = this.ShowDescription ? string.Empty : webpage.NavigateUrl;
                itemName.Target = target;
                itemName.Text = webpage.Name;

                if (this.ShowDescription)
                {
                    Label ItemDescription = (Label)e.Item.FindControl("ItemDescription");
                    ItemDescription.Text = webpage.Description;
                }

                Label itemSummary = (Label)e.Item.FindControl("ItemSummary");
                if (this.ShowSummary)
                {
                    string readMoreLink = string.Empty;
                    if (!this.ShowDescription && !string.IsNullOrWhiteSpace(webpage.Description)) readMoreLink = string.Format(" <a href=\"{0}\" target=\"{1}\">read more...</a>", Page.ResolveUrl(webpage.NavigateUrl), target);
                    itemSummary.Text = webpage.Summary + readMoreLink;
                }

                // hide the published label if both date and author is not provided
                if(webpage.PublishDate == DateTime.MinValue && string.IsNullOrWhiteSpace(webpage.PublishedBy))
                {
                    Panel publishInfoPanel = (Panel)e.Item.FindControl("PublishInfo");
                    publishInfoPanel.Visible = false;
                }
                else
                {
                    Label publishInfoLabel = (Label)e.Item.FindControl("PublishInfoLabel");
                    string publishedBy = string.IsNullOrWhiteSpace(webpage.PublishedBy) ? string.Empty : " by " + webpage.PublishedBy;
                    string publishedDate = webpage.PublishDate == DateTime.MinValue ? string.Empty : " " + string.Format("{0:D}", webpage.PublishDate);
                    publishInfoLabel.Text = string.Format(publishInfoLabel.Text, publishedDate, publishedBy);
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

        protected void BindPagingControls()
        {
            if (_lastPageIndex > 0)
            {
                PagerPanel.Visible = (PagingLinksLocation == "BOTTOM" || PagingLinksLocation == "TOPANDBOTTOM");
                PagerPanelTop.Visible = (PagingLinksLocation == "TOP" || PagingLinksLocation == "TOPANDBOTTOM");

                float tempIndex = ((float)_currentPageIndex / 10) * 10;
                int currentPagerIndex = (int)tempIndex;

                int totalPages = currentPagerIndex + 1 + _pageSize; // ADD ONE BECAUSE IT IS A ZERO BASED INDEX
                if (totalPages > (_lastPageIndex + 1)) totalPages = (_lastPageIndex + 1);

                string baseUrl;
                if (_Category != null)
                {
                    baseUrl = this.Page.ResolveUrl(_Category.NavigateUrl) + "?";
                }
                else
                {
                    baseUrl = this.Page.ResolveUrl(Request.Url.AbsolutePath) + "?";
                }

                string s = Request.QueryString["s"];
                if (!string.IsNullOrEmpty(s))
                {
                    baseUrl = baseUrl + "s=" + s + "&";
                }
                                
                string ps = Request.QueryString["ps"];
                if (string.IsNullOrEmpty(ps)) ps = _pageSize.ToString();
                if (!string.IsNullOrEmpty(ps))
                {
                    baseUrl = baseUrl + "ps=" + ps + "&";
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
    }
}