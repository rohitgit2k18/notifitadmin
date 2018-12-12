using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Caching;
using System.Text;
using CommerceBuilder.Catalog;
using System.ComponentModel;
using System.Web.UI.WebControls.WebParts;
using CommerceBuilder.Common;

namespace AbleCommerce.ConLib
{
    [Description("A simple category menu suitable for displaying in sidebar. It which shows the nested categories under the selected category.")]
    public partial class CategoryMenu : System.Web.UI.UserControl, CommerceBuilder.UI.ISidebarControl
    {
        private string _HeaderText;
        string _CacheKey = "CategoryMenuContents";

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Categories")]
        [Description("Title Text for the header.")]
        public string HeaderText
        {
            get { return _HeaderText; }
            set { _HeaderText = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(HeaderText)) phCaption.Text = HeaderText;
            BindMenu();
            phReload.Visible = AbleContext.Current.User.IsAdmin;
        }

        private void BindMenu()
        {
            string menuContent = (string)Cache[_CacheKey];
            if (string.IsNullOrEmpty(menuContent))
            {
                // load xml menu
                menuContent = GenerateMenu(0, 1);
                Cache.Add(_CacheKey, menuContent, null, Cache.NoAbsoluteExpiration, Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
            }
            phMenu.Text = menuContent;
        }

        protected void RefreshButton_Click(object sender, EventArgs e)
        {
            Cache.Remove(_CacheKey);
            BindMenu();
        }

        private string GenerateMenu(int parentCategoryId, int level)
        {
            StringBuilder sb = new StringBuilder();
            bool menuOpened = false;
            IList<Category> categories = CategoryDataSource.LoadForParent(parentCategoryId, true);
            foreach (Category category in categories)
            {
                string title = category.Name;
                string url = category.NavigateUrl;
                string target = string.Empty;
                if (!menuOpened)
                {
                    if (level == 1)
                    {
                        sb.Append("<ul id=\"menu\">");
                    }
                    else
                    {
                        sb.Append("<ul>");
                    }
                    menuOpened = true;
                }
                sb.Append("<li>");
                if (!string.IsNullOrEmpty(url)) url = Page.ResolveUrl(url);
                else url = "#";
                sb.Append("<a href=\"" + url + "\"");
                if (!string.IsNullOrEmpty(target))
                {
                    sb.Append("target=\"" + target + "\"");
                }
                sb.Append(">");
                sb.Append(title);
                sb.Append("</a>");
                sb.Append(GenerateMenu(category.Id, level + 1));
            }
            if (menuOpened) sb.Append("</ul>");
            return sb.ToString();
        }
    }
}