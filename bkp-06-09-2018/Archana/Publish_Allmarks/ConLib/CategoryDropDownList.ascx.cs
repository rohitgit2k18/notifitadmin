namespace AbleCommerce.ConLib
{
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Utility;

    [Description("Displays a drop down list of categories in your store.")]
    public partial class CategoryDropDownList : System.Web.UI.UserControl
    {
        string _HomeText = "Home";
        [Browsable(true), DefaultValue("Home")]
        [Description("The text to use for the top level item that directs to your home page.")]
        public string HomeText
        {
            get { return _HomeText; }
            set { _HomeText = value; }
        }

        string _Prefix = " . . ";
        [Browsable(true), DefaultValue(" . . ")]
        [Description("The text to place before a subdirectory, repeated for each category level.")]
        public string Prefix
        {
            get { return _Prefix; }
            set { _Prefix = value; }
        }

        int _Levels = 0;
        [Browsable(true), DefaultValue(0)]
        [Description("The maximum number of category levels to include in the list. Set to 0 for all levels.")]
        public int Levels
        {
            get { return _Levels; }
            set { _Levels = value; }
        }

        bool _AutoPostBack = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true, the page will automatically redirect to the category when selected. If false, the button must be clicked to navigate to the selected category.")]
        public bool AutoPostBack
        {
            get { return _AutoPostBack; }
            set { _AutoPostBack = value; }
        }

        string _GoButtonText = "";
        [Browsable(true), DefaultValue("")]
        [Description("The text for the button that when clicked, will display the selected category. If you set this to an empty string, the button will be hidden.")]
        public string GoButtonText
        {
            get { return _GoButtonText; }
            set { _GoButtonText = value; }
        }
        
        int _CacheDuration = 1440;
        [Browsable(true), DefaultValue(1440)]
        [Description("Number of minutes the category list will remain cached in memory. Set to 0 to disable caching.")]
        public int CacheDuration
        {
            get { return _CacheDuration; }
            set { _CacheDuration = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            InitializeCategoryList();
            CategoryList.AutoPostBack = _AutoPostBack;
            if (string.IsNullOrEmpty(_GoButtonText))
            {
                GoButton.Visible = false;
            }
            else
            {
                GoButton.Text = _GoButtonText;
            }
        }

        private void InitializeCategoryList()
        {
            //ADD TOP LEVEL ITEM FOR ROOT
            ListItem item = new ListItem(_HomeText, "0");
            CategoryList.Items.Add(item);
            //ADD CATEGORY TREE
            ListItem[] categoryItems = GetCategoryListItems();
            if (categoryItems != null) CategoryList.Items.AddRange(categoryItems);
            //SELECT THE CORRECT INITIAL CATEGORY
            int categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            ListItem selected = CategoryList.Items.FindByValue(categoryId.ToString());
            if (selected != null) CategoryList.SelectedIndex = CategoryList.Items.IndexOf(selected);
        }

        private ListItem[] GetCategoryListItems()
        {
            string cacheKey = "68B9A666401D411E8FEFC9BA96CB2FF2";
            ListItem[] categoryList = null;
            if (_CacheDuration > 0)
            {
                //LOOK IN CACHE FOR LIST ITEMS
                CategoryListCacheWrapper categoryListWrapper = Cache.Get(cacheKey) as CategoryListCacheWrapper;
                if ((categoryListWrapper != null) && (categoryListWrapper.Prefix == _Prefix) && (categoryListWrapper.Levels == Levels))
                {
                    categoryList = categoryListWrapper.GetCategoryList();
                }
            }
            if (categoryList == null)
            {
                int startLevel = (_HomeText.Length > 0 ? 1 : 0);
                categoryList = GetCategoryListItemsRecursive(0, startLevel);
                if (_CacheDuration > 0)
                {
                    CategoryListCacheWrapper categoryListWrapper = new CategoryListCacheWrapper(_Prefix, _Levels, categoryList);
                    Cache.Insert(cacheKey, categoryListWrapper, null, DateTime.Now.AddMinutes(_CacheDuration), System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.High, null);
                }
            }
            return categoryList;
        }

        private ListItem[] GetCategoryListItemsRecursive(int categoryId, int level)
        {
            List<ListItem> subcatList = new List<ListItem>();
            IList<Category> subcategories = CategoryDataSource.LoadForParent(categoryId, true);
            foreach (Category subcat in subcategories)
            {
                string prefix = new string(' ', level).Replace(" ", Server.HtmlDecode(_Prefix));
                subcatList.Add(new ListItem(prefix + subcat.Name, subcat.Id.ToString()));
                ListItem[] subcatItems = GetCategoryListItemsRecursive(subcat.Id, level + 1);
                if (subcatItems != null) subcatList.AddRange(subcatItems);
            }
            if (subcatList.Count == 0) return null;
            return subcatList.ToArray();
        }

        private class CategoryListCacheWrapper
        {
            private string _Prefix;
            public string Prefix { get { return _Prefix; } }
            private int _Levels;
            public int Levels { get { return _Levels; } }
            public ListItem[] _CategoryList;
            public CategoryListCacheWrapper(string prefix, int levels, ListItem[] categoryList)
            {
                _Prefix = prefix;
                _Levels = levels;
                _CategoryList = categoryList;
            }
            public ListItem[] GetCategoryList()
            {
                return _CategoryList;
            }
        }

        protected void CategoryList_Changed(object sender, EventArgs e)
        {
            CategoryRedir();
        }

        protected void GoButton_Click(object sender, EventArgs e)
        {
            CategoryRedir();
        }

        private void CategoryRedir()
        {
            int categoryId = AlwaysConvert.ToInt(CategoryList.SelectedValue);
            if (categoryId == 0) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl());
            Category category = CategoryDataSource.Load(categoryId);
            if (category != null) Response.Redirect(category.NavigateUrl);
        }
    }
}