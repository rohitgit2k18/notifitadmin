using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using AbleCommerce.Code;
using CommerceBuilder.Common;
using CommerceBuilder.Products;
using CommerceBuilder.Search;
using CommerceBuilder.Stores;
using CommerceBuilder.Utility;
using CommerceBuilder.Users;
using CommerceBuilder.UI;
using System.Text;
using CommerceBuilder.Catalog;
using CommerceBuilder.DomainModel;
using System.Linq;

namespace AbleCommerce.Mobile
{
    public partial class Search : AbleCommercePage
    {
        private int _pageSize = AbleContext.Current.Store.Settings.MobileStoreCatalogPageSize;
        private int _categoryId = 0;
        private int _manufacturerId = 0;
        private string _keywords = string.Empty;
        private int _hiddenPageIndex;
        private int _searchResultCount;
        private int _lastPageIndex;
        
        protected void Page_Init(object sender, System.EventArgs e)
        {
            _categoryId = AlwaysConvert.ToInt(Request.QueryString["c"]);
            _manufacturerId = AlwaysConvert.ToInt(Request.QueryString["m"]);

            int minLength = AbleContext.Current.Store.Settings.MinimumSearchLength;
            KeywordValidator.MinimumLength = minLength;
            KeywordValidator.ErrorMessage = String.Format("Search keyword must be at least {0} characters in length excluding spaces and wildcards.", minLength);
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            string kwords = KeywordField.Text;
            if (string.IsNullOrEmpty(kwords)) kwords = HiddenSearchKeywords.Value;
            if (Page.IsPostBack && !string.IsNullOrEmpty(kwords))
            {
                _keywords = StringHelper.StripHtml(kwords).Trim();
                HiddenSearchKeywords.Value = _keywords;
            }
            else
            {
                _keywords = Server.UrlDecode(Request.QueryString["k"]);
                if (!string.IsNullOrEmpty(_keywords))
                    _keywords = StringHelper.StripHtml(_keywords).Trim();
            }

            if (HasSearchCriteria())
            {
                //has something to search
                ResultsPanel.Visible = true;
                NoSearchCriteriaPanel.Visible = false;
                ResultTermMessage.Visible = true;

                if (!Page.IsPostBack)
                {
                    //initialize search sorting and paging criteria based on query string parameters
                    HiddenPageIndex.Value = AlwaysConvert.ToInt(Request.QueryString["p"]).ToString();
                    string tempSort = Request.QueryString["s"];
                    if (!string.IsNullOrEmpty(tempSort))
                    {
                        ListItem item = SortResults.Items.FindByValue(tempSort);
                        if (item != null) item.Selected = true;
                    }
                }

                //initialize paging vars
                _hiddenPageIndex = AlwaysConvert.ToInt(HiddenPageIndex.Value);
                _searchResultCount = ProductDataSource.AdvancedSearchCount(_keywords, _categoryId, _manufacturerId, true, true, true, 0, 0);
                _lastPageIndex = ((int)Math.Ceiling(((double)_searchResultCount / (double)_pageSize))) - 1;
                if (_hiddenPageIndex > _lastPageIndex) _hiddenPageIndex = _lastPageIndex;
                if (_pageSize == 0) _pageSize = _searchResultCount;
                
                //update the header search criteria message
                StringBuilder sb = new StringBuilder();
                if (!string.IsNullOrEmpty(_keywords)) sb.Append(string.Format(" for '{0}'", _keywords));
                Category category = CategoryDataSource.Load(_categoryId);
                if (category != null)
                {
                    sb.Append(string.Format(" in '{0}'", category.Name));
                }
                Manufacturer manufacturer = ManufacturerDataSource.Load(_manufacturerId);
                if (manufacturer != null)
                {
                    sb.Append(string.Format(" in '{0}'", manufacturer.Name));
                }
                ResultTermMessage.Text = string.Format(ResultTermMessage.Text, sb.ToString());
                
                //bind search results
                int startIndex = (_hiddenPageIndex * _pageSize);
                if (startIndex < 0) startIndex = 0;
                var products = ProductDataSource.AdvancedSearch(_keywords, _categoryId, _manufacturerId, true, true, true, 0, 0, _pageSize, startIndex, SortResults.SelectedValue);
                
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

                ProductList.DataSource = products;
                ProductList.DataBind();
                
                NoResultsPanel.Visible = _searchResultCount == 0;
                SortPanel.Visible = _searchResultCount > 1;

                //bind paging
                int totalPages;
                if (_pageSize <= 0) totalPages = 1;
                else totalPages = (int)Math.Ceiling((double)_searchResultCount / _pageSize);

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
            else
            {
                //no search criteria
                ResultsPanel.Visible = false;
                NoSearchCriteriaPanel.Visible = true;
                ResultTermMessage.Visible = false;
            }
        }

        protected void GoButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(_keywords))
            {
                Response.Redirect("Search.aspx?k=" + _keywords);
            }
            Response.Redirect("Search.aspx");
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

            return baseurl;
        }

        protected bool HasSearchCriteria()
        {
            if (!string.IsNullOrEmpty(_keywords)) return true;
            if (_manufacturerId != 0) return true;
            if (_categoryId != 0) return true;
            return false;
        }

        protected void SortResults_SelectedIndexChanged(object sender, EventArgs e)
        {
            //gets updated automatically in Page_Load
        }


        protected void Page_PreRender(object sender, EventArgs e)
        {
            KeywordField.Text = _keywords;
        }
    }
}
