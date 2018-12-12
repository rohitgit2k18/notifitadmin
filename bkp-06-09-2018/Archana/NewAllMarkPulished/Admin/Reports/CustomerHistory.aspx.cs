using System;
using System.Collections.Generic;
using System.Net;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Reporting;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Reports
{
    public partial class CustomerHistory : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _UserId;
        private User user;

        protected void Page_PreInit(object sender, EventArgs e)
        {
            // READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = true;
        }

        protected void Page_SaveStateComplete(object sender, EventArgs e)
        {
            // END READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
            user = UserDataSource.Load(_UserId);
            if (user == null) Response.Redirect("~/Admin/");
            Caption.Text = string.Format(Caption.Text, (user.IsAnonymous ? "anonymous" : user.UserName));
        }

        protected void PageViewsGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            PageView pageView = (PageView)e.Row.DataItem;
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ICatalogable catalogNode = pageView.CatalogNode;
                if (catalogNode != null)
                {
                    PlaceHolder phCatalogNode = (PlaceHolder)e.Row.FindControl("phCatalogNode");
                    if (phCatalogNode != null)
                    {
                        HyperLink catalogLink = new HyperLink();
                        catalogLink.NavigateUrl = catalogNode.NavigateUrl;
                        catalogLink.EnableViewState = false;
                        Image catalogIcon = new Image();
                        catalogIcon.SkinID = pageView.CatalogNodeType.ToString() + "Icon";
                        catalogIcon.AlternateText = catalogNode.Name;
                        catalogIcon.EnableViewState = false;
                        catalogLink.Controls.Add(catalogIcon);
                        phCatalogNode.Controls.Add(catalogLink);
                    }
                }
            }
        }

        protected string GetUri(object dataItem)
        {
            PageView pageView = (PageView)dataItem;
            if (!string.IsNullOrEmpty(pageView.UriQuery))
                return pageView.UriStem + "<wbr>?" + pageView.UriQuery.Replace("&", "<wbr>&").Replace("%", "<wbr>%");
            else return pageView.UriStem;
        }
    }
}