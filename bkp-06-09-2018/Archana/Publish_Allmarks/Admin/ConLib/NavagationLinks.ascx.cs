using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Xml;

namespace AbleCommerce.Admin.ConLib
{
    public partial class NavagationLinks : System.Web.UI.UserControl
    {
        /// <summary>
        /// Path of the menuitem in ~/App_Data/adminmenu.xml
        /// </summary>
        public string Path { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.Path)) BindMenu();
        }

        private void BindMenu()
        {
            if (string.IsNullOrEmpty(this.Path)) return;

            XmlDocument menuDoc = new XmlDocument();
            menuDoc.Load(Server.MapPath("~/App_Data/adminmenu.xml"));
            string[] parentPaths = Path.Split('/');            
            string xpath = string.Empty;
            foreach (string parentPath in parentPaths)
                xpath += GetMenuItemXPath(parentPath) + "/";
            string parentXPath = xpath.Substring(0, xpath.Length - 1);
            xpath = xpath + "*";
            
            List<AdminMenuItem> menuItems = new List<AdminMenuItem>();

            // PARENT NODE
            XmlNode parentNode = menuDoc.DocumentElement.SelectSingleNode(parentXPath);
            if (parentNode != null && CheckPermissions(parentNode))
            {
                //  CURRENT PAGE URL
                string currentPageUrl = Request.AppRelativeCurrentExecutionFilePath.ToLowerInvariant();

                // ADD SUB ITEMS
                XmlNodeList nodes = menuDoc.DocumentElement.SelectNodes(xpath);
                foreach (XmlNode node in nodes)
                {
                    // IF USER IS NOT ALLOWED TO SEE THIS URL SKIP THIS NODE AND CONTINUE WITH NEXT
                    if (!CheckPermissions(node)) continue;

                    string title = string.Empty;
                    string description = string.Empty;
                    string url = string.Empty;

                    // USE THE navtitle ATTRIBUTE AS DEFAULT VALUE, iF NOT PRESENT USE title ATTRIBUTE
                    if (node.Attributes["navtitle"] != null)
                        title = node.Attributes["navtitle"].Value;
                    else if (node.Attributes["title"] != null)
                        title = node.Attributes["title"].Value;

                    if (node.Attributes["description"] != null)
                        description = node.Attributes["description"].Value;

                    if (node.Attributes["url"] != null)
                        url = node.Attributes["url"].Value;

                    // IDENTIFY CURRENT PAGE ITEM
                    bool isCurrentPageItem = url.ToLowerInvariant() == currentPageUrl;

                    menuItems.Add(new AdminMenuItem() { Title = title, Description = description, Url = Page.ResolveUrl(url), IsCurrentPageItem = isCurrentPageItem });
                }

                MenuItemRepeater.DataSource = menuItems;
                MenuItemRepeater.DataBind();
            }
            else MainPanel.Visible = false;
        }

        private bool CheckPermissions(XmlNode node)
        {
            if (node.Attributes["roles"] != null)
            {
                string[] roles = node.Attributes["roles"].Value.Split(',');
                bool allowed = false;
                foreach (string role in roles)
                {
                    // IF USER IS IN AN ALLOWED ROLE, THEN BREAK ADD THE MENU ITEM AND CONTINUE WITH NEXT
                    if (Page.User.IsInRole(role))
                    {
                        allowed = true;
                        break;
                    }
                }

                return allowed;
            }
            return true;
        }

        private string GetMenuItemXPath(string title)
        {
            return string.Format("menuItem[translate(@title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')='{0}']", title);
        }
    }

    public class AdminMenuItem
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Url { get; set; }
        public bool IsCurrentPageItem { get; set; }
    }
}