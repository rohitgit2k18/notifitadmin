namespace AbleCommerce.Mobile
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.UI;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class CategoryPage : AbleCommercePage
    {
        private int _pageSize = AbleContext.Current.Store.Settings.MobileStoreCatalogPageSize;
        private Category _category;
        private int _hiddenPageIndex;
        private int _productCount;
        private int _lastPageIndex;
        private int _categoryId;

        protected void Page_Init(object sender, EventArgs e)
        {
            _categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            _category = CategoryDataSource.Load(this._categoryId);
            if (_category != null)
            {
                if ((_category.Visibility == CatalogVisibility.Private) &&
                    (!AbleContext.Current.User.IsInRole(Role.CatalogAdminRoles)))
                {
                    Response.Redirect(NavigationHelper.GetMobileStoreUrl("default.sapx"));
                }
            }
            else NavigationHelper.Trigger404(Response, "Invalid Category");

            //REGISTER THE PAGEVISIT
            PageVisitHelper.RegisterPageVisit(_category.Id, CatalogNodeType.Category, _category.Name);
            PageHelper.BindMetaTags(this, _category);
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            Page.Title = string.IsNullOrEmpty(_category.Title) ? _category.Name : _category.Title;
            Caption.Text = _category.Name;

            if (!Page.IsPostBack)
            {
                //initialize search sorting and paging criteria based on query string parameters
                HiddenPageIndex.Value = AlwaysConvert.ToInt(Request.QueryString["p"]).ToString();
                string tempSort = Request.QueryString["s"];
                if (!string.IsNullOrEmpty(tempSort))
                {
                    ListItem item = SortResults.Items.OfType<ListItem>().SingleOrDefault(x => string.Compare(x.Value, tempSort, StringComparison.InvariantCultureIgnoreCase) == 0);
                    if (item != null) item.Selected = true;
                }
            }

            //initialize paging vars
            _hiddenPageIndex = AlwaysConvert.ToInt(HiddenPageIndex.Value);
            _productCount = ProductDataSource.CountForCategory(_categoryId, false, true);
            _lastPageIndex = ((int)Math.Ceiling(((double)_productCount / (double)_pageSize))) - 1;
            if (_hiddenPageIndex > _lastPageIndex) _hiddenPageIndex = _lastPageIndex;
            if (_pageSize == 0) _pageSize = _productCount;

            //bind products
            ProductList.DataSource = ProductDataSource.LoadForCategory(true, _categoryId, false, true, SortResults.SelectedValue, _pageSize, (_hiddenPageIndex * _pageSize));
            ProductList.DataBind();

            ProductsPanel.Visible = _productCount > 0;
            if (_productCount == 0 && CategoryDataSource.CountForParent(_categoryId, true) == 0) NoResultPanel.Visible = true;

            //bind paging
            int totalPages;
            if (_pageSize <= 0) totalPages = 1;
            else totalPages = (int)Math.Ceiling((double)_productCount / _pageSize);

            if (_lastPageIndex > 0)
            {
                PagerPanel.Visible = true;
                PagerPanelTop.Visible = true;
                List<PagerLinkData> pagerLinkData = GetPagingLinkData(totalPages);
                PagerControls.DataSource = pagerLinkData;
                PagerControls.DataBind();
                PagerControlsTop.DataSource = pagerLinkData;
                PagerControlsTop.DataBind();

                PagerMessageTop.Text = string.Format("Page {0} of {1}", (_hiddenPageIndex + 1), totalPages);
                PagerMessageBottom.Text = string.Format("Page {0} of {1}", (_hiddenPageIndex + 1), totalPages);
            }
            else
            {
                PagerPanel.Visible = false;
                PagerPanelTop.Visible = false;
            }
        }

        protected List<PagerLinkData> GetPagingLinkData(int totalPages)
        {
            float tempIndex = ((float)_hiddenPageIndex / 10) * 10;
            int currentPagerIndex = (int)tempIndex;

            string baseurl = GetPagingBaseUrl();

            List<PagerLinkData> pagerLinkData = AbleCommerce.Code.NavigationHelper.GetPaginationLinks(currentPagerIndex, totalPages, baseurl);

            return pagerLinkData;
        }

        protected string GetPagingBaseUrl()
        {
            string baseUrl = string.Empty;
            if (_category != null)
            {
                baseUrl = this.Page.ResolveUrl(_category.NavigateUrl) + "?";
            }
            else if (_categoryId == 0)
            {
                baseUrl = this.Page.ResolveUrl(Request.Url.AbsolutePath) + "?";
            }
            else
            {
                baseUrl = AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page, "Category.aspx?");
            }

            if (!String.IsNullOrEmpty(SortResults.SelectedValue))
            {
                baseUrl += "s=" + SortResults.SelectedValue.Replace(" ", "+") + "&amp;";
            }

            return baseUrl;
        }
    }
}