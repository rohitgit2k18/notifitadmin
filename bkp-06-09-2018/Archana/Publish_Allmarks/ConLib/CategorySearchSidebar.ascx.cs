namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.Collections.Specialized;
    using System.ComponentModel;
    using System.Web;
    using System.Web.UI.WebControls;
    using System.Linq;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Search;
    using CommerceBuilder.UI;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;
    using System.Web.UI.WebControls.WebParts;

    [Description("An ajax enabled search bar that displays products in a grid format. Allows customers to narrow and expand by category, manufacturer, and keyword in a search style interface.  This search bar must be used in conjunction with the Category Grid control.")]
    public partial class CategorySearchSidebar : System.Web.UI.UserControl, ISidebarControl
    {
        private IList<ManufacturerProductCount> _manufacturers;
        private const int _MaximumManufacturers = 4;

        private int _categoryId = 0;
        private int _manufacturerId = 0;
        private string _keyword = string.Empty;
        private bool _isCategoryPage = false;
        private bool _enableShopBy = true;
        private bool _showProductCount = true;
                
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("If true any shop by template fields will listed to narrow products listings")]
        public bool EnableShopBy
        {
            get { return _enableShopBy; }
            set { _enableShopBy = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("If true product counts will be shown")]
        public bool ShowProductCount
        {
            get { return _showProductCount; }
            set { _showProductCount = value; }
        }
        
        protected void Page_Init(object sender, EventArgs e)
        {
            // SET UP THE MINIMUM LENGTH VALIDATOR
            int minLength = AbleContext.Current.Store.Settings.MinimumSearchLength;
            KeywordValidator.MinimumLength = minLength;
            KeywordValidator.ErrorMessage = String.Format(KeywordValidator.ErrorMessage, minLength);

            _manufacturerId = AlwaysConvert.ToInt(Request.QueryString["m"]);
            _categoryId = AlwaysConvert.ToInt(Request.QueryString["c"]);

            // IF CONTROL IS ON CATEGORY PAGE
            if (_categoryId == 0)
            {
                _categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            }

            // CHECK IF PAGE IS CATEGORY PAGE
            _isCategoryPage = AbleCommerce.Code.PageHelper.GetCategoryId() > 0;

            _keyword = Server.UrlDecode(Request.QueryString["k"]);
            if (!string.IsNullOrEmpty(_keyword))
                _keyword = StringHelper.StripHtml(_keyword);

            string eventTarget = Request.Form["__EVENTTARGET"];
            if (!string.IsNullOrEmpty(eventTarget))
            {
                if (eventTarget.StartsWith(ShowAllManufacturers.UniqueID))
                {
                    ShowAllManufacturers.Visible = false;
                }

                if (eventTarget.StartsWith(KeywordButton.UniqueID))
                {
                    string kw = StringHelper.StripHtml(Request.Form[KeywordField.UniqueID]).Trim();
                    if (!string.IsNullOrEmpty(kw) && kw != _keyword && KeywordValidator.EvaluateIsValid(kw))
                    {
                        SearchHistory record = new SearchHistory(kw, AbleContext.Current.User);
                        record.Save();
                        Response.Redirect(ModifyQueryStringParameters("k", Server.UrlEncode(kw)));
                    }
                }
            }
            BootstrapCollaspe.Visible = PageHelper.IsResponsiveTheme(this.Page);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Trace.Write(this.GetType().ToString(), "Begin PreRender");
            //GET PRODUCT COUNTS FOR MANUFACTURERS THAT MEET SEARCH FILTER
            _manufacturers = ProductDataSource.AdvancedSearchCountByManufacturer(_keyword, this._categoryId, true, true, true, 0, 0, PageHelper.GetShopByChoices());
            
            //BIND THE EXPAND PANEL
            BindExpandResultPanel();

            //BIND THE NARROW BY CATEGORY PANEL
            BindNarrowByCategoryPanel();

            //BIND THE NARROW BY MANUFACTURER PANEL
            BindNarrowByManufacturerPanel();

            //BIND THE NARROW BY KEYWORD PANEL
            BindNarrowByKeywordPanel();

            BindShopByPanel();

            Trace.Write(this.GetType().ToString(), "End PreRender");
        }

        private void BindShopByPanel()
        {
            if (EnableShopBy)
            {
                IList<ShopByField> shopByFields = ProductDataSource.LoadShopByFields(_keyword, this._categoryId, _manufacturerId, true, true, true, 0, 0, false, PageHelper.GetShopByChoices());
                MerchantFieldRepeater.DataSource = shopByFields;
                MerchantFieldRepeater.DataBind();
                ShopByPanel.Visible = shopByFields.Count > 0;
            }
            else
            {
                ShopByPanel.Visible = false;
            }
        }

        protected void BindExpandResultPanel()
        {
            Trace.Write(this.GetType().ToString(), "Begin BindExpandResultPanel");

            //START WITH THE PANEL VISIBLE
            ExpandResultPanel.Visible = true;

            //BIND THE EXPAND CATEGORY LINKS
            IList<CatalogPathNode> currentPath = CatalogDataSource.GetPath(this._categoryId, false);

            if (_isCategoryPage && currentPath.Count > 0 && currentPath[0].CatalogNodeType == CatalogNodeType.Category)
            {
                currentPath.RemoveAt(0);
            }

            if (currentPath.Count > 0)
            {
                ExpandCategoryLinks.Visible = true;
                ExpandCategoryLinks.DataSource = currentPath;
                ExpandCategoryLinks.DataBind();
            }
            else
            {
                ExpandCategoryLinks.Visible = false;
            }

            //BIND THE EXPAND MANUFACTURER LINK
            Manufacturer m = ManufacturerDataSource.Load(this._manufacturerId);
            if (m != null)
            {
                ExpandManufacturerLink.Text = string.Format("{0} (X)", m.Name);
                ExpandManufacturerLink.NavigateUrl = RemoveQueryStringParameter("m");
                ExpandManufacturerListItem.Visible = true;
            }
            else
            {
                ExpandManufacturerListItem.Visible = false;
                ExpandManufacturerLink.NavigateUrl = "#";
            }

            //BIND THE EXPAND KEYWORD LINK
            if (!string.IsNullOrEmpty(this._keyword))
            {
                ExpandKeywordLink.Text = string.Format("Remove Keyword: {0}", Server.HtmlEncode(this._keyword));
                ExpandKeywordLink.NavigateUrl = RemoveQueryStringParameter("k");
                ExpandKeywordListItem.Visible = true;
            }
            else
            {
                ExpandKeywordListItem.Visible = false;
            }

            IList<ShopByChoice> choices = PageHelper.GetShopByChoices();
            if (choices != null && choices.Count > 0)
            {
                ExpandShopByLinks.DataSource = choices;
                ExpandShopByLinks.DataBind();
                ExpandShopByLinks.Visible = true;
            }
            else
            {
                ExpandShopByLinks.Visible = false;
            }
            

            //SET VISIBILITY OF EXPAND PANEL BASED ON CHILD CONTROLS VISIBILITY
            ExpandResultPanel.Visible = (ExpandCategoryLinks.Visible || ExpandManufacturerListItem.Visible || ExpandKeywordListItem.Visible) || ExpandShopByLinks.Visible;
            Trace.Write(this.GetType().ToString(), "End BindExpandResultPanel");
        }

        #region NARROW BY CATEGORY PANEL

        protected void BindNarrowByCategoryPanel()
        {
            Trace.Write(this.GetType().ToString(), "Begin BindNarrowByCategoryPanel");
            Trace.Write(this.GetType().ToString(), "Load All Child Categories");
            IList<Category> allCategories = CategoryDataSource.LoadForParent(this._categoryId, true);
            List<NarrowByCategoryData> populatedCategories = new List<NarrowByCategoryData>();
            foreach (Category category in allCategories)
            {
                Trace.Write(this.GetType().ToString(), "Count Items in " + category.Name);
                if (ShowProductCount)
                {
                    int totalProducts = ProductDataSource.AdvancedSearchCount(this._keyword, category.Id, this._manufacturerId, true, true, true, 0, 0, false, PageHelper.GetShopByChoices());
                    if (totalProducts > 0)
                    {
                        populatedCategories.Add(new NarrowByCategoryData(category.Id, category.Name, totalProducts));
                    }
                }
                else
                {
                    populatedCategories.Add(new NarrowByCategoryData(category.Id, category.Name, 0));
                }
            }
            Trace.Write(this.GetType().ToString(), "CheckBox Populated Categories");
            if (populatedCategories.Count > 0)
            {
                NarrowByCategoryPanel.Visible = true;
                NarrowByCategoryLinks.DataSource = populatedCategories;
                NarrowByCategoryLinks.DataBind();
            }
            else NarrowByCategoryPanel.Visible = false;
            Trace.Write(this.GetType().ToString(), "End BindNarrowByCategoryPanel");
        }

        protected void NarrowByCategoryLinks_ItemCreated(object source, DataListItemEventArgs e)
        {
            NarrowByCategoryData nbcd = (NarrowByCategoryData)e.Item.DataItem;
            if (nbcd != null)
            {
                HyperLink narrowByCategoryLink = (HyperLink)e.Item.FindControl("NarrowByCategoryLink");
                if (_isCategoryPage)
                {
                    Category category = CategoryDataSource.Load(nbcd.CategoryId);
                    narrowByCategoryLink.NavigateUrl = GetUrlWithCurrentQueryString(category.NavigateUrl);
                }
                else
                {
                    narrowByCategoryLink.NavigateUrl = ModifyQueryStringParameters("c", nbcd.CategoryId.ToString());
                }
            }
        }

        public class NarrowByCategoryData
        {
            private int _CategoryId;
            private string _Name;
            private int _ProductCount;
            public int CategoryId { get { return _CategoryId; } }
            public string Name { get { return _Name; } }
            public int ProductCount { get { return _ProductCount; } }
            public NarrowByCategoryData(int categoryId, string name, int productCount)
            {
                _CategoryId = categoryId;
                _Name = name;
                _ProductCount = productCount;
            }
        }

        #endregion

        #region EXPAND BY CATEGORY PANEL

        protected void ExpandCategoryLinks_ItemCreated(object source, RepeaterItemEventArgs e)
        {
            CatalogPathNode cpn = (CatalogPathNode)e.Item.DataItem;
            HyperLink expandByCategoryLink = (HyperLink)e.Item.FindControl("ExpandByCategoryLink");
            if (_isCategoryPage)
            {
                Category category = CategoryDataSource.Load(cpn.CategoryId);
                expandByCategoryLink.NavigateUrl = GetUrlWithCurrentQueryString(category.NavigateUrl);
            }
            else
            {
                if (cpn.CategoryId > 0)
                    expandByCategoryLink.NavigateUrl = ModifyQueryStringParameters("c", cpn.CategoryId.ToString());
                else
                    expandByCategoryLink.NavigateUrl = RemoveQueryStringParameter("c");
            }
        }

        #endregion

        #region NARROW BY MANUFACTURER PANEL

        protected void BindNarrowByManufacturerPanel()
        {
            Trace.Write(this.GetType().ToString(), "Begin BindNarrowByManufacturerPanel");
            if (!ExpandManufacturerLink.Visible)
            {
                NarrowByManufacturerPanel.Visible = true;
                if (_manufacturers.Count > _MaximumManufacturers)
                {
                    if (ShowAllManufacturers.Visible)
                    {
                        int count = _manufacturers.Count - _MaximumManufacturers;
                        for (int i = 0; i < count; i++)
                        {
                            if(_manufacturers.Count > _MaximumManufacturers)
                                _manufacturers.RemoveAt(_MaximumManufacturers);
                        }
                    }
                }
                else ShowAllManufacturers.Visible = false;
                ManufacturerList.DataSource = _manufacturers;
                ManufacturerList.DataBind();
                NarrowByManufacturerPanel.Visible = (ManufacturerList.Items.Count > 0);
            }
            else NarrowByManufacturerPanel.Visible = false;
            Trace.Write(this.GetType().ToString(), "End BindNarrowByManufacturerPanel");
        }

        protected void ManufacturerList_ItemCreated(object source, DataListItemEventArgs e)
        {
            ManufacturerProductCount m = (ManufacturerProductCount)e.Item.DataItem;
            HyperLink narrowByManufacturerLink = (HyperLink)e.Item.FindControl("NarrowByManufacturerLink");
            narrowByManufacturerLink.NavigateUrl = ModifyQueryStringParameters("m", m.ManufacturerId.ToString());
        }

        #endregion

        #region NARROW BY SHOPBY

        protected void FieldChoicesRepeater_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.DataItem != null)
            {
                ShopByChoice choice = (ShopByChoice)e.Item.DataItem;
                HyperLink narrowByChoiceLink = (HyperLink)e.Item.FindControl("ChoiceLink");
                if (narrowByChoiceLink != null)
                    narrowByChoiceLink.NavigateUrl = ModifyQueryStringParameters("shopby", choice.Id.ToString(), true);
            }
        }

        protected void ExpandShopByLinks_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.DataItem != null)
            {
                ShopByChoice choice = (ShopByChoice)e.Item.DataItem;
                HyperLink expandShopByLink = (HyperLink)e.Item.FindControl("ExpandShopByLink");
                if (expandShopByLink != null)
                    expandShopByLink.NavigateUrl = RemoveQueryStringParameter("shopby", choice.Id.ToString());
            }
        }

        #endregion

        #region NARROW BY KEYWORD PANEL

        protected void BindNarrowByKeywordPanel()
        {
            Trace.Write(this.GetType().ToString(), "Begin BindNarrowByKeywordPanel");
            if (string.IsNullOrEmpty(_keyword))
            {
                NarrowByKeywordPanel.Visible = true;
            }
            else
            {
                NarrowByKeywordPanel.Visible = false;
            }

            Trace.Write(this.GetType().ToString(), "End BindNarrowByKeywordPanel");
        }

        #endregion

        #region UTILITY METHODS

        private string GetUrlWithCurrentQueryString(string url)
        {
            string newUrl = url;
            string[] addressParts = Request.RawUrl.Split('?');
            string query = addressParts.Length > 1 ? addressParts[1] : string.Empty;
            if (!string.IsNullOrEmpty(query))
            {
                newUrl = string.Format("{0}?{1}", url, query);
            }

            return newUrl;
        }

        private string ModifyQueryStringParameters(string name, string value)
        {
            return ModifyQueryStringParameters(name, value, false);
        }

        private string ModifyQueryStringParameters(string name, string value, bool isList)
        {
            string[] addressParts = Request.RawUrl.Split('?');
            string query = addressParts.Length > 1 ? addressParts[1] : string.Empty;
            NameValueCollection nvc = HttpUtility.ParseQueryString(query);
            if (isList)
            { 
                string qparamvalue = nvc[name];
                List<string> values = new List<string>();
                if (!string.IsNullOrEmpty(qparamvalue))
                {
                    values = new List<string>(qparamvalue.Split(','));
                    int index = values.IndexOf(value);
                    if (index >= 0)
                        values[index] = value;
                    else
                        values.Add(value);
                }
                else
                {
                    values.Add(value);
                }

                nvc[name] = String.Join(",", values.ToArray());
            }
            else
            {
                nvc[name] = value;
            }

            return string.Format("{0}{1}", addressParts[0], ToQueryString(nvc));
        }

        private string RemoveQueryStringParameter(string name)
        {
            return RemoveQueryStringParameter(name, string.Empty);
        }

        private string RemoveQueryStringParameter(string name, string value)
        {
            string[] addressParts = Request.RawUrl.Split('?');
            string query = addressParts.Length > 1 ? addressParts[1] : string.Empty;
            NameValueCollection nvc = HttpUtility.ParseQueryString(query);
            if (!string.IsNullOrEmpty(value))
            {
                string qparamvalue = nvc[name];
                List<string> values = new List<string>();
                if (!string.IsNullOrEmpty(qparamvalue))
                {
                    values = new List<string>(qparamvalue.Split(','));
                    int index = values.IndexOf(value);
                    if (index >= 0)
                        values.RemoveAt(index);
                }

                if (values.Count == 0)
                    nvc.Remove(name);
                else
                    nvc[name] = String.Join(",", values.ToArray());
            }
            else
            {
                nvc.Remove(name);
            }
            return string.Format("{0}{1}", addressParts[0], ToQueryString(nvc));
        }

        private string ToQueryString(NameValueCollection nvc)
        {
            if (nvc == null || nvc.Count == 0)
                return string.Empty;
            return "?" + string.Join("&", Array.ConvertAll(nvc.AllKeys, key => string.Format("{0}={1}", HttpUtility.UrlEncode(key), HttpUtility.UrlEncode(nvc[key]))));
        }

        #endregion
    }
}