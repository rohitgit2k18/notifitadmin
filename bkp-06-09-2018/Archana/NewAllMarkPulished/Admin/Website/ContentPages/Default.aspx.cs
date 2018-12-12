using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.Stores;
using CommerceBuilder.UI;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Website.ContentPages
{
    public partial class _Default : AbleCommerceAdminPage
    {
        Dictionary<string, string> _DisplayPages;
        StoreSettingsManager _Settings;
        private string _IconPath = string.Empty;

        protected void Page_Init(object sender, EventArgs e)
        {
            AlphabetRepeater.DataSource = GetAlphabetDS();
            AlphabetRepeater.DataBind();

            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _Settings = AbleContext.Current.Store.Settings;
            _DisplayPages = new Dictionary<string, string>();
            IList<DisplayPage> displayPages = DisplayPageDataSource.Load("~/Layouts/Webpages");
            foreach (DisplayPage displayPage in displayPages)
            {
                if (displayPage.NodeType == CatalogNodeType.Webpage)
                {
                    string displayName = string.Format("{0}", displayPage.Name);
                    _DisplayPages[displayPage.DisplayPageFile] = displayName;
                }
            }
            displayPages = DisplayPageDataSource.Load();
            foreach (DisplayPage displayPage in displayPages)
            {
                if (displayPage.NodeType == CatalogNodeType.Webpage)
                {
                    string displayName = string.Format("{0} (webparts)", displayPage.Name);
                    _DisplayPages[displayPage.DisplayPageFile] = displayName;
                }
            }
        }

        protected void NewPageButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddContentPage.aspx");
        }

        protected string GetVisibilityIconUrl(object dataItem)
        {
            return _IconPath + "Cms" + (((Webpage)dataItem).Visibility) + ".gif";
        }

        protected void WebpagesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int webPageId = AlwaysConvert.ToInt(e.CommandArgument);
            Webpage webpage = WebpageDataSource.Load(webPageId);

            if (e.CommandName.ToLower() == "dodelete")
            {
                WebpageDataSource.Delete(webPageId);
                WebpagesGrid.DataBind();
            }

            else if (e.CommandName.ToLower() == "docopy")
            {
                Webpage page = Webpage.Copy(webPageId);
                page.Name = string.Format("Copy of {0}", page.Name);
                page.Save();
                WebpagesGrid.DataBind();
            }

            else if (e.CommandName.ToLower() == "do_pub")
            {
                switch (webpage.Visibility)
                {
                    case CatalogVisibility.Public:
                        webpage.Visibility = CatalogVisibility.Hidden;
                        break;
                    case CatalogVisibility.Hidden:
                        webpage.Visibility = CatalogVisibility.Private;
                        break;
                    default:
                        webpage.Visibility = CatalogVisibility.Public;
                        break;
                }
                webpage.Save();

                WebpagesGrid.DataBind();
            }

        }

        protected string GetLayout(object dataItem)
        {
            Webpage webpage = (Webpage)dataItem;
            if (webpage.Layout != null)
                return webpage.Layout.DisplayName;
            return "default";
        }

        protected string GetTheme(object dataItem)
        {
            Webpage webpage = (Webpage)dataItem;
            return webpage.Theme;
        }

        protected string GetCategories(Object dataItem) 
        {
            Webpage webpage = (Webpage)dataItem;
            List<string> categoryPaths = new List<string>();
            foreach (int categoryId in webpage.Categories)
            {
                IList<CatalogPathNode> pathNodes = CatalogDataSource.GetPath(categoryId,false);
                List<string> pathNodeNames = new List<string>();
                foreach(CatalogPathNode pathNode in pathNodes)
                {
                    pathNodeNames.Add(pathNode.Name);
                }
                categoryPaths.Add(string.Format("<a href='{0}'>{1}</a>", Page.ResolveUrl("~/Admin/Catalog/EditCategory.aspx?CategoryId="+categoryId), String.Join(" > ", pathNodeNames.ToArray())));
            }
            return String.Join(", ", categoryPaths.ToArray());
        }

        protected void AlphabetRepeater_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if ((e.CommandArgument.ToString().Length == 1))
            {
                WebpagesDs.SelectParameters["searchPhrase"].DefaultValue = (e.CommandArgument.ToString() + "*");
            }
            else
            {
                WebpagesDs.SelectParameters["searchPhrase"].DefaultValue = String.Empty;
            }
            WebpagesGrid.DataBind();
        }

        protected string[] GetAlphabetDS()
        {
            string[] alphabet = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "All" };
            return alphabet;
        }
    }
}
