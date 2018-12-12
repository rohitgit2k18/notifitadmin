using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace AbleCommerce.Admin
{
    public partial class Menu : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string path = Request.QueryString["path"];
                if (!string.IsNullOrEmpty(path))
                {
                    path = Server.UrlDecode(path).ToLowerInvariant();
                    BindMenu(path);
                }
            }
        }

        private void BindMenu(string path)
        {
            XmlDocument menuDoc = new XmlDocument();
            menuDoc.Load(Server.MapPath("~/App_Data/adminmenu.xml"));
            string[] parentPaths = path.Split('/');
            string xpath = string.Empty;
            foreach (string parentPath in parentPaths)
            {
                xpath += GetMenuItemXPath(parentPath) + "/";
            }
            xpath = xpath + "*";
            string parentXPath = xpath.Substring(0, xpath.Length - 2);

            // bind the caption
            string parentTitle = string.Empty;
            XmlNode parentNode = menuDoc.DocumentElement.SelectSingleNode(parentXPath);
            if (parentNode != null && parentNode.Attributes["title"] != null)
            {
                parentTitle = parentNode.Attributes["title"].Value;
            }
            Caption.Text = string.Format(Caption.Text, parentTitle);

            XmlNodeList nodes = menuDoc.DocumentElement.SelectNodes(xpath);
            List<AdminMenuItem> menuItems = new List<AdminMenuItem>();
            foreach (XmlNode node in nodes)
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

                    // IF USER IS NOT ALLOWED TO SEE THIS URL SKIP THIS NODE AND CONTINUE WITH NEXT
                    if(!allowed)
                        continue;
                }

                string title = string.Empty;
                string description = string.Empty;
                string url = string.Empty;
                
                if(node.Attributes["title"] != null )
                    title = node.Attributes["title"].Value;

                if(node.Attributes["description"] != null )
                    description = node.Attributes["description"].Value;

                if(node.Attributes["url"] != null )
                    url = node.Attributes["url"].Value;

                menuItems.Add(new AdminMenuItem() { Title = title, Description = description, Url = Page.ResolveUrl(url) });
            }
            
            MenuItemRepeater.DataSource = menuItems;
            MenuItemRepeater.DataBind();
        }

        private string GetMenuItemXPath(string title) 
        {
            return string.Format("menuItem[translate(@title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')='{0}']", title);
        }

        protected string GetDescription(object dataItem)
        {
            AdminMenuItem item = (AdminMenuItem)dataItem;
            return HttpUtility.HtmlEncode(item.Description);
        }
    }

    public class AdminMenuItem 
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Url { get; set; }
    }
}