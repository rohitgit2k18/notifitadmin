using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Caching;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using CommerceBuilder.Common;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.ConLib
{
    public partial class AdminMenu : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // get current user roles
            List<string> roleList = new List<string>();
            User user = AbleContext.Current.User;
            foreach (UserGroup userGroup in user.UserGroups)
            {
                foreach (Role role in userGroup.Group.Roles)
                {
                    roleList.Add(role.LoweredName);
                }
            }

            string cacheKey = "AdminMenu_" + string.Join("_", roleList.ToArray());
            string menuContent = (string)Cache[cacheKey];
            if (string.IsNullOrEmpty(menuContent))
            {
                // load xml menu
                XmlDocument menuMap = new XmlDocument();
                string menuMapFile = Server.MapPath("~/App_Data/adminmenu.xml");
                menuMap.Load(menuMapFile);
                menuContent = GenerateMenu(menuMap.DocumentElement, roleList, 1);
                Cache.Add(cacheKey, menuContent, new CacheDependency(menuMapFile), Cache.NoAbsoluteExpiration, Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
            }
            Menu.Text = menuContent;
        }

        private string GenerateMenu(XmlNode rootNode, List<string> userRoleList, int level)
        {
            StringBuilder sb = new StringBuilder();
            bool menuOpened = false;
            XmlNodeList nodeList = rootNode.SelectNodes("menuItem");
            foreach (XmlNode node in nodeList)
            {
                string allowedRoleList = XmlUtility.GetAttributeValue(node, "roles", string.Empty);
                if (UserHasValidRole(userRoleList, allowedRoleList))
                {
                    string title = XmlUtility.GetAttributeValue(node, "title", string.Empty);
                    string url = XmlUtility.GetAttributeValue(node, "url", string.Empty);
                    string target = XmlUtility.GetAttributeValue(node, "target", string.Empty);
                    if (!menuOpened)
                    {
                        if (level == 1)
                        {
                            sb.Append("<ul class=\"sf-menu\" id=\"adminMenu\">");
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
                        sb.Append(" target=\"" + target + "\"");
                    }
                    sb.Append(">");
                    sb.Append(title);
                    sb.Append("</a>");
                    sb.Append(GenerateMenu(node, userRoleList, level + 1));
                    sb.Append("</li>");
                }
            }
            if (menuOpened) sb.Append("</ul>");
            return sb.ToString();
        }

        private bool UserHasValidRole(List<string> userRoleList, string allowedRoleList)
        {
            if (string.IsNullOrEmpty(allowedRoleList)) return true;
            string[] allowedRoles = allowedRoleList.ToLowerInvariant().Split(',');
            foreach (string role in allowedRoles)
            {
                if (userRoleList.Contains(role)) return true;
            }
            return false;
        }
    }
}