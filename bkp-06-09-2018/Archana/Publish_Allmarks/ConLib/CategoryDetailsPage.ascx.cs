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

    [Description("A category page that displays all contents of a category with summary description in a row format.  This page displays products, webpages, and links.")]
    public partial class CategoryDetailsPage : System.Web.UI.UserControl
    {
        private Category _Category;
        private string _DefaultCaption = "Catalog";
        private string _DefaultCategorySummary = "Welcome to our store.";
        private int _pageSize = 12;
        private int _currentPageIndex;
        private int _lastPageIndex;
                
        /// <summary>
        /// Name that will be shown as caption when root category will be browsed
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Catalog")]
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
        [Browsable(true), DefaultValue("Welcome to our store.")]
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsValidCategory())
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

                if (string.IsNullOrEmpty(eventTarget) || !eventTarget.EndsWith("SortResults"))
                {
                    string sortOption = Request.QueryString["s"];
                    if (!string.IsNullOrEmpty(sortOption))
                    {
                        SortResults.ClearSelection();
                        ListItem item = SortResults.Items.OfType<ListItem>().SingleOrDefault(x => string.Compare(x.Value, sortOption, StringComparison.InvariantCultureIgnoreCase) == 0);
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
                        url += "&ps=" + PageSizeOptions.SelectedValue;
                        Response.Redirect(url);
                    }
                }
                
                if (_Category != null)
                {
                    CategoryBreadCrumbs1.CategoryId = this.CategoryId;
                    Caption.Text = _Category.Name;

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
                    Caption.Text = DefaultCaption;
                    if (ShowSummary)
                    {
                        CategorySummary.Text = DefaultCategorySummary;
                    }
                }

                if (_Category != null)
                {
                    int count = CatalogDataSource.CountForCategory(_Category.Id, true, true);
                    if (count > 0)
                    {
                        _currentPageIndex = AlwaysConvert.ToInt(Request.QueryString["p"]);
                        _pageSize = AlwaysConvert.ToInt(PageSizeOptions.SelectedValue);
                        _lastPageIndex = ((int)Math.Ceiling(((double)count / (double)_pageSize))) - 1;

                        CatalogNodeList.DataSource = CatalogDataSource.LoadForCategory(_Category.Id, true, true, _pageSize, (_currentPageIndex * _pageSize), SortResults.SelectedValue);
                        CatalogNodeList.DataBind();
                        int startRowIndex = (_pageSize * _currentPageIndex);
                        int endRowIndex = startRowIndex + _pageSize;
                        if (endRowIndex > count) endRowIndex = count;
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

                CatalogNode catalogNode = (CatalogNode)e.Item.DataItem;

                string catalogNodeUrl = this.Page.ResolveUrl(catalogNode.NavigateUrl);
                string target = "_self";
                if (catalogNode.CatalogNodeType == CatalogNodeType.Link)
                    target = ((Link)catalogNode.ChildObject).TargetWindow;

                Panel thumbnailPanel = (Panel)e.Item.FindControl("ThumbnailPanel");
                HyperLink itemThumbnailLink = (HyperLink)e.Item.FindControl("ItemThumbnailLink");
                Image itemThumbnail = (Image)e.Item.FindControl("ItemThumbnail");

                itemThumbnailLink.NavigateUrl = catalogNode.NavigateUrl;
                itemThumbnailLink.Target = target;

                if (!string.IsNullOrEmpty(catalogNode.ThumbnailUrl))
                {
                    itemThumbnail.ImageUrl = catalogNode.ThumbnailUrl;
                    itemThumbnail.AlternateText = string.IsNullOrEmpty(catalogNode.ThumbnailAltText) ? catalogNode.Name : catalogNode.ThumbnailAltText;
                }
                else
                {
                    Image NoThumbnail = (Image)e.Item.FindControl("NoThumbnail");
                    itemThumbnail.Visible = false;
                    NoThumbnail.Visible = true;
                }

                HyperLink itemName = (HyperLink)e.Item.FindControl("ItemName");
                itemName.NavigateUrl = catalogNode.NavigateUrl;
                itemName.Target = target;
                itemName.Text = catalogNode.Name;

                Label itemSummary = (Label)e.Item.FindControl("ItemSummary");
                if(ShowSummary)
                    itemSummary.Text = catalogNode.Summary;
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